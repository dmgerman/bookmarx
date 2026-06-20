;;; bmkx-test-filename-style.el --- Bmenu filename rendering   -*- lexical-binding: t -*-
;;
;; Pure-function tests for `bmkx-bmenu-format-filename' and the
;; `bmkx-bmenu--shrink-path' helper.  No bookmark state, no bmenu
;; buffer is exercised here -- those are integration-shaped and live
;; elsewhere if/when needed.

;;; Code:

(require 'bmkx-test-helper)

;; All shrink/abbreviate tests assume a known HOME so the result is
;; reproducible regardless of who runs the suite.  We pick a path that
;; is highly unlikely to collide with a real ancestor of the test
;; fixtures.
(defconst bmkx-test-filename-style--home "/Users/test-user")

(defmacro bmkx-test-filename-style--with-home (&rest body)
  "Run BODY with HOME pinned to a stable value and the directory-abbrev
alist refreshed so `abbreviate-file-name' respects the override."
  (declare (indent 0) (debug t))
  `(let ((process-environment        (cons (concat "HOME=" bmkx-test-filename-style--home)
                                           process-environment))
         (directory-abbrev-alist     nil)
         (abbreviated-home-dir       nil))
     ,@body))


;;; bmkx-bmenu--shrink-path
;; --------------------------------------------------------------------

(ert-deftest bmkx-test-filename-style/shrink-home-relative ()
  "A path under HOME shrinks to ~/<first-char>/... while keeping the basename."
  (bmkx-test-filename-style--with-home
    (should (equal "~/.e/m/b/bookmark-x-1.el"
                   (bmkx-bmenu--shrink-path
                    (concat bmkx-test-filename-style--home
                            "/.emacs.d/modules/bookmark-x/bookmark-x-1.el"))))))

(ert-deftest bmkx-test-filename-style/shrink-absolute-non-home ()
  "An absolute path outside HOME shrinks each parent to one char."
  (bmkx-test-filename-style--with-home
    (should (equal "/e/i/cron"
                   (bmkx-bmenu--shrink-path "/etc/init.d/cron")))))

(ert-deftest bmkx-test-filename-style/shrink-root-only ()
  "A bare top-level file `/foo' has no parents to shrink."
  (bmkx-test-filename-style--with-home
    (should (equal "/root"
                   (bmkx-bmenu--shrink-path "/root")))))

(ert-deftest bmkx-test-filename-style/shrink-dot-directory-keeps-two-chars ()
  "A leading-dot directory like `.emacs.d' collapses to `.e', not `.'."
  (bmkx-test-filename-style--with-home
    (let ((shrunk (bmkx-bmenu--shrink-path
                   (concat bmkx-test-filename-style--home "/.emacs.d/init.el"))))
      (should (equal "~/.e/init.el" shrunk)))))

(ert-deftest bmkx-test-filename-style/shrink-preserves-basename-unshrunk ()
  "Even with a long basename, the basename is never shrunk."
  (bmkx-test-filename-style--with-home
    (let ((shrunk (bmkx-bmenu--shrink-path
                   "/very/deeply/nested/directories/Some-Long-File-Name.txt")))
      (should (equal "/v/d/n/d/Some-Long-File-Name.txt" shrunk)))))


;;; bmkx-bmenu-format-filename dispatch
;; --------------------------------------------------------------------

(ert-deftest bmkx-test-filename-style/format-full-passes-through ()
  "Style `full' leaves the path verbatim."
  (let ((bmkx-bmenu-filename-style 'full))
    (should (equal "/Users/x/.emacs.d/init.el"
                   (bmkx-bmenu-format-filename "/Users/x/.emacs.d/init.el")))))

(ert-deftest bmkx-test-filename-style/format-abbreviate-home ()
  "Style `abbreviate' replaces HOME with `~'."
  (bmkx-test-filename-style--with-home
    (let ((bmkx-bmenu-filename-style 'abbreviate))
      (should (equal "~/.emacs.d/init.el"
                     (bmkx-bmenu-format-filename
                      (concat bmkx-test-filename-style--home "/.emacs.d/init.el")))))))

(ert-deftest bmkx-test-filename-style/format-shrink ()
  "Style `shrink' delegates to `bmkx-bmenu--shrink-path'."
  (bmkx-test-filename-style--with-home
    (let ((bmkx-bmenu-filename-style 'shrink))
      (should (equal "~/.e/m/b/bookmark-x-1.el"
                     (bmkx-bmenu-format-filename
                      (concat bmkx-test-filename-style--home
                              "/.emacs.d/modules/bookmark-x/bookmark-x-1.el")))))))

(ert-deftest bmkx-test-filename-style/format-basename ()
  "Style `basename' returns only the file's last component."
  (let ((bmkx-bmenu-filename-style 'basename))
    (should (equal "bookmark-x-1.el"
                   (bmkx-bmenu-format-filename
                    "/Users/x/.emacs.d/modules/bookmark-x/bookmark-x-1.el")))))

(ert-deftest bmkx-test-filename-style/format-non-path-passthrough ()
  "Buffer names and other non-path locations are not reformatted."
  (let ((bmkx-bmenu-filename-style 'shrink))
    (should (equal "*scratch*"            (bmkx-bmenu-format-filename "*scratch*")))
    (should (equal "-- Unknown location --"
                   (bmkx-bmenu-format-filename "-- Unknown location --")))
    (should (equal "some-buffer-name"     (bmkx-bmenu-format-filename "some-buffer-name")))))

(ert-deftest bmkx-test-filename-style/format-unknown-style-passes-through ()
  "An unrecognised style value is treated as `full' rather than erroring."
  (let ((bmkx-bmenu-filename-style 'bogus-style))
    (should (equal "/Users/x/init.el"
                   (bmkx-bmenu-format-filename "/Users/x/init.el")))))


;;; Cycle ordering
;; --------------------------------------------------------------------

(ert-deftest bmkx-test-filename-style/cycle-order-is-stable ()
  "`bmkx-bmenu-filename-style-order' contains exactly the supported values."
  (should (equal '(full abbreviate shrink basename)
                 bmkx-bmenu-filename-style-order)))

(ert-deftest bmkx-test-filename-style/cycle-wraps ()
  "Cycling from the last value wraps back to the first."
  (let ((bmkx-bmenu-filename-style 'basename))
    ;; Avoid calling the bmenu-refreshing path: invoke the pure cycle
    ;; pick directly the way the command does.
    (let* ((rest (cdr (memq bmkx-bmenu-filename-style bmkx-bmenu-filename-style-order)))
           (next (or (car rest) (car bmkx-bmenu-filename-style-order))))
      (should (eq 'full next)))))


(provide 'bmkx-test-filename-style)
;;; bmkx-test-filename-style.el ends here
