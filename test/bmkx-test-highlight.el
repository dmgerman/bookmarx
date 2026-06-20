;;; bmkx-test-highlight.el --- Persistent bookmark highlighting   -*- lexical-binding: t -*-
;;
;; These tests exercise `bookmark-x-lit.el'.  They are skipped if the
;; library is not loaded.

;;; Code:

(require 'bmkx-test-helper)


(defmacro bmkx-test-skip-unless-lit (&rest body)
  "Run BODY only if `bookmark-x-lit' is loaded."
  (declare (indent 0) (debug t))
  `(if (featurep 'bookmark-x-lit)
       (progn ,@body)
     (ert-skip "bookmark-x-lit not loaded")))


(defun bmkx-test--overlays-for-bookmark (file name)
  "Return all `bookmark-plus' overlays in FILE's buffer tagged with NAME."
  (let ((dest (find-file-noselect file)))
    (with-current-buffer dest
      (cl-remove-if-not
       (lambda (ov)
         (let ((bmk (overlay-get ov 'bookmark)))
           (and (eq 'bookmark-plus (overlay-get ov 'category))
                (consp bmk)
                (equal name (car bmk)))))
       (overlays-in (point-min) (point-max))))))

(ert-deftest bmkx-test-highlight/light-adds-overlay ()
  "Lighting a bookmark adds at least one overlay in the destination buffer."
  (bmkx-test-skip-unless-lit
    (bmkx-test-with-clean-bookmarks
      (bmkx-test-with-fixture-buffer buf "alpha beta gamma"
        (let ((file (buffer-file-name buf)))
          (bmkx-test--make-bookmark "lit-target" buf 7)
          (bmkx-light-bookmark "lit-target")
          (should (bmkx-test--overlays-for-bookmark file "lit-target")))))))

(ert-deftest bmkx-test-highlight/unlight-removes-overlay ()
  "Unlighting a bookmark removes its overlay."
  (bmkx-test-skip-unless-lit
    (bmkx-test-with-clean-bookmarks
      (bmkx-test-with-fixture-buffer buf "alpha beta gamma"
        (let ((file (buffer-file-name buf)))
          (bmkx-test--make-bookmark "lit-rm" buf 7)
          (bmkx-light-bookmark "lit-rm")
          (should     (bmkx-test--overlays-for-bookmark file "lit-rm"))
          (bmkx-unlight-bookmark "lit-rm")
          (should-not (bmkx-test--overlays-for-bookmark file "lit-rm")))))))

(ert-deftest bmkx-test-highlight/light-records-style-override ()
  "Setting a per-bookmark lighting style stores a `lighting' property."
  (bmkx-test-skip-unless-lit
    (bmkx-test-with-clean-bookmarks
      (bmkx-test-with-fixture-buffer buf "x"
        (bmkx-test--make-bookmark "ovr" buf))
      ;; `bmkx-set-lighting-for-bookmark' is interactive; call it via the
      ;; setter helpers it uses internally.
      (let ((rec (bmkx-get-bookmark "ovr")))
        (bookmark-prop-set rec 'lighting '(:style line :face nil)))
      (should (bmkx-get-lighting "ovr")))))


(provide 'bmkx-test-highlight)
;;; bmkx-test-highlight.el ends here
