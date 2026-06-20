;;; bookmark-x-preview.el --- Live preview for Bookmark-X   -*- lexical-binding:t -*-
;;
;; Filename:    bookmark-x-preview.el
;; Description: Live preview for `bmkx-jump' and the `*Bmkx List*' buffer.
;;              Part of Bookmark-X.
;;
;; Author:     Daniel M. German
;; Maintainer: Daniel M. German <dmg@turingmachine.org>
;;
;; Copyright (C) 2026, Daniel M. German, all rights reserved.
;;
;; Created: Mon Jun  1 11:26:34 2026 (-0700)
;;
;; URL: https://github.com/dmgerman/bookmarx
;;
;; Keywords:      bookmarks, convenience
;; Compatibility: GNU Emacs 30+
;;
;; SPDX-License-Identifier: GPL-3.0-or-later
;;
;; Assisted-by: Claude:claude-opus-4-7

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Two ways to preview a bookmark's destination without committing to a jump:
;;
;;   `bmkx-list-preview-mode' — buffer-local minor mode in `*Bmkx List*'.
;;       Modeled on the built-in `next-error-follow-minor-mode' (simple.el):
;;       a `post-command-hook' watches point motion and dispatches the
;;       bookmark on the current line into another window without selecting
;;       it.  Toggle with `P' in `bmkx-list-mode'.
;;
;;   `bmkx-jump' minibuffer preview — when `consult' is loaded and
;;       `bmkx-preview-use-consult-flag' is non-nil, the interactive
;;       bookmark-name read for `bmkx-jump' (and its other-window /
;;       other-frame variants) is routed through `consult--read' with
;;       `consult--bookmark-preview' as the `:state' callback, the same
;;       mechanism `consult-bookmark' uses.
;;
;; The minibuffer-side path also shows each candidate's tags as a
;; completion annotation, via `bmkx-bookmark-annotation'.  The annotator
;; is additive: it prepends a `#tag #tag ...' segment to whatever
;; `marginalia-annotate-bookmark' would otherwise return (type / file /
;; location), so the existing bookmark completion display is preserved
;; and tags are added in front of it.  When `marginalia' is loaded, the
;; same annotator is registered on the `bookmark' completion category
;; so `consult-bookmark' and any other bookmark completion benefit.
;;
;; In `bmkx-jump' (but not `consult-bookmark') each candidate is
;; augmented further so the completion matches against tags and so
;; bookmark types can be narrowed / grouped:
;;
;;   - Tag tokens (`#name1 #name2 ...') are appended to the candidate
;;     string with `display ""', which keeps them in the candidate for
;;     orderless/substring matching while hiding them from view.
;;     Typing a tag name in the minibuffer filters the list.
;;
;;   - Each candidate carries a `consult--type' text property derived
;;     from its handler via `bmkx-jump-narrow', enabling the
;;     same single-key type narrowing (`,' prefix by default) as
;;     `consult-bookmark'.
;;
;;   - `bmkx-jump-sort-by' chooses the candidate order: `mru'
;;     (default; recently modified first), `visits' (most-jumped
;;     first), or `alpha' (alphabetical).  The chosen order is
;;     applied within each group when grouping is enabled.
;;
;;   - `bmkx-jump-group-by' selects whether the completion is grouped
;;     by handler type (`type'), by the bookmark's first tag (`tag'),
;;     or not at all (nil, default).  When grouping is enabled,
;;     candidates are clustered by group key and the chosen sort
;;     applies within each group; groups appear in first-seen order.
;;
;;   - Multi-axis filter state (foundation for richer faceted UI).
;;     `bmkx-jump--active-filters' is an alist of (FACET . VALUE)
;;     describing facets that further constrain the candidate set
;;     beyond what the input string and `consult-narrow-key' provide.
;;     The minibuffer keymap `bmkx-jump-minibuffer-map' binds:
;;
;;         M-t   add a tag filter (completing-read from all known tags)
;;         M-D   pop the most recently added filter
;;         M-T   clear all filters
;;
;;     Active filters are shown bracketed in the prompt
;;     (`[#emacs #work] Bookmark: '), and candidates failing any
;;     facet are excluded.  Mutation rebuilds the candidate list by
;;     quitting and re-entering `consult--read', driven by
;;     `bmkx-jump--restart-flag'.

;;; Code:

(require 'bookmark)

(declare-function bmkx-list-bookmark             "bookmark-x-bmu")
(declare-function bmkx-jump-1                    "bookmark-x-1")
(declare-function bmkx-maybe-load-default-file   "bookmark-x-1")
(declare-function bmkx-completing-read           "bookmark-x-1")
(declare-function bmkx-default-bookmark-name     "bookmark-x-1")
(declare-function bmkx-get-tags                  "bookmark-x-1")

;; Soft consult deps — only used when `(featurep 'consult)'.
(declare-function consult--read                  "consult")
(declare-function consult--bookmark-preview      "consult")
(declare-function consult--type-group            "consult")
(declare-function consult--type-narrow           "consult")

;; Marginalia integration — only touched inside `with-eval-after-load 'marginalia'.
(defvar marginalia-annotators)


;;; Customization --------------------------------------------------------

(defcustom bmkx-preview-use-consult-flag t
  "Non-nil means use `consult' for live preview in `bmkx-jump' commands.
Only takes effect when the `consult' package is loaded.  When nil, or
when `consult' is not loaded, `bmkx-jump' reads bookmark names through
the usual `completing-read', with no preview."
  :type 'boolean :group 'bookmark-plus)

(defcustom bmkx-list-preview-display-action
  '(display-buffer-use-some-window . ((inhibit-same-window . t)))
  "`display-buffer' action used to show preview windows.
Used by `bmkx-list-preview-mode'.  The default opens the preview in
some other window without stealing focus from `*Bmkx List*'."
  :type '(cons function alist) :group 'bookmark-plus)

(defcustom bmkx-jump-narrow
  '((?f "File"           bookmark-default-handler)
    (?d "Dired"          bmkx-jump-dired
                         bmkp-jump-dired
                         vc-dir-bookmark-jump)
    (?i "Info"           Info-bmkx-jump
                         Info-bookmark-jump)
    (?o "Org heading"    org-bookmark-heading-jump)
    (?n "News/Gnus"      bmkx-jump-gnus
                         gnus-summary-bookmark-jump)
    (?m "Man/Help"       bmkx-jump-man
                         bmkx-jump-woman
                         Man-bookmark-jump
                         woman-bookmark-jump
                         help-bookmark-jump)
    (?p "Picture"        image-bmkx-jump
                         image-bookmark-jump)
    (?w "Web"            bmkx-jump-eww
                         bmkx-jump-w3m
                         eww-bookmark-jump
                         xwidget-webkit-bookmark-jump-handler)
    (?u "URL"            bmkx-jump-url-browse)
    (?s "Shell"          eshell-bookmark-jump
                         shell-bookmark-jump)
    (?v "Doc view/PDF"   doc-view-bookmark-jump
                         pdf-view-bookmark-jump-handler)
    (?D "Desktop"        bmkx-jump-desktop)
    (?L "Bookmark list"  bmkx-jump-bookmark-list)
    (?F "Bookmark file"  bmkx-jump-bookmark-file)
    (?S "Snippet"        bmkx-jump-snippet)
    (?V "Variable list"  bmkx-jump-variable-list)
    (?q "Sequence"       bmkx-jump-sequence)
    (?x "Function/kmacro" bmkx-jump-function)
    (nil "Other"))
  "Narrowing configuration for `bmkx-jump'.

Each element has the form (CHAR NAME HANDLER...).  CHAR is the
single-character narrow key (or nil for the catch-all).  NAME is the
group label.  HANDLERs are the bookmark-handler symbols routed under
that group.

Used by the `consult'-backed `bmkx-jump' completion path to drive
both type narrowing and (when `bmkx-jump-group-by' is `type')
candidate grouping."
  :type '(alist :key-type (choice character (const :tag "Catch-all" nil))
                :value-type (cons string (repeat function)))
  :group 'bookmark-plus)

(defcustom bmkx-jump-group-by nil
  "How `bmkx-jump' groups completion candidates.

  `type'  Group by bookmark handler type (file, dired, info, ...).
          Uses `bmkx-jump-narrow'.
  `tag'   Group by the bookmark's first tag; untagged bookmarks
          collect under \"(untagged)\".
  nil     No grouping (default).

When non-nil, candidates are clustered by group key (preserving the
order chosen by `bmkx-jump-sort-by' within each group), and groups
appear in first-seen order.

Affects only the `consult'-backed `bmkx-jump' completion path."
  :type '(choice (const :tag "No grouping" nil)
                 (const :tag "By type" type)
                 (const :tag "By primary tag" tag))
  :group 'bookmark-plus)

(defcustom bmkx-jump-sort-by 'mru
  "How `bmkx-jump' sorts completion candidates.

  `mru'    Most recently modified first (uses each bookmark's
           `last-modified' property; Bookmark-X updates it on jump).
  `visits' Most-jumped first (uses each bookmark's `visits' count).
  `alpha'  Alphabetical by bookmark name.

When `bmkx-jump-group-by' is non-nil this order is applied within
each group; groups themselves appear in first-seen order, so the
group containing the best-sorting candidate comes first.

Affects only the `consult'-backed `bmkx-jump' completion path."
  :type '(choice (const :tag "Most recently used" mru)
                 (const :tag "By visit count"     visits)
                 (const :tag "Alphabetical"       alpha))
  :group 'bookmark-plus)


;;; Buffer-side: `bmkx-list-preview-mode' -------------------------------

(defvar bmkx-list-preview-mode)         ; Forward decl (defined by `define-minor-mode' below).

(defvar-local bmkx-list-preview--last-line nil
  "Line number of the bookmark last previewed in the current buffer.")

(defvar-local bmkx-list-preview--saved-window-config nil
  "Window configuration saved when `bmkx-list-preview-mode' was enabled.")

(defun bmkx-list-preview--show ()
  "Preview the bookmark on the current line, leaving point in `*Bmkx List*'."
  (when bmkx-list-preview-mode
    (let ((line  (line-number-at-pos)))
      (unless (eq line bmkx-list-preview--last-line)
        (setq bmkx-list-preview--last-line  line)
        (let ((bmk  (ignore-errors (bmkx-list-bookmark))))
          (when bmk
            (save-selected-window
              (condition-case _err
                  (let ((display-buffer-overriding-action  bmkx-list-preview-display-action))
                    (bmkx-jump-1 bmk #'pop-to-buffer nil))
                (error nil)))))))))

;;;###autoload
(define-minor-mode bmkx-list-preview-mode
  "Toggle live preview of the bookmark on point in `*Bmkx List*'.

When enabled, moving point onto a bookmark line opens its destination
in another window without changing the selected window.  This is the
bookmark-list analog of `next-error-follow-minor-mode'.

Disabling the mode restores the window configuration that was in
effect when the mode was enabled."
  :lighter " Pv"
  :group 'bookmark-plus
  (cond
   (bmkx-list-preview-mode
    (setq bmkx-list-preview--saved-window-config  (current-window-configuration))
    (setq bmkx-list-preview--last-line            nil)
    (add-hook 'post-command-hook #'bmkx-list-preview--show nil 'local)
    (bmkx-list-preview--show))
   (t
    (remove-hook 'post-command-hook #'bmkx-list-preview--show 'local)
    (when bmkx-list-preview--saved-window-config
      (set-window-configuration bmkx-list-preview--saved-window-config)
      (setq bmkx-list-preview--saved-window-config  nil)))))


;;; Minibuffer-side: consult integration for `bmkx-jump' ---------------

(defun bmkx--candidate-name (cand)
  "Return the bare bookmark name carried by completion candidate CAND.
Augmented candidates produced by `bmkx-read-bookmark-for-jump' store
the bare name in a `bmkx-bookmark-name' text property.  Plain strings
(e.g. produced by `consult-bookmark') are returned unchanged."
  (or (and (stringp cand) (get-text-property 0 'bmkx-bookmark-name cand))
      cand))

(defun bmkx--bookmark-primary-tag (name)
  "Return the first tag of bookmark NAME as a string, or nil if untagged."
  (let ((first  (car (bookmark-prop-get name 'tags))))
    (cond ((consp first) (car first))
          (first first))))

(defun bmkx--make-jump-candidate (bm narrow-alist)
  "Build a `bmkx-jump' completion candidate for bookmark record BM.

The candidate string holds three things:

  - The bookmark name (visible).
  - Any tag tokens (`#tag1 #tag2 ...'), appended with `display \"\"' so
    they stay in the candidate for orderless/substring matching but
    are not shown in the minibuffer.
  - Text properties: `bmkx-bookmark-name' (the bare name, for
    `:lookup' / `:state' / annotator); `consult--type' (the narrow
    character mapped from the handler via NARROW-ALIST, for
    `consult--type-narrow' / `consult--type-group').

NARROW-ALIST maps handler symbols to single-char narrow keys, in the
form consumed by `consult--type-narrow' / `consult--type-group'."
  (let* ((name      (car bm))
         (tags      (bookmark-prop-get name 'tags))
         (raw       (when tags (bmkx--tags-segment-raw tags)))
         (type-char (alist-get
                     (or (bookmark-get-handler bm) #'bookmark-default-handler)
                     narrow-alist))
         (head      (propertize name
                                'bmkx-bookmark-name name
                                'consult--type     type-char)))
    (if raw
        (concat head
                (propertize (concat " " raw)
                            'display           ""
                            'bmkx-bookmark-name name
                            'consult--type     type-char))
      head)))

(defun bmkx--jump-group-function (narrow)
  "Return a `:group' function honoring `bmkx-jump-group-by'.
NARROW is the (CHAR . NAME) alist used by `consult--type-group'."
  (pcase bmkx-jump-group-by
    ('type (consult--type-group narrow))
    ('tag  (lambda (cand transform)
             (if transform
                 cand
               (or (bmkx--bookmark-primary-tag (bmkx--candidate-name cand))
                   "(untagged)"))))
    (_     nil)))

(defun bmkx--sort-candidates (cands)
  "Order CANDS per `bmkx-jump-sort-by'."
  (pcase bmkx-jump-sort-by
    ('alpha
     (sort cands (lambda (a b)
                   (string< (bmkx--candidate-name a)
                            (bmkx--candidate-name b)))))
    ('mru
     (sort cands (lambda (a b)
                   (time-less-p
                    (or (bookmark-prop-get (bmkx--candidate-name b) 'last-modified) '(0 0))
                    (or (bookmark-prop-get (bmkx--candidate-name a) 'last-modified) '(0 0))))))
    ('visits
     (sort cands (lambda (a b)
                   (> (or (bookmark-prop-get (bmkx--candidate-name a) 'visits) 0)
                      (or (bookmark-prop-get (bmkx--candidate-name b) 'visits) 0)))))
    (_ cands)))

(defun bmkx--candidate-group-key (cand)
  "Return the group key for CAND per `bmkx-jump-group-by', or nil."
  (pcase bmkx-jump-group-by
    ('type (get-text-property 0 'consult--type cand))
    ('tag  (or (bmkx--bookmark-primary-tag (bmkx--candidate-name cand))
               "(untagged)"))))

(defun bmkx--cluster-by-group (cands)
  "If grouping is enabled, cluster sorted CANDS by group key.
Within-group order is preserved (so the sort chosen by
`bmkx-jump-sort-by' still applies within each group).  Groups appear
in first-seen order — the group whose best-sorting candidate is
first in CANDS leads."
  (if (null bmkx-jump-group-by)
      cands
    (let ((buckets (make-hash-table :test 'equal))
          (order   nil))
      (dolist (c cands)
        (let ((g (bmkx--candidate-group-key c)))
          (unless (gethash g buckets) (push g order))
          (puthash g (cons c (gethash g buckets nil)) buckets)))
      (mapcan (lambda (g) (nreverse (gethash g buckets)))
              (nreverse order)))))


;;; Multi-axis filter state -------------------------------------------

(defvar bmkx-jump--active-filters nil
  "Active filter facets for the current `bmkx-jump' session.
An alist of (FACET . VALUE).  Currently supported facets:

  `tag'  VALUE is a tag name string; the candidate matches if any of
         its tags equals VALUE.

The list is reset on every fresh invocation of `bmkx-jump' (via
`bmkx-read-bookmark-for-jump').  Designed to grow new facets
(annotation regex, autofile-only, date range) without changing the
calling shape.")

(defvar bmkx-jump--restart-flag nil
  "Non-nil signals the `bmkx-read-bookmark-for-jump' loop to re-enter
`consult--read' after a filter command quit the minibuffer.")

(defun bmkx--all-tags ()
  "Return the sorted, distinct list of tag names across `bookmark-alist'."
  (let ((seen  (make-hash-table :test 'equal)))
    (dolist (bm bookmark-alist)
      (dolist (tag (bookmark-prop-get (car bm) 'tags))
        (puthash (if (consp tag) (car tag) tag) t seen)))
    (let (out) (maphash (lambda (k _v) (push k out)) seen)
         (sort out #'string<))))

(defun bmkx--bookmark-passes-filters-p (bm filters)
  "Return non-nil if bookmark record BM satisfies every facet in FILTERS."
  (cl-every (lambda (f)
              (pcase (car f)
                ('tag (let ((tags  (bookmark-prop-get (car bm) 'tags)))
                        (cl-some (lambda (tg)
                                   (equal (if (consp tg) (car tg) tg) (cdr f)))
                                 tags)))
                (_ t)))
            filters))

(defun bmkx--format-active-filters ()
  "Format `bmkx-jump--active-filters' for display in the prompt.
Returns a possibly-empty propertized string (no trailing space)."
  (if (null bmkx-jump--active-filters) ""
    (mapconcat (lambda (f)
                 (pcase (car f)
                   ('tag (propertize (concat "#" (cdr f))
                                     'face 'completions-annotations))
                   (_    (format "%S" f))))
               (reverse bmkx-jump--active-filters)
               " ")))

(defun bmkx--jump-build-prompt (base default)
  "Build the consult `:prompt' string with active-filter indicator and DEFAULT."
  (let* ((tail   (if default
                     (format " (%s): "
                             (if (consp default) (car default) default))
                   ": "))
         (filter (bmkx--format-active-filters)))
    (if (string-empty-p filter)
        (concat base tail)
      (concat "[" filter "] " base tail))))

;;;###autoload
(defun bmkx-jump-add-tag-filter ()
  "Inside `bmkx-jump's minibuffer: prompt for a tag and add it as a filter.
Quits and re-enters the completion with the updated filter set.  The
tag is read from `bmkx--all-tags' (every distinct tag in
`bookmark-alist')."
  (interactive)
  (let* ((known  (bmkx--all-tags))
         (tag    (and known
                      (completing-read "Tag filter: " known nil t))))
    (when (and tag (not (string-empty-p tag)))
      (cl-pushnew (cons 'tag tag) bmkx-jump--active-filters :test #'equal)
      (setq bmkx-jump--restart-flag t)
      (abort-minibuffers))))

;;;###autoload
(defun bmkx-jump-pop-filter ()
  "Inside `bmkx-jump's minibuffer: remove the most recently added filter."
  (interactive)
  (when bmkx-jump--active-filters
    (pop bmkx-jump--active-filters)
    (setq bmkx-jump--restart-flag t)
    (abort-minibuffers)))

;;;###autoload
(defun bmkx-jump-clear-filters ()
  "Inside `bmkx-jump's minibuffer: clear all active filters."
  (interactive)
  (when bmkx-jump--active-filters
    (setq bmkx-jump--active-filters nil)
    (setq bmkx-jump--restart-flag t)
    (abort-minibuffers)))

(defvar-keymap bmkx-jump-minibuffer-map
  :doc "Keymap active in the minibuffer during `bmkx-jump' completion.
Bindings are layered on top of consult's own minibuffer map."
  "M-t" #'bmkx-jump-add-tag-filter
  "M-T" #'bmkx-jump-clear-filters
  "M-D" #'bmkx-jump-pop-filter)

(defun bmkx--jump-read-once (prompt default)
  "One pass of the `bmkx-jump' consult read; signals `quit' on filter restart.
Caller (`bmkx-read-bookmark-for-jump') loops while
`bmkx-jump--restart-flag' is set after each pass."
  (let* ((narrow-alist  (cl-loop for (y _ . xs) in bmkx-jump-narrow nconc
                                 (cl-loop for x in xs collect (cons x y))))
         (narrow        (cl-loop for (x y . _) in bmkx-jump-narrow collect (cons x y)))
         (cands         (bmkx--cluster-by-group
                         (bmkx--sort-candidates
                          (cl-loop for bm in bookmark-alist
                                   when (bmkx--bookmark-passes-filters-p
                                         bm bmkx-jump--active-filters)
                                   collect (bmkx--make-jump-candidate bm narrow-alist)))))
         (preview       (consult--bookmark-preview)))
    (consult--read
     cands
     :prompt        (bmkx--jump-build-prompt prompt default)
     :require-match t
     :sort          nil
     :default       (if (consp default) (car default) default)
     :history       'bookmark-history
     :category      'bookmark
     :annotate      #'bmkx-bookmark-annotation
     :group         (bmkx--jump-group-function narrow)
     :narrow        (consult--type-narrow narrow)
     :keymap        bmkx-jump-minibuffer-map
     :lookup        (lambda (selected &rest _)
                      (bmkx--candidate-name selected))
     :state         (lambda (action cand)
                      (funcall preview action
                               (and cand (bmkx--candidate-name cand)))))))

;;;###autoload
(defun bmkx-read-bookmark-for-jump (prompt &optional default)
  "Read a bookmark name with live preview, for the `bmkx-jump' commands.

When `consult' is loaded and `bmkx-preview-use-consult-flag' is
non-nil, read through `consult--read', augmenting each candidate with:

  - hidden tag tokens so typing a tag name narrows the candidate
    list (the tag text is matched by completion but not displayed);
  - handler-type narrowing via `consult--type-narrow' and the
    configuration in `bmkx-jump-narrow';
  - grouping per `bmkx-jump-group-by' (by type or by primary tag);
  - sorting per `bmkx-jump-sort-by' (mru/visits/alpha);
  - a multi-axis filter state in `bmkx-jump--active-filters' that the
    minibuffer keys in `bmkx-jump-minibuffer-map' mutate (M-t adds a
    tag filter, M-D pops, M-T clears).  Active filters are shown in
    the prompt and candidates failing them are excluded.

Otherwise falls back to `bmkx-completing-read'."
  (bmkx-maybe-load-default-file)
  (setq bmkx-jump--active-filters nil)
  (if (and bmkx-preview-use-consult-flag
           (featurep 'consult)
           (fboundp 'consult--read)
           (fboundp 'consult--bookmark-preview))
      (let (result done)
        (while (not done)
          (setq bmkx-jump--restart-flag nil)
          (condition-case _
              (progn
                (setq result (bmkx--jump-read-once prompt default))
                (setq done t))
            (quit
             ;; A filter command triggered the quit -> loop and re-enter.
             ;; A genuine C-g -> propagate so the caller aborts cleanly
             ;; instead of receiving nil and erroring downstream.
             (unless bmkx-jump--restart-flag
               (signal 'quit nil)))))
        result)
    (bmkx-completing-read prompt default)))


;;; Bookmark annotation (tags + built-in details) ----------------------

(declare-function marginalia-annotate-bookmark "marginalia")

(defun bmkx--tags-segment-raw (tags)
  "Return TAGS rendered as space-separated `#tag' tokens (a plain string)."
  (mapconcat (lambda (tag) (concat "#" (if (consp tag) (car tag) tag)))
             tags " "))

(defvar bmkx--tags-segment-width-cache nil
  "Cache for `bmkx--tags-segment-width': cons (BOOKMARK-ALIST . WIDTH).
Invalidated when `bookmark-alist' is replaced (identity changes).")

(defun bmkx--tags-segment-width ()
  "Return the max width of the formatted tags segment across `bookmark-alist'.
Width is the maximum, over every bookmark, of (length (`bmkx--tags-segment-raw'
TAGS)).  Untagged bookmarks contribute 0.  Cached by alist identity."
  (let ((cached  (car bmkx--tags-segment-width-cache)))
    (unless (eq cached bookmark-alist)
      (setq bmkx--tags-segment-width-cache
            (cons bookmark-alist
                  (apply #'max 0
                         (mapcar (lambda (b)
                                   (let ((tags  (bookmark-prop-get (car b) 'tags)))
                                     (if tags (length (bmkx--tags-segment-raw tags)) 0)))
                                 bookmark-alist))))))
  (cdr bmkx--tags-segment-width-cache))

(defun bmkx-bookmark-annotation (cand)
  "Return an annotation for bookmark candidate CAND.
Composes two parts:

  - A tags segment built from `bmkx-get-tags', formatted as
    space-separated `#tag' tokens and padded on the right to the
    width of the widest tags segment in `bookmark-alist' so that
    annotations form an aligned column.  Untagged bookmarks emit a
    blank segment of the same width.

  - The base annotation from `marginalia-annotate-bookmark' (type,
    file, location), when `marginalia' is loaded.

A `marginalia--align' text property is placed at position 0 so the
tags column starts at a fixed minibuffer column regardless of the
candidate name's width (marginalia replaces that one char with a
`(space :align-to ...)' display at render time).

Either part may be missing.  Returns nil if both are missing."
  (let* ((width      (bmkx--tags-segment-width))
         (name       (bmkx--candidate-name cand))
         (bmk        (and (stringp name) (assoc name bookmark-alist)))
         (tags       (and bmk (bmkx-get-tags bmk)))
         (raw-tags   (if tags (bmkx--tags-segment-raw tags) ""))
         (base-part  (and (fboundp 'marginalia-annotate-bookmark)
                          (marginalia-annotate-bookmark name))))
    (cond
     ;; Nothing to show.
     ((and (zerop width) (null base-part)) nil)
     ;; Tags-only (marginalia is not loaded).
     ((null base-part)
      (concat "   " (propertize raw-tags 'face 'completions-annotations)))
     ;; Both, with column alignment.
     (t
      (let* ((padded    (concat raw-tags
                                (make-string (max 0 (- width (length raw-tags))) ?\ )))
             (tags-fmt  (propertize padded 'face 'completions-annotations)))
        (concat (propertize " " 'marginalia--align t)
                tags-fmt
                "  "
                base-part))))))

;; When `marginalia' is loaded, register `bmkx-bookmark-annotation' as
;; the primary annotator for the `bookmark' category so it fires for
;; `consult-bookmark' and any other bookmark completion.  The original
;; `marginalia-annotate-bookmark' is invoked from within our annotation
;; (we compose, not replace), and is also preserved as a `marginalia-cycle'
;; alternative.
(with-eval-after-load 'marginalia
  (let ((entry  (assq 'bookmark marginalia-annotators)))
    (if entry
        (unless (memq 'bmkx-bookmark-annotation entry)
          (setcdr entry (cons #'bmkx-bookmark-annotation (cdr entry))))
      (push '(bookmark bmkx-bookmark-annotation builtin none)
            marginalia-annotators))))


(provide 'bookmark-x-preview)

;;; bookmark-x-preview.el ends here
