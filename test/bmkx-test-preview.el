;;; bmkx-test-preview.el --- bmkx-list-preview-mode   -*- lexical-binding: t -*-

;;; Code:

(require 'bmkx-test-helper)
(require 'cl-lib)


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


;;; bmkx-bookmark-location-function (annotation substitution for non-file bookmarks)

(defun bmkx-test--make-url-bookmark (name url)
  "Register a URL bookmark NAME pointing at URL.  No buffer required."
  (let ((bmk  (list (cons 'filename bmkx-non-file-filename)
                    (cons 'location url)
                    (cons 'handler  #'bmkx-jump-url-browse)
                    (cons 'position 0))))
    (bookmark-store name bmk nil)
    (bmkx-get-bookmark name 'NOERROR)))

(ert-deftest bmkx-test-preview/location-default-returns-url-for-url-bookmark ()
  "`bmkx-bookmark-location-default' returns the URL of a URL bookmark."
  (bmkx-test-with-clean-bookmarks
    (let ((rec  (bmkx-test--make-url-bookmark "url-bmk" "https://example.com/")))
      (should (equal "https://example.com/"
                     (bmkx-bookmark-location-default rec))))))

(ert-deftest bmkx-test-preview/location-default-nil-for-file-bookmark ()
  "`bmkx-bookmark-location-default' returns nil for a plain file bookmark."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "x"
      (bmkx-test--make-bookmark "file-bmk" buf))
    (should-not (bmkx-bookmark-location-default (assoc "file-bmk" bookmark-alist)))))

(ert-deftest bmkx-test-preview/annotation-substitutes-url-for-no-file-marker ()
  "`bmkx-bookmark-annotation' replaces the no-file marker with the URL.
Stubs marginalia so the test does not require the package."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test--make-url-bookmark "url-annot" "https://example.org/path")
    (cl-letf (((symbol-function 'marginalia-annotate-bookmark)
               (lambda (_n) (concat "TYPE" bmkx-non-file-filename "EXTRA"))))
      (let ((annot  (bmkx-bookmark-annotation "url-annot")))
        (should (stringp annot))
        (should (string-match-p "https://example.org/path" annot))
        (should-not (string-match-p (regexp-quote bmkx-non-file-filename) annot))))))

(ert-deftest bmkx-test-preview/annotation-honors-user-override ()
  "A user-supplied `bmkx-bookmark-location-function' takes effect."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test--make-url-bookmark "url-override" "https://example.net/")
    (cl-letf (((symbol-function 'marginalia-annotate-bookmark)
               (lambda (_n) (concat "T" bmkx-non-file-filename "Z")))
              (bmkx-bookmark-location-function
               (lambda (_bmk) "<<custom>>")))
      (let ((annot  (bmkx-bookmark-annotation "url-override")))
        (should (string-match-p "<<custom>>" annot))
        (should-not (string-match-p "https://example.net/" annot))))))

(ert-deftest bmkx-test-preview/annotation-leaves-file-bookmark-alone ()
  "Annotation for a file bookmark does not invoke the substitution."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "x"
      (bmkx-test--make-bookmark "file-annot" buf))
    (cl-letf (((symbol-function 'marginalia-annotate-bookmark)
               (lambda (_n) "TYPE  /tmp/some/file  ")))
      (let ((annot  (bmkx-bookmark-annotation "file-annot")))
        (should (stringp annot))
        (should (string-match-p "/tmp/some/file" annot))))))


(provide 'bmkx-test-preview)
;;; bmkx-test-preview.el ends here
