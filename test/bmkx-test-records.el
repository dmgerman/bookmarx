;;; bmkx-test-records.el --- Bookmark record creation and identity   -*- lexical-binding: t -*-

;;; Code:

(require 'bmkx-test-helper)


(ert-deftest bmkx-test-records/set-stores-record ()
  "`bookmark-set' stores a record retrievable by `bmkx-get-bookmark'."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "hello world"
      (bmkx-test--make-bookmark "test-set" buf 7))
    (let ((rec (bmkx-get-bookmark "test-set" 'NOERROR)))
      (should rec)
      (should (equal (car rec) "test-set")))))

(ert-deftest bmkx-test-records/record-has-id ()
  "Every newly-created record carries an `id' property."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "hello"
      (bmkx-test--make-bookmark "with-id" buf))
    (let ((id (bookmark-prop-get "with-id" 'id)))
      (should (stringp id))
      (should (> (length id) 0)))))

(ert-deftest bmkx-test-records/ids-are-unique ()
  "Two distinct bookmarks have distinct ids."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "ab"
      (bmkx-test--make-bookmark "id-a" buf 1)
      (bmkx-test--make-bookmark "id-b" buf 2))
    (let ((id-a (bookmark-prop-get "id-a" 'id))
          (id-b (bookmark-prop-get "id-b" 'id)))
      (should id-a)
      (should id-b)
      (should-not (equal id-a id-b)))))

(ert-deftest bmkx-test-records/get-by-id-finds-record ()
  "`bmkx-get-by-id' returns the record matching an id."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "x"
      (bmkx-test--make-bookmark "by-id" buf))
    (let* ((id  (bookmark-prop-get "by-id" 'id))
           (rec (bmkx-get-by-id id)))
      (should rec)
      (should (equal (car rec) "by-id")))))

(ert-deftest bmkx-test-records/get-by-id-unknown-returns-nil ()
  "`bmkx-get-by-id' returns nil when the id does not exist."
  (bmkx-test-with-clean-bookmarks
    (should-not (bmkx-get-by-id "no-such-id-xxxxxxxx"))))

(ert-deftest bmkx-test-records/duplicate-name-auto-disambiguates ()
  "Re-creating a bookmark with no-overwrite yields a renamed sibling.

The contract: `bmkx-store NAME ... no-overwrite' creates a NEW
bookmark whose name is auto-renamed (e.g. `foo<2>') so both records
coexist."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "ab"
      (with-current-buffer buf
        (let ((bookmark-make-record-function #'bmkx-make-record-default))
          (goto-char 1)
          (bmkx-store "dup" (cdr (bookmark-make-record)) 'no-overwrite 'NO-REFRESH 'NO-MSG)
          (goto-char 2)
          (bmkx-store "dup" (cdr (bookmark-make-record)) 'no-overwrite 'NO-REFRESH 'NO-MSG))))
    (should (= 2 (length bookmark-alist)))
    (let ((names (mapcar #'car bookmark-alist)))
      (should (member "dup" names))
      (should (cl-some (lambda (n) (string-match-p "dup<[0-9]+>" n)) names)))))

(ert-deftest bmkx-test-records/delete-removes-record ()
  "`bookmark-delete' removes the record from `bookmark-alist'."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "x"
      (bmkx-test--make-bookmark "del-me" buf))
    (should (bmkx-get-bookmark "del-me" 'NOERROR))
    (bookmark-delete "del-me")
    (should-not (bmkx-get-bookmark "del-me" 'NOERROR))))

(ert-deftest bmkx-test-records/rename-preserves-id ()
  "Renaming a bookmark preserves its `id'."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "x"
      (bmkx-test--make-bookmark "before" buf))
    (let ((id-before (bookmark-prop-get "before" 'id)))
      (bookmark-rename "before" "after")
      (let ((id-after (bookmark-prop-get "after" 'id)))
        (should (equal id-before id-after))))))

(provide 'bmkx-test-records)
;;; bmkx-test-records.el ends here
