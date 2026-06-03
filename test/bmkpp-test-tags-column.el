;;; bmkpp-test-tags-column.el --- Tags column in *Bmkp List*   -*- lexical-binding: t -*-
;;
;; Pure-function tests for the tags-column formatter and the
;; name-truncator.

;;; Code:

(require 'bmkpp-test-helper)


;;; bmkp-bmenu--format-tags-for-column
;; --------------------------------------------------------------------

(ert-deftest bmkpp-test-tags-column/no-tags-is-all-spaces ()
  "An empty tag list yields exactly WIDTH spaces."
  (should (equal (make-string 12 ?\s)
                 (bmkp-bmenu--format-tags-for-column () 12))))

(ert-deftest bmkpp-test-tags-column/short-tags-padded ()
  "Tags shorter than WIDTH are right-padded with spaces."
  (should (equal "foo         "
                 (bmkp-bmenu--format-tags-for-column '("foo") 12)))
  (should (equal "foo,bar     "
                 (bmkp-bmenu--format-tags-for-column '("foo" "bar") 12))))

(ert-deftest bmkpp-test-tags-column/exact-fit-no-padding ()
  "Tags whose joined string is exactly WIDTH chars are returned as-is."
  (should (equal "abcdefghijkl"
                 (bmkp-bmenu--format-tags-for-column '("abcdefghijkl") 12))))

(ert-deftest bmkpp-test-tags-column/overflow-gets-ellipsis ()
  "Joined tags exceeding WIDTH are truncated to WIDTH-1 + `…'."
  (should (equal "abcdefghijk…"
                 (bmkp-bmenu--format-tags-for-column '("abcdefghijkmno") 12)))
  (should (equal "alpha,beta,…"
                 (bmkp-bmenu--format-tags-for-column '("alpha" "beta" "gamma") 12))))

(ert-deftest bmkpp-test-tags-column/cons-tags-use-car ()
  "Tag values stored as (NAME . VALUE) cons cells render NAME only."
  (should (equal "color,size  "
                 (bmkp-bmenu--format-tags-for-column
                  '(("color" . "red") ("size" . "M")) 12))))

(ert-deftest bmkpp-test-tags-column/width-1-edge ()
  "Width 1 with overflow returns the ellipsis alone."
  (should (equal "…" (bmkp-bmenu--format-tags-for-column '("anything") 1))))

(ert-deftest bmkpp-test-tags-column/width-0-returns-empty ()
  "Width 0 returns the empty string regardless of tags."
  (should (equal "" (bmkp-bmenu--format-tags-for-column '("foo") 0)))
  (should (equal "" (bmkp-bmenu--format-tags-for-column ()       0))))


;;; bmkp-bmenu--truncate-name
;; --------------------------------------------------------------------

(ert-deftest bmkpp-test-tags-column/truncate-nil-is-passthrough ()
  "A nil WIDTH leaves NAME untouched even when very long."
  (let ((long (make-string 200 ?x)))
    (should (equal long (bmkp-bmenu--truncate-name long nil)))))

(ert-deftest bmkpp-test-tags-column/truncate-shorter-passes-through ()
  (should (equal "abc" (bmkp-bmenu--truncate-name "abc" 10))))

(ert-deftest bmkpp-test-tags-column/truncate-exact-passes-through ()
  (should (equal "abcdefghij" (bmkp-bmenu--truncate-name "abcdefghij" 10))))

(ert-deftest bmkpp-test-tags-column/truncate-longer-gets-ellipsis ()
  (should (equal "abcdefghi…" (bmkp-bmenu--truncate-name "abcdefghijklm" 10))))

(ert-deftest bmkpp-test-tags-column/truncate-width-1-edge ()
  (should (equal "a" (bmkp-bmenu--truncate-name "abcdef" 1))))


(provide 'bmkpp-test-tags-column)
;;; bmkpp-test-tags-column.el ends here
