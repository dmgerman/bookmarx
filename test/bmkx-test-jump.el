;;; bmkx-test-jump.el --- Jump dispatch   -*- lexical-binding: t -*-

;;; Code:

(require 'bmkx-test-helper)


(ert-deftest bmkx-test-jump/file-bookmark-visits-file ()
  "Jumping to a file bookmark visits the file and lands at the recorded position."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "line one\nline two\nline three\n"
      (with-current-buffer buf
        (goto-char (point-min))
        (forward-line 1)
        (let ((bookmark-make-record-function #'bmkx-make-record-default))
          (bookmark-set "line2-bmk")))
      (kill-buffer buf))
    (bmkx-jump "line2-bmk")
    (should (string= "line one\nline two\nline three\n"
                     (buffer-substring-no-properties (point-min) (point-max))))
    (should (= (line-number-at-pos) 2))))

(ert-deftest bmkx-test-jump/region-bookmark-activates-region ()
  "Jumping to a region bookmark activates the region between start and end."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "the quick brown fox"
      (with-current-buffer buf
        (goto-char 5)                   ; "quick" start
        (set-mark 10)                   ; "quick" end
        (activate-mark)
        (let ((bookmark-make-record-function #'bmkx-make-record-default)
              (bmkx-use-region t))
          (bookmark-set "quick-region")))
      (kill-buffer buf))
    (let ((bmkx-use-region t))
      (bmkx-jump "quick-region"))
    (should mark-active)
    (should (or (= (mark) 5)  (= (point) 5)))
    (should (or (= (mark) 10) (= (point) 10)))))

(ert-deftest bmkx-test-jump/unknown-bookmark-signals ()
  "Jumping to a non-existent bookmark signals an error."
  (bmkx-test-with-clean-bookmarks
    (should-error (bmkx-jump "no-such-bookmark"))))

(ert-deftest bmkx-test-jump/bookmark-name-from-record ()
  "`bookmark-name-from-full-record' returns the bookmark's name."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "x"
      (bmkx-test--make-bookmark "h" buf))
    (let ((rec (assoc "h" bookmark-alist)))
      (should (equal "h" (bookmark-name-from-full-record rec))))))

