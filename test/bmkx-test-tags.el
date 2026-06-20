;;; bmkx-test-tags.el --- Tag operations   -*- lexical-binding: t -*-

;;; Code:

(require 'bmkx-test-helper)


(defun bmkx-test--tag-names (bmk)
  "Return tag names (strings) for BMK, ignoring values."
  (mapcar (lambda (tt) (if (consp tt) (car tt) tt))
          (bmkx-get-tags bmk)))


(ert-deftest bmkx-test-tags/add-and-list ()
  "Tags added with `bmkx-add-tags' appear in `bmkx-get-tags'."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "x"
      (bmkx-test--make-bookmark "tag-add" buf))
    (bmkx-add-tags "tag-add" '("a" "b" "c") 'NO-UPDATE-P 'NO-MSG-P)
    (let ((tags (bmkx-test--tag-names "tag-add")))
      (should (member "a" tags))
      (should (member "b" tags))
      (should (member "c" tags))
      (should (= 3 (length tags))))))

(ert-deftest bmkx-test-tags/remove ()
  "`bmkx-remove-tags' removes a tag from a bookmark."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "x"
      (bmkx-test--make-bookmark "tag-rm" buf))
    (bmkx-add-tags "tag-rm" '("a" "b") 'NO-UPDATE-P 'NO-MSG-P)
    (bmkx-remove-tags "tag-rm" '("a") 'NO-UPDATE-P 'NO-MSG-P)
    (let ((tags (bmkx-test--tag-names "tag-rm")))
      (should-not (member "a" tags))
      (should     (member "b" tags)))))

(ert-deftest bmkx-test-tags/add-twice-is-idempotent ()
  "Adding the same tag twice does not duplicate it."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "x"
      (bmkx-test--make-bookmark "idemp" buf))
    (bmkx-add-tags "idemp" '("foo") 'NO-UPDATE-P 'NO-MSG-P)
    (bmkx-add-tags "idemp" '("foo") 'NO-UPDATE-P 'NO-MSG-P)
    (should (= 1 (length (bmkx-get-tags "idemp"))))))

(ert-deftest bmkx-test-tags/tag-with-value ()
  "A tag stored as (NAME . VALUE) carries its value."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "x"
      (bmkx-test--make-bookmark "valued" buf))
    (bmkx-add-tags "valued" (list (cons "color" "blue")) 'NO-UPDATE-P 'NO-MSG-P)
    (should (equal "blue" (bmkx-get-tag-value "valued" "color")))))

(ert-deftest bmkx-test-tags/list-all-tags ()
  "`bmkx-tags-list' aggregates tags across bookmarks."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "abcdef"
      (bmkx-test--make-bookmark "all-a" buf 1)
      (bmkx-test--make-bookmark "all-b" buf 5))
    (should (= 2 (length bookmark-alist)))
    (bmkx-add-tags "all-a" '("alpha" "shared") 'NO-UPDATE-P 'NO-MSG-P)
    (bmkx-add-tags "all-b" '("beta"  "shared") 'NO-UPDATE-P 'NO-MSG-P)
    (let ((all (mapcar #'car (bmkx-tags-list))))
      (should (member "alpha"  all))
      (should (member "beta"   all))
      (should (member "shared" all)))))

(ert-deftest bmkx-test-tags/rename ()
  "`bmkx-rename-tag' renames the tag in every bookmark that has it."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "abcdef"
      (bmkx-test--make-bookmark "rn-a" buf 1)
      (bmkx-test--make-bookmark "rn-b" buf 5))
    (bmkx-add-tags "rn-a" '("old") 'NO-UPDATE-P 'NO-MSG-P)
    (bmkx-add-tags "rn-b" '("old") 'NO-UPDATE-P 'NO-MSG-P)
    (bmkx-rename-tag "old" "new")
    (should (member "new" (bmkx-test--tag-names "rn-a")))
    (should (member "new" (bmkx-test--tag-names "rn-b")))
    (should-not (member "old" (bmkx-test--tag-names "rn-a")))
    (should-not (member "old" (bmkx-test--tag-names "rn-b")))))


(provide 'bmkx-test-tags)
;;; bmkx-test-tags.el ends here
