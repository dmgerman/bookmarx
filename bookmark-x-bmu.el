;;; bookmark-x-bmu.el --- Bookmark-X code for the `*Bmkx List*' (bmenu).   -*- lexical-binding:t -*-
;;
;; Filename:    bookmark-x-bmu.el
;; Description: Bookmark-X code for the `*Bmkx List*' (bmenu).
;;              Fork of Drew Adams' Bookmark+, modernized for Emacs 30+.
;;
;; Author:     Drew Adams, Thierry Volpiatto
;; Maintainer: Daniel M. German <dmg@turingmachine.org>
;;
;; Copyright (C) 2000-2025, Drew Adams, all rights reserved.
;; Copyright (C) 2009, Thierry Volpiatto, all rights reserved.
;; Copyright (C) 2026, Daniel M. German, all rights reserved.
;;
;; Created: Mon Jul 12 09:05:21 2010 (-0700)
;;
;; URL: https://github.com/dmgerman/bookmarx
;;
;; Keywords:      bookmarks, placeholders, annotations, search, info, url, eww, gnus
;; Compatibility: GNU Emacs 30+
;;
;; SPDX-License-Identifier: GPL-3.0-or-later
;;
;; Assisted-by: Claude:claude-opus-4-7
;;
;; Features that might be required by this library:
;;
;;   `apropos', `apropos+', `auth-source', `avoid', `backquote',
;;   `bookmark', `bookmark-x', `bookmark-x-1', `bookmark-x-bmu',
;;   `bookmark-x-key', `bookmark-x-lit', `button', `bytecomp', `cconv',
;;   `cl-generic', `cl-lib', `cl-macs', `cmds-menu',
;;   `eieio', `eieio-core', `eieio-loaddefs',
;;   `epg-config', `font-lock', `font-lock+',
;;   `frame-fns', `gv', `help+', `help-fns', `help-fns+',
;;   `help-macro', `help-macro+', `help-mode', `hl-line', `hl-line+',
;;   `info', `info+', `kmacro', `macroexp', `menu-bar', `menu-bar+',
;;   `misc-cmds', `misc-fns', `naked', `package', `password-cache',
;;   `pp', `pp+', `radix-tree', `rect', `replace', `second-sel',
;;   `seq', `strings', `syntax', `tabulated-list', `text-mode',
;;   `thingatpt', `url-handlers', `url-parse',
;;   `url-vars', `vline', `w32browser-dlgopen', `wid-edit',
;;   `wid-edit+'.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;;    This library contains code for buffer `*Bmkx List*' (mode
;;    `bmkx-list-mode').
;;
;;    The Bookmark-X libraries are these:
;;
;;    `bookmark-x.el'     - main (driver) library
;;    `bookmark-x-mac.el' - Lisp macros
;;    `bookmark-x-lit.el' - (optional) code for highlighting bookmarks
;;    `bookmark-x-bmu.el' - code for the `*Bmkx List*' (this file)
;;    `bookmark-x-1.el'   - other required code (non-bmenu)
;;    `bookmark-x-key.el' - key and menu bindings
;;
;;    User documentation is the `bookmark-x' Info manual.  See
;;    `M-x info RET m bookmark-x RET' or the source in
;;    `doc/bookmark-x.texi'.
 
;;(@> "Index")
;;
;;  Index
;;  -----
;;
;;  Tip: run `M-x outline-minor-mode' with `outline-regexp' set to
;;  `";;[ \\t]*(@[*>@]"' to fold and navigate the sections of this file.
;;
;;  (@> "Things Defined Here")
;;  (@> "Utility Functions")
;;  (@> "Faces (Customizable)")
;;  (@> "User Options (Customizable)")
;;  (@> "Internal Variables")
;;  (@> "Compatibility Code for Older Emacs Versions")
;;  (@> "Menu List Replacements (`bookmark-bmenu-*')")
;;  (@> "Bookmark-X Functions (`bmkx-*')")
;;    (@> "Menu-List (`*-bmenu-*') Filter Commands")
;;    (@> "Menu-List (`*-bmenu-*') Commands Involving Marks")
;;    (@> "Omitted Bookmarks")
;;    (@> "Search-and-Replace Locations of Marked Bookmarks")
;;    (@> "Tags")
;;    (@> "General Menu-List (`-*bmenu-*') Commands and Functions")
;;    (@> "Sorting - Commands")
;;    (@> "Other Bookmark-X Functions (`bmkx-*')")
;;  (@> "Keymaps")
 
;;(@* "Things Defined Here")
;;
;;  Things Defined Here
;;  -------------------
;;
;;  Commands defined here:
;;
;;    `bmkx-bmenu-add-tags', `bmkx-bmenu-add-tags-to-marked',
;;    `bmkx-bmenu-change-sort-order',
;;    `bmkx-bmenu-change-sort-order-repeat',
;;    `bmkx-bmenu-clone-bookmark', `bmkx-bmenu-copy-bookmark',
;;    `bmkx-bmenu-copy-marked-to-bookmark-file',
;;    `bmkx-bmenu-copy-tags',
;;    `bmkx-bmenu-create-bookmark-file-from-marked',
;;    `bmkx-bmenu-define-command',
;;    `bmkx-bmenu-define-full-snapshot-command',
;;    `bmkx-bmenu-define-jump-marked-command',
;;    `bmkx-bmenu-delete-marked', `bmkx-bmenu-describe-marked',
;;    `bmkx-bmenu-describe-this+move-down',
;;    `bmkx-bmenu-describe-this+move-up',
;;    `bmkx-bmenu-describe-this-bookmark',`bmkx-bmenu-dired-marked',
;;    `bmkx-bmenu-edit-annotations-for-marked',
;;    `bmkx-bmenu-edit-bookmark-name-and-location',
;;    `bmkx-bmenu-filter-annotation-incrementally',
;;    `bmkx-bmenu-filter-bookmark-name-incrementally',
;;    `bmkx-bmenu-filter-file-name-incrementally',
;;    `bmkx-bmenu-filter-tags-incrementally',
;;    `bmkx-bmenu-flag-for-deletion',
;;    `bmkx-bmenu-flag-for-deletion-backwards',
;;    `bmkx-bmenu-isearch-marked-bookmarks' (Emacs 23+),
;;    `bmkx-bmenu-isearch-marked-bookmarks-regexp' (Emacs 23+),
;;    `bmkx-bmenu-jump-to-marked', `bmkx-bmenu-load-marking',
;;    `bmkx-bmenu-load-marking-unmark-first',
;;    `bmkx-bmenu-make-sequence-from-marked', `bmkx-bmenu-mark-all',
;;    `bmkx-bmenu-mark-autofile-bookmarks',
;;    `bmkx-bmenu-mark-bookmark-file-bookmarks',
;;    `bmkx-bmenu-mark-bookmark-list-bookmarks',
;;    `bmkx-bmenu-mark-bookmarks-satisfying',
;;    `bmkx-bmenu-mark-bookmarks-tagged-all',
;;    `bmkx-bmenu-mark-bookmarks-tagged-none',
;;    `bmkx-bmenu-mark-bookmarks-tagged-not-all',
;;    `bmkx-bmenu-mark-bookmarks-tagged-regexp',
;;    `bmkx-bmenu-mark-bookmarks-tagged-some',
;;    `bmkx-bmenu-mark-desktop-bookmarks',
;;    `bmkx-bmenu-mark-dired-bookmarks',
;;    `bmkx-bmenu-mark-eww-bookmarks' (Emacs 25+),
;;    `bmkx-bmenu-mark-file-bookmarks',
;;    `bmkx-bmenu-mark-function-bookmarks',
;;    `bmkx-bmenu-mark-gnus-bookmarks',
;;    `bmkx-bmenu-mark-image-bookmarks',
;;    `bmkx-bmenu-mark-info-bookmarks',
;;    `bmkx-bmenu-mark-lighted-bookmarks',
;;    `bmkx-bmenu-mark-man-bookmarks',
;;    `bmkx-bmenu-mark-non-file-bookmarks',
;;    `bmkx-bmenu-mark-non-invokable-bookmarks',
;;    `bmkx-bmenu-mark-orphaned-local-file-bookmarks',
;;    `bmkx-bmenu-mark-region-bookmarks',
;;    `bmkx-bmenu-mark-snippet-bookmarks',
;;    `bmkx-bmenu-mark-specific-buffer-bookmarks',
;;    `bmkx-bmenu-mark-specific-file-bookmarks',
;;    `bmkx-bmenu-mark-url-bookmarks',
;;    `bmkx-bmenu-mark-variable-list-bookmarks',
;;    `bmkx-bmenu-mark-w3m-bookmarks', `bmkx-bmenu-mouse-3-menu',
;;    `bmkx-bmenu-mode-status-help',
;;    `bmkx-bmenu-move-marked-to-bookmark-file',
;;    `bmkx-bmenu-nb-marked-in-mode-name', `bmkx-bmenu-omit',
;;    `bmkx-bmenu-omit-marked', `bmkx-bmenu-omit/unomit-marked',
;;    `bmkx-bmenu-paste-add-tags',
;;    `bmkx-bmenu-paste-add-tags-to-marked',
;;    `bmkx-bmenu-paste-replace-tags',
;;    `bmkx-bmenu-paste-replace-tags-for-marked',
;;    `bmkx-bmenu-query-replace-marked-bookmarks-regexp',
;;    `bmkx-bmenu-quit', `bmkx-bmenu-refresh-menu-list',
;;    `bmkx-bmenu-regexp-mark', `bookmark-bmenu-relocate' (Emacs 20,
;;    21), `bmkx-bmenu-relocate-marked', `bmkx-bmenu-remove-all-tags',
;;    `bmkx-bmenu-remove-tags', `bmkx-bmenu-remove-tags-from-marked',
;;    `bmkx-bmenu-search-marked-bookmarks-regexp',
;;    `bmkx-bmenu-set-bookmark-file-bookmark-from-marked',
;;    `bmkx-bmenu-set-tag-value',
;;    `bmkx-bmenu-set-tag-value-for-marked', `bmkx-bmenu-show-all',
;;    `bmkx-bmenu-show-only-autofile-bookmarks',
;;    `bmkx-bmenu-show-only-autonamed-bookmarks',
;;    `bmkx-bmenu-show-only-bookmark-file-bookmarks',
;;    `bmkx-bmenu-show-only-bookmark-list-bookmarks',
;;    `bmkx-bmenu-show-only-desktop-bookmarks',
;;    `bmkx-bmenu-show-only-dired-bookmarks',
;;    `bmkx-bmenu-show-only-eww-bookmarks' (Emacs 25+),
;;    `bmkx-bmenu-show-only-file-bookmarks',
;;    `bmkx-bmenu-show-only-function-bookmarks',
;;    `bmkx-bmenu-show-only-gnus-bookmarks',
;;    `bmkx-bmenu-show-only-image-bookmarks',
;;    `bmkx-bmenu-show-only-info-bookmarks',
;;    `bmkx-bmenu-show-only-man-bookmarks',
;;    `bmkx-bmenu-show-only-non-file-bookmarks',
;;    `bmkx-bmenu-show-only-non-invokable-bookmarks',
;;    `bmkx-bmenu-show-only-omitted-bookmarks',
;;    `bmkx-bmenu-show-only-orphaned-local-file-bookmarks',
;;    `bmkx-bmenu-show-only-region-bookmarks',
;;    `bmkx-bmenu-show-only-snippet-bookmarks',
;;    `bmkx-bmenu-show-only-specific-buffer-bookmarks',
;;    `bmkx-bmenu-show-only-specific-file-bookmarks',
;;    `bmkx-bmenu-show-only-temporary-bookmarks',
;;    `bmkx-bmenu-show-only-tagged-bookmarks',
;;    `bmkx-bmenu-show-only-untagged-bookmarks',
;;    `bmkx-bmenu-show-only-url-bookmarks',
;;    `bmkx-bmenu-show-only-variable-list-bookmarks',
;;    `bmkx-bmenu-show-only-w3m-bookmarks',
;;    `bmkx-bmenu-show-or-edit-annotation',
;;    `bmkx-bmenu-show-this-annotation+move-down',
;;    `bmkx-bmenu-show-this-annotation+move-up',
;;    `bmkx-bmenu-sort-annotated-before-unannotated',
;;    `bmkx-bmenu-sort-by-bookmark-name',
;;    `bmkx-bmenu-sort-by-bookmark-visit-frequency',
;;    `bmkx-bmenu-sort-by-bookmark-type',
;;    `bmkx-bmenu-sort-by-creation-time',
;;    `bmkx-bmenu-sort-by-file-name',
;;    `bmkx-bmenu-sort-by-Gnus-thread',
;;    `bmkx-bmenu-sort-by-Info-node-name',
;;    `bmkx-bmenu-sort-by-Info-position',
;;    `bmkx-bmenu-sort-by-last-bookmark-access',
;;    `bmkx-bmenu-sort-by-last-buffer-or-file-access',
;;    `bmkx-bmenu-sort-by-last-local-file-access',
;;    `bmkx-bmenu-sort-by-last-local-file-update',
;;    `bmkx-bmenu-sort-by-local-file-size',
;;    `bmkx-bmenu-sort-by-local-file-type', `bmkx-bmenu-sort-by-url',
;;    `bmkx-bmenu-sort-flagged-before-unflagged',
;;    `bmkx-bmenu-sort-marked-before-unmarked',
;;    `bmkx-bmenu-sort-modified-before-unmodified',
;;    `bmkx-bmenu-sort-tagged-before-untagged',
;;    `bmkx-bmenu-toggle-marked-temporary/savable',
;;    `bmkx-bmenu-toggle-marks', `bmkx-bmenu-toggle-show-only-marked',
;;    `bmkx-bmenu-toggle-show-only-unmarked',
;;    `bmkx-bmenu-toggle-temporary', `bmkx-bmenu-unmark-all',
;;    `bmkx-bmenu-unmark-bookmarks-tagged-all',
;;    `bmkx-bmenu-unmark-bookmarks-tagged-none',
;;    `bmkx-bmenu-unmark-bookmarks-tagged-not-all',
;;    `bmkx-bmenu-unmark-bookmarks-tagged-regexp',
;;    `bmkx-bmenu-unmark-bookmarks-tagged-some',
;;    `bmkx-bmenu-unomit-marked', `bmkx-bmenu-w32-open',
;;    `bmkx-bmenu-w32-open-select', `bmkx-bmenu-w32-open-with-mouse',
;;    `bmkx-define-tags-sort-command'.
;;
;;  Faces defined here:
;;
;;    `bmkx-*-mark', `bmkx->-mark', `bmkx-a-mark',
;;    `bmkx-bad-bookmark', `bmkx-bookmark-file', `bmkx-bookmark-list',
;;    `bmkx-buffer', `bmkx-D-mark', `bmkx-desktop',
;;    `bmkx-file-handler', `bmkx-function', `bmkx-gnus',
;;    `bmkx-heading', `bmkx-info', `bmkx-local-directory',
;;    `bmkx-local-file-with-region', `bmkx-local-file-without-region',
;;    `bmkx-man', `bmkx-no-jump', `bmkx-no-local', `bmkx-non-file',
;;    `bmkx-remote-file', `bmkx-sequence', `bmkx-snippet',
;;    `bmkx-su-or-sudo', `bmkx-t-mark', `bmkx-url',
;;    `bmkx-variable-list', `bmkx-X-mark'.
;;
;;  User options defined here:
;;
;;    `bmkx-bmenu-commands-file',
;;    `bmkx-bmenu-image-bookmark-icon-file',
;;    `bmkx-bmenu-omitted-bookmarks', `bmkx-bmenu-state-file',
;;    `bmkx-propertize-bookmark-names-flag',
;;    `bmkx-bmenu-show-file-not-buffer-flag',
;;    `bmkx-sort-orders-alist', `bmkx-sort-orders-for-cycling-alist'.
;;
;;  Non-interactive functions defined here:
;;
;;    `bmkx--pop-to-buffer-same-window', `bmkx-assoc-delete-all',
;;    `bmkx-bmenu-barf-if-not-in-menu-list',
;;    `bmkx-bmenu-cancel-incremental-filtering',
;;    `bmkx-bmenu-filter-alist-by-annotation-regexp',
;;    `bmkx-bmenu-filter-alist-by-bookmark-name-regexp',
;;    `bmkx-bmenu-filter-alist-by-file-name-regexp',
;;    `bmkx-bmenu-filter-alist-by-tags-regexp',
;;    `bmkx-bmenu-get-marked-files', `bmkx-bmenu-goto-bookmark-named',
;;    `bmkx-bmenu-kill-annotation', `bmkx-bmenu-list-1',
;;    `bmkx-bmenu-mark/unmark-bookmarks-tagged-all/none',
;;    `bmkx-bmenu-mark/unmark-bookmarks-tagged-some/not-all',
;;    `bmkx-bmenu-mode-line', `bmkx-bmenu-mode-line-string',
;;    `bmkx-bmenu-propertize-item', `bmkx-bmenu-read-filter-input',
;;    `bmkx-bmenu-store-org-link' (Emacs 24.4+),
;;    `bmkx-bookmark-data-from-record',
;;    `bmkx-bookmark-name-from-record', `bmkx-face-prop',
;;    `bmkx-bmenu-marked-or-this-or-all', `looking-at-p',
;;    `bmkx-maybe-unpropertize-bookmark-names',
;;    `bmkx-maybe-unpropertize-string', `bmkx-remap',
;;    `bmkx-replace-regexp-in-string',
;;    `bmkx-reverse-multi-sort-order', `bmkx-reverse-sort-order',
;;    `string-match-p', `bookmark-name-from-full-record',
;;    `bookmark-name-from-record',
;;
;;  Internal variables and constants defined here:
;;
;;    `bmkx-bmenu-before-hide-marked-alist',
;;    `bmkx-bmenu-before-hide-unmarked-alist',
;;    `bmkx-bmenu-bookmark-file-menu',
;;    `bmkx-bmenu-define-command-history',
;;    `bmkx-bmenu-define-command-menu', `bmkx-bmenu-delete-menu',
;;    `bmkx-bmenu-filter-function', `bmkx-bmenu-filter-pattern',
;;    `bmkx-bmenu-filter-timer', `bmkx-bmenu-first-time-p',
;;    `bmkx-bmenu-header-lines', `bmkx-bmenu-highlight-menu',
;;    `bmkx-bmenu-line-overlay', `bmkx-bmenu-mark-menu',
;;    `bmkx-bmenu-marked-bookmarks', `bmkx-bmenu-marks-width',
;;    `bmkx-bmenu-mark-types-menu', `bmkx-bmenu-menubar-menu',
;;    `bmkx--bmenu-nb->', `bmkx--bmenu-nb-a', `bmkx--bmenu-nb-D',
;;    `bmkx--bmenu-nb-t', `bmkx--bmenu-nb-X', `bmkx--bmenu-nb-*',
;;    `bmkx-bmenu-omit-menu', `bmkx--bmenu-regexp->',
;;    `bmkx--bmenu-regexp-a', `bmkx--bmenu-regexp-D',
;;    `bmkx--bmenu-regexp-t', `bmkx--bmenu-regexp-X',
;;    `bmkx--bmenu-regexp-*', `bmkx-bmenu-search-menu',
;;    `bmkx-bmenu-show-menu',
;;    `bmkx-bmenu-show-types-menu',`bmkx-bmenu-sort-menu',
;;    `bmkx-bmenu-tags-menu', `bmkx-bmenu-title',
;;    `bmkx-bmenu-toggle-menu', `bmkx-flagged-bookmarks',
;;    `bmkx-last-bmenu-bookmark'.
;;
;;
;;  ***** NOTE: The following commands defined in `bookmark.el'
;;              have been REDEFINED HERE:
;;
;;    `bmkx-list-execute-deletions', `bmkx-list',
;;    `bmkx-list-mark', `bmkx-list-1-window',
;;    `bmkx-list-2-window', `bmkx-list-other-frame',
;;    `bmkx-list-other-window',
;;    `bmkx-list-other-window-with-mouse',
;;    `bmkx-list-show-annotation',
;;    `bmkx-list-switch-other-window',
;;    `bmkx-list-this-window', `bookmark-bmenu-toggle-filenames',
;;    `bmkx-list-unmark'.
;;
;;
;;  ***** NOTE: The following non-interactive functions and macros
;;              defined in `bookmark.el' have been REDEFINED HERE:
;;
;;    `bmkx-list-bookmark', `bmkx-list-check-position',
;;    `bmkx-list-delete', `bmkx-list-delete-backwards',
;;    `bmkx-list-ensure-position' (Emacs 23.2+),
;;    `bmkx-list-hide-filenames', `bmkx-list-mode',
;;    `bmkx-list-show-filenames',
;;    `bmkx-list-surreptitiously-rebuild-list'.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
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
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;

(eval-when-compile (unless (require 'cl-lib nil t)
                     (require 'cl)
                     (defalias 'cl-case 'case)))

(eval-when-compile (require 'easymenu)) ;; easy-menu-create-menu
(eval-when-compile (require 'org nil t)) ;; org-add-link-type

(require 'bookmark)
;; bookmark-alist, bookmark-bmenu-file-column,
;; bookmark-bmenu-hidden-bookmarks, bmkx-list-mode-map,
;; bookmark-bmenu-select, bookmark-get-annotation,
;; bookmark-get-filename, bookmark-get-handler, bookmark-kill-line,
;; bmkx-maybe-load-default-file, bookmark-name-from-full-record,
;; bookmark-name-from-record, bookmark-prop-get


;; `bmkx-list-mode' is defined below via `define-derived-mode' with parent
;; `special-mode', which auto-creates `bmkx-list-mode-map'.  The keymap is
;; populated by `define-key' calls further down.  Pre-declare it so the
;; byte-compiler doesn't complain when those `define-key' forms appear
;; before the `define-derived-mode' is reached at load time.
(defvar bmkx-list-mode-map (make-sparse-keymap)
  "Keymap for `bmkx-list-mode' (the *Bmkx List* buffer).")



;; Some general renamings.  In Emacs 27+ the built-in defines both
;; `bookmark-name-from-record' and `bookmark-name-from-full-record'
;; (the latter as an alias) so we no longer need the cross-aliasing
;; dance that earlier Emacs versions required.
;;
;; The built-in name of `bookmark-get-bookmark-record' is misleading
;; -- it returns only the cdr of the record -- so we keep the more
;; descriptive bmkx- aliases for both helpers.
;;
(defalias 'bmkx-bookmark-data-from-record 'bookmark-get-bookmark-record)
(defalias 'bmkx-bookmark-name-from-record 'bookmark-name-from-full-record)


(eval-when-compile
 (or (condition-case nil
         (load-library "bookmark-x-mac") ; Use load-library to ensure latest .elc.
       (error nil))
     (require 'bookmark-x-mac)))         ; Require, so can load separately if not on `load-path'.
;; bmkx-define-show-only-command, bmkx-define-sort-command, bmkx-menu-bar-make-toggle,
;; bmkx-with-help-window, bmkx-with-output-to-plain-temp-buffer

(put 'bmkx-with-output-to-plain-temp-buffer 'common-lisp-indent-function '(4 &body))


;;; These functions are used in macro `bmkx-define-sort-command'.  The first is used in the macro code
;;; that produces the function code, so its definition is also in `bookmark-x-mac.el'.
;;;
(defun bmkx-replace-regexp-in-string (regexp rep string &optional fixedcase literal subexp start)
  "Replace all matches for REGEXP with REP in STRING and return STRING."
  ; Emacs > 20.
      (replace-regexp-in-string regexp rep string fixedcase literal subexp start)) ; Emacs 20

(defvar bmkx-bmenu-buffer) ; In `bookmark-x.el' (declared again below for clarity).

;;;###autoload (autoload 'bmkx-fit-frame-flag "bookmark-x")
(defcustom bmkx-fit-frame-flag nil
  "Non-nil means shrink the frame to fit Bookmark-X pop-up buffers.
Affects `*Bmkx List*' rendering (refresh, sort, filter) and the
annotation show/edit buffers.  In each case, when the buffer is the
only window in its frame, Bookmark-X calls `fit-frame-to-buffer' to
resize the whole frame to the buffer's content.

Default nil — frames are left alone, which matches expectations under
tiling window managers and multi-frame setups."
  :type 'boolean :group 'bookmark-plus)

(defun bmkx-fit-bmenu-frame ()
  "Fit the current frame to its buffer, if `*Bmkx List*' owns it.
Does nothing unless `bmkx-fit-frame-flag' is non-nil, the selected
window is the only one in its frame, and that window shows the
`*Bmkx List*' buffer."
  (when (and bmkx-fit-frame-flag
             (one-window-p t)
             (eq (selected-window)
                 (get-buffer-window (get-buffer-create bmkx-bmenu-buffer) 0)))
    (fit-frame-to-buffer)))

(defun bmkx-assoc-delete-all (key alist)
  "Delete from ALIST all elements whose car is `equal' to KEY.
Return the modified alist.
Elements of ALIST that are not conses are ignored."
  (while (and (consp (car alist)) (equal (car (car alist)) key))  (setq alist  (cdr alist)))
  (let ((tail  alist)
        tail-cdr)
    (while (setq tail-cdr  (cdr tail))
      (if (and (consp (car tail-cdr))  (equal (car (car tail-cdr)) key))
          (setcdr tail (cdr tail-cdr))
        (setq tail  tail-cdr))))
  alist)


(require 'bookmark-x-1)

;; bmkx-add-tags, bmkx-alpha-p, bmkx-bookmark-creation-cp,
;; bmkx-bookmark-description, bmkx-bookmark-file-bookmark-p,
;; bmkx-bookmark-last-access-cp, bmkx-bookmark-list-bookmark-p,
;; bmkx-buffer-last-access-cp, bmkx-completing-read-buffer-name,
;; bmkx-completing-read-file-name, bmkx-current-bookmark-file,
;; bmkx-current-sort-order, bmkx-describe-bookmark,
;; bmkx-describe-bookmark-internals, bmkx-desktop-bookmark-p,
;; bmkx-edit-bookmark-name-and-location, bmkx-file-alpha-cp,
;; bmkx-file-remote-p, bmkx-function-bookmark-p, bmkx-get-bookmark,
;; bmkx-get-buffer-name, bmkx-get-tags, bmkx-gnus-bookmark-p,
;; bmkx-gnus-cp, bmkx-handler-cp, bmkx-incremental-filter-delay,
;; bmkx-image-bookmark-p, bmkx-info-bookmark-p,
;; bmkx-info-node-name-cp, bmkx-info-position-cp,
;; bmkx-isearch-bookmarks, bmkx-isearch-bookmarks-regexp, bmkx-jump-1,
;; bmkx-last-bookmark-file, bmkx-last-specific-buffer,
;; bmkx-last-specific-file, bmkx-latest-bookmark-alist,
;; bmkx-local-file-bookmark-p, bmkx-local-file-type-cp,
;; bmkx-local-file-accessed-more-recently-cp,
;; bmkx-local-file-updated-more-recently-cp,
;; bmkx-set-sequence-bookmark, bmkx-man-bookmark-p,
;; bmkx-marked-bookmark-p, bmkx-marked-bookmarks-only, bmkx-marked-cp,
;; bmkx-msg-about-sort-order, bmkx-non-file-filename,
;; bmkx-read-tag-completing, bmkx-read-tags-completing,
;; bmkx-refresh-menu-list, bmkx-region-bookmark-p,
;; bmkx-remove-all-tags, bmkx-remove-if, bmkx-remove-tags,
;; bmkx-repeat-command, bmkx-reverse-multi-sort-p,
;; bmkx-reverse-sort-p, bmkx-root-or-sudo-logged-p, bmkx-same-file-p,
;; bmkx-save-menu-list-state, bmkx-sequence-bookmark-p,
;; bmkx-set-tag-value, bmkx-set-tag-value-for-bookmarks,
;; bmkx-set-union, bmkx-snippet-alist-only, bmkx-snippet-bookmark-p,
;; bmkx-some, bmkx-some-marked-p, bmkx-some-unmarked-p,
;; bmkx-sort-omit, bmkx-sort-comparer, bmkx-sorted-alist,
;; bmkx-su-or-sudo-regexp, bmkx-tag-name, bmkx-tags-list,
;; bmkx-url-bookmark-p, bmkx-url-cp, bmkx-unmarked-bookmarks-only,
;; bmkx-variable-list-bookmark-p, bmkx-visited-more-cp

;; bookmark-x-lit.el is an optional dependency.  We cannot (require) it
;; here because it (require)s us, so use declare-function instead.
(declare-function bmkx-get-lighting                "bookmark-x-lit")
(declare-function bmkx-toggle-auto-light-when-jump "bookmark-x-lit")
(declare-function bmkx-toggle-auto-light-when-set  "bookmark-x-lit")

;; Org integration (declared so byte-compile doesn't warn; loaded lazily).
(declare-function org-link-store-props "ol")

;;;;;;;;;;;;;;;;;;;;;;;

;; Quiet the byte-compiler
(defvar bookmark-file-coding-system)    ; In `bookmark.el' (Emacs 25.2+)
(defvar bmkx-auto-light-when-jump)      ; In `bookmark-x-lit.el'.
(defvar bmkx-bmenu-buffer)              ; In `bookmark-x.el'.
(defvar bmkx-bmenu-highlight-menu)      ; Defined in this file (conditionally).
(defvar bmkx-copied-tags)               ; In `bookmark-x-1.el'.
(defvar bmkx-count-multi-mods-as-one-flag) ; In `bookmark-x-1.el'.
(defvar bmkx-current-bookmark-file)     ; In `bookmark-x-1.el'.
(defvar bmkx-edit-bookmark-orig-record) ; In `bookmark-x-1.el'.
(defvar bmkx-incremental-filter-delay)  ; In `bookmark-x-1.el'.
(defvar bmkx-edit-bookmark-records-number) ; In `bookmark-x-1.el'.
(defvar bmkx-last-bookmark-file)        ; In `bookmark-x-1.el'.
(defvar bmkx-last-specific-buffer)      ; In `bookmark-x-1.el'.
(defvar bmkx-last-specific-file)        ; In `bookmark-x-1.el'.
(defvar bmkx-latest-bookmark-alist)     ; In `bookmark-x-1.el'.
(defvar bmkx-modified-bookmarks)        ; In `bookmark-x-1.el'.
(defvar bmkx-non-file-filename)         ; In `bookmark-x-1.el'.
(defvar bmkx-reverse-multi-sort-p)      ; In `bookmark-x-1.el'.
(defvar bmkx-reverse-sort-p)            ; In `bookmark-x-1.el'.
(defvar bmkx-sort-comparer)             ; In `bookmark-x-1.el'.
(defvar bmkx-sorted-alist)              ; In `bookmark-x-1.el'.
(defvar bmkx-sort-orders-alist)         ; Here.
(defvar bmkx-su-or-sudo-regexp)         ; In `bookmark-x-1.el'.
(defvar bmkx-temporary-bookmarking-mode) ; In `bookmark-x-1.el'.
(defvar describe-function-orig-buffer)  ; In `help-fns.el' (Emacs 28+).
(defvar dired-re-mark)                  ; In `dired.el'.
(defvar minibuffer-prompt-properties)   ; Emacs 22+.
(defvar tramp-file-name-regexp)         ; In `tramp.el'.

 
;;(@* "Utility Functions")
;;; Utility Functions ------------------------------------------------

(defun bmkx-remap (old new map &optional _oldmap)
  "Bind command NEW in MAP to all keys currently bound to OLD.
Uses `command-remapping'.  OLDMAP is accepted for backward-compatible
calling but ignored — modern Emacs always has command remapping."
  (define-key map (vector 'remap old) new))

;; This is also in `bookmark-x-lit.el', since it is loaded first but is optional.
;;
(defalias 'bmkx--pop-to-buffer-same-window 'pop-to-buffer-same-window)
 
;;(@* "Faces (Customizable)")
;;; Faces (Customizable) ---------------------------------------------

(defface bmkx->-mark '((((background dark)) (:foreground "Yellow"))
                       (t (:foreground "Blue")))
  ;; (:foreground "Magenta2" :box (:line-width 1 :style pressed-button))))
  "*Face used for a `>' mark in the bookmark list."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-a-mark '((((background dark)) (:background "SaddleBrown"))
                       (t (:background "SkyBlue")))
  "*Face used for an annotation indicator (`a') in the bookmark list."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-bad-bookmark '((t (:foreground "Red" :background "Chartreuse1")))
  "*Face used for a bookmark that seems to be bad: e.g., nonexistent file."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-bookmark-file
    '((((background dark))
       (:foreground "#00005A5AFFFF" :background "#FFFF9B9BFFFF")) ; ~ blue, ~ pink
      (t (:foreground "Orange" :background "DarkGreen")))
  "*Face used for a bookmark-file bookmark."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-bookmark-list
    '((((background dark)) (:foreground "#7474FFFFFFFF" :background "DimGray")) ; ~ cyan
      (t (:foreground "DarkRed" :background "LightGray")))
  "*Face used for a bookmark-list bookmark."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-buffer
    '((((background dark)) (:foreground "#FFFF9B9BFFFF")) ; ~ pink
      (t (:foreground "DarkGreen")))
  "*Face used for a bookmarked existing buffer not associated with a file."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-D-mark '((t (:foreground "Yellow" :background "Red")))
  "*Face used for a deletion mark (`D') in the bookmark list."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-desktop
    '((((background dark)) (:foreground "Orange" :background "DarkSlateBlue"))
      (t (:foreground "DarkBlue" :background "PaleGoldenrod")))
  "*Face used for a bookmarked desktop."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-file-handler
    '((((background dark)) (:background "#FFFF78CB48E1")) ; ~ dark brown
      (t (:background "LightBlue")))
  "*Face used for a bookmark that has a `file-handler' attribute."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-function
    '((((background dark)) (:foreground "#0000EBEB6C6C")) ; ~ green
      (t (:foreground "DeepPink1")))
  "*Face used for a function bookmark: a bookmark that invokes a function."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-gnus
    '((((background dark)) (:foreground "Gold"))
      (t (:foreground "DarkBlue")))
  "*Face used for a Gnus bookmark."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-info
    '((((background dark)) (:foreground "#7474FFFFFFFF")) ; ~ light cyan
      (t (:foreground "DarkRed")))
  "*Face used for a bookmarked Info node."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-local-directory
    '((((background dark))
       (:foreground "Pink" :background "DarkBlue"))
      (t (:foreground "DarkBlue" :background "HoneyDew2")))
  "*Face used for a bookmarked local directory."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-local-file-without-region
    '((((background dark)) (:foreground "White"))
      (t (:foreground "Black")))
  "*Face used for a bookmarked local file (without a region)."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-local-file-with-region
    '((((background dark)) (:foreground "Yellow"))
      (t (:foreground "Blue")))
  "*Face used for a region bookmark in a local file."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-man
    '((((background dark)) (:foreground "Orchid"))
      (t (:foreground "Orange4")))
  "*Face used for a `man' page bookmark."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-*-mark '((t (:foreground "Red" :background "Yellow")))
  "*Face used for a modification mark (`*') in the bookmark list."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-no-jump
    '((t (:foreground "gray50")))
  "*Face used for a bookmark you cannot jump to from `*Bmkx List*'."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-no-local
    '((t (:background "orange")))
  "*Face used for a local file bookmark whose target file does not exist."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-non-file
    '((t (:foreground "MediumSeaGreen")))
  "*Face used for a bookmark not associated with an existing buffer."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-remote-file
    '((((background dark)) (:foreground "#6B6BFFFF2C2C")) ; ~ green
      (t (:foreground "DarkViolet")))
  "*Face used for a bookmarked tramp remote file (/ssh:)."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-sequence
    '((((background dark)) (:foreground "DeepSkyBlue"))
      (t (:foreground "DarkOrange2")))
  "*Face used for a sequence bookmark: one composed of other bookmarks."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-snippet
    '((t (:inherit region)))
  "*Face used for a bookmarked snippet."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-su-or-sudo '((t (:foreground "Red")))
  "*Face used for a bookmarked tramp file (/su: or /sudo:)."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-t-mark '((((background dark)) (:foreground "Magenta"))
                       (t (:foreground "#000093F402A2"))) ; a medium green
  "*Face used for a tags mark (`t') in the bookmark list."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-url
    '((((background dark)) (:foreground "#7474FFFF7474")) ; ~ green
      (t (:foreground "DarkMagenta")))
  "*Face used for a bookmarked URL."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-variable-list
    '((((background dark)) (:foreground "#FFFF8D947477")) ; ~ salmon
      (t (:foreground "#0000726B8B8B")))     ; ~dark cyan
  "*Face used for a bookmarked list of variables."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-X-mark '((t (:foreground "Red")))
  "*Face used for a temporary-bookmark indicator (`X') in the bookmark list."
  :group 'bookmark-plus :group 'faces)

;; $$$$$$ Not used now - using `bmkx-url' instead.
;; (defface bmkx-w3m
;;     '((((background dark)) (:foreground "yellow"))
;;       (t (:foreground "DarkMagenta")))
;;   "*Face used for a bookmarked w3m url."
;;   :group 'bookmark-plus :group 'faces)

;; Instead of built-in `bookmark-menu-heading' (defined in Emacs 22+), to use a better default.
(defface bmkx-heading '((((background dark)) (:foreground "Yellow"))
                        (t (:foreground "Blue")))
  "*Face used to highlight the headings in various Bookmark-X buffers."
  :group 'bookmark-plus :version "22.1" :group 'faces)
 
;;(@* "User Options (Customizable)")
;;; User Options (Customizable) --------------------------------------


;;;###autoload (autoload 'bmkx-bmenu-omitted-bookmarks "bookmark-x")
(defcustom bmkx-bmenu-omitted-bookmarks ()
  "*List of names of omitted bookmarks.
They are generally not available for display in the bookmark list.
You can, however, use \\<bmkx-list-mode-map>\
`\\[bmkx-bmenu-show-only-omitted-bookmarks]' to see them.
You can then mark some of them and use `\\[bmkx-bmenu-omit/unomit-marked]'
 to make those that are marked available again for the bookmark list."
  ;; $$$$$$ TODO: Create a customize :type `bookmark-name'
  ;;              and provide completion for filling out the field.
  :type '(repeat (string :tag "Bookmark name")) :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-bmenu-commands-file "bookmark-x")
(defcustom bmkx-bmenu-commands-file (convert-standard-filename "~/.emacs-bmk-bmenu-commands.el")
  "*File for saving user-defined bookmark-list commands.
This must be an absolute file name (possibly containing `~') or nil
\(it is not expanded).

You can use `\\[bmkx-list-defuns-in-commands-file]' to list the
commands defined in the file and how many times each is defined.

NOTE: Each time you define a command using \\<bmkx-list-mode-map>\
`\\[bmkx-bmenu-define-command]', `\\[bmkx-bmenu-define-full-snapshot-command]', \
`\\[bmkx-bmenu-define-jump-marked-command], or `\\[bmkx-define-tags-sort-command]',
it is saved in the file.  The new definition is simply appended to the
file - old definitions of the same command are not overwritten.  So
you might want to clean up the file occasionally, to remove any old,
unused definitions.  This is especially advisable if you used \
`\\[bmkx-bmenu-define-full-snapshot-command]',
because such command definitions can be very large."
  :type '(file  :tag "File for saving menu-list state") :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-bmenu-state-file "bookmark-x")
(defcustom bmkx-bmenu-state-file (convert-standard-filename "~/.emacs-bmk-bmenu-state.el")
  "*File for saving `*Bmkx List*' state when you quit bookmark list.
This must be an absolute file name (possibly containing `~') or nil
\(it is not expanded).

The state is also saved when you quit Emacs, even if you don't quit
the bookmark list first (using \\<bmkx-list-mode-map>`\\[bmkx-bmenu-quit]').

Set this to nil if you do not want to restore the bookmark list as it
was the last time you used it."
  :type '(choice
          (const :tag "Do not save and restore menu-list state" nil)
          (file  :tag "File for saving menu-list state"))
  :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-bmenu-image-bookmark-icon-file "bookmark-x")
(defcustom bmkx-bmenu-image-bookmark-icon-file
  (and (display-images-p)
       (let ((bmk-img    (convert-standard-filename "~/.emacs-bmk-bmenu-image-file-icon.png"))
             (emacs-img  (convert-standard-filename (concat data-directory "images/gnus/exit-gnus.xpm"))))
         (or (and (file-readable-p bmk-img)    bmk-img)
             (and (file-readable-p emacs-img)  emacs-img))))
  "*Iconic image file to show next to image-file bookmarks.
If nil, show no image.  Otherwise, this is an absolute file name,
possibly containing `~', (the value is not expanded).

Use any image file that Emacs can display, but you probably want to
use a small, iconic image - say 16x16 pixels.

The default image, which you are sure to have in any Emacs version
that supports images, is 24x24 pixels.  That wastes vertical space, so
you probably want to use something smaller.

If you don't have another image that you prefer, try this one (16x16):
https://www.emacswiki.org/emacs/BookmarkPlusImageFileDefaultIcon"
  :type '(choice
          (file  :tag "Use iconic image file")
          (const :tag "Show no image"))
  :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-bmenu-show-file-not-buffer-flag "bookmark-x")
(defcustom bmkx-bmenu-show-file-not-buffer-flag nil
  "Non-nil means show bookmark file names, not buffer names.
This applies to the location shown to the right of the bookmark
name.  (You hide/show this column using \\<bmkx-list-mode-map>\
`\\[bookmark-bmenu-toggle-filenames]'.)

This applies only if a bookmark records no explicit `location' entry
and it records both a buffer name and a file name.  If it records
`location' then that is what is shown.  If it records only a file name
or only a buffer name then that is shown."
  :type 'boolean :group 'bookmark-plus)

(defcustom bmkx-bmenu-filename-style 'abbreviate
  "How to render file paths in the `*Bookmark List*' buffer.

Long paths often get truncated at the right edge of the window,
hiding the basename — which is usually the most informative part.
This option controls how the path is shortened before display.

Values:

  `full'        Show the recorded path unchanged.
  `abbreviate'  Replace the home directory with `~' via
                `abbreviate-file-name'.  Standard Emacs convention.
  `shrink'      Collapse each parent directory to its first
                character: `~/.e/m/b/file.el'.  Keeps the basename
                intact and shows hierarchy depth.
  `basename'    Show only the basename.

Only paths that look like absolute filenames are reformatted.
Buffer names, `location' strings, and other non-path locations
pass through unchanged.

Toggle interactively with `\\<bookmark-bmenu-mode-map>\
\\[bmkx-bmenu-cycle-filename-style]' in the bookmark list."
  :type '(choice (const :tag "Full path"                    full)
                 (const :tag "Abbreviate home as ~"         abbreviate)
                 (const :tag "Shrink parents to first char" shrink)
                 (const :tag "Basename only"                basename))
  :group 'bookmark-plus)

(defun bmkx-bmenu--shrink-path (path)
  "Return PATH with each parent directory collapsed to its first character.
PATH is first passed through `abbreviate-file-name'.  The basename is
left intact, and a leading `~' or `/' is preserved.

Examples:
  /Users/dmg/.emacs.d/modules/bookmark-x/bookmark-x-1.el
    => ~/.e/m/b/bookmark-x-1.el
  /etc/init.d/cron => /e/i/cron
  /root => /root"
  (let* ((abbrev    (abbreviate-file-name path))
         (basename  (file-name-nondirectory abbrev))
         (dir       (file-name-directory abbrev)))
    (cond
     ((or (null dir) (string-empty-p dir))
      abbrev)
     (t
      (let* ((leading  (cond ((string-prefix-p "~/" dir) "~/")
                             ((string-prefix-p "/"  dir) "/")
                             (t                          "")))
             (body     (substring dir (length leading)))
             ;; Drop the trailing slash so `split-string' does not give a "".
             (body     (if (string-suffix-p "/" body)
                           (substring body 0 -1)
                         body))
             (parts    (if (string-empty-p body) () (split-string body "/")))
             (shrunk   (mapconcat (lambda (p)
                                    (cond ((string-empty-p p) "")
                                          ((string-prefix-p "." p) (substring p 0 (min 2 (length p))))
                                          (t (substring p 0 1))))
                                  parts
                                  "/")))
        (concat leading
                shrunk
                (if (string-empty-p shrunk) "" "/")
                basename))))))

(defun bmkx-bmenu-format-filename (location)
  "Format LOCATION for display in the bookmark list buffer.
Dispatch on `bmkx-bmenu-filename-style'.  Non-path LOCATION strings
\(buffer names, `--Unknown location--', etc.) pass through unchanged."
  (cond
   ((not (stringp location))
    (format "%s" location))
   ;; Only reformat absolute paths.  Buffer names and other
   ;; non-path locations are returned as-is.
   ((not (or (string-prefix-p "/"  location)
             (string-prefix-p "~/" location)))
    location)
   (t
    (pcase bmkx-bmenu-filename-style
      ('full       location)
      ('abbreviate (abbreviate-file-name location))
      ('basename   (file-name-nondirectory (directory-file-name location)))
      ('shrink     (bmkx-bmenu--shrink-path location))
      (_           location)))))

(defcustom bmkx-bmenu-show-tags-flag t
  "Non-nil means show a tags column in the `*Bookmark List*' buffer.
The column appears between the bookmark name and the file/location
column, and is `bmkx-bmenu-tags-column-width' characters wide.
Toggle interactively with `\\<bookmark-bmenu-mode-map>\
\\[bmkx-bmenu-toggle-tags-column]'."
  :type 'boolean :group 'bookmark-plus)

(defcustom bmkx-bmenu-tags-column-width 18
  "Width of the tags column when `bmkx-bmenu-show-tags-flag' is non-nil.
The joined tag names (separated by `,') are truncated with `…' if they
exceed this width, and padded with spaces if shorter."
  :type 'integer :group 'bookmark-plus)

(defcustom bmkx-bmenu-name-column-width nil
  "Maximum width of the bookmark-name column in `*Bookmark List*'.
nil means use the longest name in the current display.  An integer
truncates longer names to that width (with a trailing `…').  Use this
with `bmkx-bmenu-show-tags-flag' to keep the layout stable when
bookmark names vary in length."
  :type '(choice (const :tag "Auto (longest name)" nil)
                 (integer :tag "Maximum width"))
  :group 'bookmark-plus)

(defun bmkx-bmenu--truncate-name (name width)
  "Return NAME truncated to WIDTH chars, with `…' if cut.
WIDTH nil means do not truncate."
  (cond
   ((or (null width) (<= (string-width name) width)) name)
   ((<= width 1) (substring name 0 width))
   (t (concat (substring name 0 (- width 1)) "…"))))

(defun bmkx-bmenu--format-tags-for-column (tags width)
  "Return a string of exactly WIDTH chars representing TAGS.
TAGS is the list returned by `bmkx-get-tags' (each element is a string
or a (NAME . VALUE) cons).  The names are joined with `,' (no space),
truncated with `…' if too long, and padded with spaces if too short."
  (let* ((names  (mapcar (lambda (tg) (if (consp tg) (car tg) tg)) (or tags ())))
         (joined (mapconcat #'identity names ",")))
    (cond
     ((<= width 0)
      "")
     ((<= (string-width joined) width)
      (concat joined (make-string (- width (string-width joined)) ?\s)))
     ((= width 1)
      "…")
     (t
      (concat (substring joined 0 (- width 1)) "…")))))

;; This is a general option.  It is in this file because it is used mainly by the bmenu code.
(defcustom bmkx-sort-orders-alist ()
  "*Alist of all available sort functions.
This is a pseudo option - you probably do NOT want to customize this.
Instead:

 * To add a new sort function to this list, use macro
   `bmkx-define-sort-command'.  It defines a new sort function
   and automatically adds it to this list.

 * To have fewer sort orders available for cycling by \\<bmkx-list-mode-map>\
`\\[bmkx-bmenu-change-sort-order-repeat]'...,
   customize option `bmkx-sort-orders-for-cycling-alist'.

Each alist element has the form (SORT-ORDER . COMPARER):

 SORT-ORDER is a short string or symbol describing the sort order.
 Examples: \"by last access time\", \"by bookmark name\".

 COMPARER compares two bookmarks.  It must be acceptable as a value of
 `bmkx-sort-comparer'."
  :type '(alist
          :key-type (choice :tag "Sort order" string symbol)
          :value-type (choice
                       (const    :tag "None (do not sort)" nil)
                       (function :tag "Sorting Predicate")
                       (list     :tag "Sorting Multi-Predicate"
                        (repeat (function :tag "Component Predicate"))
                        (choice
                         (const    :tag "None" nil)
                         (function :tag "Final Predicate")))))
  :group 'bookmark-plus)

;;(@* "Internal Variables")
;;; Internal Variables -----------------------------------------------

(defconst bmkx-bmenu-header-lines 5
  "Number of lines used for the `*Bmkx List*' header.")

(defconst bmkx-bmenu-marks-width 4
  "Number of columns (chars) used for the `*Bmkx List*' marks columns.
Bookmark names thus begin in this column number (since zero-based).")


(defvar bmkx-bmenu-before-hide-marked-alist ()
  "Copy of `bookmark-alist' made before hiding marked bookmarks.")

(defvar bmkx-bmenu-before-hide-unmarked-alist ()
  "Copy of `bookmark-alist' made before hiding unmarked bookmarks.")

(defvar bmkx-bmenu-define-command-history ()
  "History of names of commands you have defined for `*Bmkx List*'.")

(defvar bmkx-bmenu-filter-function  nil "Latest filtering function for `*Bmkx List*' display.")

(defvar bmkx-bmenu-filter-pattern "" "Regexp for incremental filtering.")

(defvar bmkx-bmenu-filter-timer nil "Timer used for incremental filtering.")

(defvar bmkx-bmenu-first-time-p t
  "Non-nil means bookmark list has not yet been shown after quitting it.
Quitting the list or the Emacs session resets this to t.
The first time the list is displayed, it is set to nil.")

(defvar bmkx-bmenu-marked-bookmarks ()
  "Names of the marked bookmarks.
This includes possibly omitted bookmarks, that is, bookmarks listed in
`bmkx-bmenu-omitted-bookmarks'.")

(defvar bmkx-bmenu-title "" "Latest title for `*Bmkx List*' display.")

(defvar bmkx-flagged-bookmarks ()
  "Alist of bookmarks that are flagged for deletion in `*Bmkx List*'.")

;; This is a general variable.  It is in this file because it is used only in the bmenu code.
(defvar bmkx-last-bmenu-bookmark nil "The name of the last bookmark current in the bookmark list.")
 
;;(@* "Menu List Replacements (`bookmark-bmenu-*')")
;;; Menu List Replacements (`bookmark-bmenu-*') ----------------------



;; Differences from built-in `bookmark.el':
;;
;; 1. Return t.  Value doesn't mean anything (didn't anyway), but must be non-nil for built-in Emacs.
;; 2. Do not count lines.  Just make sure we're on a bookmark line.
;;
(defalias 'bmkx-list-check-position 'bmkx-list-ensure-position)
(defun bmkx-list-ensure-position ()
  "Move to the beginning of the nearest bookmark line."
  (beginning-of-line)
  (unless (bmkx-list-bookmark)
    (if (and (bolp)  (eobp))
        (beginning-of-line 0)
      (goto-char (point-min))
      (forward-line bmkx-bmenu-header-lines)))
  t)                                    ; Older built-in bookmark code depends on non-nil value.


;; Differences from built-in `bookmark.el':
;;
;; 1. Don't use `tabulated-list-mode' (Emacs 28+).
;; 2 Add bookmark to `bmkx-bmenu-marked-bookmarks'.  Delete it from `bmkx-flagged-bookmarks'.
;; 3. Don't call `bmkx-list-ensure-position' again at end.
;; 4. Raise error if not in `*Bmkx List*'.
;; 5. Narrower scope for `with-buffer-modified-unmodified' and `let'.
;; 6. If current sort is `s >' (marked first or last), and it was unmarked before, then re-sort.
;; 7. Added optional arg NO-RE-SORT-P to inhibit #5.
;; 8. Added optional arg MSG-P.
;; 9. Call `bmkx-bmenu-mode-line'.
;;
;;;###autoload (autoload 'bmkx-list-mark "bookmark-x")
(defun bmkx-list-mark (&optional no-re-sort-p msg-p) ; Bound to `m' in bookmark list
  "Mark the bookmark on this line, using mark `>'.
Add its name to `bmkx-bmenu-marked-bookmarks', after propertizing it
with the full bookmark as `bmkx-full-record'.

If the bookmark was unmarked before, and if the sort order is marked
first or last (`s >'), then re-sort.

Non-interactively:
* Non-nil optional arg NO-RE-SORT-P inhibits re-sorting.
* Non-nil optional arg MSG-P means display a status message."
  (interactive (list nil 'MSG-P))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-list-ensure-position)
  (beginning-of-line)
  (with-buffer-modified-unmodified
      (let ((inhibit-read-only  t))
        (delete-char 1) (insert ?>) (put-text-property (1- (point)) (point) 'face 'bmkx->-mark)))
  (let* ((bname           (bmkx-list-bookmark))
         (bmk             (bmkx-bookmark-record-from-name bname))
         (was-unmarked-p  nil))
    ;; This is the same as `add-to-list' with `eq' (not available for Emacs 20-21).
    (unless (memq bname bmkx-bmenu-marked-bookmarks)
      (setq bmkx-bmenu-marked-bookmarks  (cons bname bmkx-bmenu-marked-bookmarks)
            was-unmarked-p               t))
    (setq bmkx-flagged-bookmarks  (delq bmk bmkx-flagged-bookmarks))
    (unless no-re-sort-p
      ;; If it was unmarked but now is marked, and if sort order is `s >', then re-sort.
      (when (and was-unmarked-p  (equal bmkx-sort-comparer '((bmkx-marked-cp) bmkx-alpha-p)))
        (let ((curr-bmk  (bmkx-list-bookmark)))
          (bmkx-list-surreptitiously-rebuild-list (not msg-p))
          (when curr-bmk (bmkx-bmenu-goto-bookmark-named curr-bmk))))))
  (forward-line 1)
  (when (fboundp 'bmkx-bmenu-mode-line) (bmkx-bmenu-mode-line)))


;; Differences from built-in `bookmark.el':
;;
;;  1. Don't use `tabulated-list-mode' (Emacs 28+).
;;  2. Remove bookmark from `bmkx-bmenu-marked-bookmarks' and `bmkx-flagged-bookmarks'.
;;  3. Use `bmkx-delete-bookmark-name-from-list', not `delete'.
;;  4. Don't call `bmkx-list-ensure-position' again at end.
;;  5. Raise error if not in `*Bmkx List*'.
;;  6. Narrower scope for `with-buffer-modified-unmodified' and `let'.
;;  7. If current sort is `s >' (marked first or last), and it was marked before, then re-sort.
;;  8. Added optional arg NO-RE-SORT-P to inhibit #6.
;;  9. Added optional arg MSG-P.
;; 10. Call `bmkx-bmenu-mode-line'.
;;
;;;###autoload (autoload 'bmkx-list-unmark "bookmark-x")
(defun bmkx-list-unmark (&optional backup no-re-sort-p msg-p) ; Bound to `u' in bookmark list
  "Unmark the bookmark on this line, then move down to the next.
With a prefix argument, move up instead.

If the bookmark was marked before, and if the sort order is marked
first or last (`s >'), then re-sort.

Non-interactively:
* Non-nil optional arg BACKUP (prefix arg) means move up.
* Non-nil optional arg NO-RE-SORT-P inhibits re-sorting.
* Non-nil optional arg MSG-P means display a status message."
  (interactive (list current-prefix-arg nil 'MSG-P))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-list-ensure-position)
  (beginning-of-line)
  (with-buffer-modified-unmodified
      (let ((inhibit-read-only  t))
        (delete-char 1) (insert " ")))
  (let ((was-marked-p  (memq (bmkx-list-bookmark) bmkx-bmenu-marked-bookmarks)))
    (setq bmkx-bmenu-marked-bookmarks  (bmkx-delete-bookmark-name-from-list
                                        (bmkx-list-bookmark) bmkx-bmenu-marked-bookmarks)
          bmkx-flagged-bookmarks       (delq (bmkx-bookmark-record-from-name (bmkx-list-bookmark))
                                             bmkx-flagged-bookmarks))
    (unless no-re-sort-p
      ;; If it was marked but now is unmarked, and if sort order is `s >', then re-sort.
      (when (and was-marked-p  (equal bmkx-sort-comparer '((bmkx-marked-cp) bmkx-alpha-p)))
        (let ((curr-bmk  (bmkx-list-bookmark)))
          (bmkx-list-surreptitiously-rebuild-list (not msg-p))
          (when curr-bmk (bmkx-bmenu-goto-bookmark-named curr-bmk))))))
  (forward-line (if backup -1 1))
  (when (fboundp 'bmkx-bmenu-mode-line) (bmkx-bmenu-mode-line)))


;; Differences from built-in `bookmark.el':
;;
;; 1. Don't use `tabulated-list-mode' (Emacs 28+).
;; 2. Do not use `bmkx-list-ensure-position' as a test - it always returns non-nil anyway.
;;    And don't call it again the end.
;; 3. Use `bmkx-delete-bookmark-name-from-list', not `delete'.
;; 4. Use face `bmkx-D-mark' on the `D' flag.
;; 5. Raise error if not in buffer `*Bmkx List*'.
;; 6. Remove bookmark from `bmkx-bmenu-marked-bookmarks'.  Add it to `bmkx-flagged-bookmarks'.
;; 7. Call `bmkx-bmenu-mode-line'.
;;
;;;###autoload (autoload 'bmkx-bmenu-flag-for-deletion "bookmark-x")
(defalias 'bmkx-bmenu-flag-for-deletion 'bmkx-list-delete) ; A better name.
;;;###autoload (autoload 'bmkx-list-delete "bookmark-x")
(defun bmkx-list-delete ()         ; Bound to `d', `k' in bookmark list
  "Flag this bookmark for deletion, using mark `D'.
Use `\\<bmkx-list-mode-map>\\[bmkx-list-execute-deletions]' to carry out \
the deletions."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (beginning-of-line)
  (bmkx-list-ensure-position)
  (with-buffer-modified-unmodified
      (let ((inhibit-read-only  t))
        (delete-char 1) (insert ?D) (put-text-property (1- (point)) (point) 'face 'bmkx-D-mark)))
  (when (bmkx-list-bookmark)       ; Should never be nil, but just to be safe.
    (setq bmkx-bmenu-marked-bookmarks  (bmkx-delete-bookmark-name-from-list
                                        (bmkx-list-bookmark) bmkx-bmenu-marked-bookmarks))
    ;; This is the same as `add-to-list' with `eq' (not available for Emacs 20-21).
    (let ((bmk  (bmkx-bookmark-record-from-name (bmkx-list-bookmark))))
      (unless (memq bmk bmkx-flagged-bookmarks)
        (setq bmkx-flagged-bookmarks  (cons bmk bmkx-flagged-bookmarks)))))
  (forward-line 1)
  (when (fboundp 'bmkx-bmenu-mode-line) (bmkx-bmenu-mode-line)))


;; Differences from built-in `bookmark.el':
;;
;; Do not move forward another line at end.  Leave point above flagged bookmark.
;;
;;;###autoload (autoload 'bmkx-bmenu-flag-for-deletion-backwards "bookmark-x")
(defalias 'bmkx-bmenu-flag-for-deletion-backwards 'bmkx-list-delete-backwards) ; A better name.
;;;###autoload (autoload 'bmkx-list-delete-backwards "bookmark-x")
(defun bmkx-list-delete-backwards ()
  "Mark bookmark on this line to be deleted, then move up one line.
To carry out the deletions that you've marked, use \\<bmkx-list-mode-map>\
\\[bmkx-list-execute-deletions]."
  (interactive)
  (bmkx-list-delete)
  (forward-line -2)
  (bmkx-list-ensure-position))


;; Differences from built-in `bookmark.el':
;;
;; 1. Added optional arg NO-MSG-P.
;; 2. Rebuild the menu list using the last filtered alist in use, `bmkx-latest-bookmark-alist'.
;; 3. Update the menu-list title.
;;
(defun bmkx-list-surreptitiously-rebuild-list (&optional no-msg-p)
  "Rebuild the bookmark list, if it exists.
Non-nil optional arg NO-MSG-P means do not show progress messages."
  (when (get-buffer bmkx-bmenu-buffer)
    (unless no-msg-p (message "Updating bookmark-list display..."))
    (save-excursion (save-window-excursion (let ((bookmark-alist  bmkx-latest-bookmark-alist))
                                             (bmkx-list 'filteredp))))
    (unless no-msg-p (message "Updating bookmark-list display...done"))))


;; Differences from built-in `bookmark.el':
;;
;; 1. Added arg FILTEREDP.
;; 2. Handles also region bookmarks and buffer (non-file) bookmarks.
;; 3. Uses `pop-to-buffer', not `switch-to-buffer', so we respect `special-display-*'
;;    (but keep `one-window-p' if that's the case).
;; 4. If option `bmkx-bmenu-state-file' is non-nil, then the first time since the last quit
;;     (or the last Emacs session) restores the last menu-list state.
;; 5. If option `bmkx-bmenu-commands-file' is non-nil, then read that file, which contains
;;    user-defined `*Bmkx List*' commands.
;; 6. Many differences in the display itself - see the doc.
;;
;;;###autoload (autoload 'bmkx-list "bookmark-x")
(defun bmkx-list (&optional filteredp msg-p) ; Bound to `C-x x e', `C-x r l'
  "Display a list of existing bookmarks, in buffer `*Bmkx List*'.
The leftmost column of a bookmark entry shows `D' if the bookmark is
 flagged for deletion, or `>' if it is marked normally.
The second column shows `t' if the bookmark has tags.
The third  column shows `a' if the bookmark has an annotation.

The following faces are used for the list entries.
Use `customize-face' if you want to change the appearance.

 `bmkx-bad-bookmark', `bmkx-bookmark-file', `bmkx-bookmark-list',
 `bmkx-buffer', `bmkx-desktop', `bmkx-file-handler', `bmkx-function',
 `bmkx-gnus', `bmkx-info', `bmkx-local-directory',
 `bmkx-local-file-without-region', `bmkx-local-file-with-region',
 `bmkx-man', `bmkx-no-jump', `bmkx-no-local', `bmkx-non-file',
 `bmkx-remote-file', `bmkx-sequence', `bmkx-snippet',
 `bmkx-su-or-sudo', `bmkx-url', `bmkx-variable-list'

If option `bmkx-bmenu-state-file' is non-nil then the state of the
displayed bookmark list is saved when you quit it, and it is restored
when you next use this command.  That saved state is not restored,
however, if it represents a different file from the current bookmark
file.

If you call this interactively when buffer `*Bmkx List*' exists,
that buffer is refreshed to show all current bookmarks, and any
markings are removed.  If you instead want to show the buffer in its
latest state then just do that: use `C-x b' or similar.  If you want
to refresh the displayed buffer, to show the latest state, reflecting
any additions, deletions, renamings, and so on, use \\<bmkx-list-mode-map>\
`\\[bmkx-bmenu-refresh-menu-list]'.


Non-interactively:

 - Non-nil optional argument FILTEREDP means the bookmark list has
   been filtered, which means:

   * Use `bmkx-bmenu-title' not the default menu-list title.
   * Do not reset `bmkx-latest-bookmark-alist' to `bookmark-alist'.

 - Non-nil optional arg MSG-P means display progress messages."
  (interactive "i\np")
  (bmkx-maybe-load-default-file)
  (when msg-p (message "Gathering bookmarks to display..."))
  (when (and bmkx-bmenu-first-time-p  bmkx-bmenu-commands-file
             (file-readable-p bmkx-bmenu-commands-file))
    (when (file-directory-p bmkx-bmenu-commands-file)
      (error "`%s' is a directory, not a file" bmkx-bmenu-commands-file))
    (with-current-buffer (let ((enable-local-variables  ())
                               (emacs-lisp-mode-hook    nil))
                           (find-file-noselect bmkx-bmenu-commands-file))
      (goto-char (point-min))
      (while (not (eobp)) (condition-case nil (eval (read (current-buffer))) (error nil)))
      (kill-buffer (current-buffer))))
  (cond ((and bmkx-bmenu-first-time-p  bmkx-bmenu-state-file ; Restore from state file.
              (file-readable-p bmkx-bmenu-state-file))
         (when (file-directory-p bmkx-bmenu-state-file)
           (error "`%s' is a directory, not a file" bmkx-bmenu-state-file))
         (let ((state  ()))
           (with-current-buffer (let ((enable-local-variables  nil)
                                      (emacs-lisp-mode-hook    nil))
                                  (find-file-noselect bmkx-bmenu-state-file))
             (goto-char (point-min))
             (setq state  (condition-case nil (read (current-buffer)) (error nil)))
             (kill-buffer (current-buffer)))
           (let ((last-bookmark-file-from-state  (cdr (assq 'last-bookmark-file state))))
             (when (and (consp state)
                        ;; If bookmark file has changed, then do not use state saved from other file.
                        (or (not last-bookmark-file-from-state)
                            (bmkx-same-file-p last-bookmark-file-from-state
                                              bmkx-current-bookmark-file)))
               (setq bmkx-sort-comparer                (cdr (assq 'last-sort-comparer                state))
                     bmkx-reverse-sort-p               (cdr (assq 'last-reverse-sort-p               state))
                     bmkx-reverse-multi-sort-p         (cdr (assq 'last-reverse-multi-sort-p         state))
                     bmkx-latest-bookmark-alist        (cdr (assq 'last-latest-bookmark-alist        state))
                     bmkx-bmenu-omitted-bookmarks      (cdr (assq 'last-bmenu-omitted-bookmarks      state))
                     bmkx-bmenu-marked-bookmarks       (cdr (assq 'last-bmenu-marked-bookmarks       state))
                     bmkx-bmenu-filter-function        (cdr (assq 'last-bmenu-filter-function        state))
                     bmkx-bmenu-filter-pattern         (or (cdr (assq 'last-bmenu-filter-pattern     state))
                                                           "")
                     bmkx-bmenu-title                  (cdr (assq 'last-bmenu-title                  state))
                     bmkx-last-bmenu-bookmark          (cdr (assq 'last-bmenu-bookmark               state))
                     bmkx-last-specific-buffer         (cdr (assq 'last-specific-buffer              state))
                     bmkx-last-specific-file           (cdr (assq 'last-specific-file                state))
                     bookmark-bmenu-toggle-filenames   (cdr (assq 'last-bmenu-toggle-filenames       state))
                     bmkx-last-bookmark-file           (or  (cdr (assq 'last-previous-bookmark-file  state))
                                                            bmkx-current-bookmark-file)
                     bmkx-current-bookmark-file        last-bookmark-file-from-state
                     bmkx-bmenu-before-hide-marked-alist
                     (cdr (assq 'last-bmenu-before-hide-marked-alist   state))
                     bmkx-bmenu-before-hide-unmarked-alist
                     (cdr (assq 'last-bmenu-before-hide-unmarked-alist state))))))
         (setq bmkx-bmenu-first-time-p  nil)
         (let ((bookmark-alist  (bmkx-refresh-latest-bookmark-list))) ; This sets *-latest-* also.
           (bmkx-bmenu-list-1 'filteredp nil msg-p))
         (when bmkx-last-bmenu-bookmark
           (with-current-buffer (get-buffer bmkx-bmenu-buffer)
             (bmkx-bmenu-goto-bookmark-named bmkx-last-bmenu-bookmark))))
        (t
         (setq bmkx-bmenu-first-time-p  nil)
         (bmkx-bmenu-list-1 filteredp (or msg-p  (not (get-buffer bmkx-bmenu-buffer))) msg-p))))

(defun bmkx-bmenu-list-1 (filteredp reset-p interactivep)
  "Helper for `bmkx-list'.
See `bmkx-list' for the description of FILTEREDP.
Reset `bmkx-modified-bookmarks' and `bmkx-flagged-bookmarks'.
Non-nil RESET-P means reset `bmkx-bmenu-marked-bookmarks' also.
Non-nil INTERACTIVEP means `bmkx-list' was called
 interactively, so display the bookmark list and communicate sort order.

Display goes through `pop-to-buffer-same-window' by default, which
opens the bookmark list in the currently-selected window.  To put it
elsewhere (a side window, a dedicated frame, the previously-used
window), add an entry for buffer name `*Bmkx List*' to
`display-buffer-alist' -- it takes precedence over our default."
  (setq bmkx-modified-bookmarks  ()
        bmkx-flagged-bookmarks   ())
  (when reset-p (setq bmkx-bmenu-marked-bookmarks  ()))
  (if interactivep
      (pop-to-buffer-same-window (get-buffer-create bmkx-bmenu-buffer))
    (set-buffer (get-buffer-create bmkx-bmenu-buffer)))
  (let* ((inhibit-read-only       t)
         (title                   (if (and filteredp bmkx-bmenu-title  (not (equal "" bmkx-bmenu-title)))
                                      bmkx-bmenu-title
                                    "All Bookmarks"))
         (show-image-file-icon-p  (and (display-images-p)
                                       bmkx-bmenu-image-bookmark-icon-file
                                       (file-readable-p bmkx-bmenu-image-bookmark-icon-file))))
    (erase-buffer)
    (remove-images (point-min) (point-max))
    (insert (format "%s\n%s\n" title (make-string (length title) ?-)))
    (add-text-properties (point-min) (point) (bmkx-face-prop 'bmkx-heading))
    (goto-char (point-min))
    (insert (format "Bookmark file:\n%s\n\n" bmkx-current-bookmark-file))
    (forward-line bmkx-bmenu-header-lines)
    (let* ((show-tags-p    bmkx-bmenu-show-tags-flag)
           (tag-width      bmkx-bmenu-tags-column-width)
           (name-width-cfg bmkx-bmenu-name-column-width)
           (longest-name   0)
           (name-area      0)
           (name-end-col   0)
           (max-width      0)
           name markedp flaggedp tags annotation start)
      (setq bmkx-sorted-alist  (bmkx-sort-omit bookmark-alist
                                               (and (not (eq bmkx-bmenu-filter-function
                                                             'bmkx-omitted-alist-only))
                                                    bmkx-bmenu-omitted-bookmarks)))
      (dolist (bmk  bmkx-sorted-alist)
        (setq longest-name  (max longest-name
                                 (string-width (bmkx-bookmark-name-from-record bmk)))))
      (setq name-area     (or name-width-cfg longest-name)
            name-end-col  (+ bmkx-bmenu-marks-width name-area)
            max-width     (if show-tags-p
                              (+ name-end-col 1 tag-width)
                            name-end-col))
      (dolist (bmk  bmkx-sorted-alist)
        (setq name        (bmkx-bookmark-name-from-record bmk)
              markedp     (bmkx-marked-bookmark-p bmk)
              flaggedp    (bmkx-flagged-bookmark-p bmk)
              tags        (bmkx-get-tags bmk)
              annotation  (bookmark-get-annotation bmk)
              start       (+ bmkx-bmenu-marks-width (point)))
        (cond (flaggedp (insert "D") (put-text-property (1- (point)) (point) 'face 'bmkx-D-mark))
              (markedp  (insert ">") (put-text-property (1- (point)) (point) 'face 'bmkx->-mark))
              (t        (insert " ")))
        (if (null tags)
            (insert " ")
          (insert "t") (put-text-property (1- (point)) (point) 'face 'bmkx-t-mark))
        (cond ((bmkx-temporary-bookmark-p bmk)
               (insert "X") (put-text-property (1- (point)) (point) 'face 'bmkx-X-mark))
              ((and annotation  (not (string-equal annotation "")))
               (insert "a") (put-text-property (1- (point)) (point) 'face 'bmkx-a-mark))
              (t (insert " ")))
        (if (not (memq bmk bmkx-modified-bookmarks))
            (insert " ")
          (insert "*")
          (put-text-property (1- (point)) (point) 'face 'bmkx-*-mark))
        (when (and (featurep 'bookmark-x-lit)  (bmkx-get-lighting bmk)) ; Highlight highlight overrides.
          (put-text-property (1- (point)) (point) 'face 'bmkx-light-mark))
        (when (and (bmkx-image-bookmark-p bmk)  show-image-file-icon-p)
          (let ((image  (create-image bmkx-bmenu-image-bookmark-icon-file nil nil :ascent 95)))
            (when image (put-image image (point)))))
        (insert (bmkx-bmenu--truncate-name name name-area))
        (when show-tags-p
          (move-to-column name-end-col t)
          (insert " ")
          (insert (bmkx-bmenu--format-tags-for-column tags tag-width)))
        (move-to-column max-width t)
        (bmkx-bmenu-propertize-item bmk start (point))
        (insert "\n"))
      (goto-char (point-min)) (forward-line bmkx-bmenu-header-lines)
      (bmkx-list-mode)
      ;; `bmkx-list-mode' (via `define-derived-mode') calls
      ;; `kill-all-local-variables', so any buffer-local we want the
      ;; subsequent filename insertion to see must be set AFTER it.
      (when (or show-tags-p  name-width-cfg)
        (setq-local bookmark-bmenu-file-column
                    (max bookmark-bmenu-file-column (+ max-width 2))))
      (when (and bookmark-alist  bookmark-bmenu-toggle-filenames)
        (bmkx-list-toggle-filenames t 'NO-MSG-P))
      (bmkx-fit-bmenu-frame)))
  (when (fboundp 'bmkx-bmenu-mode-line) (bmkx-bmenu-mode-line))
  (when (and interactivep  bmkx-sort-comparer) (bmkx-msg-about-sort-order (bmkx-current-sort-order))))


;; Differences from built-in `bookmark.el':
;;
;; Redefined.
;; 1. Don't use `tabulated-list-mode' (Emacs 28+).
;; 2. Get name of the current bookmark from text property `bmkx-bookmark-name'.
;; 3. Added optional arg FULL, to return full bookmark record.
;; 4. Use `condition-case' in case we're at eob (so cannot advance).
;;
(defun bmkx-list-bookmark (&optional full)
  "Return the name of the bookmark on this line.
Return nil if no bookmark on this line.
Non-nil optional FULL means return the bookmark record, not the name."
  (condition-case nil
      (let ((name  (save-excursion (forward-line 0) (forward-char bmkx-bmenu-marks-width)
                                   (get-text-property (point) 'bmkx-bookmark-name))))
        (if full (and name (assoc name bookmark-alist)) name))
    (error nil)))


;; Differences from built-in `bookmark.el':
;;
;; 1. Mode-line major-mode name is different, and indicates whether in temporary bookmarking minor mode.
;; 2. Don't derive from `tabulated-list-mode' (Emacs 28+).
;; 3. Doc string is different.
;;
(define-derived-mode bmkx-list-mode special-mode "Bookmarks"
  "Major mode for editing a list of bookmarks.

Each line represents an Emacs bookmark.  Keys without prefix `C-x' are
available only here (in `*Bmkx List*').  Other keys are available
everywhere.

Remember that you can see all bindings for a prefix key by hitting it,
then `C-h'.  E.g., `s C-h' to see keys with prefix `s' (sorting keys).

If the `casual-lib' package is loaded, key `c' opens a Transient menu
of common commands (a discoverable alternative to the keymap).

More bookmarking help below.


Help - Bookmark Info
--------------------

\\<bmkx-list-mode-map>\
`\\[bookmark-bmenu-toggle-filenames]'\t- Toggle showing filenames next to bookmarks
`\\[bmkx-bmenu-cycle-filename-style]'\t- Cycle filename display style: full -> ~/path -> ~/.e/m/b -> basename
\t  (see option `bmkx-bmenu-filename-style')
`\\[bmkx-bmenu-toggle-tags-column]'\t- Toggle the tags column
\t  (see options `bmkx-bmenu-show-tags-flag', `bmkx-bmenu-tags-column-width',
\t   `bmkx-bmenu-name-column-width')
`\\[bmkx-bmenu-describe-this-bookmark]'
\t- Show information about bookmark       (`C-u': internal form)
`\\[bmkx-bmenu-describe-this+move-down]'
\t- Show the info, then move to next bookmark
`\\[bmkx-bmenu-describe-this+move-up]'\t- Show the info, then move to previous bookmark
`\\[bmkx-bmenu-describe-marked]'\t- Show info about the marked bookmarks  (`C-u': internal form)
`\\[bookmark-bmenu-locate]'\t- Show location of bookmark (in minibuffer)
`\\[bmkx-list-show-annotation]'\t- Show bookmark's annotation
`\\[bookmark-bmenu-show-all-annotations]'\t- Show the annotations of all annotated bookmarks

`\\[bmkx-list-defuns-in-commands-file]'
\t- List the commands defined in `bmkx-bmenu-commands-file'


Bookmark-List Display (`*Bmkx List*')
-----------------------------------------

`\\[bmkx-toggle-saving-menu-list-state]'\t- Toggle autosaving bookmark-list display state
`\\[bmkx-save-menu-list-state]'\t- Save bookmark-list display state

`\\[bmkx-bmenu-refresh-menu-list]'\t- Refresh display to current bookmark list  (`C-u': from file)
`\\[bmkx-bmenu-show-all]'\t- Show all bookmarks
`\\[bmkx-toggle-bookmark-set-refreshes]'
\t- Toggle whether `bmkx-set' refreshes the bookmark list

`\\[bmkx-bmenu-mode-status-help]'\t- Show this help
`\\[bmkx-bmenu-quit]'\t- Quit (`*Bmkx List*')


Bookmark Files
--------------

`\\[bmkx-toggle-saving-bookmark-file]'\t- Toggle autosaving to the current bookmark file
`\\[bookmark-bmenu-save]'\t- Save bookmarks now (`C-u': Save As... - prompt for file)
`\\[bmkx-empty-file]'
\t- Empty existing bookmark file or create new, empty one

`C-u \\[bmkx-bmenu-refresh-menu-list]'\t- Revert to bookmarks in the bookmark file    (overwrite load)
`\\[bmkx-switch-bookmark-file-create]'\t- Switch to a different bookmark file         (overwrite load)
`C-u \\[bmkx-switch-bookmark-file-create]'
\t- Switch back to the previous bookmark file   (overwrite load)
`\\[bookmark-bmenu-load]'\t- Add bookmarks from a different bookmark file    (extra load)
`\\[bmkx-bmenu-load-marked-bookmark-file-bookmarks]'\t- Load marked bookmark-file bookmarks\
             (extra load)

`\\[bmkx-bmenu-move-marked-to-bookmark-file]'\t- Move the marked bookmarks to a bookmark file
`\\[bmkx-bmenu-copy-marked-to-bookmark-file]'\t- Copy the marked bookmarks to a bookmark file
`\\[bmkx-bmenu-create-bookmark-file-from-marked]'\t- Copy the marked bookmarks to a new bookmark file
`C-u \\[bmkx-bmenu-create-bookmark-file-from-marked]'\t- Same, plus create bookmark-file bookmark for it


General
-------

Here:

`\\[bmkx-bmenu-dired-marked]'\t- Open Dired for the marked file and directory bookmarks
`\\[bmkx-bmenu-make-sequence-from-marked]'
\t- Create a sequence bookmark from the marked bookmarks
`\\[bmkx-temporary-bookmarking-mode]'\t- Toggle temporary-only bookmarking (new, empty bookmark file)

Anywhere:

\\<global-map>\
`\\[bmkx-toggle-autotemp-on-set]'
\t- Toggle making bookmarks temporary when setting them
`\\[bmkx-set-bookmark-file-bookmark]'\t- Create a bookmark to a bookmark file
\t(`\\[bmkx-bookmark-file-jump]' to load it, `C-u \\[bmkx-bookmark-file-jump]' to switch to it)
`\\[bmkx-delete-bookmarks]'\t- Delete some bookmarks at point or all in buffer
`\\[bmkx-make-function-bookmark]'\t- Create a function bookmark

`\\[bmkx-choose-navlist-of-type]'\t- Set navlist to bookmarks of a type you choose
`\\[bmkx-choose-navlist-from-bookmark-list]'\t- Set navlist to bookmarks of a bookmark-list bookmark
`\\[bmkx-navlist-bmenu-list]'\t- Open `*Bmkx List*' for bookmarks in navlist

`\\[bmkx-this-file/buffer-bmenu-list]'
\t- Open `*Bmkx List*' for bookmarks in current file/buffer
`\\[bmkx-switch-to-bookmark-file-this-file/buffer]'\t- Switch to bookmark file for current file/buffer
`\\[bmkx-save-bookmarks-this-file/buffer]'\t- Save bookmarks for current file/buffer to a file
\\<bmkx-list-mode-map>


Create/Set Bookmarks (anywhere)
--------------------

`\\[bmkx-toggle-autonamed-bmkx-set/delete]'\t- Set/delete an autonamed bookmark here
`\\[bmkx-autofile-set]'\t- Set and autoname a bookmark for a file
`\\[bmkx-file-target-set]'\t- Set a bookmark for a file
`\\[bmkx-url-target-set]'\t- Set a bookmark for a URL
`\\[bmkx-bookmark-set-confirm-overwrite]'\t- Set a bookmark here
`\\[bmkx-set-desktop-bookmark]'\t- Set a bookmark for the current desktop
`\\[bmkx-set-bookmark-file-bookmark]'\t- Set a bookmark for a bookmark file
`\\[bmkx-set-snippet-bookmark]'\t- Save the region text as a snippet bookmark


Jump to (Visit) Bookmarks
-------------------------

`\\[bmkx-list-this-window]'\t- This bookmark in the same window
`\\[bmkx-list-other-window]'\t- This bookmark in another window
`\\[bmkx-list-switch-other-window]'\t- This bookmark in other window, without selecting it
`\\[bmkx-list-2-window]'\t- This bookmark and last-visited bookmark
`\\[bmkx-list-1-window]'\t- This bookmark in a full-frame window
`\\[bmkx-list-other-frame]'
\t- This bookmark in another frame

`\\[bmkx-bmenu-jump-to-marked]'\t- Bookmarks marked `>', in other windows

Prefix `j' uses another window; prefix `J' reuses this window:

`\\[bmkx-jump-other-window]'\t- Bookmark by name
`\\[bmkx-jump-in-navlist-other-window]'\t- Bookmark in the navigation list
`\\[bmkx-lighted-jump-other-window]'\t- Highlighted bookmark

`\\[bmkx-jump-to-type-other-window]'\t- Bookmark by type
`\\[bmkx-autonamed-jump-other-window]'\t- Autonamed bookmark
`\\[bmkx-autonamed-this-buffer-jump-other-window]'\t- Autonamed bookmark in this buffer
`\\[bmkx-temporary-jump-other-window]'\t- Temporary bookmark

`\\[bmkx-autofile-jump-other-window]'\t- Autofile bookmark
`\\[bmkx-dired-jump-other-window]'\t- Dired bookmark
`\\[bmkx-file-jump-other-window]'\t- File or directory bookmark
`\\[bmkx-dired-this-dir-jump-other-window]'\t- Dired bookmark for this dir
`\\[bmkx-file-this-dir-jump-other-window]'\t- Bookmark for a file or subdir in this dir
`\\[bmkx-local-file-jump-other-window]'\t- Local-file bookmark
`\\[bmkx-remote-file-jump-other-window]'\t- Remote-file bookmark
`\\[bmkx-non-file-jump-other-window]'\t- Non-file (buffer) bookmark

`\\[bmkx-desktop-jump]'\t- Desktop bookmark
`\\[bmkx-bookmark-list-jump]'\t- Bookmark-list bookmark
`\\[bmkx-bookmark-file-jump]'\t- Bookmark-file bookmark

`\\[bmkx-region-jump-other-window]'\t- Region bookmark (restore region)
`\\[bmkx-snippet-to-kill-ring]'\t- Snippet bookmark (copy to `kill-ring')
`\\[bmkx-image-jump-other-window]'\t- Image-file bookmark
`\\[bmkx-info-jump-other-window]'\t- Info bookmark
`\\[bmkx-man-jump-other-window]'\t- `man'-page bookmark
`\\[bmkx-gnus-jump-other-window]'\t- Gnus bookmark
`\\[bmkx-url-jump-other-window]'\t- URL bookmark
`\\[bmkx-variable-list-jump]'\t- Variable-list bookmark

`\\[bmkx-some-tags-jump-other-window]'\t- Bookmark having some tags you specify
`\\[bmkx-tag-jump-other-window]'\t- Bookmark that has every tag you specify
`\\[bmkx-all-tags-jump-other-window]'\t- Bookmark whose tags are all in a set you specify
`\\[bmkx-some-tags-regexp-jump-other-window]'\t- Bookmark having a tag that matches a regexp
`\\[bmkx-all-tags-regexp-jump-other-window]'\t- Bookmark having all its tags match a regexp
`\\[bmkx-file-some-tags-jump-other-window]'\t- File bookmark having some tags you specify
`\\[bmkx-file-all-tags-jump-other-window]'\t- File bookmark having each tag you specify
`\\[bmkx-file-some-tags-regexp-jump-other-window]'\t- File bookmark having a tag that matches a regexp
`\\[bmkx-file-all-tags-regexp-jump-other-window]'\t- File bookmark having all its tags match a regexp
`\\[bmkx-file-this-dir-some-tags-jump-other-window]'\t- File in this dir having some tags you specify
`\\[bmkx-file-this-dir-all-tags-jump-other-window]'\t- File in this dir having each tag you specify
`\\[bmkx-file-this-dir-some-tags-regexp-jump-other-window]'\t- \
File in this dir having a tag that matches a regexp
`\\[bmkx-file-this-dir-all-tags-regexp-jump-other-window]'\t- \
File in this dir having all its tags match a regexp


Autonamed Bookmarks
-------------------

`\\[bmkx-toggle-autonamed-bmkx-set/delete]'\t- Create/delete autonamed bookmark at point
`C-u \\[bmkx-toggle-autonamed-bmkx-set/delete]'\t- Delete all autonamed bookmarks in current buffer
`\\[bmkx-autonamed-jump-other-window]'\t\t- Jump to an autonamed bookmark
`\\[bmkx-autonamed-this-buffer-jump-other-window]'\t\t- Jump to an autonamed bookmark in a given buffer


Cycle Bookmarks (anywhere)
---------------

`\\[bmkx-next-bookmark-this-file/buffer-repeat]'...\t- Next bookmark in buffer         (C-x x n, C-x x C-n)
`\\[bmkx-previous-bookmark-this-file/buffer-repeat]'...\t- Prev bookmark in buffer         (C-x x p, \
C-x x C-p)
`\\[bmkx-next-bookmark-repeat]'...- Next bookmark in navlist        (C-x x f, C-x x C-f)
`\\[bmkx-previous-bookmark-repeat]'...\t- Prev bookmark in navlist        (C-x x b, C-x x C-b)
`\\[bmkx-next-bookmark-w32-repeat]'...\t- MS Windows `Open' next     in navlist   (C-x x next)
`\\[bmkx-previous-bookmark-w32-repeat]'...- MS Windows `Open' previous in navlist  (C-x x prior)
`\\[bmkx-next-lighted-this-buffer-repeat]'...- Next highlighted bookmark in buffer  (C-x x C-down)
`\\[bmkx-previous-lighted-this-buffer-repeat]'...\t- Prev highlighted bookmark in buffer     (C-x x C-up)

 Similar, but not bound to keys by default:
  \\[bmkx-next-autonamed-bookmark-repeat]        (and `previous')
  \\[bmkx-next-bookmark-list-bookmark-repeat]    (and `previous')
  \\[bmkx-next-desktop-bookmark-repeat]          (and `previous')
  \\[bmkx-next-dired-bookmark-repeat]            (and `previous')
  \\[bmkx-next-eww-bookmark-repeat]              (and `previous')
  \\[bmkx-next-file-bookmark-repeat]             (and `previous')
  \\[bmkx-next-gnus-bookmark-repeat]             (and `previous')
  \\[bmkx-next-info-bookmark-repeat]             (and `previous')
  \\[bmkx-next-lighted-bookmark-repeat]          (and `previous')
  \\[bmkx-next-local-file-bookmark-repeat]       (and `previous')
  \\[bmkx-next-man-bookmark-repeat]              (and `previous')
  \\[bmkx-next-non-file-bookmark-repeat]         (and `previous')
  \\[bmkx-next-remote-file-bookmark-repeat]      (and `previous')
  \\[bmkx-next-specific-buffers-bookmark-repeat] (and `previous')
  \\[bmkx-next-specific-files-bookmark-repeat]   (and `previous')
  \\[bmkx-next-url-bookmark-repeat]              (and `previous')
  \\[bmkx-next-variable-list-bookmark-repeat]    (and `previous')


Search-and-Replace in Bookmark Targets (here, in sort order)
--------------------------------------

`\\[bmkx-bmenu-isearch-marked-bookmarks]'\t- Isearch the marked bookmarks            (`C-u': all)
`\\[bmkx-bmenu-isearch-marked-bookmarks-regexp]'\t- Regexp-isearch the marked bookmarks     (`C-u': all)
`\\[bmkx-bmenu-search-marked-bookmarks-regexp]'\t- Regexp-search the marked file bookmarks (`C-u': all)
`\\[bmkx-bmenu-query-replace-marked-bookmarks-regexp]'\t\t- Query-replace the marked file bookmarks


Mark/Unmark Bookmarks
---------------------

\(Mark means `>'.  Flag means `D'.   See also `Tags', below.)

`\\[bmkx-bmenu-flag-for-deletion]'\t- Flag bookmark `D' for deletion, then move down
`\\[bmkx-bmenu-flag-for-deletion-backwards]'\t- Flag bookmark `D' for deletion, then move up

`\\[bmkx-list-mark]'\t- Mark bookmark
`\\[bmkx-list-unmark]'\t- Unmark bookmark                    (`C-u': move up one line)
`\\[bookmark-bmenu-backup-unmark]'\t- Unmark previous bookmark (move up, then unmark)

`\\[bmkx-bmenu-mark-all]'\t- Mark all bookmarks
`\\[bmkx-bmenu-regexp-mark]'\t- Mark all bookmarks whose names match a regexp
`\\[bmkx-bmenu-unmark-all]'\t- Unmark all bookmarks              (`C-u': interactive query)
`\\[bmkx-bmenu-toggle-marks]'\t- Toggle marks: unmark the marked and mark the unmarked

`\\[bmkx-bmenu-mark-autofile-bookmarks]'\t- Mark autofile bookmarks
`\\[bmkx-bmenu-mark-autonamed-bookmarks]'\t- Mark autonamed bookmarks
`\\[bmkx-bmenu-mark-temporary-bookmarks]'\t- Mark temporary bookmarks
`\\[bmkx-bmenu-mark-lighted-bookmarks]'\t- Mark highlighted bookmarks (requires `bookmark-x-lit.el)

`\\[bmkx-bmenu-mark-non-file-bookmarks]'\t- Mark non-file (i.e. buffer) bookmarks
`\\[bmkx-bmenu-mark-dired-bookmarks]'\t- Mark Dired bookmarks
`\\[bmkx-bmenu-mark-file-bookmarks]'\t- Mark file & directory bookmarks          (`C-u': local only)
`\\[bmkx-bmenu-mark-gnus-bookmarks]'\t- Mark Gnus bookmarks
`\\[bmkx-bmenu-mark-info-bookmarks]'\t- Mark Info bookmarks
`\\[bmkx-bmenu-mark-non-invokable-bookmarks]'\t- Mark non-invokable bookmarks
`\\[bmkx-bmenu-mark-image-bookmarks]'\t- Mark image-file bookmarks
`\\[bmkx-bmenu-mark-desktop-bookmarks]'\t- Mark desktop bookmarks
`\\[bmkx-bmenu-mark-man-bookmarks]'\t- Mark `man' page bookmarks (that's `M' twice, not Meta-M)
`\\[bmkx-bmenu-mark-orphaned-local-file-bookmarks]'\t- Mark orphaned local file/dir bookmarks  (`C-u': \
remote also)
`\\[bmkx-bmenu-mark-region-bookmarks]'\t- Mark region bookmarks
`\\[bmkx-bmenu-mark-function-bookmarks]'\t- Mark function bookmarks
`\\[bmkx-bmenu-mark-url-bookmarks]'\t- Mark URL bookmarks
`\\[bmkx-bmenu-mark-variable-list-bookmarks]'\t- Mark variable-list bookmarks
`\\[bmkx-bmenu-mark-w3m-bookmarks]'\t- Mark W3M (URL) bookmarks
`\\[bmkx-bmenu-mark-snippet-bookmarks]'\t- Mark snippet bookmarks
`\\[bmkx-bmenu-mark-bookmark-file-bookmarks]'\t- Mark bookmark-file bookmarks
`\\[bmkx-bmenu-mark-bookmark-list-bookmarks]'\t- Mark bookmark-list bookmarks
`

Modify, Delete Bookmarks
------------------------

\(See also `Tags', next.)

`\\[bmkx-bmenu-edit-bookmark-name-and-location]'\t- Rename and/or relocate bookmark
`\\[bookmark-bmenu-relocate]'\t- Relocate bookmark
`\\[bmkx-bmenu-relocate-marked]'\t- Relocate marked bookmarks
`\\[bmkx-bmenu-edit-tags]'\t- Edit bookmark's tags
`\\[bookmark-bmenu-edit-annotation]'\t- Edit bookmark's annotation
`\\[bmkx-bmenu-edit-annotations-for-marked]'\t- Edit annotations of marked bookmarks            (`C-u': all)
`\\[bmkx-bmenu-edit-bookmark-record]'\t- Edit internal Lisp record for bookmark
`\\[bmkx-bmenu-edit-marked]'\t- Edit internal Lisp records of marked bookmarks  (`C-u': all)
`\\[bmkx-bmenu-toggle-temporary]'\t- Toggle temporary/savable status of bookmark
`\\[bmkx-bmenu-toggle-marked-temporary/savable]'\t- Toggle temporary/savable status of marked bookmarks
`\\[bmkx-delete-all-temporary-bookmarks]'
\t- Delete all temporary bookmarks
`\\[bmkx-list-execute-deletions]'\t- Delete (visible) bookmarks flagged `D'
`\\[bmkx-bmenu-delete-marked]'\t- Delete (visible) bookmarks marked `>'


Bookmark Tags
-------------

Here:

`\\[bmkx-bmenu-copy-tags]'\t- Copy tags from this bookmark (for subsequent pasting)
`\\[bmkx-bmenu-paste-add-tags]'\t- Paste tags (copied from another) to this bookmark
`\\[bmkx-bmenu-paste-replace-tags]'\t- Replace tags for this bookmark (with those copied)
`\\[bmkx-add-tags]'\t- Add some tags to a bookmark
`\\[bmkx-remove-tags]'\t- Remove some tags from a bookmark (`C-u': from all bookmarks)
`\\[bmkx-remove-all-tags]'\t- Remove all tags from a bookmark
`\\[bmkx-remove-tags-from-all]'\t- Remove some tags from all bookmarks
`\\[bmkx-rename-tag]'\t- Rename a tag in all bookmarks
`\\[bmkx-list-all-tags]'\t- List all tags used in any bookmarks (`C-u': show tag values)
`\\[bmkx-bmenu-list-tags-of-marked]'\t- List tags used in marked bookmarks  (`C-u': show tag values)
`\\[bmkx-bmenu-edit-tags]'\t- Edit bookmark's tags
`\\[bmkx-bmenu-set-tag-value]'\t- Set the value of a tag (as attribute)

`\\[bmkx-bmenu-set-tag-value-for-marked]'\t- Set value of a tag, for each marked bookmark    (`C-u': all)
`\\[bmkx-bmenu-paste-add-tags-to-marked]'
\t- Add tags copied from a bookmark to those marked (`C-u': all)
`\\[bmkx-bmenu-paste-replace-tags-for-marked]'\t- Replace tags of marked with copied tags \
        (`C-u': all)
`\\[bmkx-bmenu-add-tags-to-marked]'\t- Add some tags to the marked bookmarks           (`C-u': all)
`\\[bmkx-bmenu-remove-tags-from-marked]'\t- Remove some tags from the marked bookmarks      (`C-u': all)

`\\[bmkx-bmenu-mark-bookmarks-tagged-regexp]'\t- Mark bookmarks having at least one \
tag that matches a regexp
`\\[bmkx-bmenu-mark-bookmarks-tagged-some]'\t- Mark bookmarks having at least one tag \
in a set    (OR)
`\\[bmkx-bmenu-mark-bookmarks-tagged-all]'\t- Mark bookmarks having all of the tags \
in a set     (AND)
`\\[bmkx-bmenu-mark-bookmarks-tagged-none]'
\t- Mark bookmarks not having any of the tags in a set (NOT OR)
`\\[bmkx-bmenu-mark-bookmarks-tagged-not-all]'
\t- Mark bookmarks not having all of the tags in a set (NOT AND)

`\\[bmkx-bmenu-unmark-bookmarks-tagged-regexp]'\t- Unmark bookmarks having a \
tag that matches a regexp
`\\[bmkx-bmenu-unmark-bookmarks-tagged-some]'\t- Unmark bookmarks having at least one \
tag in a set  (OR)
`\\[bmkx-bmenu-unmark-bookmarks-tagged-all]'\t- Unmark bookmarks having all of the tags \
in a set   (AND)
`\\[bmkx-bmenu-unmark-bookmarks-tagged-none]'
\t- Unmark bookmarks not having any tags in a set      (NOT OR)
`\\[bmkx-bmenu-unmark-bookmarks-tagged-not-all]'
\t- Unmark bookmarks not having all tags in a set      (NOT AND)

Anywhere:

\\<global-map>\
`\\[bmkx-list-all-tags]'\t- List all tags
`\\[bmkx-edit-tags]'\t- Edit the tags of a bookmark
`\\[bmkx-rename-tag]'\t- Rename a tag (everywhere)
`\\[bmkx-copy-tags]'\t- Copy tags from a bookmark (for subsequent pasting)
`\\[bmkx-paste-add-tags]'\t- Add (paste) tags copied from a bookmark
`\\[bmkx-paste-replace-tags]'\t- Replace (paste) a bookmark's tags with copied tags
`\\[bmkx-add-tags]'\t- Add some tags to a bookmark
`\\[bmkx-remove-tags]'\t- Remove some tags from a bookmark
`\\[bmkx-remove-all-tags]'\t- Remove ALL tags from a bookmark
`\\[bmkx-remove-tags-from-all]'\t- Remove some tags from ALL bookmarks
`\\[bmkx-tag-a-file]'\t- Add tags to a file (create/update autofile bookmark)
`\\[bmkx-untag-a-file]'\t- Remove tags from a file (an autofile bookmark)
`\\[bmkx-set-tag-value]'\t- Set a tag value for a bookmark
`\\[bmkx-set-tag-value-for-navlist]'\t- Set a tag value for each bookmark in navlist
\\<bmkx-list-mode-map>


Bookmark Highlighting
---------------------

`\\[bmkx-bmenu-show-only-lighted-bookmarks]'\t- Show only the highlighted bookmarks
`\\[bmkx-bmenu-set-lighting]'\t- Set highlighting for bookmark
`\\[bmkx-bmenu-set-lighting-for-marked]'\t- Set highlighting for marked bookmarks
`\\[bmkx-bmenu-light]'\t- Highlight bookmark
`\\[bmkx-bmenu-unlight]'\t- Unhighlight bookmark
`\\[bmkx-bmenu-mark-lighted-bookmarks]'\t- Mark the highlighted bookmarks
`\\[bmkx-bmenu-light-marked]'\t- Highlight the marked bookmarks
`\\[bmkx-bmenu-unlight-marked]'\t- Unhighlight the marked bookmarks
`\\[bmkx-light-bookmark-this-buffer]'\t- Highlight a bookmark in current buffer
`\\[bmkx-unlight-bookmark-this-buffer]'\t- Unhighlight a bookmark in current buffer
`\\[bmkx-light-bookmarks]'\t- Highlight bookmarks (see prefix arg)
`\\[bmkx-unlight-bookmarks]'\t- Unhighlight bookmarks (see prefix arg)
`\\[bmkx-bookmarks-lighted-at-point]'\t- List bookmarks highlighted at point
`\\[bmkx-unlight-bookmark-here]'\t- Unhighlight a bookmark at point or on same line
`\\[bmkx-lighted-jump-other-window]'\t- Jump to a highlighted bookmark (other window)


Sort `*Bmkx List*' (`s C-h' to see this)
----------------------

\(Repeat to cycle normal/reversed/off, except as noted.)

`\\[bmkx-reverse-sort-order]'\t- Reverse current sort direction       (repeat to toggle)
`\\[bmkx-reverse-multi-sort-order]'\t- Complement sort predicate decisions  (repeat \
to toggle)
`\\[bmkx-bmenu-change-sort-order-repeat]'\t- Cycle sort orders                    (repeat \
to cycle)

`\\[bmkx-bmenu-sort-marked-before-unmarked]'\t- Sort marked (`>') bookmarks first
`\\[bmkx-bmenu-sort-flagged-before-unflagged]'\t- Sort flagged (`D') bookmarks first
`\\[bmkx-bmenu-sort-modified-before-unmodified]'\t- Sort modified (`*') bookmarks first
`\\[bmkx-bmenu-sort-tagged-before-untagged]'\t- Sort tagged (`t') bookmarks first
`\\[bmkx-bmenu-sort-annotated-before-unannotated]'\t- Sort annotated (`a') bookmarks first

`\\[bmkx-bmenu-sort-by-creation-time]'\t- Sort by bookmark creation time
`\\[bmkx-bmenu-sort-by-last-buffer-or-file-access]'\t- Sort by last buffer or file \
access
`\\[bmkx-bmenu-sort-by-last-bookmark-access]'\t- Sort by last bookmark access time
`\\[bmkx-bmenu-sort-by-Gnus-thread]'\t- Sort by Gnus thread: group, article, message
`\\[bmkx-bmenu-sort-by-Info-node-name]'\t- Sort by Info manual, node, position in node
`\\[bmkx-bmenu-sort-by-Info-position]'\t- Sort by Info manual, position in manual
`\\[bmkx-bmenu-sort-by-bookmark-type]'\t- Sort by bookmark type
`\\[bmkx-bmenu-sort-by-bookmark-name]'\t- Sort by bookmark name
`\\[bmkx-bmenu-sort-by-url]'\t- Sort by URL
`\\[bmkx-bmenu-sort-by-bookmark-visit-frequency]'\t- Sort by bookmark visit frequency

`\\[bmkx-bmenu-sort-by-last-local-file-access]'\t- Sort by last local file access
`\\[bmkx-bmenu-sort-by-local-file-type]'\t- Sort by local file type: file, symlink, dir
`\\[bmkx-bmenu-sort-by-file-name]'\t- Sort by file name
`\\[bmkx-bmenu-sort-by-local-file-size]'\t- Sort by local file size
`\\[bmkx-bmenu-sort-by-last-local-file-update]'\t- Sort by last local file update (edit)


Hide/Show (Filtering `*Bmkx List*')
---------------------------------------

`\\[bmkx-bmenu-show-all]'\t- Show all bookmarks
`\\[bmkx-bmenu-toggle-show-only-marked]'\t- Toggle showing only marked bookmarks
`\\[bmkx-bmenu-toggle-show-only-unmarked]'\t- Toggle showing only unmarked bookmarks

`\\[bmkx-bmenu-show-only-autonamed-bookmarks]'\t- Show only autonamed bookmarks
`\\[bmkx-bmenu-show-only-autofile-bookmarks]'\t- Show only autofile bookmarks
`\\[bmkx-bmenu-show-only-temporary-bookmarks]'\t- Show only temporary bookmarks

`\\[bmkx-bmenu-show-only-non-file-bookmarks]'\t- Show only non-file (i.e. buffer) bookmarks
`\\[bmkx-bmenu-show-only-dired-bookmarks]'\t- Show only Dired bookmarks
`\\[bmkx-bmenu-show-only-file-bookmarks]'\t- Show only file & directory bookmarks     (`C-u': local only)
`\\[bmkx-bmenu-show-only-gnus-bookmarks]'\t- Show only Gnus bookmarks
`\\[bmkx-bmenu-show-only-info-bookmarks]'\t- Show only Info bookmarks
`\\[bmkx-bmenu-show-only-non-invokable-bookmarks]'\t- Show only non-invokable bookmarks
`\\[bmkx-bmenu-show-only-image-bookmarks]'\t- Show only image-file bookmarks
`\\[bmkx-bmenu-show-only-orphaned-local-file-bookmarks]'\t- Show only orphaned local file \
bookmarks (`C-u': remote also)
`\\[bmkx-bmenu-show-only-desktop-bookmarks]'\t- Show only desktop bookmarks
`\\[bmkx-bmenu-show-only-man-bookmarks]'\t- Show only `man' page bookmarks
`\\[bmkx-bmenu-show-only-region-bookmarks]'\t- Show only region bookmarks
`\\[bmkx-bmenu-show-only-function-bookmarks]'\t- Show only function bookmarks
`\\[bmkx-bmenu-show-only-url-bookmarks]'\t- Show only URL bookmarks
`\\[bmkx-bmenu-show-only-eww-bookmarks]'\t- Show only EWW bookmarks
`\\[bmkx-bmenu-show-only-w3m-bookmarks]'\t- Show only W3M bookmarks
`\\[bmkx-bmenu-show-only-variable-list-bookmarks]'\t- Show only variable-list bookmarks
`\\[bmkx-bmenu-show-only-tagged-bookmarks]'\t- Show only tagged bookmarks
`\\[bmkx-bmenu-show-only-untagged-bookmarks]'\t- Show only untagged bookmarks
`\\[bmkx-bmenu-show-only-snippet-bookmarks]'\t- Show only snippet bookmarks
`\\[bmkx-bmenu-show-only-bookmark-file-bookmarks]'\t- Show only bookmark-file bookmarks
`\\[bmkx-bmenu-show-only-bookmark-list-bookmarks]'\t- Show only bookmark-list bookmarks

`\\[bmkx-bmenu-filter-annotation-incrementally]'\t- Incrementally show bookmarks whose \
annotations match regexp
`\\[bmkx-bmenu-filter-bookmark-name-incrementally]'\t- Incrementally show only bookmarks \
whose names match a regexp
`\\[bmkx-bmenu-filter-file-name-incrementally]'\t- Incrementally show only bookmarks whose \
files match a regexp
`\\[bmkx-bmenu-filter-tags-incrementally]'\t- Incrementally show only bookmarks whose tags \
match a regexp


Omit/Un-omit (`*Bmkx List*')
--------------------------------

`\\[bmkx-bmenu-show-only-omitted-bookmarks]'\t- Show (only) the omitted bookmarks
`\\[bmkx-bmenu-show-all]'\t- Show the un-omitted bookmarks (all)
`\\[bmkx-bmenu-omit/unomit-marked]'\t- Omit the marked bookmarks; un-omit them if after \
`\\[bmkx-bmenu-show-only-omitted-bookmarks]'
`\\[bmkx-unomit-all]'\t- Un-omit all omitted bookmarks


Define Commands for `*Bmkx List*'
-------------------------------------

`\\[bmkx-bmenu-define-command]'
\t- Define a command to restore the current sort order & filter
`\\[bmkx-bmenu-define-full-snapshot-command]'\t- Define a command to restore current bookmark list
`\\[bmkx-define-tags-sort-command]'\t- Define a command to sort bookmarks by tags
`\\[bmkx-bmenu-define-jump-marked-command]'
\t- Define a command to jump to a bookmark that is now marked


Options for `*Bmkx List*'
-----------------------------

`bookmark-bmenu-file-column'       - Bookmark width if files are shown
`bookmark-bmenu-toggle-filenames'  - Show filenames initially?

`bmkx-bmenu-omitted-bookmarks'     - List of omitted bookmarks
`bmkx-bmenu-state-file'            - File to save bookmark-list state
                                   (\"home\") nil: do not save/restore
`bmkx-sort-comparer'               - Initial sort
`bmkx-sort-orders-for-cycling-alist' - Sort orders that `\\[bmkx-bmenu-change-sort-order-repeat]'... cycles


Other Options
-------------

`bookmark-automatically-show-annotations'  - Show annotation when visit?
`bookmark-completion-ignore-case'  - Case-sensitive completion?
`bookmark-default-file'            - File to save bookmarks in
`bookmark-menu-length'             - Max size of bookmark-name menu item
`bookmark-save-flag'               - Whether and when to save
`bookmark-use-annotations'         - Edit annotation when set bookmark?
`bookmark-version-control'         - Numbered backups of bookmark file?

`bmkx-autoname-format'        - Format of autonamed bookmark name
`bmkx-last-as-first-bookmark-file' - Whether to start with last b. file
`bmkx-highlight-on-jump-flag' - Highlight position when visit?
`bmkx-menu-popup-max-length'  - Use menus to choose bookmarks?
`bmkx-save-new-location-flag' - Save if bookmark relocated?
`bmkx-sequence-jump-display-function' - How to display a sequence
`bmkx-sort-comparer'          - Predicates for sorting bookmarks
`bmkx-su-or-sudo-regexp'      - Bounce-show each end of region?
`bmkx-this-file/buffer-cycle-sort-comparer' -  cycling sort for here
`bmkx-use-region'             - Activate saved region when visit?"
  (setq truncate-lines    t
        buffer-read-only  t)
  ;; Reflect bmkx-temporary-bookmarking-mode in the mode line.
  (when bmkx-temporary-bookmarking-mode
    (setq mode-name  "TEMPORARY Bookmarking")))


;; Differences from built-in `bookmark.el':
;;
;; 1. Corrected (rewrote).  Toggle var first (unless SHOW).  Call fn according to the var (& to SHOW).
;; 2. Added optional arg NO-MSG-P.
;;
(defun bmkx-list-toggle-filenames (&optional show no-msg-p)
  "Toggle whether filenames are shown in the bookmark list.
Toggle the value of `bookmark-bmenu-toggle-filenames', unless SHOW is
non-nil.
Optional argument SHOW means show them unconditionally.

Non-nil optional arg NO-MSG-P means do not show progress messages."
  (interactive)
  (unless show  (setq bookmark-bmenu-toggle-filenames  (not bookmark-bmenu-toggle-filenames)))
  (let ((bookmark-bmenu-toggle-filenames  (or show  bookmark-bmenu-toggle-filenames)))
    (if bookmark-bmenu-toggle-filenames
        (bmkx-list-show-filenames nil no-msg-p)
      (bmkx-list-hide-filenames nil no-msg-p))))

(defconst bmkx-bmenu-filename-style-order
  '(full abbreviate shrink basename)
  "Cycle order used by `bmkx-bmenu-cycle-filename-style'.")

(defun bmkx-bmenu-set-filename-style (style)
  "Set `bmkx-bmenu-filename-style' to STYLE and refresh the bookmark list.
If the current buffer is the bookmark list, redisplay filenames in
place; otherwise just set the option."
  (interactive
   (list (intern (completing-read
                  "Filename style: "
                  (mapcar #'symbol-name bmkx-bmenu-filename-style-order)
                  nil t nil nil
                  (symbol-name bmkx-bmenu-filename-style)))))
  (unless (memq style bmkx-bmenu-filename-style-order)
    (user-error "Unknown filename style: %s" style))
  (setq bmkx-bmenu-filename-style style)
  (let ((buf (or (and (derived-mode-p 'bmkx-list-mode) (current-buffer))
                 (get-buffer "*Bmkx List*"))))
    (when (and buf bookmark-bmenu-toggle-filenames)
      (with-current-buffer buf
        (bmkx-list-hide-filenames nil 'no-msg-p)
        (bmkx-list-show-filenames nil 'no-msg-p))))
  (message "Bookmark filename style: %s" style)
  style)

(defun bmkx-bmenu-cycle-filename-style ()
  "Cycle `bmkx-bmenu-filename-style' through its supported values.
Order: full -> abbreviate -> shrink -> basename -> full.
Refresh the *Bookmark List* in place if filenames are shown."
  (interactive)
  (let* ((rest (cdr (memq bmkx-bmenu-filename-style bmkx-bmenu-filename-style-order)))
         (next (or (car rest) (car bmkx-bmenu-filename-style-order))))
    (bmkx-bmenu-set-filename-style next)))

(defun bmkx-bmenu--refresh-list ()
  "Rebuild the *Bmkx List* buffer, preserving the current bookmark on point."
  (let ((buf (or (and (derived-mode-p 'bmkx-list-mode) (current-buffer))
                 (get-buffer "*Bmkx List*"))))
    (when buf
      (with-current-buffer buf
        (let ((bmk (ignore-errors (bmkx-list-bookmark))))
          (bmkx-bmenu-refresh-menu-list)
          (when bmk (bmkx-bmenu-goto-bookmark-named bmk)))))))

(defun bmkx-bmenu-toggle-tags-column ()
  "Toggle display of the tags column in the bookmark list.
Flips `bmkx-bmenu-show-tags-flag' and redisplays the buffer."
  (interactive)
  (setq bmkx-bmenu-show-tags-flag (not bmkx-bmenu-show-tags-flag))
  (bmkx-bmenu--refresh-list)
  (message "Tags column %s" (if bmkx-bmenu-show-tags-flag
                                (format "shown (%d chars)" bmkx-bmenu-tags-column-width)
                              "hidden")))

(defun bmkx-bmenu-set-tags-column-width (width)
  "Set `bmkx-bmenu-tags-column-width' to WIDTH and refresh.
Prompts for an integer.  Has no visible effect unless
`bmkx-bmenu-show-tags-flag' is non-nil."
  (interactive
   (list (read-number "Tags column width (chars): " bmkx-bmenu-tags-column-width)))
  (unless (and (integerp width) (> width 0))
    (user-error "Width must be a positive integer"))
  (setq bmkx-bmenu-tags-column-width width)
  (bmkx-bmenu--refresh-list)
  (message "Tags column width: %d" width))

(defun bmkx-bmenu-set-name-column-width (width)
  "Set `bmkx-bmenu-name-column-width' to WIDTH and refresh.
WIDTH is a positive integer, or nil (or 0) to mean automatic
\(use the longest current bookmark name)."
  (interactive
   (list (read-number "Name column width (0 = auto): "
                      (or bmkx-bmenu-name-column-width 0))))
  (setq bmkx-bmenu-name-column-width (and (integerp width) (> width 0) width))
  (bmkx-bmenu--refresh-list)
  (message "Name column width: %s" (or bmkx-bmenu-name-column-width "auto")))


;; Differences from built-in `bookmark.el':
;;
;; 1. Put `mouse-face' on whole line, with the same help-echo as for the bookmark name.
;; 2. Correct FORCE behavior.
;; 3. Correct doc string.
;; 4. Added optional arg NO-MSG-P and progress message.
;; 5. Fit one-window frame.
;;
(defun bmkx-list-show-filenames (&optional force no-msg-p)
  "Show file names if `bookmark-bmenu-toggle-filenames' is non-nil.
Otherwise do nothing, except non-nil optional argument FORCE has the
same effect as non-nil `bookmark-bmenu-toggle-filenames'.  FORCE is
mainly for debugging.
Non-nil optional arg NO-MSG-P means do not show progress messages."
  (when (or force  bookmark-bmenu-toggle-filenames)
    (unless no-msg-p (message "Showing file names..."))
    (with-buffer-modified-unmodified
        (save-excursion
          (save-window-excursion
            (goto-char (point-min)) (forward-line bmkx-bmenu-header-lines)
            (setq bookmark-bmenu-hidden-bookmarks  ())
            (let ((inhibit-read-only  t))
              (while (< (point) (point-max))
                (let ((bmk  (bmkx-list-bookmark)))
                  (setq bookmark-bmenu-hidden-bookmarks  (cons bmk bookmark-bmenu-hidden-bookmarks))
                  (move-to-column bookmark-bmenu-file-column t)
                  (delete-region (point) (line-end-position))
                  (insert "  ")
                  (insert (bmkx-bmenu-format-filename (bmkx-location bmk)))
                  (when ; Emacs 21+.
                            (and (display-color-p)  (display-mouse-p))
                    (let ((help  (get-text-property (+ bmkx-bmenu-marks-width (line-beginning-position))
                                                    'help-echo)))
                      (put-text-property (+ bmkx-bmenu-marks-width (line-beginning-position))
                                         (point) 'mouse-face 'highlight)
                      (when help  (put-text-property (+ bmkx-bmenu-marks-width (line-beginning-position))
                                                     (point) 'help-echo help))))
                  (forward-line 1)))))))
    (unless no-msg-p (message "Showing file names...done"))
    (bmkx-fit-bmenu-frame)))


;; Differences from built-in `bookmark.el':
;;
;; 1. Add text properties when hiding filenames.
;; 2. Do not set or use `bookmark-bmenu-bookmark-column' - use `bmkx-bmenu-marks-width' always.
;; 3. Correct FORCE behavior.
;; 4. Correct doc string.
;; 5. Added optional arg NO-MSG-P and progress message.
;; 6. Fit one-window frame.
;;
(defun bmkx-list-hide-filenames (&optional force no-msg-p)
  "Hide filenames if `bookmark-bmenu-toggle-filenames' is nil.
Otherwise do nothing, except non-nil optional argument FORCE has the
same effect as nil `bookmark-bmenu-toggle-filenames'.  FORCE is mainly
for debugging.
Non-nil optional arg NO-MSG-P means do not show progress messages."
  (when (or force  (not bookmark-bmenu-toggle-filenames))
    (unless no-msg-p (message "Hiding file names..."))
    (with-buffer-modified-unmodified
        (save-excursion
          (save-window-excursion
            (goto-char (point-min)) (forward-line bmkx-bmenu-header-lines)
            (setq bookmark-bmenu-hidden-bookmarks  (nreverse bookmark-bmenu-hidden-bookmarks))
            (let ((max-width  0))
              (dolist (name  bookmark-bmenu-hidden-bookmarks)
                (setq max-width  (max max-width (string-width name))))
              (setq max-width  (+ max-width bmkx-bmenu-marks-width))
              (save-excursion
                (let ((inhibit-read-only  t))
                  (while bookmark-bmenu-hidden-bookmarks
                    (move-to-column bmkx-bmenu-marks-width t)
                    (bookmark-kill-line)
                    (let ((name   (car bookmark-bmenu-hidden-bookmarks))
                          (start  (point))
                          end)
                      (insert name)
                      (move-to-column max-width t)
                      (setq end  (point))
                      (bmkx-bmenu-propertize-item name start end))
                    (setq bookmark-bmenu-hidden-bookmarks  (cdr bookmark-bmenu-hidden-bookmarks))
                    (forward-line 1))))))))
    (unless no-msg-p (message "Hiding file names...done"))
    (bmkx-fit-bmenu-frame)))


;; Differences from built-in `bookmark.el':
;;
;; 1. Prefix arg reverses `bmkx-use-region'.
;; 2. Raise error if not in buffer `*Bmkx List*'.
;;
;;;###autoload (autoload 'bmkx-list-1-window "bookmark-x")
(defun bmkx-list-1-window (&optional flip-use-region-p) ; Bound to `1' in bookmark list
  "Select this line's bookmark, alone, in full frame.
See `bmkx-jump' for info about the prefix arg."
  (interactive "P")
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-list-ensure-position)
  (bmkx-jump-1 (bmkx-list-bookmark) 'pop-to-buffer flip-use-region-p)
  (bury-buffer (other-buffer))
  (delete-other-windows))


;; Differences from built-in `bookmark.el':
;;
;; 1. Prefix arg reverses `bmkx-use-region'.
;; 2. Raise error if not in buffer `*Bmkx List*'.
;;
;;;###autoload (autoload 'bmkx-list-2-window "bookmark-x")
(defun bmkx-list-2-window (&optional flip-use-region-p) ; Bound to `2' in bookmark list
  "Select this line's bookmark, with previous buffer in second window.
See `bmkx-jump' for info about the prefix arg."
  (interactive "P")
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-list-ensure-position)
  (let ((bookmark-name   (bmkx-list-bookmark))
        (menu            (current-buffer))
        (pop-up-windows  t))
    (delete-other-windows)
    (bmkx--pop-to-buffer-same-window (other-buffer))
    ;; (let ((bookmark-automatically-show-annotations nil)) ; $$$$$$ Needed?
    (bmkx-jump-1 bookmark-name 'pop-to-buffer flip-use-region-p)
    (bury-buffer menu)))


;; Differences from built-in `bookmark.el':
;;
;; 1. Prefix arg reverses `bmkx-use-region'.
;; 2. Raise error if not in buffer `*Bmkx List*'.
;;
;;;###autoload (autoload 'bmkx-list-this-window "bookmark-x")
(defun bmkx-list-this-window (&optional flip-use-region-p) ; Bound to `RET' in bookmark list
  "Select this line's bookmark in this window.
See `bmkx-jump' for info about the prefix arg."
  (interactive "P")
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-list-ensure-position)
  (let ((bookmark-name  (bmkx-list-bookmark)))
    (bmkx-jump-1 bookmark-name 'bmkx--pop-to-buffer-same-window flip-use-region-p)))


;; Differences from built-in `bookmark.el':
;;
;; 1. Use `pop-to-buffer', not `switch-to-buffer-other-window'.
;; 2. Prefix arg reverses `bmkx-use-region'.
;; 3. Raise error if not in buffer `*Bmkx List*'.
;;
;;;###autoload (autoload 'bmkx-list-other-window "bookmark-x")
(defun bmkx-list-other-window (&optional flip-use-region-p) ; Bound to `o' in bookmark list
  "Select this line's bookmark in other window.  Show `*Bmkx List*' still.
See `bmkx-jump' for info about the prefix arg."
  (interactive "P")
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-list-ensure-position)
  (let ((bookmark-name  (bmkx-list-bookmark)))
    ;; (bookmark-automatically-show-annotations  t)) ; $$$$$$ Needed?
    (bmkx-jump-other-window bookmark-name flip-use-region-p)))


;; Differences from built-in `bookmark.el' (Emacs 27+):
;;
;; 1. Use `pop-to-buffer', not `view-buffer-other-frame'.
;; 2. Prefix arg reverses `bmkx-use-region'.
;; 3. Raise error if not in buffer `*Bmkx List*'.
;;
;;;###autoload (autoload 'bmkx-list-other-window "bookmark-x")
(defun bmkx-list-other-frame (&optional flip-use-region-p) ; Bound to `j 5' in bookmark list
  "Select this line's bookmark in another frame.
See `bmkx-jump' for info about the prefix arg."
  (interactive "P")
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-list-ensure-position)
  (let ((bookmark-name  (bmkx-list-bookmark)))
    ;; (bookmark-automatically-show-annotations  t)) ; $$$$$$ Needed?
    (bmkx-jump-other-frame bookmark-name flip-use-region-p)))


;; Differences from built-in `bookmark.el':
;;
;; 1. Prefix arg reverses `bmkx-use-region'.
;; 2. Raise error if not in buffer `*Bmkx List*'.
;;
;;;###autoload (autoload 'bmkx-list-switch-other-window "bookmark-x")
(defun bmkx-list-switch-other-window (&optional flip-use-region-p) ; Bound to `C-o'/`TAB' in bookmark list
  "Make the other window select this line's bookmark.
The current window remains selected.
See `bmkx-jump' for info about the prefix arg."
  (interactive "P")
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-list-ensure-position)
  (let ((bookmark-name  (bmkx-list-bookmark))
        ;; Force display in a non-selected window: never reuse the `*Bmkx List*'
        ;; window for the destination buffer.
        (display-buffer-overriding-action
         '((display-buffer-reuse-window
            display-buffer-use-some-window
            display-buffer-pop-up-window)
           (inhibit-same-window . t))))
    (save-selected-window
      (bmkx-jump-1 bookmark-name #'display-buffer flip-use-region-p))))


;; Differences from built-in `bookmark.el':
;;
;; 1. Prefix arg reverses `bmkx-use-region'.
;; 2. Raise error if not in buffer `*Bmkx List*'.
;;
;;;###autoload (autoload 'bmkx-list-other-window-with-mouse "bookmark-x")
(defun bmkx-list-other-window-with-mouse (event &optional flip-use-region-p)
  "Select clicked bookmark in other window.  Show `*Bmkx List*' still.
See `bmkx-jump' for info about the prefix arg."
  (interactive "e\nP")
  (with-current-buffer (window-buffer (posn-window (event-end event)))
    (save-excursion (goto-char (posn-point (event-end event)))
                    (bmkx-list-other-window flip-use-region-p))))


;; Differences from built-in `bookmark.el':
;;
;; 1. Added optional arg MSG-P.
;; 2. Call `bmkx-show-annotation' with arg MSG-P.
;; 3. Raise error if not in buffer `*Bmkx List*'.
;; 4. Doc string reflects enhanced behavior of `bmkx-show-annotation'.
;;
;;;###autoload (autoload 'bmkx-list-show-annotation "bookmark-x")
(defun bmkx-list-show-annotation (&optional msg-p) ; Bound to `a a' in bookmark list
  "Show the annotation for the current bookmark, or follow it if external.
If the annotation is external then jump to its destination.
Non-interactively, non-nil MSG-P means display messages."
  (interactive "p")
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-list-ensure-position)
  (let ((bmk  (bmkx-list-bookmark)))
    (unless bmk (error "No bookmark here"))
    (bmkx-show-annotation bmk msg-p)))


;; Differences from built-in `bookmark.el':
;;
;;  1. Don't use progress-reporter.
;;  2. Added optional arg MARKEDP: handle bookmarks marked `>', not just those flagged `D'.
;;  3. Added optional arg NO-CONFIRM-P.
;;  4. Delete bookmark on current line (after confirmation) if none are flagged/marked.
;;  5. Inhibit saving until all are deleted, then save all.  This is because the Bookmark-X version of
;;     `bmkx-save' refreshes the bookmark list display, and that removes `D' flags.
;;  6. Use `bmkx-get-bookmark' instead of `bookmark-get-bookmark', so we can get the right bookmarks when
;;     they have names with property `bmkx-full-record'.  But don't require that they have names, so
;;     calls from built-in or other code won't be bothered.
;;  7. Use `bmkx-list-surreptitiously-rebuild-list', instead of using
;;     `bmkx-list', updating the modification count, and saving.
;;  8. Update `bmkx-latest-bookmark-alist' to reflect the deletions.
;;  9. Pass full bookmark, not name, to `delete' (and do not use `assoc').
;; 10. Use `bmkx-bmenu-goto-bookmark-named'.
;; 11. Added status messages.
;; 12. Raise error if not in buffer `*Bmkx List*'.
;;
;;;###autoload (autoload 'bmkx-list-execute-deletions "bookmark-x")
(defun bmkx-list-execute-deletions (&optional markedp no-confirm-p) ; Bound to `x' in bookmark list
  "Delete (visible) bookmarks flagged `D', without confirmation.
With a prefix argument, delete the bookmarks marked `>' instead, but
only after confirmation.

If NO bookmarks are flagged or marked (depending on whether a prefix
arg was used), then delete the bookmark on this line, but only after
confirmation.

Non-interactively, optional arg NO-CONFIRM-P non-nil means do not ask
for confirmation when deleting marked (not flagged) bookmarks."
  (interactive "P")
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (if (and (null (if markedp bmkx-bmenu-marked-bookmarks bmkx-flagged-bookmarks))
           (bmkx-list-bookmark))
      (if (progn (let ((visible-bell                  t)
                       (minibuffer-prompt-properties  (append minibuffer-prompt-properties
                                                              '(face bmkx-*-mark))))
                   (ding) (ding)
                   (yes-or-no-p "DELETE THIS bookmark ")))
          (bmkx-delete (bmkx-list-bookmark))
        (message "OK, not deleted"))
    (if (or (not markedp)
            no-confirm-p
            (yes-or-no-p "Delete bookmarks marked `>' (not `D') "))
        (let* ((mark-type  (if markedp "^>" "^D"))
               (o-str      (and (not (looking-at-p mark-type))  (bmkx-list-bookmark)))
               (o-point    (point))
               (count      0))
          (message "Deleting bookmarks...")
          (goto-char (point-min)) (forward-line bmkx-bmenu-header-lines)
          (while (re-search-forward mark-type (point-max) t)
            (let* ((bmk-name  (bmkx-list-bookmark))
                   (bmk       (bmkx-get-bookmark bmk-name nil 'NO-NAME-CHECK-P)))
              ;; Inhibit saving until all are deleted, then do it once.  Otherwise, some might not be
              ;; deleted, because `bmkx-save' refreshes the list, which removes `D' flags.
              (let ((bookmark-save-flag  nil))  (bmkx-delete bmk-name 'BATCHP))
              ;; Count is misleading if the bookmark is not really in `bookmark-alist'.
              (setq count                       (1+ count)
                    bmkx-latest-bookmark-alist  (delete bmk bmkx-latest-bookmark-alist))))
          (bmkx-maybe-save-bookmarks)   ; Do it now.
          (if (<= count 0)
              (message (if markedp "No marked bookmarks" "No bookmarks flagged for deletion"))
            (bmkx-list-surreptitiously-rebuild-list 'NO-MSG-P)
            (message "Deleted %d bookmarks" count))
          (if o-str
              (bmkx-bmenu-goto-bookmark-named o-str)
            (goto-char o-point)
            (beginning-of-line)))
      (message "OK, nothing deleted"))))



;;(@* "Bookmark-X Functions (`bmkx-*')")
;;; Bookmark-X Functions (`bmkx-*') -----------------------------------


;;(@* "Menu-List (`*-bmenu-*') Filter Commands")
;;  *** Menu-List (`*-bmenu-*') Filter Commands ***

;; `bmkx-bmenu-show-only-autonamed-bookmarks',
;; `bmkx-bmenu-show-only-non-file-bookmarks',
;; `bmkx-bmenu-show-only-dired-bookmarks',
;; `bmkx-bmenu-show-only-eww-bookmarks' (Emacs 25+),
;; `bmkx-bmenu-show-only-function-bookmarks',
;; `bmkx-bmenu-show-only-gnus-bookmarks',
;; `bmkx-bmenu-show-only-non-invokable-bookmarks',
;; `bmkx-bmenu-show-only-image-bookmarks',
;; `bmkx-bmenu-show-only-info-bookmarks',
;; `bmkx-bmenu-show-only-desktop-bookmarks',
;; `bmkx-bmenu-show-only-man-bookmarks',
;; `bmkx-bmenu-show-only-region-bookmarks',
;; `bmkx-bmenu-show-only-tagged-bookmarks',
;; `bmkx-bmenu-show-only-untagged-bookmarks',
;; `bmkx-bmenu-show-only-url-bookmarks',
;; `bmkx-bmenu-show-only-variable-list-bookmarks',
;; `bmkx-bmenu-show-only-snippet-bookmarks',
;; `bmkx-bmenu-show-only-w3m-bookmarks',
;; `bmkx-bmenu-show-only-temporary-bookmarks',
;; `bmkx-bmenu-show-only-bookmark-file-bookmarks',
;; `bmkx-bmenu-show-only-bookmark-list-bookmarks',


;; The simple ones are defined using macro `bmkx-define-show-only-command'.
;;
;;;###autoload (autoload 'bmkx-bmenu-show-only-autonamed-bookmarks "bookmark-x")
;;;###autoload (autoload 'bmkx-bmenu-show-only-non-file-bookmarks "bookmark-x")
;;;###autoload (autoload 'bmkx-bmenu-show-only-dired-bookmarks "bookmark-x")

;; ;;;###autoload (autoload 'bmkx-bmenu-show-only-eww-bookmarks "bookmark-x")

;;;###autoload (autoload 'bmkx-bmenu-show-only-function-bookmarks "bookmark-x")
;;;###autoload (autoload 'bmkx-bmenu-show-only-gnus-bookmarks "bookmark-x")
;;;###autoload (autoload 'bmkx-bmenu-show-only-non-invokable-bookmarks "bookmark-x")
;;;###autoload (autoload 'bmkx-bmenu-show-only-image-bookmarks "bookmark-x")
;;;###autoload (autoload 'bmkx-bmenu-show-only-info-bookmarks "bookmark-x")
;;;###autoload (autoload 'bmkx-bmenu-show-only-desktop-bookmarks "bookmark-x")
;;;###autoload (autoload 'bmkx-bmenu-show-only-man-bookmarks "bookmark-x")
;;;###autoload (autoload 'bmkx-bmenu-show-only-region-bookmarks "bookmark-x")
;;;###autoload (autoload 'bmkx-bmenu-show-only-tagged-bookmarks "bookmark-x")
;;;###autoload (autoload 'bmkx-bmenu-show-only-untagged-bookmarks "bookmark-x")
;;;###autoload (autoload 'bmkx-bmenu-show-only-url-bookmarks "bookmark-x")
;;;###autoload (autoload 'bmkx-bmenu-show-only-variable-list-bookmarks "bookmark-x")
;;;###autoload (autoload 'bmkx-bmenu-show-only-snippet-bookmarks "bookmark-x")
;;;###autoload (autoload 'bmkx-bmenu-show-only-w3m-bookmarks "bookmark-x")
;;;###autoload (autoload 'bmkx-bmenu-show-only-temporary-bookmarks "bookmark-x")
;;;###autoload (autoload 'bmkx-bmenu-show-only-bookmark-file-bookmarks "bookmark-x")
;;;###autoload (autoload 'bmkx-bmenu-show-only-bookmark-list-bookmarks "bookmark-x")

;; Bindings indicated are in `*Bmkx List*'.
(bmkx-define-show-only-command autonamed "Display (only) the autonamed bookmarks."
                               bmkx-autonamed-alist-only)                                     ; `# S'
(bmkx-define-show-only-command non-file "Display (only) the non-file (buffer) bookmarks."
                               bmkx-non-file-alist-only)                                      ; `B S'
(bmkx-define-show-only-command dired "Display (only) the Dired bookmarks."
                               bmkx-dired-alist-only)                                         ; `M-d M-s'
(bmkx-define-show-only-command gnus "Display (only) the gnus bookmarks."
                               bmkx-gnus-alist-only)                                          ; `G S'
(bmkx-define-show-only-command image "Display (only) the image-file bookmarks."
                               bmkx-image-alist-only)                                         ; `M-I M-S'
(bmkx-define-show-only-command info "Display (only) the Info bookmarks."
                               bmkx-info-alist-only)                                          ; `I S'
(bmkx-define-show-only-command desktop  "Display (only) the desktop bookmarks."
                               bmkx-desktop-alist-only)                                       ; `K S'
(bmkx-define-show-only-command man "Display (only) the `man' page bookmarks."
                               bmkx-man-alist-only)                                           ; `M S'
(bmkx-define-show-only-command function "Display (only) the function bookmarks."
                               bmkx-function-alist-only)                                      ; `Q S'
(bmkx-define-show-only-command region "Display (only) the bookmarks that record a region."
                               bmkx-region-alist-only)                                        ; `R S'
(bmkx-define-show-only-command tagged "Display (only) the bookmarks that have tags."
                               bmkx-tagged-alist-only)                                        ; `T S'
(bmkx-define-show-only-command untagged "Display (only) the bookmarks that do not have tags."
                               bmkx-untagged-alist-only)                                      ; Not bound
(bmkx-define-show-only-command url "Display (only) the url bookmarks."
                               bmkx-url-alist-only)                                           ; `M-u M-s'
(bmkx-define-show-only-command variable-list "Display (only) the variable-list bookmarks."
                               bmkx-variable-list-alist-only)                                 ; `V S'
(bmkx-define-show-only-command snippet "Display (only) the snippet bookmarks."
                               bmkx-snippet-alist-only)                                       ; `w S'
(when (fboundp 'bmkx-eww-bookmark-p)    ; Emacs 25+
  (bmkx-define-show-only-command eww "Display (only) the EWW URL bookmarks."
                                 bmkx-eww-alist-only))                                        ; `W E S'
(bmkx-define-show-only-command w3m "Display (only) the W3M URL bookmarks."
                               bmkx-w3m-alist-only)                                           ; `W 3 S'
(bmkx-define-show-only-command temporary "Display (only) the temporary bookmarks."
                               bmkx-temporary-alist-only)                                     ; `X S'
(bmkx-define-show-only-command bookmark-file "Display (only) the bookmark-file bookmarks."
                               bmkx-bookmark-file-alist-only)                                 ; `Y S'
(bmkx-define-show-only-command bookmark-list  "Display (only) the bookmark-list bookmarks."
                               bmkx-bookmark-list-alist-only)                                 ; `Z S'

;;;###autoload (autoload 'bmkx-bmenu-show-all "bookmark-x")
(defun bmkx-bmenu-show-all ()           ; Bound to `.' in bookmark list
  "Show all bookmarks known to the bookmark list (aka \"menu list\").
Omitted bookmarks are not shown, however.
Also, this does not revert the bookmark list, to bring it up to date.
To revert the display from the current list, use `\\<bmkx-list-mode-map>\
\\[bmkx-bmenu-refresh-menu-list]'.
To revert the list and display from the bookmark file, use `C-u \\[bmkx-bmenu-refresh-menu-list]'."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (setq bmkx-bmenu-filter-function  nil
        bmkx-bmenu-title            "All Bookmarks"
        bmkx-latest-bookmark-alist  bookmark-alist)
  (bmkx-list)
  (when (called-interactively-p 'interactive) (bmkx-msg-about-sort-order (bmkx-current-sort-order) "All bookmarks are shown")))

;;;###autoload (autoload 'bmkx-bmenu-show-only-autofile-bookmarks "bookmark-x")
(defun bmkx-bmenu-show-only-autofile-bookmarks (&optional arg) ; Bound to `A S' in bookmark list
  "Display (only) the autofile bookmarks.
This means bookmarks whose names are the same as the nondirectory part
of their file names (or their `directory-file-name', for directories).

But with a prefix arg you are prompted for a prefix that each bookmark
name must have."
  (interactive "P")
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (setq bmkx-bmenu-filter-function  (if (not arg)
                                        'bmkx-autofile-alist-only
                                      (let ((prefix  (read-string "Prefix for bookmark names: "
                                                                  nil nil "")))
                                        `(lambda () (bmkx-autofile-alist-only ,prefix))))
        bmkx-bmenu-title            "Autofile Bookmarks")
  (let ((bookmark-alist  (funcall bmkx-bmenu-filter-function)))
    (setq bmkx-latest-bookmark-alist  bookmark-alist)
    (bmkx-list 'filteredp))
  (when (called-interactively-p 'interactive)
    (bmkx-msg-about-sort-order (bmkx-current-sort-order) "Only autofile bookmarks are shown")))

;;;###autoload (autoload 'bmkx-bmenu-show-only-file-bookmarks "bookmark-x")
(defun bmkx-bmenu-show-only-file-bookmarks (&optional arg) ; Bound to `F S' in bookmark list
  "Display a list of file and directory bookmarks (only).
With a prefix argument, do not include remote files or directories."
  (interactive "P")
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (setq bmkx-bmenu-filter-function  (if arg 'bmkx-local-file-alist-only 'bmkx-file-alist-only)
        bmkx-bmenu-title            (if arg
                                        "Local File and Directory Bookmarks"
                                      "File and Directory Bookmarks"))
  (let ((bookmark-alist  (funcall bmkx-bmenu-filter-function)))
    (setq bmkx-latest-bookmark-alist  bookmark-alist)
    (bmkx-list 'filteredp))
  (when (called-interactively-p 'interactive)
    (bmkx-msg-about-sort-order (bmkx-current-sort-order) "Only file bookmarks are shown")))

;;;###autoload (autoload 'bmkx-bmenu-show-only-orphaned-local-file-bookmarks "bookmark-x")
(defun bmkx-bmenu-show-only-orphaned-local-file-bookmarks (&optional arg) ; `O S' in bookmark list
  "Display a list of orphaned local file and directory bookmarks (only).
With a prefix argument, include remote orphans as well."
  (interactive "P")
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (setq bmkx-bmenu-filter-function  (if arg
                                        'bmkx-orphaned-file-alist-only
                                      'bmkx-orphaned-local-file-alist-only)
        bmkx-bmenu-title            (if arg
                                        "Orphaned File and Directory Bookmarks"
                                      "Local Orphaned File and Directory Bookmarks"))
  (let ((bookmark-alist  (funcall bmkx-bmenu-filter-function)))
    (setq bmkx-latest-bookmark-alist  bookmark-alist)
    (bmkx-list 'filteredp))
  (when (called-interactively-p 'interactive)
    (bmkx-msg-about-sort-order (bmkx-current-sort-order) "Only orphaned file bookmarks are shown")))

;;;###autoload (autoload 'bmkx-bmenu-show-only-specific-buffer-bookmarks "bookmark-x")
(defun bmkx-bmenu-show-only-specific-buffer-bookmarks (&optional buffer) ; `= b S' in bookmark list
  "Display (only) the bookmarks for BUFFER.
Interactively, read the BUFFER name.
If BUFFER is non-nil, set `bmkx-last-specific-buffer' to it."
  (interactive (list (bmkx-completing-read-buffer-name)))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (when buffer (setq bmkx-last-specific-buffer  buffer))
  (setq bmkx-bmenu-filter-function  'bmkx-last-specific-buffer-alist-only
        bmkx-bmenu-title            (format "Buffer `%s' Bookmarks" bmkx-last-specific-buffer))
  (let ((bookmark-alist  (funcall bmkx-bmenu-filter-function)))
    (setq bmkx-latest-bookmark-alist  bookmark-alist)
    (bmkx-list 'filteredp))
  (when (called-interactively-p 'interactive)
    (bmkx-msg-about-sort-order (bmkx-current-sort-order)
                               (format "Only bookmarks for buffer `%s' are shown"
                                       bmkx-last-specific-buffer))))

;;;###autoload (autoload 'bmkx-bmenu-show-only-specific-file-bookmarks "bookmark-x")
(defun bmkx-bmenu-show-only-specific-file-bookmarks (&optional file) ; Bound to `= f S' in bookmark list
  "Display (only) the bookmarks for FILE, an absolute file name.
Interactively, read the FILE name.
If FILE is non-nil, set `bmkx-last-specific-file' to it."
  (interactive (list (bmkx-completing-read-file-name)))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (let ((orig-last-spec-file  bmkx-last-specific-file)
        (orig-filter-fn       bmkx-bmenu-filter-function)
        (orig-title           bmkx-bmenu-title)
        (orig-latest-alist    bmkx-latest-bookmark-alist))
    (condition-case err
        (progn
          (when file (setq bmkx-last-specific-file  file))
          (setq bmkx-bmenu-filter-function  'bmkx-last-specific-file-alist-only
                bmkx-bmenu-title            (format "File `%s' Bookmarks" bmkx-last-specific-file))
          (let ((bookmark-alist         (funcall bmkx-bmenu-filter-function))
                (bmkx-bmenu-state-file  nil)) ; Prevent restoring saved state.
            (setq bmkx-latest-bookmark-alist  bookmark-alist)
            (bmkx-list 'filteredp))
          (when (called-interactively-p 'interactive)
            (bmkx-msg-about-sort-order (bmkx-current-sort-order)
                                       (format "Only bookmarks for file `%s' are shown"
                                               bmkx-last-specific-file)))
          (raise-frame))
      (error (progn (setq bmkx-last-specific-file     orig-last-spec-file
                          bmkx-bmenu-filter-function  orig-filter-fn
                          bmkx-bmenu-title            orig-title
                          bmkx-latest-bookmark-alist  orig-latest-alist)
                    (error "%s" (error-message-string err)))))))


;;;###autoload (autoload 'bmkx-bmenu-refresh-menu-list "bookmark-x")
(defun bmkx-bmenu-refresh-menu-list (&optional parg msg-p) ; Bound to `g' in bookmark list
  "Refresh (revert) the bookmark list display (aka \"menu list\").
This brings the displayed list up to date with respect to the current
bookmark list.  It does not change the filtering or sorting of the
displayed list.

With a prefix argument and upon confirmation, refresh the bookmark
list and its display from the current bookmark file.  IOW, it reloads
the file, overwriting the current bookmark list.  This also removes
any markings and omissions.

You can use command `bmkx-toggle-bookmark-set-refreshes' to toggle
whether setting a bookmark in any way should automatically refresh the
list.

From Lisp, non-nil optional arg MSG-P means show progress messages."
  (interactive "P\np")
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (let ((msg  "Refreshing from bookmark "))
    (cond ((and parg  (yes-or-no-p (format "Refresh list to bookmarks saved in file `%s'? "
                                           bmkx-current-bookmark-file)))
           (when msg-p (message (setq msg  (concat msg "file..."))))
           (bmkx-load bmkx-current-bookmark-file 'OVERWRITE 'BATCH-NO-SAVE)
           (setq bmkx-bmenu-marked-bookmarks   () ; Start from scratch.
                 bmkx-modified-bookmarks       ()
                 bmkx-flagged-bookmarks        ()
                 bmkx-bmenu-omitted-bookmarks  (condition-case nil
                                                   (eval (car (get 'bmkx-bmenu-omitted-bookmarks
                                                                   'saved-value)))
                                                 (error nil)))
           (let ((bmkx-bmenu-filter-function  nil)) ; Remove any filtering.
             (bmkx-refresh-menu-list (bmkx-list-bookmark) (not msg-p))))
          (t
           (when msg-p (message (setq msg  (concat msg "list in memory..."))))
           (bmkx-refresh-menu-list (bmkx-list-bookmark) (not msg-p))))
    (when msg-p (message (concat msg "done")))))

;;;###autoload (autoload 'bmkx-bmenu-filter-bookmark-name-incrementally "bookmark-x")
(defun bmkx-bmenu-filter-bookmark-name-incrementally () ; Bound to `P B' in bookmark list
  "Incrementally filter bookmarks by bookmark name using a regexp."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (unwind-protect
      (progn (setq bmkx-bmenu-filter-timer
                   (run-with-idle-timer bmkx-incremental-filter-delay 'REPEAT
                                        #'bmkx-bmenu-filter-alist-by-bookmark-name-regexp))
             (bmkx-bmenu-read-filter-input))
    (bmkx-bmenu-cancel-incremental-filtering)))

(defun bmkx-bmenu-filter-alist-by-bookmark-name-regexp ()
  "Filter bookmarks by bookmark name, then refresh the bookmark list."
  (setq bmkx-bmenu-filter-function  'bmkx-regexp-filtered-bookmark-name-alist-only
        bmkx-bmenu-title            (format "Bookmarks with Names Matching Regexp `%s'"
                                            bmkx-bmenu-filter-pattern))
  (let ((bookmark-alist  (funcall bmkx-bmenu-filter-function)))
    (setq bmkx-latest-bookmark-alist  bookmark-alist)
    (bmkx-list 'filteredp)))

;;;###autoload (autoload 'bmkx-bmenu-filter-file-name-incrementally "bookmark-x")
(defun bmkx-bmenu-filter-file-name-incrementally () ; Bound to `P F' in bookmark list
  "Incrementally filter bookmarks by file name using a regexp."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (unwind-protect
      (progn (setq bmkx-bmenu-filter-timer
                   (run-with-idle-timer bmkx-incremental-filter-delay 'REPEAT
                                        #'bmkx-bmenu-filter-alist-by-file-name-regexp))
             (bmkx-bmenu-read-filter-input))
    (bmkx-bmenu-cancel-incremental-filtering)))

(defun bmkx-bmenu-filter-alist-by-file-name-regexp ()
  "Filter bookmarks by file name, then refresh the bookmark list."
  (setq bmkx-bmenu-filter-function  'bmkx-regexp-filtered-file-name-alist-only
        bmkx-bmenu-title            (format "Bookmarks with File Names Matching Regexp `%s'"
                                            bmkx-bmenu-filter-pattern))
  (let ((bookmark-alist  (funcall bmkx-bmenu-filter-function)))
    (setq bmkx-latest-bookmark-alist  bookmark-alist)
    (bmkx-list 'filteredp)))

;;;###autoload (autoload 'bmkx-bmenu-filter-annotation-incrementally "bookmark-x")
(defun bmkx-bmenu-filter-annotation-incrementally () ; Bound to `P A' in bookmark list
  "Incrementally filter bookmarks by their annotations using a regexp."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (unwind-protect
      (progn (setq bmkx-bmenu-filter-timer
                   (run-with-idle-timer bmkx-incremental-filter-delay 'REPEAT
                                        #'bmkx-bmenu-filter-alist-by-annotation-regexp))
             (bmkx-bmenu-read-filter-input))
    (bmkx-bmenu-cancel-incremental-filtering)))

(defun bmkx-bmenu-filter-alist-by-annotation-regexp ()
  "Filter bookmarks by annoation, then refresh the bookmark list."
  (setq bmkx-bmenu-filter-function  'bmkx-regexp-filtered-annotation-alist-only
        bmkx-bmenu-title            (format "Bookmarks with Annotations Matching Regexp `%s'"
                                            bmkx-bmenu-filter-pattern))
  (let ((bookmark-alist  (funcall bmkx-bmenu-filter-function)))
    (setq bmkx-latest-bookmark-alist  bookmark-alist)
    (bmkx-list 'filteredp)))

;;;###autoload (autoload 'bmkx-bmenu-filter-tags-incrementally "bookmark-x")
(defun bmkx-bmenu-filter-tags-incrementally () ; Bound to `P T' in bookmark list
  "Incrementally filter bookmarks by tags using a regexp."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (unwind-protect
      (progn (setq bmkx-bmenu-filter-timer
                   (run-with-idle-timer bmkx-incremental-filter-delay 'REPEAT
                                        #'bmkx-bmenu-filter-alist-by-tags-regexp))
             (bmkx-bmenu-read-filter-input))
    (bmkx-bmenu-cancel-incremental-filtering)))

(defun bmkx-bmenu-filter-alist-by-tags-regexp ()
  "Filter bookmarks by tags, then refresh the bookmark list."
  (setq bmkx-bmenu-filter-function  'bmkx-regexp-filtered-tags-alist-only
        bmkx-bmenu-title            (format "Bookmarks with Tags Matching Regexp `%s'"
                                            bmkx-bmenu-filter-pattern))
  (let ((bookmark-alist  (funcall bmkx-bmenu-filter-function)))
    (setq bmkx-latest-bookmark-alist  bookmark-alist)
    (bmkx-list 'filteredp)))

(defun bmkx-bmenu-read-filter-input ()
  "Read input and add it to `bmkx-bmenu-filter-pattern'."
  (setq bmkx-bmenu-filter-pattern  "")
  (let ((curr-bmk       (bmkx-list-bookmark))
        (orig-title     bmkx-bmenu-title)
        (orig-filt-fn   bmkx-bmenu-filter-function)
        (orig-filt-pat  bmkx-bmenu-filter-pattern))
    (when (eq 'QUIT
              (let ((tmp-list                                  ())
                    (inhibit-quit                              t)
                    (prefix-command-echo-keystrokes-functions  ()) ; 25+  See Emacs bug #44500.
                    char)
                (catch 'bmkx-bmenu-read-filter-input
                  (while (condition-case nil
                             (setq char  (read-char (concat "Pattern: " bmkx-bmenu-filter-pattern)))
                           ;; `read-char' raises an error for non-char event.
                           (error (throw 'bmkx-bmenu-read-filter-input nil)))
                    (unless (characterp char) ; E.g. `M-x', `M-:'
                      (throw 'bmkx-bmenu-read-filter-input nil))
                    (cl-case char
                      ((?\e ?\r)  (throw 'bmkx-bmenu-read-filter-input nil)) ; Break and exit.
                      (?\C-g      (setq inhibit-quit  nil)
                                  (throw 'bmkx-bmenu-read-filter-input 'QUIT)) ; Quit.
                      (?\d        (or (null tmp-list) ; No-op if no chars to delete.
                                      (pop tmp-list)
                                      t)) ; Delete last char of `bmkx-bmenu-filter-pattern'.
                      (t          (push (text-char-description char) tmp-list))) ; Accumulate CHAR.
                    (setq bmkx-bmenu-filter-pattern  (mapconcat #'identity (reverse tmp-list) ""))))))
      (message "Restoring display prior to incremental filtering...")
      (setq bmkx-bmenu-title            orig-title
            bmkx-bmenu-filter-function  orig-filt-fn
            bmkx-bmenu-filter-pattern   orig-filt-pat)
      (bmkx-list 'FILTEREDP)
      (bmkx-bmenu-goto-bookmark-named curr-bmk)
      (message "Restoring display prior to incremental filtering...done"))))

(defun bmkx-bmenu-cancel-incremental-filtering ()
  "Cancel timer used for incrementally filtering bookmarks."
  (cancel-timer bmkx-bmenu-filter-timer)
  (setq bmkx-bmenu-filter-timer  nil))

;;;###autoload (autoload 'bmkx-bmenu-toggle-show-only-unmarked "bookmark-x")
(defun bmkx-bmenu-toggle-show-only-unmarked () ; Bound to `<' in bookmark list
  "Hide all marked bookmarks.  Repeat to toggle, showing all."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  ;; Save display, to be sure `bmkx-bmenu-before-hide-marked-alist' is up-to-date.
  (bmkx-save-menu-list-state)
  (if (or (bmkx-some-marked-p bmkx-latest-bookmark-alist)
          (bmkx-some-marked-p bmkx-bmenu-before-hide-marked-alist))
      (let ((bookmark-alist  bmkx-latest-bookmark-alist)
            status)
        (if bmkx-bmenu-before-hide-marked-alist
            (setq bookmark-alist                       bmkx-bmenu-before-hide-marked-alist
                  bmkx-bmenu-before-hide-marked-alist  ()
                  bmkx-latest-bookmark-alist           bookmark-alist
                  status                               'shown)
          (setq bmkx-bmenu-before-hide-marked-alist  bmkx-latest-bookmark-alist
                bookmark-alist                       (bmkx-unmarked-bookmarks-only)
                bmkx-latest-bookmark-alist           bookmark-alist
                status                               'hidden))
        (bmkx-list-surreptitiously-rebuild-list 'NO-MSG-P)
        (cond ((eq status 'hidden)
               (bmkx-list-ensure-position)
               (message "Marked bookmarks are now hidden"))
              (t
               (goto-char (point-min))
               (when (re-search-forward "^>" (point-max) t)  (forward-line 0))
               (message "Marked bookmarks no longer hidden"))))
    (message "No marked bookmarks to hide"))
  (bmkx-fit-bmenu-frame))

;;;###autoload (autoload 'bmkx-bmenu-toggle-show-only-marked "bookmark-x")
(defun bmkx-bmenu-toggle-show-only-marked () ; Bound to `>' in bookmark list
  "Hide all unmarked bookmarks.  Repeat to toggle, showing all."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  ;; Save display, to be sure `bmkx-bmenu-before-hide-unmarked-alist' is up-to-date.
  (bmkx-save-menu-list-state)
  (if (or (bmkx-some-unmarked-p bmkx-latest-bookmark-alist)
          (bmkx-some-unmarked-p bmkx-bmenu-before-hide-unmarked-alist))
      (let ((bookmark-alist  bmkx-latest-bookmark-alist)
            status)
        (if bmkx-bmenu-before-hide-unmarked-alist
            (setq bookmark-alist                         bmkx-bmenu-before-hide-unmarked-alist
                  bmkx-bmenu-before-hide-unmarked-alist  ()
                  bmkx-latest-bookmark-alist             bookmark-alist
                  status                                 'shown)
          (setq bmkx-bmenu-before-hide-unmarked-alist  bmkx-latest-bookmark-alist
                bookmark-alist                         (bmkx-marked-bookmarks-only)
                bmkx-latest-bookmark-alist             bookmark-alist
                status                                 'hidden))
        (bmkx-list-surreptitiously-rebuild-list 'NO-MSG-P)
        (cond ((eq status 'hidden)
               (bmkx-list-ensure-position)
               (message "Unmarked bookmarks are now hidden"))
              (t
               (goto-char (point-min))
               (when (re-search-forward "^>" (point-max) t)  (forward-line 0))
               (message "Unmarked bookmarks no longer hidden"))))
    (message "No unmarked bookmarks to hide"))
  (bmkx-fit-bmenu-frame))


;;(@* "Menu-List (`*-bmenu-*') Commands Involving Marks")
;;  *** Menu-List (`*-bmenu-*') Commands Involving Marks ***

;;;###autoload (autoload 'bmkx-bmenu-mark-all "bookmark-x")
(defun bmkx-bmenu-mark-all (&optional no-re-sort-p msg-p) ; Bound to `M-m' in bookmark list
  "Mark all bookmarks, using mark `>'.
If any bookmark was unmarked before, and if the sort order is marked
first or last (`s >'), then re-sort.

Non-interactively:
* Non-nil optional arg NO-RE-SORT-P inhibits re-sorting.
* Non-nil optional arg MSG-P means display a status message."
  (interactive "i\np")
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (let ((count      0)
        (nb-marked  (length bmkx-bmenu-marked-bookmarks)))
    (save-excursion
      (goto-char (point-min)) (forward-line bmkx-bmenu-header-lines)
      (when msg-p (message "Updating bookmark-list display..."))
      (while (not (eobp)) (bmkx-list-mark 'NO-RE-SORT-P) (setq count  (1+ count))))
    (unless no-re-sort-p
      ;; If some were unmarked before, and if sort order is `s >' then re-sort.
      (when (and (/= nb-marked count)  (equal bmkx-sort-comparer '((bmkx-marked-cp) bmkx-alpha-p)))
        (let ((curr-bmk  (bmkx-list-bookmark)))
          (bmkx-list-surreptitiously-rebuild-list 'NO-MSG-P)
          (when curr-bmk (bmkx-bmenu-goto-bookmark-named curr-bmk)))))
    (when msg-p (message "Marked: %d" count))))

;; This is similar to `dired-unmark-all-files'.
;;;###autoload (autoload 'bmkx-bmenu-unmark-all "bookmark-x")
(defun bmkx-bmenu-unmark-all (mark &optional arg no-re-sort-p msg-p) ; Bound to `M-DEL', `U' in bmk list
  "Remove a mark from each bookmark.
Hit the mark character (`>' or `D') to remove those marks,
 or hit `RET' to remove all marks (both `>' and `D').
With a prefix arg, you are queried to unmark each marked bookmark.
Use `\\[help-command]' during querying for help.

If any bookmark was marked before, and if the sort order is marked
first or last (`s >'), then re-sort.

Non-interactively:
* MARK is the mark character or a carriage-return character (`?\\r').
* Non-nil ARG (prefix arg) means query.
* Non-nil optional arg NO-RE-SORT-P inhibits re-sorting.
* Non-nil optional arg MSG-P means display a status message."
  (interactive "cRemove marks (RET means all): \nP\ni\np")
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (require 'dired-aux)
  (let* ((count              0)
         (some-marked-p      bmkx-bmenu-marked-bookmarks)
         (inhibit-read-only  t)
         (case-fold-search   nil)
         (string             (format "\n%c" mark))
         (help-form          "Type SPC or `y' to unmark one bookmark, DEL or `n' to skip to next,
`!' to unmark all remaining bookmarks with no more questions."))
    (save-excursion
      (goto-char (point-min))
      (forward-line (if (eq mark ?\r)
                        bmkx-bmenu-header-lines
                      (1- bmkx-bmenu-header-lines))) ; Because STRING starts with a newline.
      (while (and (not (eobp))
                  (if (eq mark ?\r)
                      (re-search-forward dired-re-mark nil t)
                    (let ((case-fold-search  t)) ; Treat `d' the same as `D'.
                      (search-forward string nil t))))
        (when (or (prog1 (not arg) (when msg-p (message "Updating bookmark-list display...")))
                  (let ((bmk  (bmkx-list-bookmark)))
                    (and bmk  (dired-query 'bmkx-bmenu-unmark-all-query "Unmark bookmark `%s'? " bmk))))
          (bmkx-list-unmark nil 'NO-RE-SORT-P) (forward-line -1)
          (setq count  (1+ count)))))
    (unless no-re-sort-p
      ;; If some were marked before, and if sort order is `s >', then re-sort.
      (when (and some-marked-p  (equal bmkx-sort-comparer '((bmkx-marked-cp) bmkx-alpha-p)))
        (let ((curr-bmk  (bmkx-list-bookmark)))
          (bmkx-list-surreptitiously-rebuild-list 'NO-MSG-P)
          (when curr-bmk (bmkx-bmenu-goto-bookmark-named curr-bmk)))))
    (when msg-p (if (= 1 count) (message "1 mark removed") (message "%d marks removed" count)))))

;;;###autoload (autoload 'bmkx-bmenu-regexp-mark "bookmark-x")
(defun bmkx-bmenu-regexp-mark (regexp &optional no-re-sort-p msg-p) ; Bound to `% m' in bookmark list
  "Mark bookmarks that match REGEXP.
The entire bookmark line is tested: bookmark name and possibly file name.
Note too that if file names are not shown currently then the bookmark
name is padded at the right with spaces.

If any bookmark was unmarked before, and if the sort order is marked
first or last (`s >'), then re-sort.

Non-interactively:
* Non-nil optional arg NO-RE-SORT-P inhibits re-sorting.
* Non-nil optional arg MSG-P means display a status message."
  (interactive (list (bmkx-read-regexp "Regexp: ") (prefix-numeric-value current-prefix-arg)))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (let ((count      0)
        (nb-marked  (length bmkx-bmenu-marked-bookmarks)))
    (save-excursion
      (goto-char (point-min)) (forward-line bmkx-bmenu-header-lines)
      (when msg-p (message "Updating bookmark-list display..."))
      (while (and (not (eobp))  (re-search-forward regexp (point-max) t))
        (bmkx-list-mark 'NO-RE-SORT-P)
        (setq count  (1+ count))))
    (unless no-re-sort-p
      ;; If some were unmarked before, and if sort order is `s >', then re-sort.
      (when (and (equal bmkx-sort-comparer '((bmkx-marked-cp) bmkx-alpha-p))
                 (< nb-marked (length bmkx-bmenu-marked-bookmarks)))
        (let ((curr-bmk  (bmkx-list-bookmark)))
          (bmkx-list-surreptitiously-rebuild-list 'NO-MSG-P)
          (when curr-bmk (bmkx-bmenu-goto-bookmark-named curr-bmk)))))
    (when msg-p (if (= 1 count) (message "1 bookmark matched") (message "%d bookmarks matched" count)))))

;;;###autoload (autoload 'bmkx-bmenu-mark-autofile-bookmarks "bookmark-x")
(defun bmkx-bmenu-mark-autofile-bookmarks (&optional arg msgp) ; Bound to `A M' in bookmark list
  "Mark autofile bookmarks: those whose names are the same as their files.
With a prefix arg you are prompted for a prefix that each bookmark
name must have."
  (interactive "P\np")
  (if (not arg)
      (bmkx-bmenu-mark-bookmarks-satisfying #'bmkx-autofile-bookmark-p nil msgp)
    (let ((prefix  (read-string "Prefix for bookmark names: " nil nil "")))
      (bmkx-bmenu-mark-bookmarks-satisfying
       #'(lambda (bb) (bmkx-autofile-bookmark-p bb prefix)) nil msgp))))

;;;###autoload (autoload 'bmkx-bmenu-mark-autonamed-bookmarks "bookmark-x")
(defun bmkx-bmenu-mark-autonamed-bookmarks (&optional msgp) ; Bound to `# M' in bookmark list
  "Mark autonamed bookmarks."
  (interactive "p")
  (bmkx-bmenu-mark-bookmarks-satisfying #'bmkx-autonamed-bookmark-p nil msgp))

;;;###autoload (autoload 'bmkx-bmenu-mark-bookmark-file-bookmarks "bookmark-x")
(defun bmkx-bmenu-mark-bookmark-file-bookmarks (&optional msgp) ; Bound to `Y M' in bookmark list
  "Mark bookmark-file bookmarks."
  (interactive "p")
  (bmkx-bmenu-mark-bookmarks-satisfying 'bmkx-bookmark-file-bookmark-p nil msgp))

;;;###autoload (autoload 'bmkx-bmenu-mark-bookmark-list-bookmarks "bookmark-x")
(defun bmkx-bmenu-mark-bookmark-list-bookmarks (&optional msgp) ; Bound to `Z M' in bookmark list
  "Mark bookmark-list bookmarks."
  (interactive "p")
  (bmkx-bmenu-mark-bookmarks-satisfying 'bmkx-bookmark-list-bookmark-p nil msgp))

;;;###autoload (autoload 'bmkx-bmenu-mark-desktop-bookmarks "bookmark-x")
(defun bmkx-bmenu-mark-desktop-bookmarks (&optional msgp) ; Bound to `K M' in bookmark list
  "Mark desktop bookmarks."
  (interactive "p")
  (bmkx-bmenu-mark-bookmarks-satisfying 'bmkx-desktop-bookmark-p nil msgp))

;;;###autoload (autoload 'bmkx-bmenu-mark-dired-bookmarks "bookmark-x")
(defun bmkx-bmenu-mark-dired-bookmarks (&optional msgp) ; Bound to `M-d M-m' in bookmark list
  "Mark Dired bookmarks."
  (interactive "p")
  (bmkx-bmenu-mark-bookmarks-satisfying 'bmkx-dired-bookmark-p nil msgp))

(when (fboundp 'bmkx-eww-bookmark-p)    ; Emacs 25+

  ;; ;;;###autoload (autoload 'bmkx-bmenu-mark-eww-bookmarks "bookmark-x")
  (defun bmkx-bmenu-mark-eww-bookmarks (&optional msgp) ; Bound to `W E M' in bookmark list
    "Mark EWW (URL) bookmarks."
    (interactive "p")
    (bmkx-bmenu-mark-bookmarks-satisfying 'bmkx-eww-bookmark-p nil msgp))

  )

;;;###autoload (autoload 'bmkx-bmenu-mark-file-bookmarks "bookmark-x")
(defun bmkx-bmenu-mark-file-bookmarks (&optional arg msgp) ; Bound to `F M' in bookmark list
  "Mark file bookmarks.
With a prefix argument, do not mark remote files or directories."
  (interactive "P\np")
  (bmkx-bmenu-mark-bookmarks-satisfying
   (if arg 'bmkx-local-file-bookmark-p 'bmkx-file-bookmark-p nil msgp)))

;;;###autoload (autoload 'bmkx-bmenu-mark-function-bookmarks "bookmark-x")
(defun bmkx-bmenu-mark-function-bookmarks (&optional msgp) ; Bound to `Q M' in bookmark list
  "Mark function bookmarks."
  (interactive "p")
  (bmkx-bmenu-mark-bookmarks-satisfying #'bmkx-function-bookmark-p nil msgp))

;;;###autoload (autoload 'bmkx-bmenu-mark-gnus-bookmarks "bookmark-x")
(defun bmkx-bmenu-mark-gnus-bookmarks (&optional msgp) ; Bound to `G M' in bookmark list
  "Mark Gnus bookmarks."
  (interactive "p")
  (bmkx-bmenu-mark-bookmarks-satisfying 'bmkx-gnus-bookmark-p nil msgp))

;;;###autoload (autoload 'bmkx-bmenu-mark-image-bookmarks "bookmark-x")
(defun bmkx-bmenu-mark-image-bookmarks (&optional msgp) ; Bound to `M-I M-M' in bookmark list
  "Mark image-file bookmarks."
  (interactive "p")
  (bmkx-bmenu-mark-bookmarks-satisfying 'bmkx-image-bookmark-p nil msgp))

;;;###autoload (autoload 'bmkx-bmenu-mark-info-bookmarks "bookmark-x")
(defun bmkx-bmenu-mark-info-bookmarks (&optional msgp) ; Bound to `I M' in bookmark list
  "Mark Info bookmarks."
  (interactive "p")
  (bmkx-bmenu-mark-bookmarks-satisfying 'bmkx-info-bookmark-p nil msgp))

(when (featurep 'bookmark-x-lit)
  (defun bmkx-bmenu-mark-lighted-bookmarks (&optional msgp) ; Bound to `H M' in bookmark list
    "Mark the highlighted bookmarks."
    (interactive "p")
    (bmkx-bmenu-mark-bookmarks-satisfying 'bmkx-lighted-p nil msgp)))

;;;###autoload (autoload 'bmkx-bmenu-mark-man-bookmarks "bookmark-x")
(defun bmkx-bmenu-mark-man-bookmarks (&optional msgp) ; Bound to `M M' in bookmark list
  "Mark `man' page bookmarks."
  (interactive "p")
  (bmkx-bmenu-mark-bookmarks-satisfying 'bmkx-man-bookmark-p nil msgp))

;;;###autoload (autoload 'bmkx-bmenu-mark-non-file-bookmarks "bookmark-x")
(defun bmkx-bmenu-mark-non-file-bookmarks (&optional msgp) ; Bound to `B M' in bookmark list
  "Mark non-file bookmarks."
  (interactive "p")
  (bmkx-bmenu-mark-bookmarks-satisfying 'bmkx-non-file-bookmark-p nil msgp))

;;;###autoload (autoload 'bmkx-bmenu-mark-non-invokable-bookmarks "bookmark-x")
(defun bmkx-bmenu-mark-non-invokable-bookmarks (&optional msgp) ; Bound to `N M' in bookmark list
  "Mark non-invokable bookmarks."
  (interactive "p")
  (bmkx-bmenu-mark-bookmarks-satisfying 'bmkx-non-invokable-bookmark-p nil msgp))

;;;###autoload (autoload 'bmkx-bmenu-mark-orphaned-local-file-bookmarks "bookmark-x")
(defun bmkx-bmenu-mark-orphaned-local-file-bookmarks (&optional arg msgp) ; Bound to `O M' in bookmark list
  "Mark orphaned local-file bookmarks (their recorded files are not readable).
With a prefix argument, mark also remote orphaned files or directories."
  (interactive "P\np")
  (bmkx-bmenu-mark-bookmarks-satisfying
   (if arg 'bmkx-orphaned-file-bookmark-p 'bmkx-orphaned-local-file-bookmark-p nil msgp)))

;;;###autoload (autoload 'bmkx-bmenu-mark-region-bookmarks "bookmark-x")
(defun bmkx-bmenu-mark-region-bookmarks (&optional msgp) ; Bound to `R M' in bookmark list
  "Mark bookmarks that record a region."
  (interactive "p")
  (bmkx-bmenu-mark-bookmarks-satisfying 'bmkx-region-bookmark-p nil msgp))

;;;###autoload (autoload 'bmkx-bmenu-mark-snippet-bookmarks "bookmark-x")
(defun bmkx-bmenu-mark-snippet-bookmarks (&optional msgp) ; Bound to `w M' in bookmark list
  "Mark snippet bookmarks."
  (interactive "p")
  (bmkx-bmenu-mark-bookmarks-satisfying 'bmkx-snippet-bookmark-p nil msgp))

;;;###autoload (autoload 'bmkx-bmenu-mark-specific-buffer-bookmarks "bookmark-x")
(defun bmkx-bmenu-mark-specific-buffer-bookmarks (&optional buffer msgp) ; `= b M' in bookmark list
  "Mark bookmarks for BUFFER.
Interactively, read the name of the buffer.
If BUFFER is non-nil, set `bmkx-last-specific-buffer' to it."
  (interactive (list (bmkx-completing-read-buffer-name) t))
  (when buffer (setq bmkx-last-specific-buffer  buffer))
  (bmkx-bmenu-mark-bookmarks-satisfying 'bmkx-last-specific-buffer-p nil msgp))

;;;###autoload (autoload 'bmkx-bmenu-mark-specific-file-bookmarks "bookmark-x")
(defun bmkx-bmenu-mark-specific-file-bookmarks (&optional file msgp) ; Bound to `= f M' in bookmark list
  "Mark bookmarks for FILE, an absolute file name.
Interactively, read the file name.
If FILE is non-nil, set `bmkx-last-specific-file' to it."
  (interactive (list (bmkx-completing-read-file-name) t))
  (when file (setq bmkx-last-specific-file  file))
  (bmkx-bmenu-mark-bookmarks-satisfying 'bmkx-last-specific-file-p nil msgp))

;;;###autoload (autoload 'bmkx-bmenu-mark-temporary-bookmarks "bookmark-x")
(defun bmkx-bmenu-mark-temporary-bookmarks (&optional msgp) ; Bound to `X M' in bookmark list
  "Mark temporary bookmarks."
  (interactive "p")
  (bmkx-bmenu-mark-bookmarks-satisfying 'bmkx-temporary-bookmark-p nil msgp))

;;;###autoload (autoload 'bmkx-bmenu-mark-variable-list-bookmarks "bookmark-x")
(defun bmkx-bmenu-mark-variable-list-bookmarks (&optional msgp) ; Bound to `V M' in bookmark list
  "Mark variable-list bookmarks."
  (interactive "p")
  (bmkx-bmenu-mark-bookmarks-satisfying 'bmkx-variable-list-bookmark-p nil msgp))

;;;###autoload (autoload 'bmkx-bmenu-mark-url-bookmarks "bookmark-x")
(defun bmkx-bmenu-mark-url-bookmarks (&optional msgp) ; Bound to `M-u M-m' in bookmark list
  "Mark URL bookmarks."
  (interactive "p")
  (bmkx-bmenu-mark-bookmarks-satisfying 'bmkx-url-bookmark-p nil msgp))

;;;###autoload (autoload 'bmkx-bmenu-mark-w3m-bookmarks "bookmark-x")
(defun bmkx-bmenu-mark-w3m-bookmarks (&optional msgp) ; Bound to `W 3 M' in bookmark list
  "Mark W3M (URL) bookmarks."
  (interactive "p")
  (bmkx-bmenu-mark-bookmarks-satisfying 'bmkx-w3m-bookmark-p nil msgp))

;;;###autoload (autoload 'bmkx-bmenu-mark-bookmarks-satisfying "bookmark-x")
(defun bmkx-bmenu-mark-bookmarks-satisfying (pred &optional no-re-sort-p msg-p) ; Not bound
  "Mark bookmarks that satisfy predicate PRED.
If you use this interactively, you are responsible for entering a
symbol that names a unnary predicate.  The function you provide is not
checked - it is simply applied to each bookmark to test it.

If any bookmark was unmarked before, and if the sort order is marked
first or last (`s >'), then re-sort.

Non-interactively:
* Non-nil optional arg NO-RE-SORT-P inhibits re-sorting.
* Non-nil optional arg MSG-P means display a status message."
  (interactive "aPredicate: \ni\np")
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (let ((count      0)
        (nb-marked  (length bmkx-bmenu-marked-bookmarks))
        bmk)
    (save-excursion
      (goto-char (point-min)) (forward-line bmkx-bmenu-header-lines)
      (when msg-p (message "Updating bookmark-list display..."))
      (while (not (eobp))
        (setq bmk  (bmkx-list-bookmark))
        (if (not (funcall pred bmk))
            (forward-line 1)
          (bmkx-list-mark 'NO-RE-SORT-P)
          (setq count  (1+ count)))))
    (unless no-re-sort-p
      ;; If some were unmarked before, and if sort order is `s >', then re-sort.
      (when (and (equal bmkx-sort-comparer '((bmkx-marked-cp) bmkx-alpha-p))
                 (< nb-marked (length bmkx-bmenu-marked-bookmarks)))
        (let ((curr-bmk  (bmkx-list-bookmark)))
          (bmkx-list-surreptitiously-rebuild-list 'NO-MSG-P)
          (when curr-bmk (bmkx-bmenu-goto-bookmark-named curr-bmk)))))
    (when msg-p (if (= 1 count) (message "1 bookmark matched") (message "%d bookmarks matched" count)))))

;;;###autoload (autoload 'bmkx-bmenu-toggle-marks "bookmark-x")
(defun bmkx-bmenu-toggle-marks (&optional no-re-sort-p msg-p) ; Bound to `t' in bookmark list
  "Toggle marks: Unmark all marked bookmarks; mark all unmarked bookmarks.
This affects only the `>' mark, not the `D' flag.

Interactively or with nil optional arg NO-RE-SORT-P, if the current
sort order is marked first or last (`s >'), then re-sort.

Non-interactively, non-nil optional arg MSG-P means display a status
message."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-list-ensure-position)
  (let ((marked-count    0)
        (unmarked-count  0))
    (save-excursion
      (goto-char (point-min)) (forward-line bmkx-bmenu-header-lines)
      (if (not (bmkx-some-marked-p bmkx-latest-bookmark-alist))
          (bmkx-bmenu-mark-all no-re-sort-p)
        (when msg-p (message "Updating bookmark-list display..."))
        (while (not (eobp))
          (cond ((bmkx-bookmark-name-member (bmkx-list-bookmark) bmkx-bmenu-marked-bookmarks)
                 (bmkx-list-unmark nil 'NO-RE-SORT-P)
                 (setq unmarked-count  (1+ unmarked-count)))
                (t
                 (bmkx-list-mark 'NO-RE-SORT-P)
                 (setq marked-count  (1+ marked-count)))))))
    ;; If sort order is `s >' then re-sort.
    (when (and (not no-re-sort-p)  (equal bmkx-sort-comparer '((bmkx-marked-cp) bmkx-alpha-p)))
      (let ((curr-bmk  (bmkx-list-bookmark)))
        (bmkx-list-surreptitiously-rebuild-list 'NO-MSG-P)
        (when curr-bmk (bmkx-bmenu-goto-bookmark-named curr-bmk))))
    (when msg-p (message "Marked: %d, unmarked: %d" marked-count unmarked-count))))

;;;###autoload (autoload 'bmkx-bmenu-toggle-marked-temporary/savable "bookmark-x")
(defun bmkx-bmenu-toggle-marked-temporary/savable () ; Bound to `M-X' in bookmark list
  "Toggle the temporary/savable status of each marked bookmark.
If none are marked, toggle status of the bookmark of the current line."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (let ((o-str       (and (not (looking-at-p "^>"))  (bmkx-list-bookmark)))
        (o-point     (point))
        (count-temp  0)
        (count-save  0)
        bmk)
    (message "Toggling temporary status of marked bookmarks...")
    (goto-char (point-min)) (forward-line bmkx-bmenu-header-lines)
    (while (re-search-forward "^>" (point-max) t)
      (bmkx-toggle-temporary-bookmark (setq bmk  (bmkx-list-bookmark)))
      (if (bmkx-temporary-bookmark-p bmk)
          (setq count-temp  (1+ count-temp))
        (setq count-save  (1+ count-save))))
    (cond ((and (<= count-temp 0)  (<= count-save 0))
           (if o-str
               (bmkx-bmenu-goto-bookmark-named o-str)
             (goto-char o-point)
             (beginning-of-line))
           (bmkx-toggle-temporary-bookmark (bmkx-list-bookmark) 'MSG)
           (bmkx-list-surreptitiously-rebuild-list 'NO-MSG-P))
          (t
           (bmkx-list-surreptitiously-rebuild-list 'NO-MSG-P)
           (message "%d made temporary; %d made savable" count-temp count-save)))
    (if o-str
        (bmkx-bmenu-goto-bookmark-named o-str)
      (goto-char o-point)
      (beginning-of-line)))
  (bmkx-fit-bmenu-frame))

;;;###autoload (autoload 'bmkx-bmenu-toggle-temporary "bookmark-x")
(defun bmkx-bmenu-toggle-temporary ()   ; Bound to `C-M-X' in bookmark list
  "Toggle whether bookmark of current line is temporary (not saved to disk)."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (let ((o-str    (bmkx-list-bookmark))
        (o-point  (point)))
    (bmkx-toggle-temporary-bookmark (bmkx-list-bookmark) 'MSG)
    (bmkx-list-surreptitiously-rebuild-list 'NO-MSG-P)
    (if o-str
        (bmkx-bmenu-goto-bookmark-named o-str)
      (goto-char o-point)
      (beginning-of-line))))

;;;###autoload (autoload 'bmkx-bmenu-dired-marked "bookmark-x")
(defun bmkx-bmenu-dired-marked (dirbufname &optional include-omitted-p)
                                        ; Bound to `M-d >' in bookmark list
  "Dired in another window for the marked file and directory bookmarks.
Absolute file names are used for the entries in the Dired buffer.
The only entries are for the marked files and directories.  These can
be located anywhere.  (In Emacs versions prior to release 23.2, remote
bookmarks are ignored, because of Emacs bug #5478.)

You are prompted for the Dired buffer name.  The `default-directory'
of the buffer is the same as that of buffer `*Bmkx List*'.

Omitted bookmarks are excluded, by default.  With a prefix arg, any
that are marked are included."
  (interactive (list (read-string "Dired buffer name: ") current-prefix-arg))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (let ((files  ())
        file)
    (dolist (bmk  (bmkx-sort-omit (bmkx-bmenu-marked-or-this-or-all nil include-omitted-p)))
      (setq file  (bookmark-get-filename bmk))
      (unless (file-name-absolute-p file) (setq file (expand-file-name file))) ; Should not happen.
      (push file files))
    (dired-other-window (cons dirbufname files))))

;;;###autoload (autoload 'bmkx-bmenu-delete-marked "bookmark-x")
(defun bmkx-bmenu-delete-marked (&optional no-confirm-p) ; Bound to `D' in bookmark list
  "Delete all (visible) bookmarks that are marked `>'.
With a prefix arg (or non-nil arg NO-CONFIRM-P from Lisp), do not ask
for confirmation."
  (interactive "P")
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-list-execute-deletions 'MARKED no-confirm-p))

;;;###autoload (autoload 'bmkx-bmenu-move-marked-to-bookmark-file "bookmark-x")
(defun bmkx-bmenu-move-marked-to-bookmark-file (file &optional duplicates-ok include-omitted-p batchp)
                                        ; Bound to `Y > -' in bookmark list
  "Move the marked bookmarks to bookmark file FILE.
You are prompted for FILE.
If FILE doesn't exist then you're prompted to confirm creating it.

The marked bookmarks are removed from the current bookmark list and
appended to those in FILE.  If any of them has the same name as a
bookmark already in FILE then it is renamed by appending a numeric
suffix \"<N>\" (N=2,3...).

Normally, any of the marked bookmarks that are already present in FILE
are ignored, rather than duplicating them under a new, suffixed name.
But if you use a non-negative prefix arg then such duplication is
allowed.

If no bookmark is marked then move the bookmark of the current line.

Omitted bookmarks are excluded, by default.  With a non-positive
prefix arg, any that are marked are included.

The bookmarks are removed from the currently displayed bookmark list,
but the bookmark file associated with it is not saved automatically.
To save it, use \\<bmkx-list-mode-map>`\\[bookmark-bmenu-save]' (as usual).

Non-interactively, non-nil optional arg BATCHP means do not prompt to
confirm moving to new, empty file if no existing file."
  (interactive
   (list (let* ((_IGNORE      (bmkx-bmenu-barf-if-not-in-menu-list))
                (std-default  (bmkx-default-bookmark-file))
                (default      (if (bmkx-same-file-p bmkx-current-bookmark-file bmkx-last-bookmark-file)
                                  (if (bmkx-same-file-p bmkx-current-bookmark-file std-default)
                                      (and (not (bmkx-same-file-p bmkx-current-bookmark-file
                                                                  bookmark-default-file))
                                           bookmark-default-file)
                                    std-default)
                                bmkx-last-bookmark-file)))
           (bmkx-read-bookmark-file-name "Move marked bookmarks to bookmark file: "
                                         (or (and default  (file-name-directory default))  "~/")
                                         default))
         (and current-prefix-arg  (>= (prefix-numeric-value current-prefix-arg) 0))
         (and current-prefix-arg  (<= (prefix-numeric-value current-prefix-arg) 0))))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (when (and (not (file-readable-p file))
             (not batchp)
             (not (y-or-n-p (format "Move to NEW, EMPTY bookmark file `%s'? " file))))
    (error "OK - canceled"))
  (bmkx-bmenu-copy-marked-to-bookmark-file file duplicates-ok include-omitted-p 'MOVE 'BATCH))

;;;###autoload (autoload 'bmkx-bmenu-copy-marked-to-bookmark-file "bookmark-x")
(defun bmkx-bmenu-copy-marked-to-bookmark-file (file &optional duplicates-ok include-omitted-p movep batchp)
                                        ; Bound to `Y > +' in bookmark list
  "Copy the marked bookmarks to bookmark file FILE.
You are prompted for FILE.
The marked bookmarks are appended to those already in FILE.
If any of them has the same name as a bookmark already in FILE then it
is renamed by appending a numeric suffix \"<N>\" (N=2,3...).

Normally, any of the marked bookmarks that are already present in FILE
are ignored, rather than duplicating them under a new, suffixed name.
But if you use a non-negative prefix arg then such duplication is
allowed.  Use this, for example, to duplicate a bookmark in the
current bookmark file (use that file as FILE).

If no bookmark is marked then copy the bookmark of the current line.

Omitted bookmarks are excluded, by default.  With a non-positive
prefix arg, any that are marked are included.

Non-interactively:
* Non-nil MOVEP means delete the bookmarks copied.
* Non-nil BATCHP means do not prompt to confirm moving to a new, empty
  file if there is no existing file."
  (interactive
   (list (let* ((_IGNORE      (bmkx-bmenu-barf-if-not-in-menu-list))
                (std-default  (bmkx-default-bookmark-file))
                (default      (if (bmkx-same-file-p bmkx-current-bookmark-file bmkx-last-bookmark-file)
                                  (if (bmkx-same-file-p bmkx-current-bookmark-file std-default)
                                      (and (not (bmkx-same-file-p bmkx-current-bookmark-file
                                                                  bookmark-default-file))
                                           bookmark-default-file)
                                    std-default)
                                bmkx-last-bookmark-file)))
           (bmkx-read-bookmark-file-name "Copy marked bookmarks to bookmark file: "
                                         (or (and default  (file-name-directory default))  "~/")
                                         default))
         (and current-prefix-arg  (>= (prefix-numeric-value current-prefix-arg) 0))
         (and current-prefix-arg  (<= (prefix-numeric-value current-prefix-arg) 0))))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (when (file-directory-p file) (error "`%s' is a directory, not a file" file))
  (when (and (not (file-readable-p file))
             (not batchp)
             (not (y-or-n-p (format "Copy to NEW, EMPTY bookmark file `%s'? " file))))
    (error "OK - canceled"))
  (let ((bookmark-save-flag  nil)       ; Inhibit auto-saving for the duration.
        imported)
    (let ((marked-bmks                        (bmkx-sort-omit
                                               (bmkx-bmenu-marked-or-this-or-all nil include-omitted-p)))
          (bookmark-alist                     bookmark-alist)
          (bookmark-alist-modification-count  bookmark-alist-modification-count))
      (when (and (not (zerop bookmark-alist-modification-count)) ; Unsaved changes.
                 (yes-or-no-p "Unsaved changes.  Save bookmarks before copying? "))
        (bmkx-save))
      (with-current-buffer (let ((enable-local-variables  ())) (find-file-noselect file))
        (goto-char (point-min))
        (unless (file-exists-p file)
          (delete-region (point-min) (point-max)) ; In case a find-file hook inserted a header etc.
          (bookmark-insert-file-format-version-stamp coding-system-for-write)
          (insert "(\n)"))
        (let ((blist  (bmkx-alist-from-buffer)))
          (unless (listp blist) (error "Invalid bookmark list in file `%s'" file))
          (setq bookmark-alist  blist)  ; Bookmarks in FILE
          (setq imported  (bmkx-import-new-list marked-bmks duplicates-ok 'RETURN-BMKS))
          (if (and (zerop (nth 0 imported))  (zerop (nth 1 imported)))
              (unless batchp (message "No changes"))
            (unless batchp (message "%d added, %d renamed" (nth 1 imported) (nth 0 imported)))
            (bmkx-write-file file)))))
    ;; (Exit `let', to restore `bookmark-alist'.)
    (cond (movep
           ;; Moved.  Delete moved bookmarks.  Refresh from memory w/o asking.
           (dolist (bmk  (nth 2 imported)) (bmkx-delete bmk 'BATCHP))
           (bmkx-bmenu-refresh-menu-list nil 'MSGP))
          ((not (zerop (nth 0 imported)))
           ;; Copied, and some were renamed.  Refresh from file w/o asking.
           (bmkx-load bmkx-current-bookmark-file 'OVERWRITE 'BATCH-NO-SAVE)
           (bmkx-refresh-menu-list (bmkx-list-bookmark))))))

;;;###autoload (autoload 'bmkx-bmenu-create-bookmark-file-from-marked "bookmark-x")
(defun bmkx-bmenu-create-bookmark-file-from-marked (file create-b-f-bookmark-p
                                                    &optional include-omitted-p batchp)
                                        ; Bound to `Y > 0' in bookmark list
  "Create bookmark file FILE by copying the marked bookmarks.
You are prompted for FILE.
They are not deleted from the current bookmark file.  To delete them, use \
\\<bmkx-list-mode-map>`\\[bmkx-bmenu-delete-marked]'.

With a non-negative prefix arg, create also a bookmark-file bookmark
for FILE.  You are prompted for the bookmark name.

If no bookmark is marked then copy the bookmark of the current line.

Omitted bookmarks are excluded, by default.  With a non-positive
prefix arg, any that are marked are included.

Non-interactively, non-nil optional arg BATCHP means do not prompt to
confirm moving to new, empty file if no existing file."
  (interactive
   (list (let* ((_IGNORE      (bmkx-bmenu-barf-if-not-in-menu-list))
                (std-default  (bmkx-default-bookmark-file))
                (default      (if (bmkx-same-file-p bmkx-current-bookmark-file bmkx-last-bookmark-file)
                                  (if (bmkx-same-file-p bmkx-current-bookmark-file std-default)
                                      (and (not (bmkx-same-file-p bmkx-current-bookmark-file
                                                                  bookmark-default-file))
                                           bookmark-default-file)
                                    std-default)
                                bmkx-last-bookmark-file)))
           (bmkx-read-bookmark-file-name "Create bookmark file from marked: "
                                         (or (and default  (file-name-directory default))  "~/")
                                         default))
         (and current-prefix-arg  (>= (prefix-numeric-value current-prefix-arg) 0))
         (and current-prefix-arg  (<= (prefix-numeric-value current-prefix-arg) 0))))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (when (and (file-readable-p file)
             (not (file-directory-p file))
             (not batchp)
             (not (y-or-n-p (format "File `%s' already exists.  Overwrite? " file))))
    (error "OK - canceled"))
  (bmkx-empty-file file)
  (bmkx-bmenu-copy-marked-to-bookmark-file file nil include-omitted-p nil 'BATCH)
  (when create-b-f-bookmark-p (bmkx-set-bookmark-file-bookmark file)))

;;;###autoload (autoload 'bmkx-bmenu-set-bookmark-file-bookmark-from-marked "bookmark-x")
(defun bmkx-bmenu-set-bookmark-file-bookmark-from-marked (file &optional include-omitted-p batchp)
                                        ; Same as `C-u Y > 0' in bookmark list (but not bound).
  "Set a bookmark-file bookmark for the marked bookmarks.
You are prompted for the names of the new bookmark file and the
bookmark-file bookmark.

This is the same as using a non-negative prefix arg with
`bmkx-bmenu-create-bookmark-file-from-marked'.

If no bookmark is marked then use the bookmark of the current line.

Omitted bookmarks are excluded, by default.  With a prefix arg, any
that are marked are included.

Non-interactively, non-nil optional arg BATCHP means do not prompt to
confirm moving to new, empty file if no existing file."
  (interactive
   (list (let* ((_IGNORE      (bmkx-bmenu-barf-if-not-in-menu-list))
                (std-default  (bmkx-default-bookmark-file))
                (default      (if (bmkx-same-file-p bmkx-current-bookmark-file bmkx-last-bookmark-file)
                                  (if (bmkx-same-file-p bmkx-current-bookmark-file std-default)
                                      (and (not (bmkx-same-file-p bmkx-current-bookmark-file
                                                                  bookmark-default-file))
                                           bookmark-default-file)
                                    std-default)
                                bmkx-last-bookmark-file)))
           (bmkx-read-bookmark-file-name "Create a bookmark file from marked: "
                                         (or (and default  (file-name-directory default))  "~/")
                                         default))
         current-prefix-arg))
  (bmkx-bmenu-create-bookmark-file-from-marked file 'CREATE-B-F-BMK include-omitted-p batchp))

;;;###autoload (autoload 'bmkx-bmenu-load-marked-bookmark-file-bookmarks "bookmark-x")
(defun bmkx-bmenu-load-marked-bookmark-file-bookmarks (&optional msg-p) ; Bound to `M-l' in bookmark list
  "Load the bookmark-file bookmarks that are marked, in display order.
Non bookmark-file bookmarks that are marked are ignored.
You can sort the bookmark-list display to change the load order.

NOTE: Automatically saving the current bookmark list is turned OFF
before loading, and it remains turned off until you explicitly turn it
back on.  Bookmark-X does not assume that you want to automatically
save all of the newly loaded bookmarks in the same bookmark file.  If
you do, just use \\<bmkx-list-mode-map>`\\[bmkx-toggle-saving-bookmark-file]' \
to turn saving back on."
  (interactive "p")
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (let ((bmks  (bmkx-remove-if-not #'bmkx-bookmark-file-bookmark-p
                                   (bmkx-remove-if-not 'bmkx-marked-bookmark-p bmkx-sorted-alist)))
        (bmk   (bmkx-list-bookmark)))
    (unless bmks (error "No marked bookmark-file bookmarks"))
    ;; Maybe save bookmarks first.
    (when (or (not msg-p)
              (and (> bookmark-alist-modification-count 0)
                   (condition-case err
                       (yes-or-no-p "Save current bookmarks? (`C-g': cancel load too) ")
                     (quit  (error "OK - canceled"))
                     (error (error (error-message-string err))))))
      (bmkx-save))
    (when (or (not msg-p)
              (yes-or-no-p "Load the marked bookmark-file bookmarks? ")
              (error "OK - canceled"))
      (when bookmark-save-flag          ; Turn off autosaving.
        (bmkx-toggle-saving-bookmark-file) ; No MSG-P arg - issue message below.
        (when bookmark-save-flag  (setq bookmark-save-flag  nil)) ; Be sure it's off.
        (when msg-p (message "Autosaving of current bookmark file is now OFF")))
      (when msg-p (message "Loading marked bookmark files..."))
      (dolist (bmk  bmks)               ; Load.
        ;; USE BATCHP: Do not refresh list or display messages here - do that after iterate.
        (bmkx-load (bookmark-get-filename bmk) nil 'BATCHP))
      ;; $$$$$$ Should we do (bmkx-tags-list) here to update the tags cache?
      (bmkx-refresh-menu-list bmk (not msg-p)) ; Refresh after iterate.
      (when msg-p (message "Autosaving is now OFF.  Loaded: %s"
                           (mapconcat (lambda (bmk) (format "`%s'" (bmkx-bookmark-name-from-record bmk)))
                                      bmks
                                      ", "))))))

;;;###autoload (autoload 'bmkx-bmenu-load-marking "bookmark-x")
(defun bmkx-bmenu-load-marking (file &optional unmark-first-p)
  "Like `bmkx-load', but mark the bookmarks that are loaded.
With a prefix arg, unmark all bookmarks first."
  (interactive
   (list (let ((default  (if (bmkx-same-file-p bmkx-current-bookmark-file bmkx-last-bookmark-file)
                             (bmkx-default-bookmark-file)
                           bmkx-last-bookmark-file)))
           (bmkx-read-bookmark-file-name "Add bookmarks from file: "
                                         (or (file-name-directory default)  "~/")
                                         default
                                         t))
         current-prefix-arg))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (when unmark-first-p (bmkx-bmenu-unmark-all ?\r))
  (let* ((bmkx-read-bookmark-file-hook  bmkx-read-bookmark-file-hook)
         (bmks-read                     (bmkx-load file)))
    (bmkx-bmenu-mark-bookmarks-satisfying
     `(lambda (bmk) (bmkx-get-bookmark-in-alist bmk t ',bmks-read)))
    bmks-read))                         ; Return list of bookmarks read.

;;;###autoload (autoload 'bmkx-bmenu-load-marking-unmark-first "bookmark-x")
(defun bmkx-bmenu-load-marking-unmark-first (file)
  "Like `bmkx-bmenu-load-marking' with a prefix arg: unmark all first."
  (interactive
   (list (let ((default  (if (bmkx-same-file-p bmkx-current-bookmark-file bmkx-last-bookmark-file)
                             (bmkx-default-bookmark-file)
                           bmkx-last-bookmark-file)))
           (bmkx-read-bookmark-file-name "Add bookmarks from file: "
                                         (or (file-name-directory default)  "~/")
                                         default
                                         t))))
  (bmkx-bmenu-load-marking file t))

;;;###autoload (autoload 'bmkx-bmenu-make-sequence-from-marked "bookmark-x")
(defun bmkx-bmenu-make-sequence-from-marked (seqname &optional dont-omit-p) ; Not bound
  "Create or update a sequence bookmark from the visible marked bookmarks.
The bookmarks that are currently marked are recorded as a sequence, in
their current order in buffer `*Bmkx List*'.
When you \"jump\" to the sequence bookmark, the bookmarks in the
sequence are processed in order.

By default, omit the marked bookmarks, after creating the sequence.
With a prefix arg, do not omit them.

If a bookmark with the specified name already exists, it is
overwritten.  If a sequence bookmark with the name already exists,
then you are prompted whether to add the marked bookmarks to the
beginning of the existing sequence (or simply replace it).

Note that another existing sequence bookmark can be marked, and thus
included in the sequence bookmark created or updated.  That is, you
can include other sequences within a sequence bookmark.

Returns the bookmark (internal record) created or updated."
  (interactive "sName of sequence bookmark: \nP")
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (let ((marked-bmks  ())
        (count        0))
    (message "Making sequence from marked bookmarks...")
    (save-excursion (with-current-buffer bmkx-bmenu-buffer
                      (goto-char (point-min)) (forward-line bmkx-bmenu-header-lines)
                      (while (re-search-forward "^>" (point-max) t)
                        (push (bmkx-list-bookmark) marked-bmks)
                        (setq count  (1+ count)))))
    (when (zerop count) (error "No marked bookmarks"))
    (bmkx-set-sequence-bookmark seqname (nreverse marked-bmks)))
  (let ((new  (bmkx-get-bookmark seqname 'NOERROR)))
    (unless (memq new bmkx-latest-bookmark-alist)
      (setq bmkx-latest-bookmark-alist  (cons new bmkx-latest-bookmark-alist)))
    (unless dont-omit-p
      (bmkx-bmenu-omit-marked)
      (message (substitute-command-keys "Marked bookmarks now OMITTED - use \
\\<bmkx-list-mode-map>`\\[bmkx-bmenu-show-only-omitted-bookmarks]' to show")))
    (bmkx-list-surreptitiously-rebuild-list 'NO-MSG-P)
    (bmkx-bmenu-goto-bookmark-named seqname)
    new))


;;(@* "Omitted Bookmarks")
;;  *** Omitted Bookmarks ***

;;;###autoload (autoload 'bmkx-bmenu-omit "bookmark-x")
(defun bmkx-bmenu-omit ()               ; Not bound
  "Omit this bookmark."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-list-ensure-position)
  (push (bmkx-list-bookmark) bmkx-bmenu-omitted-bookmarks)
  (bmkx-list-surreptitiously-rebuild-list 'NO-MSG-P)
  (message "Omitted 1 bookmark"))

;;;###autoload (autoload 'bmkx-bmenu-omit/unomit-marked "bookmark-x")
(defun bmkx-bmenu-omit/unomit-marked () ; Bound to `- >' in bookmark list
  "Omit all marked bookmarks or, if showing only omitted ones, unomit."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (if (eq bmkx-bmenu-filter-function  'bmkx-omitted-alist-only)
      (bmkx-bmenu-unomit-marked)
    (bmkx-bmenu-omit-marked)))

;;;###autoload (autoload 'bmkx-bmenu-omit-marked "bookmark-x")
(defun bmkx-bmenu-omit-marked ()        ; Bound to `- >' in bookmark list
  "Omit all marked bookmarks.
They will henceforth be invisible to the bookmark list.
You can, however, use \\<bmkx-list-mode-map>`\\[bmkx-bmenu-show-only-omitted-bookmarks]' \
to see them.
You can then mark some of them and use `\\[bmkx-bmenu-omit/unomit-marked]' to make those marked
 available again for the bookmark list."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (let ((o-str    (and (not (looking-at-p "^>"))  (bmkx-list-bookmark)))
        (o-point  (point))
        (count    0))
    (message "Omitting marked bookmarks...")
    (goto-char (point-min)) (forward-line bmkx-bmenu-header-lines)
    (while (re-search-forward "^>" (point-max) t)
      (setq bmkx-bmenu-omitted-bookmarks  (cons (bmkx-list-bookmark) bmkx-bmenu-omitted-bookmarks)
            count                         (1+ count)))
    (if (<= count 0)
        (message "No marked bookmarks")
      (bmkx-list-surreptitiously-rebuild-list 'NO-MSG-P)
      (message "Omitted %d bookmarks" count))
    (if o-str
        (bmkx-bmenu-goto-bookmark-named o-str)
      (goto-char o-point)
      (beginning-of-line)))
  (bmkx-fit-bmenu-frame))

;;;###autoload (autoload 'bmkx-bmenu-unomit-marked "bookmark-x")
(defun bmkx-bmenu-unomit-marked ()      ; `- >' in bookmark list when showing omitted bookmarks
  "Remove all marked bookmarks from the list of omitted bookmarks.
They will henceforth be available for display in the bookmark list.
\(In order to see and then mark omitted bookmarks you must use \\<bmkx-list-mode-map>\
`\\[bmkx-bmenu-show-only-omitted-bookmarks]'.)"
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (unless bmkx-bmenu-omitted-bookmarks (error "No omitted bookmarks to UN-omit"))
  (unless (eq bmkx-bmenu-filter-function  'bmkx-omitted-alist-only)
    (error "You must use command `bmkx-bmenu-show-only-omitted-bookmarks' first"))
  (let ((count    0))
    (message "UN-omitting marked bookmarks...")
    (goto-char (point-min)) (forward-line bmkx-bmenu-header-lines)
    (while (re-search-forward "^>" (point-max) t)
      (let ((bmk-name  (bmkx-list-bookmark)))
        (when (bmkx-bookmark-name-member bmk-name bmkx-bmenu-omitted-bookmarks)
          (setq bmkx-bmenu-omitted-bookmarks  (bmkx-delete-bookmark-name-from-list
                                               bmk-name bmkx-bmenu-omitted-bookmarks)
                count                         (1+ count)))))
    (if (<= count 0)
        (message "No marked bookmarks")
      (setq bmkx-bmenu-filter-function  nil
            bmkx-bmenu-title            "All Bookmarks"
            bmkx-latest-bookmark-alist  bookmark-alist)
      (bmkx-list-surreptitiously-rebuild-list 'NO-MSG-P)
      (message "UN-omitted %d bookmarks" count)))
  (bmkx-fit-bmenu-frame))

;;;###autoload (autoload 'bmkx-bmenu-show-only-omitted-bookmarks "bookmark-x")
(defun bmkx-bmenu-show-only-omitted-bookmarks ()  ; Bound to `- S' in bookmark list to show only omitted
  "Show only the omitted bookmarks.
You can then mark some of them and use `\\<bmkx-list-mode-map>\\[bmkx-bmenu-omit/unomit-marked]' to
 make those that are marked available again for the bookmark list."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (unless bmkx-bmenu-omitted-bookmarks (error "No omitted bookmarks")) ; Cannot use macro for this.
  (setq bmkx-bmenu-filter-function  'bmkx-omitted-alist-only
        bmkx-bmenu-title            "Omitted Bookmarks")
  (let ((bookmark-alist  (funcall bmkx-bmenu-filter-function)))
    (setq bmkx-latest-bookmark-alist  bookmark-alist)
    (bmkx-list 'filteredp))
  (when (called-interactively-p 'interactive)
    (bmkx-msg-about-sort-order (bmkx-current-sort-order) "Only omitted bookmarks are shown now")))


;;(@* "Search-and-Replace Locations of Marked Bookmarks")
;;  *** Search-and-Replace Locations of Marked Bookmarks ***

(defun bmkx-bmenu-isearch-marked-bookmarks (&optional allp include-omitted-p)
                                        ; Bound to `M-s a C-s' in bookmark list
  "Isearch the marked bookmark locations, in their current order.
If no bookmark is marked, search the bookmark of the current line.

With a non-negative prefix arg, search all bookmarks.

Omitted bookmarks are excluded, by default.  With a negative prefix
arg, any that are marked are included."
  (interactive (list (and current-prefix-arg  (>= (prefix-numeric-value current-prefix-arg) 0))
                     (and current-prefix-arg  (<  (prefix-numeric-value current-prefix-arg) 0))))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (let ((bookmarks        (mapcar #'car (bmkx-sort-omit
                                         (bmkx-bmenu-marked-or-this-or-all allp include-omitted-p))))
        (bmkx-use-region  nil))         ; Suppress region handling.
    (bmkx-isearch-bookmarks bookmarks))) ; Defined in `bookmark-x-1.el'.

(defun bmkx-bmenu-isearch-marked-bookmarks-regexp (&optional allp include-omitted-p)
                                        ; `M-s a M-C-s' in bookmark list
  "Regexp Isearch the marked bookmark locations, in their current order.
If no bookmark is marked, search the bookmark of the current line.

With a non-negative prefix arg, search all bookmarks.

Omitted bookmarks are excluded, by default.  With a negative prefix
arg, any that are marked are included."
  (interactive (list (and current-prefix-arg  (>= (prefix-numeric-value current-prefix-arg) 0))
                     (and current-prefix-arg  (<  (prefix-numeric-value current-prefix-arg) 0))))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (let ((bookmarks        (mapcar #'car (bmkx-sort-omit
                                         (bmkx-bmenu-marked-or-this-or-all allp include-omitted-p))))
        (bmkx-use-region  nil))         ; Suppress region handling.
    (bmkx-isearch-bookmarks-regexp bookmarks))) ; Defined in `bookmark-x-1.el'.

;;;###autoload (autoload 'bmkx-bmenu-search-marked-bookmarks-regexp "bookmark-x")
(defun bmkx-bmenu-search-marked-bookmarks-regexp (regexp &optional allp include-omitted-p)
                                        ; `M-s a M-s' in bookmark list
  "Search the marked file bookmarks, in their current order, for REGEXP.
Use `\\[tags-loop-continue]' to advance among the search hits.
Marked directory and non-file bookmarks are ignored.

If no bookmark is marked, search the bookmark of the current line.

With a non-negative prefix arg, search all bookmarks.

Omitted bookmarks are excluded, by default.  With a negative prefix
arg, any that are marked are included."
  (interactive (list (bmkx-read-regexp "Search marked file bookmarks (regexp): ")
                     (and current-prefix-arg  (>= (prefix-numeric-value current-prefix-arg) 0))
                     (and current-prefix-arg  (<  (prefix-numeric-value current-prefix-arg) 0))))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (tags-search regexp `(let ((files  ())
                             file)
                        (dolist (bmk  (bmkx-sort-omit
                                       (bmkx-bmenu-marked-or-this-or-all ',allp ',include-omitted-p)))
                          (setq file  (bookmark-get-filename bmk))
                          (when (and (not (equal bmkx-non-file-filename file))
                                     (not (file-directory-p file)))
                            (push file files)))
                        (setq files  (nreverse files)))))

;;;###autoload (autoload 'bmkx-bmenu-query-replace-marked-bookmarks-regexp "bookmark-x")
(defun bmkx-bmenu-query-replace-marked-bookmarks-regexp (from to ; Bound to `M-q' in bookmark list
                                                              &optional delimited include-omitted-p)
  "`query-replace-regexp' FROM with TO, for all marked file bookmarks.
If you exit (`\\[keyboard-quit]', `RET' or `q'), you can use `\\[tags-loop-continue]' to resume where
you left off.

If no bookmark is marked, act on the bookmark of the current line.

A non-negative prefix arg means replace only word-delimited matches.

Omitted bookmarks are excluded, by default.  With a non-positive
prefix arg, include any that are marked."
  (interactive (let ((common  (query-replace-read-args "Query replace regexp in marked files" t t)))
                 (list (nth 0 common)
                       (nth 1 common)
                       (and current-prefix-arg  (>= (prefix-numeric-value current-prefix-arg) 0))
                       (and current-prefix-arg  (<= (prefix-numeric-value current-prefix-arg) 0)))))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (fileloop-initialize-replace from to
                               (let ((files  ())
                                     file)
                                 (dolist (bmk  (bmkx-sort-omit
                                                (bmkx-bmenu-marked-or-this-or-all nil include-omitted-p)))
                                   (setq file  (bookmark-get-filename bmk))
                                   (let ((buffer  (get-file-buffer file)))
                                     (when (and buffer  (with-current-buffer buffer buffer-read-only))
                                       (error "File `%s' is visited read-only" file)))
                                   (when (and (not (equal bmkx-non-file-filename file))
                                              (not (file-directory-p file)))
                                     (push file files)))
                                 (setq files  (nreverse files)))
                               'default
                               delimited))


;;(@* "Tags")
;;  *** Tags ***

;; Not bound, but `T 0' is `bmkx-remove-all-tags'.
;;;###autoload (autoload 'bmkx-bmenu-remove-all-tags "bookmark-x")
(defun bmkx-bmenu-remove-all-tags (&optional must-confirm-p)
  "Remove all tags from this bookmark.
Interactively, you are required to confirm."
  (interactive "p")
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-list-ensure-position)
  (let ((bookmark  (bmkx-list-bookmark)))
    (when (and must-confirm-p  (null (bmkx-get-tags bookmark)))
      (error "Bookmark has no tags to remove"))
    (when (or (not must-confirm-p)  (y-or-n-p "Remove all tags from this bookmark? "))
      (bmkx-remove-all-tags bookmark))))

;;;###autoload (autoload 'bmkx-bmenu-add-tags "bookmark-x")
(defun bmkx-bmenu-add-tags ()           ; Only on `mouse-3' menu in bookmark list.
  "Add some tags to this bookmark."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-list-ensure-position)
  (let ((nb-added  (bmkx-add-tags (bmkx-list-bookmark) (bmkx-read-tags-completing))))
    (when (and (< nb-added 0)           ; It was untagged but is now tagged.  If `s t' then re-sort.
               (equal bmkx-sort-comparer '((bmkx-tagged-cp) bmkx-alpha-p))) ; Hardcoded value, for now.
      (bmkx-bmenu-sort-tagged-before-untagged))
    nb-added))

;;;###autoload (autoload 'bmkx-bmenu-edit-annotation "bookmark-x")
(defun bmkx-bmenu-edit-annotation ()    ; Bound to `a e' in bookmark list
  "Pop up an annotation-edit buffer for the bookmark on this line.
Like `bmkx-edit-annotation', but uses the bookmark at point in
the `*Bmkx List*' buffer instead of prompting for a name."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-list-ensure-position)
  (bmkx-edit-annotation (bmkx-list-bookmark)))

;;;###autoload (autoload 'bmkx-bmenu-set-tag-value "bookmark-x")
(defun bmkx-bmenu-set-tag-value ()      ; Bound to `T v' in bookmark list
  "Set the value of one of this bookmark's tags."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-list-ensure-position)
  (let ((this-bmk  (bmkx-list-bookmark)))
    (bmkx-set-tag-value
     this-bmk
     (bmkx-read-tag-completing "Tag: " (mapcar 'bmkx-full-tag (bmkx-get-tags this-bmk)))
     (read (read-string "Value: "))
     nil
     'MSG)))

;;;###autoload (autoload 'bmkx-bmenu-set-tag-value-for-marked "bookmark-x")
(defun bmkx-bmenu-set-tag-value-for-marked (tag value &optional allp include-omitted-p msg-p)
                                        ; Bound to `T > v' in bookmark list
  "Set the value of TAG to VALUE, for each of the marked bookmarks.
If any of the bookmarks has no tag named TAG, then add one with VALUE.

If no bookmark is marked, act on the bookmark of the current line.

With a non-negative prefix arg, act on all bookmarks.

Omitted bookmarks are excluded, by default.  With a negative prefix
arg, any that are marked are included.

Non-interactively, non-nil MSG-P means display messages."
  (interactive (list (bmkx-read-tag-completing)
                     (read (read-string "Value: "))
                     (and current-prefix-arg  (>= (prefix-numeric-value current-prefix-arg) 0))
                     (and current-prefix-arg  (<  (prefix-numeric-value current-prefix-arg) 0))
                     'MSG))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (when msg-p (message "Setting tag values..."))
  (let ((marked  (bmkx-bmenu-marked-or-this-or-all allp include-omitted-p)))
    (unless marked (error "No marked bookmarks"))
    (when msg-p (message "Setting tag values..."))
    (bmkx-set-tag-value-for-bookmarks marked tag value))
  (when (and msg-p  tag) (message "Setting tag values...done")))

;;;###autoload (autoload 'bmkx-bmenu-remove-tags "bookmark-x")
(defun bmkx-bmenu-remove-tags (&optional msg-p) ; Only on `mouse-3' menu in bookmark list.
  "Remove some tags from this bookmark.
Non-interactively, non-nil MSG-P means display messages."
  (interactive "p")
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-list-ensure-position)
  (let* ((bmk         (bmkx-list-bookmark))
         (nb-removed  (bmkx-remove-tags bmk
                                        (bmkx-read-tags-completing
                                         (mapcar 'bmkx-full-tag (bmkx-get-tags bmk)) t)
                                        nil
                                        msg-p)))
    (when (and (< nb-removed 0)         ; It was tagged but is now untagged.  If `s t' then re-sort.
               (equal bmkx-sort-comparer '((bmkx-tagged-cp) bmkx-alpha-p))) ; Hardcoded value, for now.
      (bmkx-bmenu-sort-tagged-before-untagged))
    nb-removed))

;;;###autoload (autoload 'bmkx-bmenu-add-tags-to-marked "bookmark-x")
(defun bmkx-bmenu-add-tags-to-marked (tags &optional allp include-omitted-p msg-p)
                                        ; Bound to `T > +' in bookmark list
  "Add TAGS to each of the marked bookmarks.
Hit `RET' to enter each tag, then hit `RET' again after the last tag.
You can use completion to enter each tag, but you are not limited to
choosing existing tags.

If no bookmark is marked, act on the bookmark of the current line.

With a non-negative prefix arg, act on all bookmarks.

Omitted bookmarks are excluded, by default.  With a negative prefix
arg, any that are marked are included.

Non-interactively:
 TAGS is a list of strings.
 Non-nil MSG-P means display messages."
  (interactive (list (bmkx-read-tags-completing)
                     (and current-prefix-arg  (>= (prefix-numeric-value current-prefix-arg) 0))
                     (and current-prefix-arg  (<  (prefix-numeric-value current-prefix-arg) 0))
                     'MSG))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (let ((marked                (bmkx-bmenu-marked-or-this-or-all allp include-omitted-p))
        (curr-bmk              (bmkx-list-bookmark))
        (some-were-untagged-p  nil))
    (unless marked (error "No marked bookmarks"))
    (when msg-p (message "Adding tags..."))
    (let ((bookmark-save-flag  (and (not bmkx-count-multi-mods-as-one-flag)
                                    bookmark-save-flag))) ; Save at most once, after `dolist'.
      (dolist (bmk  (mapcar #'car marked))
        (when (< (bmkx-add-tags bmk tags 'NO-UPDATE-P) 0)  (setq some-were-untagged-p  t))))
    (bmkx-tags-list)                    ; Update the tags cache now, after iterate.
    (bmkx-maybe-save-bookmarks)         ; Increments `bookmark-alist-modification-count'.
    (bmkx-refresh-menu-list curr-bmk (not msg-p)) ; Refresh after iterate.
    (when (and some-were-untagged-p  (equal bmkx-sort-comparer '((bmkx-tagged-cp) bmkx-alpha-p)))
      (bmkx-bmenu-sort-tagged-before-untagged))
    (when (and msg-p  tags) (message "Tags added: %S" tags))))

;;;###autoload (autoload 'bmkx-bmenu-remove-tags-from-marked "bookmark-x")
(defun bmkx-bmenu-remove-tags-from-marked (tags &optional allp include-omitted-p msg-p)
                                        ; Bound to `T > -' in bookmark list
  "Remove TAGS from each of the marked bookmarks.
Hit `RET' to enter each tag, then hit `RET' again after the last tag.
You can use completion to enter each tag.

If no bookmark is marked, act on the bookmark of the current line.

With a non-negative prefix arg, act on all bookmarks.

Omitted bookmarks are excluded, by default.  With a negative prefix
arg, any that are marked are included.

Non-interactively, non-nil MSG-P means display messages."
  (interactive
   (let ((tgs  ())
         (all  (and current-prefix-arg  (>= (prefix-numeric-value current-prefix-arg) 0)))
         (omt  (and current-prefix-arg  (<  (prefix-numeric-value current-prefix-arg) 0))))
           
     (dolist (bmk  (bmkx-bmenu-marked-or-this-or-all all omt))
       (setq tgs  (bmkx-set-union tgs (bmkx-get-tags bmk))))
     (unless tgs (error "No tags to remove"))
     (list (bmkx-read-tags-completing tgs t) all omt 'MSG)))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (let ((marked    (if allp
                       bookmark-alist
                     (or (if include-omitted-p
                             (bmkx-marked-bookmarks-only)
                           (bmkx-remove-if #'bmkx-omitted-bookmark-p (bmkx-marked-bookmarks-only)))
                         (and (bmkx-list-bookmark)
                              (list (bmkx-get-bookmark (bmkx-list-bookmark)))))))
        (curr-bmk  (bmkx-list-bookmark))
        (some-are-now-untagged-p  nil))
    (unless marked (error "No marked bookmarks"))
    (when msg-p (message "Removing tags..."))
    (let ((bookmark-save-flag  (and (not bmkx-count-multi-mods-as-one-flag)
                                    bookmark-save-flag))) ; Save at most once, after `dolist'.
      (dolist (bmk  (mapcar #'car marked))
        (when (< (bmkx-remove-tags bmk tags 'NO-UPDATE-P) 0)  (setq some-are-now-untagged-p  t))))
    (bmkx-tags-list)                    ; Update the tags cache now, after iterate.
    (bmkx-maybe-save-bookmarks)         ; Increments `bookmark-alist-modification-count'.
    (bmkx-refresh-menu-list curr-bmk (not msg-p)) ; Refresh after iterate.
    (when (and some-are-now-untagged-p  (equal bmkx-sort-comparer '((bmkx-tagged-cp) bmkx-alpha-p)))
      (bmkx-bmenu-sort-tagged-before-untagged))
    (when (and msg-p  tags) (message "Tags removed: %S" tags))))

;;;###autoload (autoload 'bmkx-bmenu-list-tags-of-marked "bookmark-x")
(defun bmkx-bmenu-list-tags-of-marked (fullp &optional msg-p)
                                        ; Bound to `T > l' in bookmark list
  "List the tags used in the marked bookmarks.
Show the list in the minibuffer or, if not enough space, in buffer
`*All Tags*'.  The tags are listed alphabetically, respecting option
`case-fold-search'.

With no prefix arg, list only the tag names.  With a prefix arg, list
the full alist of tags.  Note that when the full tags alist is shown,
the same tag name appears once for each of its different values.

Non-interactively, non-nil MSG-P means display a status message."
  (interactive "P\np")
  (require 'pp)
  (when msg-p (message "Gathering tags..."))
  (pp-display-expression (sort (let ((bookmark-alist  (bmkx-marked-bookmarks-only))
                                     bmkx-tags-alist) ; Prevent updating it.
                                 (bmkx-tags-list (not fullp) t))
                               (if fullp
                                   (lambda (t1 t2) (bmkx-string-less-case-fold-p (car t1) (car t2)))
                                 'bmkx-string-less-case-fold-p))
                         "*Tags of Marked Bookmarks*"))

;;;###autoload (autoload 'bmkx-bmenu-mark-bookmarks-tagged-regexp "bookmark-x")
(defun bmkx-bmenu-mark-bookmarks-tagged-regexp (regexp &optional notp no-re-sort-p msg-p)
                                        ; `T m %' in bookmark list
  "Mark bookmarks any of whose tags match REGEXP.
With a prefix arg, mark all that are tagged but have no matching tags.

If any bookmark was unmarked before, and if the sort order is marked
first or last (`s >'), then re-sort.

Non-interactively:
* Non-nil NOTP: see prefix arg, above.
* Non-nil optional arg NO-RE-SORT-P inhibits re-sorting.
* Non-nil optional arg MSG-P means display a status message."
  (interactive (list (bmkx-read-regexp "Regexp: ") current-prefix-arg nil
                     (prefix-numeric-value current-prefix-arg)))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (let ((count      0)
        (nb-marked  (length bmkx-bmenu-marked-bookmarks))
        tags anyp)
    (save-excursion
      (goto-char (point-min)) (forward-line bmkx-bmenu-header-lines)
      (when msg-p (message "Updating bookmark-list display..."))
      (while (not (eobp))
        (setq tags  (bmkx-get-tags (bmkx-list-bookmark))
              anyp  (and tags  (bmkx-some (lambda (tag) (string-match-p regexp (bmkx-tag-name tag)))
                                          tags)))
        (if (not (and tags  (if notp (not anyp) anyp)))
            (forward-line 1)
          (bmkx-list-mark 'NO-RE-SORT-P)
          (setq count  (1+ count)))))
    (unless no-re-sort-p
      ;; If some were unmarked before, and if sort order is `s >', then re-sort.
      (when (and (equal bmkx-sort-comparer '((bmkx-marked-cp) bmkx-alpha-p))
                 (/= nb-marked (length bmkx-bmenu-marked-bookmarks)))
        (let ((curr-bmk  (bmkx-list-bookmark)))
          (bmkx-list-surreptitiously-rebuild-list 'NO-MSG-P)
          (when curr-bmk (bmkx-bmenu-goto-bookmark-named curr-bmk)))))
    (when msg-p (if (= 1 count) (message "1 bookmark matched") (message "%d bookmarks matched" count)))))

;;;###autoload (autoload 'bmkx-bmenu-mark-bookmarks-tagged-all "bookmark-x")
(defun bmkx-bmenu-mark-bookmarks-tagged-all (tags &optional nonep msg-p) ; `T m *' in bookmark list
  "Mark all visible bookmarks that are tagged with *each* tag in TAGS.
As a special case, if TAGS is empty, then mark the bookmarks that have
any tags at all (i.e., at least one tag).

With a prefix arg, mark all that are *not* tagged with *any* TAGS."
  (interactive (list (bmkx-read-tags-completing) current-prefix-arg 'MSG))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-bmenu-mark/unmark-bookmarks-tagged-all/none tags nonep nil nil msg-p))

;;;###autoload (autoload 'bmkx-bmenu-mark-bookmarks-tagged-none "bookmark-x")
(defun bmkx-bmenu-mark-bookmarks-tagged-none (tags &optional allp msg-p) ; `T m ~ +' in bookmark list
  "Mark all visible bookmarks that are not tagged with *any* tag in TAGS.
As a special case, if TAGS is empty, then mark the bookmarks that have
no tags at all.

With a prefix arg, mark all that are tagged with *each* tag in TAGS."
  (interactive (list (bmkx-read-tags-completing) current-prefix-arg 'MSG))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-bmenu-mark/unmark-bookmarks-tagged-all/none tags (not allp) nil nil msg-p))

;;;###autoload (autoload 'bmkx-bmenu-mark-bookmarks-tagged-some "bookmark-x")
(defun bmkx-bmenu-mark-bookmarks-tagged-some (tags &optional somenotp msg-p) ; `T m +' in bookmark list
  "Mark all visible bookmarks that are tagged with *some* tag in TAGS.
As a special case, if TAGS is empty, then mark the bookmarks that have
any tags at all.

With a prefix arg, mark all that are *not* tagged with *all* TAGS.

Hit `RET' to enter each tag, then hit `RET' again after the last tag.
You can use completion to enter each tag."
  (interactive (list (bmkx-read-tags-completing) current-prefix-arg 'MSG))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-bmenu-mark/unmark-bookmarks-tagged-some/not-all tags somenotp nil nil msg-p))

;;;###autoload (autoload 'bmkx-bmenu-mark-bookmarks-tagged-not-all "bookmark-x")
(defun bmkx-bmenu-mark-bookmarks-tagged-not-all (tags &optional somep msg-p) ; `T m ~ *' in bmk list
  "Mark all visible bookmarks that are *not* tagged with *all* TAGS.
As a special case, if TAGS is empty, then mark the bookmarks that have
no tags at all.

With a prefix arg, mark all that are tagged with *some* tag in TAGS."
  (interactive (list (bmkx-read-tags-completing) current-prefix-arg 'MSG))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-bmenu-mark/unmark-bookmarks-tagged-some/not-all tags (not somep) nil nil msg-p))

;;;###autoload (autoload 'bmkx-bmenu-unmark-bookmarks-tagged-regexp "bookmark-x")
(defun bmkx-bmenu-unmark-bookmarks-tagged-regexp (regexp &optional notp no-re-sort-p msg-p)
                                        ; `T u %' in bookmark list
  "Unmark bookmarks any of whose tags match REGEXP.
With a prefix arg, mark all that are tagged but have no matching tags.

If any bookmark was marked before, and if the sort order is marked
first or last (`s >'), then re-sort.

Non-interactively:
* Non-nil NOTP: see prefix arg, above.
* Non-nil optional arg NO-RE-SORT-P inhibits re-sorting.
* Non-nil optional arg MSG-P means display a status message."
  (interactive (list (bmkx-read-regexp "Regexp: ") current-prefix-arg nil
                     (prefix-numeric-value current-prefix-arg)))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (let ((count      0)
        (nb-marked  (length bmkx-bmenu-marked-bookmarks))
        tags anyp)
    (save-excursion
      (goto-char (point-min)) (forward-line bmkx-bmenu-header-lines)
      (when msg-p (message "Updating bookmark-list display..."))
      (while (not (eobp))
        (setq tags  (bmkx-get-tags (bmkx-list-bookmark))
              anyp  (and tags  (bmkx-some (lambda (tag) (string-match-p regexp (bmkx-tag-name tag)))
                                          tags)))
        (if (not (and tags  (if notp (not anyp) anyp)))
            (forward-line 1)
          (bmkx-list-unmark nil 'NO-RE-SORT-P)
          (setq count  (1+ count)))))
    (unless no-re-sort-p
      ;; If some were marked before, and if sort order is `s >', then re-sort.
      (when (and (equal bmkx-sort-comparer '((bmkx-marked-cp) bmkx-alpha-p))
                 (/= nb-marked (length bmkx-bmenu-marked-bookmarks)))
        (let ((curr-bmk  (bmkx-list-bookmark)))
          (bmkx-list-surreptitiously-rebuild-list 'NO-MSG-P)
          (when curr-bmk (bmkx-bmenu-goto-bookmark-named curr-bmk)))))
    (when msg-p (if (= 1 count) (message "1 bookmark matched") (message "%d bookmarks matched" count)))))

;;;###autoload (autoload 'bmkx-bmenu-unmark-bookmarks-tagged-all "bookmark-x")
(defun bmkx-bmenu-unmark-bookmarks-tagged-all (tags &optional nonep msg-p) ; `T u *' in bookmark list
  "Unmark all visible bookmarks that are tagged with *each* tag in TAGS.
As a special case, if TAGS is empty, then unmark the bookmarks that have
any tags at all.

With a prefix arg, unmark all that are *not* tagged with *any* TAGS."
  (interactive (list (bmkx-read-tags-completing) current-prefix-arg 'MSG))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-bmenu-mark/unmark-bookmarks-tagged-all/none tags nonep 'UNMARK nil msg-p))

;;;###autoload (autoload 'bmkx-bmenu-unmark-bookmarks-tagged-none "bookmark-x")
(defun bmkx-bmenu-unmark-bookmarks-tagged-none (tags &optional allp msg-p) ; `T u ~ +' in bookmark list
  "Unmark all visible bookmarks that are *not* tagged with *any* TAGS.
As a special case, if TAGS is empty, then unmark the bookmarks that have
no tags at all.

With a prefix arg, unmark all that are tagged with *each* tag in TAGS."
  (interactive (list (bmkx-read-tags-completing) current-prefix-arg 'MSG))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-bmenu-mark/unmark-bookmarks-tagged-all/none tags (not allp) 'UNMARK nil msg-p))

;;;###autoload (autoload 'bmkx-bmenu-unmark-bookmarks-tagged-some "bookmark-x")
(defun bmkx-bmenu-unmark-bookmarks-tagged-some (tags &optional somenotp msg-p) ; `T u +' in bmk list
  "Unmark all visible bookmarks that are tagged with *some* tag in TAGS.
As a special case, if TAGS is empty, then unmark the bookmarks that have
any tags at all.

With a prefix arg, unmark all that are *not* tagged with *all* TAGS."
  (interactive (list (bmkx-read-tags-completing) current-prefix-arg 'MSG))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-bmenu-mark/unmark-bookmarks-tagged-some/not-all tags somenotp 'UNMARK nil msg-p))

;;;###autoload (autoload 'bmkx-bmenu-unmark-bookmarks-tagged-not-all "bookmark-x")
(defun bmkx-bmenu-unmark-bookmarks-tagged-not-all (tags &optional somep msg-p) ; `T u ~ *' in bmk list
  "Unmark all visible bookmarks that are *not* tagged with *all* TAGS.
As a special case, if TAGS is empty, then unmark the bookmarks that have
no tags at all.

With a prefix arg, unmark all that are tagged with *some* TAGS."
  (interactive (list (bmkx-read-tags-completing) current-prefix-arg 'MSG))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-bmenu-mark/unmark-bookmarks-tagged-some/not-all tags (not somep) 'UNMARK nil msg-p))

(defun bmkx-bmenu-mark/unmark-bookmarks-tagged-all/none (tags &optional nonep unmarkp no-re-sort-p msg-p)
  "Mark or unmark visible bookmarks tagged with all or none of TAGS.
TAGS is a list of strings, the tag names.
Non-nil NONEP means mark/unmark bookmarks that have none of the TAGS.
Non-nil UNMARKP means unmark; nil means mark.
Non-nil NO-RE-SORT-P inhibits re-sorting.
Non-nil MSG-P means display a status message.

As a special case, if TAGS is empty, then mark or unmark the bookmarks
that have any tags at all, or if NONEP is non-nil then mark or unmark
those that have no tags at all.

If any bookmark was (un)marked before but is not afterward, and if the
sort order is marked first or last (`s >'), then re-sort."
  (with-current-buffer bmkx-bmenu-buffer
    (let ((count      0)
          (nb-marked  (length bmkx-bmenu-marked-bookmarks))
          bmktags presentp)
      (save-excursion
        (goto-char (point-min)) (forward-line bmkx-bmenu-header-lines)
        (when msg-p (message "Updating bookmark-list display..."))
        (while (not (eobp))
          (setq bmktags  (bmkx-get-tags (bmkx-list-bookmark)))
          (if (not (if (null tags)
                       (if nonep (not bmktags) bmktags)
                     (and bmktags  (catch 'bmkx-b-mu-b-t-an
                                     (dolist (tag  tags)
                                       (setq presentp  (assoc-default tag bmktags nil t))
                                       (unless (if nonep (not presentp) presentp)
                                         (throw 'bmkx-b-mu-b-t-an nil)))
                                     t))))
              (forward-line 1)
            (if unmarkp (bmkx-list-unmark nil 'NO-RE-SORT-P) (bmkx-list-mark 'NO-RE-SORT-P))
            (setq count  (1+ count)))))
      (unless no-re-sort-p
        ;; If some were (un)marked before but not afterward, and if sort order is `s >', then re-sort.
        (when (and (equal bmkx-sort-comparer '((bmkx-marked-cp) bmkx-alpha-p))
                   (/= nb-marked (length bmkx-bmenu-marked-bookmarks)))
          (let ((curr-bmk  (bmkx-list-bookmark)))
            (bmkx-list-surreptitiously-rebuild-list 'NO-MSG-P)
            (when curr-bmk (bmkx-bmenu-goto-bookmark-named curr-bmk)))))
      (when msg-p
        (if (= 1 count) (message "1 bookmark matched") (message "%d bookmarks matched" count))))))

(defun bmkx-bmenu-mark/unmark-bookmarks-tagged-some/not-all (tags &optional notallp unmarkp
                                                             no-re-sort-p msg-p)
  "Mark or unmark visible bookmarks tagged with any or not all of TAGS.
TAGS is a list of strings, the tag names.
Non-nil NOTALLP means mark/unmark bookmarks that do not have all TAGS.
Non-nil UNMARKP means unmark; nil means mark.
Non-nil NO-RE-SORT-P inhibits re-sorting.
Non-nil MSG-P means display a status message.

As a special case, if TAGS is empty, then mark or unmark the bookmarks
that have any tags at all, or if NOTALLP is non-nil then mark or
unmark those that have no tags at all.

If any bookmark was (un)marked before but is not afterward, and if the
sort order is marked first or last (`s >'), then re-sort."
  (with-current-buffer bmkx-bmenu-buffer
    (let ((count      0)
          (nb-marked  (length bmkx-bmenu-marked-bookmarks))
          bmktags presentp)
      (save-excursion
        (goto-char (point-min)) (forward-line bmkx-bmenu-header-lines)
        (when msg-p (message "Updating bookmark-list display..."))
        (while (not (eobp))
          (setq bmktags  (bmkx-get-tags (bmkx-list-bookmark)))
          (if (not (if (null tags)
                       (if notallp (not bmktags) bmktags)
                     (and bmktags  (catch 'bmkx-b-mu-b-t-sna
                                     (dolist (tag  tags)
                                       (setq presentp  (assoc-default tag bmktags nil t))
                                       (when (if notallp (not presentp) presentp)
                                         (throw 'bmkx-b-mu-b-t-sna t)))
                                     nil))))
              (forward-line 1)
            (if unmarkp (bmkx-list-unmark nil 'NO-RE-SORT-P) (bmkx-list-mark 'NO-RE-SORT-P))
            (setq count  (1+ count)))))
      (unless no-re-sort-p
        ;; If some were (un)marked before but not afterward, and if sort order is `s >', then re-sort.
        (when (and (equal bmkx-sort-comparer '((bmkx-marked-cp) bmkx-alpha-p))
                   (/= nb-marked (length bmkx-bmenu-marked-bookmarks)))
          (let ((curr-bmk  (bmkx-list-bookmark)))
            (bmkx-list-surreptitiously-rebuild-list 'NO-MSG-P)
            (when curr-bmk (bmkx-bmenu-goto-bookmark-named curr-bmk)))))
      (when msg-p
        (if (= 1 count) (message "1 bookmark matched") (message "%d bookmarks matched" count))))))

;;;###autoload (autoload 'bmkx-bmenu-copy-tags "bookmark-x")
(defun bmkx-bmenu-copy-tags (&optional msg-p) ; `T c', `T M-w', `mouse-3' menu in bookmark list.
  "Copy tags from this bookmark, so you can paste them to another bookmark.
NOTE: It is by design that you can *remove all* tags from a bookmark
by copying an empty set of tags and then pasting to that bookmark
using replacement.  So be careful pasting with replacement.  If you
want to be sure that you do not replace tags with an empty list of
tags, you can check the value of variable `bmkx-copied-tags' before
pasting."
  (interactive (list 'MSG))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-list-ensure-position)
  (bmkx-copy-tags (bmkx-list-bookmark) msg-p))

;;;###autoload (autoload 'bmkx-bmenu-paste-add-tags "bookmark-x")
(defun bmkx-bmenu-paste-add-tags (&optional msg-p) ; `T p', `T C-y', `mouse-3' menu in bookmark list.
  "Add tags to this bookmark that were copied from another bookmark."
  (interactive (list 'MSG))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-list-ensure-position)
  (bmkx-paste-add-tags (bmkx-list-bookmark) nil msg-p))

;;;###autoload (autoload 'bmkx-bmenu-paste-replace-tags "bookmark-x")
(defun bmkx-bmenu-paste-replace-tags (&optional msg-p) ; `T q', `mouse-3' menu.
  "Replace tags for this bookmark with those copied from another bookmark.
NOTE: It is by design that you can *remove all* tags from a bookmark
by copying an empty set of tags and then pasting to that bookmark
using this command.  So be careful using it.  If you want to be sure
that you do not replace tags with an empty list of tags, you can check
the value of variable `bmkx-copied-tags' before pasting."
  (interactive (list 'MSG))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-list-ensure-position)
  (bmkx-paste-replace-tags (bmkx-list-bookmark) nil msg-p))

;;;###autoload (autoload 'bmkx-bmenu-paste-add-tags-to-marked "bookmark-x")
(defun bmkx-bmenu-paste-add-tags-to-marked (&optional allp include-omitted-p msg-p)
                                        ; Bound to `T > p', `T > C-y' in bookmark list
  "Add tags that were copied from another bookmark to the marked bookmarks.
If no bookmark is marked, act on the bookmark of the current line.

With a non-negative prefix arg, act on all bookmarks.

Omitted bookmarks are excluded, by default.  With a negative prefix
arg, any that are marked are included.

Non-interactively, non-nil MSG-P means display messages."
  (interactive (list (and current-prefix-arg  (>= (prefix-numeric-value current-prefix-arg) 0))
                     (and current-prefix-arg  (<  (prefix-numeric-value current-prefix-arg) 0))
                     'MSG))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (let ((marked  (bmkx-bmenu-marked-or-this-or-all allp include-omitted-p))
        (bmk     (bmkx-list-bookmark)))
    (unless marked (error "No marked bookmarks"))
    (when msg-p (message "Adding tags..."))
    (let ((bookmark-save-flag  (and (not bmkx-count-multi-mods-as-one-flag)
                                    bookmark-save-flag))) ; Save at most once, after `dolist'.
      (dolist (bmk  marked) (bmkx-paste-add-tags bmk 'NO-UPDATE-P)))
    (bmkx-tags-list)                    ; Update the tags cache now, after iterate.
    (bmkx-maybe-save-bookmarks)         ; Increments `bookmark-alist-modification-count'.
    (bmkx-refresh-menu-list bmk (not msg-p)) ; Refresh after iterate.
    (when msg-p (message "Tags added: %S" bmkx-copied-tags))))

;;;###autoload (autoload 'bmkx-bmenu-paste-replace-tags-for-marked "bookmark-x")
(defun bmkx-bmenu-paste-replace-tags-for-marked (&optional allp include-omitted-p msg-p) ; `T > q'
  "Replace tags for the marked bookmarks with tags copied previously.
NOTE: It is by design that you can *remove all* tags from a bookmark
by copying an empty set of tags and then pasting to that bookmark
using this command.  So be careful using it.  If you want to be sure
that you do not replace tags with an empty list of tags, you can check
the value of variable `bmkx-copied-tags' before pasting.

If no bookmark is marked, act on the bookmark of the current line.

With a non-negative prefix arg, act on all bookmarks.

Omitted bookmarks are excluded, by default.  With a negative prefix
arg, any that are marked are included.

Non-interactively, non-nil MSG-P means display messages."
  (interactive (list (and current-prefix-arg  (>= (prefix-numeric-value current-prefix-arg) 0))
                     (and current-prefix-arg  (<  (prefix-numeric-value current-prefix-arg) 0))
                     'MSG))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (let ((marked  (bmkx-bmenu-marked-or-this-or-all allp include-omitted-p))
        (bmk     (bmkx-list-bookmark)))
    (unless marked (error "No marked bookmarks"))
    (when msg-p (message "Replacing tags..."))
    (let ((bookmark-save-flag  (and (not bmkx-count-multi-mods-as-one-flag)
                                    bookmark-save-flag))) ; Save at most once, after `dolist'.
      (dolist (bmk  marked) (bmkx-paste-replace-tags bmk 'NO-UPDATE-P)))
    (bmkx-tags-list)                    ; Update the tags cache now, after iterate.
    (bmkx-maybe-save-bookmarks)         ; Increments `bookmark-alist-modification-count'.
    (bmkx-refresh-menu-list bmk (not msg-p)) ; Refresh after iterate.
    (when msg-p (message "Replacement tags: %S" bmkx-copied-tags))))


;;(@* "General Menu-List (`-*bmenu-*') Commands and Functions")
;;  *** General Menu-List (`-*bmenu-*') Commands and Functions ***

;;;###autoload (autoload 'bmkx-bmenu-create/edit-annotations-for-marked "bookmark-x")
(defun bmkx-bmenu-edit-annotations-for-marked (&optional allp include-omitted-p) ; `a >' in bookmark list
  "Edit the annotations of the marked bookmarks, in separate buffers.
Create an annotation for any marked bookmark that has none.
When you finish editing, use `\\[bmkx-edit-annotations-send]'.
The current bookmark list is then updated to reflect your edits.

If no bookmark is marked, edit the annotation of the bookmark of the
current line.

With a non-negative prefix arg, edit annotations for all bookmarks.

Omitted bookmarks are excluded, by default.  With a negative prefix
arg, any that are marked are included."
  (interactive (list (and current-prefix-arg  (>= (prefix-numeric-value current-prefix-arg) 0))
                     (and current-prefix-arg  (<  (prefix-numeric-value current-prefix-arg) 0))))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (setq bmkx-last-bmenu-bookmark  (bmkx-list-bookmark))
  ;; No marked bookmarks.  Mark this bookmark, so that `C-c C-c' in edit buffer will find it.
  (unless bmkx-bmenu-marked-bookmarks (bmkx-list-mark))
  ;; FIXME - Should we re-sort, if it was not annotated and now is, or vice versa, and if `s a'?
  ;; We do that for adding/removing tags - see `bmkx-bmenu-add-tags' and `bmkx-bmenu-remove-tags'.
  ;; If we do it, then do it also for `bookmark-bmenu-edit-annotation' (which is just built-in, so far).
  (let ((bmks  (bmkx-bmenu-marked-or-this-or-all allp include-omitted-p)))
    (unless bmks (error "No marked bookmarks"))
    (dolist (bmk  (bmkx-sort-omit bmks)) (bmkx-edit-annotation bmk))))

;;;###autoload (autoload 'bmkx-bmenu-show-or-edit-annotation "bookmark-x")
(defun bmkx-bmenu-show-or-edit-annotation (editp msg-p) ; Not bound anymore.
  "Show annotation for current bookmark in another window.  `C-u': Edit.
With no prefix arg, show the annotation.  With a prefix arg, edit it."
  (interactive "P\np")
  (if editp (bookmark-bmenu-edit-annotation) (bmkx-list-show-annotation msg-p)))

;;;###autoload (autoload 'bmkx-bmenu-jump-to-marked "bookmark-x")
(defun bmkx-bmenu-jump-to-marked ()
  "Jump to each bookmark marked `>', in another window.
Unlike `bookmark-bmenu-select', this command:
* does not bury buffer `*Bmkx List*' or replace it in its window
* does not unmark the marked bookmarks
* does not include the current bookmark - only the marked are accessed"
  (interactive)
  (dolist (bmk  bmkx-bmenu-marked-bookmarks)
    (bmkx-jump-other-window bmk)))

;;;###autoload (autoload 'bmkx-bmenu-w32-open "bookmark-x")
(defun bmkx-bmenu-w32-open ()           ; Bound to `M-RET' in bookmark list.
  "Use `w32-browser' to open this bookmark."
  (interactive) (let ((bmkx-use-w32-browser-p  t))  (bmkx-list-this-window)))

;; $$$$$$ FIXME?: If `Open' action opens a window-manager window, it might be behind all Emacs frames.
;;;###autoload (autoload 'bmkx-bmenu-w32-open-with-mouse "bookmark-x")
(defun bmkx-bmenu-w32-open-with-mouse (event) ; Bound to `M-mouse-2' in bookmark list.
  "Use `w32-browser' to open the bookmark clicked."
  (interactive "e")
  (let ((bmkx-use-w32-browser-p  t)
        (bmk                     (with-current-buffer (window-buffer (posn-window (event-end event)))
                                   (bmkx-bmenu-barf-if-not-in-menu-list)
                                   (save-excursion (goto-char (posn-point (event-end event)))
                                                   (bmkx-list-bookmark)))))
    (unless bmk (error "No bookmark here"))
    (bmkx-handle-bookmark bmk)
    ;; Probably do not want this.  Users can use `jump-fn' tag if need be.
    ;; (run-hooks 'bookmark-after-jump-hook)
    (let ((jump-fn  (bmkx-get-tag-value bmk "bmkx-jump")))
      (when jump-fn (funcall jump-fn)))
    (when bookmark-automatically-show-annotations (bmkx-show-annotation bmk))))

;;;###autoload (autoload 'bmkx-bmenu-w32-jump-to-marked "bookmark-x")
(defun bmkx-bmenu-w32-jump-to-marked ()    ; Bound to `M-o' in bookmark-list.
  "Use `w32-browser' to open this bookmark and all marked bookmarks."
  (interactive) (let ((bmkx-use-w32-browser-p  t))  (bmkx-bmenu-jump-to-marked)))

;;;###autoload (autoload 'bmkx-bmenu-mode-status-help "bookmark-x")
(defun bmkx-bmenu-mode-status-help () ; Bound to `C-h m' and `?' in bookmark list
  "`describe-mode' + current status of `*Bmkx List*' + face legend."
  (interactive)
  (unless (string= (buffer-name) "*Help*") (bmkx-bmenu-barf-if-not-in-menu-list))
  (let ((describe-function-orig-buffer  (current-buffer)))
    (with-current-buffer (get-buffer-create "*Help*")
      (bmkx-with-help-window
       "*Help*"
       (let ((buffer-read-only  nil)
             top)
         (erase-buffer)
         (save-excursion
           (let ((standard-output  (current-buffer)))
             (describe-function-1 'bmkx-list-mode))
           (help-setup-xref (list #'bmkx-bmenu-mode-status-help) (called-interactively-p 'interactive))
           (goto-char (point-min))
           (search-forward ; This depends on the text written by `bmkx-list-mode'.
            "More bookmarking help below." nil t)
           (delete-region (point-min) (point)) ; Get rid of intro from `describe-function'.
           (insert "*************************** Bookmark List ***************************\n\n")
           (insert "Major mode for editing a list of bookmarks.\n")
           (insert "Each line in `*Bmkx List*' represents an Emacs bookmark.\n")
           (setq top  (copy-marker (point)))
           ;; Add buttons to access help and Customize.
           (when (condition-case nil (require 'help-mode nil t) (error nil))
             (goto-char (point-min))
             (help-insert-xref-button "[Doc in Commentary]" 'bmkx-commentary-button)
             (insert "           ")
             (help-insert-xref-button "[Doc on the Web]" 'bmkx-help-button)
             (insert "           ")
             (help-insert-xref-button "[Customize]" 'bmkx-customize-button)
             (insert "\n\n")
             (goto-char (point-max))
             (insert (substitute-command-keys
                      "\nSend a Bookmark-X bug report: `\\[bmkx-send-bug-report]'.\n\n"))
             (help-insert-xref-button "[Doc in Commentary]" 'bmkx-commentary-button)
             (insert "           ")
             (help-insert-xref-button "[Doc on the Web]" 'bmkx-help-button)
             (insert "           ")
             (help-insert-xref-button "[Customize]" 'bmkx-customize-button)
             (insert "\n\n")
             (goto-char (point-min))
             (forward-line 2))
           (goto-char top)
           (insert (format
                    "\n\nCurrent Status\n--------------\n
Bookmark file:\t%s\nSorted:\t\t\t%s\nFiltering:\t\t%s\nMarked:\t\t\t%d\nOmitted:\t\t%d\n\
Autosave bookmarks:\t%s\nAutosave list display:\t%s\n\n\n"
                    bmkx-current-bookmark-file
                    (if (not bmkx-sort-comparer)
                        "no"
                      (format "%s%s" (or (bmkx-current-sort-order)  "")
                              ;; Code essentially the same as found in `bmkx-msg-about-sort-order'.
                              (if (not (and (consp bmkx-sort-comparer) ; Ordinary single predicate
                                            (consp (car bmkx-sort-comparer))))
                                  (if bmkx-reverse-sort-p "; reversed" "")
                                (if (not (cadr (car bmkx-sort-comparer)))
                                    ;; Single PRED.
                                    (if (or (and bmkx-reverse-sort-p  (not bmkx-reverse-multi-sort-p))
                                            (and bmkx-reverse-multi-sort-p  (not bmkx-reverse-sort-p)))
                                        "; reversed"
                                      "")
                                  ;; In case we want to distinguish:
                                  ;; (if (and bmkx-reverse-sort-p
                                  ;;          (not bmkx-reverse-multi-sort-p))
                                  ;;     "; reversed"
                                  ;;   (if (and bmkx-reverse-multi-sort-p
                                  ;;            (not bmkx-reverse-sort-p))
                                  ;;       "; reversed +"
                                  ;;     ""))

                                  ;; At least two PREDs.
                                  (cond ((and bmkx-reverse-sort-p  (not bmkx-reverse-multi-sort-p))
                                         "; reversed")
                                        ((and bmkx-reverse-multi-sort-p  (not bmkx-reverse-sort-p))
                                         "; each predicate group reversed")
                                        ((and bmkx-reverse-multi-sort-p  bmkx-reverse-sort-p)
                                         "; order of predicate groups reversed")
                                        (t ""))))))
                    (or (and bmkx-bmenu-filter-function  (downcase bmkx-bmenu-title))  "none")
                    (length bmkx-bmenu-marked-bookmarks)
                    (length bmkx-bmenu-omitted-bookmarks)
                    (if bookmark-save-flag "yes" "no")
                    (if bmkx-bmenu-state-file "yes" "no")))

           ;; Add markings legend.
           ;; copy-sequence: put-text-property mutates the string, so the
           ;; binding values must be fresh copies rather than literals.
           (let ((mm   (copy-sequence "  >"))
                 (DD   (copy-sequence "  D"))
                 (tt   (copy-sequence "  t"))
                 (aa   (copy-sequence "  a"))
                 (XX   (copy-sequence "  X"))
                 (mod  (copy-sequence "  *")))
             (put-text-property 2 3 'face 'bmkx->-mark mm)
             (put-text-property 2 3 'face 'bmkx-D-mark DD)
             (put-text-property 2 3 'face 'bmkx-t-mark tt)
             (put-text-property 2 3 'face 'bmkx-a-mark aa)
             (put-text-property 2 3 'face 'bmkx-X-mark XX)
             (put-text-property 2 3 'face 'bmkx-*-mark mod)
             (insert "Legend for Markings\n-------------------\n\n")
             (insert (concat mm  "  marked\n"))
             (insert (concat DD  "  flagged for deletion                     (`x' to delete all such)\n"))
             (insert (concat tt  "  tagged                                   (`C-h C-RET' to see)\n"))
             (insert (concat aa  "  annotated                                (`C-h C-RET' to see)\n"))
             (insert (concat mod "  modified (not saved)\n"))
             (insert (concat XX  "  temporary (will not be saved)\n"))
             (insert "\n\n"))

           ;; Add face legend.
           ;; copy-sequence: put-text-property mutates the string, so the
           ;; binding values must be fresh copies rather than literals.
           (let ((gnus             (copy-sequence "Gnus\n"))
                 (no-jump          (copy-sequence "Bookmarks you cannot jump to from `*Bmkx List*'\n"))
                 (info             (copy-sequence "Info node\n"))
                 (man              (copy-sequence "Man page\n"))
                 (url              (copy-sequence "URL\n"))
                 (local-no-region  (copy-sequence "Local file with no region\n"))
                 (local-w-region   (copy-sequence "Local file with a region\n"))
                 (no-file          (copy-sequence "No such local file\n"))
                 (buffer           (copy-sequence "Buffer\n"))
                 (no-buf           (copy-sequence "No such buffer now\n"))
                 (bad              (copy-sequence "Possibly invalid bookmark\n"))
                 (remote           (copy-sequence "Remote file/directory or Dired buffer (could have wildcards)\n"))
                 (sudo             (copy-sequence "Remote accessed by `su' or `sudo'\n"))
                 (local-dir        (copy-sequence "Local directory or Dired buffer (could have wildcards)\n"))
                 (file-handler     (copy-sequence "Bookmark with entry `file-handler'\n"))
                 (bookmark-list    (copy-sequence "*Bmkx List*\n"))
                 (bookmark-file-leg (copy-sequence "Bookmark file\n"))
                 (snippet          (copy-sequence "Snippet\n"))
                 (desktop          (copy-sequence "Desktop\n"))
                 (sequence         (copy-sequence "Sequence\n"))
                 (variable-list    (copy-sequence "Variable list\n"))
                 (function         (copy-sequence "Function\n")))
             (put-text-property 0 (1- (length gnus))          'face 'bmkx-gnus         gnus)
             (put-text-property 0 (1- (length info))          'face 'bmkx-info         info)
             (put-text-property 0 (1- (length man))           'face 'bmkx-man          man)
             (put-text-property 0 (1- (length url))           'face 'bmkx-url          url)
             (put-text-property 0 (1- (length local-no-region))
                                'face 'bmkx-local-file-without-region                  local-no-region)
             (put-text-property 0 (1- (length local-w-region))
                                'face 'bmkx-local-file-with-region                     local-w-region)
             (put-text-property 0 (1- (length no-file))       'face 'bmkx-no-local     no-file)
             (put-text-property 0 (1- (length buffer))        'face 'bmkx-buffer       buffer)
             (put-text-property 0 (1- (length no-buf))        'face 'bmkx-non-file     no-buf)
             (put-text-property 0 (1- (length remote))        'face 'bmkx-remote-file  remote)
             (put-text-property 0 (1- (length sudo))          'face 'bmkx-su-or-sudo   sudo)
             (put-text-property 0 (1- (length local-dir))
                                'face 'bmkx-local-directory                            local-dir)
             (put-text-property 0 (1- (length file-handler))  'face 'bmkx-file-handler file-handler)
             (put-text-property 0 (1- (length bookmark-list))
                                'face 'bmkx-bookmark-list                               bookmark-list)
             (put-text-property 0 (1- (length bookmark-file-leg))
                                'face 'bmkx-bookmark-file                               bookmark-file-leg)
             (put-text-property 0 (1- (length snippet))       'face 'bmkx-snippet       snippet)
             (put-text-property 0 (1- (length desktop))       'face 'bmkx-desktop       desktop)
             (put-text-property 0 (1- (length sequence))      'face 'bmkx-sequence      sequence)
             (put-text-property 0 (1- (length variable-list)) 'face 'bmkx-variable-list variable-list)
             (put-text-property 0 (1- (length function))      'face 'bmkx-function      function)
             (put-text-property 0 (1- (length no-jump))       'face 'bmkx-no-jump       no-jump)
             (put-text-property 0 (1- (length bad))           'face 'bmkx-bad-bookmark  bad)
             (insert "Legend for Bookmark Types\n-------------------------\n\n")
             (when (and (display-images-p)
                        bmkx-bmenu-image-bookmark-icon-file
                        (file-readable-p bmkx-bmenu-image-bookmark-icon-file))
               (let ((image  (create-image bmkx-bmenu-image-bookmark-icon-file nil nil :ascent 95)))
                 (when image (insert "  ")  (insert-image image)  (insert " Image file\n"))))
             (insert "  " gnus) (insert "  " info) (insert "  " man) (insert "  " url)
             (insert "  " local-no-region) (insert "  " local-w-region) (insert "  " no-file)
             (insert "  " buffer) (insert "  " no-buf) (insert "  " remote) (insert "  " sudo)
             (insert "  " local-dir) (insert "  " file-handler) (insert "  " bookmark-list)
             (insert "  " bookmark-file-leg) (insert "  " snippet) (insert "  " desktop)
             (insert "  " sequence) (insert "  " variable-list) (insert "  " function)
             (insert "  " no-jump) (insert "  " bad)
             (insert "\n\nKeys without prefix `C-x' are available only here (`*Bmkx List*').\n")
             (insert "Keys with prefix `C-x' are available everywhere.\n\n")
             (insert "Remember that you can see all bindings for a prefix key by hitting it,\n")
             (insert "then `C-h'.  E.g., `s C-h' to see keys with prefix `s' (sorting)."))))))))


(when (and (condition-case nil (require 'help-mode nil t) (error nil))
           (get 'help-xref 'button-category-symbol)) ; In `button.el'
  (define-button-type 'bmkx-help-button
      :supertype 'help-xref
      'help-function #'(lambda () (browse-url "https://www.emacswiki.org/emacs/BookmarkPlus"))
      'help-echo
      (purecopy "mouse-2, RET: Bookmark-X documentation on the Emacs Wiki (requires Internet access)"))
  (define-button-type 'bmkx-commentary-button
      :supertype 'help-xref
      'help-function #'(lambda ()
                         (info "(bookmark-x)"))
      'help-echo (purecopy "mouse-2, RET: Bookmark-X Info manual"))
  (define-button-type 'bmkx-customize-button
      :supertype 'help-xref
      'help-function #'(lambda () (customize-group-other-window 'bookmark-plus))
      'help-echo (purecopy "mouse-2, RET: Customize/Browse Bookmark-X Options & Faces")))

;;;###autoload (autoload 'bmkx-bmenu-define-jump-marked-command "bookmark-x")
(defun bmkx-bmenu-define-jump-marked-command () ; Bound to `C-c C-j' in bookmark list
  "Define a command to jump to a bookmark that is one of those now marked.
The bookmarks marked now will be those that are completion candidates
for the command (but omitted bookmarks are excluded).
Save the command definition in `bmkx-bmenu-commands-file'."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (let* ((cands  (mapcar #'list
                         (bmkx-maybe-unpropertize-bookmark-names
                          (bmkx-remove-if #'(lambda (bmk)
                                              (bmkx-bookmark-name-member bmk bmkx-bmenu-omitted-bookmarks))
                                          bmkx-bmenu-marked-bookmarks))))
         (fn     (intern (read-string "Define command to jump to a bookmark now marked: " nil
                                      bmkx-bmenu-define-command-history)))
         (def    `(defun ,fn (bookmark-name &optional flip-use-region-p)
                    (interactive (list (bmkx-read-bookmark-for-type nil ',cands t) current-prefix-arg))
                    (bmkx-jump-1 bookmark-name 'bmkx-select-buffer-other-window flip-use-region-p))))
    (eval def)
    (with-current-buffer (find-file-noselect bmkx-bmenu-commands-file)
      (goto-char (point-max))
      (let ((print-length           nil)
            (print-level            nil)
            (version-control        (cl-case bookmark-version-control
                                      ((nil)      nil)
                                      (never      'never)
                                      (nospecial  version-control)
                                      (t          t)))
            (require-final-newline  t)
            (errorp                 nil))
        (pp def (current-buffer))
        (insert "\n")
        (condition-case nil
            (write-file bmkx-bmenu-commands-file)
          (file-error (setq errorp  t) (error "CANNOT WRITE FILE `%s'" bmkx-bmenu-commands-file)))
        (kill-buffer (current-buffer))
        (unless errorp (message "Command `%s' defined and saved in file `%s'"
                                fn bmkx-bmenu-commands-file))))))

;;;###autoload (autoload 'bmkx-bmenu-define-command "bookmark-x")
(defun bmkx-bmenu-define-command () ; Bound to `C-c C-c' in bookmark list
  "Define a command to use the current sort order, filter, and omit list.
Prompt for the command name.  Save the command definition in
`bmkx-bmenu-commands-file'.

The current sort order, filter function, omit list, and title for
buffer `*Bmkx List*' are encapsulated as part of the command.
Use the command at any time to restore them."
  (interactive)
  (let* ((fn       (intern (read-string "Define sort+filter command: " nil
                                        bmkx-bmenu-define-command-history)))
         (_IGNORE  (when (fboundp fn)
                     (if (y-or-n-p (format "`%s' already defined.  Redfine? " fn))
                         (fmakunbound fn)
                       (error "OK, canceled"))))  
         (def      `(defun ,fn ()
                      (interactive)
                      (setq
                       bmkx-sort-comparer               ',bmkx-sort-comparer
                       bmkx-reverse-sort-p              ',bmkx-reverse-sort-p
                       bmkx-reverse-multi-sort-p        ',bmkx-reverse-multi-sort-p
                       bmkx-bmenu-filter-function       ',bmkx-bmenu-filter-function
                       bmkx-bmenu-filter-pattern        ',bmkx-bmenu-filter-pattern
                       ;; Use `copy-sequence' here, because some code modifies the list structure.
                       bmkx-bmenu-omitted-bookmarks     (copy-sequence
                                                         ',(bmkx-maybe-unpropertize-bookmark-names
                                                            bmkx-bmenu-omitted-bookmarks))
                       bmkx-bmenu-title                 ',bmkx-bmenu-title
                       bookmark-bmenu-toggle-filenames  ',bookmark-bmenu-toggle-filenames)
                      (bmkx-bmenu-refresh-menu-list)
                      (when (called-interactively-p 'interactive)
                        (bmkx-msg-about-sort-order
                         (car (rassoc bmkx-sort-comparer bmkx-sort-orders-alist)))))))
    (eval def)
    (with-current-buffer (find-file-noselect bmkx-bmenu-commands-file)
      (goto-char (point-min)) ; Delete any preexisting defs of the same command.
      (let (sexp)
        (condition-case nil
            (while (setq sexp  (read (current-buffer)))
              (when (and (consp sexp)  (eq 'defun (car sexp))
                         (eq fn (cadr sexp)))
                (delete-region (point) (save-excursion (backward-sexp) (point)))))
          (error nil)))
      (goto-char (point-max))
      (let ((print-length           nil)
            (print-level            nil)
            (version-control        (cl-case bookmark-version-control
                                      ((nil)      nil)
                                      (never      'never)
                                      (nospecial  version-control)
                                      (t          t)))
            (require-final-newline  t)
            (errorp                 nil))
        (pp def (current-buffer))
        (insert "\n")
        (condition-case nil
            (write-file bmkx-bmenu-commands-file)
          (file-error (setq errorp  t) (error "CANNOT WRITE FILE `%s'" bmkx-bmenu-commands-file)))
        (kill-buffer (current-buffer))
        (unless errorp (message "Command `%s' defined and saved in file `%s'"
                                fn bmkx-bmenu-commands-file))))))

;;;###autoload (autoload 'bmkx-bmenu-define-full-snapshot-command "bookmark-x")
(defun bmkx-bmenu-define-full-snapshot-command () ; Bound to `C-c C-S-c' (aka `C-c C-C') in bookmark list
  "Define a command to restore the current bookmark-list state.
Prompt for the command name.  Save the command definition in
`bmkx-bmenu-commands-file'.

Be aware that the command definition can be quite large, since it
copies the current bookmark list and accessory lists (hidden
bookmarks, marked bookmarks, etc.).  For a lighter weight command, use
`bmkx-bmenu-define-full-snapshot-command' instead.  That records only
the omit list and the sort & filter information."
  (interactive)
  (let* ((fn       (intern (read-string "Define restore-snapshot command: " nil
                                        bmkx-bmenu-define-command-history)))
         (_IGNORE  (when (fboundp fn)
                     (if (y-or-n-p (format "`%s' already defined.  Redfine? " fn))
                         (fmakunbound fn)
                       (error "OK, canceled"))))
         (def      `(defun ,fn ()
                      (interactive)
                      ;; Use `copy-sequence' here, to avoid circular references when
                      ;; `bmkx-propertize-bookmark-names-flag' is nil, and for other
                      ;; strings and lists (such as `bmkx-bmenu-marked-bookmarks'),
                      ;; because some code modifies them.
                      ;;
                      (setq
                       bmkx-sort-comparer                     ',bmkx-sort-comparer
                       bmkx-reverse-sort-p                    ',bmkx-reverse-sort-p
                       bmkx-reverse-multi-sort-p              ',bmkx-reverse-multi-sort-p
                       bmkx-latest-bookmark-alist             (copy-sequence
                                                               ',(bmkx-maybe-unpropertize-bookmark-names
                                                                  bmkx-latest-bookmark-alist))
                       bmkx-bmenu-omitted-bookmarks           (copy-sequence
                                                               ',(bmkx-maybe-unpropertize-bookmark-names
                                                                  bmkx-bmenu-omitted-bookmarks 'COPY))
                       bmkx-bmenu-marked-bookmarks            (copy-sequence
                                                               ',(bmkx-maybe-unpropertize-bookmark-names
                                                                  bmkx-bmenu-marked-bookmarks 'COPY))
                       bmkx-bmenu-filter-function             ',bmkx-bmenu-filter-function
                       bmkx-bmenu-filter-pattern              ',bmkx-bmenu-filter-pattern
                       bmkx-bmenu-title                       ',bmkx-bmenu-title
                       bmkx-last-bmenu-bookmark               ',(and (get-buffer bmkx-bmenu-buffer)
                                                                     (with-current-buffer
                                                                         (get-buffer bmkx-bmenu-buffer)
                                                                       (bmkx-maybe-unpropertize-string
                                                                        (bmkx-list-bookmark) 'COPY)))
                       bmkx-last-specific-buffer              ',(copy-sequence bmkx-last-specific-buffer)
                       bmkx-last-specific-file                ',(copy-sequence bmkx-last-specific-file)
                       bookmark-bmenu-toggle-filenames        ',bookmark-bmenu-toggle-filenames
                       bmkx-bmenu-before-hide-marked-alist    (copy-sequence
                                                               ',(bmkx-maybe-unpropertize-bookmark-names
                                                                  bmkx-bmenu-before-hide-marked-alist 'COPY))
                       bmkx-bmenu-before-hide-unmarked-alist  (copy-sequence
                                                               ',(bmkx-maybe-unpropertize-bookmark-names
                                                                  bmkx-bmenu-before-hide-unmarked-alist 'COPY))
                       bmkx-last-bookmark-file                ',(copy-sequence
                                                                 (convert-standard-filename
                                                                  (expand-file-name bmkx-last-bookmark-file)))
                       bmkx-current-bookmark-file             ',(copy-sequence
                                                                 (convert-standard-filename
                                                                  (expand-file-name
                                                                   bmkx-current-bookmark-file))))
                      ;; $$$$$$ Sets *-latest-* also:
                      ;;   (let ((bookmark-alist  (bmkx-refresh-latest-bookmark-list)))
                      (let ((bookmark-alist  (or bmkx-latest-bookmark-alist
                                                 (bmkx-refresh-latest-bookmark-list)))) ; Sets *-latest-* also.
                        (bmkx-bmenu-list-1 'filteredp nil (called-interactively-p 'interactive)))
                      (when bmkx-last-bmenu-bookmark
                        (with-current-buffer (get-buffer bmkx-bmenu-buffer)
                          (bmkx-bmenu-goto-bookmark-named bmkx-last-bmenu-bookmark)))
                      (when (called-interactively-p 'interactive)
                        (bmkx-msg-about-sort-order
                         (car (rassoc bmkx-sort-comparer bmkx-sort-orders-alist)))))))
    (eval def)
    (with-current-buffer (find-file-noselect bmkx-bmenu-commands-file)
      (goto-char (point-min)) ; Delete any preexisting defs of the same command.
      (let (sexp)
        (condition-case nil
            (while (setq sexp  (read (current-buffer)))
              (when (and (consp sexp)  (eq 'defun (car sexp))
                         (eq fn (cadr sexp)))
                (delete-region (point) (save-excursion (backward-sexp) (point)))))
          (error nil)))
      (goto-char (point-max))
      (let ((print-length           nil)
            (print-level            nil)
            (version-control        (cl-case bookmark-version-control
                                      ((nil)      nil)
                                      (never      'never)
                                      (nospecial  version-control)
                                      (t          t)))
            (require-final-newline  t)
            (errorp                 nil))
        (pp def (current-buffer))
        (insert "\n")
        (condition-case nil
            (write-file bmkx-bmenu-commands-file)
          (file-error (setq errorp  t) (error "CANNOT WRITE FILE `%s'" bmkx-bmenu-commands-file)))
        (kill-buffer (current-buffer))
        (unless errorp (message "Command `%s' defined and saved in file `%s'"
                                fn bmkx-bmenu-commands-file))))))

(defun bmkx-maybe-unpropertize-bookmark-names (list &optional copy)
  "Strip text properties from the bookmark names in a copy of LIST.
LIST is a bookmark alist or a list of bookmark names (strings).
Return the updated copy.

Note, however, that this is a shallow copy, so the names are also
stripped within any alist elements of the original LIST.

Non-nil optional arg COPY means copy also each element of LIST.  Use
this if, for example, you have bookmark lists that share bookmarks and
you want to treat the shared bookmarks separately."
  (let ((new-list  (copy-sequence list)))
    (dolist (bmk  new-list)
      (when (and (consp bmk)  (stringp (car bmk))) (setq bmk  (car bmk)))
      (when (stringp bmk)
        (set-text-properties 0 (length bmk) nil bmk)))
    (if copy (mapcar #'copy-sequence new-list) new-list)))

(defun bmkx-maybe-unpropertize-string (string &optional copy)
  "Strip text properties from STRING (destructively).
Return STRING, or a fresh copy if optional COPY is non-nil."
  (set-text-properties 0 (length string) nil string)
  (if copy (copy-sequence string) string))

;; This is a general command.  It is in this file because it uses macro `bmkx-define-sort-command'
;; and it is used mainly in the bookmark list display.
;;;###autoload (autoload 'bmkx-define-tags-sort-command "bookmark-x")
(defun bmkx-define-tags-sort-command (tags &optional msg-p) ; Bound to `T s' in bookmark list
  "Define a command to sort bookmarks in the bookmark list by tags.
Hit `RET' to enter each tag, then hit `RET' again after the last tag.

The new command sorts first by the first tag in TAGS, then by the
second, and so on.

Besides sorting for these specific tags, any bookmark that has a tag
sorts before one that has no tags.  Otherwise, sorting is by bookmark
name, alphabetically.

The name of the new command is `bmkx-bmenu-sort-' followed by the
specified tags, in order, separated by hyphens (`-').  E.g., for TAGS
\(\"alpha\" \"beta\"), the name is `bmkx-bmenu-sort-alpha-beta'.

If you use this function non-interactively, be sure to load library
`bookmark-x-mac.el' first."
  (interactive
   (progn (or (condition-case nil ; Load `bookmark-x-mac.el' when called interactively.
                  (load-library "bookmark-x-mac") ; Use load-library to ensure latest .elc.
                (error nil))
              (require 'bookmark-x-mac))
          (list (bmkx-read-tags-completing) 'MSG)))
  (let ((sort-order  (concat "tags-" (mapconcat #'identity tags "-")))
        (doc-string  (read-string "Doc string for command: "))
        (comparer    ())
        def)
    (dolist (tag  tags)
      (push `(lambda (b1 b2)
               (let ((tags1  (bmkx-get-tags b1))
                     (tags2  (bmkx-get-tags b2)))
                 (cond ((and (assoc-default ,tag tags1 nil t)
                             (assoc-default ,tag tags2 nil t))  nil)
                       ((assoc-default ,tag tags1 nil t)        '(t))
                       ((assoc-default ,tag tags2 nil t)        '(nil))
                       ((and tags1  tags2)                      nil)
                       (tags1                                   '(t))
                       (tags2                                   '(nil))
                       (t                                       nil))))
            comparer))
    (setq comparer  (nreverse comparer)
          comparer  (list comparer 'bmkx-alpha-p))
    (eval (setq def  (macroexpand `(bmkx-define-sort-command ,sort-order ,comparer ,doc-string))))
    (with-current-buffer (find-file-noselect bmkx-bmenu-commands-file)
      (goto-char (point-max))
      (let ((print-length           nil)
            (print-level            nil)
            (version-control        (cl-case bookmark-version-control
                                      ((nil)      nil)
                                      (never      'never)
                                      (nospecial  version-control)
                                      (t          t)))
            (require-final-newline  t)
            (errorp                 nil))
        (pp def (current-buffer))
        (insert "\n")
        (condition-case nil
            (write-file bmkx-bmenu-commands-file)
          (file-error (setq errorp  t) (error "CANNOT WRITE FILE `%s'" bmkx-bmenu-commands-file)))
        (kill-buffer (current-buffer))
        (when (and msg-p  (not errorp))
          (message "Defined and saved command `%s'" (concat "bmkx-bmenu-sort-" sort-order)))))))

;;;###autoload (autoload 'bmkx-bmenu-relocate-marked "bookmark-x")
(defun bmkx-bmenu-relocate-marked (directory &optional include-omitted-p msgp)
                                        ; Bound to `M-R' in bookmark list
  "Relocate target files of all (visible) bookmarks that are marked `>'.
You are prompted for the relocation target directory.
Return the number of bookmarks relocated to DIRECTORY.

Omitted bookmarks are excluded, by default.  With a prefix arg, any
that are marked are included.

Non-interactively, non-nil MSG-P means display messages."
  (interactive (list (funcall #'read-directory-name
                              "Relocate targets of marked bookmarks to directory: "
                              default-directory default-directory)
                     current-prefix-arg
                     'MSGP))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (let ((count  0)
        file)
    (dolist (bmk  (bmkx-sort-omit (bmkx-bmenu-marked-or-this-or-all nil include-omitted-p)))
      (when (and (setq file  (bookmark-get-filename bmk))
                 (not (equal file bmkx-non-file-filename)))
        (setq file   (file-name-nondirectory file)
              count  (1+ count))
        (bookmark-set-filename bmk (expand-file-name file directory))
        (setq bookmark-alist-modification-count
              (1+ bookmark-alist-modification-count))))
    (when (bookmark-time-to-save-p) (bmkx-save))
    (bmkx-list-surreptitiously-rebuild-list)
    (when msgp
      (if (> count 0)
          (message "Relocated %d bookmark%s" count (if (= 1 count) "" "s"))
        (message "No bookmarks relocated")))
    count))

;;;###autoload (autoload 'bmkx-copy-bookmark "bookmark-x")
(defalias 'bmkx-bmenu-copy-bookmark 'bmkx-bmenu-clone-bookmark)
;;;###autoload (autoload 'bmkx-bmenu-clone-bookmark "bookmark-x")
(defun bmkx-bmenu-clone-bookmark (&optional arg confirm-overwrite-p) ; Bound to `M-n' in bookmark list
  "Create a duplicate copy named of the bookmark under the cursor.
The clone name is the same as that bookmark, but with \"<2>\" appended.
With a prefix arg you are instead prompted for the clone name."
  (interactive "P\np")
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-list-ensure-position)
  (let* ((orig     (bmkx-list-bookmark))
         (default  (concat orig "<2>"))
         (new      (if arg
                       (bmkx-completing-read-lax "Clone name" default)
                     default)))
    (while (equal orig new)
      (setq new  (bmkx-completing-read-lax "Clone name (must be different)" default)))
    (bmkx-clone-bookmark orig new confirm-overwrite-p)))

;;;###autoload (autoload 'bmkx-bmenu-edit-bookmark-name-and-location "bookmark-x")
(defun bmkx-bmenu-edit-bookmark-name-and-location (&optional internalp) ; Bound to `r' in bookmark list
  "Edit the bookmark under the cursor: its name and/or location.
With a prefix argument, edit the complete bookmark record (the
internal, Lisp form)."
  (interactive "P")
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-list-ensure-position)
  (let ((bmk-name  (bmkx-list-bookmark)))
    (if internalp
        (bmkx-edit-bookmark-record bmk-name)
      (let* ((new-data  (bmkx-edit-bookmark-name-and-location bmk-name))
             (new-name  (car new-data)))
        (if (not new-data) (message "No changes made") (bmkx-refresh-menu-list new-name))))))

;;;###autoload (autoload 'bmkx-bmenu-edit-tags "bookmark-x")
(defun bmkx-bmenu-edit-tags ()          ; Bound to `T e' in bookmark list
  "Edit the tags of the bookmark under the cursor.
The edited value must be a list each of whose elements is either a
string or a cons whose key is a string."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-list-ensure-position)
  (bmkx-edit-tags (bmkx-list-bookmark)))

;;;###autoload (autoload 'bmkx-bmenu-edit-bookmark-record "bookmark-x")
(defun bmkx-bmenu-edit-bookmark-record () ; Bound to `e' in bookmark list
  "Edit the full record (the Lisp sexp) for the bookmark under the cursor.
When you finish editing, use `\\[bmkx-edit-bookmark-record-send]'.
The current bookmark list is then updated to reflect your edits."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-list-ensure-position)
  (bmkx-edit-bookmark-record (setq bmkx-edit-bookmark-orig-record  (bmkx-list-bookmark))))

;;;###autoload (autoload 'bmkx-bmenu-edit-marked "bookmark-x")
(defun bmkx-bmenu-edit-marked (&optional allp include-omitted-p) ; Bound to `E' in bookmark list
  "Edit the full records (the Lisp sexps) of the marked bookmarks.
If no bookmarks are marked then mark the bookmark on the current line,
and edit its record.

When you finish editing, use `\\[bmkx-edit-bookmark-records-send]'.
The current bookmark list is then updated to reflect your edits.

If no bookmark is marked, edit the bookmark of the current line.

With a non-negative prefix arg, edit all bookmark records.

Omitted bookmarks are excluded, by default.  With a negative prefix
arg, any that are marked are included."
  (interactive (list (and current-prefix-arg  (>= (prefix-numeric-value current-prefix-arg) 0))
                     (and current-prefix-arg  (<  (prefix-numeric-value current-prefix-arg) 0))))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (setq bmkx-last-bmenu-bookmark  (bmkx-list-bookmark))
  ;; No marked bookmarks.  Mark this bookmark, so that `C-c C-c' in edit buffer will find it.
  ;; Do this before we copy and strip full-bookmark property from name, because `bmkx-list-mark'
  ;; propertizes the name.
  (unless bmkx-bmenu-marked-bookmarks (bmkx-list-mark))
  (let ((bufname      "*Edit Marked Bookmarks*")
        (copied-bmks  (mapcar (lambda (bmk)
                                (setq bmk  (copy-sequence bmk)) ; Shallow copy
                                (let ((bname  (bmkx-bookmark-name-from-record bmk)))
                                  ;; Strip properties from name.
                                  (set-text-properties 0 (length bname) nil bname))
                                bmk)
                              (bmkx-bmenu-marked-or-this-or-all allp include-omitted-p))))
    (unless copied-bmks (error "No marked bookmarks"))
    (setq bmkx-edit-bookmark-records-number  (length copied-bmks))
    (bmkx-with-output-to-plain-temp-buffer bufname
     (princ (substitute-command-keys
             (concat ";; Edit the Lisp records for the marked bookmarks.\n;;\n"
                     ";; DO NOT CHANGE THE ORDER of the bookmarks in this buffer.\n"
                     ";; DO NOT DELETE any of them.\n;;\n"
                     ";; Type \\<bmkx-edit-bookmark-records-mode-map>\
`\\[bmkx-edit-bookmark-records-send]' when done.\n;;\n")))
     ;; $$$$$$ (let ((print-circle  t)) (pp copied-bmks)) ; $$$$$$ Should not really be needed now.
     (pp copied-bmks)
     (with-current-buffer bufname
       (goto-char (point-min))
       (buffer-enable-undo)))
    (pop-to-buffer bufname)
    (with-current-buffer (get-buffer bufname) (bmkx-edit-bookmark-records-mode))))

(defun bmkx-bmenu-propertize-item (bookmark start end)
  "Propertize text in buffer from START to END, indicating bookmark type.
This propertizes the name of BOOKMARK.
Also give this region the property `bmkx-bookmark-name' with as value
the name of BOOKMARK as a propertized string.

The propertized string has property `bmkx-full-record' with value
BOOKMARK, which is the full bookmark record, with the string as its
car.

Return the propertized string (the bookmark name)."
  (setq bookmark  (bmkx-get-bookmark bookmark))
  (let* ((bookmark-name   (bmkx-bookmark-name-from-record bookmark))
         (buffp           (bmkx-get-buffer-name bookmark))

         (filep           (bookmark-get-filename bookmark))
         (sudop           (and filep  (boundp 'tramp-file-name-regexp)
                               (string-match-p tramp-file-name-regexp filep)
                               (string-match-p bmkx-su-or-sudo-regexp filep))))
    ;; Tag the name span in the buffer with the bookmark name, so cursor-position
    ;; lookups (`bmkx-list-bookmark') can identify which bookmark is on this line.
    (put-text-property start end 'bmkx-bookmark-name bookmark-name)
    ;; Add faces, mouse face, and tooltips, to characterize the bookmark type.
    (add-text-properties
     start  end
     (cond ((bookmark-prop-get bookmark 'file-handler) ; `file-handler' bookmark
            (append (bmkx-face-prop 'bmkx-file-handler)
                    '(mouse-face highlight follow-link t
                      help-echo "mouse-2: Invoke the `file-handler' for this bookmark")))
           ((bmkx-sequence-bookmark-p bookmark)                                     ; Sequence bookmark
            (append (bmkx-face-prop 'bmkx-sequence)
                    '(mouse-face highlight follow-link t
                      help-echo "mouse-2: Invoke the bookmarks in this sequence")))
           ((bmkx-function-bookmark-p bookmark)                                     ; Function bookmark
            (append (bmkx-face-prop 'bmkx-function)
                    '(mouse-face highlight follow-link t
                      help-echo "mouse-2: Invoke this function bookmark")))
           ((bmkx-variable-list-bookmark-p bookmark)                           ; Variable-list bookmark
            (append (bmkx-face-prop 'bmkx-variable-list)
                    '(mouse-face highlight follow-link t
                      help-echo "mouse-2: Invoke this variable-list bookmark")))
           ((bmkx-bookmark-list-bookmark-p bookmark)                           ; Bookmark-list bookmark
            (append (bmkx-face-prop 'bmkx-bookmark-list)
                    '(mouse-face highlight follow-link t
                      help-echo "mouse-2: Invoke this bookmark-list bookmark")))
           ((bmkx-snippet-bookmark-p bookmark)                                       ; Snippet bookmark
            (append (bmkx-face-prop 'bmkx-snippet)
                    '(mouse-face highlight follow-link t
                      help-echo "mouse-2: Jump to this snippet bookmark")))
           ((bmkx-desktop-bookmark-p bookmark)                                       ; Desktop bookmark
            (append (bmkx-face-prop 'bmkx-desktop)
                    '(mouse-face highlight follow-link t
                      help-echo "mouse-2: Jump to this desktop bookmark")))
           ((bmkx-bookmark-file-bookmark-p bookmark)                           ; Bookmark-file bookmark
            (append (bmkx-face-prop 'bmkx-bookmark-file)
                    '(mouse-face highlight follow-link t
                      help-echo "mouse-2: Load this bookmark's bookmark file")))
           ((bmkx-non-invokable-bookmark-p bookmark)                           ; Non-invokable bookmark
            (append (bmkx-face-prop 'bmkx-no-jump)
                    '(help-echo "You CANNOT JUMP to this bookmark")))
           ((bmkx-info-bookmark-p bookmark)                                             ; Info bookmark
            (append (bmkx-face-prop 'bmkx-info)
                    '(mouse-face highlight follow-link t
                      help-echo "mouse-2: Jump to this Info bookmark")))
           ((bmkx-man-bookmark-p bookmark)                                               ; Man bookmark
            (append (bmkx-face-prop 'bmkx-man)
                    '(mouse-face highlight follow-link t
                      help-echo (format "mouse-2 Goto `man' page"))))
           ((bmkx-gnus-bookmark-p bookmark)                                             ; Gnus bookmark
            (append (bmkx-face-prop 'bmkx-gnus)
                    '(mouse-face highlight follow-link t
                      help-echo "mouse-2: Jump to this Gnus bookmark")))
           ((bmkx-url-bookmark-p bookmark)                                               ; URL bookmark
            (append (bmkx-face-prop 'bmkx-url)
                    `(mouse-face highlight follow-link t
                      help-echo (format "mouse-2: Jump to URL `%s'" ,filep))))
           ((and sudop  (not (bmkx-root-or-sudo-logged-p)))                   ; Root/sudo not logged in
            (append (bmkx-face-prop 'bmkx-su-or-sudo)
                    `(mouse-face highlight follow-link t
                      help-echo (format "mouse-2: Jump to (visit) file `%s'" ,filep))))
           ;; Test for remoteness before any other tests of the file itself
           ;; (e.g. `file-exists-p'), so Tramp does not prompt for a password etc.
           ((and filep  (bmkx-file-remote-p filep)  (not sudop)) ; Remote file (ssh, ftp)
            (append (bmkx-face-prop 'bmkx-remote-file)
                    `(mouse-face highlight follow-link t
                      help-echo (format "mouse-2: Jump to (visit) remote file `%s'" ,filep))))
           ((and filep                  ; Local directory or local Dired buffer (could be wildcards)
                 (or (file-directory-p filep)  (bmkx-dired-bookmark-p bookmark)))
            (append (bmkx-face-prop 'bmkx-local-directory)
                    `(mouse-face highlight follow-link t
                      help-echo (format "mouse-2: Dired directory `%s'" ,filep))))
           ((and filep  (file-exists-p filep) ; Local file with region
                 (bmkx-region-bookmark-p bookmark))
            (append (bmkx-face-prop 'bmkx-local-file-with-region)
                    `(mouse-face highlight follow-link t
                      help-echo (format "mouse-2: Activate region in file `%s'" ,filep))))
           ((and filep  (file-exists-p filep)) ; Local file without region
            (append (bmkx-face-prop 'bmkx-local-file-without-region)
                    `(mouse-face highlight follow-link t
                      help-echo (format "mouse-2: Jump to (visit) file `%s'" ,filep))))
           ; Existing buffer, including for a file bookmark if the file buffer has not yet been saved.
           ((and buffp  (get-buffer buffp))
            (append (bmkx-face-prop 'bmkx-buffer)
                    `(mouse-face highlight follow-link t
                      help-echo (format "mouse-2: Jump to buffer `%s'" ,buffp))))
           ((or (not filep)  (equal filep bmkx-non-file-filename)) ; Non-file, and no existing buffer.
            (append (bmkx-face-prop 'bmkx-non-file)
                    `(mouse-face highlight follow-link t
                      help-echo (format "mouse-2: Create buffer `%s' and jump to it" ,buffp))))
           ((and filep  (not (file-exists-p filep))) ; Local-file bookmark, but no such file exists.
            (bmkx-face-prop 'bmkx-no-local))
           (t (append (bmkx-face-prop 'bmkx-bad-bookmark)
                      `(mouse-face highlight follow-link t
                        help-echo (format "BAD BOOKMARK (maybe): `%s'" ,filep))))))
    bookmark-name))

;;;###autoload (autoload 'bmkx-bmenu-quit "bookmark-x")
(defun bmkx-bmenu-quit ()               ; Bound to `q' in bookmark list
  "Quit the bookmark list (aka \"menu list\").
If `bmkx-bmenu-state-file' is non-nil, then save the state, to be
restored the next time the bookmark list is shown.  Otherwise, reset
the internal lists that record menu-list markings."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (if (not bmkx-bmenu-state-file)
      (setq bmkx-bmenu-marked-bookmarks            ()
            bmkx-bmenu-before-hide-marked-alist    ()
            bmkx-bmenu-before-hide-unmarked-alist  ())
    (when (called-interactively-p 'interactive) (message "Saving bookmark-list display state..."))
    (bmkx-save-menu-list-state)
    (when (called-interactively-p 'interactive) (message "Saving bookmark-list display state...done"))
    (setq bmkx-bmenu-first-time-p  t))
  (quit-window))

(defun bmkx-bmenu-goto-bookmark-named (name)
  "Go to the bookmark whose name is NAME (a string).
Names are unique within `bookmark-alist', so a simple string match
is precise."
  (goto-char (point-min)) (forward-line bmkx-bmenu-header-lines)
  (while (and (not (eobp))
              (not (equal name (bmkx-list-bookmark))))
    (forward-line 1))
  (bmkx-list-ensure-position))     ; Just in case we fall off the end.

;; This is a general function.  It is in this file because it is used only by the bmenu code.
(defun bmkx-bmenu-barf-if-not-in-menu-list ()
  "Raise an error if current buffer is not `*Bmkx List*'."
  (unless (derived-mode-p 'bmkx-list-mode)
    (error "You can only use this command in buffer `*Bmkx List*'")))

(defun bmkx-face-prop (value)
  "Return a list with elements `font-lock-face' and VALUE."
  (list 'font-lock-face value))

(defconst bmkx--bmenu-regexp-> "^>" "Regexp to match `>' in *Bmkx List* first column.")
(defconst bmkx--bmenu-regexp-D "^D" "Regexp to match `D' in *Bmkx List* first column.")
(defconst bmkx--bmenu-regexp-t "^t" "Regexp to match `t' in *Bmkx List* second column.")
(defconst bmkx--bmenu-regexp-X "^X" "Regexp to match `X' in *Bmkx List* third column.")
(defconst bmkx--bmenu-regexp-a "^a" "Regexp to match `a' in *Bmkx List* third column.")
(defconst bmkx--bmenu-regexp-* "^*" "Regexp to match `*' in *Bmkx List* fourth column.")

(defvar bmkx--bmenu-nb-> 0 "Number of `>' in *Bmkx List* first column.")
(defvar bmkx--bmenu-nb-D 0 "Number of `D' in *Bmkx List* first column.")
(defvar bmkx--bmenu-nb-t 0 "Number of `>' in *Bmkx List* second column.")
(defvar bmkx--bmenu-nb-X 0 "Number of `X' in *Bmkx List* third column.")
(defvar bmkx--bmenu-nb-a 0 "Number of `a' in *Bmkx List* third column.")
(defvar bmkx--bmenu-nb-* 0 "Number of `*' in *Bmkx List* fourth column.")

(defun bmkx-bmenu-mode-line-string ()
  "Show, in mode line, information about the current bookmark-list display.
The information includes the sort order and the number of marked,
flagged (for deletion), tagged, temporary, annotated, and modified
bookmarks currently shown.

For each number indication:
 If the current line has the indicator (e.g. mark, flag) and there are
 others with the same indicator listed after it, then show `N/M',
 where N is the number indicated through the current line and M is the
 total number indicated."
  (let* ((bmkx--bmenu-nb->  (count-matches bmkx--bmenu-regexp-> (point-min) (point-max)))
         (bmkx--bmenu-nb-D  (count-matches bmkx--bmenu-regexp-D (point-min) (point-max)))
         (bmkx--bmenu-nb-t  (count-matches bmkx--bmenu-regexp-t (point-min) (point-max)))
         (bmkx--bmenu-nb-X  (count-matches bmkx--bmenu-regexp-X (point-min) (point-max)))
         (bmkx--bmenu-nb-a  (count-matches bmkx--bmenu-regexp-a (point-min) (point-max)))
         (bmkx--bmenu-nb-*  (count-matches bmkx--bmenu-regexp-* (point-min) (point-max)))
         (text-sort   (propertize
                       (concat "sorting " (bmkx-sorting-description (bmkx-current-sort-order)))
                       'face 'bmkx-heading))
         regexp)
    (let ((desc  "")
          nb)
      (dolist (mk  '(?> ?D ?t ?a ?X ?*))
        (setq nb      (symbol-value (intern (format "bmkx--bmenu-nb-%c" mk)))
              regexp  (symbol-value (intern (format "bmkx--bmenu-regexp-%c" mk)))
              desc    (concat
                       desc
                       (and (> nb 0)
                            (propertize
                             (format
                              "%s%d%c"
                              (save-excursion
                                (forward-line 0)
                                (if (looking-at-p (concat regexp ".*"))
                                    (format "%d/" (1+ (count-matches regexp (point-min) (point))))
                                  ""))
                              nb  mk)
                             'face (intern (format "bmkx-%c-mark" mk))))
                       (and (> nb 0)  " "))))
      (format "%s%s" desc text-sort))))

(defun bmkx-bmenu-mode-line () ; This works, but it shows the line number also.
  "Set the mode line for buffer `*Bmkx List*'."
  (condition-case nil
      (progn
        (set (make-local-variable 'mode-name) '(:eval (bmkx-bmenu-mode-line-string)))
        ;; It seems that the line number must be present, and not invisible, for dynamic updating
        ;; of the mode line when you move the cursor among lines.  Moving it way off to the right
        ;; effectively gets rid of it (ugly hack).  See Emacs bug #12867.
        (set (make-local-variable 'mode-line-position) '("%360l (line)")) ; Move it off the screen.
        (set (make-local-variable 'mode-line-format)
             '(("" mode-name "\t" mode-line-buffer-identification mode-line-position))))
    (error nil)))


(when (fboundp 'org-add-link-type)
  (org-add-link-type "bookmark"           'bmkx-jump)
  (org-add-link-type "bookmark-other-win" 'bmkx-jump-other-window)
  (add-hook 'org-store-link-functions 'bmkx-bmenu-store-org-link 'APPEND)
  (defun bmkx-bmenu-store-org-link ()
    "Store a link to this bookmark for insertion in an Org-mode buffer.
If you use a numeric prefix arg with `\\[org-store-link]' then the
bookmark will be jumped to in the same window.  Without a numeric
prefix arg, the link will use another window.  The link type is
`bookmark' or `bookmark-other-win', respectively."
    (require 'org)
    (and (derived-mode-p 'bmkx-list-mode)
         (let* ((other-win  (and current-prefix-arg  (not (consp current-prefix-arg))))
                (bmk        (bmkx-list-bookmark))
                (link       (format "bookmark%s:%s" (if other-win "-other-win" "") bmk))
                (bmk-desc   (format "Bookmark: %s" bmk)))
           (org-link-store-props :type "bookmark" :link link :description bmk-desc)))))


;;(@* "Sorting - Commands")
;;  *** Sorting - Commands ***

;;;###autoload (autoload 'bmkx-bmenu-change-sort-order-repeat "bookmark-x")
(defun bmkx-bmenu-change-sort-order-repeat () ; Bound to `s s'... in bookmark list
  "Cycle to the next sort order."
  (interactive)
  (require 'repeat)
  (bmkx-repeat-command 'bmkx-bmenu-change-sort-order))

;;;###autoload (autoload 'bmkx-bmenu-change-sort-order "bookmark-x")
(defun bmkx-bmenu-change-sort-order (&optional arg)
  "Cycle to the next sort order.
With a prefix arg, reverse the current sort order."
  (interactive "P")
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (setq bmkx-sort-orders-for-cycling-alist  (delq nil bmkx-sort-orders-for-cycling-alist))
  (if arg
      (bmkx-reverse-sort-order)
    (let ((curr-bmk  (bmkx-list-bookmark))
          next-order)
      (let ((orders  (mapcar #'car bmkx-sort-orders-for-cycling-alist)))
        (setq next-order          (or (cadr (member (bmkx-current-sort-order) orders))  (car orders))
              bmkx-sort-comparer  (cdr (assoc next-order bmkx-sort-orders-for-cycling-alist))))
      (message "Sorting...")
      (bmkx-list-surreptitiously-rebuild-list 'NO-MSG-P)
      (when curr-bmk                 ; Put cursor back on the right line.
        (bmkx-bmenu-goto-bookmark-named curr-bmk))
      (when (called-interactively-p 'interactive) (bmkx-msg-about-sort-order next-order)))))

;; This is a general command.  It is in this file because it is used only by the bmenu code.
;;;###autoload (autoload 'bmkx-reverse-sort-order "bookmark-x")
(defun bmkx-reverse-sort-order ()       ; Bound to `s r' in bookmark list
  "Reverse the current bookmark sort order.
If you combine this with \\<bmkx-list-mode-map>\
`\\[bmkx-reverse-multi-sort-order]', then see the doc for that command."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (setq bmkx-reverse-sort-p  (not bmkx-reverse-sort-p))
  (let ((curr-bmk  (bmkx-list-bookmark)))
    (bmkx-list-surreptitiously-rebuild-list 'NO-MSG-P)
    (when curr-bmk                   ; Put cursor back on the right line.
      (bmkx-bmenu-goto-bookmark-named curr-bmk)))
  (when (called-interactively-p 'interactive) (bmkx-msg-about-sort-order (bmkx-current-sort-order))))

;; This is a general command.  It is in this file because it is used only by the bmenu code.
;;;###autoload (autoload 'bmkx-reverse-multi-sort-order "bookmark-x")
(defun bmkx-reverse-multi-sort-order () ; Bound to `s C-r' in bookmark list
  "Reverse the application of multi-sorting predicates.
These are the PRED predicates described for option
`bmkx-sort-comparer'.

This reverses the order in which the predicates are tried, and it
also complements the truth value returned by each predicate.

For example, if the list of multi-sorting predicates is (p1 p2 p3),
then the predicates are tried in the order: p3, p2, p1.  And if a
predicate returns true, `(t)', then the effect is as if it returned
false, `(nil)', and vice versa.

The use of multi-sorting predicates tends to group bookmarks, with the
first predicate corresponding to the first bookmark group etc.

The effect of \\<bmkx-list-mode-map>`\\[bmkx-reverse-multi-sort-order]' is \
roughly as follows:

 - without also `\\[bmkx-reverse-sort-order]', it reverses the bookmark order in each \
group

 - combined with `\\[bmkx-reverse-sort-order]', it reverses the order of the bookmark
   groups, but not the bookmarks within a group

This is a rough description.  The actual behavior can be complex,
because of how each predicate is defined.  If this description helps
you, fine.  If not, just experiment and see what happens. \;-)

Remember that ordinary `\\[bmkx-reverse-sort-order]' reversal on its own is \
straightforward.
If you find `\\[bmkx-reverse-multi-sort-order]' confusing or not helpful, then do not \
use it."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (setq bmkx-reverse-multi-sort-p  (not bmkx-reverse-multi-sort-p))
  (let ((curr-bmk  (bmkx-list-bookmark)))
    (bmkx-list-surreptitiously-rebuild-list 'NO-MSG-P)
    (when curr-bmk                   ; Put cursor back on the right line.
      (bmkx-bmenu-goto-bookmark-named curr-bmk)))
  (when (called-interactively-p 'interactive) (bmkx-msg-about-sort-order (bmkx-current-sort-order))))



;; The ORDER of the macro calls here defines the REVERSE ORDER of
;; `bmkx-sort-orders-alist'.  The first here is thus also the DEFAULT sort order.
;; Entries are traversed by `s s'..., in `bmkx-sort-orders-alist' order.

(bmkx-define-sort-command               ; Bound to `s k' in bookmark list (`k' for "kind")
 "by bookmark type"                     ; `bmkx-bmenu-sort-by-bookmark-type'
 ((bmkx-info-node-name-cp bmkx-url-cp bmkx-gnus-cp bmkx-local-file-type-cp bmkx-handler-cp)
  bmkx-alpha-p)
 "Sort bookmarks by type: Info, URL, Gnus, files, other (by handler name).")

(bmkx-define-sort-command               ; Bound to `s u' in bookmark list
 "by url"                           ; `bmkx-bmenu-sort-by-url'
 ((bmkx-url-cp) bmkx-alpha-p)
 "Sort URL bookmarks alphabetically by their URL/filename.
When two bookmarks are not comparable this way, compare them by
bookmark name.")

;; $$$$$$ Not used now.
;; (bmkx-define-sort-command               ; Bound to `s w 3' in bookmark list
;;  "by W3M url"                           ; `bmkx-bmenu-sort-by-w3m-url'
;;  ((bmkx-w3m-cp) bmkx-alpha-p)
;;  "Sort W3M bookmarks alphabetically by their URL/filename.
;; When two bookmarks are not comparable this way, compare them by
;; bookmark name.")

;; (when (fboundp 'bmkx-eww-cp)
;;   ;; $$$$$$ Not used now.
;;   ;; (bmkx-define-sort-command               ; Bound to `s w e' in bookmark list
;;   ;;  "by EWW url"                           ; `bmkx-bmenu-sort-by-w3m-url'
;;   ;;  ((bmkx-eww-cp) bmkx-alpha-p)
;;   ;;  "Sort EWW bookmarks alphabetically by their URL/filename.
;;   ;; When two bookmarks are not comparable this way, compare them by
;;   ;; bookmark name.")
;;   )

(bmkx-define-sort-command               ; Bound to `s g' in bookmark list
 "by Gnus thread"                       ; `bmkx-bmenu-sort-by-Gnus-thread'
 ((bmkx-gnus-cp) bmkx-alpha-p)
 "Sort Gnus bookmarks by group, then by article, then by message.
When two bookmarks are not comparable this way, compare them by
bookmark name.")

(bmkx-define-sort-command               ; Bound to `s i' in bookmark list
 "by Info node name"                    ; `bmkx-bmenu-sort-by-Info-node-name'
 ((bmkx-info-node-name-cp) bmkx-alpha-p)
 "Sort Info bookmarks by manual (file) name, then node name, then position.
When two bookmarks are not comparable this way, compare them by
bookmark name.")

(bmkx-define-sort-command               ; Bound to `s I' in bookmark list
 "by Info position"                     ; `bmkx-bmenu-sort-by-Info-position'
 ((bmkx-info-position-cp) bmkx-alpha-p)
 "Sort Info bookmarks by manual (file) name, then position (order in book).
When two bookmarks are not comparable this way, compare them by
bookmark name.")

(bmkx-define-sort-command               ; Bound to `s f u' in bookmark list
 "by last local file update"            ; `bmkx-bmenu-sort-by-last-local-file-update'
 ((bmkx-local-file-updated-more-recently-cp) bmkx-alpha-p)
 "Sort bookmarks by last local file update time.
Sort a local file before a remote file, and a remote file before other
bookmarks.  Otherwise, sort by bookmark name.")

(bmkx-define-sort-command               ; Bound to `s f d' in bookmark list
 "by last local file access"            ; `bmkx-bmenu-sort-by-last-local-file-access'
 ((bmkx-local-file-accessed-more-recently-cp) bmkx-alpha-p)
 "Sort bookmarks by last local file access time.
A local file sorts before a remote file, which sorts before other
bookmarks.  Otherwise, sort by bookmark name.")

(bmkx-define-sort-command               ; Bound to `s f s' in bookmark list
 "by local file size"                   ; `bmkx-bmenu-sort-by-local-file-size'
 ((bmkx-local-file-size-cp) bmkx-alpha-p)
 "Sort bookmarks by local file size.
A local file sorts before a remote file, which sorts before other
bookmarks.  Otherwise, sort by bookmark name.")

(bmkx-define-sort-command               ; Bound to `s f n' in bookmark list
 "by file name"                         ; `bmkx-bmenu-sort-by-file-name'
 ((bmkx-file-alpha-cp) bmkx-alpha-p)
 "Sort bookmarks by file name.
When two bookmarks are not comparable by file name, compare them by
bookmark name.")

(bmkx-define-sort-command               ; Bound to `s f k' in bookmark list (`k' for "kind")
 "by local file type"                   ; `bmkx-bmenu-sort-by-local-file-type'
 ((bmkx-local-file-type-cp) bmkx-alpha-p)
 "Sort bookmarks by local file type: file, symlink, directory.
A local file sorts before a remote file, which sorts before other
bookmarks.  Otherwise, sort by bookmark name.")

(bmkx-define-sort-command               ; Bound to `s D' in bookmark list
 "flagged before unflagged"             ; `bmkx-bmenu-sort-flagged-before-unflagged'
 ((bmkx-flagged-cp) bmkx-alpha-p)
 "Sort bookmarks by putting flagged for deletion before unflagged.
Otherwise alphabetize by bookmark name.")

(bmkx-define-sort-command               ; Bound to `s *' in bookmark list
 "modified before unmodified"           ; `bmkx-bmenu-sort-modified-before-unmodified'
 ((bmkx-modified-cp) bmkx-alpha-p)
 "Sort bookmarks by putting modified before unmodified (saved).
Otherwise alphabetize by bookmark name.")

(bmkx-define-sort-command               ; Bound to `s >' in bookmark list
 "marked before unmarked"               ; `bmkx-bmenu-sort-marked-before-unmarked'
 ((bmkx-marked-cp) bmkx-alpha-p)
 "Sort bookmarks by putting marked before unmarked.
Otherwise alphabetize by bookmark name.")

(bmkx-define-sort-command               ; Bound to `s 0' (zero) in bookmark list
 "by creation time"                     ; `bmkx-bmenu-sort-by-creation-time'
 ((bmkx-bookmark-creation-cp) bmkx-alpha-p)
 "Sort bookmarks by the time of their creation.
When one or both of the bookmarks does not have a `created' entry),
compare them by bookmark name.")

(bmkx-define-sort-command               ; Bound to `s a' in bookmark list
 "annotated before unannotated" ; `bmkx-bmenu-sort-annotated-before-unannotated'
 ((bmkx-annotated-cp) bmkx-alpha-p)
 "Sort bookmarks by putting annotated before unannotated.
Otherwise alphabetize by bookmark name.")

(bmkx-define-sort-command               ; Bound to `s b' in bookmark list
 "by last buffer or file access"        ; `bmkx-bmenu-sort-by-last-buffer-or-file-access'
 ((bmkx-buffer-last-access-cp bmkx-local-file-accessed-more-recently-cp)
  bmkx-alpha-p)
 "Sort bookmarks by last buffer access or last local file access.
Sort a bookmark accessed more recently before one accessed less
recently or not accessed.  Sort a bookmark to an existing buffer
before a local file bookmark.  When two bookmarks are not comparable
by such critera, sort them by bookmark name.  (In particular, sort
remote-file bookmarks by bookmark name.")

(bmkx-define-sort-command               ; Bound to `s v' in bookmark list
 "by bookmark visit frequency"          ; `bmkx-bmenu-sort-by-bookmark-visit-frequency'
 ((bmkx-visited-more-cp) bmkx-alpha-p)
 "Sort bookmarks by the number of times they were visited as bookmarks.
When two bookmarks are not comparable by visit frequency, compare them
by bookmark name.")

(bmkx-define-sort-command               ; Bound to `s d' in bookmark list
 "by last bookmark access"              ; `bmkx-bmenu-sort-by-last-bookmark-access'
 ((bmkx-bookmark-last-access-cp) bmkx-alpha-p)
 "Sort bookmarks by the time of their last visit as bookmarks.
When two bookmarks are not comparable by visit time, compare them
by bookmark name.")

(bmkx-define-sort-command               ; Bound to `s n' in bookmark list
 "by bookmark name"                     ; `bmkx-bmenu-sort-by-bookmark-name'
 bmkx-alpha-p
 "Sort bookmarks by bookmark name, respecting `case-fold-search'.")

(bmkx-define-sort-command               ; Bound to `s t' in bookmark list
 "tagged before untagged"               ; `bmkx-bmenu-sort-tagged-before-untagged'
 ((bmkx-tagged-cp) bmkx-alpha-p)
 "Sort bookmarks by putting tagged before untagged.
Otherwise alphabetize by bookmark name.")

;; This is a general option.  It is in this file because it is used mainly by the bmenu code.
;; Its definitions MUST COME AFTER the calls to macro `bmkx-define-sort-command'.
;; Otherwise, they won't pick up a populated `bmkx-sort-orders-alist'.
(defcustom bmkx-sort-orders-for-cycling-alist (copy-sequence bmkx-sort-orders-alist)
  "*Alist of sort orders used for cycling via `s s'...
This is a subset of the complete list of available sort orders,
`bmkx-sort-orders-alist'.  This lets you cycle among fewer sort
orders, if there are some that you do not use often.

See the doc for `bmkx-sort-orders-alist', for the structure of
this value."
  :type '(alist
          :key-type (choice :tag "Sort order" string symbol)
          :value-type (choice
                       (const :tag "None (do not sort)" nil)
                       (function :tag "Sorting Predicate")
                       (list :tag "Sorting Multi-Predicate"
                        (repeat (function :tag "Component Predicate"))
                        (choice
                         (const :tag "None" nil)
                         (function :tag "Final Predicate")))))
  :group 'bookmark-plus)


;;(@* "Other Bookmark-X Functions (`bmkx-*')")
;;  *** Other Bookmark-X Functions (`bmkx-*') ***

;;;###autoload (autoload 'bmkx-bmenu-show-this-annotation+move-down "bookmark-x")
(defun bmkx-bmenu-show-this-annotation+move-down (&optional n) ; Bound to `M-down' in bookmark list
  "Move down N lines in bookmark-list display and show annotation, if any."
  (interactive "p")
  (bmkx-bmenu-kill-annotation)
  (forward-line n)
  (bmkx-list-show-annotation 'MSGP))

;;;###autoload (autoload 'bmkx-bmenu-show-this-annotation+move-up "bookmark-x")
(defun bmkx-bmenu-show-this-annotation+move-up (&optional n) ; Bound to `M-up' in bookmark list
  "Move up N lines in bookmark-list display and show annotation, if any."
  (interactive "p")
  (bmkx-bmenu-kill-annotation)
  (forward-line (- n))
  (bmkx-list-show-annotation 'MSGP))

(defun bmkx-bmenu-kill-annotation (&optional bookmark-name)
  "Kill annotation buffer, if any, for BOOKMARK-NAME.
If BOOKMARK-NAME is nil, use the bookmark of the current line.
Return non-nil only if there was such an annotation buffer."
  (let ((ann-buf  (get-buffer (format "*`%s' Annotation*"
                                      (or bookmark-name  (bmkx-list-bookmark))))))
    (when ann-buf (kill-buffer ann-buf))))

;;;###autoload (autoload 'bmkx-bmenu-describe-this+move-down "bookmark-x")
(defun bmkx-bmenu-describe-this+move-down (&optional defn) ; Bound to `C-down' in bookmark list
  "Move to next line in bookmark-list display and describe the bookmark.
With a prefix argument, show the internal definition of the bookmark."
  (interactive "P")
  (forward-line 1)
  (bmkx-bmenu-describe-this-bookmark defn))

;;;###autoload (autoload 'bmkx-bmenu-describe-this+move-up "bookmark-x")
(defun bmkx-bmenu-describe-this+move-up (&optional defn) ; Bound to `C-up' in bookmark list
  "Move to previous line in bookmark-list display and describe the bookmark.
With a prefix argument, show the internal definition of the bookmark."
  (interactive "P")
  (forward-line -1)
  (bmkx-bmenu-describe-this-bookmark defn))

;;;###autoload (autoload 'bmkx-bmenu-describe-this-bookmark "bookmark-x")
(defun bmkx-bmenu-describe-this-bookmark (&optional defn) ; Bound to `C-h RET' in bookmark list
  "Describe bookmark of current line.
With a prefix argument, show the internal definition of the bookmark."
  (interactive "P")
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (save-selected-window (if defn
                            (bmkx-describe-bookmark-internals (bmkx-list-bookmark))
                          (bmkx-describe-bookmark (bmkx-list-bookmark)))))

;;;###autoload (autoload 'bmkx-bmenu-describe-marked "bookmark-x")
(defun bmkx-bmenu-describe-marked (&optional defn include-omitted-p) ; Bound to `C-h >' in bookmark list
  "Describe the marked bookmarks, in the current sort order.
If no bookmark is marked, act on the bookmark of the current line.

With a non-negative prefix argument, show the internal definitions.

Omitted bookmarks are excluded, by default.  With a non-positive
prefix arg, any that are marked are included."
  (interactive (list (and current-prefix-arg  (>= (prefix-numeric-value current-prefix-arg) 0))
                     (and current-prefix-arg  (<= (prefix-numeric-value current-prefix-arg) 0))))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (help-setup-xref (list #'bmkx-bmenu-describe-marked) (called-interactively-p 'interactive))
  (bmkx-with-help-window "*Help*"
    (dolist (bmk  (bmkx-sort-omit (bmkx-bmenu-marked-or-this-or-all nil include-omitted-p)))
      (if defn
          (let* ((bname         (bmkx-bookmark-name-from-record bmk))
                 (print-length  nil)    ; For `pp-to-string'
                 (print-level   nil)    ; For `pp-to-string'
                 (help-text     (format "%s\n%s\n\n%s"
                                        bname (make-string (length bname) ?-) (pp-to-string bmk))))
            (princ help-text) (terpri))
        (princ (bmkx-bookmark-description bmk)) (terpri)))))

(defun bmkx-bmenu-get-marked-files ()
  "Return a list of the file names of the marked bookmarks.
Marked bookmarks that have no associated file are ignored."
  (let ((files  ()))
    (dolist (bmk  bmkx-bmenu-marked-bookmarks)
      (when (bmkx-file-bookmark-p bmk) (push (bookmark-get-filename bmk) files)))
    files))

(defun bmkx-bmenu-marked-or-this-or-all (&optional allp include-omitted-p)
  "Return the marked bookmarks or the current-line bookmark if none marked.
Non-nil ALLP means return all bookmarks: `bookmark-alist'.
Do not include marked bookmarks that are omitted, unless optional arg
INCLUDE-OMITTED-P is non-nil.  INCLUDE-OMITTED-P has no effect if none
are marked or ALLP is non-nil."
  (if allp
      bookmark-alist
    (or (if include-omitted-p
            (bmkx-marked-bookmarks-only)
          (bmkx-remove-if #'bmkx-omitted-bookmark-p (bmkx-marked-bookmarks-only)))
        (and (bmkx-list-bookmark)  (list (bmkx-get-bookmark (bmkx-list-bookmark)))))))
 
;;(@* "Keymaps")
;;; Keymaps ----------------------------------------------------------

;; `bmkx-list-mode-map'

(define-key bmkx-list-mode-map (kbd "RET")            'bmkx-list-this-window)
(define-key bmkx-list-mode-map "f"                    'bmkx-list-this-window)
(define-key bmkx-list-mode-map "o"                    'bmkx-list-other-window)
(define-key bmkx-list-mode-map "m"                    'bmkx-list-mark)
(define-key bmkx-list-mode-map "u"                    'bmkx-list-unmark)
(define-key bmkx-list-mode-map "x"                    'bmkx-list-execute-deletions)
(define-key bmkx-list-mode-map "1"                    'bmkx-list-1-window)
(define-key bmkx-list-mode-map "2"                    'bmkx-list-2-window)
(define-key bmkx-list-mode-map (kbd "C-o")            'bmkx-list-switch-other-window)
(define-key bmkx-list-mode-map (kbd "TAB")            'bmkx-list-switch-other-window)
(define-key bmkx-list-mode-map (kbd "<tab>")          'bmkx-list-switch-other-window)
(define-key bmkx-list-mode-map (kbd "M-p")                 'bmkx-list-preview-mode)
(define-key bmkx-list-mode-map (kbd "M-F")                 'bmkx-bmenu-cycle-filename-style)
(define-key bmkx-list-mode-map (kbd "M-T")                 'bmkx-bmenu-toggle-tags-column)
(define-key bmkx-list-mode-map (kbd "M-~")                 'bmkx-toggle-saving-bookmark-file)
(define-key bmkx-list-mode-map (kbd "C-M-~")          'bmkx-toggle-saving-menu-list-state)
(define-key bmkx-list-mode-map "."                    'bmkx-bmenu-show-all)
(define-key bmkx-list-mode-map ">"                    'bmkx-bmenu-toggle-show-only-marked)
(define-key bmkx-list-mode-map "<"                    'bmkx-bmenu-toggle-show-only-unmarked)
(define-key bmkx-list-mode-map (kbd "M-<DEL>")        'bmkx-bmenu-unmark-all)
(define-key bmkx-list-mode-map "->"                   'bmkx-bmenu-omit/unomit-marked)
(define-key bmkx-list-mode-map "-S"                   'bmkx-bmenu-show-only-omitted-bookmarks)
(define-key bmkx-list-mode-map "-U"                   'bmkx-unomit-all)
(define-key bmkx-list-mode-map "=bM"                  'bmkx-bmenu-mark-specific-buffer-bookmarks)
(define-key bmkx-list-mode-map "=fM"                  'bmkx-bmenu-mark-specific-file-bookmarks)
(define-key bmkx-list-mode-map "=bS"                  'bmkx-bmenu-show-only-specific-buffer-bookmarks)
(define-key bmkx-list-mode-map "=fS"                  'bmkx-bmenu-show-only-specific-file-bookmarks)
(define-key bmkx-list-mode-map "%m"                   'bmkx-bmenu-regexp-mark)
(define-key bmkx-list-mode-map "*"                    nil) ; Free `*' as a prefix key
(define-key bmkx-list-mode-map "*m"                   'bmkx-list-mark)
(define-key bmkx-list-mode-map "#M"                   'bmkx-bmenu-mark-autonamed-bookmarks)
(define-key bmkx-list-mode-map "#S"                   'bmkx-bmenu-show-only-autonamed-bookmarks)
;; In the built-in `bookmark.el', `a' shows the current annotation,
;; `A' shows all annotations, and `e' edits the current annotation.
;; Here, those become `aa', `aA', `ae' so that `a' can be a prefix.
(define-key bmkx-list-mode-map "aa"                   'bmkx-list-show-annotation)
(define-key bmkx-list-mode-map "aA"                   'bmkx-show-all-annotations)
(define-key bmkx-list-mode-map "ae"                   'bmkx-bmenu-edit-annotation)
(define-key bmkx-list-mode-map "a>"                   'bmkx-bmenu-edit-annotations-for-marked)
(define-key bmkx-list-mode-map "AM"                   'bmkx-bmenu-mark-autofile-bookmarks)
(define-key bmkx-list-mode-map "AS"                   'bmkx-bmenu-show-only-autofile-bookmarks)
(define-key bmkx-list-mode-map "BM"                   'bmkx-bmenu-mark-non-file-bookmarks)
(define-key bmkx-list-mode-map "BS"                   'bmkx-bmenu-show-only-non-file-bookmarks)
(define-key bmkx-list-mode-map (kbd "M-n")            'bmkx-bmenu-clone-bookmark)
(define-key bmkx-list-mode-map (kbd "C-c C-c")        'bmkx-bmenu-define-command)
(define-key bmkx-list-mode-map (kbd "C-c C-S-c")      'bmkx-bmenu-define-full-snapshot-command)
(define-key bmkx-list-mode-map (kbd "C-c C-j")        'bmkx-bmenu-define-jump-marked-command)
(define-key bmkx-list-mode-map "d"                    'bmkx-bmenu-flag-for-deletion)
(define-key bmkx-list-mode-map "D"                    'bmkx-bmenu-delete-marked)
(define-key bmkx-list-mode-map (kbd "C-d")                 'bmkx-bmenu-flag-for-deletion-backwards)
(define-key bmkx-list-mode-map "\M-d>"                'bmkx-bmenu-dired-marked)
(define-key bmkx-list-mode-map (kbd "M-d M-m")             'bmkx-bmenu-mark-dired-bookmarks)
(define-key bmkx-list-mode-map (kbd "M-d M-s")             'bmkx-bmenu-show-only-dired-bookmarks)
;; `e' is `bookmark-bmenu-edit-annotation' in built-in Emacs.
(define-key bmkx-list-mode-map "e"                    'bmkx-bmenu-edit-bookmark-record)
(define-key bmkx-list-mode-map "E"                    'bmkx-bmenu-edit-marked)
(define-key bmkx-list-mode-map "FM"                   'bmkx-bmenu-mark-file-bookmarks)
(define-key bmkx-list-mode-map "FS"                   'bmkx-bmenu-show-only-file-bookmarks)
(define-key bmkx-list-mode-map "g"                    'bmkx-bmenu-refresh-menu-list)
(define-key bmkx-list-mode-map "GM"                   'bmkx-bmenu-mark-gnus-bookmarks)
(define-key bmkx-list-mode-map "GS"                   'bmkx-bmenu-show-only-gnus-bookmarks)
(define-key bmkx-list-mode-map [remap describe-mode] 'bmkx-bmenu-mode-status-help)
(define-key bmkx-list-mode-map (kbd "C-h >")          'bmkx-bmenu-describe-marked)
(define-key bmkx-list-mode-map (kbd "C-h RET")        'bmkx-bmenu-describe-this-bookmark)
(define-key bmkx-list-mode-map (kbd "C-h C-<return>") 'bmkx-bmenu-describe-this-bookmark)
(define-key bmkx-list-mode-map (kbd "C-<down>")       'bmkx-bmenu-describe-this+move-down)
(define-key bmkx-list-mode-map (kbd "C-<up>")         'bmkx-bmenu-describe-this+move-up)
(define-key bmkx-list-mode-map (kbd "M-<down>")       'bmkx-bmenu-show-this-annotation+move-down)
(define-key bmkx-list-mode-map (kbd "M-<up>")         'bmkx-bmenu-show-this-annotation+move-up)
(define-key bmkx-list-mode-map (kbd "M-<return>")     'bmkx-bmenu-w32-open)
(define-key bmkx-list-mode-map [M-mouse-2]            'bmkx-bmenu-w32-open-with-mouse)
(when (featurep 'bookmark-x-lit)
  (define-key bmkx-list-mode-map "H+"                 'bmkx-bmenu-set-lighting)
  (define-key bmkx-list-mode-map "H>+"                'bmkx-bmenu-set-lighting-for-marked)
  (define-key bmkx-list-mode-map "H>H"                'bmkx-bmenu-light-marked)
  (define-key bmkx-list-mode-map "HH"                 'bmkx-bmenu-light)
  (define-key bmkx-list-mode-map "HM"                 'bmkx-bmenu-mark-lighted-bookmarks)
  (define-key bmkx-list-mode-map "HS"                 'bmkx-bmenu-show-only-lighted-bookmarks)
  (define-key bmkx-list-mode-map "H>U"                'bmkx-bmenu-unlight-marked)
  (define-key bmkx-list-mode-map "HU"                 'bmkx-bmenu-unlight))
(define-key bmkx-list-mode-map "IM"                   'bmkx-bmenu-mark-info-bookmarks)
(define-key bmkx-list-mode-map "IS"                   'bmkx-bmenu-show-only-info-bookmarks)
(define-key bmkx-list-mode-map (kbd "M-I M-M")             'bmkx-bmenu-mark-image-bookmarks)
(define-key bmkx-list-mode-map (kbd "M-I M-S")             'bmkx-bmenu-show-only-image-bookmarks)

;; Prefix `j' and `J' bindings are made in `bookmark-x-key.el', by binding `bmkx-jump(-other-window)-map'.

(define-key bmkx-list-mode-map "k"                    'bmkx-bmenu-flag-for-deletion)
(define-key bmkx-list-mode-map "KM"                   'bmkx-bmenu-mark-desktop-bookmarks)
(define-key bmkx-list-mode-map "KS"                   'bmkx-bmenu-show-only-desktop-bookmarks)
(define-key bmkx-list-mode-map "l"                    'bmkx-load)
(define-key bmkx-list-mode-map "L"                    'bmkx-switch-bookmark-file-create)
(define-key bmkx-list-mode-map [(control shift ?l)]   'bookmark-bmenu-locate) ; `C-L' (aka `C-S-l')
(define-key bmkx-list-mode-map (kbd "M-l")                 'bmkx-bmenu-load-marked-bookmark-file-bookmarks)
(define-key bmkx-list-mode-map (kbd "M-L")                 'bmkx-temporary-bookmarking-mode)
(define-key bmkx-list-mode-map "MM"                   'bmkx-bmenu-mark-man-bookmarks)
(define-key bmkx-list-mode-map "MS"                   'bmkx-bmenu-show-only-man-bookmarks)
(define-key bmkx-list-mode-map (kbd "M-m")                 'bmkx-bmenu-mark-all)
(define-key bmkx-list-mode-map "NM"                   'bmkx-bmenu-mark-non-invokable-bookmarks)
(define-key bmkx-list-mode-map "NS"                   'bmkx-bmenu-show-only-non-invokable-bookmarks)
(define-key bmkx-list-mode-map "OM"                 'bmkx-bmenu-mark-orphaned-local-file-bookmarks)
(define-key bmkx-list-mode-map "OS"                'bmkx-bmenu-show-only-orphaned-local-file-bookmarks)
(define-key bmkx-list-mode-map "PA"                  'bmkx-bmenu-filter-annotation-incrementally)
(define-key bmkx-list-mode-map "PB"                 'bmkx-bmenu-filter-bookmark-name-incrementally)
(define-key bmkx-list-mode-map "PF"                   'bmkx-bmenu-filter-file-name-incrementally)
(define-key bmkx-list-mode-map "PT"                   'bmkx-bmenu-filter-tags-incrementally)
(define-key bmkx-list-mode-map "q"                    'bmkx-bmenu-quit)
(define-key bmkx-list-mode-map (kbd "M-q")                'bmkx-bmenu-query-replace-marked-bookmarks-regexp)
(define-key bmkx-list-mode-map "QM"                   'bmkx-bmenu-mark-function-bookmarks)
(define-key bmkx-list-mode-map "QS"                   'bmkx-bmenu-show-only-function-bookmarks)
(define-key bmkx-list-mode-map "r"                    'bmkx-bmenu-edit-bookmark-name-and-location)
(define-key bmkx-list-mode-map "RM"                   'bmkx-bmenu-mark-region-bookmarks)
(define-key bmkx-list-mode-map "RS"                   'bmkx-bmenu-show-only-region-bookmarks)
(define-key bmkx-list-mode-map (kbd "M-r")                 'bookmark-bmenu-relocate) ; `R' in Emacs
(define-key bmkx-list-mode-map (kbd "M-R")                 'bmkx-bmenu-relocate-marked)
(define-key bmkx-list-mode-map "S"                    'bmkx-save) ; `s' in Emacs
(define-key bmkx-list-mode-map "s>"                   'bmkx-bmenu-sort-marked-before-unmarked)
(define-key bmkx-list-mode-map "s*"                   'bmkx-bmenu-sort-modified-before-unmodified)
(define-key bmkx-list-mode-map "s0"                   'bmkx-bmenu-sort-by-creation-time)
(define-key bmkx-list-mode-map "sa"                   'bmkx-bmenu-sort-annotated-before-unannotated)
(define-key bmkx-list-mode-map "sb"                   'bmkx-bmenu-sort-by-last-buffer-or-file-access)
(define-key bmkx-list-mode-map "sd"                   'bmkx-bmenu-sort-by-last-bookmark-access)
(define-key bmkx-list-mode-map "sD"                   'bmkx-bmenu-sort-flagged-before-unflagged)
(define-key bmkx-list-mode-map "sfd"                  'bmkx-bmenu-sort-by-last-local-file-access)
(define-key bmkx-list-mode-map "sfk"                  'bmkx-bmenu-sort-by-local-file-type)
(define-key bmkx-list-mode-map "sfn"                  'bmkx-bmenu-sort-by-file-name)
(define-key bmkx-list-mode-map "sfs"                  'bmkx-bmenu-sort-by-local-file-size)
(define-key bmkx-list-mode-map "sfu"                  'bmkx-bmenu-sort-by-last-local-file-update)
(define-key bmkx-list-mode-map "sg"                   'bmkx-bmenu-sort-by-Gnus-thread)
(define-key bmkx-list-mode-map "si"                   'bmkx-bmenu-sort-by-Info-node-name)
(define-key bmkx-list-mode-map "sI"                   'bmkx-bmenu-sort-by-Info-position)
(define-key bmkx-list-mode-map "sk"                   'bmkx-bmenu-sort-by-bookmark-type)
(define-key bmkx-list-mode-map "sn"                   'bmkx-bmenu-sort-by-bookmark-name)
(define-key bmkx-list-mode-map "sr"                   'bmkx-reverse-sort-order)
(define-key bmkx-list-mode-map "s\C-r"                'bmkx-reverse-multi-sort-order)
(define-key bmkx-list-mode-map "ss"                   'bmkx-bmenu-change-sort-order-repeat)
(define-key bmkx-list-mode-map "st"                   'bmkx-bmenu-sort-tagged-before-untagged)
(define-key bmkx-list-mode-map "su"                   'bmkx-bmenu-sort-by-url)
(define-key bmkx-list-mode-map "sv"                   'bmkx-bmenu-sort-by-bookmark-visit-frequency)

;; Not done yet.
;; ;; (define-key bmkx-list-mode-map "sw"                    nil) ; For Emacs20
;; ;; (define-key bmkx-list-mode-map "swe"                   'bmkx-bmenu-sort-by-eww-url)
;; ;; (define-key bmkx-list-mode-map "sw3"                   'bmkx-bmenu-sort-by-w3m-url)

(define-key bmkx-list-mode-map (kbd "M-s a C-s")      'bmkx-bmenu-isearch-marked-bookmarks)
(define-key bmkx-list-mode-map (kbd "M-s a M-C-s")    'bmkx-bmenu-isearch-marked-bookmarks-regexp)
(define-key bmkx-list-mode-map (kbd "M-s a M-s")      'bmkx-bmenu-search-marked-bookmarks-regexp)
(define-key bmkx-list-mode-map "T"                    nil) ; For Emacs20
(define-key bmkx-list-mode-map "T>+"                  'bmkx-bmenu-add-tags-to-marked)
(define-key bmkx-list-mode-map "T>-"                  'bmkx-bmenu-remove-tags-from-marked)
(define-key bmkx-list-mode-map "T>e"                  'bmkx-bmenu-edit-marked)
(define-key bmkx-list-mode-map "T>l"                  'bmkx-bmenu-list-tags-of-marked)
(define-key bmkx-list-mode-map "T>p"                  'bmkx-bmenu-paste-add-tags-to-marked)
(define-key bmkx-list-mode-map "T>q"                  'bmkx-bmenu-paste-replace-tags-for-marked)
(define-key bmkx-list-mode-map "T>v"                  'bmkx-bmenu-set-tag-value-for-marked)
(define-key bmkx-list-mode-map "T>\C-y"               'bmkx-bmenu-paste-add-tags-to-marked)
(define-key bmkx-list-mode-map "T0"                   'bmkx-bmenu-remove-all-tags)
(define-key bmkx-list-mode-map "T+"                   'bmkx-bmenu-add-tags)
(define-key bmkx-list-mode-map "T-"                   'bmkx-bmenu-remove-tags)
(define-key bmkx-list-mode-map "Tc"                   'bmkx-bmenu-copy-tags)
(define-key bmkx-list-mode-map "Td"                   'bmkx-remove-tags-from-all)
(define-key bmkx-list-mode-map "Te"                   'bmkx-bmenu-edit-tags)
(define-key bmkx-list-mode-map "Tl"                   'bmkx-list-all-tags)
(define-key bmkx-list-mode-map "Tm*"                  'bmkx-bmenu-mark-bookmarks-tagged-all)
(define-key bmkx-list-mode-map "Tm%"                  'bmkx-bmenu-mark-bookmarks-tagged-regexp)
(define-key bmkx-list-mode-map "Tm+"                  'bmkx-bmenu-mark-bookmarks-tagged-some)
(define-key bmkx-list-mode-map "Tm~*"                 'bmkx-bmenu-mark-bookmarks-tagged-not-all)
(define-key bmkx-list-mode-map "Tm~+"                 'bmkx-bmenu-mark-bookmarks-tagged-none)
(define-key bmkx-list-mode-map "Tp"                   'bmkx-bmenu-paste-add-tags)
(define-key bmkx-list-mode-map "Tq"                   'bmkx-bmenu-paste-replace-tags)
(define-key bmkx-list-mode-map "Tr"                   'bmkx-rename-tag)
(define-key bmkx-list-mode-map "Ts"                   'bmkx-define-tags-sort-command)
(define-key bmkx-list-mode-map "TS"                   'bmkx-bmenu-show-only-tagged-bookmarks)
(define-key bmkx-list-mode-map "TU"                   'bmkx-bmenu-show-only-untagged-bookmarks)
(define-key bmkx-list-mode-map "Tu*"                  'bmkx-bmenu-unmark-bookmarks-tagged-all)
(define-key bmkx-list-mode-map "Tu%"                  'bmkx-bmenu-unmark-bookmarks-tagged-regexp)
(define-key bmkx-list-mode-map "Tu+"                  'bmkx-bmenu-unmark-bookmarks-tagged-some)
(define-key bmkx-list-mode-map "Tu~*"                 'bmkx-bmenu-unmark-bookmarks-tagged-not-all)
(define-key bmkx-list-mode-map "Tu~+"                 'bmkx-bmenu-unmark-bookmarks-tagged-none)
(define-key bmkx-list-mode-map "Tv"                   'bmkx-bmenu-set-tag-value)
(define-key bmkx-list-mode-map "T\M-w"                'bmkx-bmenu-copy-tags)
(define-key bmkx-list-mode-map "T\C-y"                'bmkx-bmenu-paste-add-tags)
(define-key bmkx-list-mode-map (kbd "M-t")                 'bmkx-list-toggle-filenames) ; `t' in Emacs
(define-key bmkx-list-mode-map "t"                    'bmkx-bmenu-toggle-marks)
(define-key bmkx-list-mode-map "U"                    'bmkx-bmenu-unmark-all)
(define-key bmkx-list-mode-map (kbd "M-u M-m")             'bmkx-bmenu-mark-url-bookmarks)
(define-key bmkx-list-mode-map (kbd "M-u M-s")             'bmkx-bmenu-show-only-url-bookmarks)
(define-key bmkx-list-mode-map "v"                    'bmkx-bmenu-w32-jump-to-marked)
(define-key bmkx-list-mode-map "V"                    nil) ; For Emacs20
(define-key bmkx-list-mode-map "VM"                   'bmkx-bmenu-mark-variable-list-bookmarks)
(define-key bmkx-list-mode-map "VS"                   'bmkx-bmenu-show-only-variable-list-bookmarks)
(define-key bmkx-list-mode-map (kbd "M-o")                 'bmkx-bmenu-w32-jump-to-marked)
(define-key bmkx-list-mode-map "W3M"                  'bmkx-bmenu-mark-w3m-bookmarks)
(define-key bmkx-list-mode-map "W3S"                  'bmkx-bmenu-show-only-w3m-bookmarks)

(when (fboundp 'bmkx-bmenu-mark-eww-bookmarks) ; Emacs 25+
  (define-key bmkx-list-mode-map "WEM"                'bmkx-bmenu-mark-eww-bookmarks)
  (define-key bmkx-list-mode-map "WES"                'bmkx-bmenu-show-only-eww-bookmarks)
  )
(define-key bmkx-list-mode-map "wM"                   'bmkx-bmenu-mark-snippet-bookmarks)
(define-key bmkx-list-mode-map "wS"                   'bmkx-bmenu-show-only-snippet-bookmarks)
(define-key bmkx-list-mode-map "XM"                   'bmkx-bmenu-mark-temporary-bookmarks)
(define-key bmkx-list-mode-map "XS"                   'bmkx-bmenu-show-only-temporary-bookmarks)
(define-key bmkx-list-mode-map (kbd "M-X")                 'bmkx-bmenu-toggle-marked-temporary/savable)
(define-key bmkx-list-mode-map (kbd "C-M-X")              'bmkx-bmenu-toggle-temporary)
(define-key bmkx-list-mode-map "YM"                   'bmkx-bmenu-mark-bookmark-file-bookmarks)
(define-key bmkx-list-mode-map "YS"                   'bmkx-bmenu-show-only-bookmark-file-bookmarks)
(define-key bmkx-list-mode-map "Y>+"                  'bmkx-bmenu-copy-marked-to-bookmark-file)
(define-key bmkx-list-mode-map "Y>-"                  'bmkx-bmenu-move-marked-to-bookmark-file)
(define-key bmkx-list-mode-map "Y>0"                  'bmkx-bmenu-create-bookmark-file-from-marked)
(define-key bmkx-list-mode-map "ZM"                   'bmkx-bmenu-mark-bookmark-list-bookmarks)
(define-key bmkx-list-mode-map "ZS"                   'bmkx-bmenu-show-only-bookmark-list-bookmarks)


;;; `Bookmark-X' menu-bar menu in `*Bmkx List*'

(defvar bmkx-bmenu-menubar-menu (make-sparse-keymap "Bookmark-X") "`Bookmark-X' menu-bar menu.")
(define-key bmkx-list-mode-map [menu-bar bmkx]
  (cons "Bookmark-X" bmkx-bmenu-menubar-menu))

;; Top level
(define-key bmkx-bmenu-menubar-menu [bmkx-bmenu-quit]
  '(menu-item "Quit" bmkx-bmenu-quit
    :help "Quit the bookmark list, saving its state and the current set of bookmarks"))
(define-key bmkx-bmenu-menubar-menu [bmkx-send-bug-report]
  '(menu-item "Send Bug Report" bmkx-send-bug-report
    :help "Send an email reporting a Bookmark-X bug"))
(define-key bmkx-bmenu-menubar-menu [top-sep8] '("--")) ; ------------
(define-key bmkx-bmenu-menubar-menu [bmkx-list-defuns-in-commands-file]
  '(menu-item "List User-Defined Bookmark Commands" bmkx-list-defuns-in-commands-file
    :help "List the functions defined in `bmkx-bmenu-commands-file'"))
(define-key bmkx-bmenu-menubar-menu [bmkx-bmenu-describe-marked]
  '(menu-item "Describe Marked Bookmarks" bmkx-bmenu-describe-marked
    :help "Describe the marked bookmarks.  With `C-u' show internal format."))
(define-key bmkx-bmenu-menubar-menu [bmkx-bmenu-describe-this-bookmark]
  '(menu-item "Describe This Bookmark" bmkx-bmenu-describe-this-bookmark
    :help "Describe this line's bookmark.  With `C-u' show internal format."))
(define-key bmkx-bmenu-menubar-menu [bmkx-bmenu-mode-status-help]
  '(menu-item "Current Status, Mode Help" bmkx-bmenu-mode-status-help :keys "?"
    :help "Describe `*Bmkx List*' and show its current status"))

(define-key bmkx-bmenu-menubar-menu [top-sep7] '("--")) ; ------------
(define-key bmkx-bmenu-menubar-menu [bmkx-revert-bookmark-file]
  '(menu-item "Revert to Saved..." bmkx-revert-bookmark-file
    :help "Revert to bookmarks in current bookmark file, as last saved" :keys "C-u g"))
(define-key bmkx-bmenu-menubar-menu [bmkx-bmenu-refresh-menu-list]
  '(menu-item "Refresh to Current" bmkx-bmenu-refresh-menu-list
    :help "Update display to reflect current bookmark list (`C-u': revert from file)"))

(define-key bmkx-bmenu-menubar-menu [top-sep6] '("--")) ; ------------
(define-key bmkx-bmenu-menubar-menu [bmkx-save-menu-list-state]
  '(menu-item "Save Display State..." bmkx-save-menu-list-state
    :help "Save the current bookmark-list display state to `bmkx-bmenu-state-file'"
    :enable (and (not bmkx-bmenu-first-time-p)  bmkx-bmenu-state-file)))
(define-key bmkx-bmenu-menubar-menu [bookmark-write]
  '(menu-item "Save As..." bookmark-write
    :help "Write the current set of bookmarks to a file whose name you enter"))
(define-key bmkx-bmenu-menubar-menu [bookmark-bmenu-save]
  '(menu-item "Save" bookmark-bmenu-save
    :help "Save the current set of bookmarks to the current bookmark file"
    :enable (> bookmark-alist-modification-count 0)))

(define-key bmkx-bmenu-menubar-menu [top-sep5] '("--")) ; ----------
(define-key bmkx-bmenu-menubar-menu [bmkx-bmenu-relocate-marked]
  '(menu-item "Relocate Marked..." bmkx-bmenu-relocate-marked
    :help "Relocate the marked bookmarks to a directory"))

(define-key bmkx-bmenu-menubar-menu [top-sep4] '("--")) ; ----------
(define-key bmkx-bmenu-menubar-menu [bmkx-make-function-bookmark]
  '(menu-item "New Function Bookmark..." bmkx-make-function-bookmark
    :help "Create a bookmark that will invoke FUNCTION when \"jumped\" to"))
(define-key bmkx-bmenu-menubar-menu [bmkx-bmenu-make-sequence-from-marked]
  '(menu-item "New Sequence Bookmark from Marked..." bmkx-bmenu-make-sequence-from-marked
    :help "Create or update a sequence bookmark from the visible marked bookmarks"))
(define-key bmkx-bmenu-menubar-menu [bmkx-bmenu-clone-bookmark]
  '(menu-item "Clone (Duplicate) This Bookmark" bmkx-bmenu-clone-bookmark
    :help "Clone this bookmark.  (`\\[bmkx-bmenu-edit-bookmark-record]' to edit.)"))

(define-key bmkx-bmenu-menubar-menu [top-sep3] '("--")) ; ----------
(define-key bmkx-bmenu-menubar-menu [bmkx-choose-navlist-from-bookmark-list]
  '(menu-item "Set Navlist from Bookmark-List Bookmark..." bmkx-choose-navlist-from-bookmark-list
    :help "Set the navigation list from a bookmark-list bookmark"))
(define-key bmkx-bmenu-menubar-menu [bmkx-choose-navlist-of-type]
  '(menu-item "Set Navlist to Bookmarks of Type..." bmkx-choose-navlist-of-type
    :help "Set the navigation list to the bookmarks of a certain type"))

(define-key bmkx-bmenu-menubar-menu [top-sep2] '("--")) ; ----------

(defvar bmkx-bmenu-define-command-menu (make-sparse-keymap "Define Command")
    "`Define Command' submenu for menu-bar `Bookmark-X' menu.")
(define-key bmkx-bmenu-menubar-menu [define-command]
  (cons "Define Command" bmkx-bmenu-define-command-menu))

(defvar bmkx-bmenu-bookmark-file-menu (make-sparse-keymap "Bookmark File")
    "`Bookmark File' submenu for menu-bar `Bookmark-X' menu.")
(define-key bmkx-bmenu-menubar-menu [bookmark-file] (cons "Bookmark File" bmkx-bmenu-bookmark-file-menu))

(when (or (featurep 'bookmark-x-lit)
          (and (fboundp 'diredp-highlight-autofiles-mode)  (featurep 'highlight)))
  (defvar bmkx-bmenu-highlight-menu (make-sparse-keymap "Highlight")
    "`Highlight' submenu for menu-bar `Bookmark-X' menu.")
  (define-key bmkx-bmenu-menubar-menu [highlight] (cons "Highlight" bmkx-bmenu-highlight-menu)))

(defvar bmkx-bmenu-tags-menu (make-sparse-keymap "Tags")
    "`Tags' submenu for menu-bar `Bookmark-X' menu.")
(define-key bmkx-bmenu-menubar-menu [tags] (cons "Tags" bmkx-bmenu-tags-menu))

(defvar bmkx-bmenu-search-menu (make-sparse-keymap "Search")
    "`Search' submenu for menu-bar `Bookmark-X' menu.")
(define-key bmkx-bmenu-menubar-menu [search] (cons "Search" bmkx-bmenu-search-menu))

(defvar bmkx-bmenu-sort-menu (make-sparse-keymap "Sort")
    "`Sort' submenu for menu-bar `Bookmark-X' menu.")
(define-key bmkx-bmenu-menubar-menu [sort] (cons "Sort" bmkx-bmenu-sort-menu))

(defvar bmkx-bmenu-edit-menu (make-sparse-keymap "Edit")
    "`Edit' submenu for menu-bar `Bookmark-X' menu.")
(define-key bmkx-bmenu-menubar-menu [edit] (cons "Edit" bmkx-bmenu-edit-menu))

(defvar bmkx-bmenu-show-menu (make-sparse-keymap "Show")
    "`Show' submenu for menu-bar `Bookmark-X' menu.")
(define-key bmkx-bmenu-menubar-menu [show] (cons "Show" bmkx-bmenu-show-menu))

(defvar bmkx-bmenu-omit-menu (make-sparse-keymap "Omit")
  "`Omit' submenu for menu-bar `Bookmark-X' menu.")
(define-key bmkx-bmenu-menubar-menu [omitting] (cons "Omit" bmkx-bmenu-omit-menu))

(defvar bmkx-bmenu-mark-menu (make-sparse-keymap "Mark")
    "`Mark' submenu for menu-bar `Bookmark-X' menu.")
(define-key bmkx-bmenu-menubar-menu [marking] (cons "Mark" bmkx-bmenu-mark-menu))

(defvar bmkx-bmenu-delete-menu (make-sparse-keymap "Delete")
    "`Delete' submenu for menu-bar `Bookmark-X' menu.")
(define-key bmkx-bmenu-menubar-menu [delete] (cons "Delete" bmkx-bmenu-delete-menu))

(defvar bmkx-bmenu-toggle-menu (make-sparse-keymap "Toggle")
    "`Toggle' submenu for menu-bar menus `Bookmark-X' and `Bookmarks'.")
(define-key bmkx-bmenu-menubar-menu [toggle] (cons "Toggle" bmkx-bmenu-toggle-menu))


;;; `Define Command' submenu -----------------------------------------
(define-key bmkx-bmenu-define-command-menu [bmkx-bmenu-define-full-snapshot-command]
  '(menu-item "To Restore Full Bookmark-List State..." bmkx-bmenu-define-full-snapshot-command
    :help "Define a command to restore the current bookmark-list state"))
(define-key bmkx-bmenu-define-command-menu [bmkx-bmenu-define-command]
  '(menu-item "To Restore Current Order and Filter..." bmkx-bmenu-define-command
    :help "Define a command to use the current sort order, filter, and omit list"))
(define-key bmkx-bmenu-define-command-menu [bmkx-define-tags-sort-command]
  '(menu-item "To Sort by Specific Tags..." bmkx-define-tags-sort-command
    :help "Define a command to sort bookmarks in the bookmark list by certain tags"))
(define-key bmkx-bmenu-define-command-menu [bmkx-bmenu-define-jump-marked-command]
  '(menu-item "To Jump to a Bookmark Now Marked..." bmkx-bmenu-define-jump-marked-command
    :help "Define a command to jump to one of the bookmarks that is now marked"
    :enable bmkx-bmenu-marked-bookmarks))


;;; `Bookmark File' submenu ------------------------------------------
(define-key bmkx-bmenu-bookmark-file-menu [bmkx-bmenu-set-bookmark-file-bookmark-from-marked]
  '(menu-item "Set Bookmark-File Bookmark from Marked..."
    bmkx-bmenu-set-bookmark-file-bookmark-from-marked
    :help "Create a bookmark file and a bookmark for it, from the marked bookmarks"
    :keys "C-u Y > 0"))
(define-key bmkx-bmenu-bookmark-file-menu [bmkx-bmenu-create-bookmark-file-from-marked]
  '(menu-item "Copy Marked to New Bookmark File..." bmkx-bmenu-create-bookmark-file-from-marked
    :help "Create a bookmark file by copying the marked bookmarks (or current bookmark)"))
(define-key bmkx-bmenu-bookmark-file-menu [bmkx-bmenu-copy-marked-to-bookmark-file]
  '(menu-item "Copy Marked to Bookmark File..." bmkx-bmenu-copy-marked-to-bookmark-file
    :help "Copy the marked bookmarks (or current bookmark) to a bookmark file"))
(define-key bmkx-bmenu-bookmark-file-menu [bmkx-bmenu-move-marked-to-bookmark-file]
  '(menu-item "Move Marked to Bookmark File..." bmkx-bmenu-move-marked-to-bookmark-file
    :help "Move the marked bookmarks (or current bookmark) to a different bookmark file"))

(define-key bmkx-bmenu-bookmark-file-menu [sep] '("--")) ; ------------
(define-key bmkx-bmenu-bookmark-file-menu [bmkx-bmenu-load-marked-bookmark-file-bookmarks]
  '(menu-item "Load Marked Bookmark-File Bookmarks..." bmkx-bmenu-load-marked-bookmark-file-bookmarks
    :help "Load the marked bookmark-file bookmarks, in order"))
(define-key bmkx-bmenu-bookmark-file-menu [bmkx-bmenu-load-marking-unmark-first]
  '(menu-item "Load Bookmarks, Mark Only Those Loaded...." bmkx-bmenu-load-marking-unmark-first
    :help "`bmkx-load', marking those loaded, unmarking others"))
(define-key bmkx-bmenu-bookmark-file-menu [bmkx-bmenu-load-marking]
  '(menu-item "Load Bookmarks, Mark Those Loaded...." bmkx-bmenu-load-marking
    :help "`bmkx-load', marking bookmarks that are loaded"))
(define-key bmkx-bmenu-bookmark-file-menu [bf-sep2] '("--")) ; ------------
;;; (define-key bmkx-bmenu-bookmark-file-menu [bmkx-save-bookmarks-this-file/buffer]
;;;   '(menu-item "Save Bookmarks Here to File (No Switch)..." bmkx-save-bookmarks-this-file/buffer
;;;     :help "Save bookmarks defined for the current file or buffer to file"))
;;; (define-key bmkx-bmenu-bookmark-file-menu [bmkx-switch-to-bookmark-file-this-file/buffer]
;;;   '(menu-item "Switch to Bookmarks Here..." bmkx-switch-to-bookmark-file-this-file/buffer
;;;     :help "Switch to a bookmark file with only bookmarks for this file or buffer"))
(define-key bmkx-bmenu-bookmark-file-menu [bmkx-switch-to-last-bookmark-file]
  '(menu-item "Switch to Last Bookmark File" bmkx-switch-to-last-bookmark-file
    :help "Switch back to last set of bookmarks used, *replacing* current set" :keys "C-u L"))
(define-key bmkx-bmenu-bookmark-file-menu [bmkx-switch-bookmark-file-create]
  '(menu-item "Switch to Bookmarks..." bmkx-switch-bookmark-file-create
    :help "Switch to another bookmark file, *replacing* the current set of bookmarks"))
(define-key bmkx-bmenu-bookmark-file-menu [bookmark-bmenu-load]
  '(menu-item "Load (Add) Bookmarks..." bookmark-bmenu-load
    :help "Load additional bookmarks from a bookmark file"))
(define-key bmkx-bmenu-bookmark-file-menu [bf-sep1] '("--")) ; ------------
(define-key bmkx-bmenu-bookmark-file-menu [bmkx-empty-file]
  '(menu-item "Empty Bookmark File..." bmkx-empty-file
    :help "Empty an existing bookmark file or create a new, empty bookmark file"))
(define-key bmkx-bmenu-bookmark-file-menu [bmkx-revert-bookmark-file]
  '(menu-item "Revert to Saved Bookmarks..." bmkx-revert-bookmark-file
    :help "Revert to bookmarks in current bookmark file, as last saved" :keys "C-u g"))


;;; `Toggle' submenu -------------------------------------------------

(define-key bmkx-bmenu-toggle-menu [diredp-highlight-autofiles-mode]
  (bmkx-menu-bar-make-toggle diredp-highlight-autofiles-mode
                             diredp-highlight-autofiles-mode
                             "Autofile Highlighting in Dired"
                             "Whether to highlight autofile bookmarks in Dired us biw %s"
                             "Toggle the value of option `diredp-highlight-autofiles-mode'"
                             nil
                             :visible (and (fboundp 'diredp-highlight-autofiles-mode)
                                           (featurep 'highlight))))
(define-key bmkx-bmenu-toggle-menu [bmkx-toggle-guess-default-file-handler]
  (bmkx-menu-bar-make-toggle bmkx-toggle-guess-default-file-handler
                             bmkx-guess-default-handler-for-file-flag
                             "Guessing Default File Handler"
                             "Guessing the default handler when creating a file bookmark is now %s"
                             "Toggle the value of option `bmkx-guess-default-handler-for-file-flag'"))
(define-key bmkx-bmenu-toggle-menu [bmkx-toggle-auto-light-when-jump-menu]
  (bmkx-menu-bar-make-toggle bmkx-toggle-auto-light-when-jump-menu bmkx-auto-light-when-jump
                             "Automatic Highlighting When Jumping"
                             "Bookmark highlighting when you jump to a bookmark is now %s"
                             "Toggle the value of option `bmkx-auto-light-when-jump'"
                             (bmkx-toggle-auto-light-when-jump)
                             :visible (featurep 'bookmark-x-lit)))
(define-key bmkx-bmenu-toggle-menu [bmkx-toggle-auto-light-when-set-menu]
  (bmkx-menu-bar-make-toggle bmkx-toggle-auto-light-when-set-menu bmkx-auto-light-when-set
                             "Automatic Highlighting When Setting"
                             "Bookmark highlighting when you set a bookmark is now %s"
                             "Toggle the value of option `bmkx-auto-light-when-set'"
                             (bmkx-toggle-auto-light-when-set)
                             :visible (featurep 'bookmark-x-lit)))
(define-key bmkx-bmenu-toggle-menu [bmkx-toggle-prompt-for-tags]
  (bmkx-menu-bar-make-toggle bmkx-toggle-prompt-for-tags bmkx-prompt-for-tags-flag
                             "Prompting for Tags When Setting"
                             "Prompting for tags when you set a bookmark is now %s"
                             "Toggle the value of option `bmkx-prompt-for-tags-flag'"))
(define-key bmkx-bmenu-toggle-menu [sep4] '("--")) ; ------------ Jumping-behavior stuff
(when (boundp 'bmkx-eww-allow-multiple-buffers-flag) ; Emacs 25+
  (define-key bmkx-bmenu-toggle-menu [bmkx-toggle-eww-allow-multiple-buffers]
    (bmkx-menu-bar-make-toggle bmkx-toggle-eww-allow-multiple-buffers bmkx-eww-allow-multiple-buffers-flag
                               "Using Multiple Buffers for EWW"
                               "Using a new buffer when jumping to an EWW bookmark is now %s"
                               "Toggle the value of option `bmkx-eww-allow-multiple-buffers-flag'"))
  )
(define-key bmkx-bmenu-toggle-menu [bmkx-toggle-showing-region-end]
  (bmkx-menu-bar-make-toggle bmkx-toggle-showing-region-end bmkx-show-end-of-region-flag
                             "Showing Region End"
                             "Showing the end of the region when activating is now %s"
                             "Toggle the value of option `bmkx-show-end-of-region-flag'"))
(define-key bmkx-bmenu-toggle-menu [bmkx-toggle-pop-to]
  (bmkx-menu-bar-make-toggle bmkx-toggle-pop-to bmkx-other-window-pop-to-flag
                             "Using `pop-to-buffer'"
                             "Using `pop-to-buffer' instead of `switch-to-buffer-other-window' is now %s"
                             "Toggle the value of option `bmkx-other-window-pop-to-flag'"))
(define-key bmkx-bmenu-toggle-menu [bmkx-toggle-auto-light-when-jump-menu]
  (bmkx-menu-bar-make-toggle bmkx-toggle-auto-light-when-jump-menu bmkx-auto-light-when-jump
                             "Automatic Highlighting When Jumping"
                             "Bookmark highlighting when you jump to a bookmark is now %s"
                             "Toggle the value of option `bmkx-auto-light-when-jump'"
                             (progn (bmkx-toggle-auto-light-when-jump) bmkx-auto-light-when-jump)
                             :visible (featurep 'bookmark-x-lit)))
(define-key bmkx-bmenu-toggle-menu [bmkx-toggle-highlight-on-jump]
  (bmkx-menu-bar-make-toggle bmkx-toggle-highlight-on-jump bmkx-highlight-on-jump-flag
                             "Highlight Landing on Jump"
                             "Highlighting the landing line after a jump is now %s"
                             "Toggle the value of option `bmkx-highlight-on-jump-flag'"))

(define-key bmkx-bmenu-toggle-menu [sep3] '("--")) ; ------------ Temporary bookmark stuff
(define-key bmkx-bmenu-toggle-menu [bmkx-bmenu-toggle-marked-temporary/savable]
  '(menu-item "Temporary/Savable (`X') for Marked" bmkx-bmenu-toggle-marked-temporary/savable
    :help "Toggle the temporary (`X') vs. savable status of the marked bookmarks"))
(define-key bmkx-bmenu-toggle-menu [bmkx-temporary-bookmarking-mode]
  (bmkx-menu-bar-make-toggle bmkx-temporary-bookmarking-mode bmkx-temporary-bookmarking-mode
                             "Temporary Bookmarking"
                             "Temporary bookmarking mode is now %s"
                             "Toggle automatically saving bookmark changes"))
(define-key bmkx-bmenu-toggle-menu [bmkx-toggle-autotemp-on-set]
  (bmkx-menu-bar-make-toggle bmkx-toggle-autotemp-on-set bmkx-autotemp-all-when-set-p
                             "Making Bookmarks Temporary When Set"
                             "Automatically making bookmarks temporary when you set them is now %s"
                             "Toggle automatically making a bookmark temporary when you set it"))

(define-key bmkx-bmenu-toggle-menu [sep2] '("--")) ; ------------ List display stuff
(define-key bmkx-bmenu-toggle-menu [bmkx-toggle-bookmark-set-refreshes]
  '(menu-item "Autorefresh for `bmkx-latest-bookmark-alist'" bmkx-toggle-bookmark-set-refreshes
    :help "Toggle whether `bmkx-set' refreshes `bmkx-latest-bookmark-alist'"))
(define-key bmkx-bmenu-toggle-menu [bmkx-toggle-count-multi-mods-as-one]
  (bmkx-menu-bar-make-toggle bmkx-toggle-count-multi-mods-as-one bmkx-count-multi-mods-as-one-flag
                             "Counting Multiple Modifications As One"
                             "Counting multiple modifications as one is now %s"
                             "Toggle the value of option `bmkx-count-multi-mods-as-one-flag'"))
(define-key bmkx-bmenu-toggle-menu [bmkx-bmenu-toggle-marks]
  '(menu-item "Marked/Unmarked" bmkx-bmenu-toggle-marks
    :help "Unmark all marked bookmarks; mark all unmarked bookmarks"))
(define-key bmkx-bmenu-toggle-menu [bmkx-reverse-sort-order]
  '(menu-item "Sort Direction" bmkx-reverse-sort-order
    :help "Toggle the current bookmark sort direction"
    :enable (bmkx-current-sort-order)))
(define-key bmkx-bmenu-toggle-menu [bmkx-bmenu-toggle-show-only-unmarked]
  '(menu-item "Showing Only Unmarked" bmkx-bmenu-toggle-show-only-unmarked
    :help "Alternately show unmarked or all bookmarks"))
(define-key bmkx-bmenu-toggle-menu [bmkx-bmenu-toggle-show-only-marked]
  '(menu-item "Showing Only Marked" bmkx-bmenu-toggle-show-only-marked
    :help "Alternately show unmarked or all bookmarks"))
(define-key bmkx-bmenu-toggle-menu [bmkx-bmenu-toggle-filenames]
  (bmkx-menu-bar-make-toggle bmkx-bmenu-toggle-filenames bookmark-bmenu-toggle-filenames
                             "Showing File Names"
                             "Showing file names is now %s"
                             "Toggle the value of option `bookmark-bmenu-toggle-filenames'"
                             (progn
                               (custom-load-symbol 'bookmark-bmenu-toggle-filenames)
                               (let ((set  (or (get 'bookmark-bmenu-toggle-filenames 'custom-set)
                                               'set-default))
                                     (get  (or (get 'bookmark-bmenu-toggle-filenames 'custom-get)
                                               'default-value)))
                                 (funcall set 'bookmark-bmenu-toggle-filenames
                                          (not (funcall get 'bookmark-bmenu-toggle-filenames))))
                               (if bookmark-bmenu-toggle-filenames
                                   (bmkx-list-show-filenames)
                                 (bmkx-list-hide-filenames))
                               bookmark-bmenu-toggle-filenames)
                             :keys "M-t"))
(define-key bmkx-bmenu-toggle-menu [bmkx-toggle-saving-menu-list-state]
  (bmkx-menu-bar-make-toggle bmkx-toggle-saving-menu-list-state bmkx-bmenu-state-file
                             "Saving Display State"
                             "Ability to save bookmark list state, and autosaving, are now %s"
                             "Toggle the value of option `bmkx-bmenu-state-file'"))

(define-key bmkx-bmenu-toggle-menu [sep1] '("--")) ; ------------ Automatic stuff
(define-key bmkx-bmenu-toggle-menu [bmkx-automatic-bookmark-mode]
  '(menu-item "Automatically Creating Bookmarks" bmkx-automatic-bookmark-mode
    :help "Toggle the periodic automatic creation of bookmarks"))
(define-key bmkx-bmenu-toggle-menu [bmkx-toggle-save-desktop-before-switching]
  (bmkx-menu-bar-make-toggle bmkx-toggle-save-desktop-before-switching bmkx-desktop-jump-save-before-flag
                             "Autosaving the Desktop Before Switching"
                             "Autosaving the desktop before jumping to a desktop bookmark is now %s"
                             "Toggle the value of option `bmkx-desktop-jump-save-before-flag'"))
(define-key bmkx-bmenu-toggle-menu [bmkx-toggle-saving-relocated]
  (bmkx-menu-bar-make-toggle bmkx-toggle-saving-relocated bmkx-save-new-location-flag
                             "Autosaving Relocated Bookmarks"
                             "Automatically saving relocated bookmarks is now %s"
                             "Toggle the value of option `bmkx-save-new-location-flag'"))
(define-key bmkx-bmenu-toggle-menu [bmkx-toggle-saving-bookmark-file]
  (bmkx-menu-bar-make-toggle bmkx-toggle-saving-bookmark-file bookmark-save-flag
                             "Autosaving Bookmark File"
                             "Automatically saving the bookmark file (`bookmark-save-flag') is now %s"
                             "Toggle the value of option `bookmark-save-flag'"))


;;; `Highlight' submenu ----------------------------------------------
(when (boundp 'bmkx-bmenu-highlight-menu)
  (define-key bmkx-bmenu-highlight-menu [diredp-highlight-autofiles-mode]
    (bmkx-menu-bar-make-toggle diredp-highlight-autofiles-mode
                               diredp-highlight-autofiles-mode
                               "Toggle Autofile Highlighting in Dired"
                               "Whether to highlight autofile bookmarks in Dired us biw %s"
                               "Toggle `diredp-highlight-autofiles-mode'"
                               nil
                               :visible (and (fboundp 'diredp-highlight-autofiles-mode)
                                             (featurep 'highlight))))
  (when (featurep 'bookmark-x-lit)
    (define-key bmkx-bmenu-highlight-menu [bmkx-bmenu-show-only-lighted-bookmarks]
      '(menu-item "Show Only Highlighted" bmkx-bmenu-show-only-lighted-bookmarks
        :help "Display (only) highlighted bookmarks"))
    (define-key bmkx-bmenu-highlight-menu [bmkx-bmenu-set-lighting-for-marked]
      '(menu-item "Set Highlighting for Marked" bmkx-bmenu-set-lighting-for-marked
        :help "Set specific highlighting for the marked bookmarks"
        :enable bmkx-bmenu-marked-bookmarks))
    (define-key bmkx-bmenu-highlight-menu [bmkx-bmenu-unlight-marked]
      '(menu-item "Unhighlight Marked" bmkx-bmenu-unlight-marked
        :help "Unhighlight the marked bookmarks"
        :enable bmkx-bmenu-marked-bookmarks))
    (define-key bmkx-bmenu-highlight-menu [bmkx-bmenu-light-marked]
      '(menu-item "Highlight Marked" bmkx-bmenu-light-marked
        :help "Highlight the marked bookmarks"
        :enable bmkx-bmenu-marked-bookmarks))))


;;; `Tags' submenu ---------------------------------------------------
(define-key bmkx-bmenu-tags-menu [bmkx-list-all-tags]
  '(menu-item "List All Tags" bmkx-list-all-tags
    :help "List all tags used for any bookmarks (`C-u': show full, internal form)"))
(define-key bmkx-bmenu-tags-menu [bmkx-bmenu-list-tags-of-marked]
  '(menu-item "List Tags of Marked" bmkx-bmenu-list-tags-of-marked
    :help "List all tags used in the marked bookmarks (`C-u': show full, internal form)"))
(define-key bmkx-bmenu-tags-menu [bmkx-purge-notags-autofiles]
  '(menu-item "Purge Autofiles with No Tags..." bmkx-purge-notags-autofiles
    :help "Delete all autofile bookmarks that have no tags"))
(define-key bmkx-bmenu-tags-menu [bmkx-untag-a-file]
  '(menu-item "Untag a File (Remove Some)..." bmkx-untag-a-file
    :help "Remove some tags from autofile bookmark for a file"))
(define-key bmkx-bmenu-tags-menu [bmkx-tag-a-file]
  '(menu-item "Tag a File (Add Some)..." bmkx-tag-a-file
    :help "Add some tags to the autofile bookmark for a file"))

(define-key bmkx-bmenu-tags-menu [tags-sep] '("--")) ; ---------------
(define-key bmkx-bmenu-tags-menu [bmkx-rename-tag]
  '(menu-item "Rename Tag..." bmkx-rename-tag
    :help "Rename a tag in all bookmarks, even those not showing"))
(define-key bmkx-bmenu-tags-menu [bmkx-bmenu-edit-marked]
  '(menu-item "Edit Tags of Marked (Lisp)" bmkx-bmenu-edit-marked
    :help "Edit internal records of marked bookmarks (which include their tags)"
    :keys "T > e"))
(define-key bmkx-bmenu-tags-menu [bmkx-bmenu-set-tag-value-for-marked]
  '(menu-item "Set Tag Value for Marked..." bmkx-bmenu-set-tag-value-for-marked
    :help "Set the value of a tag, for each of the marked bookmarks"))
(define-key bmkx-bmenu-tags-menu [bmkx-remove-tags-from-all]
  '(menu-item "Remove Some Tags from All..." bmkx-remove-tags-from-all
    :help "Remove a set of tags from all bookmarks"))
(define-key bmkx-bmenu-tags-menu [bmkx-bmenu-remove-tags-from-marked]
  '(menu-item "Remove Some Tags from Marked..." bmkx-bmenu-remove-tags-from-marked
    :help "Remove a set of tags from each of the marked bookmarks"))
(define-key bmkx-bmenu-tags-menu [bmkx-bmenu-add-tags-to-marked]
  '(menu-item "Add Some Tags to Marked..." bmkx-bmenu-add-tags-to-marked
    :help "Add a set of tags to each of the marked bookmarks"))
(define-key bmkx-bmenu-tags-menu [bmkx-bmenu-paste-replace-tags-for-marked]
  '(menu-item "Paste Tags to Marked (Replace)..." bmkx-bmenu-paste-replace-tags-for-marked
    :help "Replace tags for the marked bookmarks with set of tags copied previously"))
(define-key bmkx-bmenu-tags-menu [bmkx-bmenu-paste-add-tags-to-marked]
  '(menu-item "Paste Tags to Marked (Add)..." bmkx-bmenu-paste-add-tags-to-marked
    :help "Add tags copied from another bookmark to the marked bookmarks"
    :enable bmkx-copied-tags))
(define-key bmkx-bmenu-tags-menu [bmkx-bmenu-copy-tags]
  '(menu-item "Copy Tags from This Bookmark" bmkx-bmenu-copy-tags
    :help "Copy tags from this bookmark, so you can paste them to other bookmarks"))


;;; `Search' submenu -------------------------------------------------
(define-key bmkx-bmenu-search-menu [bmkx-bmenu-query-replace-marked-bookmarks-regexp]
  '(menu-item "Query-Replace Marked..." bmkx-bmenu-query-replace-marked-bookmarks-regexp
    :help "`query-replace-regexp' over all files whose bookmarks are marked"))
(when (fboundp 'bmkx-bmenu-isearch-marked-bookmarks)
  (define-key bmkx-bmenu-search-menu [bmkx-bmenu-isearch-marked-bookmarks-regexp]
    '(menu-item "Regexp-Isearch Marked..." bmkx-bmenu-isearch-marked-bookmarks-regexp
      :help "Regexp Isearch the marked bookmark locations, in their current order"))
  (define-key bmkx-bmenu-search-menu [bmkx-bmenu-isearch-marked-bookmarks]
    '(menu-item "Isearch Marked..." bmkx-bmenu-isearch-marked-bookmarks
      :help "Isearch the marked bookmark locations, in their current order")))
(define-key bmkx-bmenu-search-menu [bmkx-bmenu-search-marked-bookmarks-regexp]
  '(menu-item "Search Marked..." bmkx-bmenu-search-marked-bookmarks-regexp
    :help "Regexp-search the files whose bookmarks are marked, in their current order"))


;;; `Sort' submenu ---------------------------------------------------
(define-key bmkx-bmenu-sort-menu [bmkx-bmenu-sort-by-url]
  '(menu-item "By URL" bmkx-bmenu-sort-by-url
    :help "Sort URL bookmarks alphabetically by their URL/filename"))
(define-key bmkx-bmenu-sort-menu [bmkx-bmenu-sort-by-Gnus-thread]
  '(menu-item "By Gnus Thread" bmkx-bmenu-sort-by-Gnus-thread
    :help "Sort Gnus bookmarks by group, then by article, then by message"))
(define-key bmkx-bmenu-sort-menu [bmkx-bmenu-sort-by-Info-node-name]
  '(menu-item "By Info Node Name" bmkx-bmenu-sort-by-Info-node-name
    :help "Sort Info bookmarks by manual (file) name, then node name, then position"))
(define-key bmkx-bmenu-sort-menu [bmkx-bmenu-sort-by-Info-position]
  '(menu-item "By Info Book Order" bmkx-bmenu-sort-by-Info-position
    :help "Sort Info bookmarks by manual (file) name, then position (order in book)"))
(define-key bmkx-bmenu-sort-menu [bmkx-bmenu-sort-by-last-local-file-update]
  '(menu-item "By Last Local File Update" bmkx-bmenu-sort-by-last-local-file-update
    :help "Sort bookmarks by last local file update time"))
(define-key bmkx-bmenu-sort-menu [bmkx-bmenu-sort-by-last-buffer-or-file-access]
  '(menu-item "By Last Buffer/File Access" bmkx-bmenu-sort-by-last-buffer-or-file-access
    :help "Sort bookmarks by time of last buffer access or local-file access"))
(define-key bmkx-bmenu-sort-menu [bmkx-bmenu-sort-by-local-file-size]
  '(menu-item "By Local File Size" bmkx-bmenu-sort-by-local-file-size
    :help "Sort bookmarks by local file size"))
(define-key bmkx-bmenu-sort-menu [bmkx-bmenu-sort-by-local-file-type]
  '(menu-item "By Local File Type" bmkx-bmenu-sort-by-local-file-type
    :help "Sort bookmarks by local file type: file, symlink, directory"))
(define-key bmkx-bmenu-sort-menu [bmkx-bmenu-sort-by-bookmark-type]
  '(menu-item "By Type" bmkx-bmenu-sort-by-bookmark-type
    :help "Sort bookmarks by type: Info, URL, Gnus, files, other"))
(define-key bmkx-bmenu-sort-menu [bmkx-bmenu-sort-by-file-name]
  '(menu-item "By File Name" bmkx-bmenu-sort-by-file-name :help "Sort bookmarks by file name"))
(define-key bmkx-bmenu-sort-menu [bmkx-bmenu-sort-by-bookmark-name]
  '(menu-item "By Bookmark Name" bmkx-bmenu-sort-by-bookmark-name
    :help "Sort bookmarks by bookmark name, respecting `case-fold-search'"))
(define-key bmkx-bmenu-sort-menu [bmkx-bmenu-sort-by-creation-time]
  '(menu-item "By Creation Time" bmkx-bmenu-sort-by-creation-time
    :help "Sort bookmarks by the time of their creation"))
(define-key bmkx-bmenu-sort-menu [bmkx-bmenu-sort-by-last-bookmark-access]
  '(menu-item "By Last Bookmark Access" bmkx-bmenu-sort-by-last-bookmark-access
    :help "Sort bookmarks by the time of their last visit as bookmarks"))
(define-key bmkx-bmenu-sort-menu [bmkx-bmenu-sort-by-bookmark-visit-frequency]
  '(menu-item "By Bookmark Use" bmkx-bmenu-sort-by-bookmark-visit-frequency
    :help "Sort bookmarks by the number of times they were visited as bookmarks"))
(define-key bmkx-bmenu-sort-menu [bmkx-bmenu-sort-marked-before-unmarked]
  '(menu-item "Marked Before Unmarked" bmkx-bmenu-sort-marked-before-unmarked
    :help "Sort bookmarks by putting marked before unmarked"))
(define-key bmkx-bmenu-sort-menu [bmkx-reverse-sort-order]
  '(menu-item "Reverse" bmkx-reverse-sort-order :help "Reverse the current bookmark sort order"))

;;; `Edit' submenu ---------------------------------------------------
(define-key bmkx-bmenu-edit-menu [bmkx-bmenu-edit-marked]
  '(menu-item "Edit Full Records of Marked (Lisp)" bmkx-bmenu-edit-marked
    :help "Edit the full internal records of the marked bookmarks" :keys "E"))
(define-key bmkx-bmenu-edit-menu [bmkx-bmenu-edit-bookmark-record]
  '(menu-item "Edit Full Record (Lisp)" bmkx-bmenu-edit-bookmark-record
    :help "Edit full record (Lisp sexp) for this bookmark, in another window"))
(define-key bmkx-bmenu-edit-menu [bmkx-bmenu-edit-bookmark-name-and-location]
  '(menu-item "Rename, Relocate..." bmkx-bmenu-edit-bookmark-name-and-location
    :help "Edit name and/or location for this bookmark, in another window"))
(define-key bmkx-bmenu-edit-menu [bmkx-bmenu-edit-annotations-for-marked]
  '(menu-item "Edit Annotations of Marked" bmkx-bmenu-edit-annotations-for-marked
    :help "Edit annotations (created if missing) for the marked bookmarks"))
(define-key bmkx-bmenu-edit-menu [bookmark-bmenu-edit-annotation]
  '(menu-item "Edit Annotation" bookmark-bmenu-edit-annotation
    :help "Edit annotation for this bookmark (create if none), in another window"))

;;; `Show' submenu ---------------------------------------------------
(define-key bmkx-bmenu-show-menu [bookmark-bmenu-show-all-annotations]
  '(menu-item "Show All Annotations" bookmark-bmenu-show-all-annotations
    :help "Show the annotations for all bookmarks (in another window)"))
(define-key bmkx-bmenu-show-menu [bmkx-list-show-annotation]
  '(menu-item "Show Annotation" bmkx-list-show-annotation
    :help "Show the annotation for this bookmark (in another window)"
    :enable (and (bmkx-list-bookmark)  (bookmark-get-annotation (bmkx-list-bookmark)))))
(define-key bmkx-bmenu-show-menu [bookmark-bmenu-toggle-filenames]
  '(menu-item "Show/Hide File Names" bookmark-bmenu-toggle-filenames
    :help "Toggle whether filenames are shown in the bookmark list"))

(define-key bmkx-bmenu-show-menu [show-sep5] '("--")) ; --------------
(define-key bmkx-bmenu-show-menu [bmkx-bmenu-filter-tags-incrementally]
  '(menu-item "Show Only Tag Matches..." bmkx-bmenu-filter-tags-incrementally
    :help "Incrementally filter bookmarks by tags using a regexp"))
(define-key bmkx-bmenu-show-menu [bmkx-bmenu-filter-annotation-incrementally]
  '(menu-item "Show Only Annotation Matches..." bmkx-bmenu-filter-annotation-incrementally
    :help "Incrementally filter bookmarks by annotation using a regexp"))
(define-key bmkx-bmenu-show-menu [bmkx-bmenu-filter-file-name-incrementally]
  '(menu-item "Show Only File Name Matches..." bmkx-bmenu-filter-file-name-incrementally
    :help "Incrementally filter bookmarks by file name using a regexp"))
(define-key bmkx-bmenu-show-menu [bmkx-bmenu-filter-bookmark-name-incrementally]
  '(menu-item "Show Only Name Matches..." bmkx-bmenu-filter-bookmark-name-incrementally
    :help "Incrementally filter bookmarks by bookmark name using a regexp"))

(define-key bmkx-bmenu-show-menu [show-sep3] '("--")) ; --------------
(define-key bmkx-bmenu-show-menu [bmkx-bmenu-show-only-specific-file-bookmarks]
  '(menu-item "Show Only for Specific File" bmkx-bmenu-show-only-specific-file-bookmarks
    :help "Display (only) the bookmarks for a specific file"))
(define-key bmkx-bmenu-show-menu [bmkx-bmenu-show-only-specific-buffer-bookmarks]
  '(menu-item "Show Only for Specific Buffer" bmkx-bmenu-show-only-specific-buffer-bookmarks
    :help "Display (only) the bookmarks for a specific buffer"))

(define-key bmkx-bmenu-show-menu [show-sep2] '("--")) ; --------------
(when (featurep 'bookmark-x-lit)
  (define-key bmkx-bmenu-show-menu [bmkx-bmenu-show-only-lighted-bookmarks]
    '(menu-item "Show Only Highlighted" bmkx-bmenu-show-only-lighted-bookmarks
      :help "Display (only) highlighted bookmarks")))
(define-key bmkx-bmenu-show-menu [bmkx-bmenu-show-only-temporary-bookmarks]
  '(menu-item "Show Only Temporaries" bmkx-bmenu-show-only-temporary-bookmarks
    :help "Display (only) the temporary bookmarks (`X')"))
(define-key bmkx-bmenu-show-menu [bmkx-bmenu-show-only-autonamed-bookmarks]
  '(menu-item "Show Only Autonamed" bmkx-bmenu-show-only-autonamed-bookmarks
    :help "Display (only) the autonamed bookmarks"))
(define-key bmkx-bmenu-show-menu [bmkx-bmenu-show-only-autofile-bookmarks]
  '(menu-item "Show Only Autofiles" bmkx-bmenu-show-only-autofile-bookmarks
    :help "Display (only) the autofile bookmarks: those named the same as their files"))

(define-key bmkx-bmenu-show-menu [show-sep1] '("--")) ; --------------
(define-key bmkx-bmenu-show-menu [bmkx-bmenu-toggle-show-only-unmarked]
  '(menu-item "Show Only Unmarked" bmkx-bmenu-toggle-show-only-unmarked
    :help "Hide all marked bookmarks.  Repeat to toggle, showing all"))
(define-key bmkx-bmenu-show-menu [bmkx-bmenu-toggle-show-only-marked]
  '(menu-item "Show Only Marked" bmkx-bmenu-toggle-show-only-marked
    :help "Hide all unmarked bookmarks.  Repeat to toggle, showing all"))
(define-key bmkx-bmenu-show-menu [bmkx-bmenu-show-all]
  '(menu-item "Show All" bmkx-bmenu-show-all
    :help "Show all bookmarks currently known to the bookmark list"))


;;; `Show' > `Only Bookmarks of Type' submenu -----------------------------

(defvar bmkx-bmenu-show-types-menu (make-sparse-keymap "Only Bookmarks of Type")
    "`Only Bookmarks of Type' submenu for `Show' submenu of `Bookmark-X' menu.")
(define-key bmkx-bmenu-show-menu [type] (cons "Only Bookmarks of Type" bmkx-bmenu-show-types-menu))

(define-key bmkx-bmenu-show-types-menu [show-sep4] '("--")) ; --------------
(define-key bmkx-bmenu-show-types-menu [bmkx-bmenu-show-only-w3m-bookmarks]
  '(menu-item "W3M URLs" bmkx-bmenu-show-only-w3m-bookmarks
    :help "Display (only) the W3M URL bookmarks"))
(when (fboundp 'bmkx-bmenu-show-only-eww-bookmarks) ; Emacs 25+
  (define-key bmkx-bmenu-show-types-menu [bmkx-bmenu-show-only-eww-bookmarks]
    '(menu-item "EWW URLs" bmkx-bmenu-show-only-eww-bookmarks
      :help "Display (only) the EWW URL bookmarks")))
(define-key bmkx-bmenu-show-types-menu [bmkx-bmenu-show-only-url-bookmarks]
  '(menu-item "URLs" bmkx-bmenu-show-only-url-bookmarks
    :help "Display (only) the URL bookmarks"))
(define-key bmkx-bmenu-show-types-menu [bmkx-bmenu-show-only-man-bookmarks]
  '(menu-item "UNIX Manual Pages" bmkx-bmenu-show-only-man-bookmarks
    :help "Display (only) the `man' page bookmarks"))
(define-key bmkx-bmenu-show-types-menu [bmkx-bmenu-show-only-untagged-bookmarks]
  '(menu-item "Untagged" bmkx-bmenu-show-only-untagged-bookmarks
    :help "Display (only) the bookmarks that do not have tags"))
(define-key bmkx-bmenu-show-types-menu [bmkx-bmenu-show-only-tagged-bookmarks]
  '(menu-item "Tagged" bmkx-bmenu-show-only-tagged-bookmarks
    :help "Display (only) the bookmarks that have tags"))
(define-key bmkx-bmenu-show-types-menu [bmkx-bmenu-show-only-variable-list-bookmarks]
  '(menu-item "Variable Lists" bmkx-bmenu-show-only-variable-list-bookmarks
    :help "Display (only) the variable-list bookmarks"))
(define-key bmkx-bmenu-show-types-menu [bmkx-bmenu-show-only-function-bookmarks]
  '(menu-item "Functions" bmkx-bmenu-show-only-function-bookmarks
    :help "Display (only) the function bookmarks"))
(define-key bmkx-bmenu-show-types-menu [bmkx-bmenu-show-only-snippet-bookmarks]
  '(menu-item "Snippets" bmkx-bmenu-show-only-snippet-bookmarks
    :help "Display (only) the snippet bookmarks"))
(define-key bmkx-bmenu-show-types-menu [bmkx-bmenu-show-only-region-bookmarks]
  '(menu-item "Regions" bmkx-bmenu-show-only-region-bookmarks
    :help "Display (only) the bookmarks that record a region"))
(define-key bmkx-bmenu-show-types-menu [bmkx-bmenu-show-only-orphaned-local-file-bookmarks]
  '(menu-item "Orphaned Local Files" bmkx-bmenu-show-only-orphaned-local-file-bookmarks
    :help "Display (only) orphaned local-file bookmarks (`C-u': show remote also)"))
(define-key bmkx-bmenu-show-types-menu [bmkx-bmenu-show-only-non-invokable-bookmarks]
  '(menu-item "Non-Invokable" bmkx-bmenu-show-only-non-invokable-bookmarks
    :help "Display (only) the non-invokable bookmarks"))
(define-key bmkx-bmenu-show-types-menu [bmkx-bmenu-show-only-non-file-bookmarks]
  '(menu-item "Non-Files (Buffers)" bmkx-bmenu-show-only-non-file-bookmarks
    :help "Display (only) the non-file bookmarks"))
(define-key bmkx-bmenu-show-types-menu [bmkx-bmenu-show-only-image-bookmarks]
  '(menu-item "Image Files" bmkx-bmenu-show-only-image-bookmarks
    :help "Display (only) image-file bookmarks"))
(define-key bmkx-bmenu-show-types-menu [bmkx-bmenu-show-only-info-bookmarks]
  '(menu-item "Info Nodes" bmkx-bmenu-show-only-info-bookmarks
    :help "Display (only) the Info bookmarks"))
(define-key bmkx-bmenu-show-types-menu [bmkx-bmenu-show-only-gnus-bookmarks]
  '(menu-item "Gnus Messages" bmkx-bmenu-show-only-gnus-bookmarks
    :help "Display (only) the Gnus bookmarks"))
(define-key bmkx-bmenu-show-types-menu [bmkx-bmenu-show-only-file-bookmarks]
  '(menu-item "Files" bmkx-bmenu-show-only-file-bookmarks
    :help "Display (only) the file and directory bookmarks"))
(define-key bmkx-bmenu-show-types-menu [bmkx-bmenu-show-only-dired-bookmarks]
  '(menu-item "Dired Buffers" bmkx-bmenu-show-only-dired-bookmarks
    :help "Display (only) the Dired bookmarks"))
(define-key bmkx-bmenu-show-types-menu [bmkx-bmenu-show-only-desktop-bookmarks]
  '(menu-item "Desktops" bmkx-bmenu-show-only-desktop-bookmarks
    :help "Display (only) the desktop bookmarks"))
(define-key bmkx-bmenu-show-types-menu [bmkx-bmenu-show-only-bookmark-list-bookmarks]
  '(menu-item "Bookmark Lists" bmkx-bmenu-show-only-bookmark-list-bookmarks
    :help "Display (only) the bookmark-list bookmarks"))
(define-key bmkx-bmenu-show-types-menu [bmkx-bmenu-show-only-bookmark-file-bookmarks]
  '(menu-item "Bookmark Files" bmkx-bmenu-show-only-bookmark-file-bookmarks
    :help "Display (only) the bookmark-file bookmarks"))


;;; `Omit' submenu ---------------------------------------------------
(define-key bmkx-bmenu-omit-menu [bmkx-bmenu-show-all]
  '(menu-item "Show All" bmkx-bmenu-show-all
    :visible (eq bmkx-bmenu-filter-function 'bmkx-omitted-alist-only)
    :help "Show all bookmarks (except omitted)"))
(define-key bmkx-bmenu-omit-menu [bmkx-bmenu-show-only-omitted-bookmarks]
  '(menu-item "Show Only Omitted" bmkx-bmenu-show-only-omitted-bookmarks
    :visible (not (eq bmkx-bmenu-filter-function 'bmkx-omitted-alist-only))
    :enable bmkx-bmenu-omitted-bookmarks :help "Show only the omitted bookmarks"))
(define-key bmkx-bmenu-omit-menu [bmkx-unomit-all]
  '(menu-item "Un-Omit All" bmkx-unomit-all
    :visible bmkx-bmenu-omitted-bookmarks :help "Un-omit all omitted bookmarks"))
(define-key bmkx-bmenu-omit-menu [bmkx-bmenu-unomit-marked]
  '(menu-item "Un-Omit Marked" bmkx-bmenu-unomit-marked
    :visible (eq bmkx-bmenu-filter-function 'bmkx-omitted-alist-only)
    :enable (and bmkx-bmenu-omitted-bookmarks
             (save-excursion (goto-char (point-min)) (forward-line bmkx-bmenu-header-lines)
                             (re-search-forward "^>" (point-max) t)))
    :help "Un-omit the marked bookmarks" :keys "\\[bmkx-bmenu-omit/unomit-marked]"))
(define-key bmkx-bmenu-omit-menu [bmkx-bmenu-omit-marked]
  '(menu-item "Omit Marked" bmkx-bmenu-omit-marked
    :visible (not (eq bmkx-bmenu-filter-function 'bmkx-omitted-alist-only))
    :enable (save-excursion (goto-char (point-min)) (forward-line bmkx-bmenu-header-lines)
                            (re-search-forward "^>" (point-max) t))
    :help "Omit the marked bookmarks" :keys "\\[bmkx-bmenu-omit/unomit-marked]"))


;;; `Mark' submenu ---------------------------------------------------
(define-key bmkx-bmenu-mark-menu [mark-sep5] '("--")) ; --------------
(define-key bmkx-bmenu-mark-menu [bmkx-bmenu-load-marking-unmark-first]
  '(menu-item "Load Bookmark File, Mark Only Loaded...." bmkx-bmenu-load-marking-unmark-first
    :help "`bmkx-load', marking only bookmarks that are loaded."))
(define-key bmkx-bmenu-mark-menu [bmkx-bmenu-load-marking]
  '(menu-item "Load Bookmark File, Mark Loaded...." bmkx-bmenu-load-marking
    :help "`bmkx-load', but mark bookmarks that are loaded.  C-u: unmark all first."))

(define-key bmkx-bmenu-mark-menu [bmkx-bmenu-unmark-bookmarks-tagged-not-all]
  '(menu-item "Unmark If Not Tagged with All..." bmkx-bmenu-unmark-bookmarks-tagged-not-all
    :help "Unmark all visible bookmarks that are tagged with *some* tag in a set you specify"))
(define-key bmkx-bmenu-mark-menu [bmkx-bmenu-unmark-bookmarks-tagged-none]
  '(menu-item "Unmark If Tagged with None..." bmkx-bmenu-unmark-bookmarks-tagged-none
    :help "Unmark all visible bookmarks that are *not* tagged with *any* tag you specify"))
(define-key bmkx-bmenu-mark-menu [bmkx-bmenu-unmark-bookmarks-tagged-all]
  '(menu-item "Unmark If Tagged with All..." bmkx-bmenu-unmark-bookmarks-tagged-all
    :help "Unmark all visible bookmarks that are tagged with *each* tag you specify"))
(define-key bmkx-bmenu-mark-menu [bmkx-bmenu-unmark-bookmarks-tagged-some]
  '(menu-item "Unmark If Tagged with Some..." bmkx-bmenu-unmark-bookmarks-tagged-some
    :help "Unmark all visible bookmarks that are tagged with *some* tag in a set you specify"))
(define-key bmkx-bmenu-mark-menu [bmkx-bmenu-unmark-bookmarks-tagged-regexp]
  '(menu-item "Unmark If Tagged Matching Regexp..." bmkx-bmenu-unmark-bookmarks-tagged-regexp
    :help "Unmark bookmarks any of whose tags match a regexp you enter"))
(define-key bmkx-bmenu-mark-menu [bmkx-bmenu-mark-bookmarks-tagged-not-all]
  '(menu-item "Mark If Not Tagged with All..." bmkx-bmenu-mark-bookmarks-tagged-not-all
    :help "Mark all visible bookmarks that are *not* tagged with *all* tags you specify"))
(define-key bmkx-bmenu-mark-menu [bmkx-bmenu-mark-bookmarks-tagged-none]
  '(menu-item "Mark If Tagged with None..." bmkx-bmenu-mark-bookmarks-tagged-none
    :help "Mark all visible bookmarks that are not tagged with *any* tag you specify"))
(define-key bmkx-bmenu-mark-menu [bmkx-bmenu-mark-bookmarks-tagged-all]
  '(menu-item "Mark If Tagged with All..." bmkx-bmenu-mark-bookmarks-tagged-all
    :help "Mark all visible bookmarks that are tagged with *each* tag you specify"))
(define-key bmkx-bmenu-mark-menu [bmkx-bmenu-mark-bookmarks-tagged-some]
  '(menu-item "Mark If Tagged with Some..." bmkx-bmenu-mark-bookmarks-tagged-some
    :help "Mark all visible bookmarks that are tagged with *some* tag in a set you specify"))
(define-key bmkx-bmenu-mark-menu [bmkx-bmenu-mark-bookmarks-tagged-regexp]
  '(menu-item "Mark If Tagged Matching Regexp..." bmkx-bmenu-mark-bookmarks-tagged-regexp
    :help "Mark bookmarks any of whose tags match a regexp you enter"))

(define-key bmkx-bmenu-mark-menu [mark-sep3] '("--")) ; --------------
(when (featurep 'bookmark-x-lit)
  (define-key bmkx-bmenu-mark-menu [bmkx-bmenu-mark-lighted-bookmarks]
    '(menu-item "Mark Highlighted" bmkx-bmenu-mark-lighted-bookmarks
      :help "Mark highlighted bookmarks")))
(define-key bmkx-bmenu-mark-menu [bmkx-bmenu-mark-temporary-bookmarks]
  '(menu-item "Mark Temporaries" bmkx-bmenu-mark-temporary-bookmarks
    :help "Mark temporary bookmarks (those with `X')"))
(define-key bmkx-bmenu-mark-menu [bmkx-bmenu-mark-autonamed-bookmarks]
  '(menu-item "Mark Autonamed" bmkx-bmenu-mark-autonamed-bookmarks
    :help "Mark autonamed bookmarks"))
(define-key bmkx-bmenu-mark-menu [bmkx-bmenu-mark-autofile-bookmarks]
  '(menu-item "Mark Autofiles" bmkx-bmenu-mark-autofile-bookmarks
    :help "Mark autofile bookmarks: those whose names are the same as their files"))

(define-key bmkx-bmenu-mark-menu [mark-sep2] '("--")) ; --------------
(define-key bmkx-bmenu-mark-menu [bmkx-bmenu-unmark-all]
  '(menu-item "Unmark All" bmkx-bmenu-unmark-all
    :help "Remove a mark you specify (> or D) from each bookmark (RET to remove both kinds)"))
(define-key bmkx-bmenu-mark-menu [bmkx-bmenu-mark-all]
  '(menu-item "Mark All" bmkx-bmenu-mark-all :help "Mark all bookmarks, using mark `>'"))
(define-key bmkx-bmenu-mark-menu [bmkx-bmenu-toggle-marks]
  '(menu-item "Toggle Marked/Unmarked" bmkx-bmenu-toggle-marks
    :help "Unmark all marked bookmarks; mark all unmarked bookmarks"))
(define-key bmkx-bmenu-mark-menu [bmkx-bmenu-regexp-mark]
  '(menu-item "Mark Regexp Matches..." bmkx-bmenu-regexp-mark
    :help "Mark bookmarks that match a regexp that you enter"))

(define-key bmkx-bmenu-mark-menu [mark-sep4] '("--")) ; --------------
(define-key bmkx-bmenu-mark-menu [bmkx-bmenu-mark-specific-file-bookmarks]
  '(menu-item "Mark for Specific File" bmkx-bmenu-mark-specific-file-bookmarks
    :help "Mark bookmarks for a specific file"))
(define-key bmkx-bmenu-mark-menu [bmkx-bmenu-mark-specific-buffer-bookmarks]
  '(menu-item "Mark for Specific Buffer" bmkx-bmenu-mark-specific-buffer-bookmarks
    :help "Mark bookmarks for a specific buffer"))


;; `Mark' > `Bookmarks of Type' submenu ------------------------------
(defvar bmkx-bmenu-mark-types-menu (make-sparse-keymap "Bookmarks of Type")
  "`Bookmarks of Type' submenu for `Mark' submenu of m`Bookmark-X' menu.")
(define-key bmkx-bmenu-mark-menu [type] (cons "Bookmarks of Type" bmkx-bmenu-mark-types-menu))

(define-key bmkx-bmenu-mark-types-menu [bmkx-bmenu-mark-w3m-bookmarks]
  '(menu-item "W3M URLs" bmkx-bmenu-mark-w3m-bookmarks :help "Mark W3M URL bookmarks"))
(when (fboundp 'bmkx-bmenu-mark-eww-bookmarks) ; Emacs 25+
  (define-key bmkx-bmenu-mark-types-menu [bmkx-bmenu-mark-eww-bookmarks]
    '(menu-item "EWW URLs" bmkx-bmenu-mark-eww-bookmarks :help "Mark Eww URL bookmarks")))
(define-key bmkx-bmenu-mark-types-menu [bmkx-bmenu-mark-url-bookmarks]
  '(menu-item "URLs" bmkx-bmenu-mark-url-bookmarks :help "Mark URL bookmarks"))
(define-key bmkx-bmenu-mark-types-menu [bmkx-bmenu-mark-variable-list-bookmarks]
  '(menu-item "Variable Lists" bmkx-bmenu-mark-variable-list-bookmarks
    :help "Mark the variable-list bookmarks"))
(define-key bmkx-bmenu-mark-types-menu [bmkx-bmenu-mark-man-bookmarks]
  '(menu-item "UNIX Manual Pages" bmkx-bmenu-mark-man-bookmarks
    :help "Mark `man' page bookmarks"))
(define-key bmkx-bmenu-mark-types-menu [bmkx-bmenu-mark-snippet-bookmarks]
  '(menu-item "Snippets" bmkx-bmenu-mark-snippet-bookmarks
    :help "Mark snippet bookmarks"))
(define-key bmkx-bmenu-mark-types-menu [bmkx-bmenu-mark-region-bookmarks]
  '(menu-item "Regions" bmkx-bmenu-mark-region-bookmarks
    :help "Mark bookmarks that record a region"))
(define-key bmkx-bmenu-mark-types-menu [bmkx-bmenu-mark-orphaned-local-file-bookmarks]
  '(menu-item "Orphaned Local Files" bmkx-bmenu-mark-orphaned-local-file-bookmarks
    :help "Mark orphaned local-file bookmarks (`C-u': remote also)"))
(define-key bmkx-bmenu-mark-types-menu [bmkx-bmenu-mark-non-invokable-bookmarks]
  '(menu-item "Non-Invokable" bmkx-bmenu-mark-non-invokable-bookmarks
    :help "Mark non-invokable bookmarks"))
(define-key bmkx-bmenu-mark-types-menu [bmkx-bmenu-mark-non-file-bookmarks]
  '(menu-item "Non-Files (Buffers)" bmkx-bmenu-mark-non-file-bookmarks
    :help "Mark non-file bookmarks"))
(define-key bmkx-bmenu-mark-types-menu [bmkx-bmenu-mark-image-bookmarks]
  '(menu-item "Images" bmkx-bmenu-mark-image-bookmarks :help "Mark image-file bookmarks"))
(define-key bmkx-bmenu-mark-types-menu [bmkx-bmenu-mark-info-bookmarks]
  '(menu-item "Info Nodes" bmkx-bmenu-mark-info-bookmarks :help "Mark Info bookmarks"))
(define-key bmkx-bmenu-mark-types-menu [bmkx-bmenu-mark-gnus-bookmarks]
  '(menu-item "Gnus Messages" bmkx-bmenu-mark-gnus-bookmarks :help "Mark Gnus bookmarks"))
(define-key bmkx-bmenu-mark-types-menu [bmkx-bmenu-mark-file-bookmarks]
  '(menu-item "Files" bmkx-bmenu-mark-file-bookmarks :help "Mark file bookmarks"))
(define-key bmkx-bmenu-mark-types-menu [bmkx-bmenu-mark-dired-bookmarks]
  '(menu-item "Dired Buffers" bmkx-bmenu-mark-dired-bookmarks :help "Mark Dired bookmarks"))
(define-key bmkx-bmenu-mark-types-menu [bmkx-bmenu-mark-desktop-bookmarks]
  '(menu-item "Desktops" bmkx-bmenu-mark-desktop-bookmarks
    :help "Mark desktop bookmarks"))
(define-key bmkx-bmenu-mark-types-menu [bmkx-bmenu-mark-bookmark-list-bookmarks]
  '(menu-item "Bookmark Lists" bmkx-bmenu-mark-bookmark-list-bookmarks
    :help "Mark the bookmark-list bookmarks"))
(define-key bmkx-bmenu-mark-types-menu [bmkx-bmenu-mark-bookmark-file-bookmarks]
  '(menu-item "Bookmark Files" bmkx-bmenu-mark-bookmark-file-bookmarks
    :help "Mark the bookmark-file bookmarks"))


;;; `Delete' submenu -------------------------------------------------
(define-key bmkx-bmenu-delete-menu [bmkx-list-execute-deletions]
  '(menu-item "Delete Flagged (D)..." bmkx-list-execute-deletions
    :help "Delete the (visible) bookmarks flagged `D'"))
(define-key bmkx-bmenu-delete-menu [bmkx-bmenu-delete-marked]
  '(menu-item "Delete Marked (>)..." bmkx-bmenu-delete-marked
    :help "Delete all (visible) bookmarks marked `>', after confirmation"))
(define-key bmkx-bmenu-delete-menu [bmkx-delete-all-temporary-bookmarks]
  '(menu-item "Delete All Temporaries..." bmkx-delete-all-temporary-bookmarks
    :help "Delete the temporary bookmarks, (`X') whether visible here or not"))


;;; `Edit' menu-bar menu

;; `menu-bar+.el' redefines `menu-bar-edit-menu'.
;; Soft-require it in `condition-case' because it soft-requires Bookmark-X.
(condition-case nil (require 'menu-bar+ nil t) (error nil))

(define-key-after menu-bar-edit-menu [separator-snippet] '("--")  'mark-whole-buffer)
(define-key-after menu-bar-edit-menu [bmkx-set-snippet-bookmark]
  '(menu-item "Region to Snippet..." bmkx-set-snippet-bookmark
    :help "Save the region text to a snippet bookmark"
    :enable (and mark-active (not buffer-read-only))) 'separator-snippet)
(define-key-after menu-bar-edit-menu [bmkx-snippet-to-kill-ring]
  '(menu-item "Snippet to Kill Ring..." bmkx-snippet-to-kill-ring
    :help "Copy the text saved in a snippet bookmark to the `kill-ring'")
  'bmkx-set-snippet-bookmark)



;;;---------------------------------------------------------------------------------------

;;; Mouse-3 menu binding.

(defvar bmkx-bmenu-line-overlay nil
  "Overlay to highlight the current line for `bmkx-bmenu-mouse-3-menu'.")
(define-key bmkx-list-mode-map [down-mouse-3] 'bmkx-bmenu-mouse-3-menu)
(define-key bmkx-list-mode-map [mouse-3]      'ignore)

;;;###autoload (autoload 'bmkx-bmenu-mouse-3-menu "bookmark-x")
(defun bmkx-bmenu-mouse-3-menu (event)
  "Pop-up menu on `mouse-3' for a bookmark listed in `*Bmkx List*'."
  (interactive "e")
  (let* ((mouse-pos                  (event-start event))
         (inhibit-field-text-motion  t) ; Just in case.
         bol eol bmk-name)
    (with-current-buffer (window-buffer (posn-window mouse-pos))
      (save-excursion
        (goto-char (posn-point mouse-pos))
        (setq bol  (line-beginning-position)
              eol  (line-end-position))
        (unwind-protect
             (progn
               (if bmkx-bmenu-line-overlay ; Don't re-create.
                   (move-overlay bmkx-bmenu-line-overlay bol eol (current-buffer))
                 (setq bmkx-bmenu-line-overlay  (make-overlay bol eol))
                 (overlay-put bmkx-bmenu-line-overlay 'face 'region))
               (setq bmk-name (bmkx-list-bookmark))
               (when bmk-name
                 (sit-for 0)
                 (let* ((map     (easy-menu-create-menu
                                  "This Bookmark"
                                  `(,(if (bmkx-bookmark-name-member bmk-name bmkx-bmenu-marked-bookmarks)
                                         ["Unmark" bmkx-list-unmark]
                                         ["Mark" bmkx-list-mark])
                                    ,(save-excursion
                                      (goto-char (posn-point mouse-pos))
                                      (beginning-of-line)
                                      (if (looking-at-p "^D")
                                          ["Unmark" bmkx-list-unmark]
                                        ["Flag for Deletion" bmkx-bmenu-flag-for-deletion]))
                                    ["Omit" bmkx-bmenu-omit]
                                    ["Jump To" bmkx-list-this-window]
                                    ["Jump To in Other Window" bmkx-list-other-window]

                                    "--" ; ----------------------------------------------------
                                    ["Edit Tags..." bmkx-bmenu-edit-tags
                                     :active (bmkx-get-tags bmk-name)]
                                    ["Copy Tags" bmkx-bmenu-copy-tags
                                     ;; You can copy an empty list of tags and paste-replace with it.
                                     ;; :active (bmkx-get-tags bmk-name)
                                     ]
                                    ["Paste Tags (Add)" bmkx-bmenu-paste-add-tags
                                     :active bmkx-copied-tags]
                                    ["Paste Tags (Replace)" bmkx-bmenu-paste-replace-tags
                                     ;; You can paste an empty list of tags to replace tags.
                                     ;; :active bmkx-copied-tags
                                     ]
                                    ["Add Some Tags..." bmkx-bmenu-add-tags]
                                    ["Remove Some Tags..." bmkx-bmenu-remove-tags
                                     :active (bmkx-get-tags bmk-name)]
                                    ["Remove All Tags..." bmkx-bmenu-remove-all-tags
                                     :active (bmkx-get-tags bmk-name)]
                                    ["Set Tag Value..." bmkx-bmenu-set-tag-value
                                     :active (bmkx-get-tags bmk-name)]
                                    ["Rename Tag..." bmkx-rename-tag
                                     :active (bmkx-get-tags bmk-name)]

                                    ["--" 'ignore :visible (featurep 'bookmark-x-lit)] ; ---------------
                                    ["Highlight" bmkx-bmenu-light
                                     :visible (featurep 'bookmark-x-lit)
                                     :active (not (bmkx-lighted-p bmk-name))]
                                    ["Unhighlight" bmkx-bmenu-unlight
                                     :visible (featurep 'bookmark-x-lit)
                                     :active (bmkx-lighted-p bmk-name)]
                                    ["Set Lighting" bmkx-bmenu-set-lighting
                                     :visible (featurep 'bookmark-x-lit)]

                                    "--" ; ----------------------------------------------------
                                    ["Toggle Temporary/Savable" bmkx-bmenu-toggle-temporary]
                                    ,@(and (fboundp 'org-add-link-type)
                                           '(["Store Org Link" org-store-link]))
                                    ["Rename, Relocate..." bmkx-bmenu-edit-bookmark-name-and-location]
                                    ["Clone (Duplicate)" bmkx-bmenu-clone-bookmark]
                                    ["Edit Internal Record (Lisp)..." bmkx-bmenu-edit-bookmark-record]
                                    ["Show Annotation" bmkx-list-show-annotation
                                     :active (bookmark-get-annotation bmk-name)]
                                    ["Edit Annotation..." bookmark-bmenu-edit-annotation]

                                    "--" ; ----------------------------------------------------
                                    ["Describe" bmkx-bmenu-describe-this-bookmark])))
                        (choice  (x-popup-menu event map)))
                   (when choice
                     (call-interactively (lookup-key map (apply 'vector choice)))))))
          (when bmkx-bmenu-line-overlay (delete-overlay bmkx-bmenu-line-overlay)))))))

;;;;;;;;;;;;;;;;;;;;;

(provide 'bookmark-x-bmu)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; bookmark-x-bmu.el ends here
