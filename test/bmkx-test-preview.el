;;; bmkx-test-preview.el --- bmkx-list-preview-mode   -*- lexical-binding: t -*-

;;; Code:

(require 'bmkx-test-helper)


(ert-deftest bmkx-test-preview/mode-defined ()
  "`bmkx-list-preview-mode' is defined."
  (should (fboundp 'bmkx-list-preview-mode)))

(ert-deftest bmkx-test-preview/mode-toggles ()
  "Toggling the mode sets and unsets the variable."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "x"
      (bmkx-test--make-bookmark "p1" buf))
    (unwind-protect
        (progn
          (bmkx-list)
          (with-current-buffer bmkx-bmenu-buffer
            (should-not bmkx-list-preview-mode)
            (bmkx-list-preview-mode 1)
            (should bmkx-list-preview-mode)
            (bmkx-list-preview-mode -1)
            (should-not bmkx-list-preview-mode)))
      (when (get-buffer bmkx-bmenu-buffer)
        (kill-buffer bmkx-bmenu-buffer)))))

(ert-deftest bmkx-test-preview/lighter-present-when-active ()
  "The mode-line lighter `\" Pv\"' appears when the mode is on."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "x"
      (bmkx-test--make-bookmark "p2" buf))
    (unwind-protect
        (progn
          (bmkx-list)
          (with-current-buffer bmkx-bmenu-buffer
            (bmkx-list-preview-mode 1)
            (let ((lighter (assq 'bmkx-list-preview-mode minor-mode-alist)))
              (should lighter)
              (should (string-match-p "Pv" (or (cadr lighter) ""))))))
      (when (get-buffer bmkx-bmenu-buffer)
        (kill-buffer bmkx-bmenu-buffer)))))

(ert-deftest bmkx-test-preview/consult-jump-reader-defined ()
  "`bmkx-read-bookmark-for-jump' is defined."
  (should (fboundp 'bmkx-read-bookmark-for-jump)))

(ert-deftest bmkx-test-preview/consult-flag-default ()
  "`bmkx-preview-use-consult-flag' is t by default."
  (should (boundp 'bmkx-preview-use-consult-flag))
  (should bmkx-preview-use-consult-flag))


(provide 'bmkx-test-preview)
;;; bmkx-test-preview.el ends here
