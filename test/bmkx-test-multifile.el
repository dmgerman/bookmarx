;;; bmkx-test-multifile.el --- Multiple bookmark files   -*- lexical-binding: t -*-

;;; Code:

(require 'bmkx-test-helper)


(ert-deftest bmkx-test-multifile/switch-replaces-alist ()
  "Switching to another bookmark file replaces `bookmark-alist'."
  (bmkx-test-with-clean-bookmarks
    (let ((file-a bookmark-default-file)
          (file-b (bmkx-test--make-temp-bookmark-file)))
      ;; Populate file A.
      (bmkx-test-with-fixture-buffer buf "x"
        (bmkx-test--make-bookmark "in-a" buf))
      (bookmark-write-file file-a)
      ;; Populate file B (fresh alist), write.
      (let ((bookmark-alist nil))
        (bmkx-test-with-fixture-buffer buf "x"
          (bmkx-test--make-bookmark "in-b" buf))
        (bookmark-write-file file-b))
      ;; Load A: confirm we have "in-a", not "in-b".
      (setq bookmark-alist nil)
      (let ((bookmarks-already-loaded nil))
        (bmkx-load file-a 'OVERWRITE 'NO-MSG))
      (should (bmkx-get-bookmark "in-a" 'NOERROR))
      (should-not (bmkx-get-bookmark "in-b" 'NOERROR)))))

(ert-deftest bmkx-test-multifile/load-accumulates ()
  "Loading a second bookmark file without OVERWRITE accumulates records."
  (bmkx-test-with-clean-bookmarks
    (let ((file-a bookmark-default-file)
          (file-b (bmkx-test--make-temp-bookmark-file)))
      (bmkx-test-with-fixture-buffer buf "x"
        (bmkx-test--make-bookmark "from-a" buf))
      (bookmark-write-file file-a)
      (let ((bookmark-alist nil))
        (bmkx-test-with-fixture-buffer buf "x"
          (bmkx-test--make-bookmark "from-b" buf))
        (bookmark-write-file file-b))
      (setq bookmark-alist nil)
      (let ((bookmarks-already-loaded nil))
        (bmkx-load file-a 'OVERWRITE 'NO-MSG)
        (bmkx-load file-b nil       'NO-MSG))
      (should (bmkx-get-bookmark "from-a" 'NOERROR))
      (should (bmkx-get-bookmark "from-b" 'NOERROR)))))

(ert-deftest bmkx-test-multifile/empty-file-bookmark-write ()
  "Writing the current alist to a new file produces a loadable file."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "x"
      (bmkx-test--make-bookmark "writer" buf))
    (let ((other (bmkx-test--make-temp-bookmark-file)))
      (bookmark-write-file other)
      (should (file-exists-p other))
      (let ((bookmark-alist nil)
            (bookmarks-already-loaded nil))
        (bmkx-load other 'OVERWRITE 'NO-MSG)
        (should (bmkx-get-bookmark "writer" 'NOERROR))))))


(provide 'bmkx-test-multifile)
;;; bmkx-test-multifile.el ends here
