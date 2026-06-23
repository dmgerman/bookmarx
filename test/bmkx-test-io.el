;;; bmkx-test-io.el --- Bookmark-file write / read round-trip   -*- lexical-binding: t -*-

;;; Code:

(require 'bmkx-test-helper)


(ert-deftest bmkx-test-io/round-trip-name-and-filename ()
  "Writing then reading the bookmark file preserves name and filename."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "hello world"
      (bmkx-test--make-bookmark "rt-one" buf 7))
    (bookmark-save)
    (let ((before bookmark-alist))
      ;; Fresh slate, reload from disk.
      (setq bookmark-alist nil)
      (let ((bookmarks-already-loaded nil))
        (bookmark-load bookmark-default-file 'OVERWRITE 'NO-MSG))
      (let ((after (bmkx-get-bookmark "rt-one" 'NOERROR)))
        (should after)
        (should (equal (bookmark-prop-get "rt-one" 'filename)
                       (bookmark-prop-get (car before) 'filename)))))))

(ert-deftest bmkx-test-io/round-trip-preserves-id ()
  "Reloading a bookmark file preserves each record's `id'."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "hi"
      (bmkx-test--make-bookmark "rt-id" buf))
    (let ((id-before (bookmark-prop-get "rt-id" 'id)))
      (bookmark-save)
      (setq bookmark-alist nil)
      (let ((bookmarks-already-loaded nil))
        (bookmark-load bookmark-default-file 'OVERWRITE 'NO-MSG))
      (should (equal id-before (bookmark-prop-get "rt-id" 'id))))))

(ert-deftest bmkx-test-io/round-trip-preserves-tags ()
  "Reloading a bookmark file preserves tags."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "hi"
      (bmkx-test--make-bookmark "rt-tags" buf)
      (bmkx-add-tags "rt-tags" '("alpha" "beta") 'NO-UPDATE-P 'NO-MSG-P))
    (bookmark-save)
    (setq bookmark-alist nil)
    (let ((bookmarks-already-loaded nil))
      (bookmark-load bookmark-default-file 'OVERWRITE 'NO-MSG))
    (let ((tags (bmkx-get-tags "rt-tags")))
      (should (member "alpha" (mapcar (lambda (tt) (if (consp tt) (car tt) tt)) tags)))
      (should (member "beta"  (mapcar (lambda (tt) (if (consp tt) (car tt) tt)) tags))))))

(ert-deftest bmkx-test-io/load-backfills-missing-ids ()
  "Loading a bookmark file with id-less records adds an `id' to each.

This simulates a file written by built-in `bookmark.el' or by older
Bookmark-X versions."
  (bmkx-test-with-clean-bookmarks
    (let ((tmp (bmkx-test--make-temp-bookmark-file))
          (txt (make-temp-file "bmkx-test-load-" nil ".txt")))
      (push txt bmkx-test--temp-files)
      (with-temp-file txt (insert "xyz"))
      ;; Hand-write a bookmark file without an `id' field.
      (with-temp-file tmp
        (insert ";;;; Emacs Bookmark Format Version 1 -*- coding: utf-8-emacs-unix -*-\n")
        (insert ";;; -*- End Of Bookmark File Format Version Stamp -*-\n")
        (prin1 `(("no-id"
                  (filename . ,txt)
                  (position . 1)))
               (current-buffer))
        (insert "\n"))
      (let ((bookmark-default-file tmp)
            (bookmarks-already-loaded nil)
            (bookmark-alist nil))
        ;; `bmkx-load' runs the post-load hooks (id backfill, dedup);
        ;; built-in `bookmark-load' does not.
        (bmkx-load tmp 'OVERWRITE 'NO-MSG)
        (let ((id (bookmark-prop-get "no-id" 'id)))
          (should (stringp id))
          (should (> (length id) 0)))))))

(ert-deftest bmkx-test-io/load-deduplicates-names ()
  "Loading a bookmark file with duplicate names yields unique names.

Bmkx-deduplicate-bookmark-names runs on the post-load hook and renames
the second occurrence (foo -> foo<2>)."
  (bmkx-test-with-clean-bookmarks
    (let ((tmp (bmkx-test--make-temp-bookmark-file))
          (txt (make-temp-file "bmkx-test-dedup-" nil ".txt")))
      (push txt bmkx-test--temp-files)
      (with-temp-file txt (insert "hi"))
      (with-temp-file tmp
        (insert ";;;; Emacs Bookmark Format Version 1 -*- coding: utf-8-emacs-unix -*-\n")
        (insert ";;; -*- End Of Bookmark File Format Version Stamp -*-\n")
        (prin1 `(("foo" (filename . ,txt) (position . 1))
                 ("foo" (filename . ,txt) (position . 2)))
               (current-buffer))
        (insert "\n"))
      (let ((bookmark-default-file tmp)
            (bookmarks-already-loaded nil)
            (bookmark-alist nil))
        (bmkx-load tmp 'OVERWRITE 'NO-MSG)
        (should (= 2 (length bookmark-alist)))
        (let ((names (mapcar #'car bookmark-alist)))
          (should (member "foo" names))
          (should (cl-some (lambda (n) (string-match-p "foo<[0-9]+>" n)) names)))))))


;;; bmkx-extend-temp-to-builtin-flag: built-in API honors `bmkx-temp'

(defun bmkx-test--make-record-for-buffer (buf &optional position)
  "Build a bookmark record alist for BUF (no NAME prefix), at POSITION."
  (with-current-buffer buf
    (save-excursion
      (goto-char (or position (point-min)))
      (let ((bookmark-make-record-function #'bmkx-make-record-default))
        (cdr (funcall bookmark-make-record-function))))))

(defun bmkx-test--match-org-capture (bmk)
  "Predicate matching the bookmark name \"test-autotemp-target\"."
  (let ((name (if (stringp bmk) bmk (bmkx-bookmark-name-from-record bmk))))
    (equal name "test-autotemp-target")))

(ert-deftest bmkx-test-io/builtin-store-fires-autotemp-predicates ()
  "`bookmark-store' fires `bmkx-autotemp-bookmark-predicates' when the flag is on."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "x"
      (let ((bmkx-autotemp-bookmark-predicates
             (cons #'bmkx-test--match-org-capture
                   bmkx-autotemp-bookmark-predicates))
            (bmkx-extend-temp-to-builtin-flag t))
        ;; Ensure advice is installed.
        (bmkx-extend-temp-to-builtin t)
        (unwind-protect
            (progn
              (bookmark-store "test-autotemp-target"
                              (bmkx-test--make-record-for-buffer buf)
                              nil)
              (should (assoc "test-autotemp-target" bookmark-alist))
              (should (bmkx-temporary-bookmark-p "test-autotemp-target")))
          ;; Restore advice state to whatever the user's session had.
          (bmkx-extend-temp-to-builtin bmkx-extend-temp-to-builtin-flag))))))

(ert-deftest bmkx-test-io/builtin-write-file-skips-temp-records ()
  "`bookmark-write-file' omits `bmkx-temp' records when the flag is on."
  (bmkx-test-with-clean-bookmarks
    (bmkx-test-with-fixture-buffer buf "x"
      (bmkx-test--make-bookmark "savable-bmk"  buf)
      (bmkx-test--make-bookmark "ephemeral-bmk" buf))
    (bmkx-make-bookmark-temporary "ephemeral-bmk")
    (let ((bmkx-extend-temp-to-builtin-flag t))
      (bmkx-extend-temp-to-builtin t)
      (unwind-protect
          (progn
            (bookmark-write-file bookmark-default-file)
            (with-temp-buffer
              (insert-file-contents bookmark-default-file)
              (let ((body (buffer-string)))
                (should     (string-match-p "savable-bmk"  body))
                (should-not (string-match-p "ephemeral-bmk" body)))))
        (bmkx-extend-temp-to-builtin bmkx-extend-temp-to-builtin-flag)))))

(ert-deftest bmkx-test-io/extend-temp-to-builtin-toggle-installs-and-removes-advice ()
  "Calling `bmkx-extend-temp-to-builtin' installs and removes both advices."
  (let ((orig  bmkx-extend-temp-to-builtin-flag))
    (unwind-protect
        (progn
          (bmkx-extend-temp-to-builtin nil)
          (should-not (advice-member-p #'bmkx--autotemp-after-bookmark-store           'bookmark-store))
          (should-not (advice-member-p #'bmkx--strip-temps-around-bookmark-write-file  'bookmark-write-file))
          (bmkx-extend-temp-to-builtin t)
          (should (advice-member-p #'bmkx--autotemp-after-bookmark-store           'bookmark-store))
          (should (advice-member-p #'bmkx--strip-temps-around-bookmark-write-file  'bookmark-write-file)))
      (bmkx-extend-temp-to-builtin orig))))


(provide 'bmkx-test-io)
;;; bmkx-test-io.el ends here
