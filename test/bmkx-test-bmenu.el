;;; bmkx-test-bmenu.el --- *Bmkx List* buffer   -*- lexical-binding: t -*-

;;; Code:

(require 'bmkx-test-helper)


(defmacro bmkx-test-with-bmenu (&rest body)
  "Open `*Bmkx List*' and run BODY with point in that buffer.
Cleans up the buffer at exit."
  (declare (indent 0) (debug t))
  `(unwind-protect
       (progn (bmkx-list)
              (with-current-buffer bmkx-bmenu-buffer ,@body))
     (when (get-buffer bmkx-bmenu-buffer)
       (kill-buffer bmkx-bmenu-buffer))))


(ert-deftest bmkx-test-bmenu/list-creates-buffer ()
  "`bmkx-list' creates the `*Bmkx List*' buffer."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "x"
      (bmkx-test--make-bookmark "show" buf))
    (bmkx-test-with-bmenu
      (should (get-buffer bmkx-bmenu-buffer))
      (should (eq major-mode 'bmkx-list-mode)))))

(ert-deftest bmkx-test-bmenu/shows-bookmark-names ()
  "The buffer renders each bookmark on its own line."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "x"
      (bmkx-test--make-bookmark "one" buf)
      (bmkx-test--make-bookmark "two" buf)
      (bmkx-test--make-bookmark "three" buf))
    (bmkx-test-with-bmenu
      (let ((text (buffer-substring-no-properties (point-min) (point-max))))
        (should (string-match-p "\\bone\\b"   text))
        (should (string-match-p "\\btwo\\b"   text))
        (should (string-match-p "\\bthree\\b" text))))))

(ert-deftest bmkx-test-bmenu/refresh-still-renders ()
  "`bmkx-bmenu-refresh-menu-list' rebuilds the display without error."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "x"
      (bmkx-test--make-bookmark "r1" buf))
    (bmkx-test-with-bmenu
      (bmkx-bmenu-refresh-menu-list)
      (let ((text (buffer-substring-no-properties (point-min) (point-max))))
        (should (string-match-p "r1" text))))))

(ert-deftest bmkx-test-bmenu/mark-and-unmark ()
  "Marking with `>' updates `bmkx-bmenu-marked-bookmarks'."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "x"
      (bmkx-test--make-bookmark "mk" buf))
    (bmkx-test-with-bmenu
      (goto-char (point-min))
      (re-search-forward "mk" nil t)
      (beginning-of-line)
      (bmkx-list-mark)
      (should (member "mk" bmkx-bmenu-marked-bookmarks))
      ;; Now unmark.
      (goto-char (point-min))
      (re-search-forward "mk" nil t)
      (beginning-of-line)
      (bmkx-list-unmark)
      (should-not (member "mk" bmkx-bmenu-marked-bookmarks)))))

(ert-deftest bmkx-test-bmenu/list-bookmark-returns-current-name ()
  "`bmkx-list-bookmark' returns the bookmark name at point."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "x"
      (bmkx-test--make-bookmark "current-line" buf))
    (bmkx-test-with-bmenu
      (goto-char (point-min))
      (re-search-forward "current-line" nil t)
      (should (equal "current-line" (bmkx-list-bookmark))))))


(provide 'bmkx-test-bmenu)
;;; bmkx-test-bmenu.el ends here
