;;; bmkx-test-tags-column.el --- Tags column in *Bmkx List*   -*- lexical-binding: t -*-
;;
;; Pure-function tests for the tags-column formatter and the
;; name-truncator.

;;; Code:

(require 'bmkx-test-helper)


;;; bmkx-bmenu--format-tags-for-column
;; --------------------------------------------------------------------

(ert-deftest bmkx-test-tags-column/no-tags-is-all-spaces ()
  "An empty tag list yields exactly WIDTH spaces."
  (should (equal (make-string 12 ?\s)
                 (bmkx-bmenu--format-tags-for-column () 12))))

(ert-deftest bmkx-test-tags-column/short-tags-padded ()
  "Tags shorter than WIDTH are right-padded with spaces."
  (should (equal "foo         "
                 (bmkx-bmenu--format-tags-for-column '("foo") 12)))
  (should (equal "foo,bar     "
                 (bmkx-bmenu--format-tags-for-column '("foo" "bar") 12))))

(ert-deftest bmkx-test-tags-column/exact-fit-no-padding ()
  "Tags whose joined string is exactly WIDTH chars are returned as-is."
  (should (equal "abcdefghijkl"
                 (bmkx-bmenu--format-tags-for-column '("abcdefghijkl") 12))))

(ert-deftest bmkx-test-tags-column/overflow-gets-ellipsis ()
  "Joined tags exceeding WIDTH are truncated to WIDTH-1 + `…'."
  (should (equal "abcdefghijk…"
                 (bmkx-bmenu--format-tags-for-column '("abcdefghijkmno") 12)))
  (should (equal "alpha,beta,…"
                 (bmkx-bmenu--format-tags-for-column '("alpha" "beta" "gamma") 12))))

(ert-deftest bmkx-test-tags-column/cons-tags-use-car ()
  "Tag values stored as (NAME . VALUE) cons cells render NAME only."
  (should (equal "color,size  "
                 (bmkx-bmenu--format-tags-for-column
                  '(("color" . "red") ("size" . "M")) 12))))

(ert-deftest bmkx-test-tags-column/width-1-edge ()
  "Width 1 with overflow returns the ellipsis alone."
  (should (equal "…" (bmkx-bmenu--format-tags-for-column '("anything") 1))))

(ert-deftest bmkx-test-tags-column/width-0-returns-empty ()
  "Width 0 returns the empty string regardless of tags."
  (should (equal "" (bmkx-bmenu--format-tags-for-column '("foo") 0)))
  (should (equal "" (bmkx-bmenu--format-tags-for-column ()       0))))


;;; bmkx-bmenu--truncate-name
;; --------------------------------------------------------------------

(ert-deftest bmkx-test-tags-column/truncate-nil-is-passthrough ()
  "A nil WIDTH leaves NAME untouched even when very long."
  (let ((long (make-string 200 ?x)))
    (should (equal long (bmkx-bmenu--truncate-name long nil)))))

(ert-deftest bmkx-test-tags-column/truncate-shorter-passes-through ()
  (should (equal "abc" (bmkx-bmenu--truncate-name "abc" 10))))

(ert-deftest bmkx-test-tags-column/truncate-exact-passes-through ()
  (should (equal "abcdefghij" (bmkx-bmenu--truncate-name "abcdefghij" 10))))

(ert-deftest bmkx-test-tags-column/truncate-longer-gets-ellipsis ()
  (should (equal "abcdefghi…" (bmkx-bmenu--truncate-name "abcdefghijklm" 10))))

(ert-deftest bmkx-test-tags-column/truncate-width-1-edge ()
  (should (equal "a" (bmkx-bmenu--truncate-name "abcdef" 1))))


(provide 'bmkx-test-tags-column)
;;; bmkx-test-tags-column.el ends here