(ert-deftest bmkx-test-jump/visit-increments-counter ()
  "Jumping to a bookmark increments its `visits' counter."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "x"
      (bmkx-test--make-bookmark "visit-counter" buf))
    (let ((before (or (bookmark-prop-get "visit-counter" 'visits) 0)))
      (bmkx-jump "visit-counter")
      (let ((after (bookmark-prop-get "visit-counter" 'visits)))
        (should after)
        (should (> after before))))))


;;; Custom-handler dispatch
;; --------------------------------------------------------------------
;;
;; Built-in `bookmark--jump-via' contract: a handler does `set-buffer'
;; on the destination and leaves display to the caller.  Built-in
;; `bookmark--jump-via' then calls DISPLAY-FUNCTION on the resulting
;; buffer.  Our `bmkx--jump-via' previously only consulted
;; `bmkx-jump-display-function' from inside the default handler, so
;; jumps to bookmarks with a custom handler (pdf-view, eww, gnus,
;; info, ...) created the destination buffer but never displayed it.

(defvar bmkx-test-jump--custom-called nil
  "Set to t by `bmkx-test-jump--custom-handler' when invoked.")

(defvar bmkx-test-jump--display-called-with nil
  "Buffer (or nil) passed to `bmkx-test-jump--mock-display'.")

(defun bmkx-test-jump--custom-handler (bmk)
  "Mimic `pdf-view-bookmark-jump-handler': set-buffer only, no display."
  (setq bmkx-test-jump--custom-called t)
  (let* ((file (bookmark-prop-get bmk 'filename))
         (buf  (or (find-buffer-visiting file)
                   (find-file-noselect file))))
    (set-buffer buf)))

(defun bmkx-test-jump--mock-display (buf)
  "Mock DISPLAY-FUNCTION: record the buffer it was called with."
  (setq bmkx-test-jump--display-called-with buf))

(ert-deftest bmkx-test-jump/display-called-when-dest-already-shown ()
  "DISPLAY-FUNCTION must run even when the destination is already shown.

This is a regression test for the consult-preview interaction: while
previewing, the destination buffer is left displayed in some window
when the user accepts the candidate.  An earlier dispatch shortcut in
`bmkx--jump-via' (\"if some window shows the destination, the handler
already displayed it; trust it\") then suppressed the DISPLAY-FUNCTION
call, leaving the originating window on the previous buffer.  We now
always call DISPLAY-FUNCTION (modulo the in-place clobber recovery
branch), so a leftover window from preview or any other source no
longer hijacks the dispatch."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer dest "destination contents"
      (let ((dest-file (buffer-file-name dest)))
        (push (list "preview-hijack"
                    (cons 'filename dest-file)
                    (cons 'position 1)
                    (cons 'handler  #'bmkx-test-jump--custom-handler)
                    (cons 'id       "test-id-preview-hijack"))
              bookmark-alist)
        ;; Simulate the preview leftover: DEST is already shown in
        ;; some live window before the read returns.  `get-buffer-window'
        ;; on DEST will return that window from inside `bmkx--jump-via',
        ;; which used to suppress the DISPLAY-FUNCTION call.
        (let ((preview-window  (display-buffer dest)))
          (should (window-live-p preview-window))
          (setq bmkx-test-jump--custom-called      nil
                bmkx-test-jump--display-called-with nil)
          (bmkx-jump "preview-hijack" #'bmkx-test-jump--mock-display)
          (should bmkx-test-jump--custom-called)
          (should (bufferp bmkx-test-jump--display-called-with))
          (should (eq dest bmkx-test-jump--display-called-with)))))))

(ert-deftest bmkx-test-jump/display-fn-let-binding-survives-reentry ()
  "Regression: `bmkx-jump-display-function' is `let'-bound so a re-entrant
`bmkx--jump-via' call cannot clobber the outer call's value.

The original implementation used `setq' on the global, so any path
that re-entered `bmkx--jump-via' (notably the autofile-on-find-file
hook, which calls `(bmkx--jump-via bmk 'ignore)') overwrote the
outer caller's display function with `'ignore'.  When the outer
handler resumed and consulted the global, it found `'ignore' and
the destination window never switched.  The fix is a `let'-binding
in `bmkx--jump-via', giving each invocation its own dynamic binding.

The test installs a custom handler on the outer bookmark that, mid-
jump, calls `bmkx--jump-via' on a second bookmark with `'ignore' as
the display function -- the same shape as the production re-entry --
then captures the value of `bmkx-jump-display-function' immediately
after the inner returns.  With the fix, the captured value is the
outer's tracker; without the fix, it would be `'ignore'."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer outer "outer destination contents"
      (bmkx-test-with-fixture-buffer inner "inner destination contents"
        (let* ((captured-after-inner  nil)
               (outer-buf             outer)
               (inner-buf             inner))
          (push (list "outer-bmk"
                      (cons 'filename (buffer-file-name outer-buf))
                      (cons 'position 1)
                      (cons 'handler
                            (lambda (_bmk)
                              (bmkx--jump-via (assoc "inner-bmk" bookmark-alist)
                                              'ignore)
                              (setq captured-after-inner bmkx-jump-display-function)
                              (set-buffer outer-buf)))
                      (cons 'id "test-id-outer-rb"))
                bookmark-alist)
          (push (list "inner-bmk"
                      (cons 'filename (buffer-file-name inner-buf))
                      (cons 'position 1)
                      (cons 'handler (lambda (_bmk) (set-buffer inner-buf)))
                      (cons 'id "test-id-inner-rb"))
                bookmark-alist)
          (bmkx-jump "outer-bmk" #'bmkx-test-jump--mock-display)
          (should (eq captured-after-inner #'bmkx-test-jump--mock-display)))))))

(ert-deftest bmkx-test-jump/custom-handler-receives-display-call ()
  "Jumping to a custom-handler bookmark must invoke DISPLAY-FUNCTION
on the destination buffer.

The built-in `bookmark--jump-via' contract: a custom handler does
`set-buffer' to make the destination current and leaves window display
to the caller.  `bmkx--jump-via' previously only consulted
`bmkx-jump-display-function' from inside the default handler, so jumps
to custom-handler bookmarks left DISPLAY-FUNCTION uncalled.

This is a contract test, not a windowing test: it checks that the
display function actually receives the destination, regardless of
whether batch mode does anything visible with it."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer dest "destination contents"
      (let ((dest-file (buffer-file-name dest)))
        (push (list "custom-h"
                    (cons 'filename dest-file)
                    (cons 'position 1)
                    (cons 'handler  #'bmkx-test-jump--custom-handler)
                    (cons 'id       "test-id-custom-h"))
              bookmark-alist)
        (setq bmkx-test-jump--custom-called      nil
              bmkx-test-jump--display-called-with nil)
        (bmkx-jump "custom-h" #'bmkx-test-jump--mock-display)
        (should bmkx-test-jump--custom-called)
        (should (bufferp bmkx-test-jump--display-called-with))
        (should (equal (file-name-nondirectory dest-file)
                       (buffer-name bmkx-test-jump--display-called-with)))))))


(provide 'bmkx-test-jump)
;;; bmkx-test-jump.el ends here
