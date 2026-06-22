;;; bookmark-x-1.el --- First part of package Bookmark-X.   -*- lexical-binding:t -*-
;;
;; Filename:    bookmark-x-1.el
;; Description: First part of package Bookmark-X.
;;              Fork of Drew Adams' Bookmark+, modernized for Emacs 30+.
;;
;; Author:     Drew Adams, Thierry Volpiatto
;; Maintainer: Daniel M. German <dmg@turingmachine.org>
;;
;; Copyright (C) 2000-2025, Drew Adams, all rights reserved.
;; Copyright (C) 2009, Thierry Volpiatto, all rights reserved.
;; Copyright (C) 2026, Daniel M. German, all rights reserved.
;;
;; Created: Mon Jul 12 13:43:55 2010 (-0700)
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
;;   `backquote', `bookmark', `bookmark-x-1', `button', `bytecomp',
;;   `cconv', `cl-lib', `font-lock',
;;   `font-lock+', `help-mode', `hl-line', `hl-line+', `kmacro',
;;   `macroexp', `pp', `replace', `syntax', `text-mode', `thingatpt',
;;   `thingatpt', `vline'.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;;    The Bookmark-X libraries are these:
;;
;;    `bookmark-x.el'     - main (driver) library
;;    `bookmark-x-mac.el' - Lisp macros
;;    `bookmark-x-lit.el' - (optional) code for highlighting bookmarks
;;    `bookmark-x-bmu.el' - code for the `*Bmkx List*' (bmenu)
;;    `bookmark-x-1.el'   - other (non-bmenu) required code (this file)
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
;;  (@> "User Options (Customizable)")
;;  (@> "Internal Variables")
;;  (@> "Compatibility Code for Older Emacs Versions")
;;  (@> "Core Replacements (`bookmark-*' except `bookmark-bmenu-*')")
;;  (@> "Bookmark-X Functions (`bmkx-*')")
;;    (@> "Search-and-Replace Locations of Marked Bookmarks")
;;    (@> "Tags")
;;    (@> "Bookmark Predicates")
;;    (@> "Filter Functions")
;;    (@> "General Utility Functions")
;;    (@> "Bookmark Entry Access Functions")
;;    (@> "Sorting - General Functions")
;;    (@> "Sorting - Commands")
;;    (@> "Sorting - General Predicates")
;;    (@> "Sorting - File-Name Predicates")
;;    (@> "Indirect Bookmarking Functions")
;;    (@> "Other Bookmark-X Functions (`bmkx-*')")
;;  (@> "Keymaps")
 
;;(@* "Things Defined Here")
;;
;;  Things Defined Here
;;  -------------------
;;
;;  Commands defined here:
;;
;;    `bmkx-add-tags', `bmkx-all-tags-jump',
;;    `bmkx-all-tags-jump-other-window', `bmkx-all-tags-regexp-jump',
;;    `bmkx-all-tags-regexp-jump-other-window',
;;    `bmkx-annotate-all-bookmarks-this-file/buffer',
;;    `bmkx-annotate-bookmark',
;;    `bmkx-annotate-bookmark-this-file/buffer',
;;    `bmkx-autofile-add-tags', `bmkx-autofile-all-tags-jump',
;;    `bmkx-autofile-all-tags-jump-other-window',
;;    `bmkx-autofile-all-tags-regexp-jump',
;;    `bmkx-autofile-all-tags-regexp-jump-other-window',
;;    `bmkx-autofile-jump', `bmkx-autofile-jump-other-window',
;;    `bmkx-autofile-remove-tags', `bmkx-autofile-set',
;;    `bmkx-autofile-some-tags-jump',
;;    `bmkx-autofile-some-tags-jump-other-window',
;;    `bmkx-autofile-some-tags-regexp-jump',
;;    `bmkx-autofile-some-tags-regexp-jump-other-window',
;;    `bmkx-automatic-bookmark-mode', `bmkx-autonamed-jump',
;;    `bmkx-autonamed-jump-other-window',
;;    `bmkx-autonamed-this-buffer-jump',
;;    `bmkx-autonamed-this-buffer-jump-other-window',
;;    `bmkx-bookmark-a-file' `bmkx-bookmark-all-dired-buffers',
;;    `bmkx-bookmark-file-jump', `bmkx-bookmark-file-load-jump',
;;    `bmkx-bookmark-file-switch-jump', `bmkx-bookmark-linked-at'
;;    (Emacs 22+), `bmkx-bookmark-linked-at-mouse' (Emacs 22+),
;;    `bmkx-bookmark-list-jump',
;;    `bmkx-bookmark-set-confirm-overwrite',
;;    `bmkx-choose-navlist-from-bookmark-list',
;;    `bmkx-choose-navlist-of-type', `bmkx-clone-bookmark',
;;    `bmkx-compilation-target-set',
;;    `bmkx-compilation-target-set-all', `bmkx-copy-bookmark',
;;    `bmkx-convert-eww-bookmarks' (Emacs 25+), `bmkx-copy-tags',
;;    `bmkx-highlight-jump-target', `bmkx-cycle',
;;    `bmkx-cycle-autonamed', `bmkx-cycle-autonamed-other-window',
;;    `bmkx-cycle-bookmark-list',
;;    `bmkx-cycle-bookmark-list-other-window', `bmkx-cycle-desktop',
;;    `bmkx-cycle-dired', `bmkx-cycle-dired-other-window',
;;    `bmkx-cycle-eww', `bmkx-cycle-eww-other-window',
;;    `bmkx-cycle-file', `bmkx-cycle-file-other-window',
;;    `bmkx-cycle-gnus', `bmkx-cycle-gnus-other-window',
;;    `bmkx-cycle-info', `bmkx-cycle-info-other-window',
;;    `bmkx-cycle-lighted', `bmkx-cycle-lighted-other-window',
;;    `bmkx-cycle-local-file', `bmkx-cycle-local-file-other-window',
;;    `bmkx-cycle-man', `bmkx-cycle-man-other-window',
;;    `bmkx-cycle-non-file', `bmkx-cycle-non-file-other-window',
;;    `bmkx-cycle-other-window', `bmkx-cycle-remote-file',
;;    `bmkx-cycle-remote-file-other-window',
;;    `bmkx-cycle-specific-buffers',
;;    `bmkx-cycle-specific-buffers-other-window',
;;    `bmkx-cycle-specific-files',
;;    `bmkx-cycle-specific-files-other-window',
;;    `bmkx-cycle-this-buffer', `bmkx-cycle-this-buffer-other-window',
;;    `bmkx-cycle-this-file', `bmkx-cycle-this-file/buffer',
;;    `bmkx-cycle-this-file/buffer-other-window',
;;    `bmkx-cycle-this-file-other-window', `bmkx-cycle-variable-list',
;;    `bmkx-cycle-url', `bmkx-cycle-url-other-window',
;;    `bmkx-delete-all-autonamed-for-this-buffer',
;;    `bmkx-delete-all-temporary-bookmarks', `bmkx-delete-bookmarks',
;;    `bmkx-describe-bookmark', `bmkx-describe-bookmark-internals',
;;    `bmkx-desktop-change-dir', `bmkx-desktop-delete',
;;    `bmkx-desktop-jump', `bmkx-desktop-read', `bmkx-dired-jump',
;;    `bmkx-dired-jump-other-window', `bmkx-dired-this-dir-jump',
;;    `bmkx-dired-this-dir-jump-other-window',
;;    `bmkx-edit-bookmark-name-and-location',
;;    `bmkx-edit-bookmark-record',
;;    `bmkx-edit-bookmark-record-file/buffer',
;;    `bmkx-edit-bookmark-record-send',
;;    `bmkx-edit-bookmark-records-send', `bmkx-edit-tags',
;;    `bmkx-edit-tags-send', `bmkx-edit-this-annotation',
;;    `bmkx-empty-file', `bmkx-eww-jump' (Emacs 25+),
;;    `bmkx-eww-jump-other-window' (Emacs 25+),
;;    `bmkx-eww-auto-bookmark-mode' (Emacs 25+),
;;    `bmkx-ffap-max-region-size', `bmkx-file-target-set',
;;    `bmkx-file-all-tags-jump',
;;    `bmkx-file-all-tags-jump-other-window',
;;    `bmkx-file-all-tags-regexp-jump',
;;    `bmkx-file-all-tags-regexp-jump-other-window', `bmkx-file-jump',
;;    `bmkx-file-jump-other-window', `bmkx-file-some-tags-jump',
;;    `bmkx-file-some-tags-jump-other-window',
;;    `bmkx-file-some-tags-regexp-jump',
;;    `bmkx-file-some-tags-regexp-jump-other-window',
;;    `bmkx-file-this-dir-all-tags-jump',
;;    `bmkx-file-this-dir-all-tags-jump-other-window',
;;    `bmkx-file-this-dir-all-tags-regexp-jump',
;;    `bmkx-file-this-dir-all-tags-regexp-jump-other-window',
;;    `bmkx-file-this-dir-jump',
;;    `bmkx-file-this-dir-jump-other-window',
;;    `bmkx-file-this-dir-some-tags-jump',
;;    `bmkx-file-this-dir-some-tags-jump-other-window',
;;    `bmkx-file-this-dir-some-tags-regexp-jump',
;;    `bmkx-file-this-dir-some-tags-regexp-jump-other-window',
;;    `bmkx-find-file', `bmkx-find-file-other-window',
;;    `bmkx-find-file-all-tags',
;;    `bmkx-find-file-all-tags-other-window',
;;    `bmkx-find-file-all-tags-regexp',
;;    `bmkx-find-file-all-tags-regexp-other-window',
;;    `bmkx-find-file-some-tags',
;;    `bmkx-find-file-some-tags-other-window',
;;    `bmkx-find-file-some-tags-regexp',
;;    `bmkx-find-file-some-tags-regexp-other-window',
;;    `bmkx-get-external-annotation',
;;    `bmkx-global-automatic-bookmark-mode' (Emacs 21+),
;;    `bmkx-gnus-jump', `bmkx-gnus-jump-other-window',
;;    `bmkx-image-jump', `bmkx-image-jump-other-window',
;;    `bmkx-info-auto-bookmark-mode' (Emacs 22+), `bmkx-info-jump',
;;    `bmkx-info-jump-other-window', `bmkx-insert-bookmark-link'
;;    (Emacs 22+), `bmkx-jump-in-navlist',
;;    `bmkx-jump-in-navlist-other-window',
;;    `bmkx-jump-to-bookmark-linked-at' (Emacs 22+),
;;    `bmkx-jump-to-bookmark-linked-at-mouse' (Emacs 22+),
;;    `bmkx-jump-to-list', `bmkx-tag-jump',
;;    `bmkx-tag-jump-other-window', `bmkx-jump-to-type',
;;    `bmkx-jump-to-type-other-window', `bmkx-list-all-tags',
;;    `bmkx-list-defuns-in-commands-file', `bmkx-local-file-jump',
;;    `bmkx-local-file-jump-other-window',
;;    `bmkx-local-non-dir-file-jump',
;;    `bmkx-local-non-dir-file-jump-other-window',
;;    `bmkx-make-bookmark-savable', `bmkx-make-bookmark-temporary',
;;    `bmkx-make-function-bookmark', `bmkx-man-jump',
;;    `bmkx-man-jump-other-window', `bmkx-navlist-bmenu-list',
;;    `bmkx-next-autonamed-bookmark',
;;    `bmkx-next-autonamed-bookmark-other-window',
;;    `bmkx-next-autonamed-bookmark-other-window-repeat',
;;    `bmkx-next-autonamed-bookmark-repeat', `bmkx-next-bookmark',
;;    `bmkx-next-bookmark-list-bookmark',
;;    `bmkx-next-bookmark-list-bookmark-other-window',
;;    `bmkx-next-bookmark-list-bookmark-other-window-repeat',
;;    `bmkx-next-bookmark-list-bookmark-repeat',
;;    `bmkx-next-bookmark-other-window',
;;    `bmkx-next-bookmark-other-window-repeat',
;;    `bmkx-next-bookmark-repeat', `bmkx-next-bookmark-this-buffer',
;;    `bmkx-next-bookmark-this-buffer-other-window',
;;    `bmkx-next-bookmark-this-buffer-other-window-repeat',
;;    `bmkx-next-bookmark-this-buffer-repeat',
;;    `bmkx-next-bookmark-this-file',
;;    `bmkx-next-bookmark-this-file/buffer',
;;    `bmkx-next-bookmark-this-file/buffer-other-window',
;;    `bmkx-next-bookmark-this-file/buffer-other-window-repeat',
;;    `bmkx-next-bookmark-this-file/buffer-repeat',
;;    `bmkx-next-bookmark-this-file-other-window',
;;    `bmkx-next-bookmark-this-file-other-window-repeat',
;;    `bmkx-next-bookmark-this-file-repeat',
;;    `bmkx-next-desktop-bookmark',
;;    `bmkx-next-desktop-bookmark-other-window',
;;    `bmkx-next-desktop-bookmark-other-window-repeat',
;;    `bmkx-next-desktop-bookmark-repeat', `bmkx-next-dired-bookmark',
;;    `bmkx-next-dired-bookmark-other-window',
;;    `bmkx-next-dired-bookmark-other-window-repeat',
;;    `bmkx-next-dired-bookmark-repeat', `bmkx-next-eww-bookmark',
;;    `bmkx-next-eww-bookmark-other-window',
;;    `bmkx-next-eww-bookmark-other-window-repeat',
;;    `bmkx-next-eww-bookmark-repeat', `bmkx-next-file-bookmark',
;;    `bmkx-next-file-bookmark-other-window',
;;    `bmkx-next-file-bookmark-other-window-repeat',
;;    `bmkx-next-file-bookmark-repeat', `bmkx-next-gnus-bookmark',
;;    `bmkx-next-gnus-bookmark-other-window',
;;    `bmkx-next-gnus-bookmark-other-window-repeat',
;;    `bmkx-next-gnus-bookmark-repeat', `bmkx-next-info-bookmark',
;;    `bmkx-next-info-bookmark-other-window',
;;    `bmkx-next-info-bookmark-other-window-repeat',
;;    `bmkx-next-info-bookmark-repeat', `bmkx-next-lighted-bookmark',
;;    `bmkx-next-lighted-bookmark-other-window',
;;    `bmkx-next-lighted-bookmark-other-window-repeat',
;;    `bmkx-next-lighted-bookmark-repeat',
;;    `bmkx-next-local-file-bookmark',
;;    `bmkx-next-local-file-bookmark-other-window',
;;    `bmkx-next-local-file-bookmark-other-window-repeat',
;;    `bmkx-next-local-file-bookmark-repeat',
;;    `bmkx-next-man-bookmark', `bmkx-next-man-bookmark-other-window',
;;    `bmkx-next-man-bookmark-other-window-repeat',
;;    `bmkx-next-man-bookmark-repeat', `bmkx-next-non-file-bookmark',
;;    `bmkx-next-non-file-bookmark-other-window',
;;    `bmkx-next-non-file-bookmark-other-window-repeat',
;;    `bmkx-next-non-file-bookmark-repeat',
;;    `bmkx-next-remote-file-bookmark',
;;    `bmkx-next-remote-file-bookmark-other-window',
;;    `bmkx-next-remote-file-bookmark-other-window-repeat',
;;    `bmkx-next-remote-file-bookmark-repeat',
;;    `bmkx-next-specific-buffers-bookmark',
;;    `bmkx-next-specific-buffers-bookmark-other-window',
;;    `bmkx-next-specific-buffers-bookmark-other-window-repeat',
;;    `bmkx-next-specific-buffers-bookmark-repeat',
;;    `bmkx-next-specific-files-bookmark',
;;    `bmkx-next-specific-files-bookmark-other-window',
;;    `bmkx-next-specific-files-bookmark-other-window-repeat',
;;    `bmkx-next-specific-files-bookmark-repeat',
;;    `bmkx-next-variable-list-bookmark',
;;    `bmkx-next-variable-list-bookmark-other-window',
;;    `bmkx-next-variable-list-bookmark-other-window-repeat',
;;    `bmkx-next-variable-list-bookmark-repeat',
;;    `bmkx-next-url-bookmark', `bmkx-next-url-bookmark-other-window',
;;    `bmkx-next-url-bookmark-other-window-repeat',
;;    `bmkx-next-url-bookmark-repeat', `bmkx-next-bookmark-w32',
;;    `bmkx-next-bookmark-w32-other-window',
;;    `bmkx-next-bookmark-w32-other-window-repeat',
;;    `bmkx-next-bookmark-w32-repeat', `bmkx-non-dir-file-jump',
;;    `bmkx-non-dir-file-jump-other-window', `bmkx-non-file-jump',
;;    `bmkx-non-file-jump-other-window',
;;    `bmkx-occur-create-autonamed-bookmarks',
;;    `bmkx-occur-target-set',
;;    `bmkx-occur-target-set-all', `bmkx-paste-add-tags',
;;    `bmkx-paste-replace-tags', `bmkx-previous-autonamed-bookmark',
;;    `bmkx-previous-autonamed-bookmark-other-window',
;;    `bmkx-previous-autonamed-bookmark-other-window-repeat',
;;    `bmkx-previous-autonamed-bookmark-repeat',
;;    `bmkx-previous-bookmark',
;;    `bmkx-previous-bookmark-list-bookmark',
;;    `bmkx-previous-bookmark-list-bookmark-other-window',
;;    `bmkx-previous-bookmark-list-bookmark-other-window-repeat',
;;    `bmkx-previous-bookmark-list-bookmark-repeat',
;;    `bmkx-previous-bookmark-list-repeat',
;;    `bmkx-previous-bookmark-other-window',
;;    `bmkx-previous-bookmark-other-window-repeat',
;;    `bmkx-previous-bookmark-repeat',
;;    `bmkx-previous-bookmark-this-buffer',
;;    `bmkx-previous-bookmark-this-buffer-other-window',
;;    `bmkx-previous-bookmark-this-buffer-other-window-repeat',
;;    `bmkx-previous-bookmark-this-buffer-repeat',
;;    `bmkx-previous-bookmark-this-file',
;;    `bmkx-previous-bookmark-this-file/buffer',
;;    `bmkx-previous-bookmark-this-file/buffer-other-window',
;;    `bmkx-previous-bookmark-this-file/buffer-other-window-repeat',
;;    `bmkx-previous-bookmark-this-file/buffer-repeat',
;;    `bmkx-previous-bookmark-this-file-other-window',
;;    `bmkx-previous-bookmark-this-file-other-window-repeat',
;;    `bmkx-previous-bookmark-this-file-repeat',
;;    `bmkx-previous-desktop-bookmark',
;;    `bmkx-previous-desktop-bookmark-other-window',
;;    `bmkx-previous-desktop-bookmark-other-window-repeat',
;;    `bmkx-previous-desktop-bookmark-repeat',
;;    `bmkx-previous-dired-bookmark',
;;    `bmkx-previous-dired-bookmark-other-window',
;;    `bmkx-previous-dired-bookmark-other-window-repeat',
;;    `bmkx-previous-dired-bookmark-repeat',
;;    `bmkx-previous-eww-bookmark',
;;    `bmkx-previous-eww-bookmark-other-window',
;;    `bmkx-previous-eww-bookmark-other-window-repeat',
;;    `bmkx-previous-eww-bookmark-repeat',
;;    `bmkx-previous-file-bookmark',
;;    `bmkx-previous-file-bookmark-other-window',
;;    `bmkx-previous-file-bookmark-other-window-repeat',
;;    `bmkx-previous-file-bookmark-repeat',
;;    `bmkx-previous-gnus-bookmark',
;;    `bmkx-previous-gnus-bookmark-other-window',
;;    `bmkx-previous-gnus-bookmark-other-window-repeat',
;;    `bmkx-previous-gnus-bookmark-repeat',
;;    `bmkx-previous-info-bookmark',
;;    `bmkx-previous-info-bookmark-other-window',
;;    `bmkx-previous-info-bookmark-other-window-repeat',
;;    `bmkx-previous-info-bookmark-repeat',
;;    `bmkx-previous-lighted-bookmark',
;;    `bmkx-previous-lighted-bookmark-other-window',
;;    `bmkx-previous-lighted-bookmark-other-window-repeat',
;;    `bmkx-previous-lighted-bookmark-repeat',
;;    `bmkx-previous-local-file-bookmark',
;;    `bmkx-previous-local-file-bookmark-other-window',
;;    `bmkx-previous-local-file-bookmark-other-window-repeat',
;;    `bmkx-previous-local-file-bookmark-repeat',
;;    `bmkx-previous-man-bookmark',
;;    `bmkx-previous-man-bookmark-other-window',
;;    `bmkx-previous-man-bookmark-other-window-repeat',
;;    `bmkx-previous-man-bookmark-repeat',
;;    `bmkx-previous-non-file-bookmark',
;;    `bmkx-previous-non-file-bookmark-other-window',
;;    `bmkx-previous-non-file-bookmark-other-window-repeat',
;;    `bmkx-previous-non-file-bookmark-repeat',
;;    `bmkx-previous-remote-file-bookmark',
;;    `bmkx-previous-remote-file-bookmark-other-window',
;;    `bmkx-previous-remote-file-bookmark-other-window-repeat',
;;    `bmkx-previous-remote-file-bookmark-repeat',
;;    `bmkx-previous-specific-buffers-bookmark',
;;    `bmkx-previous-specific-buffers-bookmark-other-window',
;;    `bmkx-previous-specific-buffers-bookmark-other-window-repeat',
;;    `bmkx-previous-specific-buffers-bookmark-repeat',
;;    `bmkx-previous-specific-files-bookmark',
;;    `bmkx-previous-specific-files-bookmark-other-window',
;;    `bmkx-previous-specific-files-bookmark-other-window-repeat',
;;    `bmkx-previous-specific-files-bookmark-repeat',
;;    `bmkx-previous-variable-list-bookmark',
;;    `bmkx-previous-variable-list-bookmark-other-window',
;;    `bmkx-previous-variable-list-bookmark-other-window-repeat',
;;    `bmkx-previous-variable-list-bookmark-repeat',
;;    `bmkx-previous-url-bookmark',
;;    `bmkx-previous-url-bookmark-other-window',
;;    `bmkx-previous-url-bookmark-other-window-repeat',
;;    `bmkx-previous-url-bookmark-repeat',
;;    `bmkx-previous-bookmark-w32',
;;    `bmkx-previous-bookmark-w32-other-window',
;;    `bmkx-previous-bookmark-w32-other-window-repeat',
;;    `bmkx-previous-bookmark-w32-repeat',
;;    `bmkx-purge-notags-autofiles', `bmkx-read-bookmark-for-type',
;;    `bmkx-region-jump',
;;    `bmkx-region-jump-narrow-indirect-other-window',
;;    `bmkx-region-jump-other-window', `bmkx-remote-file-jump',
;;    `bmkx-remote-file-jump-other-window',
;;    `bmkx-remote-non-dir-file-jump',
;;    `bmkx-temote-non-dir-file-jump-other-window',
;;    `bmkx-remove-all-tags', `bmkx-remove-tags',
;;    `bmkx-remove-tags-from-all', `bmkx-rename-tag',
;;    `bmkx-revert-bookmark-file',
;;    `bmkx-save-bookmarks-this-file/buffer',
;;    `bmkx-save-menu-list-state', `bmkx-send-bug-report',
;;    `bmkx-set-autonamed-bookmark',
;;    `bmkx-set-autonamed-bookmark-at-line',
;;    `bmkx-set-autonamed-regexp-buffer',
;;    `bmkx-set-autonamed-regexp-region',
;;    `bmkx-set-bookmark-file-bookmark', `bmkx-set-desktop-bookmark',
;;    `bmkx-set-dired-bookmark-for-files',
;;    `bmkx-set-eww-bookmark-here' (Emacs 25+),
;;    `bmkx-set-grep-command-bookmark' (Emacs 26+),
;;    `bmkx-set-info-bookmark-with-node-name' (Emacs 22+),
;;    `bmkx-set-izones-bookmark', `bmkx-set-kmacro-bookmark' (Emacs
;;    22+), `bmkx-set-kmacro-list-bookmark' (Emacs 22+),
;;    `bmkx-set-sequence-bookmark', `bmkx-set-snippet-bookmark',
;;    `bmkx-set-tag-value', `bmkx-set-tag-value-for-navlist',
;;    `bmkx-set-variable-list-bookmark',
;;    `bmkx-show-this-annotation-read-only',
;;    `bmkx-snippet-to-kill-ring', `bmkx-some-tags-jump',
;;    `bmkx-some-tags-jump-other-window',
;;    `bmkx-some-tags-regexp-jump',
;;    `bmkx-some-tags-regexp-jump-other-window',
;;    `bmkx-specific-buffers-jump',
;;    `bmkx-specific-buffers-jump-other-window',
;;    `bmkx-specific-files-jump',
;;    `bmkx-specific-files-jump-other-window', `bmkx-store-org-link'
;;    (Emacs 24.4+), `bmkx-switch-bookmark-file',
;;    `bmkx-switch-bookmark-file-create',
;;    `bmkx-switch-to-bookmark-file-this-file/buffer',
;;    `bmkx-switch-to-last-bookmark-file', `bmkx-tag-a-file',
;;    `bmkx-temporary-bookmarking-mode', `bmkx-temporary-jump',
;;    `bmkx-temporary-jump-other-window',
;;    `bmkx-this-buffer-bmenu-list', `bmkx-this-buffer-jump',
;;    `bmkx-this-buffer-jump-other-window',
;;    `bmkx-this-file-bmenu-list', `bmkx-this-file/buffer-bmenu-list',
;;    `bmkx-toggle-autonamed-bmkx-set/delete',
;;    `bmkx-toggle-autotemp-on-set',
;;    `bmkx-toggle-bookmark-set-refreshes',
;;    `bmkx-toggle-eww-auto-type' (Emacs 25+),
;;    `bmkx-toggle-info-auto-type' (Emacs 22+),
;;    `bmkx-toggle-saving-bookmark-file',
;;    `bmkx-toggle-saving-menu-list-state',
;;    `bmkx-toggle-temporary-bookmark',
;;    `bmkx-turn-on-automatic-bookmark-mode' (Emacs 21+),
;;    `bmkx-types-alist', `bmkx-unomit-all', `bmkx-untag-a-file',
;;    `bmkx-url-target-set', `bmkx-url-jump',
;;    `bmkx-url-jump-other-window', `bmkx-variable-list-jump',
;;    `bmkx-version', `bmkx-visit-external-annotation',
;;    `bmkx-w32-browser-jump', `bmkx-w3m-jump',
;;    `bmkx-w3m-jump-other-window',
;;    `bmkx-wrap-bookmark-with-last-kbd-macro'.
;;
;;  User options defined here:
;;
;;    `bmkx-annotation-modes-inherit-from', `bmkx-autofile-filecache',
;;    `bmkx-automatic-bookmark-min-distance',
;;    `bmkx-automatic-bookmark-mode-delay',
;;    `bmkx-automatic-bookmark-mode-lighter',
;;    `bmkx-automatic-bookmark-set-function',
;;    `bmkx-autoname-bookmark-function', `bmkx-autoname-format',
;;    `bmkx-autotemp-bookmark-predicates',
;;    `bmkx-bookmark-name-length-max',
;;    `bmkx-count-multi-mods-as-one-flag', `bmkx-highlight-on-jump-flag',
;;    `bmkx-default-bookmark-name',
;;    `bmkx-default-handlers-for-file-types',
;;    `bmkx-desktop-default-directory',
;;    `bmkx-desktop-jump-save-before-flag',
;;    `bmkx-desktop-no-save-vars', `bmkx-eww-auto-type' (Emacs 25+),
;;    `bmkx-eww-buffer-renaming' (Emacs 25+),
;;    `bmkx-eww-generate-buffer-flag' (Emacs 25+),
;;    `bmkx-eww-replace-keys-flag' (Emacs 25+),
;;    `bmkx-guess-default-handler-for-file-flag',
;;    `bmkx-handle-region-function', `bmkx-incremental-filter-delay',
;;    `bmkx-info-auto-type' (Emacs 22+),
;;    `bmkx-info-sort-ignores-directories-flag',
;;    `bmkx-last-as-first-bookmark-file',
;;    `bmkx-menu-popup-max-length', `bmkx-new-bookmark-default-names',
;;    `bmkx-other-window-pop-to-flag', `bmkx-prompt-for-tags-flag',
;;    `bmkx-properties-to-keep', `bmkx-read-bookmark-file-hook',
;;    `bmkx-region-search-size', `bmkx-save-new-location-flag',
;;    `bmkx-sequence-jump-display-function',
;;    `bmkx-show-end-of-region-flag', `bmkx-sort-comparer',
;;    `bmkx-su-or-sudo-regexp', `bmkx-tags-for-completion',
;;    `bmkx-temporary-bookmarking-mode',
;;    `bmkx-temporary-bookmarking-mode-hook',
;;    `bmkx-temporary-bookmarking-mode-lighter',
;;    `bmkx-this-file/buffer-cycle-sort-comparer', `bmkx-use-region',
;;    `bmkx-w3m-allow-multiple-buffers-flag',
;;    `bmkx-write-bookmark-file-hook'.
;;
;;  Non-interactive functions defined here:
;;
;;    `bmkext-jump-gnus', `bmkext-jump-man', `bmkext-jump-w3m',
;;    `bmkext-jump-woman', `bmkx-add-jump-to-list-button',
;;    `bmkx-all-exif-data', `bmkx-all-tags-alist-only',
;;    `bmkx-all-tags-regexp-alist-only', `bmkx-alpha-cp',
;;    `bmkx-alpha-p', `bmkx-annotated-alist-only',
;;    `bmkx-annotated-bookmark-p', `bmkx-annotated-cp',
;;    `bmkx-annotation-or-bookmark-description',
;;    `bmkx-autofile-alist-only', `bmkx-autofile-all-tags-alist-only',
;;    `bmkx-autofile-all-tags-regexp-alist-only',
;;    `bmkx-autofile-bookmark-p',
;;    `bmkx-autofile-some-tags-alist-only',
;;    `bmkx-autofile-some-tags-regexp-alist-only',
;;    `bmkx-autoname-bookmark-function-default',
;;    `bmkx-autonamed-alist-only',
;;    `bmkx-autonamed-bookmark-for-buffer-p',
;;    `bmkx-autonamed-bookmark-p',
;;    `bmkx-autonamed-this-buffer-alist-only',
;;    `bmkx-autonamed-this-buffer-bookmark-p',
;;    `bmkx-bookmark-creation-cp', `bmkx-bookmark-data-from-record',
;;    `bmkx-bookmark-description', `bmkx-bookmark-last-access-cp',
;;    `bmkx-bookmark-file-alist-only',
;;    `bmkx-bookmark-file-bookmark-p',
;;    `bmkx-bookmark-list-alist-only',
;;    `bmkx-bookmark-list-bookmark-p', `bmkx-bookmark-name-member',
;;    `bmkx-bookmark-record-from-name', `bmkx-buffer-alist-only',
;;    `bmkx-buffer-last-access-cp', `bmkx-buffer-names',
;;    `bmkx-compilation-file+line-at', `bmkx-completing-read-1',
;;    `bmkx-completing-read-bookmarks',
;;    `bmkx-completing-read-buffer-name',
;;    `bmkx-completing-read-file-name', `bmkx-completing-read-lax',
;;    `bmkx-cp-not', `bmkx-create-variable-list-bookmark',
;;    `bmkx-current-bookmark-list-state', `bmkx-current-sort-order',
;;    `bmkx-cycle-1', `bmkx-default-bookmark-file',
;;    `bmkx-default-bookmark-name', `bmkx-default-handler-for-file',
;;    `bmkx-default-handler-user', `bmkx-delete-autonamed-no-confirm',
;;    `bmkx-delete-autonamed-this-buffer-no-confirm',
;;    `bmkx-delete-bookmark-name-from-list',
;;    `bmkx-delete-temporary-no-confirm', `bmkx-desktop-alist-only',
;;    `bmkx-desktop-bookmark-p',
;;    `bmkx-desktop-file-p',`bmkx-desktop-kill', `bmkx-desktop-save',
;;    `bmkx-desktop-save-as-last', `bmkx-dired-alist-only',
;;    `bmkx-dired-bookmark-p', `bmkx-dired-subdirs',
;;    `bmkx-dired-this-dir-alist-only',
;;    `bmkx-dired-wildcards-alist-only',
;;    `bmkx-dired-this-dir-bookmark-p',
;;    `bmkx-dired-wildcards-bookmark-p',
;;    `bmkx-edit-bookmark-record-mode',
;;    `bmkx-edit-bookmark-records-mode', `bmkx-edit-tags-mode',
;;    `bmkx-end-position-post-context',
;;    `bmkx-end-position-pre-context', `bmkx-every',
;;    `bmkx-eww-alist-only' (Emacs 25+), `bmkx-eww-bookmark-p' (Emacs
;;    25+), `bmkx-eww-cp' (Emacs 25+), `bmkx-eww-new-buffer-name'
;;    (Emacs 25+), `bmkx-eww-rename-buffer' (Emacs 25+),
;;    `bmkx-eww-title' (Emacs 25+), `bmkx-eww-url' (Emacs 25+),
;;    `bmkx-ffap-guesser', `bmkx-file-alist-only',
;;    `bmkx-file-all-tags-alist-only',
;;    `bmkx-file-all-tags-regexp-alist-only', `bmkx-file-alpha-cp',
;;    `bmkx-file-attribute-0-cp', `bmkx-file-attribute-1-cp',
;;    `bmkx-file-attribute-2-cp', `bmkx-file-attribute-3-cp',
;;    `bmkx-file-attribute-4-cp', `bmkx-file-attribute-5-cp',
;;    `bmkx-file-attribute-6-cp', `bmkx-file-attribute-7-cp',
;;    `bmkx-file-attribute-8-cp', `bmkx-file-attribute-9-cp',
;;    `bmkx-file-attribute-10-cp', `bmkx-file-attribute-11-cp',
;;    `bmkx-file-bookmark-p', `bmkx-file-names', `bmkx-file-remote-p',
;;    `bmkx-file-some-tags-alist-only',
;;    `bmkx-file-some-tags-regexp-alist-only',
;;    `bmkx-file-this-dir-alist-only',
;;    `bmkx-file-this-dir-all-tags-alist-only',
;;    `bmkx-file-this-dir-all-tags-regexp-alist-only',
;;    `bmkx-file-this-dir-bookmark-p',
;;    `bmkx-file-this-dir-some-tags-alist-only',
;;    `bmkx-file-this-dir-some-tags-regexp-alist-only',
;;    `bmkx-find-tag-default-as-regexp' (Emacs 22-24.2),
;;    `bmkx-flagged-bookmark-p', `bmkx-flagged-cp', `bmkx-float-time',
;;    `bmkx-format-spec', `bmkx-full-tag', `bmkx-function-alist-only',
;;    `bmkx-function-bookmark-p', `bmkx-get-autofile-bookmark',
;;    `bmkx-get-bookmark', `bmkx-get-bookmark-in-alist',
;;    `bmkx-get-buffer-name', `bmkx-get-end-position',
;;    `bmkx-get-tag-value', `bmkx-get-tags', `bmkx-get-visit-time',
;;    `bmkx-get-visits-count', `bmkx-gnus-alist-only',
;;    `bmkx-gnus-bookmark-p', `bmkx-gnus-cp', `bmkx-goto-position',
;;    `bmkx-handle-region-default',
;;    `bmkx-handle-region+narrow-indirect', `bmkx-handler-cp',
;;    `bmkx-handler-pred', `bmkx-has-tag-p',
;;    `bmkx-has-tags-alist-only', `bmkx-image-alist-only',
;;    `bmkx-image-bookmark-p', `bmkx-info-alist-only',
;;    `bmkx-info-bookmark-p', `bmkx-info-node-name-cp',
;;    `bmkx-info-position-cp', `bmkx-isearch-bookmarks' (Emacs 23+),
;;    `bmkx-isearch-bookmarks-regexp' (Emacs 23+),
;;    `bmkx-isearch-next-bookmark-buffer' (Emacs 23+), `bmkx-jump-1',
;;    `bmkx-jump-bookmark-file', `bmkx-jump-bookmark-list',
;;    `bmkx-jump-desktop', `bmkx-jump-dired', `bmkx-jump-eww' (Emacs
;;    25+), `bmkx-jump-function', `bmkx-jump-gnus',
;;    `bmkx-jump-kmacro-list' (Emacs 22+), `bmkx-jump-man',
;;    `bmkx-jump-sequence',
;;    `bmkx-jump-snippet', `bmkx-jump-url-browse',
;;    `bmkx-jump-variable-list', `bmkx-jump-w3m',
;;    `bmkx-jump-w3m-new-buffer', `bmkx-jump-w3m-new-buffer',
;;    `bmkx-jump-w3m-only-one-buffer',
;;    `bmkx-jump-w3m-only-one-buffer', `bmkx-jump-woman',
;;    `bmkx-kmacro-list-bookmark-p',
;;    `bmkx-last-specific-buffer-alist-only',
;;    `bmkx-last-specific-buffer-p',
;;    `bmkx-last-specific-file-alist-only',
;;    `bmkx-last-specific-file-p', `bmkx-list-position',
;;    `bmkx-local-directory-bookmark-p',
;;    `bmkx-local-file-accessed-more-recently-cp',
;;    `bmkx-local-file-alist-only', `bmkx-local-file-bookmark-p',
;;    `bmkx-local-file-size-cp', `bmkx-local-file-type-cp',
;;    `bmkx-local-non-dir-file-alist-only',
;;    `bmkx-local-non-dir-file-bookmark-p',
;;    `bmkx-local-file-updated-more-recently-cp',
;;    `bmkx-make-bookmark-file-record',
;;    `bmkx-make-bookmark-list-record', `bmkx-make-desktop-record',
;;    `bmkx-make-dired-record', `bmkx-make-eww-record' (Emacs 25+),
;;    `bmkx-make-gnus-record', `bmkx-make-kmacro-list-record' (Emacs 22+),
;;    `bmkx-make-man-record', `bmkx-make-obsolete',
;;    `bmkx-make-obsolete-variable',
;;    `bmkx-make-record-for-target-file', `bmkx-make-sequence-record',
;;    `bmkx-make-url-browse-record', `bmkx-make-variable-list-record',
;;    `bmkx-make-w3m-record', `bmkx-make-woman-record' (Emacs 21+),
;;    `bmkx-man-alist-only', `bmkx-man-bookmark-p',
;;    `bmkx-marked-bookmark-p', `bmkx-marked-bookmarks-only',
;;    `bmkx-marked-cp', `bmkx-maybe-save-bookmarks',
;;    `bmkx-modified-bookmark-p', `bmkx-modified-cp',
;;    `bmkx-msg-about-sort-order', `bmkx-multi-sort',
;;    `bmkx-names-same-bookmark-p', `bmkx-navlist-bookmark-p',
;;    `bmkx-new-bookmark-default-names',
;;    `bmkx-non-autonamed-alist-only', `bmkx-non-dir-file-alist-only',
;;    `bmkx-non-dir-file-bookmark-p', `bmkx-non-file-alist-only',
;;    `bmkx-non-file-bookmark-p', `bmkx-non-invokable-alist-only',
;;    `bmkx-non-invokable-bookmark-p',
;;    `bmkx-not-near-other-automatic-bmks', `bmkx-omitted-alist-only',
;;    `bmkx-orphaned-file-alist-only',
;;    `bmkx-orphaned-file-bookmark-p',
;;    `bmkx-orphaned-local-file-alist-only',
;;    `bmkx-orphaned-local-file-bookmark-p',
;;    `bmkx-orphaned-remote-file-alist-only',
;;    `bmkx-orphaned-remote-file-bookmark-p',
;;    `bmkx-pop-to-readable-marker', `bmkx-position-after-whitespace',
;;    `bmkx-position-before-whitespace', `bmkx-position-cp',
;;    `bmkx-position-post-context',
;;    `bmkx-position-post-context-region',
;;    `bmkx-position-pre-context', `bmkx-position-pre-context-region',
;;    `bmkx-printable-vars+vals', `bmkx-propertize',
;;    `bmkx-readable-p', `bmkx-read-bookmark-file-default',
;;    `bmkx-read-bookmark-file-name', `bmkx-read-buffers',
;;    `bmkx-read-files', `bmkx-read-from-whole-string',
;;    `bmkx-read-regexp', `bmkx-read-tag-completing',
;;    `bmkx-read-tags', `bmkx-read-tags-completing',
;;    `bmkx-read-variable', `bmkx-read-variables-completing',
;;    `bmkx-record-visit', `bmkx-refresh-latest-bookmark-list',
;;    `bmkx-refresh-menu-list', `bmkx-refresh/rebuild-menu-list',
;;    `bmkx-regexp-filtered-annotation-alist-only',
;;    `bmkx-regexp-filtered-bookmark-name-alist-only',
;;    `bmkx-regexp-filtered-file-name-alist-only',
;;    `bmkx-regexp-filtered-tags-alist-only',
;;    `bmkx-region-alist-only', `bmkx-region-bookmark-p',
;;    `bmkx-remote-file-alist-only', `bmkx-remote-file-bookmark-p',
;;    `bmkx-remote-non-dir-file-alist-only',
;;    `bmkx-remote-non-dir-file-bookmark-p', `bmkx-remove-dups',
;;    `bmkx-remove-if', `bmkx-remove-if-not', `bmkx-remove-omitted',
;;    `bmkx-rename-for-marked-and-omitted-lists',
;;    `bmkx-repeat-command', `bmkx-replace-existing-bookmark',
;;    `bmkx-reset-bmkx-store-org-link-checking-p' (Emacs 24.4+),
;;    `bmkx-root-or-sudo-logged-p', `bmkx-same-creation-time-p',
;;    `bmkx-same-file-p', `bmkx-save-new-region-location',
;;    `bmkx-select-buffer-other-window', `bmkx-sequence-alist-only',
;;    `bmkx-sequence-bookmark-p', `bmkx-set-automatic-bookmark',
;;    `bmkx-set-tag-value-for-bookmarks', `bmkx-set-union',
;;    `bmkx-snippet-alist-only', `bmkx-snippet-bookmark-p',
;;    `bmkx-some', `bmkx-some-marked-p', `bmkx-some-tags-alist-only',
;;    `bmkx-some-tags-regexp-alist-only', `bmkx-some-unmarked-p',
;;    `bmkx-sorting-description', `bmkx-sort-omit', `bmkx-sound-jump',
;;    `bmkx-specific-buffers-alist-only',
;;    `bmkx-specific-files-alist-only', `bmkx-store-org-link-1',
;;    `bmkx-string-less-case-fold-p', `bmkx-tagged-alist-only',
;;    `bmkx-tagged-bookmark-p', `bmkx-tagged-cp', `bmkx-tag-name',
;;    `bmkx-tags-in-bookmark-file', `bmkx-tags-list',
;;    `bmkx-temporary-alist-only', `bmkx-temporary-bookmark-p',
;;    `bmkx-thing-at-point', `bmkx-this-buffer-alist-only',
;;    `bmkx-this-buffer-p', `bmkx-this-file-alist-only',
;;    `bmkx-this-file/buffer-alist-only', `bmkx-this-file-p',
;;    `bmkx-unmarked-bookmarks-only', `bmkx-unpropertized-string',
;;    `bmkx-untagged-alist-only', `bmkx-upcase',
;;    `bmkx-update-autonamed-bookmark', `bmkx-url-alist-only',
;;    `bmkx-url-bookmark-p', `bmkx-url-browse-alist-only',
;;    `bmkx-url-browse-bookmark-p', `bmkx-url-cp',
;;    `bmkx-variable-list-alist-only',
;;    `bmkx-variable-list-bookmark-p', `bmkx-visited-more-often-cp',
;;    `bmkx-visited-more-recently-cp', `bmkx-w3m-alist-only',
;;    `bmkx-w3m-bookmark-p', `bmkx-w3m-cp',
;;    `bmkx-w3m-set-new-buffer-name',
;;    `bmkx-write-alist-bookmarks-to-file'.
;;
;;  Internal variables defined here:
;;
;;    `bmkx-after-set-hook', `bmkx-autofile-history',
;;    `bmkx-automatic-bookmark-mode-timer',
;;    `bmkx-automatic-bookmarks', `bmkx-autonamed-history',
;;    `bmkx-autotemp-all-when-set-p', `bmkx-before-jump-hook',
;;    `bmkx-bookmark-file-history', `bmkx-bookmark-list-history',
;;    `bmkx-bookmark-set-confirms-overwrite-p',
;;    `bmkx-buffer-bookmark-p', `bmkx-current-bookmark-file',
;;    `bmkx-current-nav-bookmark', `bmkx-desktop-current-file',
;;    `bmkx-desktop-history', `bmkx-dired-history',
;;    `bmkx-edit-bookmark-record-mode-map',
;;    `bmkx-edit-bookmark-records-mode-map',
;;    `bmkx-edit-bookmark-records-number', `bmkx-edit-tags-mode-map',
;;    `bmkx-eww-history' (Emacs 25+), `bmkx-eww-jumping-p' (Emacs
;;    25+), `bmkx-eww-new-buf-name' (Emacs 25+),
;;    `bmkx-file-bookmark-handlers', `bmkx-file-history',
;;    `bmkx-gnus-history', `bmkx-image-history', `bmkx-info-history',
;;    `bmkx-isearch-bookmarks' (Emacs 23+),
;;    `bmkx-jump-display-function', `bmkx-jump-other-window-map',
;;    `bmkx-last-bmenu-state-file', `bmkx-last-bookmark-file',
;;    `bmkx-last-save-flag-value', `bmkx-last-specific-buffer',
;;    `bmkx-last-specific-file', `bmkx-latest-bookmark-alist',
;;    `bmkx-local-file-history', `bmkx-man-history',
;;    `bmkx-modified-bookmarks', `bmkx-nav-alist',
;;    `bmkx-non-file-filename', `bmkx-non-file-history',
;;    `bmkx-region-history', `bmkx-remote-file-history',
;;    `bmkx-return-buffer', `bmkx-reverse-multi-sort-p',
;;    `bmkx-reverse-sort-p', `bmkx-snippet-history',
;;    `bmkx-sorted-alist', `bmkx-specific-buffers-history',
;;    `bmkx-specific-files-history', `bmkx-store-org-link-checking-p',
;;    `bmkx-tag-history', `bmkx-tags-alist', `bmkx-temporary-history',
;;    `bmkx-url-history', `bmkx-use-w32-browser-p',
;;    `bmkx-variable-list-history', `bmkx-version-number',
;;    `bmkx-w3m-history'.
;;
;;
;;  ***** NOTE: The following commands defined in `bookmark.el'
;;              have been REDEFINED HERE:
;;
;;    `bmkx-default-annotation-text', `bmkx-delete',
;;    `bmkx-edit-annotation-mode', `bmkx-insert',
;;    `bmkx-insert-annotation',
;;    `bmkx-insert-current-bookmark', `bmkx-insert-location',
;;    `bmkx-jump', `bmkx-jump-other-frame',
;;    `bmkx-jump-other-window', `bmkx-load',
;;    `bmkx-relocate', `bmkx-rename', `bmkx-save',
;;    `bmkx-send-edited-annotation', `bmkx-set',
;;    `bmkx-set-name', `bmkx-yank-word'.
;;
;;
;;  ***** NOTE: The following user options defined in `bookmark.el'
;;              have been REDEFINED HERE:
;;
;;    `bookmark-automatically-show-annotations', `bookmark-sort-flag'
;;    (document non-use), `bookmark-version-control'.
;;
;;
;;  ***** NOTE: The following non-interactive functions defined in
;;              `bookmark.el' have been REDEFINED HERE:
;;
;;    `bmkx--jump-via', `bmkx-alist-from-buffer',
;;    `bmkx-all-names', `bmkx-completing-read',
;;    `bmkx-default-handler', `bmkx-edit-annotation' (command
;;    here), `bmkx-exit-hook-internal', `bookmark-get-bookmark',
;;    `bookmark-get-bookmark-record' (Emacs 20-22),
;;    `bookmark-get-handler' (Emacs 20-22),
;;    `bmkx-handle-bookmark', `bmkx-import-new-list',
;;    `bookmark-jump-noselect' (Emacs 20-22), `bmkx-location',
;;    `bmkx-make-record', `bmkx-make-record-default',
;;    `bmkx-maybe-load-default-file', `bmkx-maybe-rename',
;;    `bookmark-prop-get' (Emacs 20-22), `bmkx-prop-set',
;;    `bmkx-show-annotation' (command here),
;;    `bmkx-show-all-annotations' (command here), `bmkx-store'
;;    (Emacs 20-22), `bmkx-write-file'.
;;
;;
;;  ***** NOTE: The following internal variables defined in
;;              `bookmark.el' have been REDEFINED HERE:
;;
;;    `bookmark-alist' (doc string only),
;;    `bookmark-make-record-function' (Emacs 20-22),
;;
;;
;;  ***** NOTE: The following function defined in `info.el'
;;              has been REDEFINED HERE:
;;
;;    `Info-bmkx-make-record' (Emacs 20-22).
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

 ;; ffap-file-remote-p
(eval-when-compile (require 'gnus)) ;; mail-header-id (really in `nnheader.el')
(eval-when-compile (require 'gnus-sum)) ;; gnus-summary-article-header

(eval-when-compile (unless (require 'cl-lib nil t)
                     (require 'cl)
                     (defalias 'cl-case                'case)
                     (defalias 'cl-loop                'loop)
                     (defalias 'cl-multiple-value-bind 'multiple-value-bind)
                     (defalias 'cl-typecase            'typecase)))

;; Replacements for the few `thingatpt+.el' helpers bookmark-x relied on.
;; The originals scanned outward from point for the nearest symbol; built-in
;; `symbol-at-point' returns nil if the cursor is not literally on one.

(defcustom bmkx-near-point-distance 2000
  "Max number of characters to search away from point for the nearest symbol.
Used by `bmkx-symbol-nearest-point' and
`bmkx-region-or-symbol-name-nearest-point'."
  :type 'integer :group 'bookmark-plus)

(defun bmkx-symbol-nearest-point ()
  "Return the symbol nearest to point, or nil if none within range.
The symbol at point is preferred.  Otherwise scan up to
`bmkx-near-point-distance' characters in either direction and return
whichever symbol is closer."
  (or (symbol-at-point)
      (let* ((p       (point))
             (lo      (max (point-min) (- p bmkx-near-point-distance)))
             (hi      (min (point-max) (+ p bmkx-near-point-distance)))
             (rx      "\\_<\\(?:\\sw\\|\\s_\\)+\\_>")
             (before  (save-excursion
                        (and (re-search-backward rx lo t)
                             (cons (- p (match-end 0))
                                   (intern-soft (match-string-no-properties 0))))))
             (after   (save-excursion
                        (and (re-search-forward rx hi t)
                             (cons (- (match-beginning 0) p)
                                   (intern-soft (match-string-no-properties 0)))))))
        (cond ((and before after) (if (< (car before) (car after)) (cdr before) (cdr after)))
              (before              (cdr before))
              (after               (cdr after))))))

(defcustom bmkx-non-textual-modes
  '(image-mode doc-view-mode pdf-view-mode archive-mode hexl-mode)
  "Major modes whose buffer contents are not meaningful text.
`bmkx-region-or-symbol-name-nearest-point' returns nil in these
modes so a new bookmark's default name falls through to the file
or buffer name instead of a garbled \"symbol\" pulled from raw
bytes."
  :type '(repeat symbol) :group 'bookmark-plus)

(defun bmkx-region-or-symbol-name-nearest-point ()
  "Return active region content (if non-empty) or nearest symbol's name.
Returns nil if neither is available, or if the current major mode
is in `bmkx-non-textual-modes' (image, PDF, archive, ...) where
the bytes around point are not meaningful as a word."
  (cond
   ((use-region-p)
    (let ((s  (buffer-substring-no-properties (region-beginning) (region-end))))
      (and (not (string-empty-p s)) s)))
   ((apply #'derived-mode-p bmkx-non-textual-modes)
    nil)
   (t
    (let ((sym  (bmkx-symbol-nearest-point)))
      (and sym (symbol-name sym))))))

(require 'font-lock+ nil t)             ; font-lock-ignore (text property)

(require 'bookmark)
;; bookmark-alist, bookmark-alist-modification-count, bookmark-annotation-name,
;; bookmark-automatically-show-annotations, bmkx-list-bookmark,
;; bmkx-list-surreptitiously-rebuild-list, bookmark-buffer-file-name, bookmark-buffer-name,
;; bookmark-completion-ignore-case, bookmark-current-bookmark, bookmark-default-file,
;; bmkx-edit-annotation, bookmark-get-annotation, bookmark-get-bookmark, bookmark-get-bookmark-record,
;; bookmark-get-filename, bookmark-get-front-context-string, bookmark-get-handler, bookmark-get-position,
;; bookmark-get-rear-context-string, bookmark-insert-file-format-version-stamp, bookmark-kill-line,
;; bmkx-make-record, bookmark-maybe-historicize-string, bookmark-maybe-upgrade-file-format,
;; bookmark-menu-popup-paned-menu, bookmark-name-from-full-record, bookmark-name-from-record,
;; bookmark-prop-get, bookmark-save-flag, bookmark-search-size,
;; bookmark-set-annotation, bookmark-set-filename, bookmark-set-position, bookmark-time-to-save-p,
;; bookmark-use-annotations, bookmark-yank-point


;; Some general Renamings.
;;
;; 1. Fix incompatibility introduced by gratuitous Emacs name change.
;;
(cond ((and (fboundp 'bookmark-name-from-record)  (not (fboundp 'bookmark-name-from-full-record)))
       (defalias 'bookmark-name-from-full-record 'bookmark-name-from-record))
      ((and (fboundp 'bookmark-name-from-full-record)  (not (fboundp 'bookmark-name-from-record)))
       (defalias 'bookmark-name-from-record 'bookmark-name-from-full-record)))

;; 2. The built-in name of the first is misleading, as it returns only the cdr of the record.
;;    The second is for consistency.
;;
(defalias 'bmkx-bookmark-data-from-record 'bookmark-get-bookmark-record)
(defalias 'bmkx-bookmark-name-from-record 'bookmark-name-from-full-record)

;; 3. Thin wrappers around the standard obsoletion functions, kept for caller
;;    convenience.  The pre-Emacs-23 compatibility branches were removed when
;;    this fork dropped support for Emacs < 30.
;;
(defun bmkx-make-obsolete (obsolete-name current-name &optional when)
  "Same as `make-obsolete'."
  (make-obsolete obsolete-name current-name when))

(defun bmkx-make-obsolete-variable (obsolete-name current-name &optional when access-type)
  "Same as `make-obsolete-variable'."
  (make-obsolete-variable obsolete-name current-name when access-type))

(eval-when-compile
 (or (condition-case nil
         (load-library "bookmark-x-mac") ; Use load-library to ensure latest .elc.
       (error nil))
     (require 'bookmark-x-mac)))         ; Require, so can load separately if not on `load-path'.
;; bmkx-define-cycle-command, bmkx-define-file-sort-predicate, bmkx-define-next+prev-cycle-commands,
;; bmkx-with-help-window, bmkx-with-output-to-plain-temp-buffer

;; Forward declarations for symbols defined in `bookmark-x-bmu.el' are placed
;; in the "Quiet the byte-compiler" block below.  The previous
;; (eval-when-compile (require 'bookmark-x-bmu)) caused a load-time cycle
;; once `bookmark-x-bmu.el' was changed to (require 'bookmark-x-1).


;; (eval-when-compile (require 'bookmark-x-lit nil t))
;; bmkx-light-bookmark, bmkx-light-bookmarks, bmkx-light-this-buffer


;; For the redefinition of `bookmark-get-bookmark'.
(provide 'bookmark-x-1)                  ; Ensure this library is loaded before we compile it.
(require 'bookmark-x-1)                  ; So be sure to put this library in your `load-path' before
                                        ; trying to byte-compile it.

;;;;;;;;;;;;;;;;;;;;;;;

;; Quiet the byte-compiler

(defvar bmkx-auto-light-when-set)       ; In `bookmark-x-lit.el'
(defvar bmkx-auto-light-when-jump)      ; In `bookmark-x-lit.el'
(defvar bmkx-bmenu-buffer)              ; In `bookmark-x.el'
(defvar bmkx-edit-bookmark-record-mode-map) ; Here, via `define-derived-mode'
(defvar bmkx-edit-bookmark-records-mode-map) ; Here, via `define-derived-mode'
(defvar bmkx-edit-tags-mode-map)        ; Here, via `define-derived-mode'
;; Obsolete-variable aliases for the two renamed EWW defcustoms.  These
;; must be declared before the referent (i.e. before the forward defvar
;; below as well as the actual defcustom much later in the file) so the
;; byte-compiler does not emit "Alias should be declared before its
;; referent" warnings.
(defvaralias 'bmkx-eww-buffer-handling 'bmkx-eww-buffer-renaming)
(bmkx-make-obsolete-variable 'bmkx-eww-buffer-handling 'bmkx-eww-buffer-renaming "2018-02-23")
(defvaralias 'bmkx-replace-eww-keys-flag 'bmkx-eww-replace-keys-flag)
(bmkx-make-obsolete-variable 'bmkx-replace-eww-keys-flag 'bmkx-eww-replace-keys-flag "2017-01-10")

(defvar bmkx-eww-auto-type)             ; Defined later, if EWW is available.
(defvar bmkx-eww-buffer-renaming)       ; Defined later, if EWW is available.
(defvar bmkx-eww-generate-buffer-flag)  ; Defined later, if EWW is available.
(defvar bmkx-eww-jumping-p)             ; Defined later, if EWW is available.
(defvar bmkx-eww-new-buf-name)          ; Defined later, if EWW is available.
(defvar bmkx-eww-replace-keys-flag)     ; Defined later, if EWW is available.
(defvar bmkx-info-auto-type)            ; Here (Emacs 22+)
(defvar bmkx-light-priorities)          ; In `bookmark-x-lit.el'
(defvar bmkx-setting-automatic-bmk-p)   ; Here, bound in `bmkx-set-automatic-bookmark'.
(defvar bmkx-temporary-bookmarking-mode) ;  Here
(defvar bmkx-global-automatic-bookmark-mode) ; Here, via `define-globalized-minor-mode'
(defvar bookmark-current-point)         ; In `bookmark.el', but not in Emacs 23+
(defvar bookmark-edit-annotation-text-func) ; In `bookmark.el'
(defvar bookmark-file-coding-system)    ; In `bookmark.el' (Emacs 25.2+)
(defvar bookmark-read-annotation-text-func) ; In `bookmark.el', but not in Emacs 23+
(defvar bookmark-make-record-function)  ; In `bookmark.el'
(defvar bookmark-set-fringe-mark)       ; In `bookmark.el' (Emacs 28+)
(defvar cl-print-readably)              ; In `cl-print.el'
(defvar desktop-basefilename)           ; In `desktop.el' (Emacs < 22)
(defvar desktop-base-file-name)         ; In `desktop.el'
(defvar desktop-buffer-args-list)       ; In `desktop.el'
(defvar desktop-delay-hook)             ; In `desktop.el'
(defvar desktop-dirname)                ; In `desktop.el'
(defvar desktop-file-modtime)           ; In `desktop.el'
(defvar desktop-globals-to-save)        ; In `desktop.el'
(defvar desktop-restore-eager)          ; In `desktop.el'
(defvar desktop-save-mode)              ; In `desktop.el'
(defvar desktop-save)                   ; In `desktop.el'
(defvar dired-actual-switches)          ; In `dired.el'
(defvar dired-buffers)                  ; In `dired.el'
(defvar dired-directory)                ; In `dired.el'
(defvar dired-guess-shell-case-fold-search) ; In `dired-x.el'
(defvar dired-subdir-alist)             ; In `dired.el'
(defvar eww-data)                       ; In `eww.el' (Emacs 25+)
(defvar eww-local-regex)                ; In `eww.el' (Emacs 25+)
(defvar eww-search-prefix)              ; In `eww.el' (Emacs 25+)
(defvar gnus-article-current)           ; In `gnus-sum.el'
(defvar grep-history)                   ; In `grep.el' (Emacs 22+)
(defvar Info-current-node)              ; In `info.el'
(defvar Info-current-file)              ; In `info.el'
(defvar kmacro-counter)                 ; In `kmacro.el'
(defvar kmacro-counter-format-start)    ; In `kmacro.el'
(defvar kmacro-ring)                    ; In `kmacro.el'
(defvar Man-arguments)                  ; In `man.el'
(defvar Man-notify-method)              ; In `man.el'
(defvar org-store-link-functions)       ; In `org.el'
(defvar pp-default-function)            ; Emacs 30+
(defvar read-file-name-completion-ignore-case) ; Emacs 23+
(defvar repeat-previous-repeated-command) ; In `repeat.el'
(defvar repeat-message-function)        ; In `repeat.el'
(defvar last-repeatable-command)        ; In `repeat.el'
(defvar zz-izones-var)                  ; In `zones.el'
(defvar woman-last-file-name)           ; In `woman.el'
(defvar crm-separator)                  ; In `crm.el'  (dynamic binding by `completing-read-multiple')

;; Forward function declarations.  In bookmark-x-lit.el (optional, soft require).
(declare-function bmkx-bookmarks-lighted-at-point "bookmark-x-lit")
(declare-function bmkx-cycle-lighted             "bookmark-x-lit")
(declare-function bmkx-cycle-lighted-other-window "bookmark-x-lit")
(declare-function bmkx-get-lighting              "bookmark-x-lit")
(declare-function bmkx-light-bookmark            "bookmark-x-lit")
(declare-function bmkx-light-bookmarks           "bookmark-x-lit")
(declare-function bmkx-light-this-buffer         "bookmark-x-lit")
(declare-function bmkx-lighted-alist-only        "bookmark-x-lit")
(declare-function bmkx-toggle-auto-light-when-jump "bookmark-x-lit")
(declare-function bmkx-toggle-auto-light-when-set  "bookmark-x-lit")

(declare-function bmkx-read-bookmark-for-jump      "bookmark-x-preview")

(defvar bmkx-fit-frame-flag)            ; Defined in `bookmark-x-bmu.el'.

;; In bookmark-x-bmu.el.
(declare-function bmkx-fit-bmenu-frame                    "bookmark-x-bmu")

;; Defined here (via define-button-type or inside conditional defun forms).
(declare-function bmkx-describe-bookmark-button           "bookmark-x-1")
(declare-function bmkx-describe-bookmark-internals-button "bookmark-x-1")
(declare-function bmkx-jump-to-list-button                "bookmark-x-1")
(declare-function bmkx-eww-alist-only                     "bookmark-x-1")
(declare-function bmkx-find-tag-default-as-regexp         "bookmark-x-1")

;; Built-in libraries we touch lazily (only inside specific bookmark handlers
;; or rarely-exercised code paths).  Declare instead of require to avoid
;; pulling them in at load time.
(declare-function ffap-guesser                   "ffap")
(declare-function ffap-read-file-or-url          "ffap")
(declare-function ffap-url-p                     "ffap")
(declare-function Man-getpage-in-background      "man")
(declare-function Info-find-node                 "info")
(declare-function eww-current-url                "eww")
(declare-function gnus-article-show-summary      "gnus-art")
(declare-function gnus-summary-goto-article      "gnus-sum")
(declare-function gnus-summary-insert-cached-articles "gnus-sum")
(declare-function gnus-data-find-in              "gnus-sum")
(declare-function dired-guess-default            "dired-x")
(declare-function compilation-next-error         "compile")
(declare-function image-dired-get-thumbnail-image "image-dired")
(declare-function mailcap-file-default-commands  "mailcap")
(declare-function org-link-store-props           "ol")
(declare-function desktop-full-file-name         "desktop")
(declare-function desktop-release-lock           "desktop")
(declare-function desktop-lazy-abort             "desktop")

;; dired+ is an optional Drew Adams package, still maintained.
(declare-function diredp-dired-union-interactive-spec "dired+")
(declare-function diredp-live-dired-buffers           "dired+")

;;(@* "User Options (Customizable)")
;;; User Options (Customizable) --------------------------------------

;;;###autoload (autoload 'bmkx-autofile-access-invokes-bookmark-flag "bookmark-x")
(defcustom bmkx-autofile-access-invokes-bookmark-flag nil
  "*Non-nil means invoke the bookmark when you access an autofile.
That is, if a file has an associated autofile bookmark then functions
such as `find-file' will automatically jump to the bookmark.  The
buffer position of an autofile bookmark is not important, but this can
be useful to update the bookmark data, such as the number of visits.

If you change the option value in Lisp code without using a Customize
function, then add/remove `bmkx-find-file-invoke-bookmark-if-autofile'
to/from `find-file-hook'."
  :set (lambda (sym new-val)
         (custom-set-default sym new-val)
         (if bmkx-autofile-access-invokes-bookmark-flag
             (add-hook 'find-file-hook 'bmkx-find-file-invoke-bookmark-if-autofile)
           (remove-hook 'find-file-hook 'bmkx-find-file-invoke-bookmark-if-autofile)))
  :type 'boolean :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-autofile-filecache "bookmark-x")
(defcustom bmkx-autofile-filecache 'cache-only
  "*Whether Emacs filecache commands create/set an autofile bookmark.
The possible values:
`autofile+cache' - Whenever a file is added to the file cache, also
                   create/set an autofile bookmark for the file.
`autofile-only'  - Create/set an autofile instead of caching the file.
`cache-only'     - Add the file to the file cache.  No autofile."
  :type '(choice
          (const :tag "Create/set an autofile bookmark instead of adding to file cache"  autofile-only)
          (const :tag "Create/set an autofile bookmark and add to file cache"            autofile+cache)
          (const :tag "Add to file cache only - do not create/set an autofile bookmark"  cache-only))
  :group 'bookmark-plus)


;; We do not use `define-obsolete-variable-alias' so that byte-compilation in older Emacs
;; works for newer Emacs too.
(progn ; Emacs 22+
  (defvaralias 'bmkx-auto-idle-bookmark-min-distance 'bmkx-automatic-bookmark-min-distance)
  (bmkx-make-obsolete-variable 'bmkx-auto-idle-bookmark-min-distance 'bmkx-automatic-bookmark-min-distance
                               "2021-08-18"))

;;;###autoload (autoload 'bmkx-automatic-bookmark-min-distance "bookmark-x")
(defcustom bmkx-automatic-bookmark-min-distance 1000
  "*Minimum number of chars between automatic bookmark positions.
Automatic bookmarking is done by `bmkx-automatic-bookmark-mode'."
  :type '(choice
          (const   :tag "No minumum distance" nil)
          (integer :tag "At least this many chars" :value 1000))
  :group 'bookmark-plus)

;; Emacs 20 only.
;;
;; (Don't bother aliasing the old name, for Emacs 20.)
;;
;;;###autoload (autoload 'bmkx-automatic-bookmark-mode "bookmark-x")


;; We do not use `define-obsolete-variable-alias' so that byte-compilation in older Emacs
;; works for newer Emacs too.
(progn ; Emacs 22+
  (defvaralias 'bmkx-auto-idle-bookmark-mode-delay 'bmkx-automatic-bookmark-mode-delay)
  (bmkx-make-obsolete-variable 'bmkx-auto-idle-bookmark-mode-delay 'bmkx-automatic-bookmark-mode-delay
                               "2021-08-18"))

;;;###autoload (autoload 'bmkx-automatic-bookmark-mode-delay "bookmark-x")
(defcustom bmkx-automatic-bookmark-mode-delay 60
  "*Number of seconds delay before automatically setting a bookmark.
Automatic bookmarking is done by `bmkx-automatic-bookmark-mode'."
  :type 'integer :group 'bookmark-plus)


;; We do not use `define-obsolete-variable-alias' so that byte-compilation in older Emacs
;; works for newer Emacs too.
(progn ; Emacs 22+
  (defvaralias 'bmkx-auto-idle-bookmark-mode-lighter 'bmkx-automatic-bookmark-mode-lighter)
  (bmkx-make-obsolete-variable 'bmkx-auto-idle-bookmark-mode-lighter 'bmkx-automatic-bookmark-mode-lighter
                               "2021-08-18"))

;;;###autoload (autoload 'bmkx-automatic-bookmark-mode-lighter "bookmark-x")
(defcustom bmkx-automatic-bookmark-mode-lighter " Auto-Bmk"
  "*Lighter for `bmkx-automatic-bookmark-mode'.
This string shows in the mode line when `bmkx-automatic-bookmark-mode'
is enabled.  Set this to nil or \"\" if you do not want any lighter."
  :type 'string :group 'bookmark-plus)


;; We do not use `define-obsolete-variable-alias' so that byte-compilation in older Emacs
;; works for newer Emacs too.
(progn ; Emacs 22+
  (defvaralias 'bmkx-auto-idle-bookmark-mode-set-function 'bmkx-automatic-bookmark-set-function)
  (bmkx-make-obsolete-variable 'bmkx-auto-idle-bookmark-mode-set-function
                               'bmkx-automatic-bookmark-set-function
                               "2021-08-18"))

;;;###autoload (autoload 'bmkx-automatic-bookmark-set-function "bookmark-x")
(defcustom bmkx-automatic-bookmark-set-function #'bmkx-set-autonamed-bookmark-at-line
  "*Function used to set an automatic bookmark.
Used by `bmkx-automatic-bookmark-mode' and `bmkx-set-automatic-bookmark'.

The default value, `bmkx-set-autonamed-bookmark-at-line', sets an
autonamed bookmark at the start of the current line.  To bookmark the
current position, so you can have more than one automatic bookmark per
line, use `bmkx-set-autonamed-bookmark' instead."
  :type 'function :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-autoname-bookmark-function "bookmark-x")
(defcustom bmkx-autoname-bookmark-function 'bmkx-autoname-bookmark-function-default
  "*Function to automatically name a bookmark at point (cursor position).
It should accept a buffer position as its (first) argument.
The name returned should match the application of
`bmkx-autoname-format' to the buffer name."
  :type 'function :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-autoname-format "bookmark-x")
(defcustom bmkx-autoname-format "^[0-9]\\{9\\} %B"
  "*Format string to match an autonamed bookmark name.
You can use `%B' instead of `%s' to accept the buffer name.  This has
the advantage that commands and other functions that check for a
buffer-specific bookmark can tell more accurately whether a bookmark
name matches the given buffer.  This applies to functions such as
`bmkx-autonamed-this-buffer-jump' and
`bmkx-autonamed-this-buffer-bookmark-p'."
  :type 'string :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-autotemp-bookmark-predicates "bookmark-x")
(defcustom bmkx-autotemp-bookmark-predicates '(bmkx-autonamed-bookmark-p
                                               bmkx-autonamed-this-buffer-bookmark-p)
  "*Predicates for bookmarks to be set (created) as temporary bookmarks.
Each is typically a type predicate, but it can be any function that
accepts as its (first) argument a bookmark or bookmark name.

These are the predefined type predicates:

`bmkx-annotated-bookmark-p', `bmkx-autofile-bookmark-p',
`bmkx-autonamed-bookmark-for-buffer-p', `bmkx-autonamed-bookmark-p',
`bmkx-autonamed-this-buffer-bookmark-p', `bmkx-buffer-bookmark-p',
`bmkx-bookmark-file-bookmark-p', `bmkx-bookmark-list-bookmark-p',
`bmkx-desktop-bookmark-p', `bmkx-dired-bookmark-p',
`bmkx-dired-this-dir-bookmark-p', `bmkx-dired-wildcards-bookmark-p',
`bmkx-eww-bookmark-p' (Emacs 25+), `bmkx-file-bookmark-p',
`bmkx-file-remote-p', `bmkx-file-this-dir-bookmark-p',
`bmkx-flagged-bookmark-p', `bmkx-function-bookmark-p',
`bmkx-gnus-bookmark-p', `bmkx-image-bookmark-p', `bmkx-info-bookmark-p',
`bmkx-last-specific-buffer-p', `bmkx-last-specific-file-p',
`bmkx-local-directory-bookmark-p', `bmkx-local-file-bookmark-p',
`bmkx-local-non-dir-file-bookmark-p', `bmkx-man-bookmark-p',
`bmkx-marked-bookmark-p', `bmkx-modified-bookmark-p',
`bmkx-navlist-bookmark-p', `bmkx-non-dir-file-bookmark-p',
`bmkx-non-file-bookmark-p', `bmkx-non-invokable-bookmark-p',
`bmkx-omitted-bookmark-p', `bmkx-orphaned-file-bookmark-p',
`bmkx-orphaned-local-file-bookmark-p',
`bmkx-orphaned-remote-file-bookmark-p', `bmkx-region-bookmark-p',
`bmkx-remote-file-bookmark-p', `bmkx-remote-non-dir-file-bookmark-p',
`bmkx-sequence-bookmark-p', `bmkx-snippet-bookmark-p',
`bmkx-temporary-bookmark-p', `bmkx-this-buffer-p', `bmkx-this-file-p',
`bmkx-url-bookmark-p', `bmkx-url-browse-bookmark-p',
`bmkx-variable-list-bookmark-p', `bmkx-w3m-bookmark-p'"
  :type '(repeat symbol) :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-bookmark-name-length-max "bookmark-x")
(defcustom bmkx-bookmark-name-length-max 70
  "*Max number of chars for default name for a bookmark with a region."
  :type 'integer :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-count-multi-mods-as-one-flag "bookmark-x")
(defcustom bmkx-count-multi-mods-as-one-flag t
  "*Non-nil means count multiple modifications as one.
This is for `bookmark-alist-modification-count'.  Non-nil means that
when you invoke a command that acts on multiple bookmarks or acts in
multiple ways on one bookmark, all of changes together count as only
one modification.  That can prevent automatic saving of your bookmark
file during the sequence of modifications, so that when the command is
done you can choose not to save (i.e., to quit) if you like."
  :type 'boolean :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-highlight-on-jump-flag "bookmark-x")
(defcustom bmkx-highlight-on-jump-flag t
  "*Non-nil means briefly pulse-highlight the landing line after a jump.
Implemented with `pulse.el' (built in since Emacs 27.1).

The highlight appears in whatever buffer is current after jumping.
If the bookmark's handler does not switch to a buffer (e.g. one whose
handler just invokes an external program), the highlight appears in
the buffer that was current before the jump.

If you set this option from Lisp, add or remove
`bmkx-highlight-jump-target' on `bookmark-after-jump-hook' yourself."
  :set (lambda (sym new-val)
         (custom-set-default sym new-val)
         (if bmkx-highlight-on-jump-flag
             (add-hook 'bookmark-after-jump-hook 'bmkx-highlight-jump-target)
           (remove-hook 'bookmark-after-jump-hook 'bmkx-highlight-jump-target)))
  :type 'boolean :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-default-bookmark-name "bookmark-x")
(defcustom bmkx-default-bookmark-name 'highlighted
  "*Default bookmark name preference for accessing existing bookmarks.
\(The default name for a *new* bookmark is obtained using option
`bmkx-new-bookmark-default-names'.)

In `*Bmkx List*' use the name of the current line's bookmark.
Otherwise, if `bookmark-x-lit.el' is not loaded then use the name of
the last-used bookmark in the current file.

Otherwise, use this option to determine the default, by preferring one
of the following, if available:

* a highlighted bookmark at point
* the last-used bookmark in the current file"
  :type '(choice
          (const :tag "Highlighted bookmark at point"    highlighted)
          (const :tag "Last used bookmark in same file"  last-used))
  :group 'bookmark-plus)


;; We do not use `define-obsolete-variable-alias' so that byte-compilation in older Emacs
;; works for newer Emacs too.
(progn ; Emacs 22+
  (defvaralias 'bmkx-default-handler-associations 'bmkx-default-handlers-for-file-types)
  (bmkx-make-obsolete-variable 'bmkx-default-handler-associations 'bmkx-default-handlers-for-file-types
                               "2012-02-27"))

;;;###autoload (autoload 'bmkx-default-handlers-for-file-types "bookmark-x")
(defcustom bmkx-default-handlers-for-file-types
  (and (require 'dired-x)         ; It in turn requires `dired-aux.el'
       (let ((assns  ()))
         (dolist (shell-assn  dired-guess-shell-alist-user)
           (push (cons (car shell-assn)
                       `(lambda (bmk)
                          (dired-run-shell-command
                           (dired-shell-stuff-it ,(cadr shell-assn) (list (bookmark-get-filename bmk))
                                                 nil nil))))
                 assns))
         assns))
  "*File associations for bookmark handlers used for indirect bookmarks.
Each element of the alist is (REGEXP . COMMAND).
REGEXP matches a file name.
COMMAND is a sexp that evaluates to either a shell command (a string)
 or an Emacs function (a symbol or a lambda form).  The shell command
 or Lisp function must accept a file-name argument.

Example value:

 ((\"\\\\.pdf$\"   . \"AcroRd32.exe\") ; Adobe Acrobat Reader
  (\"\\\\.ps$\"    . \"gsview32.exe\") ; Ghostview (PostScript viewer)
  (\"\\\\.html?$\" . browse-url)       ; Use Lisp function `browse-url'
  (\"\\\\.doc$\"   . w32-browser))     ; Use Lisp function `w32-browser'

When you change this option using Customize, if you want to use a
literal string as COMMAND then you must double-quote the text:
\"...\".  (But do not use double-quotes for the REGEXP.)  If you want
to use a symbol as COMMAND, just type the symbol name (no quotes).

This option is used by `bmkx-default-handler-for-file' to determine
the default `file-handler' property for a given file bookmark.  If a
given file name does not match this option, and if
`bmkx-guess-default-handler-for-file-flag' is non-nil, then
`bmkx-default-handler-for-file' tries to guess a shell command to use
in the default handler.  For that it uses `dired-guess-default' and
\(Emacs 23+ only) mailcap entries, in that order."
  :type '(alist :key-type
                regexp :value-type
                (sexp :tag "Shell command (string) or Emacs function (symbol or lambda form)"))
  :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-desktop-default-directory "bookmark-x")
(defcustom bmkx-desktop-default-directory nil
  "*Default directory used when reading the name of a desktop file.
If nil then use the current directory (value of `default-directory')."
  :type 'directory :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-desktop-jump-save-before-flag "bookmark-x")
(defcustom bmkx-desktop-jump-save-before-flag nil
  "*Non-nil means `bmkx-desktop-jump' saves the desktop file before switching."
  :type 'boolean :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-desktop-no-save-vars "bookmark-x")
(defcustom bmkx-desktop-no-save-vars '(search-ring regexp-search-ring kill-ring)
  "*List of variables not to save when creating a desktop bookmark.
They are removed from `desktop-globals-to-save' for the duration of
the save (only)."
  :type '(repeat (variable :tag "Variable")) :group 'bookmark-plus)


;; EWW support
(progn ; Emacs 25+

  (defcustom bmkx-eww-auto-type 'update-only
    "How `bmkx-eww-auto-bookmark-mode' behaves when enabled.
You can toggle this option using `\\[bmkx-toggle-eww-auto-type]'."
    :type '(choice
            (const :tag "Create EWW bookmark or update existing EWW bookmark" create-or-update)
            (const :tag "Update existing EWW bookmark (only)" update-only))
    :group 'bookmark-plus)

  (defcustom bmkx-eww-buffer-renaming nil
    "Whether and how an EWW buffer is renamed.
Non-nil values affect EWW behavior even when bookmarks are not used.

* nil:    Do not rename buffer - use `*eww*' (built-in EWW behavior).
* `url':  Rename buffer to web-page title plus last 20 chars of URL.
* `page': Rename buffer to web-page title (only)."
    :type '(choice
            (const :tag "Do not rename buffer (use name `*eww*')"                    nil)
            (const :tag "Rename buffer to web-page title plus last 20 chars of URL"  url)
            ;; Any symbol other than `page' and nil is treated the same as `page'.
            (const :tag "Rename buffer to web-page title"                            page))
    :group 'bookmark-plus)

  (defcustom bmkx-eww-generate-buffer-flag nil
    "Whether to generate a new buffer when jumping to an EWW bookmark.
* nil means reuse an existing buffer for the bookmarked URL.
* Non-nil means use a new buffer."
    :type 'boolean :group 'bookmark-plus)

  (defcustom bmkx-eww-replace-keys-flag t
    "Non-nil means replace EWW bookmarking keys and menus with Bookmark-X ones.
If you change the value of this option then you must restart Emacs for
it to take effect."
    :type 'boolean :group 'bookmark-plus)
  )

;;;###autoload (autoload 'bmkx-annotation-modes-inherit-from "bookmark-x")
(defcustom bmkx-annotation-modes-inherit-from 'org-mode
  "Symbol for mode that bookmark annotation modes are to inherit from.
Or nil if no parent mode.  The annotation modes are
`bmkx-edit-annotation-mode' and `bmkx-show-annotation-mode'.

You must restart Emacs after changing the value of this option, for
the change to take effect."
  :type  'symbol :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-handle-region-function "bookmark-x")
(defcustom bmkx-handle-region-function 'bmkx-handle-region-default
  "*Function to handle a bookmarked region."
  :type 'function :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-info-sort-ignores-directories-flag "bookmark-x")
(defcustom bmkx-info-sort-ignores-directories-flag t
  "*Non-nil means Info-bookmark sorting uses manual names, not file locations.
If nil, the absolute file names of the manuals are used.  This can be
useful if you have bookmarks for multiple Emacs releases, and you want
the bookmarks for a given release to appear together."
  :type 'boolean :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-incremental-filter-delay "bookmark-x")
(defcustom bmkx-incremental-filter-delay (if (boundp 'bookmark-search-delay)
                                             bookmark-search-delay
                                           0.2)
  "*Seconds to wait before updating display when filtering bookmarks."
  :type 'number :group 'bookmark-plus)


(progn ; Emacs 22+ (need also `Info-selection-hook').

  (defcustom bmkx-info-auto-type 'create-or-update
    "How `bmkx-info-auto-bookmark-mode' behaves when enabled.
You can toggle this option using `\\[bmkx-toggle-info-auto-type]'."
    :type '(choice
            (const :tag "Create Info bookmark or update existing Info bookmark" create-or-update)
            (const :tag "Update existing Info bookmark (only)" update-only))
    :group 'bookmark-plus)

  )

;; Removed autoload cookie, to avoid (void-variable bookmark-default-file) ;;;###autoload
(defcustom bmkx-last-as-first-bookmark-file bookmark-default-file
  "*Whether to use the last-used bookmark file as the first used.
If nil then Emacs always uses the value of `bookmark-default-file' as
the initial bookmark file, in any given session.

If non-nil, Emacs uses the last bookmark file you used, in the last
Emacs session.  If none was recorded then it uses
`bookmark-default-file'.  The particular non-nil value must be an
absolute file name \(possibly containing `~') - it is not expanded).

NOTE: A non-nil option value is overwritten by Bookmark-X, so that it
becomes the last-used bookmark file.  A nil value is never
overwritten."
  :type '(choice
          (const :tag "Use `bookmark-default-file' as initial bookmark file" nil)
          (file  :tag "Use last-used bookmark file as initial bookmark file"
           :value "~/.emacs.bmk"))
  :group 'bookmark)

;;;###autoload (autoload 'bmkx-menu-popup-max-length "bookmark-x")
(defcustom bmkx-menu-popup-max-length 20
  "*Max number of bookmarks for `bmkx-completing-read' to use a menu.
When choosing a bookmark from a list of bookmarks using
`bmkx-completing-read', this controls whether to use a menu or
minibuffer input with completion.
If t, then always use a menu.
If nil, then never use a menu.
If an integer, then use a menu only if there are fewer bookmark
 choices than the value."
  :type '(choice
          (integer :tag "Use a menu if there are fewer bookmark choices than this" 20)
          (const   :tag "Always use a menu to choose a bookmark" t)
          (const   :tag "Never use a menu to choose a bookmark" nil))
  :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-new-bookmark-default-names "bookmark-x")
(defcustom bmkx-new-bookmark-default-names
  (list 'bmkx-region-or-symbol-name-nearest-point
        (lambda () (let ((ff  (function-called-at-point)))
                     (and ff  (symbolp ff)  (symbol-name ff)))))
  "Functions to produce the default name for a new bookmark.
\(The default name for an *existing* bookmark is obtained using
`bmkx-default-bookmark-name'.)

The option value is a list of functions that do not require an
argument and return a string (or nil).  They are invoked, in order, to
produce the default names.

The following names are also provided, after the names described
above: The value of variable `bookmark-current-bookmark' and the
return value of function `bookmark-buffer-name', in that order.

These latter names are the defaults provided by built-in Emacs
`bookmark.el', so if you want the built-in behavior then set the option
value to nil.

For non-interactive use of a default bookmark name, and for Emacs
prior to Emacs 23 even for interactive use, only the first default
name is used.

Some functions you might want to use in the option value:

 * `bmkx-region-or-symbol-name-nearest-point'
 * (lambda () (let ((ff  (function-called-at-point)))
      (and (symbolp ff)  (symbol-name ff))))
 * (lambda () (let ((vv  (variable-at-point))) ; `variable-at-point'
      (and (symbolp vv)  (symbol-name vv))))   ;  returns 0 if no var
 * `word-at-point'
 * (lambda () (let ((ss  (symbol-at-point)))
     (and ss  (symbol-name ss))))

The first of these returns the text in the region, if it is active
and non-empty.  Otherwise it returns the name of the symbol nearest
point, searching up to `bmkx-near-point-distance' characters away."
  :type '(repeat function) :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-other-window-pop-to-flag "bookmark-x")
(defcustom bmkx-other-window-pop-to-flag t
  "*Non-nil means other-window bookmark jumping uses `pop-to-buffer'.
Use nil if you want the built-in Emacs behavior, which uses
`switch-to-buffer-other-window'.  That creates a new window even if
there is already another window showing the buffer."
  :type 'boolean :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-prompt-for-tags-flag "bookmark-x")
(defcustom bmkx-prompt-for-tags-flag nil
  "*Non-nil means setting bookmarks interactively prompts for tags to add.
For an existing bookmark, if option `bmkx-properties-to-keep' includes
`tags' (which it does by default), then the tags you enter are added
to any that the bookmark already has - none are removed."
  :type 'boolean :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-properties-to-keep "bookmark-x")
(defcustom bmkx-properties-to-keep '(tags annotation)
  "*List of properties to keep when you set an existing bookmark.
When you set a bookmark that already exists, its properties are
updated (overwritten), with the exception of those listed here."
  :type '(repeat symbol) :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-region-search-size "bookmark-x")
(defcustom bmkx-region-search-size 40
  "*Same as `bookmark-search-size', but specialized for bookmark regions."
  :type 'integer :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-save-new-location-flag "bookmark-x")
(defcustom bmkx-save-new-location-flag t
  "*Non-nil means save automatically relocated bookmarks.
If nil, then the new bookmark location is visited, but it is not saved
as part of the bookmark definition."
  :type 'boolean :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-sequence-jump-display-function "bookmark-x")
(defcustom bmkx-sequence-jump-display-function 'pop-to-buffer
  "*Function used to display the bookmarks in a bookmark sequence."
  :type 'function :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-show-end-of-region-flag "bookmark-x")
(defcustom bmkx-show-end-of-region-flag t
  "*Show end of region with `exchange-point-and-mark' when activating a region.
If nil show only beginning of region."
  :type 'boolean :group 'bookmark-plus)

;; The default value corresponds to what's used by `bmkx-bmenu-sort-by-bookmark-type' (`s k').
;;
;;;###autoload (autoload 'bmkx-sort-comparer "bookmark-x")
(defcustom bmkx-sort-comparer '((bmkx-info-node-name-cp bmkx-url-cp bmkx-gnus-cp
                                                        bmkx-local-file-type-cp bmkx-handler-cp)
                                bmkx-alpha-p)
  ;; $$$$$$ An alternative default value: `bmkx-alpha-p', which corresponds to `s n'.
  "*Predicate or predicates for sorting (comparing) bookmarks.
This defines the default sort for bookmarks in the bookmark list.

Various sorting commands, such as \\<bmkx-list-mode-map>\
`\\[bmkx-bmenu-sort-by-bookmark-visit-frequency]', change the value of this
option dynamically (but they do not save the changed value).

The value must be one of the following:

* nil, meaning do not sort

* a predicate that takes two bookmarks as args

* a list of the form ((PRED...) FINAL-PRED), where each PRED and
  FINAL-PRED are predicates that take two bookmarks as args

If the value is a list of predicates, then each PRED is tried in turn
until one returns a non-nil value.  In that case, the result is the
car of that value.  If no non-nil value is returned by any PRED, then
FINAL-PRED is used and its value is the result.

Each PRED should return `(t)' for true, `(nil)' for false, or nil for
undecided.  A nil value means that the next PRED decides (or
FINAL-PRED, if there is no next PRED).

Thus, a PRED is a special kind of predicate that indicates either a
boolean value (as a singleton list) or \"I cannot decide - let the
next guy else decide\".  (Essentially, each PRED is a hook function
that is run using `run-hook-with-args-until-success'.)

Examples:

 nil           - No sorting.

 string-lessp  - Single predicate that returns nil or non-nil.

 ((p1 p2))     - Two predicates `p1' and `p2', which each return
                 (t) for true, (nil) for false, or nil for undecided.

 ((p1 p2) string-lessp)
               - Same as previous, except if both `p1' and `p2'
                 return nil, then the return value of `string-lessp'
                 is used.

Note that these two values are generally equivalent, in terms of their
effect (*):

 ((p1 p2))
 ((p1) p2-plain) where p2-plain is (bmkx-make-plain-predicate p2)

Likewise, these three values generally act equivalently (*):

 ((p1))
 (() p1-plain)
 p1-plain        where p1-plain is (bmkx-make-plain-predicate p1)

The PRED form lets you easily combine predicates: use `p1' unless it
cannot decide, in which case try `p2', and so on.  The value ((p2 p1))
tries the predicates in the opposite order: first `p2', then `p1' if
`p2' returns nil.

Using a single predicate or FINAL-PRED makes it easy to reuse an
existing predicate that returns nil or non-nil.

You can also convert a PRED-type predicate (which returns (t), (nil),
or nil) into an ordinary predicate, by using macro
`bmkx-make-plain-predicate'.  That lets you reuse elsewhere, as
ordinary predicates, any PRED-type predicates you define.

For example, this defines a plain predicate to compare by URL:
 (defalias \\='bmkx-url-p (bmkx-make-plain-predicate bmkx-url-cp))

Note: As a convention, predefined Bookmark-X PRED-type predicate names
have the suffix `-cp' (for \"component predicate\") instead of `-p'.

--
* If you use `\\[bmkx-reverse-multi-sort-order]', then there is a difference in \
behavior between

   (a) using a plain predicate as FINAL-PRED and
   (b) using the analogous PRED-type predicate (and no FINAL-PRED).

  In the latter case, `\\[bmkx-reverse-multi-sort-order]' affects when the predicate \
is tried and
  its return value.  See `bmkx-reverse-multi-sort-order'."
  :type '(choice
          (const    :tag "None (do not sort)" nil)
          (function :tag "Sorting Predicate")
          (list     :tag "Sorting Multi-Predicate"
                    (repeat (function :tag "Component Predicate"))
                    (choice (const    :tag "None" nil)
                            (function :tag "Final Predicate"))))
  :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-su-or-sudo-regexp "bookmark-x")
(defcustom bmkx-su-or-sudo-regexp "\\(/su:\\|/sudo:\\)"
  "*Regexp to recognize `su' or `sudo' Tramp bookmarks."
  :type 'regexp :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-tags-for-completion "bookmark-x")
(defcustom bmkx-tags-for-completion 'current
  "*List of strings used as tags for completion (not an alist).
The tags can be specified here individually or taken from (a) the
current bookmark list or (b) one or more bookmark files or both.

\(In Emacs 20 and 21, you cannot choose (b) when customizing, but if
\(b) was chosen using a later Emacs version then the option value can
still be used in Emacs 20 and 21.)

If a relative file name is specified for a bookmark file then the
current value of `default-directory' is used to find the file."
  :type '(choice
          (const :tag "From current bookmarks only" current)
          (list :tag "From current bookmarks and other sources"
           (const  :tag "" current)
           (repeat :inline t :tag "Additional sources or specific tags"
            (choice
             (string :tag "Specific tag")
             (cons   :tag "All tags from a bookmark file"
              (const :tag "" bmkfile) (file :must-match t)))))
          (repeat :tag "Choose sources or specific tags"
           (choice
            (string :tag "Specific tag")
            (cons   :tag "All tags from a bookmark file"
             (const :tag "" bmkfile) (file :must-match t)))))
  :group 'bookmark-plus)

;; Emacs 20 only.

;;;###autoload (autoload 'bmkx-temporary-bookmarking-mode-hook "bookmark-x")
(defcustom bmkx-temporary-bookmarking-mode-hook ()
  "*Functions run after entering and exiting temporary-bookmarking mode."
  :type 'hook :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-this-file/buffer-cycle-sort-comparer "bookmark-x")
(defcustom bmkx-this-file/buffer-cycle-sort-comparer '((bmkx-position-cp))
  "*`bmkx-sort-comparer' value for cycling this-file/buffer bookmarks.
Use bookmarks for the currently visited file or (non-file) buffer.
Some values you might want to use: ((bmkx-position-cp)),
 ((bmkx-bookmark-creation-cp)), ((bmkx-visited-more-often-cp)),
 ((bmkx-visited-more-recently-cp)).
See `bmkx-sort-comparer'."
  :type '(choice
          (const    :tag "None (do not sort)" nil)
          (function :tag "Sorting Predicate")
          (list     :tag "Sorting Multi-Predicate"
           (repeat (function :tag "Component Predicate"))
           (choice
            (const    :tag "None" nil)
            (function :tag "Final Predicate"))))
  :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-guess-default-handler-for-file-flag "bookmark-x")
(defcustom bmkx-guess-default-handler-for-file-flag nil
  "*Non-nil means guess the default handler when creating a file bookmark.
This is ignored if a handler can be found using option
`bmkx-default-handlers-for-file-types'.  Otherwise, this is used by
function `bmkx-default-handler-for-file' to determine the default
handler for a given file."
  :type 'boolean :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-read-bookmark-file-hook "bookmark-x")
(defcustom bmkx-read-bookmark-file-hook ()
  "*List of functions called, in order, after reading a bookmark file.
Each function should accept the list of bookmarks read from the file
as first argument and the bookmark file name as second argument."
  :type 'hook :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-temporary-bookmarking-mode-lighter "bookmark-x")
(defcustom bmkx-temporary-bookmarking-mode-lighter " Temp-Bmk"
  "*Lighter for `bmkx-temporary-bookmarking-mode'.
This string shows in the mode line when `bmkx-temporary-bookmarking-mode'
is enabled.  Set this to nil or \"\" if you do not want any lighter."
  :type 'string :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-use-region "bookmark-x")
(defcustom bmkx-use-region t
  "*Non-nil means visiting a bookmark activates its recorded region."
  :type '(choice
          (const :tag "Activate bookmark region (except during cycling)"  t)
          (const :tag "Do not activate bookmark region"                   nil)
          (const :tag "Activate bookmark region even during cycling"      cycling-too))
  :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-write-bookmark-file-hook "bookmark-x")
(defcustom bmkx-write-bookmark-file-hook ()
  "*List of functions called, in order, after writing a bookmark file.
Each function should accept the bookmark file name as first argument.
Used after `after-save-hook'."
  :type 'hook :group 'bookmark-plus)

;; This and the version of function `Info-bmkx-jump' defined here are also defined in `info+.el',
;; so that their feature is available if you use either `Info+' or `Bookmark-X'.
;;
;;;###autoload
(defcustom Info-bookmark-use-only-node-not-file-flag t
  "Non-nil means an Info bookmark uses only the node name.
The recorded Info file name is ignored.  This means use only manuals
corresponding to the current Emacs session, regardless of the Emacs
version or platform used to record the bookmark.

A nil value means use the manuals whose absolute file names are
recorded in the bookmarks.  (But if the file doesn't exist or is
unreadable, then act as if the value is non-nil.)

A non-nil value means you can use the same bookmark with different
Emacs installations, including on different platforms.  A nil value
means that you can use a bookmark to consult the Info manual for a
different Emacs version from that of the current session."
  :type 'boolean :group 'bookmark-plus)
 
;;(@* "Internal Variables")
;;; Internal Variables -----------------------------------------------

(defconst bmkx-non-file-filename "   - no file -"
  "Name to use for `filename' entry, for non-file bookmarks.")

(defvar bmkx-after-set-hook nil "Hook run after `bmkx-set' sets a bookmark.")

(defvar bmkx-automatic-bookmarks ()
  "Alist of bookmarks that were created automatically during this session.")


;; We do not use `define-obsolete-variable-alias' so that byte-compilation in older Emacs
;; works for newer Emacs too.
(progn ; Emacs 22+
  (defvaralias 'bmkx-automatic-bookmark-mode-timer 'bmkx-auto-idle-bookmark-mode-timer)
  (bmkx-make-obsolete-variable 'bmkx-auto-idle-bookmark-mode-timer 'bmkx-automatic-bookmark-mode-timer
                               "2021-08-18"))

(defvar-local bmkx-automatic-bookmark-mode-timer nil
  "Timer for `bmkx-automatic-bookmark-mode'.
This variable is buffer-local, which means that there is a separate
timer for each buffer where automatic bookmarking is enabled.")


(defvar bmkx-autotemp-all-when-set-p nil "Non-nil means make any bookmark temporary whenever it is set.")

;;; $$$$$$ No - don't bother.
;;; (defconst bmkx-bookmark-modifier-functions  '(bmkx-prop-set bmkx-replace-existing-bookmark
;;;                                               bmkx-set-name bmkx-store)
;;;   "List of functions that modify bookmarks.
;;; Used to mark modified, unsaved bookmarks, in `*Bmkx List*'.
;;; Should not include any function that calls another in the list.")


;; `defvar' Provided for older Emacs versions.
(defvar bookmark-after-jump-hook nil
  "Hook run after `bmkx-jump' jumps to a bookmark.
Useful for example to unhide text in `outline-mode'.")

(defvar bmkx-before-jump-hook nil
  "Hook run before `bmkx-jump' jumps to a bookmark.")

(defvar bmkx-copied-tags ()
  "List of tags copied from a bookmark, for pasting to other bookmarks.")

(defvar bmkx-bookmark-set-confirms-overwrite-p nil
  "Non-nil means `bmkx-set' requires confirmation about overwriting.")

(defvar bmkx-current-bookmark-file bookmark-default-file
  "Current bookmark file.
When you start Emacs, this is initialized according to
`bmkx-last-as-first-bookmark-file'.

When you load bookmarks using `\\[bmkx-switch-bookmark-file-create]', this is set to the file you
load.  When you save bookmarks using `bmkx-save' with no prefix
arg, they are saved to this file.

Loading a bookmark file does not change the value of
`bookmark-default-file', but it might change the value of
`bmkx-last-as-first-bookmark-file' (which see).  The value of
`bookmark-default-file' is never changed, except by your
customizations.")

(defvar bmkx-desktop-current-file nil
  "Desktop file from last desktop bookmark jumped to.")

(defvar bmkx-edit-bookmark-orig-record nil
  "Record of bookmark being edited.")

(defvar bmkx-ffap-max-region-size 1024 ; See also Emacs bug #25243.
  "Max size of active region used to obtain file-name defaults.
An active region larger than this many characters prevents
`bmkx-ffap-guesser' from calling `ffap-guesser'.")

(defvar bmkx-file-bookmark-handlers '(bmkx-jump-dired image-bmkx-jump)
  "List of functions that handle file or directory bookmarks.
This is used to determine `bmkx-file-bookmark-p'.")

(defvar bmkx-last-bmenu-state-file nil "Last value of option `bmkx-bmenu-state-file'.")

(defvar bmkx-last-bookmark-file bookmark-default-file
  "Last bookmark file used in this session (or default bookmark file).
This is a backup for `bmkx-current-bookmark-file'.")

(defvar bmkx-current-nav-bookmark nil "Current bookmark for navigation.")

(defvar bmkx-jump-display-function nil "Function used currently to display a bookmark.")

(defvar bmkx-last-specific-buffer ""
  "Name of buffer used by `bmkx-last-specific-buffer-p'.")

(defvar bmkx-last-specific-file ""
  "(Absolute) file name used by `bmkx-last-specific-file-p'.")

(defvar bmkx-modified-bookmarks ()
  "Alist of bookmarks that have been modified and not saved.")

(defvar bmkx-nav-alist () "Current bookmark alist used for navigation.")

(defvar bmkx-return-buffer nil "Name of buffer to return to.")

(defvar bmkx-reverse-sort-p nil "Non-nil means the sort direction is reversed.")

(defvar bmkx-reverse-multi-sort-p nil
  "Non-nil means the truth values returned by predicates are complemented.
This changes the order of the sorting groups, but it does not in
general reverse that order.  The order within each group is unchanged
\(not reversed).")

(defvar bmkx-use-w32-browser-p nil
  "Non-nil means use `w32-browser' in the default bookmark handler.
That is, use the default Windows application for the bookmarked file.
This has no effect if function `w32-browser' is not defined.")

(defvar bmkx-latest-bookmark-alist () "Copy of `bookmark-alist' as last filtered.")

(defvar bmkx-last-save-flag-value nil "Last value of option `bookmark-save-flag'.")

(defvar bmkx-sorted-alist ()
  "Copy of current bookmark alist, as sorted for buffer `*Bmkx List*'.
Has the same structure as `bookmark-alist'.")

(defvar bmkx-tag-history () "History of tags read from the user.")

(defvar bmkx-tags-alist ()
  "Alist of all bookmark tags, per option `bmkx-tags-for-completion'.
Each entry is a full tag: a cons whose car is a tag name, a string.
This is set by function `bmkx-tags-list'.
Use that function to update the value.")

;; Use this instead of either `bookmark-bookmarks-timestamp' (Emacs 27+)
;;                         or `bookmarks-already-loaded' (< Emacs 27).
;;
(defvar bmkx-bookmarks-already-loaded nil
  "Non-nil means some bookmarks have been loaded during this Emacs session.")


;; Override the built-in `bookmark-alist' doc string to reflect
;; `Bookmark-X' enhancements.
;;
(put 'bookmark-alist 'variable-documentation
     "Current list of bookmarks (bookmark records).
Bookmark functions update the value automatically.
You probably do not want to change the value yourself.

The value is an alist with entries of the form
 (BOOKMARK-NAME . PARAM-ALIST)
or the deprecated form (BOOKMARK-NAME PARAM-ALIST).

 BOOKMARK-NAME is the name you gave to the bookmark when creating it.
 PARAM-ALIST is an alist of bookmark data.  The order of the entries
  in PARAM-ALIST is not important.  The possible entries are described
  below.

Bookmarks created using built-in Emacs (`bookmark.el'):

 (filename . FILENAME)
 (location . LOCATION)
 (position . POS)
 (front-context-string . STR-AFTER-POS)
 (rear-context-string  . STR-BEFORE-POS)
 (handler . HANDLER)
 (annotation . ANNOTATION)

 FILENAME names the bookmarked file.
 LOCATION names the bookmarked file, URL, or other place (Emacs 23+).
  FILENAME or LOCATION is what is shown in the bookmark list
  (`C-x r l') when you use `M-t'.
 POS is the bookmarked buffer position (position in the file).
 STR-AFTER-POS is buffer text that immediately follows POS.
 STR-BEFORE-POS is buffer text that immediately precedes POS.
 ANNOTATION is a string that you can provide to identify the bookmark.
  See options `bookmark-use-annotations' and
  `bookmark-automatically-show-annotations'.
 HANDLER is a function that provides the bmkx-jump behavior
  for a specific kind of bookmark.  This is the case for Info
  bookmarks, for instance (starting with Emacs 23).

Bookmarks created using Bookmark-X are the same as for built-in Emacs,
except for the following differences.

1. Time of creation is recorded when you create a new bookmark:

 (created . CREATION-TIME)

 CREATION-TIME is an Emacs time representation, returned by function
 `current-time'.

2. Visit information is recorded, using entries `visits' and
   `last-visited':

 (visits . NUMBER-OF-VISITS)
 (last-visited . TIME-LAST-VISITED)

 NUMBER-OF-VISITS is a whole-number counter.

 TIME-LAST-VISITED is an Emacs time representation, returned by
 `current-time'.

3. The buffer name is recorded, using entry `buffer-name'.  It need
not be associated with a file.

4. If no file is associated with the bookmark, then FILENAME is
   `   - no file -'.

5. Bookmarks can be tagged by users.  The tag information is recorded
using entry `tags':

 (tags . TAGS-ALIST)

 TAGS-ALIST is an alist with string keys.

6. A bookmark can be simply a wrapper for a file, in which case it has
entry `file-handler' instead of `handler'.  When you \"jump\" to such
a bookmark, the `file-handler' function or shell-command is applied to
the `filename' entry.  Any `handler' entry present is ignored, as are
entries such as `position'.  It is only the target file that is
important.

7. The HANDLER function, if present, and if you want the bookmark
destination to be displayed, should display it.  The easiest, and
generally best way for it to do this is simply to invoke the default
handler, `bmkx-default-handler', at its end.  Handler function
`bmkx-jump-man' does this at the end, for example:

 (bmkx-default-handler (bmkx-get-bookmark bookmark))

8. Bookmarks can have individual highlighting, provided by users.
This overrides any default highlighting.

 (lighting . HIGHLIGHTING)

 HIGHLIGHTING is a property list that contain any of these keyword
 pairs:

   `:style' - Highlighting style.  Cdrs of `bmkx-light-styles-alist'
              entries are the possible values.
   `:face'  - Highlighting face, a symbol.
   `:when'  - A sexp to be evaluated.  Return value of `:no-light'
              means do not highlight.

9. The following additional entries are used to record region
information.  When a region is bookmarked, POS represents the region
start position.

 (end-position . END-POS)
 (front-context-region-string . STR-BEFORE-END-POS)
 (rear-context-region-string . STR-AFTER-END-POS))

 END-POS is the region end position.
 STR-BEFORE-END-POS is buffer text that precedes END-POS.
 STR-AFTER-END-POS is buffer text that follows END-POS.

The two context region strings are non-nil only when a region is
bookmarked.

 NOTE: The relative locations of `front-context-region-string' and
 `rear-context-region-string' are reversed from those of
 `front-context-string' and `rear-context-string'.  For example,
 `front-context-string' is the text that *follows* `position', but
 `front-context-region-string' *precedes* `end-position'.

10. The following additional entries are used for a Dired bookmark.

 (dired-marked . MARKED-FILES)
 (dired-subdirs . INSERTED-SUBDIRS)
 (dired-hidden-dirs . HIDDEN-SUBDIRS)
 (dired-switches . SWITCHES)

 MARKED-FILES is the list of files that were marked `*'.
 INSERTED-SUBDIRS is the list of subdirectores that were inserted.
 HIDDEN-SUBDIRS is the list of inserted subdirs that were hidden.
 SWITCHES is the string of `dired-listing-switches'.

11. The following additional entries are used for a Gnus bookmark.

 (group . GNUS-GROUP-NAME)
 (article . GNUS-ARTICLE-NUMBER)
 (message-id . GNUS-MESSAGE-ID)

 GNUS-GROUP-NAME is the name of a Gnus group.
 GNUS-ARTICLE-NUMBER is the number of a Gnus article.
 GNUS-MESSAGE-ID is the identifier of a Gnus message.

12. For a URL bookmark, FILENAME or LOCATION is a URL.

13. A sequence bookmark has this additional entry:

 (sequence . COMPONENT-BOOKMARKS)

 COMPONENT-BOOKMARKS is the list of component bookmark names.

14. A function bookmark has this additional entry, which records the
FUNCTION:

 (function . FUNCTION)

15. A bookmark-list bookmark has this additional entry, which records
the state of buffer `*Bmkx List*' at the time it is created:

 (bookmark-list . STATE)

 STATE records the sort order, filter function, omit list, and title.")

;;(@* "Core Replacements (`bookmark-*' except `bookmark-bmenu-*')")
;;; Core Replacements (`bookmark-*' except `bookmark-bmenu-*') -------



;; REPLACES DOCUMENTATION of ORIGINAL in `bookmark.el'.
;;
;; Doc now just says that this option is ignored by Bookmark-X.
(put 'bookmark-sort-flag 'variable-documentation
     "Ignored by Bookmark-X, which uses option `bmkx-sort-comparer' instead.")


(defun bmkx-get-bookmark (bookmark &optional noerror _no-name-check-p)
  "Return the full bookmark record for BOOKMARK, or nil / error.
BOOKMARK is a bookmark name (a string) or a full bookmark record.

If BOOKMARK is a cons (assumed already a record), return it as-is.
If BOOKMARK is a string, return `(assoc-string BOOKMARK bookmark-alist)'
(name lookup is precise because names are unique within bookmark-alist).

Non-nil optional NOERROR means return nil for invalid input; otherwise
raise an error.  The third arg is accepted for caller compatibility and
ignored."
  (cond ((consp bookmark) bookmark)
        ((stringp bookmark)
         (bmkx-bookmark-record-from-name bookmark noerror))
        (t (and (not noerror) (error "Invalid bookmark: `%s'" bookmark)))))


;; Differences from built-in `bookmark.el':
;;
;; Use option `bmkx-new-bookmark-default-names' to obtain the default name.
;;
(defun bmkx-make-record ()
  "Return a new bookmark record (NAME . ALIST) for the current location.
Start with `bookmark-make-record-function'.  If it does not provide a
bookmark name, then use option `bmkx-new-bookmark-default-names' to
provide it.  If that does not provide it then use
`bookmark-current-bookmark' or `bookmark-buffer-name', in that order."
  (let ((record  (funcall bookmark-make-record-function))
        defname)
    (if (stringp (car record))
        record
      (when (car record) (push nil record))
      (setq defname  (catch 'bmkx-make-record
                       (dolist (fn  bmkx-new-bookmark-default-names)
                         (when (functionp fn) ; Be sure it is defined and is a function.
                           (let ((val  (funcall fn)))
                             (when (and (stringp val)  (not (string= "" val)))
                               (throw 'bmkx-make-record val)))))
                       (or bookmark-current-bookmark  (bookmark-buffer-name))))
      (when (and defname  (not (stringp defname))) (setq defname  (format "%s" defname))) ; Just in case.
      (when (string= "" defname) (setq defname "<EMPTY NAME>")) ; You never know.
      (setcar record  defname)
      record)))


;; Differences from built-in `bookmark.el':
;;
;; 1. Added optional args NO-REFRESH-P and NO-MSG-P.
;; 2. Update the bookmark name also, not just the data, for an existing bookmark.
;; 3. Use `bmkx-get-bookmark-in-alist' to test whether the bookmark already exists.
;; 4. Put full bookmark record on bookmark name (inside record) as property `bmkx-full-record'.
;; 5. Use `bmkx-maybe-save-bookmarks'.
;; 6. Add the bookmark to `bmkx-modified-bookmarks', and to `bmkx-automatic-bookmarks' if appropriate.
;; 7. Use `bmkx-refresh/rebuild-menu-list', not `bmkx-list-surreptitiously-rebuild-list'.
;; 8. Return the bookmark.
;;
(defun bmkx-store (bookmark-name data no-overwrite &optional no-refresh-p no-msg-p)
  "Store the bookmark named BOOKMARK-NAME, giving it DATA.
Return the new bookmark.

DATA is the bookmark record without its name, i.e., what
`bmkx-bookmark-data-from-record' returns.

If NO-OVERWRITE is non-nil and bookmark BOOKMARK-NAME already exists
in the current bookmark list (`bookmark-alist') then record the new
bookmark but do not discard the old one.  The check for existence uses
`bmkx-get-bookmark-in-alist'.

Non-nil optional arg NO-REFRESH-P means do not refresh/rebuild the
bookmark-list display.

Non-nil optional arg NO-MSG-P means do not show progress messages.

Note: In spite of the function name, like all functions that define or
change bookmarks, this function does not necessarily save your
bookmark file.  Saving the file depends on `bookmark-save-flag'."
  (bmkx-maybe-load-default-file)
  (let ((bname  (copy-sequence bookmark-name))
        bmk)
    (set-text-properties 0 (length bname) () bname)
    (cond ((and no-overwrite  (bmkx-get-bookmark-in-alist bname 'NOERROR))
           ;; Phase 2: enforce unique names.  When the caller does not want to
           ;; overwrite and BNAME already exists, auto-disambiguate the new one
           ;; (foo -> foo<2> -> foo<3> ...) so each record has a unique name.
           (setq bname  (bmkx-make-unique-name bname))
           (push (setq bmk  (cons bname data)) bookmark-alist))
          ((not (setq bmk  (bmkx-get-bookmark-in-alist bname 'NOERROR)))
           (push (setq bmk  (cons bname data)) bookmark-alist)) ; Add new bookmark.
          (t                            ; Overwrite existing bookmark.
           (bmkx-set-name bmk bname)
           (when (and (boundp 'bookmark-set-fringe-mark)  bookmark-set-fringe-mark) ; Emacs 28+
             (bookmark--remove-fringe-mark bmk))
           (setcdr bmk data)))
    (bmkx-maybe-save-bookmarks)
    ;; These two are the same as `add-to-list' with `EQ' (not available for Emacs 20-21).
    (unless (memq bmk bmkx-modified-bookmarks)
      (setq bmkx-modified-bookmarks  (cons bmk bmkx-modified-bookmarks)))
    (when (and (boundp 'bmkx-setting-automatic-bmk-p)  (not (memq bmk bmkx-automatic-bookmarks)))
      (setq bmkx-automatic-bookmarks  (cons bmk bmkx-automatic-bookmarks)))
    (setq bookmark-current-bookmark  bname)
    (unless no-refresh-p (bmkx-refresh/rebuild-menu-list bmk no-msg-p))
    bmk))                               ; Return the bookmark.


;; Differences from built-in `bookmark.el':
;;
;; Mention `C-c C-M-c', not `C-c C-c'.
;;
;;;###autoload (autoload 'bmkx-default-annotation-text "bookmark-x")
(defun bmkx-default-annotation-text (bookmark-name)
  "Return default annotation text for BOOKMARK-NAME.
The default annotation text is simply some text explaining how to use
annotations."
  (concat "#  Type the annotation for bookmark `" bookmark-name "' here.\n"
          "#  All lines that start with a `#' will be deleted.\n"
          "#  Type `C-c C-M-c' when done.\n#\n"
          "#  Author: " (user-full-name) " <" (user-login-name) "@"
          (system-name) ">\n"
          "#  Date:    " (current-time-string) "\n"))


;; Differences from built-in `bookmark.el' (Emacs 24.4+):
;;
;; Usable for older Emacs versions also.
;;
;;;###autoload (autoload 'bmkx-insert-annotation "bookmark-x")
(defun bmkx-insert-annotation (bookmark)
  "Insert annotation for BOOKMARK.
BOOKMARK is a bookmark name or a bookmark record."
  (setq bookmark  (bmkx-bookmark-name-from-record (bmkx-get-bookmark-in-alist bookmark)))
  (insert (funcall (if (boundp 'bookmark-edit-annotation-text-func)
                       bookmark-edit-annotation-text-func
                     bookmark-read-annotation-text-func)
                   bookmark))
  (let ((annotation  (bookmark-get-annotation bookmark)))
    (when (and annotation  (not (string-equal annotation ""))) (insert annotation))))


;; Differences from built-in `bookmark.el':
;;
;; 1. Derive from value of option `bmkx-annotation-modes-inherit-from'.
;; 2. First, remove parent map from `bmkx-edit-annotation-mode-map', so it is derived anew.
;; 3. Corrected typo in doc string: *send-EDITED-*.
;; 4. Need to use `eval', to pick up option value and reset parent keymap.
;; 5. Bind `C-x C-q' to `bmkx-show-this-annotation-read-only'.
;;
;;;###autoload (autoload 'bmkx-edit-annotation-mode "bookmark-x")
(eval
 `(progn
   ;; Get rid of default parent, so `bmkx-annotation-modes-inherit-from' is used for the map.
   (when (and (boundp 'bmkx-edit-annotation-mode-map)
              (keymapp bmkx-edit-annotation-mode-map))
     (set-keymap-parent bmkx-edit-annotation-mode-map nil))
   (define-derived-mode bmkx-edit-annotation-mode ,bmkx-annotation-modes-inherit-from
       "Edit Bookmark Annotation"
     "Mode for editing the annotation of a bookmark.
When you have finished composing, use `C-c C-M-c'.

\\{bmkx-edit-annotation-mode-map}")
    (define-key bmkx-edit-annotation-mode-map (kbd "C-x C-q")    'bmkx-show-this-annotation-read-only)
    ;; Define this key because Org mode co-opts `C-c C-c' as a prefix key.
    (define-key bmkx-edit-annotation-mode-map (kbd "C-c C-M-c") 'bmkx-send-edited-annotation)))

(define-derived-mode bmkx-show-annotation-mode bmkx-edit-annotation-mode
    "Show Bookmark Annotation"
  "Mode for displaying the annotation of a bookmark.

\\{bmkx-show-annotation-mode-map}"
  (setq buffer-read-only  t)
  (define-key bmkx-show-annotation-mode-map (kbd "C-x C-q") 'bmkx-edit-this-annotation))


;; Differences from built-in `bookmark.el':
;;
;; 1. Record an empty annotation as nil, not "".
;; 2. BUG fix: Put point back where it was (on the bookmark just annotated).
;; 3. Refresh menu list, to pick up the `a' marker.
;; 4. Make sure it's the annotation buffer that gets killed.
;; 5. Delete window also, if `misc-cmds.el' loaded.
;;
;;;###autoload (autoload 'bmkx-send-edited-annotation "bookmark-x")
(defun bmkx-send-edited-annotation () ; Bound to `C-c C-M-c' in `bmkx-edit-annotation-mode'.
  "Use buffer contents as annotation for a bookmark.
Lines beginning with `#' are ignored."
  (interactive)
  (unless (derived-mode-p 'bmkx-edit-annotation-mode)
    (error "Not in mode derived from `bmkx-edit-annotation-mode'"))
  (goto-char (point-min))
  (while (< (point) (point-max)) (if (= (following-char) ?#) (bookmark-kill-line t) (forward-line 1)))
  (let ((annotation      (buffer-substring-no-properties (point-min) (point-max)))
        (bookmark        bookmark-annotation-name)
        (annotation-buf  (current-buffer)))
    (when (string= annotation "") (setq annotation  nil))
    (bookmark-set-annotation bookmark annotation)
    (bookmark-update-last-modified bookmark)
    (setq bookmark-alist-modification-count  (1+ bookmark-alist-modification-count))
    (bmkx-refresh/rebuild-menu-list bookmark) ; So display `a' and `*' markers (updated).
    (if (fboundp 'kill-buffer-and-its-windows)
        (kill-buffer-and-its-windows annotation-buf) ; Defined in `misc-cmds.el'.
      (kill-buffer annotation-buf))))


;; Differences from built-in `bookmark.el':
;;
;; 1. Make it a command (added `interactive' spec).  Prefix arg means add or edit (choose any bookmark).
;; 2. Manage buffer-modified-p.
;; 3. Emacs 26+: Added ignored &rest arg to accommodate built-in Emacs fix to bug #20150 (not a bug for us).
;;
;;;###autoload (autoload 'bmkx-edit-annotation "bookmark-x")
(defun bmkx-edit-annotation (bookmark &rest _IGNORED) ; Bound to `C-x x a e'
  "Pop up a buffer for editing bookmark BOOKMARK's annotation.
Interactively, you are prompted for the bookmark name.  With a prefix
arg, you can choose any bookmark.  Otherwise, only annotated bookmarks
are candidates.

Non-interactively, BOOKMARK is a bookmark name or a bookmark record."
  (interactive
   (let ((alist  (bmkx-annotated-alist-only)))
     (list (bmkx-completing-read (format "%s annotation for bookmark"
                                             (if current-prefix-arg "Add or edit" "Edit"))
                                     (bmkx-default-bookmark-name alist)
                                     alist
                                     nil
                                     nil
                                     (not current-prefix-arg)))))
  (pop-to-buffer (generate-new-buffer-name "*Bookmark Annotation Compose*"))
  (bmkx-insert-annotation bookmark)
  (bmkx-edit-annotation-mode)
  (setq bookmark-annotation-name  bookmark))


(defun bmkx-all-names (&optional alist)
  "Return a list of all bookmark names in ALIST (default `bookmark-alist').
Calls `bmkx-maybe-load-default-file' first.  Like the built-in
`bookmark-all-names', plus an optional ALIST arg."
  (bmkx-maybe-load-default-file)
  (mapcar #'bmkx-bookmark-name-from-record (or alist  bookmark-alist)))


;; Differences from built-in `bookmark.el':
;;
;; 1. Added optional args ALIST, PRED, and HIST.
;; 2. Use helper function `bmkx-completing-read-1', which does this:
;;    (a) binds `icicle-delete-candidate-object' to (essentially) `bmkx-delete'.
;;    (b) forces you to enter a non-empty name, if DEFAULT is nil or "".
;;
(defun bmkx-completing-read (prompt &optional default alist pred hist use-nil-alist-p)
  "Read a bookmark name, prompting with PROMPT.
PROMPT is automatically suffixed with \": \", so do not include that.

DEFAULT is a string or a list of strings.  If the user input is empty
then return the string (or the first string in the list).  If DEFAULT
is nil (absent) then return \"\" for empty input.

The bookmark alist argument used for completion is optional arg ALIST.
If USE-NIL-ALIST-P is nil, then ALIST defaults to `bookmark-alist'.

Optional arg PRED is a predicate used for completion.

Optional arg HIST is a history variable for completion.  Default is
 `bookmark-history'.

Non-nil optional arg USE-NIL-ALIST-P means do not default ALIST to
`bookmark-alist': if ALIST is nil then there are no bookmark
candidates.

If you access this function from a menu, then, depending on the value
of option `bmkx-menu-popup-max-length' and the number of
bookmarks in ALIST, you choose the bookmark using a menu or using
completion."
  (bmkx-completing-read-1 prompt default alist pred hist nil use-nil-alist-p))


;; Differences from built-in `bookmark.el':
;;
;; 1. Handles also regions and non-file buffers.
;; 2. Do not use NO-CONTEXT or POSN if < Emacs 24.
;;
(defun bmkx-make-record-default (&optional no-file no-context position visits no-region)
  "Return the record describing the location of a new bookmark.
Point must be where the bookmark is to be set.

Non-nil NO-FILE means return only the subset of the record that
 pertains to the location within the buffer (not also the file name).

Non-nil NO-CONTEXT means do not include the front and rear context
strings in the record enough.

Non-nil POSITION means record it, not point, as the `position' entry.

Non-nil VISITS means record it as the `visits' entry.

Non-nil NO-REGION means do not include the region end, `end-position'."
    (let* ((dired-p  (and (boundp 'dired-buffers)  (car (rassq (current-buffer) dired-buffers))))
         (buf      (buffer-name))
         (ctime    (current-time))

         ;; Begin `let*' dependencies.
         (regionp  (and transient-mark-mode  mark-active  (> (region-end) (region-beginning))))
         (beg      (if regionp (region-beginning) (or position  (point))))
         (end      (if regionp (region-end) (point)))
         (fcs      (and (not no-context)  (if regionp
                                              (bmkx-position-post-context-region beg end)
                                            (bmkx-position-post-context beg))))
         (rcs      (and (not no-context)  (if regionp
                                              (bmkx-position-pre-context-region beg)
                                            (bmkx-position-pre-context beg))))
         (fcrs     (and (not no-context)  regionp  (bmkx-end-position-pre-context beg end)))
         (ecrs     (and (not no-context)  regionp  (bmkx-end-position-post-context end))))
    `(,@(unless no-file
          `((filename . ,(cond ((buffer-file-name) (bookmark-buffer-file-name))
                               (dired-p            nil)
                               (t                  bmkx-non-file-filename)))))
      (buffer-name . ,buf)
      ,@(unless no-context `((front-context-string . ,fcs)))
      ,@(unless no-context `((rear-context-string . ,rcs)))
      ,@(unless no-context `((front-context-region-string . ,fcrs)))
      ,@(unless no-context `((rear-context-region-string  . ,ecrs)))
      (id       . ,(bmkx-generate-id))
      (visits   . ,(or visits  0))
      ,@(and visits  `((last-visited . ,ctime)))
      (created  . ,ctime)
      (last-modified . ,ctime)
      (position . ,beg)
      ,@(when (and regionp  (not no-region)) `((end-position . ,end))))))


;; Differences from built-in `bookmark.el':
(defun bmkx-alist-from-buffer ()
  "Read and return a bookmark list (in any format) from the current buffer.
Point is irrelevant and unaffected."
  (let ((bmks  (save-excursion
                 (goto-char (point-min))
                 (if (search-forward bookmark-end-of-version-stamp-marker nil t)
                     (condition-case err
                         (read (current-buffer))
                       (error (error "Cannot read definitions in bookmark file:  %s"
                                     (error-message-string err))))
                   ;; Else we're dealing with format version 0
                   (if (search-forward "(" nil t)
                       (progn (forward-char -1)
                              (condition-case err
                                  (read (current-buffer))
                                (error (error "Cannot read definitions in bookmark file:  %s"
                                              (error-message-string err)))))
                     ;; Else no hope of getting information here.
                     (error "Buffer is not in bookmark-list format"))))))
    ;; Put full bookmark on bookmark names as property `bmkx-full-record'.
    ;; Do this regardless of Emacs version and `bmkx-propertize-bookmark-names-flag'.
    ;; If property needs to be stripped, that will be done when saving.
    bmks))


;; Differences from built-in `bookmark.el':
;;
;;  1. Use `bmkx-make-record'.
;;  2. Use special default prompts for active region, EWW, W3M, and Gnus.
;;  3. Use function `bmkx-new-bookmark-default-names', in addition to the name that
;;     `bmkx-make-record' comes up with, as the list of default values.
;;  4. Use `bmkx-completing-read-lax', choosing from current buffer's bookmarks.
;;  5. Numeric prefix arg (diff from plain): all bookmarks as completion candidates.
;;  6. Ask for confirmation if (a) not plain `C-u' and (b) NAME names an existing bookmark.
;;  7. Do not overwrite properties listed in option `bmkx-properties-to-keep'.
;;  8. Added optional args INTERACTIVEP and NO-REFRESH-P.
;;  9. Prompt for tags if `bmkx-prompt-for-tags-flag' is non-nil.
;; 10. Possibly highlight bookmark and other bookmarks in buffer, per `bmkx-auto-light-when-set'.
;; 11. Make bookmark temporary, if `bmkx-autotemp-bookmark-predicates' says to.
;; 12. Run `bmkx-after-set-hook'.
;;
;;;###autoload (autoload 'bmkx-set "bookmark-x")
(defun bmkx-set (&optional name parg interactivep no-refresh-p) ; `C-x r M', `C-x x c M'
  "Set a bookmark named NAME, then run `bmkx-after-set-hook'.
If the region is active (`transient-mark-mode') and nonempty, then
record the region limits in the bookmark.

If NAME is nil, then prompt for the bookmark name.  The default names
for prompting are as follows (in order of priority):

 * If in W3M mode, then the current W3M title.

 * If in a Gnus mode, then the Gnus summary article header.

 * If on a `man' page, then the page name (command and section).

 * If the region is active and nonempty, then the buffer name followed
   by \": \" and the region prefix (up to
   `bmkx-bookmark-name-length-max' chars).

 * The names defined by option `bmkx-new-bookmark-default-names'.

 * The value of variable `bookmark-current-bookmark', the name of the
   last-used bookmark for the current file.

 * The value returned by function `bookmark-buffer-name'.

All of the names described above are available as default values,
by repeating `M-n'.

While entering a bookmark name at the prompt:

 * You can use (lax) completion against bookmarks in the same buffer.
   If there are no bookmarks in the current buffer, then all bookmarks
   are completion candidates.  (See also below, about a numeric prefix
   argument.)

 * You can use `C-M-w' to yank words from the buffer to the
   minibuffer.  Repeating `C-M-w' yanks successive words (newlines
   between yanked words are stripped out).

 * You can use `C-M-u' to insert the name of the last bookmark used in
   the buffer.  This can be useful as an aid to track your progress
   through a large file.  (If no bookmark has yet been used, then
   `C-M-u' inserts the name of the visited file.)

A prefix argument changes the behavior as follows:

 * Numeric prefix arg: Use all bookmarks as completion candidates,
   instead of just the bookmarks for the current buffer.

 * Plain prefix arg (`C-u'): Do not overwrite a bookmark that has the
   same name as NAME, if such a bookmark already exists.  Instead,
   push the new bookmark onto the bookmark alist.

   For use by built-in Emacs, only the most recently set bookmark named
   NAME is in effect at any given time, but any others named NAME can
   become available, should you decide to delete the most recent one.

   For Bookmark-X, if option `bmkx-propertize-bookmark-names-flag' is
   non-`nil' then you can use any number of bookmarks that have the
   same name.  If that option is `nil' then the behavior is the same
   as for built-in Emacs.

Bookmark properties listed in option `bmkx-properties-to-keep' are not
overwritten when you set an existing bookmark.  Their existing values
are kept.  Other properties may be updated.  Properties such as
`position' and `visits' are typically updated, for example, to record
the new position and the number of visits.

Use `\\[bmkx-delete]' to remove bookmarks (you give it a name, and it removes
only the first instance of a bookmark with that name from the list of
bookmarks).

From Lisp code:

* Non-nil INTERACTIVEP means the user can be prompted for
  confirmation, tags, etc., and it is used for the call to
  `bmkx-store'.

* Non-nil NO-REFRESH-P is also passed to `bmkx-store'.  It means
  do not refresh/rebuild the bookmark-list display."
  (interactive (list nil current-prefix-arg t))
  (unwind-protect
      (progn
        (bmkx-maybe-load-default-file)
        (setq bookmark-current-point   (point)) ; `bookmark-current-point' is a free var here.
        ;; Do not set these if they are already set in some other buffer (e.g gnus-art).
        (unless (and bookmark-yank-point  bookmark-current-buffer)
          (save-excursion (skip-chars-forward " ") (setq bookmark-yank-point  (point)))
          (setq bookmark-current-buffer  (current-buffer)))
        (let* ((record   (bmkx-make-record))
               (defname  (cond ((and (eq major-mode 'eww-mode)
                                     (fboundp 'bmkx-make-eww-record) ; Emacs 25+
                                     (bmkx-eww-title)))
                               ((eq major-mode 'gnus-summary-mode) (elt (gnus-summary-article-header) 1))
                               ((memq major-mode '(Man-mode woman-mode))
                                (buffer-substring (point-min) (save-excursion (goto-char (point-min))
                                                                              (skip-syntax-forward "^ ")
                                                                              (point))))
                               (t nil)))
               (defname  (and defname  (bmkx-replace-regexp-in-string "\n" " " defname)))
               (bname    (or name  (bmkx-completing-read-lax
                                    "Set bookmark"
                                    (bmkx-new-bookmark-default-names defname)
                                    (and (or (not parg)  (consp parg)) ; No numeric PARG: all bookmarks.
                                         (bmkx-specific-buffers-alist-only))
                                    nil 'bookmark-history (or (not parg)  (consp parg))))))
          ;; BNAME should not be "" now, since `bmkx-new-bookmark-default-names' should provide default(s)
          ;; and empty input to `bmkx-completing-read-lax' returns the default.  But just in case...
          (when (and (string= bname "")  defname) (setq bname  defname))
          (while (string= "" bname)
            (message "Enter a NON-EMPTY bookmark name") (sit-for 2)
            (setq bname  (bmkx-completing-read-lax
                          "Set bookmark"
                          (bmkx-new-bookmark-default-names defname)
                          (and (or (not parg)  (consp parg)) ; No numeric PARG: all bookmarks.
                               (bmkx-specific-buffers-alist-only))
                          nil 'bookmark-history (or (not parg)  (consp parg)))))
          (let ((old-bmk  (bmkx-get-bookmark-in-alist bname 'NOERROR)))
            (when (and interactivep  bmkx-bookmark-set-confirms-overwrite-p  (atom parg)  old-bmk
                       (not (y-or-n-p (format "Overwrite bookmark `%s'? " bname))))
              (error "OK, canceled"))
            (when old-bmk ; Restore props of existing bookmark per `bmkx-properties-to-keep'.
              (dolist (prop  bmkx-properties-to-keep)
                (bmkx-prop-set record prop (bookmark-prop-get old-bmk prop)))))
          ;; Maybe make bookmark temporary.
          ;; Pass RECORD, not BNAME, so `bmkx-prop-set' DTRT in `bmkx-make-bookmark-temporary'.
          (if bmkx-autotemp-all-when-set-p
              (bmkx-make-bookmark-temporary record)
            (catch 'bmkx-set
              (dolist (pred  bmkx-autotemp-bookmark-predicates)
                (when (and (functionp pred)  (funcall pred bname))
                  (bmkx-make-bookmark-temporary record)
                  (throw 'bmkx-set t)))))
          ;; `bmkx-store' may auto-disambiguate (foo -> foo<2>) when
          ;; (consp parg) is non-nil and `bname' collides.  Update local
          ;; `bname' to the stored bookmark's actual name so subsequent
          ;; tag / light / annotate calls reference the right record.
          (setq bname  (car (bmkx-store bname (cdr record) (consp parg)
                                            no-refresh-p (not interactivep))))
          (when (and interactivep  bmkx-prompt-for-tags-flag)
            (bmkx-add-tags bname (bmkx-read-tags-completing) 'NO-UPDATE-P)) ; Do not update here.
          (cl-case (and (boundp 'bmkx-auto-light-when-set)  bmkx-auto-light-when-set)
            (autonamed-bookmark       (when (bmkx-autonamed-bookmark-p bname)
                                        (bmkx-light-bookmark bname)))
            (non-autonamed-bookmark   (unless (bmkx-autonamed-bookmark-p bname)
                                        (bmkx-light-bookmark bname)))
            (any-bookmark             (bmkx-light-bookmark bname))
            (autonamed-in-buffer      (bmkx-light-bookmarks (bmkx-autonamed-this-buffer-alist-only)
                                                            nil interactivep))
            (non-autonamed-in-buffer  (bmkx-light-bookmarks
                                       (bmkx-remove-if #'bmkx-autonamed-this-buffer-bookmark-p
                                                       (bmkx-this-buffer-alist-only))
                                       nil interactivep))
            (all-in-buffer            (bmkx-light-this-buffer nil interactivep)))
          (run-hooks 'bmkx-after-set-hook)
          (if bookmark-use-annotations
              (bmkx-edit-annotation bname)
            (goto-char bookmark-current-point))) ; `bookmark-current-point' is a free var here.
        (when (and (boundp 'bookmark-set-fringe-mark)  bookmark-set-fringe-mark) ; Emacs 28+
          (bookmark--set-fringe-mark)))
    (setq bookmark-yank-point     nil
          bookmark-current-buffer nil)))


(defun bmkx-set-name (bookmark newname)
  "Set name of BOOKMARK to NEWNAME.
BOOKMARK is a bookmark name (a string) or a bookmark record.
Adds BOOKMARK to `bmkx-modified-bookmarks' so it will be saved on
the next bookmark-file write."
  (setq bookmark  (bookmark-get-bookmark bookmark))
  (setcar bookmark newname)
  (unless (memq bookmark bmkx-modified-bookmarks)
    (setq bmkx-modified-bookmarks  (cons bookmark bmkx-modified-bookmarks))))


;;;###autoload (autoload 'bmkx-yank-word "bookmark-x")
(defun bmkx-yank-word ()                ; Bound to `C-M-w' in minibuffer when setting a bookmark.
  "Yank the word at point in `bookmark-current-buffer'.
Repeat to yank consecutive words from the current buffer, appending
them to the minibuffer.  Newline characters between yanked words are
stripped out."
  (interactive)
  (let ((string  (with-current-buffer bookmark-current-buffer
                   (goto-char bookmark-yank-point)
                   (buffer-substring-no-properties (point)
                                                   (progn (forward-word 1)
                                                          (setq bookmark-yank-point  (point)))))))
    (setq string  (replace-regexp-in-string "\n" "" string))
    (insert string)))


;; Differences from built-in `bookmark.el':
;;
;; 1. Separate renaming of obsolete default bookmark name (do it even if not loading the default file).
;; 2. Load `bmkx-last-as-first-bookmark-file' if it is non-nil.
;; 3. Use `bmkx-bookmarks-already-loaded', not `bookmarks-already-loaded' (Emacs < 27).
;; 4. Don't use/support `bookmark-watch-bookmark-file' (Emacs 27+).
;;
(defun bmkx-maybe-load-default-file ()
  "If bookmarks have not yet been loaded, load them.
If `bmkx-last-as-first-bookmark-file' is non-nil, load it.
Otherwise, load `bookmark-default-file'."
  ;; The Emacs-27 one-time migration from `bookmark-old-default-file' to
  ;; `bookmark-default-file' was removed when this fork dropped support for
  ;; Emacs < 30.  Anyone on Emacs 30+ has already migrated.
  (let ((file-to-load  (bmkx-default-bookmark-file)))
    (and (not bmkx-bookmarks-already-loaded)
         (null bookmark-alist)
         (file-readable-p file-to-load)
         (bmkx-load file-to-load t 'nosave)
         (setq bmkx-bookmarks-already-loaded  t))))


;; Differences from built-in `bookmark.el':
;;
;; 1. Save DISPLAY-FUNCTION to `bmkx-jump-display-function' before calling `bmkx-handle-bookmark'.
;; 2. Update the name and position of an autonamed bookmark, in case it moved.
;; 3. Possibly highlight bookmark and other bookmarks in buffer, per `bmkx-auto-light-when-jump'.
;; 4. Added `catch', so a handler can throw to skip the rest of the processing if it wants.
;;
(defun bmkx--jump-via (bookmark display-function)
  "Display BOOKMARK using DISPLAY-FUNCTION.
Then run `bookmark-after-jump-hook' and show annotations for BOOKMARK.
BOOKMARK is a bookmark name or a bookmark record.
DISPLAY-FUNCTION is as in `bmkx-jump'."
  (bmkx-record-visit bookmark 'BATCHP)
  (setq bmkx-jump-display-function  display-function)
  (catch 'bmkx--jump-via
    (let* ((had-handler   (or (bookmark-prop-get bookmark 'file-handler)
                              (bookmark-get-handler bookmark)))
           ;; Snapshot the originating window's buffer before the
           ;; handler runs so we can detect (and undo) in-place
           ;; clobbers.
           (orig-window   (and had-handler  display-function (selected-window)))
           (orig-buffer   (and orig-window  (window-buffer orig-window))))
      (bmkx-handle-bookmark bookmark)
      ;; Custom handlers diverge on where they leave things:
      ;;
      ;; A. Some (e.g. `find-file' inside many handlers) call
      ;;    `switch-to-buffer', which clobbers the originating
      ;;    window's buffer in place regardless of the caller's
      ;;    `display-buffer-overriding-action'.
      ;; B. Some (e.g. `org-goto-marker-or-bmk', which calls
      ;;    `pop-to-buffer-same-window') honour the overriding
      ;;    action and display the destination in a different
      ;;    window themselves.
      ;; C. Some (e.g. `pdf-view-bookmark-jump-handler') only
      ;;    `set-buffer' the destination and leave displaying to
      ;;    the caller.
      ;;
      ;; The built-in `bookmark--jump-via' assumes case C and
      ;; unconditionally calls the display function.  That gives us
      ;; a double display in case B (the second one steals a
      ;; different window from somewhere -- e.g. `*Bmkx List*' --
      ;; and overlays the destination there) and a wrongly-clobbered
      ;; origin in case A.
      ;;
      ;; Discriminate:
      (when (and had-handler  display-function)
        (cond
         ;; Case A: handler clobbered orig-window in place.
         ((and orig-window
               (window-live-p orig-window)
               (buffer-live-p orig-buffer)
               (not (eq (window-buffer orig-window) orig-buffer)))
          (set-window-buffer orig-window orig-buffer)
          (funcall display-function (current-buffer)))
         ;; Case B: handler already displayed the destination in
         ;; some window.  Trust it.
         ((get-buffer-window (current-buffer) t))
         ;; Case C: handler only set-buffer'd.  Display now.
         (t (funcall display-function (current-buffer))))))
    (unless (and bmkx-use-w32-browser-p  (fboundp 'w32-browser)  (bookmark-get-filename bookmark))
      (let ((win  (get-buffer-window (current-buffer) 0)))
        (when win (set-window-point win (point))))
      ;; If this is an autonamed bookmark, update its name and position, in case it moved.
      ;; But don't do this if we're using w32, since we might not have moved to the bookmark position.
      (when (and (bmkx-autonamed-bookmark-for-buffer-p bookmark (buffer-name))
                 (not bmkx-use-w32-browser-p))
        (setq bookmark  (bmkx-update-autonamed-bookmark bookmark)))
      (cl-case (and (boundp 'bmkx-auto-light-when-jump)  bmkx-auto-light-when-jump)
        (autonamed-bookmark       (when (bmkx-autonamed-bookmark-p bookmark)
                                    (bmkx-light-bookmark bookmark nil nil nil 'USE-POINT)))
        (non-autonamed-bookmark   (unless (bmkx-autonamed-bookmark-p bookmark)
                                    (bmkx-light-bookmark bookmark nil nil nil 'USE-POINT)))
        (any-bookmark             (bmkx-light-bookmark bookmark nil nil nil 'USE-POINT))
        (autonamed-in-buffer      (bmkx-light-bookmarks
                                   (bmkx-remove-if-not #'bmkx-autonamed-bookmark-p
                                                       (bmkx-this-buffer-alist-only))
                                   nil 'MSG))
        (non-autonamed-in-buffer  (bmkx-light-bookmarks (bmkx-remove-if #'bmkx-autonamed-bookmark-p
                                                                        (bmkx-this-buffer-alist-only))
                                                        nil 'MSG))
        (all-in-buffer            (bmkx-light-this-buffer nil 'MSG))))
    ;; $$$$$$ Not sure we should place the built-in fringe mark in this case.  Try it for a while
    (when (and (boundp 'bookmark-set-fringe-mark)  bookmark-set-fringe-mark) ; Emacs 28+
      (let ((overlays  (overlays-in (pos-bol) (1+ (pos-bol))))
            temp found)
        (while (and (not found)  (setq temp  (pop overlays)))
          (when (eq 'bookmark (overlay-get temp 'category)) (setq found  t)))
        (unless found (bookmark--set-fringe-mark))))
    (run-hooks 'bookmark-after-jump-hook)
    (let ((jump-fn  (bmkx-get-tag-value bookmark "bmkx-jump")))
      (when jump-fn (funcall jump-fn)))
    (when bookmark-automatically-show-annotations (bmkx-show-annotation bookmark))))


(defun bmkx-prop-set (bookmark prop val &optional _require-name-p)
  "Set the entry (property) PROP of BOOKMARK to VAL.
BOOKMARK is a bookmark name (a string) or a bookmark record.
Adds BOOKMARK to `bmkx-modified-bookmarks' so it will be saved on
the next bookmark-file write.

The 4th argument is accepted for caller compatibility and ignored;
it had meaning only in the previous design that disambiguated
same-named bookmarks via a text property."
  (let* ((bmk   (bmkx-get-bookmark bookmark))
         (cell  (assq prop (bmkx-bookmark-data-from-record bmk))))
    (if cell
        (setcdr cell val)
      (setcdr bmk (if (consp (car (cadr bmk)))
                      (list (cons (cons prop val) (cadr bmk))) ; Old format: ("name" ((filename . "f")...))
                    (cons (cons prop val) (cdr bmk))))) ; New format:        ("name" (filename . "f")...)
    (unless (memq bmk bmkx-modified-bookmarks)
      (setq bmkx-modified-bookmarks  (cons bmk bmkx-modified-bookmarks)))))


;; Differences from built-in `bookmark.el':
;;
;; 1. Added optional arg FLIP-USE-REGION-P.
;; 2. Use `bmkx-default-bookmark-name' as default when interactive.
;; 3. Use `bmkx-jump-1'.
;; 4. Added note about Icicles `S-delete' to doc string.
;;
;;;###autoload (autoload 'bmkx-jump "bookmark-x")
(defun bmkx-jump (bookmark          ; Bound to `C-x j j', `C-x r b', `C-x x g'
                      &optional display-function flip-use-region-p)
  "Jump to bookmark BOOKMARK.
You may have a problem using this function if the value of variable
`bookmark-alist' is nil.  If that happens, you need to load in some
bookmarks.  See function `bmkx-load' for more about this.

If the file pointed to by BOOKMARK no longer exists, you are asked if
you wish to give the bookmark a new location.  If so, `bmkx-jump'
jumps to the new location and saves it.

If the bookmark defines a region, then the region is activated if
`bmkx-use-region' is not-nil or it is nil and you use a prefix
argument.  A prefix arg temporarily flips the value of
`bmkx-use-region'.

In Lisp code:
BOOKMARK is a bookmark name or a bookmark record.
Non-nil DISPLAY-FUNCTION is a function to display the bookmark.  By
 default, use `pop-to-buffer-same-window'.
Non-nil FLIP-USE-REGION-P flips the value of `bmkx-use-region'."
  (interactive (list (bmkx-read-bookmark-for-jump "Jump to bookmark" (bmkx-default-bookmark-name))
                     nil
                     current-prefix-arg))
  (bmkx-jump-1 bookmark (or display-function  'bmkx--pop-to-buffer-same-window) flip-use-region-p))


;; Differences from built-in `bookmark.el':
;;
;; 1. Added optional arg FLIP-USE-REGION-P.
;; 2. Use `bmkx-default-bookmark-name' as default when interactive.
;; 3. Use `bmkx-jump-1'.
;;
;;;###autoload (autoload 'bmkx-jump-other-window "bookmark-x")
(defun bmkx-jump-other-window (bookmark &optional flip-use-region-p)
                                        ; Bound to `C-x 4 j j', `C-x x j', `C-x x o', `C-x x q'
  "Jump to bookmark BOOKMARK in another window.
See `bmkx-jump', in particular for info about using a prefix arg."
  (interactive (list (bmkx-read-bookmark-for-jump "Jump to bookmark (in another window)"
                                                  (bmkx-default-bookmark-name))
                     current-prefix-arg))
  (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window flip-use-region-p))


;; Differences from built-in `bookmark.el' (Emacs 27+):
;;
;; 1. Added optional arg FLIP-USE-REGION-P.
;; 2. Use `bmkx-default-bookmark-name' as default when interactive.
;; 3. Use `bmkx-jump-1'.
;;
;;;###autoload (autoload 'bmkx-jump-other-frame "bookmark-x")
(defun bmkx-jump-other-frame (bookmark &optional flip-use-region-p) ; Bound to `C-x 5 B'
  "Jump to bookmark BOOKMARK in another frame.
See `bmkx-jump', in particular for info about using a prefix arg."
  (interactive (list (bmkx-read-bookmark-for-jump "Jump to bookmark (in another frame)"
                                                  (bmkx-default-bookmark-name))
                     current-prefix-arg))
  (let ((pop-up-frames  t)) (bmkx-jump-other-window bookmark flip-use-region-p)))


;; Differences from built-in `bookmark.el':
;;
;; 1. Invoke MS Windows `Open' action if `bmkx-use-w32-browser-p' and if `w32-browser' is defined.
;; 2. Favor entry `file-handler' over entry `handler'.  If the former is available, apply it to the file.
;; 3. If BOOKMARK has its own handler but that is not a defined function, then use the default handler.
;;    This lets Emacs 22, for instance, handle Emacs 23+ image bookmarks.
;; 4. Different relocation message for non-file bookmark.
;;
(defun bmkx-handle-bookmark (bookmark)
  "Call BOOKMARK's handler, or `bmkx-default-handler' if it has none.
Return nil or raise an error.

BOOKMARK is a bookmark name or a bookmark record.

More precisely:

  If `bmkx-use-w32-browser-p' is non-`nil' and `w32-browser' is
  defined then invoke the MS Windows `Open' action.

  Else, if BOOKMARK has both `file-handler' and `filename' entries
  then apply the former to the latter.

  Else, if BOOKMARK has a `handler' entry whose value is a defined
  function then apply it to BOOKMARK.

  Else, apply the default bookmark handler,
  `bmkx-default-handler', to BOOKMARK.

The default handler changes the current buffer and point.

If the default handler is used and a file error is raised, the error
is handled as follows:
 If BOOKMARK has no `filename' entry, do nothing.
 Else prompt to relocate the file.
   If relocated, then try again to handle.  Else raise a file error."
  (cond ((and bmkx-use-w32-browser-p  (fboundp 'w32-browser)  (bookmark-get-filename bookmark))
         (w32-browser (bookmark-get-filename bookmark))
         ;; This `throw' is only for the case where this handler is called from `bmkx--jump-via'.
         ;; It tells `bmkx--jump-via' to skip the rest of what it does after calling the handler.
         (condition-case nil (throw 'bmkx--jump-via 'BOOKMARK-HANDLE-BOOKMARK) (no-catch nil)))
        ((functionp (bookmark-prop-get bookmark 'file-handler))
         (funcall (bookmark-prop-get bookmark 'file-handler) (bookmark-get-filename bookmark)))
        ((functionp (bookmark-get-handler bookmark))
         (funcall (bookmark-get-handler bookmark) (bmkx-get-bookmark bookmark)))
        (t
         (condition-case err
             (funcall 'bmkx-default-handler (bmkx-get-bookmark bookmark))
           (bookmark-error-no-filename  ; `file-error'
            ;; BOOKMARK can be either a bookmark name or a bookmark record.
            ;; If a record, do nothing - assume it is a bookmark used internally by some other package.
            (when (stringp bookmark)
              (let ((file             (bookmark-get-filename bookmark))
                    (use-dialog-box   nil)
                    (use-file-dialog  nil))
                (when file
                  ;; Ask user whether to relocate the file.  If no, signal the file error.
                  (unless (string= file bmkx-non-file-filename) (setq file  (expand-file-name file)))
                  (ding)
                  (cond ((y-or-n-p (if (and (string= file bmkx-non-file-filename)
                                            (bmkx-get-buffer-name bookmark))
                                       "Bookmark's buffer does not exist.  Re-create it? "
                                     (concat (file-name-nondirectory file) " nonexistent.  Relocate \""
                                             bookmark "\"? ")))
                         (if (string= file bmkx-non-file-filename)
                             ;; This is probably not the right way to get the correct buffer, but it's
                             ;; better than nothing, and it gives the user a chance to DTRT.
                             (pop-to-buffer (bmkx-get-buffer-name bookmark)) ; Create buffer.
                           (bmkx-relocate bookmark)) ; Relocate to file.
                         (funcall (or (bookmark-get-handler bookmark)  'bmkx-default-handler)
                                  (bmkx-get-bookmark bookmark))) ; Try again
                        (t
                         (message "Bookmark not relocated: `%s'" bookmark)
                         (signal (car err) (cdr err)))))))))))
  (when (stringp bookmark) (setq bookmark-current-bookmark  bookmark))
  ;; $$$$$$ The built-in code returns nil, but there is no explanation of why and no code seems
  ;; to use the return value.  Perhaps we should return the bookmark instead?
  nil)                                  ; Return nil if no error.

(put 'bookmark-error-no-filename 'error-conditions
     '(error bookmark-errors bookmark-error-no-filename))
(put 'bookmark-error-no-filename 'error-message "Bookmark has no associated file (or directory)")


;; Differences from built-in `bookmark.el':
;;
;; 1. Use `bmkx-get-bookmark' instead of `bookmark-get-bookmark', so we can get the right bookmark if
;;    it has a name with property `bmkx-full-record'.
;; 2. Support regions, buffer names, and entry `file-handler'.
;; 3. Handle MS Windows `Open' command if `bmkx-use-w32-browser-p' and if `w32-browser' is defined.
;;
(defun bmkx-default-handler (bookmark)
  "Default handler to jump to the location of BOOKMARK.
Return nil (or raise an error).

BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'.

If `bmkx-use-w32-browser-p' is non-nil and function `w32-browser' is
defined, then call `w32-browser'.  That is, use the default MS Windows
application for the bookmarked file.

If BOOKMARK has entries `file-handler' and `filename', then apply the
value of the former to the latter.

If BOOKMARK is an old-style Info bookmark, then go to the Info node.

If BOOKMARK records a nonempty region and `bmkx-use-region' is
 non-nil then activate the region.

Otherwise, call `bmkx-goto-position' to go to the recorded position."
  (let* ((bmk            (bmkx-get-bookmark bookmark))
         (file           (bookmark-get-filename bmk))
         (buf            (bookmark-prop-get bmk 'buffer))
         (bufname        (bmkx-get-buffer-name bmk))
         (pos            (bookmark-get-position bmk))
         (end-pos        (bmkx-get-end-position bmk))
         (old-info-node  (and (not (bookmark-get-handler bookmark))  (bookmark-prop-get bmk 'info-node))))

    (cond ((and bmkx-use-w32-browser-p  (fboundp 'w32-browser)  file)  (w32-browser file))
          ((and (bookmark-prop-get bookmark 'file-handler)  file)
           (funcall (bookmark-prop-get bookmark 'file-handler) file))
          (old-info-node                ; Emacs 20-21 Info bookmarks - no handler entry.
           (progn (require 'info)
                  (Info-find-node file old-info-node)
                  (when pos (goto-char pos))))
          ((not (and bmkx-use-region  pos  end-pos  (/= pos end-pos)))
           ;; Single-position bookmark (no region).  Go to it.
           (bmkx-goto-position bmk file buf bufname pos
                               (bookmark-get-front-context-string bmk)
                               (bookmark-get-rear-context-string bmk)))
          (t
           ;; Bookmark with a region.  Go to it and activate the region.
           (if (and file  (file-readable-p file)  (not (buffer-live-p buf)))
;;; $$$$$$$    (with-current-buffer (let ((enable-local-variables  ())) (find-file-noselect file))
               (with-current-buffer (find-file-noselect file) (setq buf  (buffer-name)))
             ;; No file found.  If no buffer either, then signal that file doesn't exist.
             (unless (or (and buf  (get-buffer buf))
                         (and bufname  (get-buffer bufname)  (not (string= buf bufname))))
               (signal 'bookmark-error-no-filename (list 'stringp file))))
           (set-buffer (or buf  bufname))
           (when bmkx-jump-display-function
             (save-current-buffer (funcall bmkx-jump-display-function (current-buffer)))
             (raise-frame))
           (goto-char (if pos (min pos (point-max)) (point-max)))
           (when (and pos  (> pos (point-max))) (error "Bookmark position is beyond buffer end"))
           ;; Activate region.  Relocate it if it moved.  Save relocated bookmark if confirm.
           (funcall bmkx-handle-region-function bmk)))
    ;; $$$$$$ The built-in code returns nil, but there is no explanation of why and no code seems
    ;; to use the return value.  Perhaps we should return the bookmark instead?
    nil))                               ; Return nil if no file error.


;; Differences from built-in `bookmark.el':
;;
;; 1. Added optional arg NO-REFRESH-P.
;; 2. Added bookmark default for interactive use.
;; 3. Added note about `S-delete' to doc string.
;; 4. Changed arg name: BOOKMARK -> BOOKMARK-NAME.
;; 5. Update Dired location too, for Dired bookmark.
;; 6. Refresh menu list, to show new location.
;;
;;;###autoload (autoload 'bmkx-relocate "bookmark-x")
(defun bmkx-relocate (bookmark-name &optional no-refresh-p) ; Not bound
  "Relocate the bookmark named BOOKMARK-NAME to another file.
You are prompted for the new file name.
Non-nil optional arg NO-REFRESH-P means do not refresh/rebuild the
bookmark-list display.

Changes the file associated with the bookmark.
Useful when a file has been renamed after a bookmark was set in it."
  (interactive (list (bmkx-completing-read "Bookmark to relocate" (bmkx-default-bookmark-name))))
  (bookmark-maybe-historicize-string bookmark-name)
  (bmkx-maybe-load-default-file)
  (let* ((bookmark-filename  (bookmark-get-filename bookmark-name))
         (new-filename       (abbreviate-file-name
                              (expand-file-name
                               (read-file-name
                                (format "Relocate %s to: " bookmark-name)
                                (file-name-directory bookmark-filename))))))
    (bookmark-set-filename bookmark-name new-filename)
    (bookmark-update-last-modified bookmark-name)
    ;; Change location for Dired too, but not if different from original file name (e.g. a cons).
    (let ((dired-dir  (bookmark-prop-get bookmark-name 'dired-directory)))
      (when (and dired-dir  (equal dired-dir bookmark-filename))
        (bmkx-prop-set bookmark-name 'dired-directory new-filename))))
  (bmkx-maybe-save-bookmarks)
  (when (and bookmark-bmenu-toggle-filenames  (get-buffer bmkx-bmenu-buffer)
             (get-buffer-window (get-buffer bmkx-bmenu-buffer) 0)
             (not no-refresh-p))
    (with-current-buffer (get-buffer bmkx-bmenu-buffer) ; Do NOT just use `bmkx-refresh/rebuild-menu-list'.
      (bmkx-refresh-menu-list bookmark-name)))) ; So display new location and `*' marker.


;; Vanilla `bookmark.el' removed this command in Emacs 24.3 (Emacs bug #19838)
;; and has not restored it.  Bookmark-X provides it under its own name.
;;;###autoload (autoload 'bmkx-insert-current-bookmark "bookmark-x")
(defun bmkx-insert-current-bookmark ()
  "Insert current-bookmark name, or buffer file name if none.
If `bookmark-current-bookmark' in `bookmark-current-buffer' is non-nil,
insert that; otherwise insert the buffer's file name."
  (interactive)
  (let ((str  (with-current-buffer bookmark-current-buffer
                (or bookmark-current-bookmark  (bookmark-buffer-name)))))
    (insert str)))


;; Differences from built-in `bookmark.el':
;;
;; 1. Added bookmark default for interactive use.
;; 2. Do not add any text properties here.  That's done in `bmkx-bmenu-propertize-item'.
;; 3. Added note about `S-delete' to doc string.
;; 4. Changed arg name: BOOKMARK -> BOOKMARK-NAME.
;;
;;;###autoload (autoload 'bmkx-insert-location "bookmark-x")
(defun bmkx-insert-location (bookmark-name &optional no-history) ; `C-x x I' (original: `C-x x f')
  "Insert file or buffer name for the bookmark named BOOKMARK-NAME.
If a file is bookmarked, insert the recorded file name.
If a non-file buffer is bookmarked, insert the recorded buffer name.

Optional arg NO-HISTORY means do not record BOOKMARK-NAME in
`bookmark-history'."
  (interactive
   (let ((bmk  (bmkx-completing-read "Insert bookmark location" (bmkx-default-bookmark-name))))
     (list bmk)))
  (unless no-history (bookmark-maybe-historicize-string bookmark-name))
  (insert (bmkx-location bookmark-name))) ; Return the line inserted.


;; Differences from built-in `bookmark.el':
;;
;; 1. The different `bookmark-get-bookmark' behavior from built-in Emacs means we can get the right bookmark
;;    if it has a name with property `bmkx-full-record', without looking it up in `bookmark-alist'.
;;    But we don't require that BOOKMARK have a name, so calls from built-in or other code aren't bothered.
;; 2. Pass full bookmark to the various "get" functions.
;; 3. Location returned can be a buffer name.
;; 4. If both file and buffer names are recorded, respect option `bmkx-bmenu-show-file-not-buffer-flag'.
;;
(defun bmkx-location (bookmark)
  "Return a description of the location of BOOKMARK.
BOOKMARK is a bookmark name or a bookmark record.
If it is a name with text property `bmkx-full-record', or if it is a
bookmark record, then it is NOT looked up in `bookmark-alist' (it need
not belong).  If it is a name without that property then it is looked
up in `bookmark-alist'.

If BOOKMARK records a `location' entry, then use that.

Otherwise, look for buffer and file names.  If only one of those is
recorded then use that.

If both buffer and file name are recorded then respect option
`bmkx-bmenu-show-file-not-buffer-flag': If non-nil then use the file
name, otherwise use the buffer name.

If no `location', buffer, or file name is recorded then use \"--
Unknown location --\"."
  (bmkx-maybe-load-default-file)
  (setq bookmark  (bookmark-get-bookmark bookmark))
  (or (bookmark-prop-get bookmark 'location)
      (if bmkx-bmenu-show-file-not-buffer-flag
          (or (bookmark-get-filename bookmark)
              (bmkx-get-buffer-name bookmark) ; Entry `buffer-name'.
              (bookmark-prop-get bookmark 'buffer)) ; Entry `buffer'.
        (or (bmkx-get-buffer-name bookmark)
            (bookmark-prop-get bookmark 'buffer)
            (bookmark-get-filename bookmark)))
      "-- Unknown location --"))


;; Differences from built-in `bookmark.el':
;;
;; 1. Added BATCHP arg.  Return OLD if BATCHP is non-nil and NEW is nil.
;; 2. Use `bmkx-completing-read-lax', not `read-from-minibuffer', for new name.
;; 3. Put `bmkx-full-record' property on new name.
;; 4. Rename also in marked and omitted lists.
;; 5. Added note about `S-delete' to doc string.
;; 6. Refresh menu list, to show new name.
;;
;;;###autoload (autoload 'bmkx-rename "bookmark-x")
(defun bmkx-rename (old &optional new batchp) ; Not bound in Bookmark-X
  "Change bookmark's name from OLD to NEW.
Interactively:
 If called from the keyboard, then prompt for OLD.
 If called from the menubar, select OLD from a menu.
If NEW is nil, then prompt for its string value (unless BATCH).

When entering the NEW name you can use completion against existing
bookmark names.  This completion is lax, so you can easily edit an
existing name.  See `bmkx-set' for particular keys available
during this input.

If BATCHP is non-nil, then do not rebuild the bookmark list.  (NEW
should be non-nil if BATCH is non-nil.)"
  (interactive (list (bmkx-completing-read "Old bookmark name" (bmkx-default-bookmark-name))))
  (bookmark-maybe-historicize-string old)
  (bmkx-maybe-load-default-file)
  (setq bookmark-current-point  (point)) ; `bookmark-current-point' is a free var here.
  (save-excursion (skip-chars-forward " ") (setq bookmark-yank-point  (point)))
  (setq bookmark-current-buffer  (current-buffer))
  (let ((newname  (or new  (and (not batchp)  (bmkx-completing-read-lax "New name" old)))))
;;; $$$$$$  (read-from-minibuffer "New name: " nil
;;;           (let ((now-map  (copy-keymap minibuffer-local-map)))
;;;             (define-key now-map  (kbd "C-w") 'bmkx-yank-word)
;;;             now-map)
;;;           nil 'bookmark-history))))
    (when newname
      (bmkx-set-name old newname)
      (bookmark-update-last-modified newname)
      (bmkx-rename-for-marked-and-omitted-lists old newname) ; Rename in marked & omitted lists, if present.
      (setq bookmark-current-bookmark  newname)
      (unless batchp
        (if (and (get-buffer bmkx-bmenu-buffer)  (get-buffer-window (get-buffer bmkx-bmenu-buffer) 0))
            (with-current-buffer (get-buffer bmkx-bmenu-buffer)
              (bmkx-refresh-menu-list newname)) ; So the new name is displayed.
          (bmkx-list-surreptitiously-rebuild-list)))
      (bmkx-maybe-save-bookmarks))
    (or newname  old)))                 ; NEWNAME is nil only if BATCHP is non-nil and NEW was nil.


;;;###autoload (autoload 'bmkx-insert "bookmark-x")
(defun bmkx-insert (bookmark-name)       ; Bound to `C-x x i'
  "Insert the text of a bookmarked file.
BOOKMARK-NAME is the name of the bookmark.  Interactively, prompt
with completion (default: `bmkx-default-bookmark-name')."
  (interactive (list (bmkx-completing-read "Insert bookmark contents" (bmkx-default-bookmark-name))))
  (bookmark-insert bookmark-name))


;; Differences from built-in `bookmark.el':
;;
;; 1. Accept a bookmark or a bookmark name as arg.
;; 2. Use `bmkx-default-bookmark-name' as default when interactive.
;; 3. Use `bmkx-get-bookmark' instead of `bookmark-get-bookmark', so we can get the right bookmark if
;;    it has a name with property `bmkx-full-record'.
;; 4. Use `bmkx-get-bookmark-in-alist', not `bookmark-get-bookmark', when checking `bookmark-current-bookmark'.
;; 5. Remove highlighting for the bookmark.
;; 6. Doc string includes note about `S-delete' for Icicles.
;; 7. Update `bmkx-latest-bookmark-alist', `bmkx-bmenu-omitted-bookmarks', and `bmkx-automatic-bookmarks'.
;; 8. Increment `bookmark-alist-modification-count' even when BATCHP is non-nil.
;;
;;;###autoload (autoload 'bmkx-delete "bookmark-x")
(defun bmkx-delete (bookmark &optional batchp) ; Bound to `C-x x d'
  "Delete the BOOKMARK from the bookmark list.
BOOKMARK is a bookmark name or a bookmark record.
Interactively, default to the \"current\" bookmark (that is, the one
most recently used in this file), if it exists.

If BOOKMARK is a name and it has property `bmkx-full-record' then use
that property along with the name to find the bookmark to delete.  If
it is or has a name without property `bmkx-full-record' then
delete (only) the first bookmark in `bookmark-alist' with that name.

Optional arg BATCHP means do not update buffer `*Bmkx List*'.
In this way, you can delete multiple bookmarks."
  (interactive (list (bmkx-completing-read "Delete bookmark" (bmkx-default-bookmark-name))))

  ;; $$$$$$ Instead of loading unconditionally, maybe we should just try to delete conditionally?
  ;; IOW, why not (when bmkx-bookmarks-already-loaded BODY) instead of `bmkx-maybe-load-default-file'?
  ;; If it gets called on a hook that gets run before ever loading, then should probably do nothing.
  ;; Leaving it as is for now (2011-04-06).
  (bmkx-maybe-load-default-file)
  (let* ((bmk    (bmkx-get-bookmark bookmark 'NOERROR))
         (bname  (bmkx-bookmark-name-from-record bmk))) ; BOOKMARK might have been a bookmark.
    (when bname                         ; Do nothing if BOOKMARK does not represent a bookmark.
      (bookmark-maybe-historicize-string bname)
      (when (fboundp 'bmkx-unlight-bookmark) (bmkx-unlight-bookmark bmk 'NOERROR))
      (bookmark--remove-fringe-mark bmk)
      (setq bookmark-alist                (delq bmk bookmark-alist)
            bmkx-latest-bookmark-alist    (delq bmk bmkx-latest-bookmark-alist)
            bmkx-automatic-bookmarks      (delq bmk bmkx-automatic-bookmarks)
            bmkx-bmenu-omitted-bookmarks  (bmkx-delete-bookmark-name-from-list
                                           bname bmkx-bmenu-omitted-bookmarks))
      (unless (bmkx-get-bookmark-in-alist bookmark-current-bookmark 'NOERROR)
        (setq bookmark-current-bookmark  nil)) ; Make this nil if last occurrence of BMK was deleted.
       ;; Do NOT refresh/rebuild if BATCHP.  Caller must do that if batching deletions.
      (unless batchp (bmkx-refresh/rebuild-menu-list))
      (bmkx-maybe-save-bookmarks))))    ; Increments `bookmark-alist-modification-count'.


;; Differences from built-in `bookmark.el':
;;
;; 1. Use `bmkx-current-bookmark-file', not `bookmark-default-file'.
;; 2. Update `bmkx-last-as-first-bookmark-file' if it is non-nil.
;; 3. Reset `bmkx-modified-bookmarks' to ().
;; 4. Call `bmkx-refresh/rebuild-menu-list'.
;;
;;;###autoload (autoload 'bmkx-save "bookmark-x")
(defun bmkx-save (&optional parg file) ; Bound to `C-x x s'
  "Save currently defined bookmarks.
Save by default in the file named by variable
`bmkx-current-bookmark-file'.  With a prefix arg, you are prompted for
the file to save to.

If `bmkx-last-as-first-bookmark-file' is non-nil, update its value to
the file being saved.

To load bookmarks from a specific file, use `\\[bmkx-load]'
\(`bmkx-load').

If called from Lisp:
 With nil PARG and nil FILE, use file `bmkx-current-bookmark-file'.
 With non-nil FILE, use file FILE.
 With non-nil PARG, prompt the user for the file to use."
  (interactive "P")
  (bmkx-maybe-load-default-file)
  (let ((file-to-save
         (cond (file)                   ; Use FILE provided.
               (parg        (bmkx-read-bookmark-file-name
                             "File to save bookmarks in: " nil
                             (bmkx-read-bookmark-file-default)))
               ((not parg)  bmkx-current-bookmark-file))))
    (when (file-directory-p file-to-save) (error "`%s' is a directory, not a file" file-to-save))
    (when (and bmkx-last-as-first-bookmark-file
               bookmark-save-flag)      ; nil if temporary bookmarking mode.
      (customize-save-variable 'bmkx-last-as-first-bookmark-file file-to-save))
    (bmkx-write-file file-to-save))
  ;; Indicate by the count that we have synced the current bookmark file.
  ;; If an error has already occurred somewhere, the count will not be set, which is what we want.
  (setq bookmark-alist-modification-count  0
        bmkx-modified-bookmarks            ())
  (bmkx-refresh/rebuild-menu-list))     ; $$$$$$ Should this be done only when interactive?


;; From `mule-util.el'
;;
(eval-when-compile
 (defmacro with-coding-priority (coding-systems &rest body)
   "Execute BODY like `progn' with CODING-SYSTEMS at the front of priority list.
CODING-SYSTEMS is a list of coding systems.  See `set-coding-system-priority'.
This affects the implicit sorting of lists of coding systems returned by
operations such as `find-coding-systems-region'."
   (let ((current (make-symbol "current")))
     `(let ((,current (coding-system-priority-list)))
       (apply #'set-coding-system-priority ,coding-systems)
       (unwind-protect
            (progn ,@body)
         (apply #'set-coding-system-priority ,current))))))


;; Differences from built-in `bookmark.el':
;;
;;  1. Use `write-file', not `write-region', so backup files are made.
;;  2. Do not save temporary bookmarks (`bmkx-temporary-bookmark-p').
;;  3. Added optional arguments ADD and ALT-MSG.
;;     Do not delete region if ADD.  Position point depending on ADD.
;;  4. Delete contents only if file does not exist (just in case).  Else `bookmark-maybe-upgrade-file-format'.
;;  5. Insert code piecewise, to improve performance when saving `bookmark-alist'.
;;     (Do not let `pp' parse all of `bookmark-alist' at once.)
;;  6. Unless `bmkx-propertize-bookmark-names-flag', remove text properties from bookmark name and file name.
;;     Remove them also from bookmark names in a sequence bookmark `sequence' entry.
;;  7. Bind `print-circle' and `print-gensym' around `pp', to record bNAME with `bmkx-full-record' prop, when
;;     appropriate.
;;  8. Use `cl-case', not `cond'.
;;  9. Run `bmkx-write-bookmark-file-hook' functions after writing the bookmark file.
;; 10. Don't kill buffer of written file at end, if buffer visiting the file existed at the outset.
;;
(defun bmkx-write-file (file &optional add alt-msg)
  "Write `bookmark-alist' to FILE.
Bookmarks that have a non-nil `bmkx-temp' entry are not saved.
They are removed from the bookmark file, but not from the current
bookmark list.

Non-nil optional arg ADD means do not replace the bookmarks in FILE.
If the value is `append' then append `bookmark-list' to them.  Any
other non-nil value means prepend `bookmark-list' to them.  Prepending
means that for some operations the copied bookmarks take precedence
over existing ones with the same name (since an alist is used).

Non-nil ALT-MSG is a message format string to use in place of the
default, \"Saving bookmarks to file `%s'...\".  The string must
contain a `%s' construct, so that it can be passed along with FILE to
`format'.  At the end, \"done\" is appended to the message."
  (let ((msg                      (or alt-msg  "Saving bookmarks to file `%s'..."))
        (coding-system-for-write  (if (boundp 'bookmark-file-coding-system) ; Emacs 25.2+.
                                      (or coding-system-for-write  bookmark-file-coding-system  'utf-8-emacs)
                                    coding-system-for-write))
        (print-length             nil)
        (print-level              nil)
        (rem-all-p                t) ; Always strip text properties on save.
        (existing-buf             (get-file-buffer file))
        (emacs-lisp-mode-hook     nil) ; Avoid inserting automatic file header if existing empty file, so
        (lisp-mode-hook           nil) ; better chance `bookmark-maybe-upgrade-file-format' signals error.
        bname fname last-fname start end)
    (when (file-directory-p file) (error "`%s' is a directory, not a file" file))
    (message msg (abbreviate-file-name file))
    (with-current-buffer (let ((enable-local-variables  ())) (find-file-noselect file))
      (goto-char (point-min))
      (unless (file-exists-p file)
        (delete-region (point-min) (point-max)) ; In case a find-file hook inserted a header, etc.
        ;; Don't insert the version stamp here; the block below will do that
        ;; with proper coding-system handling.
        (insert "(\n)"))
      (setq start  (and (file-exists-p file)
                        (or (save-excursion (goto-char (point-min))
                                            (search-forward (concat bookmark-end-of-version-stamp-marker "(")
                                                            nil t))
                            (error "Invalid bookmark-file")))
            end    (and start
                        (or (save-excursion (goto-char start) (and (looking-at ")")  start)) ; Bmk list = ().
                            (save-excursion (goto-char (point-max)) (re-search-backward "^)" nil t))
                            (error "Invalid bookmark-file"))))
      (if (not start)                   ; New file, no header yet.
          (goto-char 2)
        ;;  Existing file - delete old bookmarks unless ADD.
        (unless add (delete-region start end))
        (goto-char (if (eq add 'append) end start)))
      (dolist (bmk  bookmark-alist)
        (unless (bmkx-temporary-bookmark-p bmk)
          (setq bname  (bookmark-name-from-full-record bmk)
                fname  (bookmark-get-filename bmk))
          (cond (rem-all-p ; Remove text properties from bookmark name and file name.
                 (set-text-properties 0 (length bname) () bname)
                 (when fname (set-text-properties 0 (length fname) () fname)))
                (t ; Remove face / display / etc. text properties.
                 (remove-text-properties 0 (length bname) '(face            nil
                                                            display         nil
                                                            help-echo       nil
                                                            rear-nonsticky  nil
                                                            invisible       nil)
                                         bname)))
          (setcar bmk bname)
          (when (setq last-fname  (assq 'filename bmk)) (setcdr last-fname fname))
          (let ((pp-default-function  #'pp-28)) ; Emacs 30.1 redefined `pp' and added var `pp-default-function'.
            (if (not (and rem-all-p  (bmkx-sequence-bookmark-p bmk)))
                (pp bmk (current-buffer))
              ;; Remove text properties from bookmark names in the `sequence' entry of sequence bookmark.
              (insert "(\"" (let ((seqbname  (copy-sequence (bookmark-name-from-full-record bmk))))
                              (set-text-properties 0 (length seqbname) () seqbname)
                              seqbname)
                      "\"\n")
              (dolist (prop  (cdr bmk))
                (if (not (eq 'sequence (car prop)))
                    (insert " " (pp-to-string prop))
                  (insert " (sequence " (mapconcat (lambda (bname)
                                                     (let ((name  (copy-sequence bname)))
                                                       (set-text-properties 0 (length name) () name)
                                                       (concat "\"" name "\"")))
                                                   (cdr prop) " ")
                          ")\n")))
              (insert " )\n")))))
      ;; Make sure specified encoding can encode the bookmarks.  If not, suggest utf-8-emacs as default.
      (with-coding-priority '(utf-8-emacs)
        (setq coding-system-for-write  (select-safe-coding-system (point-min) (point-max)
                                                                  (list t coding-system-for-write))))
      (when start (delete-region 1 (1- start))) ; Delete old header.
      (goto-char 1)
      (bookmark-insert-file-format-version-stamp coding-system-for-write)
      (let ((version-control        (cl-case bookmark-version-control
                                      ((nil)      nil)
                                      (never      'never)
                                      (nospecial  version-control)
                                      (t          t)))
            (require-final-newline  t)
            (errorp                 nil))
        (condition-case nil
            (write-file file)
          (file-error (setq errorp  t)
                      ;; Do NOT raise error.  (Need to be able to exit.)
                      (let ((msg  (format "CANNOT WRITE FILE `%s'" file)))
                        (display-warning 'bookmark-plus msg))))
        (when (boundp 'bookmark-file-coding-system) ; Emacs 25.2+
          (setq bookmark-file-coding-system  coding-system-for-write))
        (unless existing-buf (kill-buffer (current-buffer)))
        (run-hook-with-args 'bmkx-write-bookmark-file-hook file)
        (unless errorp (message (concat msg "done") file))))))


;; Differences from built-in `bookmark.el':
;;
;; 1. Added optional arg DUPLICATES-OK.
;;
;; 2. Unless DUPLICATES-OK is non-nil, if a bookmark in NEW-LIST is `equal' to a bookmark in `bookmark-alist'
;;    then do not rename it and do not add it - just ignore it.
;;
;; 3. Return value includes how many bookmarks were added and renamed.
;;    If RETURN-BMKS is non-nil then it also includes which bookmarks were added.
;;
(defun bmkx-import-new-list (new-list &optional duplicates-ok return-bmks)
  "Add NEW-LIST of bookmarks to `bookmark-alist'.
Unless optional arg DUPLICATES-OK is non-nil, ignore bookmarks that
are `equal' to bookmarks in `bookmark-alist'.  (This means that all of
their information is `equal', not just their names.  This includes
their tags and annotations.)

Rename new bookmarks that are not ignored, as needed, using suffix
\"<N>\" (N=2,3...) when they conflict with existing bookmark names.

Return a list (NB-RENAMED NB-ADDED BMKS-ADDED) of the number renamed,
the number added, and the full bookmarks that were added.  If
RETURN-BMKS is nil then BMKS-ADDED is just nil (the bookmarks are not
returned)."
  (let ((names       (bmkx-all-names))
        (nb-added    0)
        (nb-renamed  0)
        (bmks-added  ()))
    (dolist (full-bmk  new-list)
      (when (or (and (not (member full-bmk bookmark-alist)) ; Check even if DUPLICATES-OK, to update ADDEDP.
                     (setq nb-added  (1+ nb-added)))
                duplicates-ok)
        (when (bmkx-maybe-rename full-bmk names) (setq nb-renamed  (1+ nb-renamed)))
        (setq bookmark-alist  (nconc bookmark-alist (list full-bmk)))
        (push (bookmark-name-from-full-record full-bmk) names)
        (when return-bmks (push full-bmk bmks-added))))
    (list nb-renamed nb-added bmks-added)))

;; Differences from built-in `bookmark.el':
;;
;; Return non-nil iff bookmark was renamed.
;;
(defun bmkx-maybe-rename (full-record names)
  "Rename bookmark FULL-RECORD if its current name is already used.
This is a helper for `bmkx-import-new-list'.
Return non-nil if the bookmark was renamed, nil otherwise."
  (let ((found-name  (bookmark-name-from-full-record full-record)))
    (when (member found-name names)
      (let ((count     2)
            (new-name  found-name))
        (while (member new-name names)
          (setq new-name  (concat found-name (format "<%d>" count))
                count     (1+ count)))
        (bmkx-set-name full-record new-name)
        (not (string= found-name new-name))))))


;; Differences from built-in `bookmark.el':
;;
;;  1. Prefix arg means OVERWRITE.
;;  2. Return the list of bookmarks read from FILE.
;;  3. Use `bmkx-read-bookmark-file-name', not `read-file-name', and use different default.
;;  4. If OVERWRITE is non-nil:
;;     * Update `bmkx-last-bookmark-file' to `bmkx-current-bookmark-file'.
;;     * Update `bmkx-current-bookmark-file' to FILE.
;;     * Reset bmenu stuff: `bmkx-bmenu-marked-bookmarks', `bmkx-modified-bookmarks',
;;       `bmkx-flagged-bookmarks', `bmkx-bmenu-omitted-bookmarks', `bmkx-bmenu-filter-function'.
;;     * If `bmkx-last-as-first-bookmark-file', then update it to FILE and save it to disk.
;;  5. If the bookmark-file buffer already existed, do not kill it after loading.
;;  6. Set `bmkx-bookmarks-already-loaded' regardless of FILE (not just `bookmark-default-file').
;;  7. Update `bmkx-sorted-alist' (it's a cache).
;;  8. Final msg says whether overwritten.
;;  9. Run `bmkx-read-bookmark-file-hook' after reading the bookmark file.
;; 10. Call `bmkx-bmenu-refresh-menu-list' at end, if interactive.
;; 11. Don't support optional 4th arg DEFAULT (Emacs 27+).
;;
;;;###autoload (autoload 'bmkx-load "bookmark-x")
(defun bmkx-load (file &optional overwrite batchp &rest _IGNORED) ; Bound to `C-x x l'
  "Load bookmarks from FILE (which must be in the standard format).
Return the list of bookmarks read from FILE.
Without a prefix argument (argument OVERWRITE is nil), add the newly
loaded bookmarks to those already current.  They are saved to the
current bookmark file when bookmarks are saved.

If you do not use a prefix argument, then no existing bookmarks are
overwritten.  If you load some bookmarks that have the same names as
bookmarks already defined in your Emacs session, numeric suffixes
\"<2>\", \"<3>\",... are appended as needed to the names of those new
bookmarks to distinguish them.

With a prefix argument (non-nil arg OVERWRITE), switch the bookmark
file currently used, *replacing* all currently existing bookmarks with
the newly loaded bookmarks.  In this case, the value of
`bmkx-current-bookmark-file'is backed up to `bmkx-last-bookmark-file'
and then changed to FILE, so bookmarks will subsequently be saved to
FILE.

If `bmkx-last-as-first-bookmark-file' is non-nil and is not FILE then
it is changed to FILE and saved persistently, so that the next Emacs
session will start with it as the bookmark file.  (The value of
`bookmark-default-file' is unaffected.)

Interactively, if any bookmarks have been modified since last saved
then you are asked whether you want to first save them before loading
FILE.  If you hit `C-g' then both saving and loading are canceled.

`bmkx-load' runs `bmkx-read-bookmark-file-hook' after reading the
bookmark file.

When called from Lisp, non-nil optional arg BATCHP means this is not
an interactive call.  In this case, do not interact with the user: do
not ask whether to save the current (unsaved) bookmark list before
loading; do not display any load progress messages; and do not
update/refresh buffer `*Bmkx List*'.

If BATCHP is `save' and bookmarks have been modified since the
bookmark list was last saved, then save the bookmark list before
loading.

If BATCHP is any other non-nil value besides `save', do not save the
bookmark list.

Your initial bookmark file, either `bmkx-last-as-first-bookmark-file'
or `bookmark-default-file', is loaded automatically by Emacs the first
time you use bookmarks in a session - you do not need to load it
manually.  Use `bmkx-load' only to load extra bookmarks (with no
prefix arg) or an alternative set of bookmarks (with a prefix arg).

If you use `bmkx-load' to load a file that does not contain a
proper bookmark alist, then when bookmarks are saved the current
bookmark file will likely become corrupted.  You should load only
bookmark files that were created using the bookmark functions."
  (interactive
   (list (let ((default  (if (bmkx-same-file-p bmkx-current-bookmark-file bmkx-last-bookmark-file)
                             (bmkx-default-bookmark-file)
                           bmkx-last-bookmark-file)))
           (bmkx-read-bookmark-file-name
            (if current-prefix-arg "Switch to bookmark file: " "Add bookmarks from file: ")
            (or (file-name-directory default)  "~/")
            default
            t))
         current-prefix-arg))
  ;; Maybe save first.
  (when (or (eq batchp 'save)
            (and (not batchp)  (> bookmark-alist-modification-count 0)
                 (condition-case err
                     (yes-or-no-p "Save current bookmarks before loading? (`C-g': cancel load) ")
                   (quit  (error "OK, canceled"))
                   (error (error (error-message-string err))))))
    (bmkx-save))
  ;; Load.
  (setq file  (abbreviate-file-name (expand-file-name file)))
  (when (file-directory-p file) (error "`%s' is a directory, not a file" file))
  (unless (file-readable-p file) (error "Cannot read bookmark file `%s'" file))
  (unless batchp (message "Loading bookmarks from `%s'..." file))
  (let ((existing-buf  (get-file-buffer file))
        blist)
    (with-current-buffer (let ((enable-local-variables  ())) (find-file-noselect file))
      (goto-char (point-min))
      (setq blist  (bmkx-alist-from-buffer))
      (unless (listp blist) (error "Invalid bookmark list in `%s'" file))
      (cond (overwrite
             (setq bmkx-last-bookmark-file            bmkx-current-bookmark-file
                   bmkx-current-bookmark-file         file
                   bookmark-alist                     blist
                   bookmark-alist-modification-count  0)
             (setq bmkx-bmenu-marked-bookmarks        () ; Start from scratch.
                   bmkx-modified-bookmarks            ()
                   bmkx-flagged-bookmarks             ()
                   bmkx-bmenu-omitted-bookmarks       (condition-case nil
                                                          (eval (car (get 'bmkx-bmenu-omitted-bookmarks
                                                                          'saved-value)))
                                                        (error nil))
                   bmkx-bmenu-filter-function         nil)
             (when (and bmkx-last-as-first-bookmark-file
                        (not (bmkx-same-file-p bmkx-last-as-first-bookmark-file file)))
               (customize-save-variable 'bmkx-last-as-first-bookmark-file file)))
            (t
             (bmkx-import-new-list blist)
             (setq bookmark-alist-modification-count  (1+ bookmark-alist-modification-count))))
      (setq bmkx-bookmarks-already-loaded  t ; Systematically, whenever any file is loaded.
            bmkx-sorted-alist              (bmkx-sort-omit bookmark-alist))
      (when (boundp 'bookmark-file-coding-system) ; Emacs 25.2+
        (setq bookmark-file-coding-system  buffer-file-coding-system))
      (run-hook-with-args 'bmkx-read-bookmark-file-hook blist file)
      (unless (eq existing-buf (current-buffer)) (kill-buffer (current-buffer))))
    (unless batchp                      ; If appropriate, *CALLER* MUST refresh/rebuild, if BATCHP.
      (bmkx-refresh/rebuild-menu-list)
      (message "%s bookmarks in `%s'" (if overwrite "Switched to" "Added") file))
    blist))                             ; Return the list of bookmarks read from FILE.


;; Differences from built-in `bookmark.el':
;;
;;  1. Make it a command (added `interactive' spec).
;;  2. Use `bmkx-get-bookmark' instead of `bookmark-get-bookmark', so we can get the right bookmark if
;;     it has a name with property `bmkx-full-record'.
;;  3. Handle external annotations (jump to their destinations).
;;  4. Added optional arg MSG-P.  Show message if no annotation.
;;  5. If `bookmark-automatically-show-annotations' is `edit' then this is `bmkx-edit-annotation'.
;;  6. Name buffer after the bookmark.
;;  7. Highlight the title, using face `bmkx-heading'.
;;  8. MSG-P means message if no annotation.
;;  9. Set `bookmark-annotation-name'.
;; 10. Manage `buffer-modified-p'.
;; 11. Use `, not ', in title.  (Both are tolerated.)
;; 12. Fit frame to buffer if `one-windowp'.
;; 13. Restore frame selection.
;;
;;;###autoload (autoload 'bmkx-show-annotation "bookmark-x")
(defun bmkx-show-annotation (bookmark &optional msg-p) ; Bound to `C-x x a s'
  "Show the annotation for BOOKMARK, or follow it if external.
BOOKMARK is a bookmark name or a bookmark record.
If it is a bookmark name then it is looked up in `bookmark-alist'.
If it is a record then it is NOT looked up (need not belong).
If it is or has a name that has non-nil property `bmkx-full-record',
then use the bookmark in `bookmark-alist' that is the value of that
property.  Raise no error if it has no name.

If the annotation is external then jump to its destination.
If no annotation and MSG-P is non-nil, show a no-annotation message.

Opens in read-only or edit mode, as chosen by option
`bookmark-automatically-show-annotations'.  You can toggle between
read-only and edit mode using `C-x C-q'."
  (interactive (list (bmkx-completing-read "Show annotation of bookmark"
                                               (bmkx-default-bookmark-name)
                                               (bmkx-annotated-alist-only)
                                               nil
                                               nil
                                               'USE-NIL-ALIST-P)))
  (let* ((bmk       (bmkx-get-bookmark bookmark 'NOERROR))
         (bname     (bmkx-bookmark-name-from-record bmk))
         (ann       (and bmk  (bookmark-get-annotation bmk)))
         (external  (and ann  (bmkx-get-external-annotation ann))))
    (if external
        (bmkx-visit-external-annotation external msg-p)
      (if (not (and ann  (not (string-equal ann ""))))
          (when msg-p (message "Bookmark has no annotation"))
        (if (eq 'edit bookmark-automatically-show-annotations)
            (bmkx-edit-annotation bookmark)
          (let ((oframe  (selected-frame)))
            (save-selected-window
              (pop-to-buffer (get-buffer-create (format "*`%s' Annotation*" bname)))
              (let ((buffer-read-only  nil) ; Because buffer might already exist, in view mode.
                    (buf-modified-p    (buffer-modified-p)))
                (delete-region (point-min) (point-max))
                (insert (concat "Annotation for bookmark `" bname "':\n\n"))
                ;; Use `font-lock-ignore' property from library `font-lock+.el', because Org mode
                ;; uses font-lock, which would otherwise wipe out the highlighting added here.
                (add-text-properties (line-beginning-position -1) (line-end-position 1)
                                     '(face              bmkx-heading
                                       font-lock-ignore  t))
                (insert ann)
                (set-buffer-modified-p buf-modified-p))
              (goto-char (point-min))
              (bmkx-show-annotation-mode)
              (when (and bmkx-fit-frame-flag (one-window-p t)) (fit-frame-to-buffer))
              (setq bookmark-annotation-name  bmk))
            (select-frame-set-input-focus oframe)))))))


;; Differences from built-in `bookmark.el':
;;
;; 1. Make it a command (added `interactive' spec).
;; 2. Use `bmkx-maybe-load-default-file', to ensure bookmarks are loaded.
;; 3. Use name `*Bookmark Annotations*', not `*Bookmark Annotation*'.
;; 4. Don't list bookmarks that have no annotation.
;; 5. Highlight bookmark names.  Don't indent annotations.  Add a blank line after each annotation.
;; 6. Use `view-mode'.  `q' uses `quit-window'.
;; 7. Fit frame to buffer if `one-windowp'.
;; 8. Restore frame selection.
;;
;;;###autoload (autoload 'bmkx-show-all-annotations "bookmark-x")
(defun bmkx-show-all-annotations () ; Bound to `C-x x a S'
  "Display the annotations for all bookmarks.
If called from buffer `*Bmkx List*' then the annotations are shown
in the current sort order."
  (interactive)
  (bmkx-maybe-load-default-file)
  (let ((obuf    (current-buffer))
        (oframe  (selected-frame)))
    (save-selected-window
      (pop-to-buffer (get-buffer-create "*Bookmark Annotations*"))
      (let ((buffer-read-only  nil)) ; Because buffer might already exist, in view mode.
        (delete-region (point-min) (point-max))
        ;; (Could use `bmkx-annotated-alist-only' here instead.)
        (dolist (full-record  (if (equal (buffer-name obuf) bmkx-bmenu-buffer)
                                  (bmkx-sort-omit bookmark-alist
                                                  (and (not (eq bmkx-bmenu-filter-function
                                                                'bmkx-omitted-alist-only))
                                                       bmkx-bmenu-omitted-bookmarks))
                                bookmark-alist))
          (let ((ann  (bookmark-get-annotation full-record)))
            (when (and ann  (not (string-equal ann "")))
              (insert (concat (bmkx-bookmark-name-from-record full-record) ":\n"))
              (put-text-property (line-beginning-position 0) (line-end-position 0) 'face 'bmkx-heading)
              (insert ann) (unless (bolp) (insert "\n\n")))))
        (goto-char (point-min))
        (view-mode-enter)
        (when (and bmkx-fit-frame-flag (one-window-p t)) (fit-frame-to-buffer))))
    (select-frame-set-input-focus oframe)))


;; Differences from built-in `bookmark.el':
;;
;; Save menu-list state to `bmkx-bmenu-state-file'.
;;
(defun bmkx-exit-hook-internal ()   ; This goes on `kill-emacs-hook'.
  "Save currently defined bookmarks and perhaps bookmark menu-list state.
Run `bookmark-exit-hook', then save bookmarks if they were updated.
Then save menu-list state to file `bmkx-bmenu-state-file', but only if
that option is non-nil."
  (run-hooks 'bookmark-exit-hook)
  (when (bookmark-time-to-save-p t)
    (condition-case err                 ; Do NOT raise error.  (Need to be able to exit.)
        (bmkx-save)
      (error (display-warning 'bookmark-plus (error-message-string err))
             nil)))
  (bmkx-save-menu-list-state))
 
;;(@* "Bookmark-X Functions (`bmkx-*')")
;;; Bookmark-X Functions (`bmkx-*') -----------------------------------


;;(@* "Filter Functions")
;;  *** Filter Functions ***

(put 'bmkx-all-tags-alist-only 'bmkx-read-arg 'bmkx-read-tags-completing)
(defun bmkx-all-tags-alist-only (tags)
  "`bookmark-alist', restricted to bookmarks whose tags are all in TAGS.
A bookmark matches if every tag it has appears in TAGS (i.e. the
bookmark's tag set is a subset of TAGS).  Bookmarks with no tags do
not match.  A new list is returned (no side effects).

This is the inverse of the more common \"bookmark has every tag in
TAGS\" check; for that, see `bmkx-has-tags-alist-only'."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not
   (lambda (bmk)
     (let* ((tgs       tags)
                    (bmk-tags  (bmkx-get-tags bmk)))
       (and bmk-tags  (bmkx-every (lambda (tag) (member (bmkx-tag-name tag) tgs)) bmk-tags))))
   bookmark-alist))

(put 'bmkx-has-tags-alist-only 'bmkx-read-arg 'bmkx-read-tags-completing)
(defun bmkx-has-tags-alist-only (tags)
  "`bookmark-alist', restricted to bookmarks that have every tag in TAGS.
TAGS is a list of tag-name strings.  A bookmark matches if, for each
NAME in TAGS, the bookmark has a tag with that name (other tags on
the bookmark are allowed).  An empty TAGS list matches every bookmark.
A new list is returned (no side effects).

Contrast `bmkx-all-tags-alist-only', which matches when the
bookmark's tag set is a subset of TAGS."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not
   (lambda (bmk)
     (bmkx-every (lambda (tag) (bmkx-has-tag-p bmk tag)) tags))
   bookmark-alist))

(put 'bmkx-all-tags-regexp-alist-only 'bmkx-read-arg 'bmkx-read-regexp)
(defun bmkx-all-tags-regexp-alist-only (regexp)
  "`bookmark-alist', but with only bookmarks having all tags match REGEXP.
Does not include bookmarks that have no tags.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not
   (let ((rg  regexp))
     (lambda (bmk)
       (let ((bmk-tags  (bmkx-get-tags bmk)))
         (and bmk-tags
              (bmkx-every (lambda (tag) (string-match-p rg (bmkx-tag-name tag))) bmk-tags)))))
   bookmark-alist))

(defun bmkx-annotated-alist-only ()
  "`bookmark-alist', but only for bookmarks with non-empty annotations.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-annotated-bookmark-p bookmark-alist))

(defun bmkx-autofile-alist-only (&optional prefix)
  "`bookmark-alist', filtered to retain only autofile bookmarks.
With non-nil arg PREFIX, the bookmark names must all have that PREFIX."
  (bmkx-maybe-load-default-file)
  (if (not prefix)
      (bmkx-remove-if-not #'bmkx-autofile-bookmark-p bookmark-alist)
    (bmkx-remove-if-not (let ((pref  prefix)) (lambda (bmk) (bmkx-autofile-bookmark-p bmk pref)))
                        bookmark-alist)))

(put 'bmkx-autofile-all-tags-alist-only 'bmkx-read-arg 'bmkx-read-tags-completing)
(defun bmkx-autofile-all-tags-alist-only (tags)
  "`bookmark-alist', with only autofiles having all tags in TAGS.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not
   (let ((tgs  tags))
     (lambda (bmk)
       (and (bmkx-autofile-bookmark-p bmk)  (bmkx-get-tags bmk)
            (bmkx-every (let ((bk  bmk)) (lambda (tag) (bmkx-has-tag-p bk tag))) tgs))))
   bookmark-alist))

(put 'bmkx-autofile-all-tags-regexp-alist-only 'bmkx-read-arg 'bmkx-read-regexp)
(defun bmkx-autofile-all-tags-regexp-alist-only (regexp)
  "`bookmark-alist', with only autofiles having all tags match REGEXP.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not
   (let ((rg  regexp))
     (lambda (bmk)
       (and (bmkx-autofile-bookmark-p bmk)
            (let ((bmk-tags  (bmkx-get-tags bmk)))
              (and bmk-tags
                   (bmkx-every (lambda (tag) (string-match-p rg (bmkx-tag-name tag))) bmk-tags))))))
   bookmark-alist))

(put 'bmkx-autofile-some-tags-alist-only 'bmkx-read-arg 'bmkx-read-tags-completing)
(defun bmkx-autofile-some-tags-alist-only (tags)
  "`bookmark-alist', with only autofiles having some tags in TAGS.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not
   (lambda (bmk) (and (bmkx-autofile-bookmark-p bmk)
                      (bmkx-some (let ((bk  bmk)) (lambda (tag) (bmkx-has-tag-p bk tag)))  tags)))
   bookmark-alist))

(put 'bmkx-autofile-some-tags-regexp-alist-only 'bmkx-read-arg 'bmkx-read-regexp)
(defun bmkx-autofile-some-tags-regexp-alist-only (regexp)
  "`bookmark-alist', with only autofiles having some tags match REGEXP.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not
   (let ((rg  regexp))
     (lambda (bmk) (and (bmkx-autofile-bookmark-p bmk)
                        (bmkx-some (lambda (tag) (string-match-p rg (bmkx-tag-name tag)))
                                   (bmkx-get-tags bmk)))))
   bookmark-alist))
(defun bmkx-autonamed-alist-only ()
  "`bookmark-alist', with only autonamed bookmarks (from any buffers).
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-autonamed-bookmark-p bookmark-alist))

(defun bmkx-autonamed-this-buffer-alist-only ()
  "`bookmark-alist', with only autonamed bookmarks for the current buffer.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not (lambda (bmk) (bmkx-autonamed-this-buffer-bookmark-p bmk)) bookmark-alist))

(defun bmkx-bookmark-file-alist-only ()
  "`bookmark-alist', filtered to retain only bookmark-file bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-bookmark-file-bookmark-p bookmark-alist))

(defun bmkx-bookmark-list-alist-only ()
  "`bookmark-alist', filtered to retain only bookmark-list bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-bookmark-list-bookmark-p bookmark-alist))

(defun bmkx-buffer-alist-only ()
  "`bookmark-alist', filtered to retain only non-file buffer bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-buffer-bookmark-p bookmark-alist))

(defun bmkx-desktop-alist-only ()
  "`bookmark-alist', filtered to retain only desktop bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-desktop-bookmark-p bookmark-alist))

(defun bmkx-dired-alist-only ()
  "`bookmark-alist', filtered to retain only Dired bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-dired-bookmark-p bookmark-alist))

(defun bmkx-dired-this-dir-alist-only ()
  "`bookmark-alist', with only Dired bookmarks for the current directory.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-dired-this-dir-bookmark-p bookmark-alist))

(defun bmkx-dired-wildcards-alist-only ()
  "`bookmark-alist', with only bookmarks for a Dired buffer with wildcards.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-dired-wildcards-bookmark-p bookmark-alist))

(when (fboundp 'bmkx-eww-bookmark-p)    ; Emacs 25+

  (defun bmkx-eww-alist-only ()
    "`bookmark-alist', filtered to retain only EWW bookmarks.
A new list is returned (no side effects)."
    (bmkx-maybe-load-default-file)
    (bmkx-remove-if-not #'bmkx-eww-bookmark-p bookmark-alist))

  )

(defun bmkx-file-alist-only ()
  "`bookmark-alist', filtered to retain only file and directory bookmarks.
This excludes bookmarks that might contain file information but are
particular in some way - for example, Info bookmarks or Gnus bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-file-bookmark-p bookmark-alist))

(put 'bmkx-file-all-tags-alist-only 'bmkx-read-arg 'bmkx-read-tags-completing)
(defun bmkx-file-all-tags-alist-only (tags)
  "`bookmark-alist', with only file bookmarks having all tags in TAGS.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not
   (let ((tgs  tags))
     (lambda (bmk)
       (and (bmkx-file-bookmark-p bmk)  (bmkx-get-tags bmk)
            (bmkx-every (let ((bk  bmk)) (lambda (tag) (bmkx-has-tag-p bk tag)))  tgs))))
   bookmark-alist))

(put 'bmkx-file-all-tags-regexp-alist-only 'bmkx-read-arg 'bmkx-read-regexp)
(defun bmkx-file-all-tags-regexp-alist-only (regexp)
  "`bookmark-alist', with only file bookmarks having all tags match REGEXP.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not
   (let ((rg  regexp))
     (lambda (bmk)
       (and (bmkx-file-bookmark-p bmk)
            (let ((bmk-tags  (bmkx-get-tags bmk)))
              (and bmk-tags
                   (bmkx-every (lambda (tag) (string-match-p rg (bmkx-tag-name tag))) bmk-tags))))))
   bookmark-alist))

(put 'bmkx-file-some-tags-alist-only 'bmkx-read-arg 'bmkx-read-tags-completing)
(defun bmkx-file-some-tags-alist-only (tags)
  "`bookmark-alist', with only file bookmarks having some tags in TAGS.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not
   (let ((tgs  tags))
     (lambda (bmk) (and (bmkx-file-bookmark-p bmk)
                        (bmkx-some (let ((bk  bmk)) (lambda (tag) (bmkx-has-tag-p bk tag)))  tgs))))
   bookmark-alist))

(put 'bmkx-file-some-tags-regexp-alist-only 'bmkx-read-arg 'bmkx-read-regexp)
(defun bmkx-file-some-tags-regexp-alist-only (regexp)
  "`bookmark-alist', with only file bookmarks having some tags match REGEXP.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not
   (let ((rg  regexp))
     (lambda (bmk) (and (bmkx-file-bookmark-p bmk)
                        (bmkx-some (lambda (tag) (string-match-p rg (bmkx-tag-name tag)))
                                   (bmkx-get-tags bmk)))))
   bookmark-alist))

(defun bmkx-file-this-dir-alist-only ()
  "`bookmark-alist', filtered with `bmkx-file-this-dir-bookmark-p'.
Include only files and subdir that are in `default-directory'.
This excludes bookmarks that might contain file information but are
particular in some way - for example, Info bookmarks or Gnus bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-file-this-dir-bookmark-p bookmark-alist))

(put 'bmkx-file-this-dir-all-tags-alist-only 'bmkx-read-arg 'bmkx-read-tags-completing)
(defun bmkx-file-this-dir-all-tags-alist-only (tags)
  "`bookmark-alist', for files in this dir having all tags in TAGS.
Include only files and subdir that are in `default-directory'.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not
   (let ((tgs  tags))
     (lambda (bmk)
       (and (bmkx-file-this-dir-bookmark-p bmk)  (bmkx-get-tags bmk)
            (bmkx-every (let ((bk  bmk)) (lambda (tag) (bmkx-has-tag-p bk tag)))  tgs))))
   bookmark-alist))

(put 'bmkx-file-this-dir-all-tags-regexp-alist-only 'bmkx-read-arg 'bmkx-read-regexp)
(defun bmkx-file-this-dir-all-tags-regexp-alist-only (regexp)
  "`bookmark-alist', for files in this dir having all tags match REGEXP.
Include only files and subdir that are in `default-directory'.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not
   (let ((rg  regexp))
     (lambda (bmk)
       (and (bmkx-file-this-dir-bookmark-p bmk)
            (let ((bmk-tags  (bmkx-get-tags bmk)))
              (and bmk-tags
                   (bmkx-every (lambda (tag) (string-match-p rg (bmkx-tag-name tag)))  bmk-tags))))))
   bookmark-alist))

(put 'bmkx-file-this-dir-some-tags-alist-only 'bmkx-read-arg 'bmkx-read-tags-completing)
(defun bmkx-file-this-dir-some-tags-alist-only (tags)
  "`bookmark-alist', for files in this dir having some tags in TAGS.
Include only files and subdir that are in `default-directory'.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not
   (let ((tgs  tags))
     (lambda (bmk) (and (bmkx-file-this-dir-bookmark-p bmk)
                        (bmkx-some (let ((bk  bmk)) (lambda (tag) (bmkx-has-tag-p bk tag)))  tgs))))
   bookmark-alist))

(put 'bmkx-file-this-dir-some-tags-regexp-alist-only 'bmkx-read-arg 'bmkx-read-regexp)
(defun bmkx-file-this-dir-some-tags-regexp-alist-only (regexp)
  "`bookmark-alist', for files in this dir having some tags match REGEXP.
Include only files and subdir that are in `default-directory'.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not
   (let ((rg  regexp))
     (lambda (bmk) (and (bmkx-file-this-dir-bookmark-p bmk)
                        (bmkx-some (lambda (tag) (string-match-p rg (bmkx-tag-name tag)))
                                   (bmkx-get-tags bmk)))))
   bookmark-alist))

(defun bmkx-function-alist-only ()
  "`bookmark-alist', filtered to retain only function bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-function-bookmark-p bookmark-alist))

(defun bmkx-gnus-alist-only ()
  "`bookmark-alist', filtered to retain only Gnus bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-gnus-bookmark-p bookmark-alist))

(defun bmkx-image-alist-only ()
  "`bookmark-alist', filtered to retain only image-file bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-image-bookmark-p bookmark-alist))

(defun bmkx-info-alist-only ()
  "`bookmark-alist', filtered to retain only Info bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-info-bookmark-p bookmark-alist))

(defun bmkx-last-specific-buffer-alist-only ()
  "`bookmark-alist', but only for `bmkx-last-specific-buffer'.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-last-specific-buffer-p bookmark-alist))

(defun bmkx-last-specific-file-alist-only ()
  "`bookmark-alist', but only for `bmkx-last-specific-file'.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-last-specific-file-p bookmark-alist))

(defun bmkx-man-alist-only ()
  "`bookmark-alist', filtered to retain only `man' page bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-man-bookmark-p bookmark-alist))

(defun bmkx-local-file-alist-only ()
  "`bookmark-alist', filtered to retain only local-file bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-local-file-bookmark-p bookmark-alist))

(defun bmkx-local-non-dir-file-alist-only ()
  "`bookmark-alist', filtered to retain only local non-dir file bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-local-non-dir-file-bookmark-p bookmark-alist))

(defun bmkx-marked-bookmarks-only ()
  "Return the list of marked bookmarks."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-marked-bookmark-p bookmark-alist))

(defun bmkx-non-autonamed-alist-only ()
  "`bookmark-alist', with only non-autonamed bookmarks (from any buffers).
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not (lambda (bmk) (not (bmkx-autonamed-bookmark-p bmk))) bookmark-alist))

(defun bmkx-non-dir-file-alist-only ()
  "`bookmark-alist', filtered to retain only nondirectory file bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-non-dir-file-bookmark-p bookmark-alist))

(defun bmkx-non-file-alist-only ()
  "`bookmark-alist', filtered to retain only non-file bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-non-file-bookmark-p bookmark-alist))

(defun bmkx-non-invokable-alist-only ()
  "`bookmark-alist', filtered to retain only non-invokable bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-non-invokable-bookmark-p bookmark-alist))

(defun bmkx-omitted-alist-only ()
  "`bookmark-alist', filtered to retain only the omitted bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-omitted-bookmark-p bookmark-alist))

(defun bmkx-omitted-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is an omitted bookmark.
BOOKMARK is a bookmark name or a bookmark record."
  (unless (stringp bookmark) (setq bookmark  (bmkx-bookmark-name-from-record bookmark)))
  (bmkx-bookmark-name-member bookmark bmkx-bmenu-omitted-bookmarks))

(defun bmkx-orphaned-file-alist-only ()
  "`bookmark-alist', filtered to retain only orphaned file bookmarks."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-orphaned-file-bookmark-p bookmark-alist))

(defun bmkx-orphaned-local-file-alist-only ()
  "`bookmark-alist', but retaining only orphaned local-file bookmarks."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-orphaned-local-file-bookmark-p bookmark-alist))

(defun bmkx-orphaned-remote-file-alist-only ()
  "`bookmark-alist', but retaining only orphaned remote-file bookmarks."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-orphaned-remote-file-bookmark-p bookmark-alist))

(defun bmkx-regexp-filtered-annotation-alist-only ()
  "`bookmark-alist' for annotations matching `bmkx-bmenu-filter-pattern'."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not
   (lambda (bmk)
     (let ((annot  (bookmark-get-annotation bmk)))
       (and (stringp annot)  (not (string= "" annot))
            (string-match-p bmkx-bmenu-filter-pattern annot))))
   bookmark-alist))                     ; (Could use `bmkx-annotated-alist-only' here instead.)

(defun bmkx-regexp-filtered-bookmark-name-alist-only ()
  "`bookmark-alist' for bookmarks matching `bmkx-bmenu-filter-pattern'."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not (lambda (bmk)
                        (string-match-p bmkx-bmenu-filter-pattern (bookmark-name-from-full-record bmk)))
                      bookmark-alist))

(defun bmkx-regexp-filtered-file-name-alist-only ()
  "`bookmark-alist' for files matching `bmkx-bmenu-filter-pattern'."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not (lambda (bmk) (let ((fname  (bookmark-get-filename bmk)))
                                      (and fname  (string-match-p bmkx-bmenu-filter-pattern fname))))
                      bookmark-alist))

(defun bmkx-regexp-filtered-tags-alist-only ()
  "`bookmark-alist' for tags matching `bmkx-bmenu-filter-pattern'."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not (lambda (bmk)
                        (let ((bmk-tags  (bmkx-get-tags bmk)))
                          (and bmk-tags  (bmkx-some (lambda (tag)
                                                      (string-match-p bmkx-bmenu-filter-pattern
                                                                           (bmkx-tag-name tag)))
                                                    bmk-tags))))
                      bookmark-alist))

(defun bmkx-region-alist-only ()
  "`bookmark-alist', filtered to retain only bookmarks that have regions.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-region-bookmark-p bookmark-alist))

(defun bmkx-remote-file-alist-only ()
  "`bookmark-alist', filtered to retain only remote-file bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-remote-file-bookmark-p bookmark-alist))

(defun bmkx-remote-non-dir-file-alist-only ()
  "`bookmark-alist', filtered to retain only remote non-dir file bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-remote-non-dir-file-bookmark-p bookmark-alist))

(defun bmkx-sequence-alist-only ()
  "`bookmark-alist', filtered to retain only sequence bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-sequence-bookmark-p bookmark-alist))  

(defun bmkx-snippet-alist-only ()
  "`bookmark-alist', filtered to retain only snippet bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-snippet-bookmark-p bookmark-alist))

(put 'bmkx-some-tags-alist-only 'bmkx-read-arg 'bmkx-read-tags-completing)
(defun bmkx-some-tags-alist-only (tags)
  "`bookmark-alist', but with only bookmarks having some tags in TAGS.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not (let ((tgs  tags))
                        (lambda (bmk)
                          (bmkx-some (let ((bk  bmk)) (lambda (tag) (bmkx-has-tag-p bk tag)))
                                     tgs)))
                      bookmark-alist))

(put 'bmkx-some-tags-regexp-alist-only 'bmkx-read-arg 'bmkx-read-regexp)
(defun bmkx-some-tags-regexp-alist-only (regexp)
  "`bookmark-alist', but with only bookmarks having some tags match REGEXP.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not (let ((rg  regexp))
                        (lambda (bmk)
                          (bmkx-some (lambda (tag) (string-match-p rg (bmkx-tag-name tag)))
                                     (bmkx-get-tags bmk))))
                      bookmark-alist))

(put 'bmkx-specific-buffers-alist-only 'bmkx-read-arg 'bmkx-read-buffers)
(defun bmkx-specific-buffers-alist-only (&optional buffers)
  "`bookmark-alist', filtered to retain only bookmarks to buffers BUFFERS.
BUFFERS is a list of buffer names.
It defaults to a singleton list with the current buffer's name.
A new list is returned (no side effects).

Note: Bookmarks created by built-in Emacs do not record the buffer
name.  They are therefore excluded from the returned alist."
  (unless buffers  (setq buffers  (list (buffer-name))))
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not (let ((bufs  buffers))
                        (lambda (bmk)
                          (and (not (bmkx-desktop-bookmark-p       bmk)) ; Exclude these
                               (not (bmkx-bookmark-file-bookmark-p bmk))
                               (not (bmkx-sequence-bookmark-p      bmk))
                               (not (bmkx-function-bookmark-p      bmk))
                               (not (bmkx-variable-list-bookmark-p bmk))
                               (member (bmkx-get-buffer-name bmk) bufs))))
                      bookmark-alist))

(put 'bmkx-specific-files-alist-only 'bmkx-read-arg 'bmkx-read-files)
(defun bmkx-specific-files-alist-only (&optional files)
  "`bookmark-alist', filtered to retain only bookmarks to files FILES.
FILES is a list of absolute file names.
It defaults to a singleton list with the current buffer's file name,
 or to the empty list if the buffer is not visiting a file.
A new list is returned (no side effects)."
  (unless files  (setq files  (and (buffer-file-name)  (list (buffer-file-name)))))
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not (let ((ff  files))
                        (lambda (bmk)
                          (let ((bf  (bookmark-get-filename bmk))) 
                            (and bf
                                 ;; If we loaded `cl-seq.el': (cl-member bf ff :test #'bmkx-same-file-p)
                                 (catch 'bmkx-specific-files-alist-only
                                   (dolist (f  ff)
                                     (or (bmkx-same-file-p f bf)  (throw 'bmkx-specific-files-alist-only nil)))
                                   t)))))
                      bookmark-alist))

(defun bmkx-tagged-alist-only ()
  "`bookmark-alist', with only bookmarks that have tags.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-get-tags bookmark-alist))

(defun bmkx-temporary-alist-only ()
  "`bookmark-alist', filtered to retain only temporary bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-temporary-bookmark-p bookmark-alist))

(defun bmkx-this-file/buffer-alist-only ()
  "`bookmark-alist', with only bookmarks for the current file/buffer.
A new list is returned (no side effects).
If visiting a file, this is `bmkx-this-file-alist-only'.
Otherwise, this is `bmkx-this-buffer-alist-only'."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not (if (buffer-file-name) #'bmkx-this-file-p #'bmkx-this-buffer-p) bookmark-alist))

(defun bmkx-this-buffer-alist-only ()
  "`bookmark-alist', with only bookmarks for the current buffer.
A new list is returned (no side effects).
See `bmkx-this-buffer-p'."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-this-buffer-p bookmark-alist))

(defun bmkx-this-file-alist-only ()
  "`bookmark-alist', with only bookmarks for the current file.
A new list is returned (no side effects).
See `bmkx-this-file-p'."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-this-file-p bookmark-alist))

(defun bmkx-unmarked-bookmarks-only ()
  "Return the list of unmarked bookmarks."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if #'bmkx-marked-bookmark-p bookmark-alist))

(defun bmkx-untagged-alist-only ()
  "`bookmark-alist', with only bookmarks that do not have tags.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if #'bmkx-get-tags bookmark-alist))

(defun bmkx-url-alist-only ()
  "`bookmark-alist', filtered to retain only URL bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-url-bookmark-p bookmark-alist))

(defun bmkx-url-browse-alist-only ()
  "`bookmark-alist', but with only URL bookmarks that are non-W3M, non-EWW.
\(The bookmarks satisfy `bmkx-url-browse-bookmark-p'.)
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-url-browse-bookmark-p bookmark-alist))

(defun bmkx-variable-list-alist-only ()
  "`bookmark-alist', filtered to retain only variable-list bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-variable-list-bookmark-p bookmark-alist))

(defun bmkx-w3m-alist-only ()
  "`bookmark-alist', filtered to retain only W3M bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not #'bmkx-w3m-bookmark-p bookmark-alist))

;; This provides the `defvar's for all Bookmark-X history variables.
;; Use this again, after you define any of your own filter functions
;; `bmkx-*-alist-only', for new kinds of bookmarks.
;;
(bmkx-define-history-variables) ; Macro defined in `bookmark-x-mac.el'.


;;(@* "Miscellaneous Bookmark-X Functions")
;;  *** Miscellaneous Bookmark-X Functions ***

(defun bmkx-read-regexp (&optional prompt defaults history)
      "Same as `read-regexp', except argument PROMPT is optional.
PROMPT defaults to \"Regexp: \"."
      (unless prompt (setq prompt  "Regexp: "))
      (read-regexp prompt defaults history))

;; Same as `icicle-propertize'.  (Not used yet.)
;;
(defun bmkx-propertize (object &rest properties)
  "Like `propertize', but for all Emacs versions.
If OBJECT is not a string, then use `prin1-to-string' to get a string."
  (let ((new  (if (stringp object) (copy-sequence object) (prin1-to-string object))))
    (add-text-properties 0 (length new) properties new)
    new))

(defun bmkx-new-bookmark-default-names (&optional first-def)
  "Return a list of default names (strings) for a new bookmark.
A non-nil optional arg FIRST-DEF is prepended to the list of names
described below.

If the region is active and non-empty, then the first default name
\(other than FIRST-DEF) is the current buffer name followed by \": \"
and the region prefix (up to `bmkx-bookmark-name-length-max' chars).
The other names are as described below.

Uses option `bmkx-new-bookmark-default-names' to come up with the
other names.  To these names, `bookmark-current-bookmark' and
`bookmark-buffer-name' are appended, if available (non-nil)."
  (let ((defs  (and first-def  (list first-def)))
        val)
    ;; If region is active, first default is its text, with buffer name prepended.
    (when (and transient-mark-mode  mark-active  (> (region-end) (region-beginning)))
      (let* ((regname  (concat (buffer-name) ": " (buffer-substring (region-beginning) (region-end))))
             (defname  (bmkx-replace-regexp-in-string
                        "\n" " "
                        (progn (save-excursion (goto-char (region-beginning))
                                               (skip-chars-forward " ")
                                               (setq bookmark-yank-point  (point)))
                               (substring regname 0 (min bmkx-bookmark-name-length-max
                                                         (length regname)))))))
        (unless (memq defname defs) (setq defs  (cons defname defs)))))
    ;; Names provided by option `bmkx-new-bookmark-default-names',
    ;; plus `bookmark-current-bookmark' and `bookmark-buffer-name'.
    (dolist (fn  bmkx-new-bookmark-default-names)
      (when (functionp fn)              ; Be sure it is defined and is a function.
        (setq val  (funcall fn))
        (when (and (stringp val)  (not (string= "" val)))
          (setq val  (bmkx-replace-regexp-in-string "\n" " " val))
          (unless (memq val defs) (setq defs  (cons val defs))))))
    (when (listp defs)
      (when bookmark-current-bookmark (push bookmark-current-bookmark defs))
      (let ((buf  (bookmark-buffer-name))) (when buf (push buf defs)))
      (setq defs  (nreverse defs)))
    defs))

(defun bmkx-bookmark-record-from-name (bookmark-name &optional noerror _memp alist)
  "Return the full bookmark record for BOOKMARK-NAME, or nil / error.
BOOKMARK-NAME must be a string.  Names are unique within ALIST (default
`bookmark-alist'), so simple `assoc-string' lookup is precise.

Non-nil optional NOERROR means return nil if BOOKMARK-NAME is unknown;
otherwise raise an error.  The MEMP arg is accepted for caller
compatibility and ignored; it had meaning only in the previous design
that disambiguated same-named bookmarks via a text property."
  (unless alist (setq alist  bookmark-alist))
  (or (assoc-string bookmark-name alist bookmark-completion-ignore-case)
      (and (not noerror)
           (error "No such bookmark in bookmark list: `%s'" bookmark-name))))

(defun bmkx-rename-for-marked-and-omitted-lists (old new)
  "Replace OLD bookmark name with NEW in marked and omitted lists."
  (when (bmkx-marked-bookmark-p old)
    (setq bmkx-bmenu-marked-bookmarks  (bmkx-delete-bookmark-name-from-list old
                                                                            bmkx-bmenu-marked-bookmarks))
    (push new bmkx-bmenu-marked-bookmarks))
  (when (bmkx-omitted-bookmark-p old)
    (setq bmkx-bmenu-omitted-bookmarks  (bmkx-delete-bookmark-name-from-list old
                                                                             bmkx-bmenu-omitted-bookmarks))
    (push new bmkx-bmenu-omitted-bookmarks)))

(defun bmkx-get-bookmark-in-alist (bookmark &optional noerror alist)
  "Return the full bookmark in ALIST that corresponds to BOOKMARK.
Return nil if there is none.
BOOKMARK is a bookmark name or a bookmark record.

Non-nil optional arg NOERROR means return nil if BOOKMARK does not
represent a valid bookmark or is valid but is not in ALIST.  If
NOERROR is nil then raise an error in this case.

Optional arg ALIST defaults to `bookmark-alist'.

Bookmark membership in ALIST is tested using `eq'.

If BOOKMARK is a bookmark name instead of a full bookmark then return
what `bmkx-bookmark-record-from-name' with non-nil arg MEMP returns.

This function is like `bookmark-get-bookmark', except that
`bookmark-get-bookmark' tests whether BOOKMARK is in `bookmark-alist'
only when it is a string (a bookmark name, not a full bookmark).  When
BOOKMARK is a full bookmark `bookmark-get-bookmark' is thus not a test
for its existence, as is `bmkx-get-bookmark-in-alist'."
  (cond ((consp bookmark) (and (memq bookmark (or alist  bookmark-alist))  bookmark))
        ((stringp bookmark) (bmkx-bookmark-record-from-name bookmark noerror 'MEMP alist))
        (t (and (not noerror)  (error "Invalid bookmark: `%s'" bookmark)))))

;;(@* "Stable per-bookmark identity (`id' property)")
;;; Stable per-bookmark identity (`id' property) ---------------------
;;
;; Every bookmark record carries an `(id . STRING)' property.  Identity
;; is the `id', not the name string -- two bookmarks may share a name,
;; their ids differ.  See DESIGN.md for the full rationale.
;;
;; Phase 1 (current): new records get an id at creation; on file load,
;; any record lacking an id receives one and the alist is marked dirty
;; so the next save persists it.  The legacy `bmkx-full-record'
;; text-property machinery still runs in parallel; later phases drop it.

(defun bmkx-generate-id ()
  "Return a fresh opaque string id for a bookmark.
Format is a sortable timestamp plus 24 random bits, e.g.
\"20260531T230547-a3f2c1\".  Collision-resistant for normal use."
  (format "%s-%06x"
          (format-time-string "%Y%m%dT%H%M%S")
          (random #x1000000)))

(defun bmkx-get-by-id (id &optional alist)
  "Return the bookmark record in ALIST whose `id' property equals ID.
ALIST defaults to `bookmark-alist'.  Returns nil if none."
  (cl-find id (or alist  bookmark-alist)
           :key  (lambda (bmk) (cdr (assq 'id (cdr bmk))))
           :test #'equal))

(defun bmkx-ensure-record-ids (blist &rest _ignored)
  "Assign an `id' to every record in BLIST that lacks one.
Bumps `bookmark-alist-modification-count' if any record was updated,
so the next save writes the new ids to disk.  Intended for
`bmkx-read-bookmark-file-hook'."
  (let (added)
    (dolist (bmk blist)
      (let ((data (cdr bmk)))
        (unless (assq 'id data)
          (setcdr bmk (cons (cons 'id (bmkx-generate-id)) data))
          (setq added  t))))
    (when added
      (setq bookmark-alist-modification-count
            (1+ bookmark-alist-modification-count)))
    blist))

(add-hook 'bmkx-read-bookmark-file-hook #'bmkx-ensure-record-ids)

;;(@* "Unique bookmark names (phase 2)")
;;; Unique bookmark names (phase 2) ---------------------------------
;;
;; Names are enforced unique within `bookmark-alist'.  When a user
;; tries to create a bookmark with a name that already exists (and
;; isn't overwriting), the new bookmark is auto-renamed
;; `foo' -> `foo<2>' -> `foo<3>' ....  Stable identity is the `id'
;; property (assigned in phase 1); names are display-only labels.

(defun bmkx-make-unique-name (name &optional alist)
  "Return NAME unchanged if free in ALIST; otherwise `NAME<N>' for the
smallest N >= 2 that is free.  ALIST defaults to `bookmark-alist'."
  (let ((al  (or alist  bookmark-alist)))
    (if (not (assoc name al))
        name
      (let ((n  2))
        (while (assoc (format "%s<%d>" name n) al) (setq n  (1+ n)))
        (format "%s<%d>" name n)))))

(defun bmkx-deduplicate-bookmark-names (blist &rest _ignored)
  "Rename any duplicate names in BLIST so all names are unique.
Keeps the first occurrence; suffixes later ones with `<N>'.  Bumps
`bookmark-alist-modification-count' if any record was renamed, so the
next save persists the new names.  Intended for
`bmkx-read-bookmark-file-hook'."
  (let ((seen     (make-hash-table :test #'equal))
        renamed)
    (dolist (bmk blist)
      (let ((name  (car bmk)))
        (when (gethash name seen)
          (let ((new  (bmkx-make-unique-name name blist)))
            (setcar bmk new)
            (setq renamed  t
                  name     new)))
        (puthash name t seen)))
    (when renamed
      (setq bookmark-alist-modification-count
            (1+ bookmark-alist-modification-count)))
    blist))

(add-hook 'bmkx-read-bookmark-file-hook #'bmkx-deduplicate-bookmark-names)


(defun bmkx-default-bookmark-file ()
  "`bmkx-last-as-first-bookmark-file', or `bookmark-default-file' if nil."
  (or bmkx-last-as-first-bookmark-file  bookmark-default-file))

(defun bmkx-completing-read-bookmarks (&optional alist pred hist names-only-p use-nil-alist-p)
  "Read bookmark names and return the bookmarks named as a list.
You are prompted for each bookmark name.  Hit `RET' with empty input
to end.

ALIST is the bookmark alist to use.  It defaults to `bookmark-alist'
unless USE-NIL-ALIST-P is non-nil.

NAMES-ONLY-P non-nil means return bookmark names, not full bookmarks.
If NAMES-ONLY-P is `lax' then completion is lax.

USE-NIL-ALIST-P means do not default ALIST to `bookmark-alist': if
ALIST is nil there are no bookmark candidates, so just return nil."
  (let ((bmks  ())
        (bmk   t))
    (if (and use-nil-alist-p  (not alist))
        ()
      (while bmk
        (setq bmk  (bmkx-completing-read-1 "Bookmark (RET for each, empty input to finish)"
                                           "" alist pred hist (eq names-only-p 'lax)))
        (when (equal "" bmk) (setq bmk  nil))
        (when (and bmk  (not names-only-p)) (setq bmk (bmkx-get-bookmark-in-alist bmk 'NO-ERROR alist)))
        (when bmk (push bmk bmks)))
      (setq bmks  (nreverse bmks))
      bmks)))

(defun bmkx-completing-read-lax (prompt &optional default alist pred hist use-nil-alist-p)
  "Read a bookmark name, prompting with PROMPT.
Like `bmkx-completing-read', but completion is lax (non-strict):
your input need not match any existing bookmark name.

In addition:
 * You can use `SPC' and `?' freely when typing the name.
 * You can use `C-M-w' repeatedly to yank consecutive words from the
   current buffer (see `bmkx-yank-word')."
  (let ((orig-C-M-w  (lookup-key minibuffer-local-completion-map (kbd "C-M-w")))
        (orig-C-M-u  (lookup-key minibuffer-local-completion-map (kbd "C-M-u")))
        (orig-SPC    (lookup-key minibuffer-local-completion-map (kbd "SPC")))
        (orig-qmark  (lookup-key minibuffer-local-completion-map (kbd "?"))))
    (unwind-protect
        (progn (define-key minibuffer-local-completion-map (kbd "C-M-w") 'bmkx-yank-word)
               (define-key minibuffer-local-completion-map (kbd "C-M-u") 'bmkx-insert-current-bookmark)
               (define-key minibuffer-local-completion-map (kbd "SPC")   'self-insert-command)
               (define-key minibuffer-local-completion-map (kbd "?")     'self-insert-command)
               (bmkx-completing-read-1 prompt default alist pred hist 'LAX use-nil-alist-p))
      (define-key minibuffer-local-completion-map (kbd "C-M-w") orig-C-M-w)
      (define-key minibuffer-local-completion-map (kbd "C-M-u") orig-C-M-u)
      (define-key minibuffer-local-completion-map (kbd "SPC")   orig-SPC)
      (define-key minibuffer-local-completion-map (kbd "?")     orig-qmark))))

(defun bmkx-completing-read-1 (prompt &optional default alist pred hist laxp use-nil-alist-p)
  "Helper for functions that read a bookmark name with completion.
See `bmkx-completing-read' for the argument descriptions."
  (bmkx-maybe-load-default-file)
  (unless (or alist  use-nil-alist-p) (setq alist  bookmark-alist))
  (if (and (not laxp)
           (listp last-nonmenu-event)
           (or (eq t bmkx-menu-popup-max-length)
               (and (integerp bmkx-menu-popup-max-length)  (< (length alist) bmkx-menu-popup-max-length))))
      (bookmark-menu-popup-paned-menu
       t prompt
       (if bmkx-sort-comparer           ; Test whether to sort, but always use `string-lessp'.
           (sort (bmkx-all-names alist) 'string-lessp)
         (bmkx-all-names alist)))
    (let* ((completion-ignore-case          bookmark-completion-ignore-case)
           (default                         (and (not (equal "" default))  default)) ; Treat "" like nil.
           (prompt                          (concat prompt (if default
                                                               (format " (%s): " (if (consp default)
                                                                                     (car default)
                                                                                   default))
                                                             ": ")))
           (str                             (completing-read prompt alist pred (not laxp) nil
                                                             (or hist  'bookmark-history) default)))
      str)))

(defun bmkx-jump-1 (bookmark display-function &optional flip-use-region-p)
  "Helper function for `bmkx-jump' commands.
BOOKMARK is a bookmark name or a bookmark record.
If it is a bookmark name then it is looked up in `bookmark-alist'.
If it is a record then it is NOT looked up (need not belong).
If it is or has a name that has non-nil property `bmkx-full-record',
then use the bookmark in `bookmark-alist' that is the value of that
property.  Raise no error if it has no name.

DISPLAY-FUNCTION as in `bmkx-jump'.  Passed to `bmkx--jump-via'.
Non-nil optional arg FLIP-USE-REGION-P means temporarily flip the
 value of `bmkx-use-region'."
  (setq bookmark  (bmkx-get-bookmark bookmark 'NOERROR))
  (unless bookmark (error "No bookmark specified"))
  (run-hooks 'bmkx-before-jump-hook)
  (bookmark-maybe-historicize-string (bmkx-bookmark-name-from-record bookmark))
  (let ((bmkx-use-region  (if flip-use-region-p (not bmkx-use-region) bmkx-use-region)))
    (condition-case err
        (bmkx--jump-via bookmark display-function)
      ;; Translate handler failures into a one-line user-error so the
      ;; minibuffer shows a clean message instead of a stack trace when
      ;; the bookmark's file is missing, the buffer is gone, or the
      ;; handler signals any other file-error.  `bookmark-error-no-filename'
      ;; (raised by built-in `bookmark-default-handler') is caught too.
      ((file-error bookmark-error-no-filename)
       (user-error "Cannot jump to bookmark `%s': %s"
                   (bmkx-bookmark-name-from-record bookmark)
                   (error-message-string err))))))

(defun bmkx-select-buffer-other-window (buffer)
  "Select BUFFER in another window.
If `bmkx-other-window-pop-to-flag' is non-nil, then use
`pop-to-buffer'.  Otherwise, use `switch-to-buffer-other-window'."
  (if bmkx-other-window-pop-to-flag (pop-to-buffer buffer t) (switch-to-buffer-other-window buffer)))

(defun bmkx-maybe-save-bookmarks (&optional same-count-p)
  "Increment save counter and maybe save `bookmark-alist'.
Non-nil optional arg SAME-COUNT-P means do not increment
`bookmark-alist-modification-count'."
  (unless same-count-p (setq bookmark-alist-modification-count  (1+ bookmark-alist-modification-count)))
  (when (bookmark-time-to-save-p) (bmkx-save)))

;;;###autoload (autoload 'bmkx-annotate-bookmark "bookmark-x")
(defun bmkx-annotate-bookmark (bookmark) ; Bound to `C-x x a a'
  "Annotate BOOKMARK.  Pop up a buffer to add or edit the annotation.
Interactively, this is the same as using command
`bmkx-edit-annotation' with a prefix arg.  You are prompted for
the bookmark name.  Command `bmkx-edit-annotation' can be more
convenient for editing an existing annotation, because you choose
among only the already annotated bookmarks, not all bookmarks.

Non-interactively, BOOKMARK is a bookmark name or a bookmark record."
  (interactive (list (bmkx-completing-read "Annotate bookmark" (bmkx-default-bookmark-name))))
  (pop-to-buffer (generate-new-buffer-name "*Bookmark Annotation Compose*"))
  (bmkx-insert-annotation bookmark)
  (bmkx-edit-annotation-mode)
  (setq bookmark-annotation-name  bookmark))

;;;###autoload (autoload 'bmkx-annotate-bookmark-this-file/buffer "bookmark-x")
(defun bmkx-annotate-bookmark-this-file/buffer (bookmark) ; Bound to `C-x x a b'
  "Annotate an existing bookmark in this file or buffer.
You are prompted for the name of a bookmark here, with completion."
  (interactive
   (let ((alist  (bmkx-this-file/buffer-alist-only)))
     (list (bmkx-completing-read (format "%s annotation for bookmark"
                                             (if current-prefix-arg "Add or edit" "Edit"))
                                     (or (and (fboundp 'bmkx-bookmarks-lighted-at-point)
                                              (bmkx-bookmarks-lighted-at-point))
                                         (bmkx-default-bookmark-name alist))
                                     alist
                                     nil
                                     nil
                                     (not current-prefix-arg)))))
  (bmkx-edit-annotation bookmark))

;;;###autoload (autoload 'bmkx-annotate-all-bookmarks-this-file/buffer "bookmark-x")
(defun bmkx-annotate-all-bookmarks-this-file/buffer () ; Bound to `C-x x a B'
  "Pop up annotation-editing buffer for each bookmark in this file/buffer."
  (interactive)
  (dolist (bmk  (bmkx-this-file/buffer-alist-only))
    (bmkx-edit-annotation bmk)))

;;;###autoload (autoload 'bmkx-show-this-annotation-read-only "bookmark-x")
(defun bmkx-show-this-annotation-read-only ()
  "Switch to `Show Bookmark Annotation' mode for this annotation.
That is, switch from edit mode to read-only mode."
  (interactive)
  (unless (eq major-mode 'bmkx-edit-annotation-mode)
    (error "Buffer is not in `Edit Bookmark Annotation' mode"))
  (if (not (or (not (buffer-modified-p))  (y-or-n-p "Annotation was modified.  Lose changes?")))
      (message "OK, canceled - use `C-c C-c' if you want to save changes")
    (let* ((bmk    (bmkx-get-bookmark bookmark-annotation-name 'NOERROR))
           (bname  (bookmark-name-from-full-record bmk))
           (ann    (and bmk  (bookmark-get-annotation bmk)))
           (obuf   (current-buffer)))
      (unless bname (error "No such bookmark: `%s'" bmk))
      (bmkx--pop-to-buffer-same-window (format "*`%s' Annotation*" bname))
      (let ((buffer-read-only  nil)     ; Because buffer might already exist, in view mode.
            (buf-modified-p    (buffer-modified-p)))
        (delete-region (point-min) (point-max))
        (insert (concat "Annotation for bookmark '" bname "':\n\n"))
        ;; Use `font-lock-ignore' property from library `font-lock+.el', because Org mode
        ;; uses font-lock, which would otherwise wipe out the highlighting added here.
        (add-text-properties (line-beginning-position -1) (line-end-position 1)
                             '(face              bmkx-heading
                               font-lock-ignore  t))
        (insert ann)
        (set-buffer-modified-p buf-modified-p))
      (goto-char (point-min))
      (bmkx-show-annotation-mode)
      (when (and bmkx-fit-frame-flag (one-window-p t)) (fit-frame-to-buffer))
      (setq bookmark-annotation-name  bmk)
      (kill-buffer obuf))))

;;;###autoload (autoload 'bmkx-edit-this-annotation "bookmark-x")
(defun bmkx-edit-this-annotation ()
  "Switch to `Edit Bookmark Annotation' mode for this annotation.
That is, switch from read-only mode to edit mode."
  (interactive)
  (unless (eq major-mode 'bmkx-show-annotation-mode)
    (error "Buffer is not in `Show Bookmark Annotation' mode"))
  (let* ((bmk    (bmkx-get-bookmark bookmark-annotation-name 'NOERROR))
         (bname  (bookmark-name-from-full-record bmk))
         (obuf   (current-buffer)))
    (unless bname (error "No such bookmark: `%s'" bmk))
    (bmkx--pop-to-buffer-same-window (generate-new-buffer-name "*Bookmark Annotation Compose*"))
    (let ((buf-modified-p  (buffer-modified-p)))
      (bmkx-insert-annotation bname)
      (set-buffer-modified-p buf-modified-p))
    (bmkx-edit-annotation-mode)
    (when (and bmkx-fit-frame-flag (one-window-p t)) (fit-frame-to-buffer))
    (setq bookmark-annotation-name  bmk)
    (kill-buffer obuf)))

;;;###autoload (autoload 'bmkx-copy-bookmark "bookmark-x")
(defalias 'bmkx-copy-bookmark 'bmkx-clone-bookmark)
;;;###autoload (autoload 'bmkx-clone-bookmark "bookmark-x")
(defun bmkx-clone-bookmark (bookmark &optional clone confirm-overwrite-p)
                                        ; Bound to `C-x x 2' (`M-n' in bookmark list)
  "Duplicate BOOKMARK to produce a clone.
The clone name is the same as BOOKMARK, but with \"<2>\" appended.
With a prefix arg you are instead prompted for the clone name.

When called from Lisp:
 * BOOKMARK is a bookmark name or a bookmark record.
 * Optional CLONE is the clone name.
 * Optional non-nil CONFIRM-OVERWRITE-P means prompt to confirm
   overwriting an existing bookmark."
  (interactive
   (let* ((orig     (bmkx-completing-read "Clone bookmark" (bmkx-default-bookmark-name)))
          (default  (concat orig "<2>"))
          (new      (if current-prefix-arg
                        (bmkx-completing-read-lax "Clone name" default)
                      default)))
     (while (equal orig new)
       (setq new  (bmkx-completing-read-lax "Clone name (must be different)" default)))
     (list orig new t)))
  (let ((orig-bmk  (bmkx-get-bookmark bookmark))
        (new-bmk   (bmkx-get-bookmark clone 'NO-ERROR)))
    (when (and new-bmk  confirm-overwrite-p)
      (unless (yes-or-no-p "Another bookmark with that name already exists.  Overwrite it? ")
        (error "OK; canceled")))
    (setq new-bmk  (copy-sequence orig-bmk))
    ;; Get rid of old bookmark name, which might have property `bmkx-full-record'.
    ;; Need to do that before calling `bmkx-store'.
    (setcar new-bmk clone)
    (bmkx-store clone (cdr new-bmk) nil) ; (Puts `bmkx-full-record' on name.)
    (setq bookmark-current-bookmark  clone)
    (if (and (get-buffer bmkx-bmenu-buffer)  (get-buffer-window (get-buffer bmkx-bmenu-buffer) 0))
        (with-current-buffer (get-buffer bmkx-bmenu-buffer)
          (bmkx-refresh-menu-list clone))
      (bmkx-list-surreptitiously-rebuild-list))
    (bmkx-maybe-save-bookmarks)))

;;;###autoload (autoload 'bmkx-edit-bookmark-name-and-location "bookmark-x")
(defun bmkx-edit-bookmark-name-and-location (bookmark &optional edit-record-p)
                                        ; Bound to `C-x x r' (`r' in bookmark list)
  "Edit BOOKMARK's name and location, and maybe save them.
Return a list of the new bookmark name and new location.
BOOKMARK is a bookmark name or a bookmark record.

Without a prefix arg, you are prompted for the new bookmark name and
 the new location name.  When entering the new names you can use
 completion against existing names.  This completion is lax, so you
 can easily edit an existing name.  See `bmkx-set' for particular
 keys available during this input.

With a prefix arg, edit the complete bookmark record (the
 internal, Lisp form)."
  (interactive
   (list (bmkx-completing-read (concat "Edit " (and current-prefix-arg  "internal record for ")
                                           "bookmark")
                                   (bmkx-default-bookmark-name))
         current-prefix-arg))
  (setq bookmark  (bmkx-get-bookmark-in-alist bookmark))
  (if edit-record-p
      (bmkx-edit-bookmark-record bookmark)
    (let* ((bmk-name                                    (bmkx-bookmark-name-from-record bookmark))
           (bmk-location                                (bookmark-prop-get bookmark 'location))
           (bmk-urlp                                    (and bmk-location
                                                             (require 'ffap nil t)
                                                             (ffap-url-p bmk-location)))
           (bmk-filename                                (bookmark-get-filename bmk-name))
           (bmk-buffname                                (or (bmkx-get-buffer-name bookmark)
                                                            (bookmark-prop-get bookmark 'buffer)))
           (new-bmk-name                                (bmkx-completing-read-lax
                                                         "New bookmark name" bmk-name))
           (new-location
            (cond (bmk-location
                   (cond ((not bmk-urlp) (read-string "New location: "))
                         ((and (fboundp 'bmkx-eww-bookmark-p)  (bmkx-eww-bookmark-p bmk-name))
                          (read-string "New URL: "))
                         ((bmkx-w3m-bookmark-p bmk-name)
                          (read-string "New URL: "))  ; Legacy w3m bookmark; treat URL as a string.
                         ((require 'ffap) (ffap-read-file-or-url "New URL: " bmk-location))
                         (t (read-string "New location: "))))
                  (bmk-filename
                   (read-file-name
                    "New file name (location): "
                    (and bmk-filename
                         (file-name-directory  bmk-filename))
                    bmk-filename))
                  (bmk-buffname
                   (read-buffer "New location: " bmk-buffname))
                  (t                    ; No current location.
                   (read-string "New location: "))))
           ;; $$$$$$ Should we change a W3M bookmark that uses `filename' to use `location' instead?
           (changed-bmk-name-p                          (and (not (equal new-bmk-name ""))
                                                             (not (equal new-bmk-name bmk-name))))
           (changed-location-p                          (and bmk-location
                                                             (not (equal new-location ""))
                                                             (not (equal new-location bmk-location))))
           (changed-filename-p                          (and bmk-filename
                                                             (not (equal new-location ""))
                                                             (not (equal new-location bmk-filename))))
           (changed-buffname-p                          (and bmk-buffname
                                                             (not (equal new-location ""))
                                                             (not (equal new-location bmk-buffname))
                                                             (not (and (fboundp 'bmkx-eww-bookmark-p)
                                                                       (bmkx-eww-bookmark-p bookmark))))))
      (when (or changed-bmk-name-p  changed-location-p  changed-filename-p  changed-buffname-p)
        (when changed-bmk-name-p (bmkx-rename bmk-name new-bmk-name 'BATCHP))
        (when changed-location-p (bmkx-prop-set new-bmk-name 'location new-location))
        (when changed-filename-p (bookmark-set-filename new-bmk-name new-location))
        (when changed-buffname-p (bmkx-prop-set new-bmk-name 'buffer-name new-location))
        ;; Change location for Dired too, but not if different from original file name (e.g. a cons).
        (let ((dired-dir  (bookmark-prop-get new-bmk-name 'dired-directory)))
          (when (and dired-dir  (equal dired-dir bmk-filename))
            (bmkx-prop-set new-bmk-name 'dired-directory new-location)))
        (bmkx-maybe-save-bookmarks)     ; Maybe save automatically.
        (when (and bookmark-alist-modification-count ; Did not save automatically.  Ask user.
                   (y-or-n-p "Save changes? "))
          (bmkx-save))
        (list new-bmk-name new-location)))))

(define-derived-mode bmkx-edit-bookmark-records-mode emacs-lisp-mode
    "Edit Bookmark Records"
  "Mode for editing a list of bookmark records, as in `bookmark-alist'.
When you finish editing, use \\<bmkx-edit-bookmark-record-mode-map>\
`\\[bmkx-edit-bookmark-record-send]' in the record-editing buffer."
  :group 'bookmark-plus)

;; This binding must be defined *after* the mode, so `bmkx-edit-bookmark-records-mode-map' is defined.
;; (Alternatively, we could use a `defvar' to define `bmkx-edit-bookmark-records-mode-map' before
;; calling `define-derived-mode'.)
(define-key bmkx-edit-bookmark-records-mode-map (kbd "C-c C-c") 'bmkx-edit-bookmark-records-send)

(defvar bmkx-edit-bookmark-records-number 0
  "NUmber of bookmard records being edited.")

;;;###autoload (autoload 'bmkx-edit-bookmark-records-send "bookmark-x")
(defun bmkx-edit-bookmark-records-send (&optional msg-p) ; Bound to `C-c C-c' in records-editing buffer.
  "Update `bookmark-alist' with buffer contents: a bookmark alist.
Lines beginning with `;;' are ignored.
Non-interactively, optional arg MSG-P means display progress messages.

This assumes that the bookmarks in the buffer are the marked bookmarks
in `*Bmkx List*'.  That is, it assumes that the buffer was created
by `bmkx-bmenu-edit-marked' (`\\<bmkx-list-mode-map>\\[bmkx-bmenu-edit-marked]' in `*Bmkx List*')."
  (interactive "p")
  (unless (eq major-mode 'bmkx-edit-bookmark-records-mode)
    (error "Not in `bmkx-edit-bookmark-records-mode'"))
  (when msg-p (message "Reading edited bookmarks..."))
  (let* ((editbuf             (current-buffer))
         (orig-bmks           (bmkx-marked-bookmarks-only))
         (edited-bookmarks    ())
         (read-error-msg
          (catch 'bmkx-edit-bookmark-records-send
            (setq edited-bookmarks  (condition-case err
                                        (save-excursion (goto-char (point-min))  (read (current-buffer)))
                                      (error (throw 'bmkx-edit-bookmark-records-send
                                                    (error-message-string err)))))
            (unless orig-bmks (error "No marked bookmarks now - edits must correspond to currently marked"))
            (cond ((not (listp edited-bookmarks))
                   (throw 'bmkx-edit-bookmark-records-send "Not a list of bookmarks"))
                  ((not (= (length edited-bookmarks) bmkx-edit-bookmark-records-number))
                   (throw 'bmkx-edit-bookmark-records-send
                          (format "Need %d bookmarks, but there seem to be %d"
                                  bmkx-edit-bookmark-records-number (length edited-bookmarks)))))
            (let ((bookmark-save-flag  (and (not bmkx-count-multi-mods-as-one-flag)
                                            bookmark-save-flag))) ; Save only after `dolist' and update.
              (dolist (edited-bmk  edited-bookmarks)
                (unless (and (consp edited-bmk)  (stringp (car edited-bmk))) ; Sanity check.
                  (throw 'bmkx-edit-bookmark-records-send (format "Invalid bookmark: `%s'" edited-bmk)))
                (let ((bname  (bmkx-bookmark-name-from-record edited-bmk))
                      (data   (bmkx-bookmark-data-from-record edited-bmk)))
                  ;; Update the original bookmark (same cons cell) with what's in the edited version.
                  (setcar (car orig-bmks) bname)
                  (setcdr (car orig-bmks) data)
                  ;; This is the same as `add-to-list' with `EQ' (not available for Emacs 20-21).
                  (unless (memq (car orig-bmks) bmkx-modified-bookmarks)
                    (setq bmkx-modified-bookmarks  (cons (car orig-bmks) bmkx-modified-bookmarks)))
                  (setq orig-bmks  (cdr orig-bmks))))
              ;; Update using modified ORIG-BMKS.
              (setq bmkx-bmenu-marked-bookmarks        (mapcar #'bmkx-bookmark-name-from-record
                                                               bmkx-modified-bookmarks)
                    bmkx-sorted-alist                  (bmkx-sort-omit bookmark-alist)
                    bookmark-alist-modification-count  (1+ bookmark-alist-modification-count)))
            nil)))
    (if (stringp read-error-msg)
        (if msg-p  (message "%s  --> edit and try again" read-error-msg)  (error read-error-msg))
      (when (get-buffer editbuf) (kill-buffer editbuf))
      (bmkx-refresh/rebuild-menu-list
       (and (= 1 (length edited-bookmarks))  (car edited-bookmarks)) ; Only one, so we belong on its line.
       (not msg-p)))))

(define-derived-mode bmkx-edit-bookmark-record-mode emacs-lisp-mode
    "Edit Bookmark Record"
  "Mode for editing an internal bookmark record.
When you finish editing, use \\<bmkx-edit-bookmark-record-mode-map>\
`\\[bmkx-edit-bookmark-record-send]' in the record-editing buffer."
  :group 'bookmark-plus)

;; This binding must be defined *after* the mode, so `bmkx-edit-bookmark-record-mode-map' is defined.
;; (Alternatively, we could use a `defvar' to define `bmkx-edit-bookmark-record-mode-map' before
;; calling `define-derived-mode'.)
(define-key bmkx-edit-bookmark-record-mode-map (kbd "C-c C-c") 'bmkx-edit-bookmark-record-send)

;;;###autoload (autoload 'bmkx-edit-bookmark-record "bookmark-x")
(defun bmkx-edit-bookmark-record (bookmark) ; Bound to `C-x x E'.
  "Edit the full record (the Lisp sexp) for BOOKMARK.
BOOKMARK is a bookmark name or a bookmark record.
When you finish editing, use \\<bmkx-edit-bookmark-record-mode-map>\
`\\[bmkx-edit-bookmark-record-send]' in the record-editing buffer.
The current bookmark list is then updated to reflect your edits."
  (interactive (list (bmkx-completing-read "Edit Lisp record for bookmark" (bmkx-default-bookmark-name))))
  (bmkx-maybe-load-default-file)
  (setq bmkx-edit-bookmark-orig-record  (bmkx-get-bookmark-in-alist bookmark))
  (let* ((bmk-copy  (copy-sequence bmkx-edit-bookmark-orig-record)) ; Shallow copy
         (bname     (bmkx-bookmark-name-from-record bmk-copy))
         (bufname   (format "*Edit Record for Bookmark `%s'*" bname)))
    (set-text-properties 0 (length bname) nil bname) ; Strip properties from (copied) name string.
    (bookmark-maybe-historicize-string bname)
    (bmkx-with-output-to-plain-temp-buffer bufname
      (princ
       (substitute-command-keys
        (concat ";; Edit the Lisp record for bookmark\n;;\n"
                ";; `" bname "'\n;;\n"
                ";; Type \\<bmkx-edit-bookmark-record-mode-map>\
`\\[bmkx-edit-bookmark-record-send]' when done.\n;;\n")))
      ;; (let ((print-circle  t)) (pp bmk)) ; $$$$$$ Binding should not really be needed now.
      (pp bmk-copy)
      (goto-char (point-min)))
    (pop-to-buffer bufname)
    (buffer-enable-undo)
    (with-current-buffer (get-buffer bufname) (bmkx-edit-bookmark-record-mode))))

;;;###autoload (autoload 'bmkx-edit-bookmark-record-send "bookmark-x")
(defun bmkx-edit-bookmark-record-send (&optional msg-p) ; Bound to `C-c C-c' in record-editing buffer.
  "Update `bookmark-alist' with buffer contents: a bookmark record.
Lines beginning with `;;' are ignored.
Non-interactively, optional arg MSG-P means display progress messages."
  (interactive "p")
  (unless (eq major-mode 'bmkx-edit-bookmark-record-mode)
    (error "Not in `bmkx-edit-bookmark-record-mode'"))
  (unless (and (boundp 'bmkx-edit-bookmark-orig-record)  (consp bmkx-edit-bookmark-orig-record))
    (error "Lost original bookmark record - try edit command again"))
  (when msg-p (message "Reading edited bookmark..."))
  (let* ((editbuf     (current-buffer))
         (bmk-name    nil)
         (read-error-msg
          (catch 'bmkx-edit-bookmark-record-send
            (let ((edited-bmk
                   (condition-case err
                       (save-excursion (goto-char (point-min))  (read (current-buffer)))
                     (error (throw 'bmkx-edit-bookmark-record-send (error-message-string err))))))
              (unless (and (consp edited-bmk)  (stringp (car edited-bmk)))
                (throw 'bmkx-edit-bookmark-record-send (format "Invalid bookmark: `%s'" edited-bmk)))
              (let ((bname  (bmkx-bookmark-name-from-record edited-bmk))
                    (data   (bmkx-bookmark-data-from-record edited-bmk)))
                ;; Update the original bookmark with what's in the edited version.
                (setcar bmkx-edit-bookmark-orig-record bname)
                (setcdr bmkx-edit-bookmark-orig-record data)
                ;; This is the same as `add-to-list' with `EQ' (not available for Emacs 20-21).
                (unless (memq bmkx-edit-bookmark-orig-record bmkx-modified-bookmarks)
                  (setq bmkx-modified-bookmarks  (cons bmkx-edit-bookmark-orig-record
                                                       bmkx-modified-bookmarks)))
                (setq bmk-name  bname)) ; Save for bookmark-list display, below.
              (setq bmkx-sorted-alist                  (bmkx-sort-omit bookmark-alist)
                    bookmark-alist-modification-count  (1+ bookmark-alist-modification-count)))
            nil)))
    (if (stringp read-error-msg)
        (if msg-p (message "%s  --> edit and try again" read-error-msg) (error read-error-msg))
      (when (get-buffer editbuf) (kill-buffer editbuf))
      (bmkx-refresh/rebuild-menu-list bmk-name (not msg-p)))
    (unless read-error-msg
      (setq bmkx-edit-bookmark-orig-record  nil)))) ; Reset it, but keep it if error so can try again.

;;;###autoload (autoload 'bmkx-edit-bookmark-record-file/buffer "bookmark-x")
(defun bmkx-edit-bookmark-record-file/buffer (bookmark) ; Not bound
  "Edit the full record (the Lisp sexp) of a bookmark in this buffer.
You are prompted for the name of a bookmark here, with completion."
  (interactive
   (let ((alist  (bmkx-this-file/buffer-alist-only)))
     (list (bmkx-completing-read (format "%s annotation for bookmark"
                                             (if current-prefix-arg "Add or edit" "Edit"))
                                     (or (and (fboundp 'bmkx-bookmarks-lighted-at-point)
                                              (bmkx-bookmarks-lighted-at-point))
                                         (bmkx-default-bookmark-name alist))
                                     alist
                                     nil
                                     nil
                                     (not current-prefix-arg)))))
  (bmkx-edit-bookmark-record bookmark))

;;; ;;;###autoload (autoload 'bmkx-edit-all-bookmark-records-this-file/buffer "bookmark-x")
;;; (defun bmkx-edit-all-bookmark-records-this-file/buffer () ; Not bound
;;;   "Pop up a record-editing buffer for each bookmark in this file/buffer."
;;;   (interactive)
;;;   (dolist (bmk  (bmkx-this-file/buffer-alist-only))
;;;     (bmkx-edit-bookmark-record bmk)))

(define-derived-mode bmkx-edit-tags-mode emacs-lisp-mode
    "Edit Bookmark Tags"
  "Mode for editing bookmark tags.
When you have finished composing, type \\[bmkx-edit-tags-send]."
  :group 'bookmark-plus)

;; This binding must be defined *after* the mode, so `bmkx-edit-tags-mode-map' is defined.
;; (Alternatively, we could use a `defvar' to define `bmkx-edit-tags-mode-map' before
;; calling `define-derived-mode'.)
(define-key bmkx-edit-tags-mode-map (kbd "C-c C-c") 'bmkx-edit-tags-send)

;;;###autoload (autoload 'bmkx-edit-tags "bookmark-x")
(defun bmkx-edit-tags (bookmark)        ; Bound to `C-x x t e'
  "Edit BOOKMARK's tags, and maybe save the result.
The edited value must be a list each of whose elements is either a
 string or a cons whose key is a string.
BOOKMARK is a bookmark name or a bookmark record."
  (interactive (list (bmkx-completing-read "Edit tags for bookmark" (bmkx-default-bookmark-name))))
  (setq bookmark  (bmkx-get-bookmark-in-alist bookmark))
  (let* ((btags  (bmkx-get-tags bookmark))
         (bname  (bmkx-bookmark-name-from-record bookmark))
         (edbuf  (format "*Edit Tags for Bookmark `%s'*" bname)))
    (set-text-properties 0 (length bname) nil bname) ; Strip properties from (copied) bookmark name string.
    (bookmark-maybe-historicize-string bname)
    (setq bmkx-return-buffer  (current-buffer))
    (bmkx-with-output-to-plain-temp-buffer
     edbuf
     (princ ";; Edit tags for bookmark\n;;\n;; ")
     (prin1 bname)                      ; In case bookmark name contains " chars etc.
     (princ "\n;;\n;; The edited value must be a list each of whose elements is\n")
     (princ ";; either a string or a cons whose key is a string.\n;;\n")
     (princ ";; DO NOT MODIFY THESE COMMENTS.\n;;\n")
     (princ (substitute-command-keys
             ";; Type \\<bmkx-edit-tags-mode-map>`\\[bmkx-edit-tags-send]' when done.\n\n"))
     (pp btags)
     (goto-char (point-min)))
    (pop-to-buffer edbuf)
    (buffer-enable-undo)
    (with-current-buffer (get-buffer edbuf) (bmkx-edit-tags-mode))))

;;;###autoload (autoload 'bmkx-edit-tags-send "bookmark-x")
(defun bmkx-edit-tags-send (&optional batchp)
  "Use buffer contents as the internal form of a bookmark's tags.
DO NOT MODIFY the header comment lines, which begin with `;;'."
  (interactive)
  (unless (eq major-mode 'bmkx-edit-tags-mode) (error "Not in `bmkx-edit-tags-mode'"))
  (let (bname)
    (unwind-protect
         (let (tags bmk)
           (goto-char (point-min))
           (unless (search-forward ";; Edit tags for bookmark\n;;\n;; ")
             (error "Missing header in edit buffer"))
           (unless (stringp (setq bname  (read (current-buffer))))
             (error "Bad bookmark name in edit-buffer header"))
           (unless (setq bmk  (bmkx-get-bookmark-in-alist bname 'NOERROR))
             (error "No such bookmark: `%s'" bname))
           (goto-char (point-min))
           (setq tags  (read (current-buffer)))
           (unless (listp tags) (error "Tags sexp is not a list of strings or an alist with string keys"))
           (bmkx-prop-set bmk 'tags tags)
           (setq bname  (bmkx-bookmark-name-from-record bmk))
           (bmkx-record-visit bmk batchp)
           (bmkx-refresh/rebuild-menu-list bname batchp)
           (bmkx-maybe-save-bookmarks)
           (unless batchp (message "Updated bookmark file with edited tags")))
      (kill-buffer (current-buffer)))
    (when bmkx-return-buffer
      (pop-to-buffer bmkx-return-buffer)
      (when (equal (buffer-name (current-buffer)) bmkx-bmenu-buffer)
        (bmkx-bmenu-goto-bookmark-named bname)))))

(defun bmkx-record-visit (bookmark &optional batchp)
  "Update the data recording a visit to BOOKMARK.
BOOKMARK is a bookmark name or a bookmark record.

This increments the `visits' entry and sets the `last-visited' entry
to the current time.  If either an entry is not present, it is
added (with 0 value for `visits').

With non-nil optional arg BATCHP, do not rebuild the menu list.

Although this function modifies BOOKMARK, it does not increment
`bookmark-alist-modification-count', and it does not add BOOKMARK to
`bmkx-modified-bookmarks'.  This is so that simply recording the visit
does not count toward needing to save or showing BOOKMARK as modified."
  (let ((vis                      (bookmark-prop-get bookmark 'visits))
        (bmkx-modified-bookmarks  bmkx-modified-bookmarks))
    (bmkx-prop-set bookmark 'visits (if vis (1+ vis) 0))
    (bmkx-prop-set bookmark 'last-visited (current-time)) ; Old name for `last-visited' was `time'.
    (unless batchp (bmkx-list-surreptitiously-rebuild-list 'NO-MSG-P))
    (let ((bookmark-save-flag  nil))  (bmkx-maybe-save-bookmarks 'SAME-COUNT-P))))

(defun bmkx-default-bookmark-name (&optional alist)
  "Default bookmark name.  See option `bmkx-default-bookmark-name'.
Non-nil ALIST means return nil unless the default names a bookmark in
ALIST."
  (let ((bname  (if (equal (buffer-name (current-buffer)) bmkx-bmenu-buffer)
                    (bmkx-list-bookmark)
                  (if (fboundp 'bmkx-default-lighted)
                      (if (eq 'highlighted bmkx-default-bookmark-name)
                          (or (bmkx-default-lighted)  bookmark-current-bookmark)
                        (or bookmark-current-bookmark  (bmkx-default-lighted)))
                    bookmark-current-bookmark))))
    (when (consp bname) (setq bname  (car bname))) ; Since `bmkx-default-lighted' can return a list of names.
    (when (and bname  alist)
      (setq bname  (bmkx-bookmark-name-from-record (bmkx-bookmark-record-from-name
                                                    bname 'NOERROR 'MEMP alist))))
    bname))

(defun bmkx-buffer-names ()
  "Buffer names used by existing bookmarks that really have buffers.
This excludes buffers for bookmarks such as desktops that are not
really associated with a buffer."
  (let ((bufs  ())
        buf)
    (dolist (bmk  bookmark-alist)
      (when (and (not (bmkx-desktop-bookmark-p        bmk))
                 (not (bmkx-bookmark-file-bookmark-p  bmk))
                 (not (bmkx-sequence-bookmark-p       bmk))
                 (not (bmkx-function-bookmark-p       bmk))
                 (not (bmkx-variable-list-bookmark-p  bmk))
                 (setq buf  (bmkx-get-buffer-name     bmk)))
        (unless (member buf bufs) (setq bufs  (cons buf bufs)))))
    bufs))

(defun bmkx-file-names ()
  "The absolute file names used by the existing bookmarks.
This excludes the pseudo file name `bmkx-non-file-filename'."
  (let ((files  ())
        file)
    (dolist (bmk  bookmark-alist)
      (when (and (setq file  (bookmark-get-filename bmk))  (not (equal file bmkx-non-file-filename)))
        (unless (member file files) (setq files  (cons file files)))))
    files))

;;;###autoload (autoload 'bmkx-bookmark-set-confirm-overwrite "bookmark-x")
(defun bmkx-bookmark-set-confirm-overwrite (&optional _n _p _intp _no-r-p) ; Bound `C-x r m', `C-x x c m'.
  "Set a bookmark named NAME, then run `bmkx-after-set-hook'.
This is the same as `bmkx-set', except that with no prefix arg you
are asked to confirm overwriting an existing bookmark of the same
NAME."
  (interactive (list nil current-prefix-arg t))
  (let ((bmkx-bookmark-set-confirms-overwrite-p  t))
    (call-interactively #'bmkx-set)))

;;;###autoload (autoload 'bmkx-send-bug-report "bookmark-x")
(defun bmkx-send-bug-report ()          ; Not bound
  "Send a bug report about a Bookmark-X problem."
  (interactive)
  (browse-url (format (concat "mailto:" "drew.adams" "@" "oracle" ".com?subject=\
Bookmark-X bug: \
&body=Describe bug below, using a precise recipe that starts with `emacs -Q' or `emacs -q'.  \
Be sure to mention the `Update #' from header of the particular Bookmark-X file header.\
%%0A%%0AEmacs version: %s")
                      (emacs-version))))

;;;###autoload (autoload 'bmkx-toggle-bookmark-set-refreshes "bookmark-x")
(defun bmkx-toggle-bookmark-set-refreshes () ; Not bound
  "Toggle whether `bmkx-set' refreshes `bookmark-alist' as last filtered.
Add/remove `bmkx-refresh-latest-bookmark-list' to/from
`bmkx-after-set-hook'.
\(Applies also to command `bmkx-bookmark-set-confirm-overwrite'.)"
  (interactive)
  (if (member 'bmkx-refresh-latest-bookmark-list bmkx-after-set-hook)
      (remove-hook 'bmkx-after-set-hook 'bmkx-refresh-latest-bookmark-list)
    (add-hook 'bmkx-after-set-hook 'bmkx-refresh-latest-bookmark-list)))

(defun bmkx-refresh-latest-bookmark-list ()
  "Refresh `bmkx-latest-bookmark-alist' to reflect `bookmark-alist'."
  (setq bmkx-latest-bookmark-alist  (if bmkx-bmenu-filter-function
                                        (funcall bmkx-bmenu-filter-function)
                                      bookmark-alist)))

;;;###autoload (autoload 'bmkx-toggle-saving-menu-list-state "bookmark-x")
(defun bmkx-toggle-saving-menu-list-state (&optional _interactively) ; Bound to `C-M-~' in bookmark list
  "Toggle the value of option `bmkx-bmenu-state-file'.
Tip: You can use this before quitting Emacs, to not save the state.
If the initial value of `bmkx-bmenu-state-file' is nil, then this
command has no effect.
The optional argument is accepted for compatibility with the menu-bar
toggle definition (which redefines this function), but ignored here."
  (interactive "p")
  (unless (or bmkx-last-bmenu-state-file  bmkx-bmenu-state-file)
    (error "Cannot toggle: initial value of `bmkx-bmenu-state-file' is nil"))
  (setq bmkx-last-bmenu-state-file  (prog1 bmkx-bmenu-state-file
                                      (setq bmkx-bmenu-state-file  bmkx-last-bmenu-state-file)))
  (message (if bmkx-bmenu-state-file
               "Autosaving of bookmark list state is now ON"
             "Autosaving of bookmark list state is now OFF")))

;;;###autoload (autoload 'bmkx-save-menu-list-state "bookmark-x")
(defun bmkx-save-menu-list-state (&optional msg-p) ; Used in `bmkx-exit-hook-internal'.
  "Save menu-list state, unless not saving or list has not yet been shown.
The state is saved to the value of `bmkx-bmenu-state-file'.
Non-interactively, optional arg MSG-P means display progress messages."
  (interactive "p")
  (when (and (not bmkx-bmenu-first-time-p)  bmkx-bmenu-state-file)
    (when msg-p (message "Saving bookmark-list display state..."))
    (let ((config-list
           `((last-sort-comparer                    . ,bmkx-sort-comparer)
             (last-reverse-sort-p                   . ,bmkx-reverse-sort-p)
             (last-reverse-multi-sort-p             . ,bmkx-reverse-multi-sort-p)
             (last-latest-bookmark-alist            . ,(bmkx-maybe-unpropertize-bookmark-names
                                                        bmkx-latest-bookmark-alist))
             (last-bmenu-omitted-bookmarks          . ,(bmkx-maybe-unpropertize-bookmark-names
                                                        bmkx-bmenu-omitted-bookmarks 'COPY))
             (last-bmenu-marked-bookmarks           . ,(bmkx-maybe-unpropertize-bookmark-names
                                                        bmkx-bmenu-marked-bookmarks 'COPY))
             (last-bmenu-filter-function            . ,bmkx-bmenu-filter-function)
             (last-bmenu-filter-pattern             . ,bmkx-bmenu-filter-pattern)
             (last-bmenu-title                      . ,bmkx-bmenu-title)
             (last-bmenu-bookmark                   . ,(and (get-buffer bmkx-bmenu-buffer)
                                                            (with-current-buffer
                                                                (get-buffer bmkx-bmenu-buffer)
                                                              (bmkx-maybe-unpropertize-string
                                                               (bmkx-list-bookmark) 'COPY))))
             ;; Use `copy-sequence' here just in case, to avoid circular references when
             ;; `bmkx-propertize-bookmark-names-flag' is nil.
             (last-specific-buffer                  . ,(copy-sequence bmkx-last-specific-buffer))
             (last-specific-file                    . ,(copy-sequence bmkx-last-specific-file))
             (last-bmenu-toggle-filenames           . ,bookmark-bmenu-toggle-filenames)
             (last-bmenu-before-hide-marked-alist   . ,(bmkx-maybe-unpropertize-bookmark-names
                                                        bmkx-bmenu-before-hide-marked-alist 'COPY))
             (last-bmenu-before-hide-unmarked-alist . ,(bmkx-maybe-unpropertize-bookmark-names
                                                        bmkx-bmenu-before-hide-unmarked-alist 'COPY))
             (last-bookmark-file                    . ,(copy-sequence
                                                        (convert-standard-filename
                                                         (expand-file-name
                                                          bmkx-current-bookmark-file))))
             (last-previous-bookmark-file           . ,(and bmkx-last-bookmark-file
                                                            (copy-sequence
                                                             (convert-standard-filename
                                                              (expand-file-name
                                                               bmkx-last-bookmark-file))))))))
      (with-current-buffer (let ((enable-local-variables  ())) (find-file-noselect bmkx-bmenu-state-file))
        (goto-char (point-min))
        (delete-region (point-min) (point-max))
        (let ((print-length           nil)
              (print-level            nil)
              (version-control        (cl-case bookmark-version-control
                                        ((nil)      nil)
                                        (never      'never)
                                        (nospecial  version-control)
                                        (t          t)))
              (require-final-newline  t)
              (errorp                 nil))
          (pp config-list (current-buffer))
          (condition-case nil
              (write-file bmkx-bmenu-state-file)
            (file-error
             (setq errorp  t)
             ;; Do NOT raise error - used in `bmkx-exit-hook-internal'.  (Need to be able to exit.)
             (let ((msg  (format "CANNOT WRITE FILE `%s'" bmkx-bmenu-state-file)))
               (display-warning 'bookmark-plus msg))))
          (kill-buffer (current-buffer))
          (when (and msg-p  (not errorp)) (message "Saving bookmark-list display state...done")))))))

;;;###autoload (autoload 'bmkx-toggle-saving-bookmark-file "bookmark-x")
(defun bmkx-toggle-saving-bookmark-file (&optional msg-p) ; Bound to `M-~' in bookmark list
  "Toggle the value of option `bookmark-save-flag'.
If the initial value of `bookmark-save-flag' is nil, then this
command has no effect.
Non-interactively, non-nil MSG-P means display a status message."
  (interactive "p")
  (unless (or bmkx-last-save-flag-value  bookmark-save-flag)
    (error "Cannot toggle: initial value of `bookmark-save-flag' is nil"))
  ;; One of the two vars should be nil.  If both are non-nil, set `*-last-*' to nil before toggling.
  (when (and bmkx-last-save-flag-value  bookmark-save-flag) (setq bmkx-last-save-flag-value  nil))  
  (setq bmkx-last-save-flag-value  (prog1 bookmark-save-flag
                                     (setq bookmark-save-flag  bmkx-last-save-flag-value)))
  (when msg-p (message (if bookmark-save-flag
                           "Autosaving of current bookmark file is now ON"
                         "Autosaving of current bookmark file is now OFF"))))

;; Same as `read-from-whole-string' (called `thingatpt--read-from-whole-string' starting with Emacs 25)
;; in library `thingatpt.el'.
;;
(defun bmkx-read-from-whole-string (string)
  "Read a Lisp expression from STRING.
Raise an error if the entire string was not used."
  (let* ((read-data  (read-from-string string))
         (more-left (condition-case nil
                        ;; The call to `ignore' suppresses a compiler warning.
                        (progn (ignore (read-from-string (substring string (cdr read-data))))
                               t)
                      (end-of-file nil))))
    (if more-left (error "Can't read whole string") (car read-data))))

;;;###autoload (autoload 'bmkx-jump-to-list "bookmark-x")
(defun bmkx-jump-to-list (bookmark) ; Bound globally to `C-x j C-j', `C-x x C-j'
  "Jump to BOOKMARK entry in `*Bmkx List*'.
You are prompted for BOOKMARK (a bookmark name).
If you use library `bookmark-x-lit.el':
 * The defaults for BOOKMARK are the lighted bookmarks at point.
 * A prefix arg means only lighted bookmarks at point are candidates."
  (interactive (let* ((litp   (fboundp 'bmkx-bookmarks-lighted-at-point))
                      (lbmks  (and litp  (bmkx-bookmarks-lighted-at-point)))
                      (bmk    (bmkx-completing-read (if current-prefix-arg "Lighted bookmark" "Bookmark")
                                                        (and litp  (if current-prefix-arg (car lbmks) lbmks))
                                                        (and current-prefix-arg  lbmks))))
                 (list bmk)))
  (pop-to-buffer (get-buffer-create bmkx-bmenu-buffer))
  (bmkx-list)
  (bmkx-bmenu-goto-bookmark-named (setq bmkx-last-bmenu-bookmark  bookmark)))

;;;###autoload (autoload 'bmkx-make-function-bookmark "bookmark-x")
(defun bmkx-make-function-bookmark (bookmark-name function &optional msg-p) ; Bound globally to `C-x x c F'.
  "Create a bookmark that invokes FUNCTION when \"jumped\" to.
You are prompted for the bookmark name and the name of the function.
But with a prefix arg the last keyboard macro defined is used instead
of prompting you for a function.

Returns the new bookmark (internal record).

Non-interactively, non-nil optional arg MSG-P means display a status
message."
  (interactive (let ()
                 (list (bmkx-completing-read-lax "Bookmark")
                       (if (and current-prefix-arg  last-kbd-macro)
                           (read-kbd-macro last-kbd-macro 'NEED-VECTOR)
                         (completing-read "Function: " obarray 'functionp))
                       'MSG)))
  (unless (or (functionp function)  (vectorp function))
    (setq function (bmkx-read-from-whole-string function))) ; Convert name to symbol.
  (bmkx-store bookmark-name `(,@(bmkx-make-record-default 'NO-FILE 'NO-CONTEXT 0 nil 'NO-REGION)
                                  (function . ,function)
                                  (handler  . bmkx-jump-function))
                  nil nil (not msg-p))
  ;; Same prompt-for-tags hook `bmkx-set' runs, missing here originally.
  (when (and msg-p  bmkx-prompt-for-tags-flag)
    (bmkx-add-tags bookmark-name (bmkx-read-tags-completing) 'NO-UPDATE-P))
  (let ((new  (bmkx-bookmark-record-from-name bookmark-name 'NOERROR)))
    (unless (memq new bmkx-latest-bookmark-alist)
      (setq bmkx-latest-bookmark-alist  (cons new bmkx-latest-bookmark-alist)))
    (bmkx-list-surreptitiously-rebuild-list (not msg-p))
    new))

;;;###autoload (autoload 'bmkx-set-dired-bookmark-for-files "bookmark-x")
(defun bmkx-set-dired-bookmark-for-files (bookmark-name dired-name to-add &optional switches msg-p)
  "Create a Dired bookmark for a set of files and directories.
You are prompted for the Dired buffer name and the file or directory
entries to include.  With a prefix arg, you are also prompted for the
`ls' switches.

Use `C-g' when done choosing file and directory names.  Any directory
names you choose this way are included as single entries in the
listing - the directory contents are not included.  To instead include
the contents of a directory, use a glob pattern: put `/*' after the
directory name.

You need library `Dired+' for this command."
  (interactive
   (let* ((_IGNORE             (unless (require 'dired+ nil t)
                                 (error "You need library `Dired+' for this command")))
          (current-prefix-arg  (if current-prefix-arg 0 -1))
          (all                 (diredp-dired-union-interactive-spec
                                "add files/dirs "
                                'NO-DIRED-BUFS
                                'READ-EXTRA-FILES-P)))
     (list (bmkx-completing-read-lax "Bookmark") (nth 0 all) (nth 3 all) (nth 2 all) 'MSG)))
  (bmkx-make-function-bookmark
   bookmark-name
   `(lambda () (diredp-add-to-dired-buffer ',dired-name ',to-add ',switches))
   msg-p))

(when (boundp 'grep-history)            ; Emacs 26+
  (defun bmkx-set-grep-command-bookmark (bookmark-name &optional grep-cmd msg-p)
    "Create a bookmark to run the last grep command.
With a prefix arg, you are prompted for the grep command to record,
 with lax completion against your previous `grep' inputs in this
 session."
    (interactive
     (let ((parg  current-prefix-arg))
       (unless grep-history (error "Emacs command `grep' has not yet been run"))
       (list (bmkx-completing-read-lax "Bookmark")
             (and parg
                  (completing-read "Grep command: "
                                   grep-history nil t nil 'grep-history (car grep-history)))
             'MSG)))
    (setq grep-cmd  (or grep-cmd  (car grep-history)))
    (unless (stringp grep-cmd) (error "Emacs command `grep' has not yet been run"))
    (bmkx-make-function-bookmark bookmark-name
                                 `(lambda () (funcall #'grep ,grep-cmd))
                                 msg-p)))

;;;###autoload (autoload 'bmkx-revert-bookmark-file "bookmark-x")
(defun bmkx-revert-bookmark-file (&optional msg-p) ; Same as `C-u g' in bookmark list (but not bound).
  "Revert to the bookmarks in the current bookmark file.
You are asked for confirmation.

This DISCARDS all modifications to bookmarks and the bookmark list
\(e.g. added/deleted bookmarks) since the last bookmark-file save.
IOW, it reloads the bookmark file, overwriting the current bookmark
list.  This also removes any markings and omissions.

This has the same effect as using `C-u \\<bmkx-list-mode-map>\\[bmkx-bmenu-refresh-menu-list]' in \
buffer `*Bmkx List*'.
To refresh the display from the current bookmark list instead of the
bookmark file, use just `\\[bmkx-bmenu-refresh-menu-list]' (no `C-u').

Non-interactively, non-nil MSG-P means display a status message."
  (interactive "p")
  (when (and msg-p  (not (yes-or-no-p (format "Revert to bookmarks saved in file `%s'? "
                                              bmkx-current-bookmark-file))))
    (error "OK - canceled"))
  (bmkx-load bmkx-current-bookmark-file 'OVERWRITE msg-p) ; Do not let `bmkx-load' ask to save.
  (bmkx-refresh/rebuild-menu-list nil (not msg-p)))

;;;###autoload (autoload 'bmkx-switch-bookmark-file "bookmark-x")
(defun bmkx-switch-bookmark-file (file &optional batchp) ; Not bound and not used in the code now.
  "Switch to a different bookmark file, FILE.
Return FILE.  Interactively, you are prompted for FILE.
Replace all bookmarks in the current bookmark list with those from the
newly loaded FILE.  Bookmarks are subsequently saved to FILE.

Optional arg BATCHP is passed to `bmkx-load'."
  (interactive
   (list  (let* ((std-default  (bmkx-default-bookmark-file))
                 (default      (if (bmkx-same-file-p bmkx-current-bookmark-file bmkx-last-bookmark-file)
                                   (if (bmkx-same-file-p bmkx-current-bookmark-file std-default)
                                       bookmark-default-file
                                     std-default)
                                 bmkx-last-bookmark-file)))
            (bmkx-read-bookmark-file-name "Switch to bookmark file: "
                                          (or (file-name-directory default)  "~/")
                                          default
                                          t)))) ; Require that the file exist.
  (bmkx-load file t batchp))        ; Treat it interactively, if this command is called interactively.

;;;###autoload (autoload 'bmkx-switch-to-last-bookmark-file "bookmark-x")
(defun bmkx-switch-to-last-bookmark-file (&optional batchp) ; Not bound to key, but effectively `C-u C-x x L'
  "Switch back to the last-used bookmark file.
Replace all currently existing bookmarks with those newly loaded from
the last-used file.  Swap the values of `bmkx-last-bookmark-file' and
`bmkx-current-bookmark-file'.

Optional arg BATCHP is passed to `bmkx-load'."
  (interactive)
  (bmkx-load (or bmkx-last-bookmark-file  (bmkx-default-bookmark-file))
                 t batchp))             ; Treat it interactively, if this command is called interactively.

;;;###autoload (autoload 'bmkx-switch-bookmark-file-create "bookmark-x")
(defun bmkx-switch-bookmark-file-create (file &optional switch-to-lastp batchp)
                                        ; Bound to `C-x x L', (`L' in bookmark list)
  "Switch to bookmark file FILE, creating it as empty if it does not exist.
With a prefix arg, switch to the last bookmark file used.
Otherwise, you are prompted for FILE.

Replace all bookmarks in the current bookmark list with those from the
newly loaded file.  Bookmarks are subsequently saved to that file.

If there is no file with the name you provide (FILE), then create a
new, empty bookmark file with that name and use that from now on.
This empties the bookmark list.  Interactively, you are required to
confirm this.

Return the newly current bookmark file.

When called from Lisp:
* FILE is the bookmark-file name or nil (meaning use the last one).
* Non-nil BATCHP is passed to `bmkx-load'."
  (interactive
   (if current-prefix-arg
       (list nil current-prefix-arg)
     (list (let* ((std-default  (bmkx-default-bookmark-file))
                  (default      (if (bmkx-same-file-p bmkx-current-bookmark-file bmkx-last-bookmark-file)
                                    (if (bmkx-same-file-p bmkx-current-bookmark-file std-default)
                                        bookmark-default-file
                                      std-default)
                                  bmkx-last-bookmark-file)))
             (bmkx-read-bookmark-file-name "Switch to bookmark file: "
                                           (or (file-name-directory default)  "~/")
                                           default))
           nil)))
  (if (not switch-to-lastp)
      (let ((empty-p  nil))
        (if (file-readable-p file)
;;;     (if (or batchp  (y-or-n-p (format "CONFIRM: `%s' as the current bookmark file? " file)))
;;;         (bmkx-load file t batchp)
;;;       (error "OK, canceled"))
            (bmkx-load file t batchp) ; Treat it interactively, if this command is called interactively.
          (setq empty-p  t)
          (when (and (not batchp)
                     (not (y-or-n-p (format "Create and use NEW, EMPTY bookmark file `%s'? " file))))
            (error "OK - canceled"))
          (bmkx-empty-file file)
          (bmkx-load file t batchp)) ; Treat it interactively, if this command is called interactively.
        (unless batchp (message "Bookmark file is now %s`%s'" (if empty-p "EMPTY file " "") file)))
    (bmkx-switch-to-last-bookmark-file batchp)
    (setq file  bmkx-current-bookmark-file))
  file)

;;;###autoload (autoload 'bmkx-switch-to-bookmark-file-this-file/buffer "bookmark-x")
(defun bmkx-switch-to-bookmark-file-this-file/buffer (file) ; Bound to `C-x x C-l'
  "Switch to a bookmark file for bookmarks in this file or buffer.
If visiting a file, the bookmarks are ‘bmkx-this-file-alist-only’.
Otherwise, they are ‘bmkx-this-buffer-alist-only’.

If there are unsaved bookmarks in the current bookmark list you are
first prompted to save it.

You are then prompted for the bookmark file to switch to, for
bookmarks only for this file/buffer."
  (interactive
   (list (let* ((std-default  (bmkx-default-bookmark-file))
                (default      (if (bmkx-same-file-p bmkx-current-bookmark-file bmkx-last-bookmark-file)
                                  (if (bmkx-same-file-p bmkx-current-bookmark-file std-default)
                                      bookmark-default-file
                                    std-default)
                                bmkx-last-bookmark-file)))
           (bmkx-read-bookmark-file-name "Switch to bookmark file for bookmarks here: "
                                         (or (and default  (file-name-directory default))  "~/")
                                         default))))
  (bmkx-switch-bookmark-file-create file))

(defun bmkx-read-bookmark-file-name (&optional prompt dir default-filename require-match)
  "Read and return an (absolute) bookmark file name.
PROMPT is the prompt to use (default: \"Use bookmark file: \").
The other args are the same as for `read-file-name'."
  (let ((insert-default-directory  t))
    (expand-file-name
     (read-file-name (or prompt  "Use bookmark file: ") dir default-filename require-match))))

(defun bmkx-read-bookmark-file-default ()
  "A default value for `bmkx-read-bookmark-file-name' DEFAULT-FILENAME arg.
A value to use if you want a default and there is none better."
  (if (not (bmkx-same-file-p "~/.emacs.bmk" bookmark-default-file))
      (list "~/.emacs.bmk" bookmark-default-file)
    "~/.emacs.bmk"))

;;;###autoload (autoload 'bmkx-empty-file "bookmark-x")
(defun bmkx-empty-file (file &optional confirmp) ; Bound to `C-x x 0'
  "Empty the bookmark file FILE, or create FILE (empty) if it does not exist.
In either case, FILE will become an empty bookmark file.  Return FILE.

NOTE: If FILE already exists and you confirm emptying it, no check is
      made that it is in fact a bookmark file before emptying it.
      It is simply replaced by an empty bookmark file and saved.

This does NOT also make FILE the current bookmark file.  To do that,
use `\\[bmkx-switch-bookmark-file-create]' (`bmkx-switch-bookmark-file-create').

Interactively, and non-interactively if optional arg CONFIRMP is
non-nil, require confirmation if the file already exists."
  (interactive (list (let ()
                       (read-file-name "Create empty bookmark file: " "~/"))
                     t))
  (setq file  (expand-file-name file))
  (when (file-directory-p file) (error "`%s' is a directory, not a file" file))
  (bmkx-maybe-load-default-file)
  (when (and confirmp  (file-exists-p file)
             (not (y-or-n-p (format "CONFIRM: Empty the existing file `%s'? " file))))
    (error "OK - canceled"))
  (let ((bookmark-alist  ()))
    (bmkx-write-file file nil (if (file-exists-p file)
                                      "Emptying bookmark file `%s'..."
                                    "Creating new, empty bookmark file `%s'...")))
  file)

(defun bmkx-write-alist-bookmarks-to-file (alist file)
  "Write bookmarks in ALIST to FILE."
  (when (file-directory-p file) (error "`%s' is a directory, not a file" file))
  (let ((bookmark-save-flag                 nil) ; Inhibit auto-saving for the duration.
        (bookmark-alist                     bookmark-alist)
        (bookmark-alist-modification-count  bookmark-alist-modification-count)
        imported)
    (with-current-buffer (let ((enable-local-variables  ())) (find-file-noselect file))
      (goto-char (point-min))
      (unless (file-exists-p file)
        (delete-region (point-min) (point-max)) ; In case a find-file hook inserted a header etc.
        (bookmark-insert-file-format-version-stamp coding-system-for-write)
        (insert "(\n)"))
      (let ((blist  (bmkx-alist-from-buffer)))
        (unless (listp blist) (error "Invalid bookmark list in file `%s'" file))
        (setq bookmark-alist  blist)    ; Bookmarks in FILE
        (setq imported  (bmkx-import-new-list alist nil 'RETURN-BMKS))
        (unless (and (zerop (nth 0 imported))  (zerop (nth 1 imported)))
          (bmkx-write-file file))))))

;;;###autoload (autoload 'bmkx-save-bookmarks-this-file/buffer "bookmark-x")
(defun bmkx-save-bookmarks-this-file/buffer (file &optional batchp) ; Bound to `C-x x C-s'
  "Save bookmarks defined for the current file/buffer to FILE.
If visiting a file, the bookmarks are ‘bmkx-this-file-alist-only’.
Otherwise, they are ‘bmkx-this-buffer-alist-only’.

You are prompted for FILE, the bookmark file to save to.

This does NOT make FILE the current bookmark file.  To do that, use
`bmkx-switch-to-bookmark-file-this-file/buffer'."
  (interactive
   (list (let* ((std-default  (bmkx-default-bookmark-file))
                (default      (if (bmkx-same-file-p bmkx-current-bookmark-file bmkx-last-bookmark-file)
                                   (if (bmkx-same-file-p bmkx-current-bookmark-file std-default)
                                       bookmark-default-file
                                     std-default)
                                 bmkx-last-bookmark-file)))
           (bmkx-read-bookmark-file-name "File to save bookmarks in: "
                                         (or (and default  (file-name-directory default))  "~/")
                                         default))
         current-prefix-arg))
  (when (file-directory-p file) (error "`%s' is a directory, not a file" file))
  (when (and (not (file-readable-p file))
             (not batchp)
             (not (y-or-n-p (format "Save to NEW, EMPTY bookmark file `%s'? " file))))
    (error "OK - canceled"))
  (bmkx-write-alist-bookmarks-to-file (bmkx-this-file/buffer-alist-only) file))

;;;###autoload (autoload 'bmkx-highlight-jump-target "bookmark-x")
(defun bmkx-highlight-jump-target ()    ; Not bound
  "Briefly highlight the line at point.
Intended for `bookmark-after-jump-hook' to flag where you landed.
Does nothing if the region is active or `bmkx-highlight-on-jump-flag'
is nil."
  (interactive)
  (when (and bmkx-highlight-on-jump-flag  (not mark-active))
    (require 'pulse)
    (pulse-momentary-highlight-one-line (point))))

;;;###autoload (autoload 'bmkx-choose-navlist-from-bookmark-list "bookmark-x")
(defun bmkx-choose-navlist-from-bookmark-list (bookmark &optional alist) ; Bound to `C-x x B'
  "Choose a bookmark-list bookmark and set the bookmark navigation list.
The navigation-list variable, `bmkx-nav-alist', is set to the list of
bookmarks that would be displayed by `bmkx-list' (`C-x r l')
for the chosen bookmark-list bookmark, sorted and filtered as
appropriate.

Instead of choosing a bookmark-list bookmark, you can choose the
pseudo-bookmark `CURRENT *Bmkx List*'.  The bookmarks used for the
navigation list are those that would be currently shown in the
`*Bmkx List*' (even if the list is not currently displayed).

BOOKMARK is a bookmark name or a bookmark record.
Optional arg ALIST is an alternative alist of bookmarks to use."
  (interactive
   (let ((bookmark-alist  (cons (bmkx-current-bookmark-list-state) (bmkx-bookmark-list-alist-only))))
     (list (bmkx-read-bookmark-for-type "bookmark-list" bookmark-alist nil nil
                                        'bmkx-bookmark-list-history "Choose ")
           bookmark-alist)))
  (setq alist  (or alist  (cons (bmkx-current-bookmark-list-state) (bmkx-bookmark-list-alist-only))))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR alist)))
  (let ((state  (let ((bookmark-alist  alist)) (bookmark-prop-get bookmark 'bookmark-list))))
    (let ((bname                            (bmkx-bookmark-name-from-record bookmark))
          (bmkx-sort-comparer               (cdr (assq 'last-sort-comparer              state)))
          (bmkx-reverse-sort-p              (cdr (assq 'last-reverse-sort-p             state)))
          (bmkx-reverse-multi-sort-p        (cdr (assq 'last-reverse-multi-sort-p       state)))
          (bmkx-bmenu-omitted-bookmarks     (cdr (assq 'last-bmenu-omitted-bookmarks    state)))
          (bmkx-bmenu-filter-function       (cdr (assq 'last-bmenu-filter-function      state)))
          (bmkx-bmenu-filter-pattern        (or (cdr (assq 'last-bmenu-filter-pattern   state))  ""))
          (bmkx-bmenu-title                 (cdr (assq 'last-bmenu-title                state)))
          (bookmark-bmenu-toggle-filenames  (cdr (assq 'last-bmenu-toggle-filenames state))))
      (setq bmkx-nav-alist             (bmkx-sort-omit (if bmkx-bmenu-filter-function
                                                           (funcall bmkx-bmenu-filter-function)
                                                         (if (string= "CURRENT *Bmkx List*" bname)
                                                             (or bmkx-latest-bookmark-alist  bookmark-alist)
                                                           bookmark-alist))
                                                       (and (not (eq bmkx-bmenu-filter-function
                                                                     'bmkx-omitted-alist-only))
                                                            bmkx-bmenu-omitted-bookmarks))
            bmkx-current-nav-bookmark  (car bmkx-nav-alist))
      (message "Bookmark navigation list is now %s"
               (if (and (string= "CURRENT *Bmkx List*" bname)  (not (get-buffer bmkx-bmenu-buffer)))
                   "the global bookmark list"
                 (format "`%s'" bname))))))

(defun bmkx-current-bookmark-list-state ()
  "Pseudo-bookmark for the current `*Bmkx List*' state."
  (bmkx-list-surreptitiously-rebuild-list 'NO-MSG-P)
  (cons "CURRENT *Bmkx List*" (bmkx-make-bookmark-list-record)))

;;; This function is used in macro `bmkx-define-history-variables', so
;;; its definition is also in `bookmark-x-mac.el'.
;;;
(defun bmkx-types-alist ()
  "Alist of bookmark types used by `bmkx-jump-to-type'.
Keys are bookmark type names.  Values are corresponding history variables.
The alist is used in commands such as `bmkx-jump-to-type'."
  (let ((entries  ()))
    (mapatoms
     (lambda (sym)
       (let ((name  (symbol-name sym)))
         (when (string-match "\\`bmkx-\\(.+\\)-alist-only\\'" name)
           (push (cons (match-string 1 name)
                       (intern (format "bmkx-%s-history" (match-string 1 name))))
                 entries)))))
    entries))

;;;###autoload (autoload 'bmkx-choose-navlist-of-type "bookmark-x")
(defun bmkx-choose-navlist-of-type (type) ; Bound to `C-x x :'
  "Set the bookmark navigation list to the bookmarks of a type you choose.
The pseudo-type `any' sets the navigation list to all bookmarks.
This sets variable `bmkx-nav-alist'."
  (interactive
   (let* ((completion-ignore-case                      t)
          (type                                        (completing-read "Type: "
                                                                        (cons '("any" . bookmark-history)
                                                                              (bmkx-types-alist))
                                                                        nil t nil nil "any")))
     (list type)))
  (setq bmkx-nav-alist  (if (equal "any" type)
                            bookmark-alist
                          (funcall (intern (format "bmkx-%s-alist-only" type)))))
  (unless bmkx-nav-alist (error "No bookmarks"))
  (setq bmkx-current-nav-bookmark  (car bmkx-nav-alist))
  (message "Bookmark navigation list is now %s"
           (if (equal "any" type) "all bookmarks" (format "for type `%s'" type))))

(defun bmkx-autonamed-bookmark-p (bookmark &optional buffer)
  "Return non-nil if BOOKMARK is an autonamed bookmark for BUFFER.
If BUFFER is nil then any buffer is OK.
BOOKMARK is a bookmark name or a bookmark record.
BUFFER, if non-nil, is a buffer or a buffer name."
  (unless (stringp bookmark) (setq bookmark  (bmkx-bookmark-name-from-record bookmark)))
  (when (bufferp buffer) (setq buffer  (buffer-name buffer)))
  (let ((nargs  0)
        (start  0))
    (save-match-data
      (while (string-match "%\\([+ #-0]+\\)?\\([0-9]+\\)?\\([.][0-9]+\\)?[BsSdoxXefgc]"
                           bmkx-autoname-format
                           start)
        (setq nargs  (1+ nargs)
              start  (match-end 0))))
    (string-match-p
     (apply #'format
            (bmkx-format-spec bmkx-autoname-format `((?B . ,(if buffer (regexp-quote buffer) ".*"))))
            (make-list nargs ".*"))
     bookmark)))

(defun bmkx-format-spec (format specification)
  "Like `format-spec', but respect standard `format' %-sequences.
%-sequences specified in SPECIFICATION are handled per `format-spec'
Any standard `format' %-sequences not specified in SPECIFICATION are
left as is.

This is also more general than `format-spec', in that the full format
of a %-sequence is supported: `%<flags><width><precision>character'.
`format-spec' does not support precision>, and it supports only the
flags `-' and `0'."
  (with-temp-buffer
    (insert format)
    (goto-char (point-min))
    (while (search-forward "%" nil t)
      (cond ((eq (char-after) ?%) (delete-char 1)) ; Quoted percent sign.
            ((looking-at "\\([+ #-0]+\\)?\\([0-9]+\\)?\\([.][0-9]+\\)?\\([a-zA-Z]\\)")
             (let* ((num   (match-string 2))
                    (spec  (string-to-char (match-string 4)))
                    (val   (assq spec specification)))
               (if (not val)
                   ;; Ignore standard format chars that are not redefined by SPECIFICATION.
                   (unless (memq (string-to-char (match-string 4)) '(?s ?S ?d ?o ?x ?X ?e ?f ?g ?c))
                     (error "Invalid format character: `%%%c'" spec))
                 (setq val  (cdr val))
                 (let ((text  (format (concat "%" num "s") val))) ; Pad result to desired length.
                   (insert-and-inherit text) ; Insert first, to preserve text properties.
                   (delete-region (+ (match-beginning 0) (length text)) ; Delete specifier body.
                                  (+ (match-end 0) (length text)))
                   (delete-region (1- (match-beginning 0)) ; Delete percent sign.
                                  (match-beginning 0))))))
            (t (error "Invalid format string"))))
    (buffer-string)))

(defun bmkx-autonamed-this-buffer-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is an autonamed bookmark for this buffer."
  (unless (stringp bookmark) (setq bookmark  (bmkx-bookmark-name-from-record bookmark)))
  (bmkx-autonamed-bookmark-p bookmark (buffer-name)))

(defun bmkx-autonamed-bookmark-for-buffer-p (bookmark buffer-name)
  "Return non-nil if BOOKMARK is an autonamed bookmark for BUFFER.
BOOKMARK is a bookmark name or a bookmark record.
BUFFER-NAME is a string matching the buffer-name part of an autoname.
This does not check the `buffer-name' entry of BOOKMARK.  It checks
only the buffer indicated by the bookmark name."
  (unless (stringp bookmark) (setq bookmark  (bmkx-bookmark-name-from-record bookmark)))
  (bmkx-autonamed-bookmark-p bookmark buffer-name))

(defun bmkx-update-autonamed-bookmark (bookmark)
  "Update the name and position of the autonamed BOOKMARK at point.
Return the updated BOOKMARK: If input was a bookmark name, then return
 then new name, else the new (full) bookmark.
It is a good idea to set BOOKMARK to the result of this call.
BOOKMARK is a bookmark name or a bookmark record."
  (let ((namep  (stringp bookmark)))
    (setq bookmark  (bmkx-get-bookmark bookmark))
    (bookmark-set-position bookmark (point))
    ;; Autonamed bookmarks do not have regions.  Update `end-position' to be the same as `position'.
    (when (bmkx-get-end-position bookmark)
      (bmkx-prop-set bookmark 'end-position (point)))
    (let ((newname  (funcall bmkx-autoname-bookmark-function (point))))
      (bmkx-rename (bmkx-bookmark-name-from-record bookmark) newname 'BATCHP)
      (bmkx-refresh/rebuild-menu-list (bmkx-bookmark-name-from-record bookmark)) ; So display new name.
      (bmkx-maybe-save-bookmarks))
    (if namep (bmkx-bookmark-name-from-record bookmark) bookmark))) ; Return updated bookmark or name.

;;;###autoload (autoload 'bmkx-this-file/buffer-bmenu-list "bookmark-x")
(defun bmkx-this-file/buffer-bmenu-list () ; Bound to `C-x x ,'
  "Show the bookmark list just for bookmarks for the current file/buffer.
If visiting a file, this is `bmkx-this-file-bmenu-list'.  Otherwise,
this is `bmkx-this-buffer-bmenu-list'."
  (interactive)
  (if (buffer-file-name) (bmkx-this-file-bmenu-list) (bmkx-this-buffer-bmenu-list)))

;;;###autoload (autoload 'bmkx-this-file-bmenu-list "bookmark-x")
(defun bmkx-this-file-bmenu-list ()
  "Show the bookmark list just for bookmarks for the current file.
Set `bmkx-last-specific-file' to the current file name.
If the current buffer is not visiting a file, prompt for the file name."
  (interactive)
  (unless bookmark-alist (bmkx-maybe-load-default-file)) ; Just to be sure.
  (let ((orig-last-spec-file  bmkx-last-specific-file)
        (orig-filter-fn       bmkx-bmenu-filter-function)
        (orig-title           bmkx-bmenu-title)
        (orig-latest-alist    bmkx-latest-bookmark-alist))
    (condition-case err
        (progn
          (setq bmkx-last-specific-file     (or (buffer-file-name)
                                                (let ()
                                                  (read-file-name "File: ")))
                bmkx-bmenu-filter-function  'bmkx-last-specific-file-alist-only
                bmkx-bmenu-title            (format "File `%s' Bookmarks" bmkx-last-specific-file))
          (let ((bookmark-alist         (funcall bmkx-bmenu-filter-function))
                (bmkx-bmenu-state-file  nil)) ; Prevent restoring saved state.
            (unless bookmark-alist (error "No bookmarks for file `%s'" bmkx-last-specific-file))
            (setq bmkx-latest-bookmark-alist  bookmark-alist)
            (pop-to-buffer (get-buffer-create bmkx-bmenu-buffer))
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

;;;###autoload (autoload 'bmkx-this-buffer-bmenu-list "bookmark-x")
(defun bmkx-this-buffer-bmenu-list ()
  "Show the bookmark list just for bookmarks for the current buffer.
Set `bmkx-last-specific-buffer' to the current buffer name."
  (interactive)
  (unless bookmark-alist (bmkx-maybe-load-default-file))
  (let ((orig-last-spec-buf  bmkx-last-specific-buffer)
        (orig-filter-fn      bmkx-bmenu-filter-function)
        (orig-title          bmkx-bmenu-title)
        (orig-latest-alist   bmkx-latest-bookmark-alist))
    (condition-case err
        (progn
          (setq bmkx-last-specific-buffer   (buffer-name)
                bmkx-bmenu-filter-function  'bmkx-last-specific-buffer-alist-only
                bmkx-bmenu-title            (format "Buffer `%s' Bookmarks"
                                                    bmkx-last-specific-buffer))
          (let ((bookmark-alist         (funcall bmkx-bmenu-filter-function))
                (bmkx-bmenu-state-file  nil)) ; Prevent restoring saved state.
            (unless bookmark-alist (error "No bookmarks for buffer `%s'"
                                          bmkx-last-specific-buffer))
            (setq bmkx-latest-bookmark-alist  bookmark-alist)
            (pop-to-buffer (get-buffer-create bmkx-bmenu-buffer))
            (bmkx-list 'filteredp))
          (when (called-interactively-p 'interactive)
            (bmkx-msg-about-sort-order (bmkx-current-sort-order)
                                       (format "Only bookmarks for buffer `%s' are shown"
                                               bmkx-last-specific-buffer)))
          (raise-frame))
      (error (progn (setq bmkx-last-specific-buffer   orig-last-spec-buf
                          bmkx-bmenu-filter-function  orig-filter-fn
                          bmkx-bmenu-title            orig-title
                          bmkx-latest-bookmark-alist  orig-latest-alist)
                    (error "%s" (error-message-string err)))))))

;;;###autoload (autoload 'bmkx-navlist-bmenu-list "bookmark-x")
(defun bmkx-navlist-bmenu-list ()       ; Bound to `C-x x N'
  "Show the bookmark list just for bookmarks from the navigation list."
  (interactive)
  (unless bmkx-nav-alist
    (bmkx-maybe-load-default-file)
    (setq bmkx-nav-alist  bookmark-alist)
    (unless bmkx-nav-alist (error "No bookmarks"))
    (setq bmkx-current-nav-bookmark  (car bmkx-nav-alist))
    (message "Bookmark navigation list is now the GLOBAL bookmark list") (sit-for 2))
  (let ((orig-title         bmkx-bmenu-title)
        (orig-latest-alist  bmkx-latest-bookmark-alist))
    (condition-case err
        (progn
          (setq bmkx-bmenu-title  "Current Navlist Bookmarks")
          (let ((bookmark-alist         bmkx-nav-alist)
                (bmkx-bmenu-state-file  nil)) ; Prevent restoring saved state.
            (unless bookmark-alist (error "No bookmarks"))
            (setq bmkx-latest-bookmark-alist  bookmark-alist)
            (pop-to-buffer (get-buffer-create bmkx-bmenu-buffer))
            (bmkx-list 'filteredp))
          (when (called-interactively-p 'interactive)
            (bmkx-msg-about-sort-order (bmkx-current-sort-order)
                                       "Only bookmarks for the navigation list are shown"))
          (raise-frame))
      (error (progn (setq bmkx-bmenu-title            orig-title
                          bmkx-latest-bookmark-alist  orig-latest-alist)
                    (error "%s" (error-message-string err)))))))

(defun bmkx-completing-read-buffer-name (&optional no-default-p)
  "Read the name of a buffer associated with a bookmark.
The candidates are the buffers in `bmkx-buffer-names'.
Non-nil NO-DEFAULT-P means provide no default value.  Used when
 called in a loop, to let the user exit using empty input.
If NO-DEFAULT-P is nil, then the default is the current buffer's name,
 or the value of `bmkx-last-specific-buffer' if the current buffer has
 no bookmarks."
  (bmkx-maybe-load-default-file)
  (let ()
    (completing-read "Buffer: " (mapcar #'list (bmkx-buffer-names)) nil t nil 'buffer-name-history
                     (and (not no-default-p)
                          (if (member (buffer-name) (bmkx-buffer-names))
                              (buffer-name)
                            bmkx-last-specific-buffer)))))

(defun bmkx-completing-read-file-name (&optional no-default-p)
  "Read the name of a file associated with a bookmark.
The candidates are the absolute file names in `bmkx-file-names'.
Non-nil NO-DEFAULT-P means provide no default value.  Used when
 called in a loop, to let the user exit using empty input.
If NO-DEFAULT-P is nil, then the default is the current buffer's file
 name, if any, or the value of `bmkx-last-specific-file' if the
 current buffer has no associated file or the file has no bookmarks."
  (bmkx-maybe-load-default-file)
  (let ((completion-ignore-case  (if (boundp 'read-file-name-completion-ignore-case)
                                     read-file-name-completion-ignore-case
                                   (memq system-type
                                         '(ms-dos windows-nt darwin cygwin)))))
    (completing-read "File: " (mapcar #'list (bmkx-file-names)) nil t nil 'file-name-history
                     (and (not no-default-p)
                          (let ((file  (buffer-file-name)))
                            (if (and file  (member file (bmkx-file-names)))
                                file
                              bmkx-last-specific-file))))))

(defun bmkx-refresh/rebuild-menu-list (&optional bookmark no-msg-p)
  "Refresh or rebuild buffer `*Bmkx List*'.
If the buffer is already displayed, call `bmkx-refresh-menu-list'.
Otherwise, call `bmkx-list-surreptitiously-rebuild-list'.
Args are the same as for `bmkx-refresh-menu-list'."
  (let ((bmklistbuf  (get-buffer bmkx-bmenu-buffer)))
    (if (and bmklistbuf  (get-buffer-window bmklistbuf 0))
        (with-current-buffer bmklistbuf (bmkx-refresh-menu-list bookmark no-msg-p))
      (bmkx-list-surreptitiously-rebuild-list no-msg-p))))

(defun bmkx-refresh-menu-list (&optional bookmark no-msg-p)
  "Refresh (revert) the bookmark list (\"menu list\").
This brings the displayed list up to date.  It does not change the
current filtering or sorting of the displayed list.
Non-nil optional arg BOOKMARK means move cursor to BOOKMARK's line.
BOOKMARK is a bookmark name or a bookmark record.
Non-nil optional arg NO-MSG-P means do not show progress messages."
  (let ((bookmark-alist  (if bmkx-bmenu-filter-function
                             (funcall bmkx-bmenu-filter-function)
                           bookmark-alist)))
    (setq bmkx-latest-bookmark-alist  bookmark-alist)
    (unless no-msg-p  (message "Updating bookmark list..."))
    (bmkx-list bmkx-bmenu-filter-function) ; No filter function means start anew.
    (when bookmark
      (unless (stringp bookmark) (setq bookmark  (bmkx-bookmark-name-from-record bookmark)))
      (with-current-buffer (get-buffer bmkx-bmenu-buffer)
        (bmkx-bmenu-goto-bookmark-named bookmark)
        (let ((bmenu-win  (get-buffer-window (current-buffer) 0)))
          (when bmenu-win (set-window-point bmenu-win (point))))))
    (unless no-msg-p  (message "Updating bookmark list...done"))))

;;;###autoload (autoload 'bmkx-unomit-all "bookmark-x")
(defun bmkx-unomit-all (&optional msg-p) ; Bound to `O U' in bookmark list
  "Remove all bookmarks from the list of omitted bookmarks.
After this, all bookmarks are available for display.
Non-interactively, non-nil optional arg MSG-P means display a status
message."
  (interactive "p")
  (unless bmkx-bmenu-omitted-bookmarks (error "No omitted bookmarks to UN-omit"))
  (when msg-p (message "UN-omitting ALL omitted bookmarks..."))
  (let ((count  0))
    (dolist (bmk-name  bmkx-bmenu-omitted-bookmarks)
      (setq bmkx-bmenu-omitted-bookmarks  (bmkx-delete-bookmark-name-from-list
                                           bmk-name bmkx-bmenu-omitted-bookmarks)
            count                         (1+ count)))
    (bmkx-list-surreptitiously-rebuild-list (not msg-p))
    (when msg-p (message "UN-omitted %d bookmarks" count)))
  (when (equal (buffer-name (current-buffer)) bmkx-bmenu-buffer) (bmkx-bmenu-show-all))
  (bmkx-fit-bmenu-frame))


;;(@* "Search-and-Replace Locations of Marked Bookmarks")
;;  *** Search-and-Replace Locations of Marked Bookmarks ***

(progn (defvar bmkx-isearch-bookmarks nil
    "Bookmarks whose locations are to be incrementally searched.")

  (defun bmkx-isearch-next-bookmark-buffer (&optional _buffer wrap)
    "Return the next buffer in a series of bookmark buffers.
Used as a value for `multi-isearch-next-buffer-function', for Isearch
of multiple bookmarks.

Variable `bmkx-isearch-bookmarks' is a list of bookmarks.  Each
bookmark in the list is visited by `bmkx--jump-via', and the
corresponding bookmark buffer is returned."
    (let ((bookmarks  (if isearch-forward bmkx-isearch-bookmarks (reverse bmkx-isearch-bookmarks))))
      (bmkx--jump-via
       (if wrap
           (car bookmarks)
         (let ((this-bmk  (catch 'bmkx-isearch-next-bookmark-buffer
                            (dolist (bmk  bookmarks)
                              (when (if (bmkx-get-buffer-name bmk)
                                        (equal (bmkx-get-buffer-name bmk) (buffer-name))
                                      (equal (bookmark-get-filename bmk) (buffer-file-name)))
                                (throw 'bmkx-isearch-next-bookmark-buffer bmk)))
                            (car bookmarks))))
           (cadr (member this-bmk bookmarks))))
       'ignore)
      (current-buffer)))

  (defun bmkx-isearch-bookmarks (bookmarks)
    "Start multi-bookmark Isearch on BOOKMARKS."
    (let ((multi-isearch-next-buffer-function  'bmkx-isearch-next-bookmark-buffer)
          (bmkx-isearch-bookmarks              bookmarks))
      (bmkx-jump (car bookmarks))
      (goto-char (if isearch-forward (point-min) (point-max)))
      (isearch-forward)))

  (defun bmkx-isearch-bookmarks-regexp (bookmarks)
    "Start multi-bookmark regexp Isearch on BOOKMARKS."
    (let ((multi-isearch-next-buffer-function  'bmkx-isearch-next-bookmark-buffer)
          (bmkx-isearch-bookmarks              bookmarks))
      (bmkx-jump (car bookmarks))
      (goto-char (if isearch-forward (point-min) (point-max)))
      (isearch-forward-regexp))))


;;(@* "Tags")
;;  *** Tags ***

(defun bmkx-get-tags (bookmark)
  "Return the `tags' entry for BOOKMARK.
BOOKMARK is a bookmark name or a bookmark record."
  (bookmark-prop-get bookmark 'tags))

(defalias 'bmkx-tagged-bookmark-p 'bmkx-get-tags)

(defun bmkx-get-tag-value (bookmark tag)
  "Return value of BOOKMARK's tag TAG.
BOOKMARK is a bookmark name or a bookmark record.
TAG is a string.
Return nil if BOOKMARK has no such TAG or if TAG has no value."
  (assoc-default tag (bmkx-get-tags bookmark)))

(defun bmkx-has-tag-p (bookmark tag)
  "Return non-nil if BOOKMARK is tagged with TAG.
BOOKMARK is a bookmark name or a bookmark record.
TAG is a string."
  (assoc-default tag (bmkx-get-tags bookmark) nil t))

;; NOT USED currently - we use `bmkx-read-tags-completing' instead.
(defun bmkx-read-tags ()
  "Read tags one by one, and return them as a list."
  (let ((tag    (read-string "Tag (RET for each, empty input to finish): "))
        (btags  ()))
    (while (not (string= "" tag))
      (push tag btags)
      (setq tag  (read-string "Tag: ")))
    btags))

(defun bmkx-read-tag-completing (&optional prompt candidate-tags require-match update-tags-alist-p)
  "Read a tag with completion, and return it as a string.
The candidate tags available are determined by option
`bmkx-tags-for-completion'.

PROMPT is the prompt string.  If nil, then use \"Tag: \".
CANDIDATE-TAGS is an alist of tags to use for completion.
 If nil, then all tags from all bookmarks are used for completion.
 The set of all tags is taken from variable `bmkx-tags-alist'.
REQUIRE-MATCH is passed to `completing-read'.
Non-nil UPDATE-TAGS-ALIST-P means update var `bmkx-tags-alist'."
  (bmkx-maybe-load-default-file)
  (let ((cand-tags  (copy-sequence
                     (or candidate-tags
                         (and (not update-tags-alist-p)
                              bmkx-tags-alist) ; Use cached list.
                         (bmkx-tags-list))))) ; Update the cache.
    (completing-read (or prompt  "Tag: ") cand-tags nil require-match nil 'bmkx-tag-history)))

(defconst bmkx-read-tags--skip-sentinel "[none]"
  "Sentinel candidate offered at the tag prompt to mean \"no tags\".
Selecting it (or submitting an empty input in plain-Emacs
completion) makes `bmkx-read-tags-completing' return nil.
Filtered out of the result; never recorded as a tag.")

(defun bmkx-read-tags-completing (&optional candidate-tags require-match update-tags-alist-p)
  "Read tags with completion, and return them as a list of strings.
Tags are entered comma-separated in a single prompt; each segment has
its own completion against the candidate list.

To skip (return no tags) in plain Emacs, submit empty input.  In
completion frameworks that auto-select the highlighted candidate
on RET (Vertico, Ivy, Helm with some configurations), the first
candidate offered is `bmkx-read-tags--skip-sentinel'; selecting
it has the same effect.  The sentinel is filtered out and never
recorded.

CANDIDATE-TAGS is an alist of tags to use for completion.
 If nil then the candidate tags are taken from variable
 `bmkx-tags-alist'.
REQUIRE-MATCH is passed to `completing-read-multiple'.
Non-nil UPDATE-TAGS-ALIST-P means update var `bmkx-tags-alist',
determining the tags to use per option `bmkx-tags-for-completion'."
  (bmkx-maybe-load-default-file)
  (let* ((source         (or candidate-tags
                             (and (not update-tags-alist-p)  bmkx-tags-alist)
                             (bmkx-tags-list)))
         (tags           (delete-dups
                          (mapcar (lambda (tg) (if (consp tg) (car tg) tg))
                                  source)))
         ;; Sentinel goes first so frameworks with `vertico-preselect'
         ;; (or equivalent) highlight it instead of a real tag.  We
         ;; recognise and strip it from the result below.  The
         ;; completion-table metadata pins our order: without it,
         ;; Vertico would re-sort alphabetically and push [none] to
         ;; the bottom of the candidate list, defeating the purpose.
         (cands          (cons bmkx-read-tags--skip-sentinel tags))
         (table          (lambda (string pred action)
                           (if (eq action 'metadata)
                               '(metadata
                                 (display-sort-function . identity)
                                 (cycle-sort-function   . identity))
                             (complete-with-action action cands string pred))))
         (crm-separator  ",")
         (raw            (completing-read-multiple
                          "Tags (comma-separated, [none] to skip): "
                          table nil require-match nil 'bmkx-tag-history)))
    (delete-dups
     (delq nil
           (mapcar (lambda (s)
                     (let ((trim (string-trim s)))
                       (and (not (string-empty-p trim))
                            (not (equal trim bmkx-read-tags--skip-sentinel))
                            trim)))
                   raw)))))

;;;###autoload (autoload 'bmkx-list-all-tags "bookmark-x")
(defun bmkx-list-all-tags (fullp current-only-p &optional msg-p)
                                        ; Bound to `C-x x t l', (`T l' in bookmark list)
  "List bookmark tags.
Show the list in the minibuffer or, if not enough space, in buffer
`*All Tags*'.  The tags are listed alphabetically, respecting option
`case-fold-search'.

With no prefix arg or with a plain prefix arg (`C-u'), the tags listed
are those defined by option `bmkx-tags-for-completion'.  Otherwise
\(i.e., with a numeric prefix arg), the tags listed are those from the
current list of bookmarks only.

With no prefix arg or with a negative prefix arg (e.g. `C--'), list
only the tag names.  With a non-negative prefix arg (e.g. `C-1' or
plain `C-u'), list the full alist of tags.

Note that when the full tags alist is shown, the same tag name appears
once for each of its different values.

Non-interactively, non-nil MSG-P means display a status message."
  (interactive (list (and current-prefix-arg  (> (prefix-numeric-value current-prefix-arg) 0))
                     (and current-prefix-arg  (not (consp current-prefix-arg)))
                     'MSG))
  (require 'pp)
  (when msg-p (message "Gathering tags..."))
  (pp-display-expression  (sort (bmkx-tags-list (not fullp) current-only-p)
                                (if fullp
                                    (lambda (t1 t2) (bmkx-string-less-case-fold-p (car t1) (car t2)))
                                  'bmkx-string-less-case-fold-p))
                          "*All Tags*"))

(defun bmkx-tags-list (&optional names-only-p current-only-p)
  "List of all bookmark tags, per option `bmkx-tags-for-completion'.
Non-nil NAMES-ONLY-P means return a list of only the tag names.
Otherwise, return an alist of the full tags and set variable
`bmkx-tags-alist' to that alist, as a cache.

Non-nil CURRENT-ONLY-P means ignore option `bmkx-tags-for-completion'
and return only the tags for the currently loaded bookmarks."
  (let ((tags      ())
        (opt-tags  bmkx-tags-for-completion)
        bmk-tags)
    (when (or (eq opt-tags 'current)  current-only-p)  (setq opt-tags '(current)))
    (dolist (entry  opt-tags)
      (cl-typecase entry
        (cons    (when (eq 'bmkfile (car entry)) ; A bookmark file
                   (setq entry  (cdr entry)
                         tags   (append tags (bmkx-tags-in-bookmark-file entry names-only-p)))))
        (string  (let ((ent  (if names-only-p entry (list entry))))
                   (unless (member ent tags) (setq tags  (cons ent tags)))))
        (symbol  (when (eq entry 'current)
                   (bmkx-maybe-load-default-file)
                   (dolist (bmk  bookmark-alist)
                     (setq bmk-tags  (bmkx-get-tags bmk))
                     (dolist (tag  bmk-tags)
                       (let ((tg  (if names-only-p (bmkx-tag-name tag) (bmkx-full-tag tag))))
                         (unless (member tg tags) (setq tags  (cons tg tags))))))))))
    (unless names-only-p (setq bmkx-tags-alist  tags))
    tags))

(defun bmkx-tags-in-bookmark-file (file &optional names-only-p)
  "Return the list of tags from all bookmarks in bookmark-file FILE.
If FILE is a relative file name, it is expanded in `default-directory.
If FILE does not name a valid, bookmark file then nil is returned.
Non-nil NAMES-ONLY-P means return a list of only the tag names.
Otherwise, return an alist of the full tags."
  (setq file  (expand-file-name file))
  (when (file-directory-p file) (error "`%s' is a directory, not a file" file))
  (let ((bookmark-save-flag  nil)       ; Just to play safe.
        (bmk-alist           ())
        (tags                ())
        bmk-tags)
    (if (not (file-readable-p file))
        (message "Cannot read bookmark file `%s'" file)
      (with-current-buffer (let ((enable-local-variables  ())) (find-file-noselect file))
        (goto-char (point-min))
        (condition-case nil ; Check whether it's a valid bookmark file.
            (unless (listp (setq bmk-alist  (bmkx-alist-from-buffer))) (error ""))
          (error (message "Not a valid bookmark file: `%s'" file))))
      (dolist (bmk  bmk-alist)
        (setq bmk-tags  (bmkx-get-tags bmk))
        (dolist (tag  bmk-tags)
          (let ((tg  (if names-only-p (bmkx-tag-name tag) (bmkx-full-tag tag))))
            (unless (member tg tags) (setq tags  (cons tg tags)))))))
    tags))

(defun bmkx-tag-name (tag)
  "Name of TAG.  If TAG is an atom, then TAG, else (car TAG)."
  (if (atom tag) tag (car tag)))

(defun bmkx-full-tag (tag)
  "Full cons entry for TAG.  If TAG is a cons, then TAG, else (list TAG)."
  (if (consp tag) tag (list tag)))

;;;###autoload (autoload 'bmkx-remove-all-tags "bookmark-x")
(defun bmkx-remove-all-tags (bookmark &optional no-update-p msg-p)
                                        ; Bound to `C-x x t 0', (`T 0' in bookmark list)
  "Remove all tags from BOOKMARK.
Non-interactively:
 - Non-nil NO-UPDATE-P means do not update `bmkx-tags-alist', do not
   update the modification count and maybe save bookmarks, and do not
   refresh/rebuild the bookmark-list display
 - Non-nil optional arg MSG-P means show a message about the removal."
  (interactive (list (bmkx-completing-read "Bookmark" (bmkx-default-bookmark-name)) nil 'MSG))
  (when (and msg-p  (null (bmkx-get-tags bookmark)))  (error "Bookmark has no tags to remove"))
  (let ((nb-removed  (and (called-interactively-p 'interactive)  (length (bmkx-get-tags bookmark)))))
    (bmkx-prop-set bookmark 'tags ())
    (unless no-update-p
      (bmkx-tags-list)                  ; Update the tags cache.
      (bmkx-maybe-save-bookmarks)       ; Increments `bookmark-alist-modification-count'.
      (bmkx-refresh/rebuild-menu-list bookmark (not msg-p))) ; So remove `t' marker and add `*' marker.
    (when (and msg-p  nb-removed)  (message "%d tags removed" nb-removed)))) ; Do after msg from refreshing.


;;;###autoload (autoload 'bmkx-add-tags "bookmark-x")
(defun bmkx-add-tags (bookmark tags &optional no-update-p msg-p)
                                        ; `C-x x t + b' (`b' for bookmark), (`T +' in bookmark list)
  "Add TAGS to BOOKMARK.
Hit `RET' to enter each tag, then hit `RET' again after the last tag.
You can use completion to enter the bookmark name and each tag.
Completion for the bookmark name is strict.
Completion for tags is lax: you are not limited to existing tags.

By default, the tag choices for completion are NOT refreshed, to save
time.  Use a prefix argument if you want to refresh them.

Non-interactively:
 - TAGS is a list of strings.
 - Non-nil MSG-P means display a message about the addition.
 - Non-nil NO-UPDATE-P means do not update `bmkx-tags-alist', do not
   update the modification count and maybe save bookmarks, and do not
   refresh/rebuild the bookmark-list display

The absolute value of the return value is the number of tags added.
If BOOKMARK was untagged before the operation, then the return value
is negative."
  (interactive (list (bmkx-completing-read "Bookmark" (bmkx-default-bookmark-name))
                     (bmkx-read-tags-completing nil nil current-prefix-arg)
                     nil
                     'MSG))
  (let* ((newtags  (copy-alist (bmkx-get-tags bookmark)))
         (olen     (length newtags)))
    (dolist (tag  tags)  (unless (or (assoc tag newtags)  (member tag newtags))  (push tag newtags)))
    (bmkx-prop-set bookmark 'tags newtags)
    (unless no-update-p
      (bmkx-tags-list)                  ; Update the tags cache.
      (bmkx-maybe-save-bookmarks) ; Increments `bookmark-alist-modification-count'.
      (bmkx-refresh/rebuild-menu-list bookmark (not msg-p))) ; So display `t' and `*' markers for BOOKMARK.
    (let ((nb-added  (- (length newtags) olen)))
      (when msg-p (message "%d tags added. Now: %S" nb-added ; Echo just the tag names.
                           (let ((tgs  (mapcar #'bmkx-tag-name newtags))) (setq tgs (sort tgs #'string<)))))
      (when (and (zerop olen)  (> (length newtags) 0)) (setq nb-added  (- nb-added)))
      nb-added)))

;; $$$$$$ Not yet used
;;;###autoload (autoload 'bmkx-set-tag-value-for-navlist "bookmark-x")
(defun bmkx-set-tag-value-for-navlist (tag value &optional msg-p) ; Bound to `C-x x t V'
  "Set the value of TAG to VALUE, for each bookmark in the navlist.
If any of the bookmarks has no tag named TAG, then add one with VALUE."
  (interactive (list (bmkx-read-tag-completing) (read (read-string "Value: ")) 'msg))
  (bmkx-set-tag-value-for-bookmarks bmkx-nav-alist tag value msg-p))

;; $$$$$$ Not yet used
(defun bmkx-set-tag-value-for-bookmarks (bookmarks tag value &optional msg-p) ; Not bound
  "Set the value of TAG to VALUE, for each of the BOOKMARKS.
If any of the BOOKMARKS has no tag named TAG, then add one with VALUE."
  (let ((bookmark-save-flag  (and (not bmkx-count-multi-mods-as-one-flag)
                                  bookmark-save-flag))) ; Save only after `dolist'.
    (dolist (bmk  bookmarks) (bmkx-set-tag-value bmk tag value 'NO-UPDATE-P)))
  (bmkx-tags-list)            ; Update the tags cache.
  (bmkx-maybe-save-bookmarks) ; Increments `bookmark-alist-modification-count'.
  (bmkx-refresh/rebuild-menu-list nil (not msg-p)))

;;;###autoload (autoload 'bmkx-set-tag-value "bookmark-x")
(defun bmkx-set-tag-value (bookmark tag value &optional no-update-p msg-p) ; Bound to `C-x x t v'
  "For BOOKMARK's TAG, set the value to VALUE.
If BOOKMARK has no tag named TAG, then add one with value VALUE.
Non-interactively:
 - Non-nil NO-UPDATE-P means do not update `bmkx-tags-alist', do not
   update the modification count and maybe save bookmarks, and do not
   refresh/rebuild the bookmark-list display
 - Non-nil MSG-P means display a message about the updated value."
  (interactive
   (let* ((bmk  (bmkx-completing-read "Bookmark" (bmkx-default-bookmark-name)))
          (tag  (bmkx-read-tag-completing "Tag: " (mapcar 'bmkx-full-tag (bmkx-get-tags bmk)))))
     (list bmk tag (read (read-string "Value: ")) nil 'MSG)))
  (unless (bmkx-has-tag-p bookmark tag) (bmkx-add-tags bookmark (list tag) 'NO-UPDATE-P)) ; No update yet.
  (let* ((newtags     (copy-alist (bmkx-get-tags bookmark)))
         (assoc-tag   (assoc tag newtags))
         (member-tag  (and (not assoc-tag)  (member tag newtags))))
    (if assoc-tag (setcdr assoc-tag value) (setcar member-tag (cons (car member-tag) value)))
    (bmkx-prop-set bookmark 'tags newtags))
  (unless no-update-p
    (bmkx-tags-list)                    ; Update the tags cache.
    (bmkx-maybe-save-bookmarks)         ; Increments `bookmark-alist-modification-count'.
    (bmkx-refresh/rebuild-menu-list bookmark (not msg-p))) ; So display `t' and `*' markers for BOOKMARK.
  (when msg-p "Tag value set"))

;;;###autoload (autoload 'bmkx-remove-tags "bookmark-x")
(defun bmkx-remove-tags (bookmark tags &optional no-update-p msg-p)
                                        ; `C-x x t - b' (`b' for bookmark), (`T -' in bookmark list)
  "Remove TAGS from BOOKMARK.
Hit `RET' to enter each tag, then hit `RET' again after the last tag.
You can use completion to enter the bookmark name and each tag.

By default, the tag choices for completion are NOT refreshed, to save
time.  Use a prefix argument if you want to refresh them.

Non-interactively:
 - TAGS is a list of strings.  The corresponding tags are removed.
 - Non-nil MSG-P means display status messages.
 - Non-nil NO-UPDATE-P means do not update `bmkx-tags-alist', do not
   update the modification count and maybe save bookmarks, and do not
   refresh/rebuild the bookmark-list display

The absolute value of the return value is the number of tags removed.
If BOOKMARK is untagged after the operation, then the return value
is negative."
  (interactive (let ((bmk  (bmkx-completing-read "Bookmark" (bmkx-default-bookmark-name))))
                 (list bmk
                       (bmkx-read-tags-completing (mapcar 'bmkx-full-tag (bmkx-get-tags bmk))
                                                  t current-prefix-arg)
                       nil
                       'MSG)))
  (let* ((remtags  (copy-alist (bmkx-get-tags bookmark)))
         (olen     (length remtags)))
    (if (null remtags)
        (when msg-p (message "Bookmark has no tags to remove")) ; Do nothing if bookmark has no tags.
      (setq remtags  (bmkx-remove-if (let ((tgs  tags))
                                       (lambda (tag)
                                         (if (atom tag) (member tag tgs) (member (car tag) tgs))))
                                     remtags))
      (bmkx-prop-set bookmark 'tags remtags)
      (unless no-update-p
        (bmkx-tags-list)                ; Update the tags cache.
        (bmkx-maybe-save-bookmarks)     ; Increments `bookmark-alist-modification-count'.
        (bmkx-refresh/rebuild-menu-list bookmark (not msg-p))) ; So remove `t' marker if no tags.
      (let ((nb-removed  (- olen (length remtags))))
        (when msg-p (message "%d tags removed. Now: %S" nb-removed ; Echo just the tag names.
                             (let ((tgs  (mapcar #'bmkx-tag-name remtags)))
                               (setq tgs (sort tgs #'string<)))))
        (when (and (zerop (length remtags))  (> olen 0)) (setq nb-removed  (- nb-removed)))
        nb-removed))))

;;;###autoload (autoload 'bmkx-remove-tags-from-all "bookmark-x")
(defun bmkx-remove-tags-from-all (tags &optional msg-p) ; Bound to `C-x x t d', (`T d' in bookmark list)
  "Remove TAGS from all bookmarks.
Hit `RET' to enter each tag, then hit `RET' again after the last tag.
You can use completion to enter each tag.
This affects all bookmarks, even those not showing in bookmark list.

By default, the tag choices for completion are NOT refreshed, to save
time.  Use a prefix argument if you want to refresh them.

Non-interactively:
* TAGS is a list of strings.  The corresponding tags are removed.
* Non-nil optional arg MSG-P means show a message about the deletion."
  (interactive
   (if (not (y-or-n-p "Delete the tags you specify from ALL bookmarks? "))
       (error "OK - deletion canceled")
     (list (bmkx-read-tags-completing nil t current-prefix-arg) 'MSG)))
  (let ((bookmark-save-flag  (and (not bmkx-count-multi-mods-as-one-flag)
                                  bookmark-save-flag))) ; Save only after `dolist'.
    (dolist (bmk  (bmkx-all-names)) (bmkx-remove-tags bmk tags 'NO-UPDATE-P)))
  (bmkx-tags-list)        ; Update the tags cache (only once, at end).
  (bmkx-maybe-save-bookmarks) ; Increments `bookmark-alist-modification-count'.
  (bmkx-refresh/rebuild-menu-list nil (not msg-p)) ; So remove `t' markers when no tags anymore.
  (when msg-p (message "Tags removed from all bookmarks: %S" tags)))

;;;###autoload (autoload 'bmkx-rename-tag "bookmark-x")
(defun bmkx-rename-tag (tag newname &optional msg-p) ; Bound to `C-x x t r', (`T r' in bookmark list)
  "Rename TAG to NEWNAME in all bookmarks, even those not showing.
Non-interactively, non-nil MSG-P means display a message about the
deletion."
  (interactive (list (bmkx-read-tag-completing "Tag (old name): ")
                     (bmkx-read-tag-completing "New name: ")
                     'MSG))
  (let ((tag-exists-p        nil)
        (bookmark-save-flag  (and (not bmkx-count-multi-mods-as-one-flag)
                                  bookmark-save-flag))) ; Save only after `dolist'.
    (dolist (bmk  (bmkx-all-names))
      (let ((newtags  (copy-alist (bmkx-get-tags bmk))))
        (when newtags
          (let* ((assoc-tag   (assoc tag newtags))
                 (member-tag  (and (not assoc-tag)  (member tag newtags))))
            (cond (assoc-tag  (setcar assoc-tag newname))
                  (member-tag (setcar member-tag newname)))
            (when (or assoc-tag  member-tag)
              (setq tag-exists-p  t)
              (bmkx-prop-set bmk 'tags newtags))))))
    (unless tag-exists-p (error "No such tag: `%s'" tag)))
  (bmkx-tags-list)                      ; Update the tags cache now, after iterating.
  (bmkx-maybe-save-bookmarks)           ; Increments `bookmark-alist-modification-count'.
  ;; (bmkx-refresh/rebuild-menu-list nil (not msg-p)) ; $$$$$$ No need to redisplay
  (when msg-p (message "Renamed")))

;;;###autoload (autoload 'bmkx-copy-tags "bookmark-x")
(defun bmkx-copy-tags (bookmark &optional msg-p) ; Bound to `C-x x t c', `C-x x t M-w'
  "Copy tags from BOOKMARK, so you can paste them to another bookmark.
Note that you can copy from a BOOKMARK that has no tags or has an
empty tags list.  In that case, the copied-tags list is empty, so if
you paste it as a replacement then the recipient bookmark will end up
with no tags.

Non-interactively, non-nil MSG-P means display a message about the
number of tags copied."
  (interactive (list (bmkx-completing-read "Bookmark" (bmkx-default-bookmark-name)) 'MSG))
  (let ((btags  (bmkx-get-tags bookmark)))
    (setq bmkx-copied-tags  (copy-alist btags))
    (when msg-p (message "%d tags now available for pasting" (length btags)))))

;;;###autoload (autoload 'bmkx-paste-add-tags "bookmark-x")
(defun bmkx-paste-add-tags (bookmark &optional no-update-p msg-p) ; Bound to `C-x x t p', `C-x x t C-y'
  "Add tags to BOOKMARK that were previously copied from another bookmark.
Return the number of tags added.
The tags are copied from `bmkx-copied-tags'.
Non-interactively:
 - Non-nil NO-UPDATE-P means do not update `bmkx-tags-alist', do not
   update the modification count and maybe save bookmarks, and do not
   refresh/rebuild the bookmark-list display
 - Non-nil MSG-P means display a message about the addition."
  (interactive (list (bmkx-completing-read "Bookmark" (bmkx-default-bookmark-name)) nil 'MSG))
  (unless (listp bmkx-copied-tags) (error "`bmkx-paste-add-tags': `bmkx-copied-tags' is not a list"))
  (bmkx-add-tags bookmark bmkx-copied-tags no-update-p msg-p))

;;;###autoload (autoload 'bmkx-paste-replace-tags "bookmark-x")
(defun bmkx-paste-replace-tags (bookmark &optional no-update-p msg-p) ; Bound to `C-x x t q'
  "Replace tags for BOOKMARK with those copied from another bookmark.
Return the number of tags for BOOKMARK.
The tags are copied from `bmkx-copied-tags'.
Any previously existing tags for BOOKMARK are *lost*.

NOTE: It is by design that you can *remove all* tags from a bookmark
by copying an empty set of tags and then pasting to that bookmark
using this command.  So be careful using it.  If you want to be sure
that you do not replace tags with an empty list of tags, you can check
the value of variable `bmkx-copied-tags' before pasting.

Non-interactively:
 - Non-nil NO-UPDATE-P means do not update `bmkx-tags-alist', do not
   update the modification count and maybe save bookmarks, and do not
   refresh/rebuild the bookmark-list display
 - Non-nil MSG-P means display a message about the addition."
  (interactive (list (bmkx-completing-read "Bookmark" (bmkx-default-bookmark-name)) nil 'MSG))
  (unless (listp bmkx-copied-tags)
    (error "`bmkx-paste-replace-tags': `bmkx-copied-tags' is not a list"))
  (let ((has-tags-p  (bmkx-get-tags bookmark)))
    (when (and msg-p  has-tags-p
               (not (y-or-n-p "Existing tags will be LOST - really replace them? ")))
      (error "OK - paste-replace tags canceled"))
    (when has-tags-p (bmkx-remove-all-tags bookmark no-update-p msg-p) (sleep-for 0.5)))
  (bmkx-add-tags bookmark bmkx-copied-tags no-update-p msg-p))


;;(@* "Bookmark Predicates")
;;  *** Bookmark Predicates ***

(defun bmkx-annotated-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK has an annotation.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (setq bookmark  (bmkx-get-bookmark bookmark))
  (let ((annotation  (bookmark-get-annotation bookmark)))
    (and annotation  (not (string-equal annotation "")))))

(defun bmkx-autofile-bookmark-p (bookmark &optional prefix)
  "Return non-nil if BOOKMARK is an autofile bookmark.
That means both:
 * It is `bmkx-file-bookmark-p'.
 * Its bookmark name is the same as the nondirectory part of its file
   name (or of its `directory-file-name', if a directory).

BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'.

Non-interactively, non-nil optional arg PREFIX means that the bookmark
name is actually expected to be the file name prefixed by PREFIX (a
string)."
  (setq bookmark  (bmkx-get-bookmark bookmark))
  (and (bmkx-file-bookmark-p bookmark)
       (let* ((file   (bookmark-get-filename bookmark))
              (fname  (file-name-nondirectory (if (file-directory-p file)
                                                  (directory-file-name file)
                                                file))))
         (string= (if prefix (concat prefix fname) fname) (bmkx-bookmark-name-from-record bookmark)))))

(defun bmkx-bookmark-file-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is a bookmark-file bookmark.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (eq (bookmark-get-handler bookmark) 'bmkx-jump-bookmark-file))

(defun bmkx-bookmark-list-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is a bookmark-list bookmark.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (eq (bookmark-get-handler bookmark) 'bmkx-jump-bookmark-list))

(defun bmkx-desktop-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is a desktop bookmark.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (eq (bookmark-get-handler bookmark) 'bmkx-jump-desktop))

;; Note: To avoid remote access, if bookmark does not have the Dired handler, then we insist
;; that it be for a local directory.  IOW, we do not include remote directories that were not
;; bookmarked by Bookmark-X (and so do not have the Dired handler).
(defun bmkx-dired-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is a Dired bookmark.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (or (eq (bookmark-get-handler bookmark) 'bmkx-jump-dired)
      (bmkx-local-directory-bookmark-p bookmark)))

(defun bmkx-dired-this-dir-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is a Dired bookmark for the `default-directory'.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (and (bmkx-dired-bookmark-p bookmark)
       (let ((dir  (file-name-directory (bookmark-get-filename bookmark))))
         (bmkx-same-file-p dir default-directory))))

(defun bmkx-dired-wildcards-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK bookmarks a Dired buffer with wildcards.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (setq bookmark  (bmkx-get-bookmark bookmark))
  (and (bmkx-dired-bookmark-p bookmark)
       (let ((file  (bookmark-get-filename bookmark)))
         (and (stringp file)  (string-match-p (regexp-quote "*") file)))))

(progn ; Emacs 25+

  (defun bmkx-eww-bookmark-p (bookmark)
    "Return non-nil if BOOKMARK is an EWW bookmark.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
    (eq (bookmark-get-handler bookmark) 'bmkx-jump-eww))

  )

(defun bmkx-file-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK bookmarks a file or directory.
This excludes bookmarks of a more specific kind (e.g. Info, Gnus).
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (let* ((filename   (bookmark-get-filename bookmark))
         (nonfile-p  (equal filename bmkx-non-file-filename))
         (handler    (bookmark-get-handler bookmark)))
    (and filename  (not nonfile-p)
         (or (not handler)
             (memq handler bmkx-file-bookmark-handlers)
             (equal handler (bmkx-default-handler-for-file filename)))
         (not (bookmark-prop-get bookmark 'info-node))))) ; Emacs 20-21 Info: no handler.

(defun bmkx-file-this-dir-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK bookmarks file/subdir in `default-directory'.
This excludes bookmarks of a more specific kind (e.g. Info, Gnus).
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (setq bookmark  (bmkx-get-bookmark bookmark 'NOERROR))
  (and bookmark
       (bmkx-file-bookmark-p bookmark)
       (bmkx-same-file-p (file-name-directory (bookmark-get-filename bookmark)) default-directory)))

(defun bmkx-flagged-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is flagged for deletion in `*Bmkx List*'.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (setq bookmark  (bmkx-get-bookmark bookmark))
  (memq bookmark bmkx-flagged-bookmarks))

(defun bmkx-function-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is a function bookmark.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (eq (bookmark-get-handler bookmark) 'bmkx-jump-function))

(defun bmkx-gnus-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is a Gnus bookmark.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (memq (bookmark-get-handler bookmark)
        '(gnus-summary-bmkx-jump bmkx-jump-gnus bmkext-jump-gnus)))

(defun bmkx-image-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is an image-file bookmark.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (or (eq (bookmark-get-handler bookmark) 'image-bmkx-jump)
      (and (bmkx-file-bookmark-p bookmark)
           (not (bmkx-dired-bookmark-p bookmark))
           (string-match-p (image-file-name-regexp) (bookmark-get-filename bookmark)))))

(defun bmkx-info-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is an Info bookmark.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (or (eq (bookmark-get-handler bookmark) 'Info-bmkx-jump)
      (and (not (bookmark-get-handler bookmark))
           (or (string= "*info*" (bmkx-get-buffer-name bookmark))
               (bookmark-prop-get bookmark 'info-node))))) ; Emacs 20-21 - no `buffer-name' entry.

(defun bmkx-kmacro-list-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is a kmacro-list bookmark.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (eq (bookmark-get-handler bookmark) 'bmkx-jump-kmacro-list))

(defun bmkx-local-directory-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK bookmarks a local directory.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (let ((file  (bookmark-get-filename bookmark)))
    (and (bmkx-local-file-bookmark-p bookmark)  (file-directory-p file))))

(defun bmkx-local-file-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK bookmarks a local file or directory.
This excludes bookmarks of a more specific kind (e.g. Info, Gnus).
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (and (bmkx-file-bookmark-p bookmark)  (not (bmkx-remote-file-bookmark-p bookmark))))

(defun bmkx-local-non-dir-file-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK bookmarks a local nondirectory file.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (let ((file  (bookmark-get-filename bookmark)))
    (and (bmkx-local-file-bookmark-p bookmark)  (not (file-directory-p file)))))

(defun bmkx-buffer-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK bookmarks a non-file buffer.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (and (bmkx-get-buffer-name bookmark)
       (let ((filep  (bookmark-get-filename bookmark)))
         (or (not filep)  (equal filep bmkx-non-file-filename)))))

(defun bmkx-man-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is a `man' page bookmark.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (memq (bookmark-get-handler bookmark) '(bmkx-jump-man bmkx-jump-woman
                                          bmkext-jump-man bmkext-jump-woman)))

(defun bmkx-marked-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is a marked bookmark in `*Bmkx List*'.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (unless (stringp bookmark) (setq bookmark  (bmkx-bookmark-name-from-record bookmark)))
  (bmkx-bookmark-name-member bookmark bmkx-bmenu-marked-bookmarks))

(defun bmkx-modified-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is a modified bookmark.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (setq bookmark  (bmkx-get-bookmark bookmark))
  (memq bookmark bmkx-modified-bookmarks))

(defun bmkx-navlist-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is in the current navigation list.
BOOKMARK is a bookmark name or a bookmark record."
  (setq bookmark  (bmkx-get-bookmark bookmark))
  (memq bookmark bmkx-nav-alist))

(defun bmkx-non-dir-file-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK bookmarks a nondirectory file.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (let ((file  (bookmark-get-filename bookmark)))
    (and (bmkx-file-bookmark-p bookmark)  (not (file-directory-p file)))))

(defun bmkx-non-file-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is a non-file bookmark (e.g *scratch*).
This excludes bookmarks of a more specific kind (e.g. Info, Gnus).
It includes bookmarks to existing buffers, as well as bookmarks
defined for buffers that do not currently exist.

BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (let* ((filename   (bookmark-get-filename bookmark))
         (nonfile-p  (equal filename bmkx-non-file-filename)))
    (and (bmkx-get-buffer-name bookmark)
         (or (not filename)  nonfile-p
             ;; Ensure not remote before calling `file-exists-p'.  (Do not prompt for password.)
             (and (not (bmkx-file-remote-p filename))  (not (file-exists-p filename))))
         (not (bookmark-get-handler bookmark)))))

(defun bmkx-non-invokable-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is a non-invokable bookmark.
That is, jumping to it has no effect, because its handler is `ignore'.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'.

A non-invokable bookmark is shown in the bookmark-list display with
face `bmkx-no-jump', because you cannot jump to it."
  (eq (bookmark-get-handler bookmark) 'ignore))

(defun bmkx-orphaned-file-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is an orphaned file or directory bookmark.
This means that the file recorded for BOOKMARK does not exist or is
not readable.  But a Dired bookmark with wildcards in the file name is
assumed to be readable.

BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (setq bookmark  (bmkx-get-bookmark bookmark))
  (and (bmkx-file-bookmark-p bookmark)
       (if (bmkx-dired-bookmark-p bookmark)
           (and (not (bmkx-dired-wildcards-bookmark-p bookmark))
                (not (file-readable-p (bookmark-get-filename bookmark))))
         (not (file-readable-p (bookmark-get-filename bookmark))))))

(defun bmkx-orphaned-local-file-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is an orphaned local-file bookmark.
This means that the file name recorded for BOOKMARK is not remote, and
the file does not exist or is not readable.  But a Dired bookmark with
wildcards in the file name is assumed to be readable.

BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (setq bookmark  (bmkx-get-bookmark bookmark))
  (and (bmkx-local-file-bookmark-p bookmark)
       (if (bmkx-dired-bookmark-p bookmark)
           (and (not (bmkx-dired-wildcards-bookmark-p bookmark))
                (not (file-readable-p (bookmark-get-filename bookmark))))
         (not (file-readable-p (bookmark-get-filename bookmark))))))

(defun bmkx-orphaned-remote-file-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is an orphaned remote-file bookmark.
This means that the file name recorded for BOOKMARK is remote, and the
file does not exist or is not readable.  But a Dired bookmark with
wildcards in the file name is assumed to be readable.

BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (setq bookmark  (bmkx-get-bookmark bookmark))
  (and (bmkx-remote-file-bookmark-p bookmark)
       (if (bmkx-dired-bookmark-p bookmark)
           (and (not (bmkx-dired-wildcards-bookmark-p bookmark))
                (not (file-readable-p (bookmark-get-filename bookmark))))
         (not (file-readable-p (bookmark-get-filename bookmark))))))

(defun bmkx-region-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK has region information.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (and (bmkx-get-end-position bookmark)
       (bookmark-get-position bookmark)
       (/= (bookmark-get-position bookmark) (bmkx-get-end-position bookmark))))

(defun bmkx-remote-file-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK bookmarks a remote file or directory.
This includes remote Dired bookmarks, but otherwise excludes bookmarks
with handlers (e.g. Info, Gnus).

BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (let* ((handler   (bookmark-get-handler bookmark))
         (file      (bookmark-get-filename bookmark))
         (rem-file  (and file  (bmkx-file-remote-p file))))
    (and rem-file  (or (not handler)  (eq handler 'bmkx-jump-dired)))))

(defun bmkx-remote-non-dir-file-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK bookmarks a remote nondirectory file.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (let ((file  (bookmark-get-filename bookmark)))
    (and (bmkx-remote-file-bookmark-p bookmark)  (not (file-directory-p file)))))

(defun bmkx-snippet-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is a snippet bookmark.
This means that it records a snippet of text and that jumping to it
copies that text to the `kill-ring'.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (setq bookmark  (bmkx-get-bookmark bookmark))
  (eq (bookmark-get-handler bookmark) 'bmkx-jump-snippet))

(defun bmkx-temporary-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is temporary.
This means that it has a non-nil `bmkx-temp' entry.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (setq bookmark  (bmkx-get-bookmark bookmark 'NOERROR))
  (and bookmark  (bookmark-prop-get bookmark 'bmkx-temp)))

(defun bmkx-this-buffer-p (bookmark)
  "Return non-nil if BOOKMARK's buffer is the current buffer.
But return nil if BOOKMARK has an associated file, but it is not the
 buffer's file.
And return nil for bookmarks, such as desktops, that are not really
 associated with a buffer, even if they have a `buffer-name' entry.

BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (and (let ((this-file  (condition-case nil (bookmark-buffer-file-name) (error nil)))
             (bmk-file   (and (bmkx-file-bookmark-p bookmark)  (bookmark-get-filename bookmark))))
         ;; Two possibilities:
         ;; * Neither buffer nor bookmark has a file, and the buffer names are the same.
         ;; * Both have files, and they are the same file.
         (or (and (not this-file)  (not bmk-file)  (equal (bmkx-get-buffer-name bookmark) (buffer-name)))
             (and this-file  bmk-file  (bmkx-same-file-p this-file bmk-file))))
       ;; If the buffer to check is from EWW, the buffer URL must match the bookmark URL.
       (or (not (eq major-mode 'eww-mode))
           (and (fboundp 'bmkx-eww-url)  (equal (bmkx-location bookmark) (bmkx-eww-url)))) ; Emacs 25+
       (not (bmkx-desktop-bookmark-p        bookmark))
       (not (bmkx-bookmark-file-bookmark-p  bookmark))
       (not (bmkx-sequence-bookmark-p       bookmark))
       (not (bmkx-function-bookmark-p       bookmark))
       (not (bmkx-variable-list-bookmark-p  bookmark))))

(defun bmkx-this-file-p (bookmark)
  "Return non-nil if BOOKMARK's file is the visited file.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (let ((bmk-file   (and (bmkx-file-bookmark-p bookmark)  (bookmark-get-filename bookmark)))
        (this-file  (or (and (buffer-file-name)  (bookmark-buffer-file-name))
                        (and (eq major-mode 'dired-mode)  (if (consp dired-directory)
                                                              (car dired-directory)
                                                            dired-directory)))))
    (and bmk-file  this-file  (bmkx-same-file-p this-file bmk-file))))

(defun bmkx-last-specific-buffer-p (bookmark)
  "Return t if BOOKMARK's `buffer-name' is `bmkx-last-specific-buffer'.
But return nil for bookmarks, such as desktops, that are not really
associated with a buffer, even if they have a `buffer-name' entry.
It does not matter whether the buffer exists.

BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (let ((buf  (bmkx-get-buffer-name bookmark)))
    (and buf  (string= buf bmkx-last-specific-buffer)
         (not (bmkx-desktop-bookmark-p        bookmark))
         (not (bmkx-bookmark-file-bookmark-p  bookmark))
         (not (bmkx-sequence-bookmark-p       bookmark))
         (not (bmkx-function-bookmark-p       bookmark))
         (not (bmkx-variable-list-bookmark-p  bookmark)))))

(defun bmkx-last-specific-file-p (bookmark)
  "Return t if BOOKMARK's `filename' is `bmkx-last-specific-file'.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (let ((file  (bookmark-get-filename bookmark)))
    (and file  (bmkx-same-file-p file bmkx-last-specific-file))))

(defun bmkx-sequence-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is a sequence bookmark.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (eq (bookmark-get-handler bookmark) 'bmkx-jump-sequence))

(defun bmkx-some-marked-p (alist)
  "Return non-nil if ALIST is nonempty and includes a marked bookmark."
  (catch 'break (dolist (i  alist)  (and (bmkx-marked-bookmark-p i)  (throw 'break t)))))

(defun bmkx-some-unmarked-p (alist)
  "Return non-nil if ALIST is nonempty and includes an unmarked bookmark."
  (catch 'break (dolist (i  alist)  (and (not (bmkx-marked-bookmark-p i))  (throw 'break t)))))

(defun bmkx-url-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is a URL bookmark.
This means that it satifies `bmkx-eww-bookmark-p' (Emacs 25+),
`bmkx-w3m-bookmark-p', or `bmkx-url-browse-bookmark-p'.

BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (or (and (fboundp 'bmkx-eww-bookmark-p)  (bmkx-eww-bookmark-p bookmark))
      (bmkx-w3m-bookmark-p bookmark)
      (bmkx-url-browse-bookmark-p bookmark)))

(defun bmkx-url-browse-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is a `browse-url' bookmark.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (eq (bookmark-get-handler bookmark) 'bmkx-jump-url-browse))

(defun bmkx-variable-list-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is a variable-list bookmark.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (eq (bookmark-get-handler bookmark) 'bmkx-jump-variable-list))

(defun bmkx-w3m-bookmark-p (bookmark)
  "Return non-nil if BOOKMARK is a W3M bookmark.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (memq (bookmark-get-handler bookmark) '(bmkx-jump-w3m bmkext-jump-w3m)))





;;(@* "General Utility Functions")
;;  *** General Utility Functions ***

(defun bmkx-remove-dups (sequence &optional test)
  "Copy of SEQUENCE with duplicate elements removed.
Optional arg TEST is the test function.  If nil, test with `equal'.
See `make-hash-table' for possible values of TEST."
  (setq test  (or test  #'equal))
  (let ((htable  (make-hash-table :test test)))
    (cl-loop for elt in sequence
             unless (gethash elt htable)
             do     (puthash elt elt htable)
             finally return (cl-loop for i being the hash-values in htable collect i))))

(defun bmkx-unpropertized-string (string)
  "Return a copy of STRING, but with properties removed.
Does not change the original STRING."
  (let ((strg  (copy-sequence string)))
    (set-text-properties 0 (length strg) () strg)
    strg))

;; For a name propertized with `bmkx-full-record', this is similar to `bmkx-assoc-delete-all'.
(defun bmkx-delete-bookmark-name-from-list (delname bnames)
  "Delete bookmark name DELNAME from list BNAMES.
Names are unique within `bookmark-alist', so this is just `delete'.
Returns the modified list BNAMES."
  (delete delname bnames))

(defun bmkx-bookmark-name-member (name names)
  "Return the tail of NAMES whose car is `string=' to NAME, or nil.
Bookmark names are unique, so this is just `member'."
  (member name names))

(defun bmkx-names-same-bookmark-p (name1 name2)
  "Return non-nil if the two strings name the same bookmark.
Bookmark names are unique, so this is just `string='."
  (string= name1 name2))

(defun bmkx-read-buffers ()
"Read names of buffers associated with bookmarks.
Invoke `bmkx-completing-read-buffer-name' repeatedly till input is empty."
  (let ((buffs  ())
        buff)
    (while (and (setq buff  (bmkx-completing-read-buffer-name 'ALLOW-EMPTY))  (not (string= "" buff)))
      (unless (member buff buffs) (setq buffs  (cons buff buffs))))
    buffs))

(defun bmkx-read-files ()
  "Read names of files associated with bookmarks.
Invoke `bmkx-completing-read-file-name' repeatedly till input is empty."
  (let ((use-file-dialog  nil)
        (files            ())
        file)
    (while (and (setq file  (bmkx-completing-read-file-name 'ALLOW-EMPTY))  (not (string= "" file)))
      (unless (member file files) (setq files  (cons file files))))
    files))

(defun bmkx-remove-if (pred xs)
  "A copy of list XS with no elements that satisfy predicate PRED."
  (let ((result  ()))
    (dolist (x  xs)  (unless (funcall pred x) (push x result)))
    (nreverse result)))

(defun bmkx-remove-if-not (pred xs)
  "A copy of list XS with only elements that satisfy predicate PRED."
  (let ((result  ()))
    (dolist (x  xs)  (when (funcall pred x) (push x result)))
    (nreverse result)))

;; Similar to `every' in `cl-extra.el', without non-list sequences and multiple sequences.
(defun bmkx-every (predicate list)
  "Return t if PREDICATE is true for all elements of LIST; else nil."
  (while (and list  (funcall predicate (car list)))  (setq list  (cdr list)))
  (null list))

;; NOT the same as `some' in `cl-extra.el', even without non-list sequences and multiple sequences:
;;
;; If PREDICATE is satisfied by a list element ELEMENT, so that it returns a non-nil value VALUE for ELEMENT,
;; then this returns the cons (ELEMENT . VALUE).  It does not return just VALUE.
(defun bmkx-some (predicate list)
  "Return non-nil if PREDICATE applied to some element of LIST is true.
The value returned is a cons, (ELEMENT . VALUE), where ELEMENT is the
first list element that satisfies PREDICATE and VALUE is the value of
PREDICATE applied to ELEMENT."
  (let (elt val)
    (catch 'bmkx-some
      (while list
        (when (setq val  (funcall predicate (setq elt  (pop list))))
          (throw 'bmkx-some (cons elt val))))
      nil)))

;; From `cl-seq.el', function `union', without keyword treatment.
;; (Same as `icicle-set-union' in `icicles-fn.el'.)
(defun bmkx-set-union (list1 list2)
  "Combine LIST1 and LIST2 using a set-union operation.
The result list contains all items that appear in either LIST1 or
LIST2.  Comparison is done using `equal'.  This is a non-destructive
function; it copies the data if necessary."
  (cond ((null list1)         list2)
        ((null list2)         list1)
        ((equal list1 list2)  list1)
        (t
         (unless (>= (length list1) (length list2))
           (setq list1  (prog1 list2 (setq list2  list1)))) ; Swap them.
         (while list2
           (unless (member (car list2) list1)  (setq list1  (cons (car list2) list1)))
           (setq list2  (cdr list2)))
         list1)))

(defun bmkx-upcase (string)
  "`upcase', but in case of error, return original STRING.
This works around an Emacs 20 problem that occurs if STRING contains
binary data (weird chars)."
  (condition-case nil (upcase string) (error string)))

;; Thx to Michael Heerdegen and Michael Albinus for help with this one.
;; See also Emacs bug #10489.
;;
(defun bmkx-same-file-p (file1 file2)
  "Return non-nil if FILE1 and FILE2 name the same file.
If either name is not absolute, then it is expanded relative to
`default-directory' for the test."
  (let ((remote1  (bmkx-file-remote-p file1))
        (remote2  (bmkx-file-remote-p file2)))
    (and (equal remote1 remote2)
         (file-equal-p file1 file2))))

;;; $$$$$$
;;; (defun bmkx-same-file-p (file1 file2)
;;;   "Return non-nil if FILE1 and FILE2 name the same file.
;;; If either name is not absolute, then it is expanded relative to
;;; `default-directory' for the test."
;;;   (and (equal (bmkx-file-remote-p file1) (bmkx-file-remote-p file2))
;;;        (string= (file-truename (expand-file-name file1))
;;;                 (file-truename (expand-file-name file2)))))

(defalias 'bmkx-file-remote-p #'file-remote-p)
(defalias 'bmkx-float-time    #'float-time)

(defun bmkx-string-less-case-fold-p (s1 s2)
  "Like `string-lessp', but respect `case-fold-search'."
  (when case-fold-search (setq s1  (bmkx-upcase s1)
                               s2  (bmkx-upcase s2)))
  (string-lessp s1 s2))

(defun bmkx-repeat-command (command)
  "Repeat COMMAND."
  (require 'repeat)                   ; Define its vars before we let-bind them.
  (let ((repeat-previous-repeated-command  command)
        (repeat-message-function           #'ignore)
        (last-repeatable-command           'repeat))
    (repeat nil)))


;;; If you need this for some reason, uncomment it.
;;; (defun bmkx-fix-bookmark-alist-and-save ()
;;;   "Update format of `bookmark-default-file' created in summer of 2009.
;;; You DO NOT NEED THIS, unless you happen to have used `bookmark-x.el' in
;;; the summer of 2009 to create non-file bookmarks.  If you did that,
;;; then some of those bookmarks might cause built-in Emacs (emacs -Q) to
;;; raise an error.  You can use this command to fix that problem: it
;;; modifies your existing `bookmark-default-file' (`~/.emacs.bmk'), after
;;; backing up that file (suffixing the name with \"_saveNUMBER\")."
;;;   (interactive)
;;;   (require 'cl)                         ; For `gensym'
;;;   (if (not (yes-or-no-p
;;;              "This will modify your bookmark file, after backing it up.  OK? "))
;;;       (message "OK, nothing done")
;;;     (bmkx-maybe-load-default-file)
;;;     (let ((bkup-file  (concat bookmark-default-file "_" (symbol-name (gensym "save")))))
;;;       (when (condition-case err
;;;                 (progn
;;;                   (with-current-buffer (let ((enable-local-variables  ()))
;;;                                          (find-file-noselect bookmark-default-file))
;;;                     (write-file bkup-file))
;;;                   (dolist (bmk  bookmark-alist)
;;;                     (let ((fn-tail  (member '(filename) bmk))
;;;                           (hdlr     (bookmark-get-handler (car bmk))))
;;;                       (cond (fn-tail
;;;                              (setcar fn-tail (cons 'filename bmkx-non-file-filename)))
;;;                             ((and (eq hdlr 'bmkx-jump-gnus)
;;;                                   (not (assoc 'filename bmk)))
;;;                              (setcdr bmk (cons (cons 'filename bmkx-non-file-filename)
;;;                                                (cdr bmk)))))))
;;;                   t)                    ; Be sure `dolist' exit with t to allow saving.
;;;               (error (error "No changes made. %s" (error-message-string err))))
;;;         (bmkx-save)
;;;         (message "Bookmarks file fixed.  Old version is `%s'" bkup-file)))))


;;(@* "Bookmark Entry Access Functions")
;;  *** Bookmark Entry Access Functions ***

(defun bmkx-get-buffer-name (bookmark)
  "Return the `buffer-name' entry for BOOKMARK.
BOOKMARK is a bookmark name or a bookmark record."
  (bookmark-prop-get bookmark 'buffer-name))

(defun bmkx-get-end-position (bookmark)
  "Return the `end-position' entry for BOOKMARK.
BOOKMARK is a bookmark name or a bookmark record."
  (bookmark-prop-get bookmark 'end-position))

(defun bmkx-get-visits-count (bookmark)
  "Return the `visits' count for BOOKMARK.
BOOKMARK is a bookmark name or a bookmark record."
  (bookmark-prop-get bookmark 'visits))

(defun bmkx-get-visit-time (bookmark)
  "Return the `last-visited' value for BOOKMARK.
BOOKMARK is a bookmark name or a bookmark record."
  ;; Support also old name, `time', for property `last-visited'.
  (let ((vt  (or (bookmark-prop-get bookmark 'last-visited)  (bookmark-prop-get bookmark 'time))))
    ;; Should just be a prop-get, but when first implemented, we used a float
    ;; instead of a time cons, so we need to convert any such obsolete recorded times.
    (when (numberp vt)                  ; Convert mid-2009 time values (floats) to cons form.
      (setq vt  (if (boundp 'seconds-to-time)
                    (seconds-to-time vt)
                  (list (floor vt 65536) ; Inlined `seconds-to-time', for Emacs 20-21.
                        (floor (mod vt 65536))
                        (floor (* (- vt (ffloor vt)) 1000000))))))
    vt))


;;(@* "Sorting - General Functions")
;;  *** Sorting - General Functions ***

(defun bmkx-sort-omit (alist &optional omit)
  "Sort a copy of ALIST, omitting any elements whose keys are in OMIT.
Return the copy.
Do not sort if `bmkx-sort-comparer' is nil.
This is a non-destructive operation: ALIST is not modified.

Sorting is done using using `bmkx-sort-comparer'.
If `bmkx-reverse-sort-p' is non-nil, then reverse the sort order.
Keys are compared for sorting using `equal'.

If optional arg OMIT is non-nil, then it is a list of keys.  Omit from
the return value any elements with keys in the list."
  (let ((new-alist  (bmkx-remove-omitted alist omit))
                (sort-fn    (and bmkx-sort-comparer  (if (and (not (functionp bmkx-sort-comparer))
                                                              (consp bmkx-sort-comparer))
                                                         'bmkx-multi-sort
                                                       bmkx-sort-comparer))))
    (when sort-fn
      (setq new-alist  (sort new-alist (if bmkx-reverse-sort-p
                                           (lambda (a b) (not (funcall sort-fn a b)))
                                         sort-fn))))
    new-alist))

(defun bmkx-remove-omitted (alist &optional omit)
  "Copy of bookmark ALIST without bookmarks whose names are in list OMIT.
Name comparison is done using `bmkx-bookmark-name-member'.
If optional arg OMIT is non-nil, then omit from the return value any
elements with keys in list OMIT."
  (let ((new  ()))
    (dolist (ii  alist)  (unless (bmkx-bookmark-name-member (car ii) omit)  (push ii new)))
    (nreverse new)))

;;; $$$$$$ No longer used.
;;; (defun bmkx-sort-and-remove-dups (alist &optional omit)
;;;   "Remove duplicates from a copy of ALIST, then sort it and return it.
;;; Do not sort if `bmkx-sort-comparer' is nil.
;;; Always remove duplicates.  Keep only the first element with a given
;;; key.  This is a non-destructive operation: ALIST is not modified.

;;; Sorting is done using using `bmkx-sort-comparer'.
;;; If `bmkx-reverse-sort-p' is non-nil, then reverse the sort order.
;;; Keys are compared for sorting using `equal'.
;;; If optional arg OMIT is non-nil, then omit from the return value any
;;; elements with keys in list OMIT."
;;;   (let ((new-alist  (bmkx-remove-assoc-dups alist omit))
;;;                (sort-fn  (and bmkx-sort-comparer  (if (and (not (functionp bmkx-sort-comparer))
;;;                                                     (consp bmkx-sort-comparer))
;;;                                                            'bmkx-multi-sort
;;;                                                    bmkx-sort-comparer))))
;;;     (when sort-fn
;;;       (setq new-alist  (sort new-alist (if bmkx-reverse-sort-p
;;;                                            (lambda (a b) (not (funcall sort-fn a b)))
;;;                                          sort-fn))))
;;;     new-alist))

;;; KEEP this simpler version also.  This uses `run-hook-with-args-until-success', but it
;;; does not respect `bmkx-reverse-multi-sort-p'.
;;; (defun bmkx-multi-sort (b1 b2)
;;;   "Try predicates in `bmkx-sort-comparer', in order, until one decides.
;;; See the description of `bmkx-sort-comparer'."
;;;   (let* ((preds   (append (car bmkx-sort-comparer) (cdr bmkx-sort-comparer)))
;;;          (result  (run-hook-with-args-until-success 'preds b1 b2)))
;;;     (if (consp result)
;;;         (car result)
;;;       result)))

;;; $$$$$$ No longer used.
;;; (defun bmkx-remove-assoc-dups (alist &optional omit)
;;;   "Shallow copy of ALIST without elements that have duplicate keys.
;;; Only the first element of those with the same key is kept.
;;; Keys are compared using `equal'.
;;; If optional arg OMIT is non-nil, then omit from the return value any
;;; elements with keys in list OMIT."
;;;   (let ((new  ()))
;;;     (dolist (ii  alist)  (unless (or (assoc (car ii) new)  (member (car ii) omit))  (push ii new)))
;;;     (nreverse new)))


;; This Lisp definition respects `bmkx-reverse-multi-sort-p', and can be extended.
(defun bmkx-multi-sort (b1 b2)
  "Try predicates in `bmkx-sort-comparer', in order, until one decides.
See the description of `bmkx-sort-comparer'.
If `bmkx-reverse-multi-sort-p' is non-nil, then reverse the order for
using multi-sorting predicates."
  (let ((preds       (car bmkx-sort-comparer))
        (final-pred  (cadr bmkx-sort-comparer))
        (result      nil))
    (when bmkx-reverse-multi-sort-p (setq preds  (reverse preds)))
    (catch 'bmkx-multi-sort
      (dolist (pred  preds)
        (setq result  (funcall pred b1 b2))
        (when (consp result)
          (when bmkx-reverse-multi-sort-p (setq result  (list (not (car result)))))
          (throw 'bmkx-multi-sort (car result))))
      (and final-pred  (if bmkx-reverse-multi-sort-p
                           (not (funcall final-pred b1 b2))
                         (funcall final-pred b1 b2))))))


;; The description returned is only approximate.  The effect of `bmkx-reverse-multi-sort-p' is not
;; always intuitive, but it can often be useful.  What's not always intuitive is the placement
;; (the order) of bookmarks that are not sorted by the predicates.
;;
(defun bmkx-sorting-description (order)
  "Return a string describing sort ORDER."
  (concat
   (if (and order  bmkx-sort-comparer)
       order
     (concat (and order  (format "(%s) " order)) "turned OFF"))
   (cond ((not bmkx-sort-comparer) nil)
         ((not (and (consp bmkx-sort-comparer)  (consp (car bmkx-sort-comparer)))) ; Ordinary single pred.
          (if bmkx-reverse-sort-p " (REVERSED)" ""))
         ((not (cadr (car bmkx-sort-comparer))) ; Single predicate.
          (if (or (and bmkx-reverse-sort-p  (not bmkx-reverse-multi-sort-p))
                  (and bmkx-reverse-multi-sort-p  (not bmkx-reverse-sort-p)))
              " (REVERSED)"
            "")
          ;; If we wanted to distinguish the two:
          ;; (if (and bmkx-reverse-sort-p  (not bmkx-reverse-multi-sort-p))
          ;;     "; REVERSED"
          ;;   (if (and bmkx-reverse-multi-sort-p  (not bmkx-reverse-sort-p))
          ;;       "; REVERSED +"
          ;;     ""))
          )
         ;; At least two predicates.
         ((and bmkx-reverse-sort-p  (not bmkx-reverse-multi-sort-p)) " (REVERSED)")
         ((and bmkx-reverse-multi-sort-p  (not bmkx-reverse-sort-p)) " (each pred group reversed)")
         ((and bmkx-reverse-multi-sort-p  bmkx-reverse-sort-p)       " (order of pred groups reversed)")
         (t ""))))

(defun bmkx-msg-about-sort-order (order &optional prefix-msg suffix-msg)
  "Display a message mentioning sort ORDER and direction.
Optional arg PREFIX-MSG is prepended to the constructed message, and
terminated with a period.
Similarly, SUFFIX-MSG is appended, after appending \".  \"."
  (let ((msg  (concat "Sorting " (bmkx-sorting-description order))))
    (when prefix-msg (setq msg  (concat prefix-msg ".  " msg)))
    (when suffix-msg (setq msg  (concat msg ".  " suffix-msg)))
    (message msg)))


;;(@* "Sorting - Commands")
;;  *** Sorting - Commands ***

(defun bmkx-current-sort-order ()
  "Current sort order or sort function, as a string, or nil if none."
  (car (rassoc bmkx-sort-comparer bmkx-sort-orders-alist)))


;;(@* "Sorting - General Predicates")
;;  *** Sorting - General Predicates ***

(defun bmkx-annotated-cp (b1 b2)
  "True if bookmark B1 is annotated and bookmark B2 is not.
Return nil if incomparable as described.

Reverse the roles of B1 and B2 for a false value.
A true value is returned as `(t)', a false value as `(nil)'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
  (setq b1  (bmkx-get-bookmark b1)
        b2  (bmkx-get-bookmark b2))
  (let ((m1  (bmkx-annotated-bookmark-p b1))
        (m2  (bmkx-annotated-bookmark-p b2)))
    (cond ((and m1 m2)  nil)
          (m1           '(t))
          (m2           '(nil))
          (t            nil))))

(defun bmkx-flagged-cp (b1 b2)
  "True if bookmark B1 is flagged for deletion and bookmark B2 is not.
Return nil if incomparable as described.

Reverse the roles of B1 and B2 for a false value.
A true value is returned as `(t)', a false value as `(nil)'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
  (setq b1  (bmkx-get-bookmark b1)
        b2  (bmkx-get-bookmark b2))
  (let ((m1  (bmkx-flagged-bookmark-p b1))
        (m2  (bmkx-flagged-bookmark-p b2)))
    (cond ((and m1 m2)  nil)
          (m1           '(t))
          (m2           '(nil))
          (t            nil))))

(defun bmkx-marked-cp (b1 b2)
  "True if bookmark B1 is marked and bookmark B2 is not.
Return nil if incomparable as described.

Reverse the roles of B1 and B2 for a false value.
A true value is returned as `(t)', a false value as `(nil)'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
  (setq b1  (bmkx-get-bookmark b1)
        b2  (bmkx-get-bookmark b2))
  (let ((m1  (bmkx-marked-bookmark-p b1))
        (m2  (bmkx-marked-bookmark-p b2)))
    (cond ((and m1 m2)  nil)
          (m1           '(t))
          (m2           '(nil))
          (t            nil))))

(defun bmkx-modified-cp (b1 b2)
  "True if bookmark B1 is modified and bookmark B2 is not.
Return nil if incomparable as described.

Reverse the roles of B1 and B2 for a false value.
A true value is returned as `(t)', a false value as `(nil)'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
  (setq b1  (bmkx-get-bookmark b1)
        b2  (bmkx-get-bookmark b2))
  (let ((m1  (bmkx-modified-bookmark-p b1))
        (m2  (bmkx-modified-bookmark-p b2)))
    (cond ((and m1 m2)  nil)
          (m1           '(t))
          (m2           '(nil))
          (t            nil))))

(defun bmkx-tagged-cp (b1 b2)
  "True if bookmark B1 is tagged and bookmark B2 is not.
Return nil if incomparable as described.

Reverse the roles of B1 and B2 for a false value.
A true value is returned as `(t)', a false value as `(nil)'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
  (setq b1  (bmkx-get-bookmark b1)
        b2  (bmkx-get-bookmark b2))
  (let ((m1  (bmkx-tagged-bookmark-p b1))
        (m2  (bmkx-tagged-bookmark-p b2)))
    (cond ((and m1 m2)  nil)
          (m1           '(t))
          (m2           '(nil))
          (t            nil))))

(defun bmkx-visited-more-often-cp (b1 b2)
  "True if bookmark B1 was visited more often than B2.
Return nil if incomparable as described.

True also if B1 was visited but B2 was not.
Reverse the roles of B1 and B2 for a false value.
A true value is returned as `(t)', a false value as `(nil)'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
  (setq b1  (bmkx-get-bookmark b1)
        b2  (bmkx-get-bookmark b2))
  (let ((v1  (bmkx-get-visits-count b1))
        (v2  (bmkx-get-visits-count b2)))
    (cond ((and v1 v2)
           (cond ((> v1 v2)  '(t))
                 ((> v2 v1)  '(nil))
                 (t          nil)))
          (v1                '(t))
          (v2                '(nil))
          (t                 nil))))

(defun bmkx-visited-more-recently-cp (b1 b2)
  "True if bookmark B1 was visited more recently than B2.
Return nil if incomparable as described.

True also if B1 was visited but B2 was not.
Reverse the roles of B1 and B2 for a false value.
A true value is returned as `(t)', a false value as `(nil)'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
  (setq b1  (bmkx-get-bookmark b1)
        b2  (bmkx-get-bookmark b2))
  (let ((v1  (bmkx-get-visit-time b1))
        (v2  (bmkx-get-visit-time b2)))
    (cond ((and v1 v2)
           (cond ((time-less-p v2 v1)  '(t))
                 ((time-less-p v1 v2)  '(nil))
                 (t          nil)))
          (v1                '(t))
          (v2                '(nil))
          (t                 nil))))

(defun bmkx-bookmark-creation-cp (b1 b2)
  "True if bookmark B1 was created more recently than B2.
Return nil if incomparable as described.

True also if B1 has a `created' entry but B2 has none.
Reverse the roles of B1 and B2 for a false value.
A true value is returned as `(t)', a false value as `(nil)'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
  (setq b1  (bmkx-get-bookmark b1)
        b2  (bmkx-get-bookmark b2))
  (let ((t1  (bookmark-prop-get b1 'created))
        (t2  (bookmark-prop-get b2 'created)))
    (cond ((and t1 t2)
           (setq t1  (bmkx-float-time t1)
                 t2  (bmkx-float-time t2))
           (cond ((> t1 t2)  '(t))
                 ((> t2 t1)  '(nil))
                 (t          nil)))
          (t1                '(t))
          (t2                '(nil))
          (t                 nil))))

;; Not used currently.
(defun bmkx-same-creation-time-p (b1 b2)
  "Return non-nil if `B1 and B2 have same `created' entry.
If neither has a `created' entry (built-in bookmarks), then return
non-nil if the full bookmarks are `equal'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
  (let ((time1  (bookmark-prop-get b1 'created))
        (time2  (bookmark-prop-get b2 'created)))
    (if (or time1  time2) (equal time1 time2) (equal b1 b2))))

(defun bmkx-bookmark-last-access-cp (b1 b2)
  "True if bookmark B1 was visited more recently than B2.
Return nil if incomparable as described.

True also if B1 was visited but B2 was not.
Reverse the roles of B1 and B2 for a false value.
A true value is returned as `(t)', a false value as `(nil)'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
  (setq b1  (bmkx-get-bookmark b1)
        b2  (bmkx-get-bookmark b2))
  (let ((t1  (bmkx-get-visit-time b1))
        (t2  (bmkx-get-visit-time b2)))
    (cond ((and t1 t2)
           (setq t1  (bmkx-float-time t1)
                 t2  (bmkx-float-time t2))
           (cond ((> t1 t2)  '(t))
                 ((> t2 t1)  '(nil))
                 (t          nil)))
          (t1                '(t))
          (t2                '(nil))
          (t                 nil))))

(defun bmkx-buffer-last-access-cp (b1 b2)
  "True if bookmark B1's buffer or file was visited more recently than B2's.
Return nil if incomparable as described.

A bookmark to an existing buffer sorts before a file bookmark, even if
the buffer has not been visited during this session.

True also if B1 has a buffer but B2 does not.
Reverse the roles of B1 and B2 for a false value.
A true value is returned as `(t)', a false value as `(nil)'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
  (setq b1  (bmkx-get-bookmark b1)
        b2  (bmkx-get-bookmark b2))
  (let ((buf1  (bmkx-get-buffer-name b1))
        (buf2  (bmkx-get-buffer-name b2)))
    (setq buf1  (and buf1  (get-buffer buf1))
          buf2  (and buf2  (get-buffer buf2)))
    (cond ((and buf1 buf2)              ; Both buffers exist.   See whether they were accessed.
           (when buf1 (setq buf1  (member buf1 (buffer-list))
                            buf1  (length buf1)))
           (when buf2 (setq buf2  (member buf2 (buffer-list))
                            buf2  (length buf2)))
           (cond ((and buf1 buf2)       ; Both were accessed.  Priority to most recent access.
                  (cond ((< buf1 buf2)  '(t))
                        ((< buf2 buf1)  '(nil))
                        (t              nil)))
                 (buf1                  '(t)) ; Only buf1 was accessed.
                 (buf2                  '(nil)) ; Only buf2 was accessed.
                 (t                     nil))) ; Neither was accessed.

          (buf1                         '(t)) ; Only buf1 exists.
          (buf2                         '(nil)) ; Only buf2 exists.
          (t                            nil)))) ; Neither buffer exists

;; EWW.  Not used yet.
(progn ; Emacs 25

  (defun bmkx-eww-cp (b1 b2)
    "True if bookmark B1 sorts as an EWW URL bookmark before B2.
Return nil if neither sorts before the other.

Two EWW URL bookmarks are compared alphabetically, by their URLs.
True also if B1 is a EWW bookmark but B2 is not.
Reverse the roles of B1 and B2 for a false value.
A true value is returned as `(t)', a false value as `(nil)'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
    (setq b1  (bmkx-get-bookmark b1)
          b2  (bmkx-get-bookmark b2))
    (let ((e1  (bmkx-eww-bookmark-p b1))
          (e2  (bmkx-eww-bookmark-p b2)))
      (cond ((and e1 e2)
             (setq e1  (bookmark-get-filename b1)
                   e2  (bookmark-get-filename b2))
             (cond ((string-lessp e1 e2)  '(t))
                   ((string-lessp e2 e1)  '(nil))
                   (t                     nil)))
            (e1                           '(t))
            (e2                           '(nil))
            (t                            nil))))

  )

(defun bmkx-handler-cp (b1 b2)
  "True if bookmark B1's handler name sorts alphabetically before B2's.
Return nil if neither sorts before the other.

Two bookmarks with handlers are compared alphabetically, by their
handler-function names, respecting `case-fold-search'.
True also if B1 has a handler but B2 has not.
Reverse the roles of B1 and B2 for a false value.
A true value is returned as `(t)', a false value as `(nil)'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
  (setq b1  (bmkx-get-bookmark b1)
        b2  (bmkx-get-bookmark b2))
  (let ((h1  (bookmark-get-handler b1))
        (h2  (bookmark-get-handler b2)))
    (cond ((and h1 h2 (symbolp h1) (symbolp h2))
           ;; Pretend woman bookmarks are man bookmarks, to keep them together.
           (when (eq h1 'bmkx-jump-woman) (setq h1  'bmkx-jump-man))
           (when (eq h2 'bmkx-jump-woman) (setq h2  'bmkx-jump-man))
           (setq h1  (symbol-name h1)
                 h2  (symbol-name h2))
           (when case-fold-search (setq h1  (bmkx-upcase h1)
                                        h2  (bmkx-upcase h2)))
           (cond ((string-lessp h1 h2)  '(t))
                 ((string-lessp h2 h1)  '(nil))
                 (t                     nil)))
          (h1                           '(t))
          (h2                           '(nil))
          (t                            nil))))

;; Keep the alias for a while, in case someone has it referenced in a state file.
(defalias 'bmkx-info-cp 'bmkx-info-node-name-cp)
(bmkx-make-obsolete 'bmkx-info-cp 'bmkx-info-node-name-cp "2017-07-03")

(defun bmkx-info-node-name-cp (b1 b2)
  "True if bookmark B1 sorts as an Info bookmark before B2.
Return nil if neither sorts before the other.

Two Info bookmarks are compared first by manual name, then by node
name, then by position.

If `bmkx-info-sort-ignores-directories-flag' is non-nil then manual
names are used.  If it is nil then absolute file names for the manuals
are used.

True also if B1 is an Info bookmark but B2 is not.
Reverse the roles of B1 and B2 for a false value.
A true value is returned as `(t)', a false value as `(nil)'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
  (setq b1  (bmkx-get-bookmark b1)
        b2  (bmkx-get-bookmark b2))
  (let ((i1  (bmkx-info-bookmark-p b1))
        (i2  (bmkx-info-bookmark-p b2))
        (fn  (if bmkx-info-sort-ignores-directories-flag #'file-name-nondirectory #'abbreviate-file-name)))
    (cond ((and i1 i2)
           (setq i1  (funcall fn (bookmark-get-filename b1))
                 i2  (funcall fn (bookmark-get-filename b2)))
           (when case-fold-search (setq i1  (bmkx-upcase i1)
                                        i2  (bmkx-upcase i2)))
           (cond ((string-lessp i1 i2)                  '(t)) ; Compare manuals (file names).
                 ((string-lessp i2 i1)                  '(nil))
                 (t                     ; Compare node names.
                  (setq i1  (bookmark-prop-get b1 'info-node)
                        i2  (bookmark-prop-get b2 'info-node))
                  (cond ((string-lessp i1 i2)           '(t))
                        ((string-lessp i2 i1)           '(nil))
                        (t
                         (setq i1  (bookmark-get-position b1)
                               i2  (bookmark-get-position b2))
                         (cond ((or (not i1)  (not i2)) '(t)) ; Fallback if no `position' entry.
                               ((<= i1 i2)              '(t))
                               ((< i2 i1)               '(nil))))))))
          (i1                                           '(t))
          (i2                                           '(nil))
          (t                                            nil))))

(defun bmkx-info-position-cp (b1 b2)
  "True if bookmark B1 sorts as Info bookmark before B2 in book order.
Return nil if neither sorts before the other.

Two Info bookmarks are compared first by manual name, then by position
in the file.

If `bmkx-info-sort-ignores-directories-flag' is non-nil then manual
names are used.  If it is nil then absolute file names for the manuals
are used.

True also if B1 is an Info bookmark but B2 is not.
Reverse the roles of B1 and B2 for a false value.
A true value is returned as `(t)', a false value as `(nil)'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
  (setq b1  (bmkx-get-bookmark b1)
        b2  (bmkx-get-bookmark b2))
  (let ((i1  (bmkx-info-bookmark-p b1))
        (i2  (bmkx-info-bookmark-p b2))
        (fn  (if bmkx-info-sort-ignores-directories-flag #'file-name-nondirectory #'abbreviate-file-name)))
    (cond ((and i1 i2)
           (setq i1  (funcall fn (bookmark-get-filename b1))
                 i2  (funcall fn (bookmark-get-filename b2)))
           (when case-fold-search (setq i1  (bmkx-upcase i1)
                                        i2  (bmkx-upcase i2)))
           (cond ((string-lessp i1 i2)                  '(t)) ; Compare manuals (file names).
                 ((string-lessp i2 i1)                  '(nil))
                 (t                     ; Compare positions.
                  (setq i1  (bookmark-get-position b1)
                        i2  (bookmark-get-position b2))
                  (cond ((or (not i1)  (not i2)) '(t)) ; Fallback if no `position' entry.
                        ((<= i1 i2)              '(t))
                        ((< i2 i1)               '(nil))))))
          (i1                                           '(t))
          (i2                                           '(nil))
          (t                                            nil))))

(defun bmkx-gnus-cp (b1 b2)
  "True if bookmark B1 sorts as a Gnus bookmark before B2.
Return nil if neither sorts before the other.

Two Gnus bookmarks are compared first by Gnus group name, then by
article number, then by message ID.
True also if B1 is a Gnus bookmark but B2 is not.
Reverse the roles of B1 and B2 for a false value.
A true value is returned as `(t)', a false value as `(nil)'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
  (setq b1  (bmkx-get-bookmark b1)
        b2  (bmkx-get-bookmark b2))
  (let ((g1  (bmkx-gnus-bookmark-p b1))
        (g2  (bmkx-gnus-bookmark-p b2)))
    (cond ((and g1 g2)
           (setq g1  (bookmark-prop-get b1 'group)
                 g2  (bookmark-prop-get b2 'group))
           (cond ((string-lessp g1 g2)                '(t)) ; Compare groups.
                 ((string-lessp g2 g1)                '(nil))
                 (t                     ; Compare article numbers.
                  (setq g1  (bookmark-prop-get b1 'article)
                        g2  (bookmark-prop-get b2 'article))
                  (cond ((< g1 g2)                    '(t))
                        ((< g2 g1)                    '(nil))
                        (t
                         (setq g1  (bookmark-prop-get b1 'message-id)
                               g2  (bookmark-prop-get b2 'message-id))
                         (cond ((string-lessp g1 g2)  '(t)) ; Compare message IDs.
                               ((string-lessp g2 g1)  '(nil))
                               (t                     nil)))))))
          (g1                                         '(t))
          (g2                                         '(nil))
          (t                                          nil))))

(defun bmkx-url-cp (b1 b2)
  "True if bookmark B1 sorts as a URL bookmark before B2.
Return nil if neither sorts before the other.

Two URL bookmarks are compared alphabetically, by their URLs.
True also if B1 is a URL bookmark but B2 is not.
Reverse the roles of B1 and B2 for a false value.
A true value is returned as `(t)', a false value as `(nil)'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
  (setq b1  (bmkx-get-bookmark b1)
        b2  (bmkx-get-bookmark b2))
  (let ((u1  (bmkx-url-bookmark-p b1))
        (u2  (bmkx-url-bookmark-p b2)))
    (cond ((and u1 u2)
           (setq u1  (or (bookmark-prop-get b1 'location)  (bookmark-get-filename b1))
                 u2  (or (bookmark-prop-get b2 'location)  (bookmark-get-filename b2)))
           (cond ((string-lessp u1 u2)  '(t))
                 ((string-lessp u2 u1)  '(nil))
                 (t                     nil)))
          (u1                           '(t))
          (u2                           '(nil))
          (t                            nil))))

;; Not used now.
(defun bmkx-w3m-cp (b1 b2)
  "True if bookmark B1 sorts as a W3M URL bookmark before B2.
Return nil if neither sorts before the other.

Two W3M URL bookmarks are compared alphabetically, by their URLs.
True also if B1 is a W3M bookmark but B2 is not.
Reverse the roles of B1 and B2 for a false value.
A true value is returned as `(t)', a false value as `(nil)'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
  (setq b1  (bmkx-get-bookmark b1)
        b2  (bmkx-get-bookmark b2))
  (let ((w1  (bmkx-w3m-bookmark-p b1))
        (w2  (bmkx-w3m-bookmark-p b2)))
    (cond ((and w1 w2)
           (setq w1  (bookmark-get-filename b1)
                 w2  (bookmark-get-filename b2))
           (cond ((string-lessp w1 w2)  '(t))
                 ((string-lessp w2 w1)  '(nil))
                 (t                     nil)))
          (w1                           '(t))
          (w2                           '(nil))
          (t                            nil))))

(defun bmkx-position-cp (b1 b2)
  "True if the `position' of B1 is not greater than that of B2.
Return nil if B1 and B2 do not bookmark the same buffer or they have
the same `position' value.

Reverse the roles of B1 and B2 for a false value.
A true value is returned as `(t)', a false value as `(nil)'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
  (setq b1  (bmkx-get-bookmark b1)
        b2  (bmkx-get-bookmark b2))
  (let ((buf1  (bmkx-get-buffer-name b1))
        (buf2  (bmkx-get-buffer-name b2)))
    (and buf1 buf2 (equal buf1 buf2)
         (let ((i1  (bookmark-get-position b1))
               (i2  (bookmark-get-position b2)))
           (cond ((or (not i1)  (not i2)) '(t)) ; Fallback if no `position' entry.
                 ((<= i1 i2)              '(t))
                 ((< i2 i1)               '(nil)))))))

(defun bmkx-alpha-cp (b1 b2)
  "True if bookmark B1's name sorts alphabetically before B2's.
Return nil if neither sorts before the other.

The bookmark names are compared, respecting `case-fold-search'.
Reverse the roles of B1 and B2 for a false value.
A true value is returned as `(t)', a false value as `(nil)'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
  (setq b1  (bmkx-get-bookmark b1)
        b2  (bmkx-get-bookmark b2))
  (let ((s1  (car b1))
        (s2  (car b2)))
    (when case-fold-search (setq s1  (bmkx-upcase s1)
                                 s2  (bmkx-upcase s2)))
    (cond ((string-lessp s1 s2)  '(t))
          ((string-lessp s2 s1)  '(nil))
          (t                     nil))))

;; Do not use `bmkx-make-plain-predicate', because it falls back on `bookmark-alpha-p'.
;; Return nil if `bookmark-alpha-cp' cannot decide.
(defun bmkx-alpha-p (b1 b2)
  "True if bookmark B1's name sorts alphabetically before B2's.
The bookmark names are compared, respecting `case-fold-search'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
  (setq b1  (bmkx-get-bookmark b1)
        b2  (bmkx-get-bookmark b2))
  (car (bmkx-alpha-cp b1 b2)))


;;(@* "Sorting - File-Name Predicates")
;;  *** Sorting - File-Name Predicates ***

(defun bmkx-file-alpha-cp (b1 b2)
  "True if bookmark B1's file name sorts alphabetically before B2's.
Return nil if neither sorts before the other.

The file names are shortened using `abbreviate-file-name', then they
are compared respecting `case-fold-search'.

Reverse the roles of B1 and B2 for a false value.
A true value is returned as `(t)', a false value as `(nil)'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
  (setq b1  (bmkx-get-bookmark b1)
        b2  (bmkx-get-bookmark b2))
  (let ((f1  (bmkx-file-bookmark-p b1))
        (f2  (bmkx-file-bookmark-p b2)))
    (cond ((and f1 f2)
           ;; Call `abbreviate-file-name' mainly to get letter case right per platform.
           (setq f1  (abbreviate-file-name (bookmark-get-filename b1))
                 f2  (abbreviate-file-name (bookmark-get-filename b2)))
           (when case-fold-search (setq f1  (bmkx-upcase f1)
                                        f2  (bmkx-upcase f2)))
           (cond ((string-lessp f1 f2)  '(t))
                 ((string-lessp f2 f1)  '(nil))
                 (t                     nil)))
          (f1                           '(t))
          (f2                           '(nil))
          (t                            nil))))

;; We define all file-attribute predicates, in case you want to use them.
;;
;; `bmkx-file-attribute-0-cp'  - type
;; `bmkx-file-attribute-1-cp'  - links
;; `bmkx-file-attribute-2-cp'  - uid
;; `bmkx-file-attribute-3-cp'  - gid
;; `bmkx-file-attribute-4-cp'  - last access time
;; `bmkx-file-attribute-5-cp'  - last update time
;; `bmkx-file-attribute-6-cp'  - last status change
;; `bmkx-file-attribute-7-cp'  - size
;; `bmkx-file-attribute-8-cp'  - modes
;; `bmkx-file-attribute-9-cp'  - gid change
;; `bmkx-file-attribute-10-cp' - inode
;; `bmkx-file-attribute-11-cp' - device
;;
(bmkx-define-file-sort-predicate 0) ; Type: file, symlink, dir
(bmkx-define-file-sort-predicate 1) ; Links
(bmkx-define-file-sort-predicate 2) ; Uid
(bmkx-define-file-sort-predicate 3) ; Gid
(bmkx-define-file-sort-predicate 4) ; Last access time
(bmkx-define-file-sort-predicate 5) ; Last modification time
(bmkx-define-file-sort-predicate 6) ; Last status-change time
(bmkx-define-file-sort-predicate 7) ; Size
(bmkx-define-file-sort-predicate 8) ; Modes
(bmkx-define-file-sort-predicate 9) ; Gid would change if re-created
(bmkx-define-file-sort-predicate 10) ; Inode
(bmkx-define-file-sort-predicate 11) ; Device

(defun bmkx-local-file-accessed-more-recently-cp (b1 b2)
  "True if bookmark B1's local file was accessed more recently than B2's.
Return nil if neither sorts before the other.

A local file sorts before a remote file, which sorts before other
bookmarks.  Two remote files are considered incomparable - their
access times are not examined.

Reverse the roles of B1 and B2 for a false value.
A true value is returned as `(t)', a false value as `(nil)'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
  (setq b1  (bmkx-get-bookmark b1)
        b2  (bmkx-get-bookmark b2))
  (cond ((and (bmkx-local-file-bookmark-p b1)  (bmkx-local-file-bookmark-p b2))
         (bmkx-cp-not (bmkx-file-attribute-4-cp b1 b2)))
        ((bmkx-local-file-bookmark-p b1)         '(t))
        ((bmkx-local-file-bookmark-p b2)         '(nil))
        ((and (bmkx-remote-file-bookmark-p b1)
              (bmkx-remote-file-bookmark-p b2))  nil)
        ((bmkx-remote-file-bookmark-p b1)        '(t))
        ((bmkx-remote-file-bookmark-p b2)        '(nil))
        (t                                       nil)))

(defun bmkx-local-file-updated-more-recently-cp (b1 b2)
  "True if bookmark B1's local file was updated more recently than B2's.
Return nil if neither sorts before the other.

A local file sorts before a remote file, which sorts before other
bookmarks.  Two remote files are considered incomparable - their
update times are not examined.

Reverse the roles of B1 and B2 for a false value.
A true value is returned as `(t)', a false value as `(nil)'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
  (setq b1  (bmkx-get-bookmark b1)
        b2  (bmkx-get-bookmark b2))
  (cond ((and (bmkx-local-file-bookmark-p b1)  (bmkx-local-file-bookmark-p b2))
         (bmkx-cp-not (bmkx-file-attribute-5-cp b1 b2)))
        ((bmkx-local-file-bookmark-p b1)         '(t))
        ((bmkx-local-file-bookmark-p b2)         '(nil))
        ((and (bmkx-remote-file-bookmark-p b1)
              (bmkx-remote-file-bookmark-p b2))  nil)
        ((bmkx-remote-file-bookmark-p b1)        '(t))
        ((bmkx-remote-file-bookmark-p b2)        '(nil))
        (t                                       nil)))

(defun bmkx-local-file-size-cp (b1 b2)
  "True if bookmark B1's local file is larger than B2's.
Return nil if neither sorts before the other.

A local file sorts before a remote file, which sorts before other
bookmarks.  Two remote files are considered incomparable - their
sizes are not examined.

Reverse the roles of B1 and B2 for a false value.
A true value is returned as `(t)', a false value as `(nil)'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
  (setq b1  (bmkx-get-bookmark b1)
        b2  (bmkx-get-bookmark b2))
  (cond ((and (bmkx-local-file-bookmark-p b1)  (bmkx-local-file-bookmark-p b2))
         (bmkx-cp-not (bmkx-file-attribute-7-cp b1 b2)))
        ((bmkx-local-file-bookmark-p b1)         '(t))
        ((bmkx-local-file-bookmark-p b2)         '(nil))
        ((and (bmkx-remote-file-bookmark-p b1)
              (bmkx-remote-file-bookmark-p b2))  nil)
        ((bmkx-remote-file-bookmark-p b1)        '(t))
        ((bmkx-remote-file-bookmark-p b2)        '(nil))
        (t                                       nil)))

(defun bmkx-local-file-type-cp (b1 b2)
  "True if bookmark B1 sorts by local file type before B2.
Return nil if neither sorts before the other.

For two local files, a file sorts before a symlink, which sorts before
a directory.

A local file sorts before a remote file, which sorts before other
bookmarks.  Two remote files are considered incomparable - their file
types are not examined.

Reverse the roles of B1 and B2 for a false value.
A true value is returned as `(t)', a false value as `(nil)'.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
  (setq b1  (bmkx-get-bookmark b1)
        b2  (bmkx-get-bookmark b2))
  (cond ((and (bmkx-local-file-bookmark-p b1)  (bmkx-local-file-bookmark-p b2))
         (bmkx-file-attribute-0-cp b1 b2))
        ((bmkx-local-file-bookmark-p b1)         '(t))
        ((bmkx-local-file-bookmark-p b2)         '(nil))
        ((and (bmkx-remote-file-bookmark-p b1)
              (bmkx-remote-file-bookmark-p b2))  nil)
        ((bmkx-remote-file-bookmark-p b1)        '(t))
        ((bmkx-remote-file-bookmark-p b2)        '(nil))
        (t                                       nil)))

(defun bmkx-cp-not (truth)
  "Return the negation of boolean value TRUTH.
If TRUTH is (t), return (nil), and vice versa.
If TRUTH is nil, return nil."
  (and truth  (if (car truth) '(nil) '(t))))


;;(@* "Indirect Bookmarking Functions")
;;  *** Indirect Bookmarking Functions ***

;;;###autoload (autoload 'bmkx-url-target-set "bookmark-x")
(defun bmkx-url-target-set (url &optional arg name/prefix no-overwrite-p no-refresh-p msg-p)
                                        ; Bound globally to `C-x x c u'.
  "Set a bookmark for a URL.  Return the bookmark.
Interactively you are prompted for the URL.  Completion is available.
Use `M-n' to pick up the url at point as the default.

You are also prompted for the bookmark name.  But with a non-negative
prefix arg, you are prompted only for a bookmark-name prefix.  In that
case, the bookmark name is the prefix followed by the URL.

When entering a bookmark name you can use completion against existing
names.  This completion is lax, so you can easily edit an existing
name.  See `bmkx-set' for particular keys available during this
input.

If you use a numeric prefix arg, such as `C-1', instead of plain
`C-u', then a new bookmark is created if a bookmark of the same name
already exists: an existing bookmark is not overwritten.  You can thus
have multiple bookmarks with the same name, which target different
URLs.

Summary of prefix argument behavior:

* None:        Provide full bookmark name. Overwrite existing bookmark
* Plain `C-u': Provide name prefix only.   Overwrite existing bookmark
* N >= 0:      Provide name prefix only.   Do not overwrite.
* N < 0:       Provide full bookmark name. Do not overwrite.

Non-interactively:
* Numeric ARG >= 0 means NAME/PREFIX is a bookmark-name prefix.
* NAME/PREFIX is the bookmark name or its prefix (the suffix = URL).
* Non-nil NO-OVERWRITE-P means do not overwrite an existing bookmark.
* Non-nil NO-REFRESH-P means do not refresh/rebuild the bookmark-list
  display.
* Non-nil MSG-P means display a status message."
  (interactive
   (let* ((default-url   (or (bmkx-thing-at-point 'url)
                             (thing-at-point-url-at-point)))
          (parg          current-prefix-arg)
          (prefix-only   (and parg  (natnump (prefix-numeric-value parg))))
          (no-overw      (and parg  (atom current-prefix-arg))))
     ;; Plain `read-from-minibuffer' here (not `ffap-read-file-or-url'):
     ;; on Emacs 31 the latter triggers an apparent-cycle-of-symbolic-links
     ;; error when its default is a URL, because the file-name machinery
     ;; calls `file-truename' through ffap's URL handler and loops.
     ;; Filename completion is irrelevant for URL input anyway.
     (list (read-from-minibuffer "URL: " nil nil nil nil default-url)
           prefix-only
           (if prefix-only
               (read-string "Prefix for bookmark name: ")
             (bmkx-completing-read-lax "Bookmark name"))
           no-overw
           nil
           'MSG)))
  (unless name/prefix (setq name/prefix  ""))
  (let ((bookmark-make-record-function  (cond ((and (eq major-mode 'eww-mode)
                                                    (fboundp 'bmkx-make-eww-record)) ; Emacs 25+
                                               'bmkx-make-eww-record)
                                              ((eq major-mode 'w3m-mode) 'bmkx-make-w3m-record)
                                              (t `(lambda () (bmkx-make-url-browse-record ',url)))))
        bmk failure)
    (condition-case err
        (setq bmk  (bmkx-store (if arg (concat name/prefix url) name/prefix)
                                   (cdr (bmkx-make-record))  no-overwrite-p  no-refresh-p  (not msg-p)))
      (error (setq failure  err)))
    (when failure (error "Failed to create bookmark for `%s':\n%s\n" url failure))
    ;; Same prompt-for-tags hook `bmkx-set' runs, missing here originally.
    ;; Keyed on MSG-P (the "I'm user-facing" flag passed through wrappers)
    ;; rather than `called-interactively-p', so wrappers see it too.
    (when (and msg-p  bmkx-prompt-for-tags-flag)
      (bmkx-add-tags (car bmk) (bmkx-read-tags-completing) 'NO-UPDATE-P))
    bmk))                               ; Return the bookmark.

;;;###autoload (autoload 'bmkx-file-target-set "bookmark-x")
(defun bmkx-file-target-set (file &optional arg name/prefix no-overwrite no-refresh-p msg-p)
                                        ; Bound to `C-x x c f'
  "Set a bookmark for FILE.  Return the bookmark.
The bookmarked position is the beginning of the file (0).
Interactively you are prompted for FILE.  Completion is available.
You can use `M-n' to pick up the file name at point, or if none then
the visited file.

FILE can also be a directory name.  In that case set a bookmark for
the directory.

You are also prompted for the bookmark name.  But with a non-negative
prefix arg, you are prompted only for a bookmark-name prefix.  In that
case, the bookmark name is the prefix followed by the nondirectory
part of FILE (or of its `directory-file-name', if a directory name).

When entering a bookmark name you can use completion against existing
names.  This completion is lax, so you can easily edit an existing
name.  See `bmkx-set' for particular keys available during this
input.

If you use a numeric prefix arg, such as `C-1', instead of plain
`C-u', then a new bookmark is created if a bookmark of the same name
already exists: an existing bookmark is not overwritten.  You can thus
have multiple bookmarks with the same name, which target different
URLs.

Summary of prefix argument behavior:

* None:        Provide full bookmark name. Overwrite existing bookmark
* Plain `C-u': Provide name prefix only.   Overwrite existing bookmark
* N >= 0:      Provide name prefix only.   Do not overwrite.
* N < 0:       Provide full bookmark name  Do not overwrite.

Non-interactively:
* Numeric ARG >= 0 means NAME/PREFIX is a bookmark-name prefix.
* NAME/PREFIX is the bookmark name or its prefix.
* Non-nil NO-OVERWRITE-P means do not overwrite an existing bookmark.
* Non-nil NO-REFRESH-P means do not refresh/rebuild the bookmark-list
  display.
* Non-nil MSG-P means show a warning message if file does not exist."
  (interactive
   (let* ((parg         current-prefix-arg)
          (prefix-only  (and parg  (natnump (prefix-numeric-value parg))))
          (no-overw     (and parg  (atom current-prefix-arg))))
     (list (read-file-name "File: " nil
                           (or (if (boundp 'file-name-at-point-functions) ; In `files.el', Emacs 23.2+.
                                   (run-hook-with-args-until-success 'file-name-at-point-functions)
                                 (bmkx-ffap-guesser))
                               (bmkx-thing-at-point 'filename)
                               (buffer-file-name)))
           prefix-only
           (if prefix-only
               (read-string "Prefix for bookmark name: ")
             (bmkx-completing-read-lax "Bookmark name"))
           no-overw
           nil
           'MSG)))
  (unless name/prefix (setq name/prefix  ""))
  (let ((bookmark-make-record-function  (bmkx-make-record-for-target-file file))
        bmk failure)
    (condition-case err
        (setq bmk  (bmkx-store (if arg
                                       (concat name/prefix
                                               (file-name-nondirectory (if (file-directory-p file)
                                                                           (directory-file-name file)
                                                                         file)))
                                     name/prefix)
                                   (cdr (bmkx-make-record))  no-overwrite  no-refresh-p  (not msg-p)))
      (error (setq failure  (error-message-string err))))
    (when failure (error "Failed to create bookmark for `%s':\n%s\n" file failure))
    (unless no-refresh-p (bmkx-refresh/rebuild-menu-list bmk (not msg-p)))
    (when (and msg-p  (not (file-exists-p file)))
      (message "File name is now bookmarked, but no such file yet: `%s'" (expand-file-name file)))
    ;; Same prompt-for-tags hook `bmkx-set' runs, missing here originally.
    (when (and msg-p  bmkx-prompt-for-tags-flag)
      (bmkx-add-tags (car bmk) (bmkx-read-tags-completing) 'NO-UPDATE-P))
    bmk))                               ; Return the bookmark.

(defun bmkx-make-record-for-target-file (file)
  "Return a function that creates a bookmark record for FILE.
The bookmarked position will be the beginning of the file."
  ;; $$$$$$ Maybe need a way to bypass default handler, at least for autofiles.
  ;;        Doesn't seem to make much sense to use a handler such as a shell cmd in this context. (?)
  (set-text-properties 0 (length file) () file)
  (let ((default-handler  (condition-case nil (bmkx-default-handler-for-file file) (error nil)))
        (common           `((filename     . ,file)
                            (position     . 0)
                            (created      . ,(current-time)))))
    (cond (default-handler              ; User default handler
              `(lambda () ',(append common `((file-handler . ,default-handler)))))
          ;; Non-user defaults.
          ((and (require 'image nil t)  (require 'image-mode nil t) ; Image
                (condition-case nil (image-type file) (error nil)))
           ;; Last two lines of function are from `image-bmkx-make-record'.
           ;; But don't use that directly, because it uses
           ;; `bmkx-make-record-default', which gets nil for `filename'.

           ;; NEED TO KEEP THIS CODE SYNC'D WITH `diredp-bookmark'.
           `(lambda ()
             ',(append common `((image-type . ,(image-type file)) (handler . image-bmkx-jump)))))
          ((let ((case-fold-search  t))  (string-match-p "\\([.]au$\\|[.]wav$\\)" file)) ; Sound
           ;; Obsolete: `(lambda () '((filename . ,file) (handler . bmkx-sound-jump))))
           `(lambda () ',(append common '((file-handler . play-sound-file)))))
          (t
           `(lambda () ',common)))))

(defun bmkx--ad-file-cache-add-file (orig-fn file)
  "Respect option `bmkx-autofile-filecache'.
Around-advice for `file-cache-add-file'."
  (cond ((eq bmkx-autofile-filecache 'autofile-only)
         (bmkx-autofile-set file nil nil 'NO-REFRESH-P))
        ((eq bmkx-autofile-filecache 'autofile+cache)
         (funcall orig-fn file)
         (bmkx-autofile-set file nil nil 'NO-REFRESH-P 'MSG-P))
        ((eq bmkx-autofile-filecache 'cache-only)
         (funcall orig-fn file))))

(advice-add 'file-cache-add-file :around #'bmkx--ad-file-cache-add-file)

(defun bmkx-find-file-invoke-bookmark-if-autofile ()
  "Invoke the autofile bookmark associated with the visited file.
This is added to `find-file-hook' when option
`bmkx-autofile-access-invokes-bookmark-flag' is non-nil.  When invoked
it causes regular file access to invoke the associated bookmark.  This
has the effect of updating the bookmark data, such as the number of
visits."
  (let* ((buf-file  (buffer-file-name))
         (bmk       (bmkx-get-bookmark-in-alist (file-name-nondirectory buf-file)
                                                t
                                                (bmkx-autofile-alist-only)))
         (bmk-file  (and bmk  (bookmark-get-filename bmk))))
    (when (and bmk-file  (bmkx-same-file-p buf-file bmk-file))
      (let ((bmkx-autofile-access-invokes-bookmark-flag  nil)) ; Just to be sure.
        (bmkx--jump-via bmk 'ignore)))))

;;;###autoload (autoload 'bmkx-bookmark-a-file "bookmark-x")
(defalias 'bmkx-bookmark-a-file 'bmkx-autofile-set)
;;;###autoload (autoload 'bmkx-autofile-set "bookmark-x")
(defun bmkx-autofile-set (file &optional dir prefix no-refresh-p msg-p) ; Bound to `C-x x c a'
  "Set a bookmark for FILE, autonaming the bookmark for the file.
Return the bookmark.
Interactively, you are prompted for FILE.  You can use `M-n' to pick
up the file name at point or the visited file.

The bookmark name is the nondirectory part of FILE, but with a prefix
arg you are also prompted for a PREFIX string to prepend to the
bookmark name.  The bookmarked position is the beginning of the file.

Note that if you provide PREFIX then the bookmark will not satisfy
`bmkx-autofile-bookmark-p' unless you provide the same PREFIX to that
predicate.

The bookmark's file name is FILE if absolute.  If relative then it is
FILE expanded in DIR, if non-nil, or in the current directory
\(`default-directory').

If a bookmark with the same name already exists for the same file name
then do nothing.

Otherwise, create a new bookmark for the file, even if a bookmark with
the same name already exists.  This means that you can have more than
one autofile bookmark with the same bookmark name and the same
relative file name (nondirectory part), but with different absolute
file names.

Non-interactively:
 - Non-nil NO-REFRESH-P means do not refresh/rebuild the bookmark-list
   display.
 - Non-nil optional arg MSG-P means display status messages."
  (interactive
   (list (let ()
           (read-file-name "File: " nil
                           (let ((deflts  ())
                                 def)
                             (when (setq def  (buffer-file-name)) (push def deflts))
                             (when (setq def  (bmkx-thing-at-point 'filename)) (push def deflts))
                             (when (setq def  (bmkx-ffap-guesser)) (push def deflts))
                             (when (and (boundp 'file-name-at-point-functions)
                                        (setq def  (run-hook-with-args-until-success
                                                    'file-name-at-point-functions)))
                               (push def deflts))
                             deflts)))
         nil
         (and current-prefix-arg  (read-string "Prefix for bookmark name: "))
         nil
         'MSG))
  (let* ((dir-to-use  (if (file-name-absolute-p file)
                          (file-name-directory file)
                        (or dir  default-directory)))
         ;; Look for existing bookmark with same name, same file, in `dir-to-use'.
         (bmk         (bmkx-get-autofile-bookmark file dir-to-use prefix)))
    ;; If BMK was found, then instead of doing nothing we could replace the existing BMK with a new
    ;; one, as follows:
    ;; (let ((bookmark-make-record-function (bmkx-make-record-for-target-file file)))
    ;;   (bmkx-replace-existing-bookmark bmk)) ; Update the existing bookmark.
    (if (not bmk)
        ;; Create a new bookmark, and return it.
        (bmkx-file-target-set (expand-file-name file dir-to-use) t prefix 'NO-OVERWRITE no-refresh-p msg-p)
      (when msg-p (message "Autofile bookmark set for `%s'" file))
      bmk)))                            ; Return the bookmark.

(defun bmkx-get-autofile-bookmark (file &optional dir prefix)
  "Return an existing autofile bookmark for FILE, or nil if there is none.
The bookmark name is PREFIX prepended to the nondirectory part of
FILE (or of FILE's `directory-file-name', if FILE is a directory).

If PREFIX is nil then it acts like an empty prefix (\"\").

The directory part of bookmark entry `filename' is the directory part
of FILE, if FILE is absolute.  Otherwise, it is DIR, if non-nil, or
`default-directory' otherwise.

FILE and the `filename' entry of the bookmark returned are the same,
except possibly for their directory parts (see previous)."
  (let* ((fname       (file-name-nondirectory (if (file-directory-p file)
                                                  (directory-file-name file)
                                                file)))
         (bname       (if prefix (concat prefix fname) fname))
         (dir-to-use  (if (file-name-absolute-p file)
                          (file-name-directory file)
                        (or dir  default-directory))))
    ;; Look for existing bookmark with same name, same file, in `dir-to-use'.
    (catch 'bmkx-get-autofile-bookmark
      (dolist (bmk  bookmark-alist)
        (when (string= bname (bmkx-bookmark-name-from-record bmk))
          (let* ((bfil  (bookmark-get-filename bmk))
                 (bdir  (and bfil  (file-name-directory bfil))))
            (when (and bfil  bdir  (bmkx-same-file-p bdir  dir-to-use)  (bmkx-same-file-p bfil file))
              (throw 'bmkx-get-autofile-bookmark bmk))))) ; Return the bookmark.
      nil)))

;;;###autoload (autoload 'bmkx-tag-a-file "bookmark-x")
(defalias 'bmkx-tag-a-file 'bmkx-autofile-add-tags) ; Bound to `C-x x t + a'
;;;###autoload (autoload 'bmkx-autofile-add-tags "bookmark-x")
(defun bmkx-autofile-add-tags (file tags &optional dir prefix no-update-p msg-p)
  "Add TAGS to the autofile bookmark for FILE (a file or directory name).
Return the number of tags added.

If there is no autofile bookmark for FILE, create one.
Interactively, you are prompted for FILE and then TAGS.
When prompted for FILE you can use `M-n' to pick up the file name at
point, or if none then the visited file.

With a non-negative prefix argument, you are prompted for a file-name
prefix, as in `bmkx-autofile-set'.

When prompted for tags, hit `RET' to enter each tag, then hit `RET'
again after the last tag.  You can use completion to enter each tag.
Completion is lax: you are not limited to existing tags.

By default, the tag choices for completion are NOT refreshed, to save
time.  Use a non-positive prefix argument if you want to refresh them.

Non-interactively:
 - TAGS is a list of strings.
 - DIR and PREFIX are as for `bmkx-autofile-set'.
 - Non-nil NO-UPDATE-P means do not update `bmkx-tags-alist', do not
   update the modification count and maybe save bookmarks, and do not
   refresh/rebuild the bookmark-list display
 - Non-nil MSG-P means display a message about the addition."
  (interactive
   (list (let ()
           (read-file-name "File or directory to tag: " nil
                           (or (if (boundp 'file-name-at-point-functions) ; In `files.el', Emacs 23.2+.
                                   (run-hook-with-args-until-success 'file-name-at-point-functions)
                                 (bmkx-ffap-guesser))
                               (bmkx-thing-at-point 'filename)
                               (buffer-file-name))))
         (bmkx-read-tags-completing nil nil (and current-prefix-arg
                                                 (<= (prefix-numeric-value current-prefix-arg) 0)))
         nil
         (and current-prefix-arg  (wholenump (prefix-numeric-value current-prefix-arg))
              (read-string "Prefix for bookmark name: "))
         nil
         'MSG))
  (bmkx-add-tags (bmkx-autofile-set file dir prefix no-update-p) tags no-update-p msg-p))

;;;###autoload (autoload 'bmkx-untag-a-file "bookmark-x")
(defalias 'bmkx-untag-a-file 'bmkx-autofile-remove-tags) ; Bound to `C-x x t - a'
;;;###autoload (autoload 'bmkx-autofile-remove-tags "bookmark-x")
(defun bmkx-autofile-remove-tags (file tags &optional dir prefix no-update-p msg-p)
  "Remove TAGS from autofile bookmark for FILE.
Return the number of tags removed.

Interactively, you are prompted for TAGS and then FILE.
With Emacs 22 and later, only files with at least one of the given
tags are candidates.

When prompted for FILE you can use `M-n' to pick up the file name at
point, or if none then the visited file.

With a non-negative prefix argument, you are prompted for a file-name
prefix, as in `bmkx-autofile-set'.


When prompted for tags, hit `RET' to enter each tag to be removed,
then hit `RET' again after the last tag.  You can use completion to
enter each tag.

By default, the tag choices for completion are NOT refreshed, to save
time.  Use a non-positive prefix argument if you want to refresh them.

Non-interactively:
 - TAGS is a list of strings.
 - DIR and PREFIX are as for `bmkx-autofile-set'.
 - Non-nil NO-UPDATE-P means do not update `bmkx-tags-alist', do not
   update the modification count and maybe save bookmarks, and do not
   refresh/rebuild the bookmark-list display
 - Non-nil MSG-P means display a message about the removal."
  (interactive
   (let* ((pref
                   (and current-prefix-arg  (wholenump (prefix-numeric-value current-prefix-arg))
                        (read-string "Prefix for bookmark name: ")))
                  (tgs
                   (bmkx-read-tags-completing nil nil (and current-prefix-arg
                                                           (<= (prefix-numeric-value current-prefix-arg) 0))))
                  (fil   (condition-case nil
                             (read-file-name
                              "File: " nil
                              (or (if (boundp 'file-name-at-point-functions) ; In `files.el', Emacs 23.2+.
                                      (run-hook-with-args-until-success 'file-name-at-point-functions)
                                    (bmkx-ffap-guesser))
                                  (bmkx-thing-at-point 'filename)
                                  (buffer-file-name))
                              t nil (lambda (ff) ; PREDICATE - only for Emacs 22+.
                                      (let* ((bmk   (bmkx-get-autofile-bookmark ff nil pref))
                                             (btgs  (and bmk  (bmkx-get-tags bmk))))
                                        (and btgs  (catch 'bmkx-autofile-remove-tags-pred
                                                     (dolist (tag  tgs)
                                                       (when (not (member tag btgs))
                                                         (throw 'bmkx-autofile-remove-tags-pred nil)))
                                                     t)))))
                           (error (read-file-name "File: " nil (or (bmkx-ffap-guesser)
                                                                   (bmkx-thing-at-point 'filename)
                                                                   (buffer-file-name)))))))
     (list fil tgs nil pref nil 'MSG)))
  (bmkx-remove-tags (bmkx-autofile-set file dir prefix no-update-p) tags no-update-p msg-p))

;;;###autoload (autoload 'bmkx-purge-notags-autofiles "bookmark-x")
(defun bmkx-purge-notags-autofiles (&optional prefix msg-p) ; Not bound
  "Delete all autofile bookmarks that have no tags.
With a prefix arg, you are prompted for a PREFIX for the bookmark name.
Non-interactively, non-nil MSG-P means display a status message."
  (interactive (if (not (y-or-n-p "Delete all autofile bookmarks that do not have tags? "))
                   (error "OK - deletion canceled")
                 (list (and current-prefix-arg  (read-string "Prefix for bookmark name: ")) 'MSG)))
  (let ((bmks                (bmkx-autofile-alist-only prefix))
        (bookmark-save-flag  (and (not bmkx-count-multi-mods-as-one-flag)
                                  bookmark-save-flag)) ; Save only after `dolist'.
        tags)
    ;; Needs Bookmark-X version of `bmkx-delete', which accepts a bookmark, not just its name.
    (dolist (bmk  bmks)
      (when (and (setq tags  (assq 'tags (bmkx-bookmark-data-from-record bmk)))
                 (or (not tags)  (null (cdr tags))))
        (bmkx-delete bmk 'BATCHP)))) ; Do not refresh list here - do it after iterate.
  (bmkx-tags-list)         ; Update the tags cache now, after iterate.
  (bmkx-maybe-save-bookmarks) ; Increments `bookmark-alist-modification-count'.
  (bmkx-refresh/rebuild-menu-list nil (not msg-p))) ; Refresh now, after iterate.


;; $$$$$$ Not used currently.
(defun bmkx-replace-existing-bookmark (bookmark)
  "Replace existing BOOKMARK with a new one of the same name.
Return the new bookmark.
BOOKMARK is a full bookmark record, not a bookmark name.

This replaces the existing bookmark data with the data for a new
bookmark, based on `bookmark-make-record-function'.  It also updates
the `bmkx-full-record' on the bookmark name (without otherwise
changing the name)."
  (let (failure)
    (condition-case err
        (progn                          ; Code similar to `bmkx-store'.
          (setcdr bookmark (cdr (bmkx-make-record)))
          (bmkx-maybe-save-bookmarks)
          (let ((bname  (bmkx-bookmark-name-from-record bookmark)))
            ;; This is the same as `add-to-list' with `EQ' (not available for Emacs 20-21).
            (unless (memq bookmark bmkx-modified-bookmarks)
              (setq bmkx-modified-bookmarks  (cons bookmark bmkx-modified-bookmarks)))
            (setq bookmark-current-bookmark  bname))
          (bmkx-list-surreptitiously-rebuild-list 'NO-MSG-P))
      (error (setq failure  (error-message-string err))))
    (if (not failure)
        bookmark                        ; Return the bookmark.
      (error "Failed to update bookmark `%s':\n%s\n"
             (bmkx-bookmark-name-from-record bookmark) failure))))

(defun bmkx-default-handler-for-file (filename)
  "Return a default bookmark handler for FILENAME, or nil.
If non-nil, it is a Lisp function, determined as follows:

1. Match FILENAME against `bmkx-default-handlers-for-file-types'.  If
it matches a Lisp function, return that function.  If it matches a
shell command, return a Lisp function that invokes that shell command.

2. If no match is found and `bmkx-guess-default-handler-for-file-flag'
is non-nil, then try to find an appropriate shell command using, in
order, `dired-guess-default' and `mailcap-file-default-commands'
\(Emacs 23+ only).  If a match is found then return a Lisp function
that invokes that shell command."
  (let* ((bmkx-user  (bmkx-default-handler-user filename))
         (shell-cmd  (if (stringp bmkx-user)
                         bmkx-user
                       (and (not bmkx-user)
                            bmkx-guess-default-handler-for-file-flag
                            (or (and (require 'dired-x nil t)
                                     (let* ((case-fold-search
                                             (or (and (boundp 'dired-guess-shell-case-fold-search)
                                                      dired-guess-shell-case-fold-search)
                                                 case-fold-search))
                                            (default  (dired-guess-default (list filename))))
                                       (if (consp default) (car default) default)))
                                (and (require 'mailcap nil t) ; Emacs 23+
                                     (car (mailcap-file-default-commands (list filename)))))))))
    (cond ((stringp shell-cmd) `(lambda (bmk) (dired-do-shell-command ',shell-cmd nil ',(list filename))))
          ((or (functionp bmkx-user)  (and bmkx-user  (symbolp bmkx-user)))
           bmkx-user)
          (t nil))))

(defun bmkx-default-handler-user (filename)
  "Return default handler for FILENAME.
The value is based on `bmkx-default-handlers-for-file-types'."
  (catch 'bmkx-default-handler-user
    (dolist (assn  bmkx-default-handlers-for-file-types)
      (when (string-match-p (car assn) filename) (throw 'bmkx-default-handler-user (cdr assn))))
    nil))

;; Keep this only for compatibility with existing bookmarks that have `bmkx-sound-jump' as `handler' prop.
(defun bmkx-sound-jump (bookmark)
  "Handler for sound files: play the sound file that is BOOKMARK's file.
This is deprecated.  It is kept only for old bookmarks that already
use this as the `handler' entry.  New sound bookmarks use
`play-sound-file' as entry `file-handler'."
  (play-sound-file (bookmark-get-filename bookmark)))

(progn (defun bmkx-compilation-target-set (&optional prefix) ; Bound to `C-c C-b' in compilation mode
    "Set a bookmark at the start of the line for this compilation hit.
The bookmark is set in the indicated file at the indicated line.
You are prompted for the bookmark name.  But with a prefix arg, you
are prompted only for a PREFIX string.  In that case, and in Lisp
code, the bookmark name is PREFIX followed by the (relative) file name
of the hit, followed by the line number of the hit."
    (interactive "P")
    (let* ((file+line  (bmkx-compilation-file+line-at (line-beginning-position)))
           (file       (car file+line))
           (line       (cdr file+line)))
      (unless (and file  line)  (error "Cursor is not on a compilation hit"))
      (save-excursion
        (with-current-buffer (let ((enable-local-variables  ())) (find-file-noselect file))
          (goto-char (point-min)) (forward-line (1- line))
          (if (not prefix)
              (call-interactively #'bmkx-set)
            (when (called-interactively-p 'interactive)
              (setq prefix  (read-string "Prefix for bookmark name: ")))
            (unless (stringp prefix) (setq prefix  ""))
            (bmkx-set (format "%s%s, line %s" prefix (file-name-nondirectory file) line)
                          99 'INTERACTIVEP))))))

  (defun bmkx-compilation-file+line-at (&optional pos)
    "Return the file and position indicated by this compilation message.
These are returned as a cons: (FILE . POSITION).
POSITION is the beginning of the line indicated by the message."
    (unless pos (setq pos  (point)))
    (let* ((loc        (car (get-text-property pos 'message)))
           (line       (cadr loc))
           (filename   (caar (nth 2 loc)))
           (directory  (cadr (car (nth 2 loc))))
           (spec-dir   (if directory (expand-file-name directory) default-directory)))
      (cons (expand-file-name filename spec-dir) line))))

(defun bmkx-compilation-target-set-all (prefix &optional msg-p) ; Bound to `C-c C-M-b' in compilation mode
    "Set a bookmark for each hit of a compilation buffer.
NOTE: You can use `C-x C-q' to make the buffer writable and then
      remove any hits that you do not want to bookmark.  Only the hits
      remaining in the buffer are bookmarked.

Interactively, you are prompted for a PREFIX string to prepend to each
bookmark name, the rest of which is the file name of the hit followed
by its line number.
Non-interactively, non-nil optional arg MSG-P means prompt and display
status messages."
    (interactive (list (read-string "Prefix for bookmark name: ") 'MSG))
    (when (and msg-p  (not (y-or-n-p "This will bookmark *EACH* hit in the buffer.  Continue? ")))
      (error "OK - canceled"))
    (let ((count  0))
      (save-excursion
        (goto-char (point-min))
        (when (get-text-property (point) 'message) ; Visible part of buffer starts with a hit
          (condition-case nil           ; because buffer is narrowed or header text otherwise removed.
              (bmkx-compilation-target-set prefix) ; Ignore error here (e.g. killed buffer).
            (error nil))
          (setq count  (1+ count)))
        (while (and (condition-case nil (progn (compilation-next-error 1) t) (error nil))
                    (not (eobp)))
          (condition-case nil
              (bmkx-compilation-target-set prefix) ; Ignore error here (e.g. killed buffer).
            (error nil))
          (setq count  (1+ count)))
        (when msg-p (message "Set %d bookmarks" count)))))


;; We could make the `occur' code work for Emacs 20 & 21 also, but you would not be able to
;; delete some occurrences and bookmark only the remaining ones.

(defun bmkx-occur-target-set (&optional prefix) ; Bound to `C-c C-b' in Occur mode
    "Set a bookmark at the start of the line for this `(multi-)occur' hit.
You are prompted for the bookmark name.  But with a prefix arg, you
are prompted only for a PREFIX string.  In that case, and in Lisp
code, the bookmark name is PREFIX followed by the buffer name of the
hit, followed by the line number of the hit.

You can use this only in `Occur' mode (commands such as `occur' and
`multi-occur')."
    (interactive "P")
    (unless (eq major-mode 'occur-mode) (error "You must be in `occur-mode'"))
    (let* ((line  (and prefix
                       (save-excursion
                         (forward-line 0)
                         ;; We could use [: ] here, to handle `moccur', but that loses anyway for
                         ;; `occur-mode-find-occurrence', so we would need other hoops too.
                         (re-search-forward "^\\s-+\\([0-9]+\\):" (line-end-position) 'NOERROR)
                         (or (format "%5d" (string-to-number (match-string 1)))  ""))))
           (mkr   (occur-mode-find-occurrence))
           (buf   (marker-buffer mkr)))
      (save-excursion (with-current-buffer buf
                        (goto-char mkr)
                        (if (not prefix)
                            (call-interactively #'bmkx-set)
                          (when (called-interactively-p 'interactive)
                            (setq prefix  (read-string "Prefix for bookmark name: ")))
                          (unless (stringp prefix) (setq prefix  ""))
                          (bmkx-set (format "%s%s, line %s" prefix buf line) 99 'INTERACTIVEP))))))

(defun bmkx-occur-target-set-all (&optional prefix msg-p) ; Bound to `C-c C-M-b' in Occur mode
    "Set a bookmark for each hit of a `(multi-)occur' buffer.
NOTE: You can use `C-x C-q' to make the buffer writable and then
      remove any hits that you do not want to bookmark.  Only the hits
      remaining in the buffer are bookmarked.

Interactively, you are prompted for a PREFIX string to prepend to each
bookmark name, the rest of which is the buffer name of the hit
followed by its line number.

You can use this only in `Occur' mode (commands such as `occur' and
`multi-occur').

See also command `bmkx-occur-create-autonamed-bookmarks', which
creates autonamed bookmarks to all `occur' and `multi-occur' hits.

Non-interactively, non-nil MSG-P means prompt and show status
messages."
    (interactive (list (read-string "Prefix for bookmark name: ") 'MSG))
    (when (and msg-p  (not (y-or-n-p "This will bookmark *EACH* hit in the buffer.  Continue? ")))
      (error "OK - canceled"))
    (let ((count  0))
      (save-excursion
        (goto-char (point-min))
        (while (condition-case nil
                   (progn (occur-next) t) ; "No more matches" ends loop.
                 (error nil))
          (condition-case nil
              (bmkx-occur-target-set prefix) ; Ignore error here (e.g. killed buffer).
            (error nil))
          (setq count  (1+ count)))
        (when msg-p (message "Set %d bookmarks" count)))))


;;(@* "Bookmark Links")
;;  *** Bookmark Links ***

(progn (defun bmkx-bookmark-linked-at (&optional position msgp)
    "Return the bookmark linked at POSITION (default: point), or nil if none."
    (interactive "d\np")
    (unless position (setq position  (point)))
    (let ((bmk  (get-text-property position 'bmkx-bookmark)))
      (prog1 bmk (when msgp (if bmk (bmkx-describe-bookmark bmk) (message "No bookmark here"))))))

  (defun bmkx-bookmark-linked-at-mouse (event)
    "Return the bookmark linked at the mouse position."
    (interactive "e")
    (bmkx-bookmark-linked-at (posn-point (event-end event)) 'MSG))

  (defun bmkx-jump-to-bookmark-linked-at (&optional position)
    "Jump to the bookmark linked at POSITION (default: point).
If a bookmark is linked at POSITION then jump to it.  Else raise an error."
    (interactive "d")
    (let ((bmk  (bmkx-bookmark-linked-at position)))
      (unless bmk (error "No bookmark here"))
      (bmkx-jump-other-window bmk)))

  (defun bmkx-jump-to-bookmark-linked-at-mouse (event)
    "Jump to the bookmark linked at the mouse position."
    (interactive "e")
    (bmkx-jump-to-bookmark-linked-at (posn-point (event-end event))))

  (defun bmkx-insert-bookmark-link (bookmark text &optional position)
    "Put a link to BOOKMARK on the active region or at point.
You are prompted for the bookmark name.
If the region is active and nonempty then put the link on its text.

Otherwise, you are prompted for the link text, which is inserted at
point.  The default text for this is the BOOKMARK name.  An unlinked
`SPC' char is inserted after the link, unless it is at the end of a
line.

Using `?' or double-clicking `mouse-1' on the link describes the
BOOKMARK.  Using `RET' or `mouse-2' on it jumps to BOOKMARK in another
window.

BOOKMARK is a bookmark name or a bookmark record.

Non-interactively, if the region is inactive or empty then TEXT is the
link text, and it is inserted at POSITION (point if POSITION is nil)."
    (interactive
     (let* ((bmk  (bmkx-completing-read "Bookmark"))
            (txt  (if (and transient-mark-mode  mark-active  (> (region-end) (region-beginning)))
                      (buffer-substring-no-properties (region-end) (region-beginning))
                    (read-string "Insert text: " nil nil bmk))))
       (list bmk txt)))
    (with-buffer-modified-unmodified
        (let* ((regionp  (and transient-mark-mode  mark-active  (> (region-end) (region-beginning))))
               (beg      (if regionp (region-beginning) (or position  (point))))
               (end      (and regionp  (region-end)))
               (bmk      (bmkx-get-bookmark bookmark))
               (map      (make-sparse-keymap)))
          (unless bmk (error "No such bookmark"))
          ;; Use `copy-sequence'.  The bookmark name in the bookmark might change.
          (setq bookmark  (copy-sequence (bmkx-bookmark-name-from-record bmk)))
          (put-text-property 0 (length bookmark) 'bmkx-bookmark bmk bookmark)
          (define-key map "?"              'bmkx-bookmark-linked-at)
          (define-key map "\r"             'bmkx-jump-to-bookmark-linked-at)
          (define-key map [double-mouse-1] 'bmkx-bookmark-linked-at-mouse)
          (define-key map [mouse-2]        'bmkx-jump-to-bookmark-linked-at-mouse)
          (define-key map [follow-link]    'mouse-face)
          (unless regionp (insert text))
          (add-text-properties beg (or end  (point))
                               `(bmkx-bookmark     ,bookmark
                                 keymap            ,map
                                 font-lock-ignore  t ; Prevent font-lock from changing the face.
                                 face              link
                                 mouse-face        highlight
                                 help-echo
                                 "RET, mouse-2: jump to bookmark; ?, double-mouse-1: describe bookmark"))
          (unless (or regionp  (eolp)) (insert " ")))))

  )


;;(@* "Other Bookmark-X Functions (`bmkx-*')")
;;  *** Other Bookmark-X Functions (`bmkx-*') ***

;;;###autoload (autoload 'bmkx-describe-bookmark "bookmark-x")
(defun bmkx-describe-bookmark (bookmark &optional defn) ; Bound to `C-h M'
  "Describe BOOKMARK.
With a prefix argument, show the internal definition of the bookmark.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'.

Starting with Emacs 22, if the file is an image file then:
* Show a thumbnail of the image as well.
* If you have command-line tool `exiftool' installed and in your
  `$PATH' or `exec-path', then show EXIF data (metadata) about the
  image.  See standard Emacs library `image-dired.el' for more
  information about `exiftool'"
  (interactive (list (bmkx-completing-read "Describe bookmark"
                                               (or (and (fboundp 'bmkx-default-lighted)
                                                        (bmkx-default-lighted))
                                                   (bmkx-default-bookmark-name)))
                     current-prefix-arg))
  (if defn
      (bmkx-describe-bookmark-internals bookmark)
    (setq bookmark  (bmkx-get-bookmark bookmark))
    (help-setup-xref (list #'bmkx-describe-bookmark bookmark) (called-interactively-p 'interactive))
    (let ((help-text  (bmkx-bookmark-description bookmark)))
      (bmkx-with-help-window "*Help*"
                             (princ help-text)
                             (bmkx-add-describe-bookmark-internals-button bookmark)
                             (bmkx-add-jump-to-list-button bookmark))
      (with-current-buffer "*Help*"
        (save-excursion
          (goto-char (point-min))
          (when (re-search-forward "@#%&()_IMAGE-HERE_()&%#@\\(.+\\)" nil t)
            (let* ((image-file        (match-string 1))
                   (image-string      (save-match-data
                                        (apply #'propertize "X"
                                               `(display
                                                 ,(append (image-dired-get-thumbnail-image image-file)
                                                          '(:margin 10))
                                                 rear-nonsticky (display)
                                                 mouse-face highlight
                                                 follow-link t
                                                 help-echo "`mouse-2' or `RET': Show full image"
                                                 keymap
                                                 (keymap
                                                  (mouse-2
                                                   . (lambda (e) (interactive "e")
                                                       (find-file ,image-file)))
                                                  (13
                                                   . (lambda () (interactive)
                                                       (find-file ,image-file))))))))
                   (buffer-read-only  nil))
              (replace-match image-string)))))
      help-text)))

(defun bmkx-bookmark-description (bookmark &optional no-image)
  "Help-text description of BOOKMARK.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'.

Starting with Emacs 22 and unless optional arg NO-IMAGE is non-nil, if
the file is an image file then the description includes the following:
* A placeholder for a thumbnail image: \"@#%&()_IMAGE-HERE_()&%#@\"
* EXIF data (metadata) about the image, provided you have command-line
  tool `exiftool' installed and in your `$PATH' or `exec-path'.  See
  standard Emacs library `image-dired.el' for more information about
  `exiftool'."
  (setq bookmark  (bmkx-get-bookmark bookmark))
  (let ((print-length     nil)          ; For `pp-to-string'
        (print-level      nil)          ; For `pp-to-string'
        (bname            (bmkx-bookmark-name-from-record bookmark))
        (buf              (bmkx-get-buffer-name bookmark))
        (file             (bookmark-get-filename bookmark))
        (location         (bookmark-prop-get bookmark 'location))
        (start            (bookmark-get-position bookmark))
        (end              (bmkx-get-end-position bookmark))
        (created          (bookmark-prop-get bookmark 'created))
        (time             (bmkx-get-visit-time bookmark))
        (visits           (bmkx-get-visits-count bookmark))
        (tags             (mapcar #'bmkx-tag-name (bmkx-get-tags bookmark)))
        (sequence-p       (bmkx-sequence-bookmark-p bookmark))
        (function-p       (bmkx-function-bookmark-p bookmark))
        (kmacro-p         (bmkx-kmacro-list-bookmark-p bookmark))
        (variable-list-p  (bmkx-variable-list-bookmark-p bookmark))
        (non-invokable-p  (bmkx-non-invokable-bookmark-p bookmark))
        (desktop-p        (bmkx-desktop-bookmark-p bookmark))
        (bookmark-file-p  (bmkx-bookmark-file-bookmark-p bookmark))
        (snippet-p        (bmkx-snippet-bookmark-p bookmark))
        (dired-p          (bmkx-dired-bookmark-p bookmark))
        (gnus-p           (bmkx-gnus-bookmark-p bookmark))
        (info-p           (bmkx-info-bookmark-p bookmark))
        (man-p            (bmkx-man-bookmark-p bookmark))
        (url-p            (bmkx-url-bookmark-p bookmark))
        (eww-p            (and (fboundp 'bmkx-eww-bookmark-p)  (bmkx-eww-bookmark-p bookmark))) ; Emacs 25+
        (w3m-p            (bmkx-w3m-bookmark-p bookmark))
        (temp-p           (bmkx-temporary-bookmark-p bookmark))
        (annot            (bookmark-get-annotation bookmark))
        non-file-p no-position-p)
    (setq non-file-p     (equal file bmkx-non-file-filename)
          no-position-p  (not start))
    (when (or sequence-p  function-p  variable-list-p  kmacro-p) (setq no-position-p  t))
    (let* ((temp-text  (if temp-p "TEMPORARY " ""))
           (help-text
            (concat
             (format "%sBookmark `%s'\n%s\n\n" temp-text bname
                     (make-string (+ 11 (length temp-text) (length bname)) ?-))
             (cond (sequence-p       (concat "Sequence:\n\t"
                                             (mapconcat (lambda (bname)
                                                          (let ((name  (copy-sequence bname)))
                                                            (set-text-properties 0 (length name) () name)
                                                            name))
                                                        (bookmark-prop-get bookmark 'sequence)
                                                        "\n\t")
                                             "\n"))
                   (function-p       (let ((fn            (bookmark-prop-get bookmark 'function)))
                                       (if (symbolp fn)
                                           (format "Function:\t\t%s\n" fn)
                                         (format "Function:\n%s\n"
                                                 (pp-to-string (bookmark-prop-get bookmark 'function))))))
                   (kmacro-p         (format "Keyboard Macro List (MACRO COUNT COUNT-FORMAT):\n\n%s\n"
                                             (pp-to-string (bookmark-prop-get bookmark 'kmacros))))
                   (variable-list-p  (format "Variable list:\n%s\n"
                                             (pp-to-string (bookmark-prop-get bookmark 'variables))))
                   (non-invokable-p  (format "Non-invokable:\n\n%s"
                                             (let ((desc  (bookmark-prop-get bookmark 'filter-description)))
                                               (if desc
                                                   (format "Isearch filter:\n%s\n" desc)
                                                 ""))))
                   (gnus-p           (format "Gnus, group:\t\t%s, article: %s, message-id: %s\n"
                                             (bookmark-prop-get bookmark 'group)
                                             (bookmark-prop-get bookmark 'article)
                                             (bookmark-prop-get bookmark 'message-id)))
                   (man-p            (format "UNIX `man' page for:\t`%s'\n"
                                             (or (bookmark-prop-get bookmark 'man-args)
                                                 ;; WoMan has no variable for the cmd name.
                                                 (bookmark-prop-get bookmark 'buffer-name))))
                   (info-p           (and file  (format "Info node:\t\t(%s) %s\n"
                                                        (file-name-nondirectory file)
                                                        (bookmark-prop-get bookmark 'info-node))))
                   (eww-p            (and file  (format "EWW URL:\t\t%s\n" file))) ; Emacs 25+
                   (w3m-p            (and file  (format "W3m URL:\t\t%s\n" file)))
                   (url-p            (format "URL:\t\t\t%s\n" location))
                   (desktop-p        (format "Desktop file:\t\t%s\n"
                                             (bookmark-prop-get bookmark 'desktop-file)))
                   (bookmark-file-p  (format "Bookmark file:\t\t%s\n"
                                             (bookmark-prop-get bookmark 'bookmark-file)))
                   (snippet-p        (format "Snippet for `kill-ring'.\n"))
                   (dired-p          (and file
                                          (let* ((switches  (bookmark-prop-get bookmark 'dired-switches))
                                                 (marked    (length (bookmark-prop-get bookmark
                                                                                       'dired-marked)))
                                                 (inserted  (length (bookmark-prop-get bookmark
                                                                                       'dired-subdirs)))
                                                 (hidden    (length (bookmark-prop-get bookmark
                                                                                       'dired-hidden-dirs)))
                                                 (dir-dir   (bookmark-prop-get bookmark 'dired-directory))
                                                 (files     (and (consp dir-dir)  (cdr dir-dir))))
                                            (format "Dired%s:%s\t\t%s\nMarked:\t\t\t%s\n\
Inserted subdirs:\t%s\nHidden subdirs:\t\t%s\n%s"
                                                    (if switches (format " `%s'" switches) "")
                                                    (if switches "" (format "\t"))
                                                    (expand-file-name file)
                                                    marked inserted hidden
                                                    (if (not files)
                                                        ""
                                                      (format "Explicit file list:\n  %s\n"
                                                              (mapconcat #'identity
                                                                         files
                                                                         "\n  ")))))))
                   (non-file-p       (or (and location  (format "Location:\t\t%s\n" location))
                                         (and buf  (format "Buffer:\t\t\t%s\n" buf))))
                   (file             (concat (format "File:\t\t\t%s\n" (file-name-nondirectory file))
                                             (let ((dir  (file-name-directory (expand-file-name file))))
                                               (and dir  (format "Directory:\t\t%s\n" dir)))))
                   (t                "Unknown\n"))
             (unless no-position-p
               (if (bmkx-region-bookmark-p bookmark)
                   (format "Region:\t\t\t%d to %d (%d chars)\n" start end (- end start))
                 (format "Position:\t\t%d\n" start)))
             (and visits     (format "Visits:\t\t\t%d\n" visits))
             (and time       (format "Last visit:\t\t%s\n" (format-time-string "%c" time)))
             (and created    (format "Creation:\t\t%s\n" (format-time-string "%c" created)))
             (and tags       (format "Tags:\n \"%s\"\n" (mapconcat #'identity tags "\"\n \"")))
             (and annot      (format "\nAnnotation:\n%s\n" annot))
             (and snippet-p  (format "\nSnippet:\n%s\n" (bookmark-prop-get bookmark 'text)))
             (and (not no-image)
                  file
                  (string-match-p (image-file-name-regexp) file)
                  (display-graphic-p)
                  (require 'image-dired nil t)
                  (image-dired-get-thumbnail-image file)
                  (concat "\n@#%&()_IMAGE-HERE_()&%#@" file "\n"))
             (and (not no-image)
                  file
                  (string-match-p (image-file-name-regexp) file)
                  (progn (message "Gathering image data...") t)
                  (condition-case nil
                      (let ((all  (bmkx-all-exif-data (expand-file-name file))))
                        (concat
                         (and all  (not (zerop (length all)))
                              (format "\nImage Data (EXIF)\n-----------------\n%s"
                                      all))))
                    (error nil))))))
      help-text)))

(when (and (condition-case nil (require 'help-mode nil t) (error nil))
           (get 'help-xref 'button-category-symbol)) ; In `button.el'
  
  (define-button-type 'bmkx-jump-to-list-button
    :supertype 'help-xref
    'help-function #'bmkx-jump-to-list
    'help-echo
    (purecopy "mouse-2, RET: Show in `*Bmkx List*'"))

  (define-button-type 'bmkx-describe-bookmark-button
    :supertype 'help-xref
    'help-function #'bmkx-describe-bookmark
    'help-echo
    (purecopy "mouse-2, RET: Show external form"))

  (define-button-type 'bmkx-describe-bookmark-internals-button
    :supertype 'help-xref
    'help-function #'bmkx-describe-bookmark-internals
    'help-echo
    (purecopy "mouse-2, RET: Show internal form"))

  )

(defun bmkx-add-jump-to-list-button (bookmark)
  "Add a [Show in `*Bmkx List*'] button for BOOKMARK."
  (with-current-buffer "*Help*"
    (let ((buffer-read-only  nil))
      ;; Add button to go to the bookmark entry in `*Bmkx List*'.
      (when (condition-case nil (require 'help-mode nil t) (error nil))
        (goto-char (point-min)) (forward-line 2)
        (help-insert-xref-button "[Show in `*Bmkx List*']"
                                 #'bmkx-jump-to-list-button
                                 (bookmark-name-from-record bookmark))
        (insert "\n")))))

(defun bmkx-add-describe-bookmark-button (bookmark)
  "Add an [External Form] button for BOOKMARK."
  (with-current-buffer "*Help*"
    (let ((buffer-read-only  nil))
      ;; Add button to go to the bookmark entry in `*Bmkx List*'.
      (when (condition-case nil (require 'help-mode nil t) (error nil))
        (goto-char (point-max))
        (insert "\n")
        (help-insert-xref-button "[External Form]"
                                 #'bmkx-describe-bookmark-button
                                 (bookmark-name-from-record bookmark))
        (insert "\n")))))

(defun bmkx-add-describe-bookmark-internals-button (bookmark)
  "Add an [Internal Form] button for BOOKMARK."
  (with-current-buffer "*Help*"
    (let ((buffer-read-only  nil))
      ;; Add button to go to the bookmark entry in `*Bmkx List*'.
      (when (condition-case nil (require 'help-mode nil t) (error nil))
        (goto-char (point-max))
        (insert "\n")
        (help-insert-xref-button "[Internal Form]"
                                 #'bmkx-describe-bookmark-internals-button
                                 (bookmark-name-from-record bookmark))
        (insert "\n")))))

;; This is the same as `help-all-exif-data' in `help-fns+.el', but we avoid requiring that library.
(defun bmkx-all-exif-data (file)
  "Return all EXIF data from FILE, using command-line tool `exiftool'."
  (with-temp-buffer
    (delete-region (point-min) (point-max))
    (unless (eq 0 (call-process shell-file-name nil t nil shell-command-switch
                                (format "exiftool -All \"%s\"" file)))
      (error "Could not get EXIF data"))
    (buffer-string)))


;;;###autoload (autoload 'bmkx-describe-bookmark-internals "bookmark-x")
(defun bmkx-describe-bookmark-internals (bookmark)
  "Show the internal definition of the bookmark BOOKMARK.
BOOKMARK is a bookmark name or a bookmark record.
If it is a record then it need not belong to `bookmark-alist'."
  (interactive (list (bmkx-completing-read "Describe bookmark" (bmkx-default-bookmark-name))))
  ;; Work with a copy of the bookmark, so we can unpropertize the name.
  (setq bookmark  (copy-sequence (bmkx-get-bookmark bookmark)))
  (help-setup-xref (list #'bmkx-describe-bookmark-internals bookmark) (called-interactively-p 'interactive))
  (let* ((bname         (copy-sequence (bmkx-bookmark-name-from-record bookmark)))
         (_IGNORE       (set-text-properties 0 (length bname) nil bname)) ; Strip properties from name.
         (bmk           (cons bname (bmkx-bookmark-data-from-record bookmark))) ; Fake bmk with stripped name.
         (print-length  nil)            ; For `pp-to-string'
         (print-level   nil)            ; For `pp-to-string'
         (help-text     (format "Bookmark `%s'\n%s\n\n%s" bname (make-string (+ 11 (length bname)) ?-)
                                (pp-to-string bmk))))
    (bmkx-with-help-window "*Help*"
                           (princ help-text)
                           (bmkx-add-describe-bookmark-button bookmark)
                           (bmkx-add-jump-to-list-button bookmark))
    help-text))

(defun bmkx-annotation-or-bookmark-description (bookmark)
  "Return the annotation or description of BOOKMARK as a string.
If BOOKMARK has an annotation then use that; else the description."
  (or (bookmark-get-annotation bookmark)
      (bmkx-bookmark-description bookmark)))

;;;###autoload (autoload 'bmkx-list-defuns-in-commands-file "bookmark-x")
(defun bmkx-list-defuns-in-commands-file ()
  "List the functions defined in `bmkx-bmenu-commands-file'.
Typically, these are all commands."
  (interactive)
  (when (and bmkx-bmenu-commands-file  (file-readable-p bmkx-bmenu-commands-file))
    (when (file-directory-p bmkx-bmenu-commands-file)
      (error "`%s' is a directory, not a file" bmkx-bmenu-commands-file))
    (let ((fns  ())
          (buf  (let ((enable-local-variables  nil))
                  (find-file-noselect bmkx-bmenu-commands-file))))
      (help-setup-xref (list #'bmkx-list-defuns-in-commands-file) (called-interactively-p 'interactive))
      (with-current-buffer buf
        (goto-char (point-min))
        (while (not (eobp))
          (when (re-search-forward "\\s-*(defun \\([^ \t\n(\"]+\\)[ \t\n(]" nil 'move)
            (push (match-string 1) fns)))
        (setq fns  (nreverse fns)
              fns  (sort fns 'string-lessp)))
      (when (buffer-live-p buf) (kill-buffer buf))
      (bmkx-with-help-window
       "*Help*"
       (princ "Bookmark Commands You Defined (in `bmkx-bmenu-commands-file')") (terpri)
       (princ "------------------------------------------------------------------") (terpri)
       (terpri)
       (let ((non-dups  (bmkx-remove-dups fns)))
         (dolist (fn  non-dups)
           (if (fboundp (intern fn))
               (with-current-buffer "*Help*"
                 (goto-char (point-max))
                 (help-insert-xref-button fn 'help-function (intern fn) (commandp (intern fn))))
             (princ fn))
           (let ((dups   (member fn fns)) ; Sorted, so all dups are together.
                 (count  0))
             (while (equal fn (car dups))
               (setq count  (1+ count)
                     dups   (cdr dups)))
             (when (> count 1) (princ (format "  (%d times)" count))))
           (terpri)))
       (help-make-xrefs (current-buffer)))
      fns)))

(defun bmkx-root-or-sudo-logged-p ()
  "Return t if the user logged in using Tramp as `root' or `sudo'.
Otherwise, return nil."
  (catch 'break
    (dolist (ii  (mapcar #'buffer-name (buffer-list)))
      (when (string-match-p "*tramp/\\(su\\|sudo\\) ." ii) (throw 'break t)))))

(defun bmkx-position-post-context (breg)
  "Return `bookmark-search-size' chars, starting at position BREG.
Return nil if there are not that many chars.
This is text that follows the bookmark's `position'.
This is used for a non-region bookmark."
  (and (>= (- (point-max) breg) bookmark-search-size)
       (buffer-substring-no-properties breg (+ breg bookmark-search-size))))

(defun bmkx-position-post-context-region (breg ereg)
  "Return the region prefix, at BREG.
Return at most `bmkx-region-search-size' or (- EREG BREG) chars.
This is text that follows the bookmark's `position'.
This is used for a region bookmark."
  (buffer-substring-no-properties breg (+ breg (min bmkx-region-search-size (- ereg breg)))))

(defun bmkx-position-pre-context (breg)
  "Return `bookmark-search-size' chars that precede BREG.
Return nil if there are not that many chars.
This is text that precedes the bookmark's `position'.
This is used for a non-region bookmark."
  (and (>= (- breg (point-min)) bookmark-search-size)
       (buffer-substring-no-properties breg (- breg bookmark-search-size))))

(defun bmkx-position-pre-context-region (breg)
  "Return the text preceding the region beginning, BREG.
Return at most `bmkx-region-search-size' chars.
This is text that precedes the bookmark's `position'.
This is used for a region bookmark."
  (buffer-substring-no-properties (max (- breg bmkx-region-search-size) (point-min)) breg))

(defun bmkx-end-position-pre-context (breg ereg)
  "Return the region suffix, ending at EREG.
Return at most `bmkx-region-search-size' or (- EREG BREG) chars.
This is text that precedes the bookmark's `end-position'."
  (buffer-substring-no-properties (- ereg (min bmkx-region-search-size (- ereg breg))) ereg))

(defun bmkx-end-position-post-context (ereg)
  "Return the text following the region end, EREG.
Return at most `bmkx-region-search-size' chars.
This is text that follows the bookmark's `end-position'."
  (buffer-substring-no-properties ereg (+ ereg (min bmkx-region-search-size (- (point-max) ereg)))))

(defun bmkx-position-after-whitespace (position)
  "Move forward from POSITION, skipping over whitespace.  Return point."
  (goto-char position)  (skip-chars-forward " \n\t" (point-max))  (point))

(defun bmkx-position-before-whitespace (position)
  "Move backward from POSITION, skipping over whitespace.  Return point."
  (goto-char position)  (skip-chars-backward " \n\t" (point-min))  (point))

(defun bmkx-save-new-region-location (bookmark beg end)
  "Update and save `bookmark-alist' for BOOKMARK, relocating its region.
Saving happens according to `bookmark-save-flag'.
BOOKMARK is a bookmark record.
BEG and END are the new region limits for BOOKMARK.
Do nothing and return nil if `bmkx-save-new-location-flag' is nil.
Otherwise, return non-nil if region was relocated."
  (and bmkx-save-new-location-flag
       (y-or-n-p "Region relocated.  Do you want to save new region limits? ")
       (progn
         (bmkx-prop-set bookmark 'front-context-string (bmkx-position-post-context-region beg end))
         (bmkx-prop-set bookmark 'rear-context-string (bmkx-position-pre-context-region beg))
         (bmkx-prop-set bookmark 'front-context-region-string (bmkx-end-position-pre-context beg end))
         (bmkx-prop-set bookmark 'rear-context-region-string (bmkx-end-position-post-context end))
         (bmkx-prop-set bookmark 'position beg)
         (bmkx-prop-set bookmark 'end-position end)
         (bmkx-maybe-save-bookmarks)
         t)))

(defun bmkx-handle-region-default (bookmark)
  "Default function to handle BOOKMARK's region.
BOOKMARK is a bookmark name or a bookmark record.
Relocate the region if necessary, then activate it.
If region was relocated, save it if user confirms saving."
  ;; Relocate by searching from the beginning (and possibly the end) of the buffer.
  (let* (;; Get bookmark object once and for all.
         ;; We should know BOOKMARK is a bookmark record (not a name), but play it safe.
         (bmk              (bmkx-get-bookmark bookmark))
         (bor-str          (bookmark-get-front-context-string bmk))
         (eor-str          (bookmark-prop-get bmk 'front-context-region-string))
         (br-str           (bookmark-get-rear-context-string bmk))
         (ar-str           (bookmark-prop-get bookmark 'rear-context-region-string))
         (pos              (bookmark-get-position bmk))
         (end-pos          (bmkx-get-end-position bmk))
         (reg-retrieved-p  t)
         (reg-relocated-p  nil))
    (unless (and end-pos
                 (string= bor-str (buffer-substring-no-properties
                                   (point) (min (point-max) (+ (point) (length bor-str)))))
                 (string= eor-str (buffer-substring-no-properties
                                   end-pos (max (point-min) (- end-pos (length bor-str))))))
      ;; Relocate region by searching from beginning (and possibly from end) of buffer.
      (let ((beg  nil)
            (end  nil))
        ;;  Go to bob and search forward for END.
        (goto-char (point-min))
        (if (search-forward eor-str (point-max) t) ; Find END, using `eor-str'.
            (setq end  (point))
          ;; Verify that region is not before context.
          (unless (search-forward br-str (point-max) t)
            (when (search-forward ar-str (point-max) t) ; Find END, using `ar-str'.
              (setq end  (match-beginning 0)
                    end  (and end  (bmkx-position-before-whitespace end))))))
        ;; If failed to find END, go to eob and search backward for BEG.
        (unless end (goto-char (point-max)))
        (if (search-backward bor-str (point-min) t) ; Find BEG, using `bor-str'.
            (setq beg  (point))
          ;; Verify that region is not after context.
          (unless (search-backward ar-str (point-min) t)
            (when (search-backward br-str (point-min) t) ; Find BEG, using `br-str'.
              (setq beg  (match-end 0)
                    beg  (and beg  (bmkx-position-after-whitespace beg))))))
        (setq reg-retrieved-p  (or beg  end)
              reg-relocated-p  reg-retrieved-p
              ;; If only one of BEG or END was found, the relocated region is only
              ;; approximate (keep the same length).  If both were found, it is exact.
              pos              (or beg  (and end  pos  end-pos  (- end (- end-pos pos)))  pos)
              end-pos          (or end  (and beg  pos  end-pos  (+ pos (- end-pos pos)))  end-pos))))
    ;; Region is available. Activate it and maybe save it.
    (cond (reg-retrieved-p
           (when pos (goto-char pos))
           (when end-pos (push-mark end-pos 'nomsg 'activate))
           (when bmkx-show-end-of-region-flag
             (let ((end-win  (save-excursion (forward-line (window-height)) (line-end-position))))
               ;; Bounce point and mark.
               (save-excursion (sit-for 0.6) (exchange-point-and-mark) (sit-for 1))
               ;; Recenter if region end is not visible.
               (when (and end-pos  (> end-pos end-win)) (recenter 1))))
           ;; Maybe save region.
           (if (and reg-relocated-p  (bmkx-save-new-region-location bmk pos end-pos))
               (message "Saved relocated region%s" (if (and pos  end-pos)
                                                       (format " (from %d to %d)" pos end-pos)
                                                     ""))
             (when (and pos  end-pos) (message "Region is from %d to %d" pos end-pos)))
           (when (and pos  end-pos)
             (goto-char pos)
             (push-mark end-pos 'nomsg 'activate)
             (setq deactivate-mark  nil)))
          ((and pos  end-pos) ; No region.  Go to old start.  Don't push-mark.
           (goto-char pos) (forward-line 0)
           (message "No region from %d to %d" pos end-pos)))))

(defun bmkx-goto-position (bookmark file buf bufname pos forward-str behind-str)
  "Go to a bookmark that has no region.
Update the recorded position if POS and `bmkx-save-new-location-flag'
are non-nil.

Arguments are respectively the bookmark, its file, buffer, buffer
name, recorded position, and the context strings for the position."
  (if (and file  (file-readable-p file)  (not (buffer-live-p buf)))
;;; $$$$$$$ (with-current-buffer (let ((enable-local-variables  ())) (find-file-noselect file))
      (with-current-buffer (find-file-noselect file) (setq buf  (buffer-name)))
    ;; No file found.  See if a non-file buffer exists for this.  If not, raise error.
    (unless (or (and buf  (get-buffer buf))
                (and bufname  (get-buffer bufname)  (not (string= buf bufname))))
      (signal 'file-error `("Jumping to bookmark" ,(format "Cannot access file `%s' or buffer `%s'"
                                                           file bufname)))))
  (set-buffer (or buf  bufname))
  (when bmkx-jump-display-function
    (save-current-buffer (funcall bmkx-jump-display-function (current-buffer))))
  (setq deactivate-mark  t)
  (raise-frame)
  (when pos (goto-char pos))
  ;; Try to relocate position.
  ;; Search forward first.  Then, if FORWARD-STR exists and was found in the file, search
  ;; backward for BEHIND-STR.  The rationale is that if text was inserted between the two
  ;; in the file, then it's better to end up before point, so you can see the text, rather
  ;; than after it and not see it.
  (when (and forward-str  (search-forward forward-str (point-max) t))
    (goto-char (match-beginning 0)))
  (when (and behind-str  (search-backward behind-str (point-min) t))  (goto-char (match-end 0)))
  (when (and (not (equal pos (point)))  bmkx-save-new-location-flag)
    (bmkx-prop-set bookmark 'position     (point))
    (bmkx-prop-set bookmark 'end-position (point))
    ;; Perhaps we should treat the case of a bookmark that had position 0 changing to position 1 specially,
    ;; by passing non-nil SAME-COUNT-P arg to `bmkx-maybe-save-bookmarks'.  On the other hand, if initially
    ;; 0 then the bookmark does not claim that the file is non-empty.  If now set to 1 then we know it is.
    ;; Leave it this way, at least for now.  The consequence is that the user will see that bookmarks have
    ;; modified (e.g. `Save' is enabled in the menu), even though nothing much has changed.
    (bmkx-maybe-save-bookmarks))
  (not (equal pos (point))))            ; Return value indicates whether POS was accurate.

(defun bmkx-jump-sequence (bookmark)
  "Handle a sequence bookmark BOOKMARK.
Handler function for sequence bookmarks.
BOOKMARK is a bookmark name or a bookmark record."
  (dolist (bmk  (bookmark-prop-get bookmark 'sequence))
    (bmkx--jump-via bmk bmkx-sequence-jump-display-function))
  (message "Done invoking bookmarks in sequence `%s'"
           (if (stringp bookmark) bookmark (bmkx-bookmark-name-from-record bookmark))))

(defun bmkx-jump-function (bookmark)
  "Handle a function bookmark BOOKMARK.
Handler function for function bookmarks.
BOOKMARK is a bookmark name or a bookmark record."
  (let ((fn  (bookmark-prop-get bookmark 'function)))
    (cond ((functionp fn) (funcall fn))
          ((arrayp fn)    (execute-kbd-macro fn current-prefix-arg)))))

(defun bmkx-make-bookmark-list-record ()
  "Create and return a bookmark-list bookmark record.
This records the current state of buffer `*Bmkx List*': the sort
order, filter function, regexp pattern, title, and omit list."
  (let ((state  `((last-sort-comparer            . ,bmkx-sort-comparer)
                  (last-reverse-sort-p           . ,bmkx-reverse-sort-p)
                  (last-reverse-multi-sort-p     . ,bmkx-reverse-multi-sort-p)
                  (last-bmenu-filter-function    . ,bmkx-bmenu-filter-function)
                  (last-bmenu-filter-pattern     . ,bmkx-bmenu-filter-pattern)
                  (last-bmenu-omitted-bookmarks  . ,(bmkx-maybe-unpropertize-bookmark-names
                                                     bmkx-bmenu-omitted-bookmarks))
                  (last-bmenu-title              . ,bmkx-bmenu-title)
                  (last-bmenu-toggle-filenames   . ,bookmark-bmenu-toggle-filenames))))
    `(,@(bmkx-make-record-default 'NO-FILE 'NO-CONTEXT)
      (filename      . ,bmkx-non-file-filename)
      (bookmark-list . ,state)
      (handler       . bmkx-jump-bookmark-list))))

(add-hook 'bmkx-list-mode-hook
          (lambda () (set (make-local-variable 'bookmark-make-record-function)
                          'bmkx-make-bookmark-list-record)))

(defun bmkx-jump-bookmark-list (bookmark)
  "Jump to bookmark-list bookmark BOOKMARK.
Handler function for record returned by
`bmkx-make-bookmark-list-record'.
BOOKMARK is a bookmark name or a bookmark record."
  (let ((state  (bookmark-prop-get bookmark 'bookmark-list)))
    (setq bmkx-sort-comparer               (cdr (assq 'last-sort-comparer            state))
          bmkx-reverse-sort-p              (cdr (assq 'last-reverse-sort-p           state))
          bmkx-reverse-multi-sort-p        (cdr (assq 'last-reverse-multi-sort-p     state))
          bmkx-bmenu-filter-function       (cdr (assq 'last-bmenu-filter-function    state))
          bmkx-bmenu-filter-pattern        (or (cdr (assq 'last-bmenu-filter-pattern state))  "")
          bmkx-bmenu-omitted-bookmarks     (cdr (assq 'last-bmenu-omitted-bookmarks  state))
          bmkx-bmenu-title                 (cdr (assq 'last-bmenu-title              state))
          bookmark-bmenu-toggle-filenames  (cdr (assq 'last-bmenu-toggle-filenames   state))))
  (let ((bookmark-alist  (if bmkx-bmenu-filter-function
                             (funcall bmkx-bmenu-filter-function)
                           bookmark-alist)))
    (setq bmkx-latest-bookmark-alist  bookmark-alist)
    (bmkx-list 'filteredp)
    (when (get-buffer bmkx-bmenu-buffer) (pop-to-buffer bmkx-bmenu-buffer))))

;; Bookmark-file bookmarks.
;;;###autoload (autoload 'bmkx-set-bookmark-file-bookmark "bookmark-x")
(defun bmkx-set-bookmark-file-bookmark (file &optional msg-p) ; Bound to `C-x x y', `C-x x c y'
  "Create a bookmark that loads bookmark-file FILE when \"jumped\" to.
You are prompted for the names of the bookmark file and the bookmark.
When entering the bookmark name you can use completion against
existing names.  This completion is lax, so you can easily edit an
existing name.  See `bmkx-set' for particular keys available
during this input.

Non-interactively, non-nil MSG-P means display a status message."
  (interactive
   (list (let* ((insert-default-directory  t)
                (std-default  (bmkx-default-bookmark-file))
                (default      (if (bmkx-same-file-p bmkx-current-bookmark-file bmkx-last-bookmark-file)
                                  (if (bmkx-same-file-p bmkx-current-bookmark-file std-default)
                                      bookmark-default-file
                                    std-default)
                                bmkx-last-bookmark-file)))
           (bmkx-read-bookmark-file-name "Create bookmark to load bookmark file: "
                                         (or (file-name-directory default)  "~/")
                                         default
                                         'confirm)) ; Non-existing file is OK, but must confirm.
         'MSG))
  (setq file  (expand-file-name file))
  (when (file-directory-p file) (error "`%s' is a directory, not a file" file))
  (unless (file-readable-p file) (error "Unreadable bookmark file `%s'" file))
  (with-current-buffer (let ((enable-local-variables  ())) (find-file-noselect file))
    (goto-char (point-min))
    (condition-case nil                 ; Check whether it's a valid bookmark file.
        (unless (listp (bmkx-alist-from-buffer)) (error ""))
      (error (error "Not a valid bookmark file: `%s'" file))))
  (let ((bookmark-make-record-function  (let ((ff  file))
                                          (lambda () (bmkx-make-bookmark-file-record ff))))
        (bookmark-name                  (bmkx-completing-read-lax "Bookmark-file BOOKMARK name"
                                                                  file nil nil 'bookmark-history)))
    (bmkx-set bookmark-name 99 'INTERACTIVEP))
  (when msg-p (message "Set bookmark-file bookmark")))

(defun bmkx-make-bookmark-file-record (bmk-file)
  "Create and return a bookmark-file bookmark record.
Records the name of the bookmark-file, BMK-FILE.
Adds a handler that tests the prefix arg and loads the bookmark file
either as a replacement for the current bookmark file or as a
supplement to it."
  `(,@(bmkx-make-record-default 'NO-FILE 'NO-CONTEXT nil nil 'NO-REGION)
    (filename      . ,bmk-file)
    (bookmark-file . ,bmk-file)
    (handler       . bmkx-jump-bookmark-file)))

(defun bmkx-jump-bookmark-file (bookmark &optional switchp batchp)
  "Jump to bookmark-file bookmark BOOKMARK, which loads the bookmark file.
Handler function for record returned by
`bmkx-make-bookmark-file-record'.
BOOKMARK is a bookmark name or a bookmark record.
Non-nil optional arg SWITCHP means overwrite current bookmark list.
Non-nil optional arg BATCHP is passed to `bmkx-load'."
  (let ((file        (bookmark-prop-get bookmark 'bookmark-file))
        (overwritep  (and switchp  (y-or-n-p "SWITCH to new bookmark file, instead of just adding it? "))))
    (bmkx-load file overwritep batchp)) ; Treat load interactively, if no BATCHP.
  ;; This `throw' is only for the case where this handler is called from `bmkx--jump-via'.
  ;; It just tells `bmkx--jump-via' to skip the rest of what it does after calling the handler.
  (condition-case nil
      (throw 'bmkx--jump-via 'BOOKMARK-FILE-JUMP)
    (no-catch nil)))

;;;###autoload (autoload 'bmkx-bookmark-file-jump "bookmark-x")
(defun bmkx-bookmark-file-jump (bookmark &optional switchp no-msg) ; `C-x j y'
  "Jump to a bookmark-file bookmark, which means load its bookmark file.
With a prefix argument, switch to the new bookmark file.
Otherwise, load it to supplement the current bookmark list.
BOOKMARK is a bookmark name or a bookmark record."
  (interactive
   (let ((alist  (bmkx-bookmark-file-alist-only)))
     (list (bmkx-read-bookmark-for-type "bookmark-file" alist nil nil 'bmkx-bookmark-file-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-bookmark-file-alist-only))))
  (bmkx-jump-bookmark-file bookmark switchp no-msg))

;;;###autoload (autoload 'bmkx-bookmark-file-load-jump "bookmark-x")
(defun bmkx-bookmark-file-load-jump (bookmark &optional nosavep)
  "Prompt for a bookmark-file BOOKMARK and load that file's bookmarks.
This adds to the current bookmark list.  It does not overwrite it.
By default, this first saves the current bookmark list in the current
bookmark file.  With a prefix argument it does not save first.
BOOKMARK is a bookmark name or a bookmark record."
  (interactive
   (let ((alist  (bmkx-bookmark-file-alist-only)))
     (list (bmkx-read-bookmark-for-type "bookmark-file" alist nil nil 'bmkx-bookmark-file-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-bookmark-file-alist-only))))
  (let ((file  (bookmark-prop-get bookmark 'bookmark-file)))
    (bmkx-load file nil (if nosavep t 'save))
    (bmkx-refresh/rebuild-menu-list)
    (message "Added bookmarks in `%s'" file)))

;;;###autoload (autoload 'bmkx-bookmark-file-switch-jump "bookmark-x")
(defun bmkx-bookmark-file-switch-jump (bookmark &optional nosavep)
  "Prompt for a bookmark-file BOOKMARK and switch to that bookmark file.
Unlike `C-u \\[bmkx-bookmark-file-jump]', you are not prompted for confirmation.
By default, this first saves the current bookmark list in the current
bookmark file.  With a prefix argument it does not save first.
BOOKMARK is a bookmark name or a bookmark record."
  (interactive
   (let ((alist  (bmkx-bookmark-file-alist-only)))
     (list (bmkx-read-bookmark-for-type "bookmark-file" alist nil nil 'bmkx-bookmark-file-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-bookmark-file-alist-only))))
  (let ((file  (bookmark-prop-get bookmark 'bookmark-file)))
    (bmkx-load file t (if nosavep t 'save))
    (bmkx-refresh/rebuild-menu-list)
    (message "Switched to bookmarks in `%s'" file)))


;; Snippet bookmarks
;; Inspired by emacs-devel@gnu.org post from Masatake Yamato [yamato@redhat.com], 2012-01-06.
;;;###autoload (autoload 'bmkx-set-snippet-bookmark "bookmark-x")
(defun bmkx-set-snippet-bookmark (beg end &optional promptp msgp)
                                        ; Bound globally to `C-x x c M-w'.
  "Save the text of the active region as a bookmark.
The bookmark is automatically named with the first line of the region
text.  With a prefix argument you are prompted for the name instead.

Jumping to the bookmark copies the saved text to the `kill-ring', so
you can yank it using `C-y'."
  (interactive "r\nP\np")
  (unless (and mark-active  transient-mark-mode) (error "No active region"))
  (when (equal beg end) (error "Region is empty"))
  (let ((text  (buffer-substring-no-properties beg end)))
    (let ((bookmark-make-record-function  (lambda ()
                                            `(,@(bmkx-make-record-default 'NO-FILE 'NO-CONTEXT)
                                              (text    . ,text)
                                              (handler . bmkx-jump-snippet))))
          (bname                          (and (not promptp)  (car (split-string text "[\n]")))))
      (bmkx-set bname 99 'INTERACTIVEP)
      ;; `bmkx-set does the prompting, providing default names.  
      (when msgp (message "Region text bookmarked%s" (if bname (format " as `%s'" bname) ""))))))

(defun bmkx-jump-snippet (bookmark)
  "Copy the text saved in BOOKMARK to the `kill-ring'.
Handler for snippet bookmarks."
  (kill-new (bookmark-prop-get bookmark 'text))
  (message "Snippet of bookmark `%s' copied to `kill-ring'" (bmkx-bookmark-name-from-record bookmark)))

;;;###autoload (autoload 'bmkx-snippet-to-kill-ring "bookmark-x")
(defun bmkx-snippet-to-kill-ring (bookmark) ; `C-x j M-w'
  "Jump to a snippet bookmark: copy its saved text to the `kill-ring'.
This is a specialization of `bmkx-jump' for snippet bookmarks."
  (interactive
   (let ((alist  (bmkx-snippet-alist-only)))
     (list (bmkx-read-bookmark-for-type "snippet" alist nil nil 'bmkx-snippet-history nil
                                        "Copy snippet to kill ring"))))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-snippet-alist-only))))
  (bmkx-jump-1 bookmark 'ignore))

;; Desktop bookmarks
;;;###autoload (autoload 'bmkx-set-desktop-bookmark "bookmark-x")
(defun bmkx-set-desktop-bookmark (desktop-file &optional nosavep)
                                        ; Bound globally to `C-x x K', `C-x r K', `C-x x c K'
  "Save the desktop as a bookmark.
You are prompted for the desktop-file location and the bookmark name.
The default value for the desktop-file location is the current value
of `desktop-base-file-name'.  As always, you can use `M-n' to retrieve
the default value.

With a prefix arg, set a bookmark to an existing desktop file - do not
save the current desktop.  Do not overwrite the file whose name you
enter, just use it to set the bookmark."
  (interactive
   (progn (unless (condition-case nil (require 'desktop nil t) (error nil))
            (error "You must have library `desktop.el' to use this command"))
          (list (read-file-name
                 (if current-prefix-arg "Use existing desktop file: " "Save desktop in file: ")
                 bmkx-desktop-default-directory
                 (if (boundp 'desktop-base-file-name) desktop-base-file-name desktop-basefilename)
                 current-prefix-arg)
                current-prefix-arg)))
  (unless (or nosavep  (condition-case nil (require 'desktop nil t) (error nil)))
    (error "You must have library `desktop.el' to use this command"))
  (unless (file-name-absolute-p desktop-file)
    (setq desktop-file  (expand-file-name desktop-file bmkx-desktop-default-directory)))
  (set-text-properties 0 (length desktop-file) nil desktop-file)
  (if nosavep
      (unless (bmkx-desktop-file-p desktop-file) (error "Not a desktop file: `%s'" desktop-file))
    (bmkx-desktop-save desktop-file))
  (let ((bookmark-make-record-function  (let ((df  desktop-file))
                                          (lambda () (bmkx-make-desktop-record df))))
        (current-prefix-arg             99)) ; Use all bookmarks for completion, for `bmkx-set'.
    (call-interactively #'bmkx-set)))

(defun bmkx-desktop-save (desktop-file)
  "Save current desktop in DESKTOP-FILE."
  (let ((desktop-basefilename     (file-name-nondirectory desktop-file)) ; Emacs < 22
        (desktop-base-file-name   (file-name-nondirectory desktop-file)) ; Emacs 23+
        (desk-dir                 (file-name-directory desktop-file))
        (desktop-restore-eager    t)    ; Don't bother with lazy restore.
        (desktop-globals-to-save  (bmkx-remove-if (lambda (elt) (memq elt bmkx-desktop-no-save-vars))
                                                  desktop-globals-to-save)))
    (desktop-save desk-dir 'RELEASE 'AUTOSAVE)
    (message "Desktop saved in `%s'" desktop-file)))

(defun bmkx-desktop-save-as-last ()
  "Save desktop to the file that is the value of `bmkx-desktop-current-file'.
Do nothing if any of these are true:

 * `desktop-save-mode' is non-nil
 * `bmkx-desktop-current-file' is nil
 * `bmkx-desktop-current-file' does not seem to be current (a non-bookmark
   desktop was last made current)

You might want to use this on `kill-emacs-hook'."
  (when (and (not desktop-save-mode)  bmkx-desktop-current-file
             (bmkx-same-file-p (desktop-full-file-name) bmkx-desktop-current-file))
    (bmkx-desktop-save bmkx-desktop-current-file)))

;;; (defun bmkx-desktop-file-p (file)
;;;   "Return non-nil if FILE is readable and appears to be a desktop file.
;;; FILE is a file-name string."
;;;   (and (stringp file)
;;;        (file-readable-p file)
;;;        (with-current-buffer (let ((enable-local-variables nil)) (find-file-noselect file))
;;;          (goto-char (point-min))
;;;          (and (zerop (forward-line 2))
;;;               (looking-at-p "^;; Desktop File for Emacs$")))))

;; Similar to `icicle-file-desktop-p' in `icicles-fn.el'.
;; This is better than using `find-file-noselect', which visits the file and leaves its buffer.
(defun bmkx-desktop-file-p (filename)
  "Return non-nil if FILENAME names a desktop file."
  (when (consp filename) (setq filename  (car filename)))
  (and (stringp filename)
       (file-readable-p filename)
       (not (file-directory-p filename))
       (with-temp-buffer
         (insert-file-contents-literally filename nil 0 1000)
         (goto-char (point-min))
         (and (zerop (forward-line 2))
              (looking-at-p "^;; Desktop File for Emacs"))))) ; No $, because maybe eol chars (e.g. ^M).

(defun bmkx-make-desktop-record (desktop-file)
  "Create and return a desktop bookmark record.
DESKTOP-FILE is the absolute file name of the desktop file to use."
  `(,@(bmkx-make-record-default 'NO-FILE 'NO-CONTEXT nil nil 'NO-REGION)
    (filename     . ,bmkx-non-file-filename)
    (desktop-file . ,desktop-file)
    (handler      . bmkx-jump-desktop)))

(defun bmkx-jump-desktop (bookmark)
  "Jump to desktop bookmark BOOKMARK.
Handler function for record returned by `bmkx-make-desktop-record'.
BOOKMARK is a bookmark name or a bookmark record."
  (let ((desktop-file  (bookmark-prop-get bookmark 'desktop-file)))
    (unless (condition-case nil (require 'desktop nil t) (error nil))
      (error "You must have library `desktop.el' to use this command"))
    ;; (unless desktop-file (error "Not a desktop-bookmark: %S" bookmark)) ; Shouldn't happen.
    (bmkx-desktop-change-dir desktop-file)
    (unless (bmkx-desktop-read desktop-file) (error "Could not load desktop file"))))

;; Derived from code in `desktop-change-dir'.
;;;###autoload (autoload 'bmkx-desktop-change-dir "bookmark-x")
(defun bmkx-desktop-change-dir (desktop-file)
  "Change to desktop saved in DESKTOP-FILE.
Kill the desktop as specified by variables `desktop-save-mode' and
 `desktop-save' (starting with Emacs 22).
Clear the desktop and load DESKTOP-FILE."
  (interactive
   (progn (unless (condition-case nil (require 'desktop nil t) (error nil))
            (error "You must have library `desktop.el' to use this command"))
          (list (let ()
                  (read-file-name "Change to desktop file: " bmkx-desktop-default-directory)))))
  (unless (condition-case nil (require 'desktop nil t) (error nil))
    (error "You must have library `desktop.el' to use this command"))
  (unless (file-name-absolute-p desktop-file)
    (setq desktop-file  (expand-file-name desktop-file bmkx-desktop-default-directory)))
  (set-text-properties 0 (length desktop-file) nil desktop-file)
  (let ((desktop-basefilename     (file-name-nondirectory desktop-file)) ; Emacs < 22
        (desktop-base-file-name   (file-name-nondirectory desktop-file)) ; Emacs 23+
        (desktop-dir              (file-name-directory desktop-file))
        (desktop-restore-eager    t)    ; Don't bother with lazy restore.
        (desktop-globals-to-save  (bmkx-remove-if (lambda (elt) (memq elt bmkx-desktop-no-save-vars))
                                                  desktop-globals-to-save)))
    (bmkx-desktop-kill)
    (desktop-clear)
    (desktop-read desktop-dir)))

;; Derived from code in `desktop-kill'.
(defun bmkx-desktop-kill ()
  "If `desktop-save-mode' is non-nil, do what `desktop-save' says to do.
In any case, release the lock on the desktop file.
This function does nothing in Emacs versions prior to Emacs 22."
  ;; We assume here: `desktop.el' has been loaded and `desktop-dirname' is defined.
  (when (and (boundp 'desktop-save-mode) ; Not defined in Emacs 20-21.
             desktop-save-mode
             (let ((exists  (file-exists-p (desktop-full-file-name))))
               (or (eq desktop-save t)
                   (and exists  (memq desktop-save '(ask-if-new if-exists)))
                   (and (or (memq desktop-save '(ask ask-if-new))
                            (and exists  (eq desktop-save 'ask-if-exists)))
                        (y-or-n-p "Save current desktop first? ")))))
    (condition-case err
        (desktop-save desktop-dirname 'RELEASE 'AUTOSAVE)
      (file-error (unless (yes-or-no-p "Error while saving the desktop.  IGNORE? ")
                    (signal (car err) (cdr err))))))
  ;; Just release lock, regardless of whether this Emacs process is the owner.
  (desktop-release-lock))

;; Derived from code in `desktop-read'.
;;;###autoload (autoload 'bmkx-desktop-read "bookmark-x")
(defun bmkx-desktop-read (file)
  "Load desktop-file FILE, then run `desktop-after-read-hook'.
Return t if FILE was loaded, nil otherwise."
  (unless (file-name-absolute-p file) ; Should never happen.
    (setq file  (expand-file-name file bmkx-desktop-default-directory)))
  (when (file-directory-p file) (error "`%s' is a directory, not a file" file))
  (setq desktop-dirname  (file-name-directory file))
  (if (not (file-readable-p file))
      nil                               ; Return nil, meaning not loaded.
    (let ((desktop-restore-eager      t) ; Don't bother with lazy restore.
          (desktop-first-buffer       nil)
          (desktop-buffer-ok-count    0)
          (desktop-buffer-fail-count  0)
          (desktop-save               nil)) ; Prevent desktop saving during eval of desktop buffer.
      (desktop-lazy-abort)
      (load file t t t)
      (when (boundp 'desktop-file-modtime) ; Emacs 22+
        (setq desktop-file-modtime  (nth 5 (file-attributes file))))
      ;; `desktop-create-buffer' puts buffers at end of the buffer list.
      ;; We want buffers existing prior to evaluating the desktop (and not reused) to be placed
      ;; at the end of the buffer list, so we move them here.
      (mapc 'bury-buffer (nreverse (cdr (memq desktop-first-buffer (nreverse (buffer-list))))))
      (bmkx--pop-to-buffer-same-window (car (buffer-list)))
      (run-hooks 'desktop-delay-hook)
      (setq desktop-delay-hook  ())
      (run-hooks 'desktop-after-read-hook)
      (when (boundp 'desktop-buffer-ok-count) ; Emacs 22+
        (message "Desktop: %d buffer%s restored%s%s." desktop-buffer-ok-count
                 (if (= 1 desktop-buffer-ok-count) "" "s")
                 (if (< 0 desktop-buffer-fail-count)
                     (format ", %d failed to restore" desktop-buffer-fail-count)
                   "")
                 (if (and (boundp 'desktop-buffer-args-list)  desktop-buffer-args-list)
                     (format ", %d to be restored lazily" (length desktop-buffer-args-list))
                   "")))
      t)))                              ; Return t, meaning successfully loaded.

;;;###autoload (autoload 'bmkx-desktop-delete "bookmark-x")
(defun bmkx-desktop-delete (bookmark)
  "Delete desktop bookmark BOOKMARK, and delete its desktop file.
Release the lock file in that desktop's directory.
\(This means that if you currently have locked a different desktop
in the same directory, then you will need to relock it.)
BOOKMARK is a bookmark name or a bookmark record."
  (interactive
   (let ((alist  (bmkx-desktop-alist-only)))
     (list (bmkx-read-bookmark-for-type "desktop" alist nil nil 'bmkx-desktop-history "Delete "))))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-desktop-alist-only))))
  (let ((desktop-file  (bookmark-prop-get bookmark 'desktop-file)))
    (unless desktop-file (error "Not a desktop-bookmark: `%s'" bookmark))
    ;; Release the desktop lock file in the same directory as DESKTOP-FILE.
    ;; This will NOT be the right thing to do if a desktop file different from DESKTOP-FILE
    ;; is currently locked in the same directory.
    (let ((desktop-dirname  (file-name-directory desktop-file)))
      (desktop-release-lock))
    (when (file-exists-p desktop-file) (delete-file desktop-file)))
  (bmkx-delete bookmark))

;; Variable-list bookmarks

(defun bmkx-read-any-variable (prompt &optional default)
  "Read the name of any bound variable.  PROMPT is the prompt string.
Optional DEFAULT is a symbol used as the default value."
  (intern (completing-read prompt obarray #'boundp t nil nil
                           (and default  (symbol-name default)))))

(defun bmkx-readable-marker (object)
  "Return a portable representation of marker OBJECT.
Returns a cons (BUFFER-NAME . POSITION).  The format matches the
\"readable marker\" representation that `zones.el' reads back, so a
bookmark saved through `bmkx-set-izones-bookmark' is interop-compatible
with `zones.el'.  Non-markers are returned unchanged."
  (if (markerp object)
      (cons (or (and (marker-buffer object)  (buffer-name (marker-buffer object)))
                "*orphan*")
            (marker-position object))
    object))

(when (boundp 'zz-izones-var)           ; In `zones.el'.
  (defun bmkx-set-izones-bookmark (&optional variable msgp)
    "Save a ring of buffer zones as a bookmark.
The zones can use markers or readable-marker objects for any
buffers.  You need library `zones.el' to use the bookmark created.

By default, the zones are those defined by the variable that is the
current value of `zz-izones-var', which defaults to `zz-izones'.  With
a prefix arg you are prompted for a different variable to use.

Non-interactively, VARIABLE is the restrictions variable to use."
    (interactive (let ((var  (or (and current-prefix-arg  (bmkx-read-any-variable "Variable: " zz-izones-var))
                                 zz-izones-var)))
                   (list var t)))
    (unless variable (setq variable  zz-izones-var))
    (let ((bookmark-make-record-function
           (lambda ()
             (bmkx-make-variable-list-record
              `((,variable              ; Format: (NUM BEGM ENDM), BEGM and ENDM are readable-marker objects.
                 . ,(mapcar (lambda (xx)
                              (let ((id     (nth 0 xx))
                                    (beg    (nth 1 xx))
                                    (end    (nth 2 xx))
                                    (extra  (nthcdr 3 xx)))
                                `(,id ,(bmkx-readable-marker beg) ,(bmkx-readable-marker end) ,@extra)))
                            (symbol-value variable))))))))
      (call-interactively #'bmkx-set)
      (and msgp  (not (featurep 'zones))  (message "Bookmark created, but you need `zones.el' to use it")))))

;;;###autoload (autoload 'bmkx-wrap-bookmark-with-last-kbd-macro "bookmark-x")
(defun bmkx-wrap-bookmark-with-last-kbd-macro (sequence bookmark &optional arg msgp)
                                        ; Bound globally to `C-x x C-k'.
  "Return a SEQUENCE bookmark that invokes BOOKMARK plus `last-kbd-macro'.
If bookmark SEQUENCE does not yet exist, create it.  Else, update it.
You are prompted for the SEQUENCE and BOOKMARK names.

BOOKMARK can be any kind of bookmark.  A special case is when it is a
sequence bookmark:

 * If BOOKMARK is the same as SEQUENCE and is an existing sequence
   bookmark then it is updated only by appending the keyboard macro to
   the sequence.

 * If BOOKMARK is a sequence bookmark different from SEQUENCE then
   SEQUENCE is updated to invoke the sequence in BOOKMARK plus
   `last-kbd-macro' either before or after the other bookmarks of
   SEQUENCE, according to the prefix arg, which is passed to
   `bmkx-set-sequence-bookmark'."
  (interactive (list (bmkx-completing-read-lax "Sequence bookmark" (bmkx-new-bookmark-default-names))
                     (bmkx-completing-read-lax "Bookmark" (bmkx-new-bookmark-default-names))
                     current-prefix-arg
                     'MSGP))
  (unless last-kbd-macro (error "No keyboard macro defined"))
  (let ((kbd-macro-vec  (read-kbd-macro (format-kbd-macro last-kbd-macro) 'VECTOR)))
    (bmkx-set-sequence-bookmark sequence (if (equal bookmark sequence)
                                             (list kbd-macro-vec)
                                           (list bookmark kbd-macro-vec))
                                arg msgp)))

;; Not used yet.
(defun bmkx-pop-to-readable-marker (readable-marker)
  "Go to the marker recorded as persistent READABLE-MARKER.
The form of the input is (marker MARKER-BUFFER MARKER-POSITION."
  (pop-to-buffer (cadr readable-marker))
  (goto-char (cadr (cdr readable-marker))))

;;;###autoload (autoload 'bmkx-set-sequence-bookmark "bookmark-x")
(defun bmkx-set-sequence-bookmark (seqname bookmark-names &optional arg msgp)
                                        ; Bound globally to `C-x x c s'.
  "Create or update a sequence bookmark named SEQNAME from BOOKMARK-NAMES.
If a sequence bookmark named SEQNAME does not exist then create one.
Else act on the existing bookmarks in bookmark SEQNAME as follows:

 * no prefix arg:    Append BOOKMARK-NAMES to those present.
 * prefix arg < 0:   Replace those present with BOOKMARK-NAMES.
 * other prefix arg: Prepend BOOKMARK-NAMES to those present.

You are prompted for SEQNAME and each of the BOOKMARK-NAMES.

When entering each item of BOOKMARK-NAMES you can enter an existing or
future bookmark name, or you can enter the name of a function or a
named keyboard macro (provided what you type does not match a bookmark
name).  If a function or keyboard macro, then a function bookmark is
created for it and that bookmark is included in the sequence.

When the sequence bookmark is invoked (\"jumped to\"), its bookmarks
are invoked in order.  In particular, any given bookmark is invoked
once for each of its occurrences in the sequence.

From Lisp code:

BOOKMARK-NAMES is generally a list of bookmarks or bookmark names
 \(strings).

 Each item in BOOKMARK-NAMES can alternatively be one of the
 following, in which case a function bookmark is created for it and is
 used in the sequence.

  * a keyboard macro as a vector
  * a function, which includes a lambda form or a symbol whose
    function value is a function or a keyboard macro.

 If an item in BOOKMARK-NAMES is a sequence bookmark then its
 bookmarks are used as if they were items of BOOKMARK-NAMES.

MSGP non-nil means possibly interact with the user, showing messages."
  (interactive (list
                (if (< (prefix-numeric-value current-prefix-arg) 0)
                    (bmkx-completing-read "Replace existing sequence bookmark"
                                              nil
                                              (bmkx-sequence-alist-only)
                                              nil
                                              nil
                                              'USE-NIL-ALIST-P)
                  (bmkx-completing-read-lax "Create or update sequence bookmark"
                                            (bmkx-new-bookmark-default-names)
                                            (bmkx-sequence-alist-only)))
                (bmkx-completing-read-bookmarks nil nil nil 'lax)
                current-prefix-arg
                'MSGP))
  (let* ((seq        (bmkx-get-bookmark-in-alist seqname 'NOERROR))
         (exists     (and seq  (bmkx-sequence-bookmark-p seq)))
         (replacing  t)
         (bnames     ())
         fun)
    (dolist (bname  bookmark-names)
      (cond ((or (functionp (setq fun bname)) ; Function from Lisp.
                 (vectorp fun)                ; Keyboard macro.
                 (functionp (setq fun  (condition-case nil ; Function name from user
                                           (bmkx-read-from-whole-string bname)
                                         (error nil)))))
             (let ((fun-bmk-name
                    (cond ((symbolp fun) (symbol-name fun)) ; Named function.  Use its name.
                          ((vectorp fun) (format-kbd-macro fun)) ; Keyboard macro.  Use human-readable strg
                          ;; Lambda form.  Use as much as possible, but uniquify (no such symbol name).
                          (t (let ((ii     1)
                                   (len    (length bname))
                                   (trial  (make-string (1+ bmkx-bookmark-name-length-max) 88)))
                               (while (and (< ii len)  (> (length trial) bmkx-bookmark-name-length-max))
                                 (setq trial  (make-temp-name (substring bname 0 (- ii)))))
                               (while (intern-soft
                                       (setq trial  (make-temp-name (substring bname 0 (- ii))))))
                               trial)))))
               (push (bmkx-bookmark-name-from-record (bmkx-make-function-bookmark fun-bmk-name fun))
                        bnames)))
            ((bmkx-sequence-bookmark-p bname) ; Sequence bookmark.
             (setq bnames (append (reverse (bookmark-prop-get bname 'sequence)) bnames)))
            ((stringp bname) (push bname bnames)) ; Bookmark name.
            ((bmkx-get-bookmark bname 'NOERROR)      ; Full bookmark.
             (push (bmkx-bookmark-name-from-record bname) bnames))
            (t (error "Bad BOOKMARK-NAMES arg to `bmkx-set-sequence-bookmark': `%S'"
                      bookmark-names)))) ; Punt.
    (setq bnames  (nreverse bnames))
    (if (not exists)
        (when msgp (message "Creating sequence bookmark..."))
      (if (< (prefix-numeric-value arg) 0)
          (when msgp (message "REPLACING existing sequence bookmark...") (sit-for 0.5))
        (when msgp (message "%sing to sequence bookmark..." (if arg "Prepend" "Append")) (sit-for 0.5))
        (setq replacing  nil
              bnames     (if arg
                             (nconc bnames (bookmark-prop-get seq 'sequence))
                           (nconc (bookmark-prop-get seq 'sequence) bnames)))))
    (let ((bookmark-make-record-function `(lambda () (bmkx-make-sequence-record ',bnames))))
      (bmkx-set seqname))
    (when msgp (message "Sequence `%s' %s" seqname (if exists
                                                       (if replacing "replaced" "updated")
                                                     "created")))))

(defun bmkx-make-sequence-record (bookmark-names)
  "Create and return a sequence bookmark record.
BOOKMARK-NAMES is a list of names of the bookmarks to be invoked in
sequence."
  (let ((record  `(,@(bmkx-make-record-default 'NO-FILE 'NO-CONTEXT 0 nil 'NO-REGION)
                   (sequence . ,bookmark-names)
                   (handler  . bmkx-jump-sequence))))
    record))

(when (require 'kmacro nil t)           ; Emacs 22+

  (defun bmkx-set-kmacro-bookmark (bookmark-name keyboard-macro &optional msg-p)
    "Create a function bookmark named BOOKMARK-NAME from KEYBOARD-MACRO.
Prompt for BOOKMARK-NAME and the name of the keyboard macro to use.
With a prefix arg, use `last-kbd-macro' as the keyboard macro."
    (interactive
     (let ((bname  (bmkx-completing-read-lax "Bookmark"))
           (kmac   (if current-prefix-arg
                       last-kbd-macro
                     (symbol-function (intern (completing-read "Keyboard macro name: "
                                                               obarray
                                                               (lambda (elt)
                                                                 (and (fboundp elt)
                                                                      (or (stringp (symbol-function elt))
                                                                          (vectorp (symbol-function elt))
                                                                          (get elt 'kmacro))))
                                                               t))))))
       (list bname kmac 'MSG)))
    (let* ((bmk     (bmkx-get-bookmark-in-alist bookmark-name 'NOERROR))
           (exists  (and bmk  (bmkx-function-bookmark-p bmk))))
      (bmkx-make-function-bookmark bookmark-name keyboard-macro msg-p)
      (when msg-p
        (message "Function bookmark `%s' %s" bookmark-name (if exists "replaced" "created")))))

  (defun bmkx-set-kmacro-list-bookmark (bookmark-name)
    "Save all current keyboard macros as a kmacro-list bookmark."
    (interactive (list (bmkx-completing-read-lax "Bookmark")))
    (let ((bookmark-make-record-function  (lambda ()
                                            (bmkx-make-kmacro-list-record
                                             (cons (kmacro-ring-head) kmacro-ring)))))
      (bmkx-set bookmark-name)))

  (defun bmkx-make-kmacro-list-record (kmacros)
    "Create and return a kmacro-list bookmark record.
KMACROS is the list of kmacros to save.  It has the same form as
`kmacro-ring'.

Each entry in KMACROS thus has the form (MACRO COUNTER FORMAT)."
    (let ((record  `(,@(bmkx-make-record-default 'NO-FILE 'NO-CONTEXT nil nil 'NO-REGION)
                     (kmacros      . ,kmacros)
                     (handler      . bmkx-jump-kmacro-list))))
      record))

  )

;;;###autoload (autoload 'bmkx-set-variable-list-bookmark "bookmark-x")
(defun bmkx-set-variable-list-bookmark (variables)
  "Save a list of variables as a bookmark.
Interactively, read the variables to save, using
`bmkx-read-variables-completing'."
  (interactive (list (bmkx-read-variables-completing)))
  (let ((bookmark-make-record-function  (let ((vars  variables))
                                          (lambda () (bmkx-make-variable-list-record vars)))))
    (call-interactively #'bmkx-set)))

;; Not used in the Bookmark-X code.  Available for users to create varlist bookmark non-interactively.
(defun bmkx-create-variable-list-bookmark (bookmark-name vars vals &optional buffer-name)
  "Create a variable-list bookmark named BOOKMARK-NAME from VARS and VALS.
VARS and VALS are corresponding lists of variables and their values.

Optional arg BUFFER-NAME is the buffer name to use for the bookmark (a
string).  This is useful if some of the variables are buffer-local.
If BUFFER-NAME is nil, the current buffer name is recorded."
  (eval `(cl-multiple-value-bind ,vars ',vals
           (let ((bookmark-make-record-function  (let ((vs   ',vars)
                                                               (buf  ,buffer-name))
                                                   (lambda () (bmkx-make-variable-list-record vs buf)))))
             (bmkx-set ,bookmark-name)))))

(defun bmkx-read-variables-completing (&optional option)
  "Read variable names with completion, and return them as a list of symbols.
Reads names one by one, until you hit `RET' twice consecutively.
Non-nil argument OPTION means read only user option names."
  (bmkx-maybe-load-default-file)
  (let ((var   (bmkx-read-variable "Variable (RET for each, empty input to finish): " option))
        (vars  ()))
    (while (not (string= "" var))
      (unless (member var vars) (setq vars  (cons var vars)))
      (setq var  (bmkx-read-variable "Variable: " option)))
    (nreverse vars)))

(defun bmkx-read-variable (prompt &optional option default-value)
  "Read name of a variable and return it as a symbol.
Prompt with string PROMPT.
With non-nil OPTION, read the name of a user option.
The default value is DEFAULT-VALUE if non-nil, or the nearest symbol
to the cursor if it is a variable."
  (setq option  (if option 'user-variable-p 'boundp))
  (let ((symb                          (bmkx-symbol-nearest-point))
        (enable-recursive-minibuffers  t))
    (when (and default-value  (symbolp default-value))
      (setq default-value  (symbol-name default-value)))
    (intern (completing-read prompt obarray option t nil 'minibuffer-history
                             (or default-value  (and (funcall option symb)  (symbol-name symb)))
                             t))))

(defun bmkx-make-variable-list-record (variables &optional buffer-name)
  "Create and return a variable-list bookmark record.
VARIABLES is the list of variables to save.
Each entry in VARIABLES is either a variable (a symbol) or a cons
 whose car is a variable and whose cdr is the variable's value.

Optional arg BUFFER-NAME is the buffer to use for the bookmark.  This
is useful if some of the variables are buffer-local.  If BUFFER-NAME
is nil, the current buffer is used."
  (let ((record  `(,@(bmkx-make-record-default 'NO-FILE 'NO-CONTEXT nil nil 'NO-REGION)
                   (filename     . ,bmkx-non-file-filename)
                   (variables    . ,(or (bmkx-printable-vars+vals variables)
                                        (error "No variables to bookmark")))
                   (handler      . bmkx-jump-variable-list))))
    (when buffer-name  (let ((bname  (assq 'buffer-name record)))  (setcdr bname buffer-name)))
    record))

(defun bmkx-printable-vars+vals (variables)
  "Return an alist of printable VARIABLES paired with their values.
Display a message for any variables that are not printable.
VARIABLES is the list of variables.  Each entry in VARIABLES is either
 a variable (a symbol) or a cons whose car is a variable and whose cdr
 is the variable's value."
  (let ((vars+vals     ())
        (unprintables  ()))
    (dolist (var  variables)
      (let ((val  (if (consp var) (cdr var) (symbol-value var))))
        (if (bmkx-readable-p val)
            (let ((v+vl  (if (consp var) var (cons var val))))
              (unless (member v+vl vars+vals) (setq vars+vals  (cons v+vl vars+vals))))
          (unless (memq var unprintables) (setq unprintables  (cons var unprintables))))))
    (when unprintables (message "Unsavable (unreadable) vars: %S" unprintables)  (sit-for 3))
    vars+vals))

;; Similar to `savehist-printable' in `savehist.el', but with `print-circle' etc. bindings.
(defun bmkx-readable-p (value)
  "Return non-nil if VALUE is Lisp-readable if printed using `prin1'."
  (cond ((numberp value))
        ((symbolp value))
        ((and (stringp value)           ; String with no text properties.
              ; Emacs 22+.
                  (equal-including-properties value (substring-no-properties value))))
        (t (with-temp-buffer
             (condition-case nil
                 (let ((cl-print-readably  t) ; In `cl-print.el'.
                       (print-level        nil))
                   (prin1 value (current-buffer)) ; Print value into a buffer and try to read back.
                   (read (point-min-marker))
                   t)
               (error nil))))))         ; Could not print and read back.

(when (require 'kmacro nil t)           ; Emacs 22

  (defun bmkx-jump-kmacro-list (bookmark)
    "Jump to kmacro-list bookmark BOOKMARK, restoring the keyboard macros.
Handler function for record returned by
`bmkx-make-kmacro-list-record'.
BOOKMARK is a bookmark name or a bookmark record."
    (let ((buf       (bmkx-get-buffer-name bookmark))
          (kbd-macs  (bookmark-prop-get bookmark 'kmacros)))
      (unless (and buf  (get-buffer buf))
        (message "Bookmarked for non-existent buffer `%s', so using current buffer" buf) (sit-for 3)
        (setq buf (current-buffer)))
      (with-current-buffer buf
        (let ((kmacs  kbd-macs))
          (when last-kbd-macro
            (kmacro-push-ring (list last-kbd-macro kmacro-counter kmacro-counter-format-start)))
          (kmacro-split-ring-element (pop kmacs))
          (dolist (kmac  kmacs) (kmacro-push-ring kmac))))
      (message "Keyboard macros restored in buffer `%s': %S" buf (mapcar #'car kbd-macs))
      (sit-for 3)))

  )


;; Differences from built-in `info.el':
;;
;; Respect `Info-bookmark-use-only-node-not-file-flag'.
;;
;; This code and the definition of `Info-bookmark-use-only-node-not-file-flag' are also in `info+.el',
;; so that their feature is available if you use either `Info+' or `Bookmark-X'.
;;
;; Note: This function name doesn't respect the naming convention for bookmark handler functions.
;;       This name gives the impression that this is a jump command.
;;
;;;###autoload (autoload 'Info-bmkx-jump "bookmark-x")
(defun Info-bmkx-jump (bookmark)
  "Handler function for record returned by `Info-bmkx-make-record'.
BOOKMARK is a bookmark name or a bookmark record.

If `Info-bookmark-use-only-node-not-file-flag' is nil, and the
recorded Info file is readable, then use it.  If not, then go to the
recorded Info node in the manual for the current Emacs version."
  (require 'info) ; Needed only for Emacs 20-22: not autoloaded for `Info-find-node'.
  (let* ((absfile    (bookmark-prop-get bookmark 'filename))
         (file       (if (or Info-bookmark-use-only-node-not-file-flag  (not (file-readable-p absfile)))
                         (file-name-nondirectory absfile)
                       absfile))
         (info-node  (bookmark-prop-get bookmark 'info-node))
         (buf        (save-window-excursion ; Vanilla FIXME: doesn't work with frames!
                       (Info-find-node file info-node) (current-buffer))))
    (bmkx-default-handler `("" (buffer . ,buf) . ,(bookmark-get-bookmark-record bookmark)))))

(defun bmkx-jump-variable-list (bookmark)
  "Jump to variable-list bookmark BOOKMARK, restoring the recorded values.
Handler function for record returned by
`bmkx-make-variable-list-record'.
BOOKMARK is a bookmark name or a bookmark record."
  (let ((buf        (bmkx-get-buffer-name bookmark))
        (vars+vals  (bookmark-prop-get bookmark 'variables)))
    (unless (get-buffer buf)
      (message "Bookmarked for non-existent buffer `%s', so using current buffer" buf) (sit-for 3)
      (setq buf (current-buffer)))
    (with-current-buffer buf
      (dolist (var+val  vars+vals)
        (set (car var+val)  (cdr var+val))))
    (message "Variables restored in buffer `%s': %S" buf (mapcar #'car vars+vals))
    (sit-for 3)))

;; URL browse support
(defun bmkx-make-url-browse-record (url)
  "Create and return a url bookmark for `browse-url' to visit URL.
The handler is `bmkx-jump-url-browse'."
  (require 'browse-url)
  (let ((url-0  (copy-sequence url)))
    (set-text-properties 0 (length url) () url-0)
    `((filename . ,bmkx-non-file-filename)
      (location . ,url-0)
      (handler  . bmkx-jump-url-browse))))

(defun bmkx-jump-url-browse (bookmark)
  "Handler function for record returned by `bmkx-make-url-browse-record'.
BOOKMARK is a bookmark name or a bookmark record."
  (require 'browse-url)
  (let ((url  (bookmark-prop-get bookmark 'location)))
    (browse-url url)))


;; EWW support.

;; This is set by `bmkx-eww-rename-buffer' and used in `bmkx-jump-eww' for local var `after-render-function'.
(defvar-local bmkx-eww-new-buf-name nil
  "If non-nil, the name of the EWW buffer to jump to.")

;; This is set by `bmkx-jump-eww' and used in `bmkx-eww-rename-buffer'.
(defvar-local bmkx-eww-jumping-p nil
  "Non-nil only if we are currently jumping to an EWW bookmark.")

  (defun bmkx-eww-title ()
    "Return the web-page title of the current `eww-mode' buffer."
    (plist-get eww-data :title))

  (defun bmkx-eww-url ()
    "Return the URL of the current `eww-mode' buffer."
    (eww-current-url))

  (defun bmkx-make-eww-record ()
    "Make a record for an EWW buffer."
    `(,(bmkx-eww-title)
      (buffer-name . ,(bmkx-eww-new-buffer-name))
      ,@(bmkx-make-record-default 'NO-FILE)
      (location . ,(bmkx-eww-url))
      (handler . bmkx-jump-eww)))

  (add-hook 'eww-mode-hook (lambda () (set (make-local-variable 'bookmark-make-record-function)
                                      'bmkx-make-eww-record)))

  (defun bmkx-eww-new-buffer-name ()
    "Return a new buffer name for the current `eww-mode' buffer.
The name format is determined by option `bmkx-eww-buffer-renaming'."
    (concat "*eww*" (and bmkx-eww-buffer-renaming
                         (concat "-"
                                 (bmkx-eww-title)
                                 (let ((url  (bmkx-eww-url)))
                                   (and (eq 'url bmkx-eww-buffer-renaming)
                                        (concat " " (if (>= (length url) 20) (substring url -20) url))))))))

  (defun bmkx-jump-eww (bookmark)
    "Handler function for record returned by `bmkx-make-eww-record'.
BOOKMARK is a bookmark name or a bookmark record."
    (require 'eww)
    (let ((buffer                 (or (and (not bmkx-eww-generate-buffer-flag)
                                           (get-buffer (bmkx-get-buffer-name bookmark)))
                                      (generate-new-buffer "*eww*"))) ; Might get renamed later.
          ;; VAR `bmkx-eww-new-buf-name' is free here.  It is bound in `bmkx-eww-rename-buffer'.
          (after-render-function  `(lambda ()
                                     (when (and bmkx-eww-buffer-renaming  bmkx-eww-new-buf-name)
                                       (kill-buffer)
                                       (set-buffer bmkx-eww-new-buf-name))
                                     (bmkx-default-handler
                                      `("" (buffer . ,(current-buffer))
                                        . ,(bmkx-bookmark-data-from-record ,(car bookmark))))
                                     (dolist (var  '(bmkx-eww-jumping-p eww-after-render-hook))
                                       (kill-local-variable var)))))
      (setq bmkx-eww-jumping-p  t)
      (with-current-buffer buffer
        (eww-mode)
        (save-window-excursion ; Save window because it calls `pop-to-buffer-same-window'.
          (eww (bmkx-location bookmark)))
        (add-hook 'eww-after-render-hook after-render-function 'APPEND 'LOCAL))))

  (defun bmkx-eww-rename-buffer (&rest _ignored)
    "Rename current buffer according to option `bmkx-eww-buffer-renaming'.
When jumping to EWW bookmark with nil `bmkx-eww-generate-buffer-flag',
if the buffer has already been visited, set `bmkx-eww-new-buf-name' so
that `bmkx-jump-eww' will use the already visited buffer."
    (when bmkx-eww-buffer-renaming
      (let ((new-bname  (bmkx-eww-new-buffer-name)))
        (condition-case nil
            (rename-buffer new-bname)
          ;; VAR `bmkx-eww-jumping-p' is free here.  It is set in `bmkx-jump-eww'.
          (error (if (and bmkx-eww-jumping-p  (not bmkx-eww-generate-buffer-flag))
                     (setq bmkx-eww-new-buf-name  new-bname) ; For `after-render-function' in `bmkx-jump-eww'.
                   (rename-buffer (generate-new-buffer-name new-bname))))))))

  ;; The EWW buffer is renamed on each visit, if `bmkx-eww-buffer-renaming' is non-nil.
  (eval-after-load "eww"
    '(progn ; Emacs 25+
       (add-hook   'eww-after-render-hook      'bmkx-eww-rename-buffer)
       (advice-add 'eww-restore-history :after 'bmkx-eww-rename-buffer)))


  ;; Eval this so that even if the library is byte-compiled with Emacs 20,
  ;; loading it into Emacs 22+ will define variable `bmkx-eww-auto-bookmark-mode'.
  (eval '(define-minor-mode bmkx-eww-auto-bookmark-mode
           "Toggle automatically setting a bookmark when you visit a URL with EWW.
The bookmark name is the title of the web page.

If option `bmkx-eww-auto-type' is `create-or-update' then such a
bookmark is created for the URL if none exists.  If the option value
is `update-only' then no new bookmark is created automatically, but an
existing bookmark is updated.  (Updating a bookmark increments the
recorded number of visits.)  You can toggle the option using
`\\[bmkx-toggle-eww-auto-type]'."
           :init-value nil :global t :group 'bookmark-plus :require 'bookmark-x
           :lighter bmkx-automatic-bookmark-mode-lighter
           :link `(url-link :tag "Send Bug Report"
                            ,(concat "mailto:" "drew.adams" "@" "oracle" ".com?subject=\
Bookmark bug: \
&body=Describe bug here, starting with `emacs -Q'.  \
Don't forget to mention your Emacs and library versions."))
           :link '(url-link :tag "Download" "https://www.emacswiki.org/emacs/download/bookmark%2b.el")
           :link '(url-link :tag "Description" "https://www.emacswiki.org/emacs/BookmarkPlus")
           :link '(emacs-commentary-link :tag "Commentary" "bookmark-x")
           (cond (bmkx-eww-auto-bookmark-mode
                  (add-hook   'eww-after-render-hook      'bmkx-set-eww-bookmark-here)
                  (advice-add 'eww-restore-history :after 'bmkx-set-eww-bookmark-here))
                 (t
                  (remove-hook   'eww-after-render-hook   'bmkx-set-eww-bookmark-here)
                  (advice-remove 'eww-restore-history     'bmkx-set-eww-bookmark-here)))
           (when (called-interactively-p 'interactive)
             (message "Automatic EWW bookmarking is now %s"
                      (if bmkx-eww-auto-bookmark-mode
                          (if (eq bmkx-eww-auto-type 'update-only)
                              "ON, updating only"
                            "ON, creating or UPDATING")
                        "OFF")))))

  (defun bmkx-set-eww-bookmark-here (&optional nomsg)
    "Set an EWW bookmark for the URL of the current EWW buffer.
The current buffer is assumed to be in `eww-mode' and visiting a URL."
    (interactive)
    (let* ((bname   (bmkx-eww-title))
           ;; (url     (bmkx-eww-url)) ; NOT USED (?)
           (bmk     (bmkx-get-bookmark bname 'NO-ERROR))
           (visits  (and bmk  (bookmark-prop-get bmk 'visits))))
      (when bname
        (cond ((and (not visits)  (eq bmkx-eww-auto-type 'create-or-update))
               (bmkx-set bname)
               (unless nomsg (message "Created EWW bookmark `%s'" bname)))
              (visits
               (bmkx-record-visit bname 'BATCHP)
               (bmkx-refresh/rebuild-menu-list bname nil)
               (bmkx-maybe-save-bookmarks)
               (unless nomsg (message "Updated EWW bookmark `%s'" bname)))))))

  (defun bmkx-toggle-eww-auto-type (&optional msgp)
    "Toggle the value of option `bmkx-eww-auto-type'."
    (interactive "p")
    (setq bmkx-eww-auto-type  (if (eq bmkx-eww-auto-type 'create-or-update) 'update-only 'create-or-update))
    (when msgp (message "`bmkx-eww-auto-bookmark-mode' now %s"
                        (if (eq bmkx-eww-auto-type 'create-or-update)
                            "CREATES, as well as updates, EWW bookmarks"
                          "only UPDATES EXISTING EWW bookmarks"))))


  ;; You can use this to convert existing EWW bookmarks to Bookmark-X bookmarks.
  ;;
  (defun bmkx-convert-eww-bookmarks (eww-file bmk-file &optional msgp)
    "Add bookmarks from EWW-FILE to BMK-FILE.
EWW-FILE is a file of \"bookmarks\" created by EWW, which are not
compatible with Emacs bookmarks.  EWW-FILE is not modified.

BMK-FILE is a Bookmark-X bookmarks file, which is an ordinary Emacs
bookmarks file (possibly with Bookmark-X-specific bookmarks).

If BMK-FILE exists then it is updated to include the converted
bookmarks.  If it does not exist then it is created."
    (interactive
     (let* ((std-default  (bmkx-default-bookmark-file))
            (default      (if (bmkx-same-file-p bmkx-current-bookmark-file bmkx-last-bookmark-file)
                              (if (bmkx-same-file-p bmkx-current-bookmark-file std-default)
                                  bookmark-default-file
                                std-default)
                            bmkx-last-bookmark-file)))
       (list (bmkx-read-bookmark-file-name "EWW bookmark file: "
                                           nil
                                           (expand-file-name "eww-bookmarks" user-emacs-directory)
                                           t)
             (bmkx-read-bookmark-file-name "Emacs bookmark file to update: "
                                           (or (file-name-directory default)  "~/")
                                           (if (bmkx-same-file-p bmkx-current-bookmark-file
                                                                 bmkx-last-bookmark-file)
                                               (bmkx-default-bookmark-file)
                                             bmkx-last-bookmark-file))
             t)))
    (when (file-directory-p eww-file) (error "`%s' is a directory, not a file" eww-file))
    (unless (file-readable-p eww-file) (error "Cannot read bookmark file `%s'" eww-file))
    (when (file-directory-p bmk-file) (error "`%s' is a directory, not a file" bmk-file))
    (unless (file-readable-p bmk-file) (bmkx-empty-file bmk-file)) ; Create empty bookmark file.
    (with-temp-buffer
      (insert-file-contents eww-file)
      (let ((bookmark-alist  ())
            url title created bmk)
        (dolist (ebmk  (read (current-buffer)))
          (setq url      (plist-get ebmk :url)
                title    (plist-get ebmk :title)
                created  (date-to-time (plist-get ebmk :time))
                bmk      `(,title
                           ,@(bmkx-make-record-default 'NO-FILE)
                           (location . ,url)
                           (handler . bmkx-jump-eww)))
          (let ((buf-cell  (assq 'buffer-name bmk))) (setcdr buf-cell "*eww*"))
          (let ((created-cell  (assq 'created bmk))) (setcdr created-cell created))
          (push bmk bookmark-alist))
        (bmkx-write-file bmk-file 'ADD)))
    (when msgp (message "Wrote Bookmark file `%s'" bmk-file)))

;; End of EWW support.

;; W3M support: legacy compatibility only.
;; w3m.el (emacs-w3m) is effectively dead.  This fork does not create new
;; w3m bookmarks, but recognises existing ones and routes them through the
;; EWW handler so they keep working.
(defalias 'bmkext-jump-w3m 'bmkx-jump-w3m)
(defun bmkx-jump-w3m (bookmark)
  "Legacy handler for w3m bookmarks: open BOOKMARK's URL in EWW.
BOOKMARK is a bookmark name or a bookmark record."
  (bmkx-jump-eww bookmark))


;; GNUS support for Emacs < 24.  More or less the same as `gnus-summary-bmkx-make-record' in Emacs 24+.
;; But this:
;;
;; * Works for other Emacs versions as well.
;; * Requires `gnus.el'.
;; * Adds a `bmkx-non-file-filename' `filename' entry.
;; * Uses `bmkx-jump-gnus', not `gnus-summary-bmkx-jump' as the handler.
;;
(defun bmkx-make-gnus-record ()
  "Make a bookmark entry for a Gnus summary buffer.
Current buffer can be the article buffer or the summary buffer."
  (require 'gnus)
  (let ((pos  nil)
        buf)
    ;; If in article buffer, record point and buffer, then go to summary buffer
    ;; and record bookmark there.
    (unless (and (derived-mode-p 'gnus-summary-mode)
                 gnus-article-current)
      (setq buf                      "art"
            bookmark-yank-point      (point)
            bookmark-current-buffer  (current-buffer))
      (save-restriction (widen) (setq pos  (point))) ; Position in article buffer.
      (gnus-article-show-summary))
    (let* ((grp   (car gnus-article-current))
           (art   (cdr gnus-article-current))
           (head  (gnus-summary-article-header art))
           (id    (mail-header-id head)))
      (unless buf (setq buf  "sum"))
      `((elt (gnus-summary-article-header) 1) ; Subject.
        ,@(condition-case
           nil
           (bmkx-make-record-default ; POS = nil if started in summary buffer.
            'NO-FILE 'NO-CONTEXT pos nil 'NO-REGION)
           (wrong-number-of-arguments (bmkx-make-record-default 'POINT-ONLY)))
        (location . ,(format "Gnus-%s %s:%d:%s" buf grp art id))
        (filename . ,bmkx-non-file-filename) (group . ,grp) (article . ,art) (message-id . ,id)
        (handler . bmkx-jump-gnus)))))  ; Vanilla Emacs 24+ uses `gnus-summary-bmkx-jump'.


;; Vanilla Emacs 24+ uses `gnus-summary-bmkx-make-record' for these hooks.
;; Better to use `bmkx-make-gnus-record' even for Emacs 24+, because `bmkx-jump-gnus' is better than
;; `gnus-summary-bmkx-jump' (no `sit-for' if article buffer not needed).

(add-hook 'gnus-summary-mode-hook (lambda ()
                                    (set (make-local-variable 'bookmark-make-record-function)
                                         'bmkx-make-gnus-record)))

(add-hook 'gnus-article-mode-hook (lambda ()
                                    (set (make-local-variable 'bookmark-make-record-function)
                                         'bmkx-make-gnus-record)))

;; More or less the same as `gnus-summary-bmkx-jump' in Emacs 24+.
;; But this does not `sit-for' unless BUF is "Gnus-art".
;;
(defun bmkx-jump-gnus (bookmark)
  "Handler function for record returned by `bmkx-make-gnus-record'.
BOOKMARK is a bookmark name or a bookmark record."
  (let* ((group    (bookmark-prop-get bookmark 'group))
         (article  (bookmark-prop-get bookmark 'article))
         (id       (bookmark-prop-get bookmark 'message-id))
         (loc      (bookmark-prop-get bookmark 'location))
         (buf      (if loc (car (split-string loc)) (bookmark-prop-get bookmark 'buffer))))
    (gnus-fetch-group group (list article))
    (gnus-summary-insert-cached-articles)
    (gnus-summary-goto-article id nil 'force)
    ;; Go to article buffer if appropriate.  Wait for it to be ready, so `bmkx-default-handler' has time
    ;; to set the right position.
    (when (equal buf "Gnus-art")  (sit-for 1) (other-window 1))
    (bmkx-default-handler `("" (buffer . ,buf) . ,(bmkx-bookmark-data-from-record bookmark)))))

(defun bmkext-jump-gnus (bookmark)      ; Compatibility code.
  "`gnus-summary-bmkx-jump' if defined, else `bmkx-jump-gnus'."
  (if (fboundp 'gnus-summary-bmkx-jump)
      (gnus-summary-bmkx-jump bookmark) ; Emacs 24
    (bmkx-jump-gnus bookmark)))


;; `man' and `woman' support for Emacs < 24.

(progn (defun bmkx-make-woman-record ()
    "Create bookmark record for `man' page bookmark created by `woman'."
    `(,@(bmkx-make-record-default 'NO-FILE)
      (filename . ,woman-last-file-name) (handler . bmkx-jump-woman))))

(defun bmkx-make-man-record ()
  "Create bookmark record for `man' page bookmark created by `man'."
  `(,@(bmkx-make-record-default 'NO-FILE)
    (filename . ,bmkx-non-file-filename)
    (man-args . ,Man-arguments) (handler . bmkx-jump-man)))


(defun bmkext-jump-woman (bookmark)     ; Compatibility code.
  "`woman-bmkx-jump' if defined, else `bmkx-jump-woman'."
  (if (fboundp 'woman-bmkx-jump)
      (woman-bmkx-jump bookmark)    ; Emacs 24
    (bmkx-jump-woman bookmark)))

(defun bmkx-jump-woman (bookmark)
  "Handler function for `man' page bookmark created by `woman'.
BOOKMARK is a bookmark name or a bookmark record."
    (bmkx-default-handler
   `("" (buffer . ,(save-window-excursion (woman-find-file (bookmark-get-filename bookmark))
                                          (current-buffer)))
     . ,(bmkx-bookmark-data-from-record bookmark))))

(defun bmkext-jump-man (bookmark)       ; Compatibility code.
  "`Man-bmkx-jump' if defined, else `bmkx-jump-man'."
  (if (fboundp 'Man-bmkx-jump)
      (Man-bmkx-jump bookmark)      ; Emacs 24
    (bmkx-jump-man bookmark)))

(defun bmkx-jump-man (bookmark)
  "Handler function for `man' page bookmark created by `man'.
BOOKMARK is a bookmark name or a bookmark record."
  (require 'man)
  (let* ((man-args           (bookmark-prop-get bookmark 'man-args))
         ;; `Man-notify-method' binding needs to be in effect during the calls to both
         ;; `Man-getpage-in-background' and `accept-process-output'.
         (Man-notify-method  (cl-case bmkx-jump-display-function
                               ((nil display-buffer)             'quiet)
                               (bmkx--pop-to-buffer-same-window  'pushy)
                               ((bmkx-select-buffer-other-window
                                 switch-to-buffer-other-window
                                 pop-to-buffer)
                                'friendly)
                               (t                                'quiet)))
         (buf                (Man-getpage-in-background man-args))
         (proc               (and (bufferp buf) ; Emacs 24+
                                  (get-buffer-process buf))))
    (if proc
        (while (and proc (eq (process-status proc) 'run)) (accept-process-output proc))
      (while (get-process "man") (sit-for 0.2)))
    (bmkx-default-handler (bmkx-get-bookmark bookmark))))

(defun bmkx-make-dired-record ()
  "Create and return a Dired bookmark record."
  (let ((hidden-dirs  (save-excursion (dired-remember-hidden))))
    (unwind-protect
        (let ((dir         (expand-file-name (if (consp dired-directory)
                                                 (file-name-directory (car dired-directory))
                                               dired-directory)))
              (subdirs     (bmkx-dired-subdirs))
              (mark-alist  (dired-remember-marks (point-min) (point-max))))
          `(,dir
            ,@(bmkx-make-record-default 'NO-FILE)
            (filename . ,dir) (dired-directory . ,dired-directory)
            (dired-marked . ,mark-alist) (dired-switches . ,dired-actual-switches)
            (dired-subdirs . ,subdirs) (dired-hidden-dirs . ,hidden-dirs)
            (handler . bmkx-jump-dired)))
      (save-excursion                 ; Hide subdirs that were hidden.
        (dolist (dir  hidden-dirs)  (when (dired-goto-subdir dir) (dired-hide-subdir 1)))))))

(add-hook 'dired-mode-hook (lambda () (set (make-local-variable 'bookmark-make-record-function)
                                           'bmkx-make-dired-record)))

;;;###autoload (autoload 'bmkx-dired-subdirs "bookmark-x")
(defun bmkx-dired-subdirs ()
  "Alist of inserted subdirectories, without their positions (markers).
This is like `dired-subdir-alist' but without the top-level dir and
without subdir positions (markers)."
  (interactive)
  (let ((subdir-alist      (cdr (reverse dired-subdir-alist))) ; Remove top.
        (subdirs-wo-posns  ()))
    (dolist (sub  subdir-alist)  (push (list (car sub)) subdirs-wo-posns))
    subdirs-wo-posns))

(defun bmkx-jump-dired (bookmark)
  "Jump to Dired bookmark BOOKMARK.
Handler function for record returned by `bmkx-make-dired-record'.
\(That's the value of `bmkx-make-dired-record' in a Dired buffer.)
BOOKMARK is a bookmark name or a bookmark record."
  (let ((dir          (bookmark-prop-get bookmark 'dired-directory))
        (mark-alist   (bookmark-prop-get bookmark 'dired-marked))
        (switches     (bookmark-prop-get bookmark 'dired-switches))
        (subdirs      (bookmark-prop-get bookmark 'dired-subdirs))
        (hidden-dirs  (bookmark-prop-get bookmark 'dired-hidden-dirs)))
    (cl-case bmkx-jump-display-function
      ((nil bmkx--pop-to-buffer-same-window)
       (dired dir switches))
      ((display-buffer)
       ;; `dired' uses `switch-to-buffer' internally, which does not
       ;; honor `display-buffer-overriding-action'.  Use
       ;; `dired-noselect' + `display-buffer' so the caller's display
       ;; action (e.g. `bmkx-list-switch-other-window' previewing in
       ;; another window) is respected.  Also `set-buffer' to the
       ;; dired buffer so the tail logic below (subdir insertion,
       ;; mark restoration, goto-char pos) runs in the right buffer.
       (let ((buf  (dired-noselect dir switches)))
         (display-buffer buf)
         (set-buffer buf)))
      ((bmkx-select-buffer-other-window pop-to-buffer switch-to-buffer-other-window)
       (dired-other-window dir switches))
      (t (dired dir switches)))
    (let ((inhibit-read-only  t))
      (dired-insert-old-subdirs subdirs)
      ;; Handle old Bookmark-X format, which just recorded `*' marks.  Property `dired-marked'
      ;; was then just a list of files, not an alist of (FILE . MARK-CHAR) entries.
      (if (and mark-alist  (not (listp (car mark-alist))))
          (dired-mark-remembered        ; Old format
           (mapcar `(lambda (mf) (cons (expand-file-name mf ,dir) 42)) mark-alist))
        (dired-mark-remembered mark-alist)) ; New format
      (save-excursion
        (dolist (dir  hidden-dirs) (when (dired-goto-subdir dir) (dired-hide-subdir 1)))))
    (let ((pos  (bookmark-get-position bookmark))) (when pos (goto-char pos)))))

;;;###autoload (autoload 'bmkx-bookmark-all-dired-buffers "bookmark-x")
(defun bmkx-bookmark-all-dired-buffers (sequence &optional msgp)
  "Create bookmarks for the Dired buffers and a bookmark for all of them.
This lets you record and later jump to a set of Dired buffers,
restoring their recorded states (marks, etc.).

You are prompted for the name of the SEQUENCE bookmark that jumps to
the Dired bookmarks.  If that bookmark already exists then replace its
Dired bookmarks with the new ones.  (No preexisting bookmarks are
deleted.)

Each Dired bookmark name is the Dired buffer's `default-directory'.

With a prefix argument, just create the Dired bookmarks; Don't also
create or replace a sequence bookmark."
  (interactive (list (and (not current-prefix-arg)  (bmkx-completing-read-lax "Sequence bookmark"
                                                                              (bmkx-new-bookmark-default-names)))
                     t))
  (let ((dbufs   (if (require 'dired+ nil t) (diredp-live-dired-buffers 'EXCLUDE-DERIVED) dired-buffers))
        (bnames  ())
        (count   0)
        bname)
    (when msgp (message "Bookmarking each Dired buffer..."))
    (dolist (dbuf  dbufs)
      (with-current-buffer dbuf
        (setq bname  (abbreviate-file-name default-directory))
        (bmkx-set bname)
        (when sequence (setq bnames  (cons bname bnames)))
        (setq count  (1+ count))))
    (when msgp (message "%d Dired bookmarks created" count))
    (when sequence (bmkx-set-sequence-bookmark sequence bnames -1 msgp))))

(defun bmkx-read-bookmark-for-type (type alist &optional other-win pred hist action prompt)
  "Read name of a bookmark of type TYPE in ALIST, and return the bookmark.
TYPE is a string used in the prompt: \"Jump to TYPE bookmark: \".
ALIST is the alist used for completion.  If nil then raise an error to
 let the user know there are no bookmarks of type TYPE.
Non-nil OTHER-WIN means append \" in another window\" to the prompt.
Non-nil PRED is a predicate used for bookmark-name completion.
Non-nil HIST is a history symbol.  Default is `bookmark-history'.
Non-nil ACTION is the action mentioned in the prompt; nil: `Jump to '.
Non-nil PROMPT is an alternative prompt."
  (unless alist (error "No bookmarks of type %s" type))
  (bmkx-bookmark-record-from-name
   (bmkx-completing-read (or prompt  (concat (or action  "Jump to ") type " bookmark"
                                                 (and other-win  " in another window")))
                             (bmkx-default-bookmark-name alist)
                             alist pred hist)
   'NOERROR nil alist))

;;;###autoload (autoload 'bmkx-jump-to-type "bookmark-x")
(defun bmkx-jump-to-type (bookmark &optional flip-use-region-p) ; `C-x j :'
  "Jump to a bookmark of a given type.  You are prompted for the type.
Otherwise, this is the same as `bmkx-jump' - see that, in
particular, for info about using a prefix argument.

When prompted for the type, you can use completion against the known
bookmark types (see function `bmkx-types-alist').

Completion is lax, so you can also enter the name of a bookmark
`handler' or `file-handler' function, without completion.  Bookmarks
with that entry value are then the jump candidates.

When called from Lisp, BOOKMARK must be a bookmark record, not a
bookmark name, or else an error is raised."
  (interactive
   (let* ((completion-ignore-case                      t)
          (type-cands                                  (bmkx-types-alist))
          (type                                        (completing-read "Type of bookmark: " type-cands))
          (history                                     (assoc-default type type-cands))
          (alist                                       (if history
                                                           (funcall
                                                            (intern (format "bmkx-%s-alist-only" type)))
                                                         bookmark-alist))
          (bmk                                         (bmkx-read-bookmark-for-type
                                                        type alist nil
                                                        ;; PREDICATE if not a recognized type name.
                                                        (and (not history)
                                                             (bmkx-handler-pred (intern type)))
                                                        history)))
     (list bmk  (or (equal type "Region")  current-prefix-arg))))
  (when (stringp bookmark) (error "Not a bookmark record (perhaps a bookmark name): `%s'" bookmark))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-jump-to-type-other-window "bookmark-x")
(defun bmkx-jump-to-type-other-window (bookmark &optional flip-use-region-p) ; `C-x 4 j :'
  "`bmkx-jump-to-type', but in another window."
  (interactive
   (let* ((completion-ignore-case                      t)
          (type-cands                                  (bmkx-types-alist))
          (type                                        (completing-read "Type of bookmark: " type-cands))
          (history                                     (assoc-default type type-cands))
          (alist                                       (if history
                                                           (funcall
                                                            (intern (format "bmkx-%s-alist-only" type)))
                                                         bookmark-alist))
          (bmk-name                                    (bmkx-read-bookmark-for-type
                                                        type alist t
                                                        ;; PREDICATE if not a recognized type name.
                                                        (and (not history)
                                                             (bmkx-handler-pred (intern type)))
                                                        history)))
     (list bmk-name (or (equal type "Region")  current-prefix-arg))))
  (when (stringp bookmark) (error "Not a bookmark record (perhaps a bookmark name): `%s'" bookmark))
  (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window flip-use-region-p))

(defun bmkx-handler-pred (type)
  "Return a bookmark predicate that tests bookmarks with handler TYPE.
More precisely, the predicate returns non-nil if TYPE is either the
bookmark's `handler' or `file-handler' entry value."
  `(lambda (bmk)
    (member ',type `(,(bookmark-prop-get bmk 'file-handler) ,(bookmark-get-handler bmk)))))

;;;###autoload (autoload 'bmkx-autonamed-jump "bookmark-x")
(defun bmkx-autonamed-jump (bookmark) ; `C-x j #'
  "Jump to an autonamed bookmark.
This is a specialization of `bmkx-jump'."
  (interactive
   (let ((alist  (bmkx-autonamed-alist-only)))
     (list (bmkx-read-bookmark-for-type "autonamed" alist nil nil 'bmkx-autonamed-history))))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-autonamed-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window))

;;;###autoload (autoload 'bmkx-autonamed-jump-other-window "bookmark-x")
(defun bmkx-autonamed-jump-other-window (bookmark) ; `C-x 4 j # #'
  "`bmkx-autonamed-jump', but in another window."
  (interactive
   (let ((alist  (bmkx-autonamed-alist-only)))
     (list (bmkx-read-bookmark-for-type "autonamed" alist t nil 'bmkx-autonamed-history))))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-autonamed-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window))

;;;###autoload (autoload 'bmkx-autonamed-this-buffer-jump "bookmark-x")
(defun bmkx-autonamed-this-buffer-jump (bookmark) ; `C-x j , #'
  "Jump to an autonamed bookmark in the current buffer.
This is a specialization of `bmkx-jump'."
  (interactive
   (let ((alist  (bmkx-autonamed-this-buffer-alist-only)))
     (list (bmkx-read-bookmark-for-type "autonamed" alist nil nil 'bmkx-autonamed-history))))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-autonamed-this-buffer-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window))

;;;###autoload (autoload 'bmkx-autonamed-this-buffer-jump-other-window "bookmark-x")
(defun bmkx-autonamed-this-buffer-jump-other-window (bookmark) ; `C-x 4 j # .'
  "`bmkx-autonamed-this-buffer-jump', but in another window."
  (interactive
   (let ((alist  (bmkx-autonamed-this-buffer-alist-only)))
     (list (bmkx-read-bookmark-for-type "autonamed" alist t nil 'bmkx-autonamed-history))))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-autonamed-this-buffer-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window))

;;;###autoload (autoload 'bmkx-bookmark-list-jump "bookmark-x")
(defun bmkx-bookmark-list-jump (bookmark &optional flip-use-region-p) ; `C-x j B'
  "Jump to a bookmark-list bookmark.
This is a specialization of `bmkx-jump' - see that, in particular
for info about using a prefix argument."
  (interactive
   (let ((alist  (bmkx-bookmark-list-alist-only)))
     (list (bmkx-read-bookmark-for-type "bookmark-list" alist nil nil 'bmkx-bookmark-list-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-bookmark-list-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-desktop-jump "bookmark-x")
(defun bmkx-desktop-jump (bookmark &optional flip-use-region-p) ; `C-x j K'
  "Jump to a desktop bookmark.
If option `bmkx-desktop-jump-save-before-flag' is non-nil, and if the
current desktop was made current by jumping to a bookmark, then save
it before jumping to the next desktop.

This command is a specialization of `bmkx-jump' - see that, in
particular for info about using a prefix argument."
  (interactive
   (let ((alist  (bmkx-desktop-alist-only)))
     (list (bmkx-read-bookmark-for-type "desktop" alist nil nil 'bmkx-desktop-history)
           current-prefix-arg)))
  (when bmkx-desktop-jump-save-before-flag (bmkx-desktop-save-as-last))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-desktop-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window flip-use-region-p)
  (setq bmkx-desktop-current-file  (bookmark-prop-get bookmark 'desktop-file)))

;;;###autoload (autoload 'bmkx-dired-jump "bookmark-x")
(defun bmkx-dired-jump (bookmark &optional flip-use-region-p) ; `C-x j d', (`J' in Dired)
  "Jump to a Dired bookmark.
This is a specialization of `bmkx-jump' - see that, in particular
for info about using a prefix argument."
  (interactive
   (let ((alist  (bmkx-dired-alist-only)))
     (list (bmkx-read-bookmark-for-type "Dired" alist nil nil 'bmkx-dired-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-dired-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-dired-jump-other-window "bookmark-x")
(defun bmkx-dired-jump-other-window (bookmark &optional flip-use-region-p) ; `C-x 4 j d'
  "`bmkx-dired-jump', but in another window."
  (interactive
   (let ((alist  (bmkx-dired-alist-only)))
     (list (bmkx-read-bookmark-for-type "Dired" alist t nil 'bmkx-dired-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-dired-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-dired-this-dir-jump "bookmark-x")
(defun bmkx-dired-this-dir-jump (bookmark &optional flip-use-region-p) ; `C-x j . d', (`C-j' in Dired)
  "Jump to a Dired bookmark for the `default-directory'.
This is a specialization of `bmkx-jump' - see that, in particular
for info about using a prefix argument."
  (interactive
   (let ((alist  (bmkx-dired-this-dir-alist-only)))
     (list (bmkx-read-bookmark-for-type "Dired-for-this-dir " alist nil nil 'bmkx-dired-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-dired-this-dir-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-dired-this-dir-jump-other-window "bookmark-x")
(defun bmkx-dired-this-dir-jump-other-window (bookmark &optional flip-use-region-p) ; `C-x 4 j C-d'
  "`bmkx-dired-this-dir-jump', but in another window."
  (interactive
   (let ((alist  (bmkx-dired-this-dir-alist-only)))
     (list (bmkx-read-bookmark-for-type "Dired-for-this-dir" alist t nil 'bmkx-dired-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-dired-this-dir-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window flip-use-region-p))

(when (fboundp 'bmkx-eww-alist-only)    ; Emacs 25+

  ;; ;;;###autoload (autoload 'bmkx-eww-jump "bookmark-x")
  (defun bmkx-eww-jump (bookmark &optional flip-use-region-p) ; `C-x j e'
    "Jump to an EWW bookmark.
This is a specialization of `bmkx-jump' - see that, in particular
for info about using a prefix argument."
    (interactive
     (let ((alist  (bmkx-eww-alist-only)))
       (list (bmkx-read-bookmark-for-type "EWW" alist nil nil 'bmkx-eww-history)
             current-prefix-arg)))
    (when (stringp bookmark)
      (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-eww-alist-only))))
    (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window flip-use-region-p))

  ;; ;;;###autoload (autoload 'bmkx-eww-jump-other-window "bookmark-x")
  (defun bmkx-eww-jump-other-window (bookmark &optional flip-use-region-p) ; `C-x 4 j e'
    "`bmkx-eww-jump', but in another window."
    (interactive
     (let ((alist  (bmkx-eww-alist-only)))
       (list (bmkx-read-bookmark-for-type "EWW" alist t nil 'bmkx-eww-history)
             current-prefix-arg)))
    (when (stringp bookmark)
      (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-eww-alist-only))))
    (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window flip-use-region-p))

  )

;;;###autoload (autoload 'bmkx-file-jump "bookmark-x")
(defun bmkx-file-jump (bookmark &optional flip-use-region-p) ; `C-x j f'
  "Jump to a file or directory bookmark.
This is a specialization of `bmkx-jump' - see that, in particular
for info about using a prefix argument."
  (interactive
   (let ((alist  (bmkx-file-alist-only)))
     (list (bmkx-read-bookmark-for-type "file" alist nil nil 'bmkx-file-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-file-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-file-jump-other-window "bookmark-x")
(defun bmkx-file-jump-other-window (bookmark &optional flip-use-region-p) ; `C-x 4 j f'
  "`bmkx-file-jump', but in another window."
  (interactive
   (let ((alist  (bmkx-file-alist-only)))
     (list (bmkx-read-bookmark-for-type "file" alist t nil 'bmkx-file-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-file-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-file-this-dir-jump "bookmark-x")
(defun bmkx-file-this-dir-jump (bookmark &optional flip-use-region-p) ; `C-x j . f'
  "Jump to a bookmark for a file or subdir in the `default-directory'.
This is a specialization of `bmkx-jump' - see that, in particular
for info about using a prefix argument."
  (interactive
   (let ((alist  (bmkx-file-this-dir-alist-only)))
     (list (bmkx-read-bookmark-for-type "file-in-this-dir" alist nil nil 'bmkx-file-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-file-this-dir-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-file-this-dir-jump-other-window "bookmark-x")
(defun bmkx-file-this-dir-jump-other-window (bookmark &optional flip-use-region-p) ; `C-x 4 j . f'
  "`bmkx-file-this-dir-jump', but in another window."
  (interactive
   (let ((alist  (bmkx-file-this-dir-alist-only)))
     (list (bmkx-read-bookmark-for-type "file-in-this-dir" alist t nil 'bmkx-file-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-file-this-dir-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-gnus-jump "bookmark-x")
(defun bmkx-gnus-jump (bookmark &optional flip-use-region-p) ; `C-x j g', (`j' in Gnus summary mode)
  "Jump to a Gnus bookmark.
This is a specialization of `bmkx-jump' - see that, in particular
for info about using a prefix argument."
  (interactive
   (let ((alist  (bmkx-gnus-alist-only)))
     (list (bmkx-read-bookmark-for-type "Gnus" alist nil nil 'bmkx-gnus-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-gnus-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-gnus-jump-other-window "bookmark-x")
(defun bmkx-gnus-jump-other-window (bookmark &optional flip-use-region-p) ; `C-x 4 j g'
  "`bmkx-gnus-jump', but in another window."
  (interactive
   (let ((alist  (bmkx-gnus-alist-only)))
     (list (bmkx-read-bookmark-for-type "Gnus" alist t nil 'bmkx-gnus-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-gnus-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-image-jump "bookmark-x")
(defun bmkx-image-jump (bookmark &optional flip-use-region-p) ; `C-x j M-i'
  "Jump to an image-file bookmark.
This is a specialization of `bmkx-jump' - see that, in particular
for info about using a prefix argument."
  (interactive
   (let ((alist  (bmkx-image-alist-only)))
     (list (bmkx-read-bookmark-for-type "image" alist nil nil 'bmkx-image-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-image-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-image-jump-other-window "bookmark-x")
(defun bmkx-image-jump-other-window (bookmark &optional flip-use-region-p) ; `C-x j M-i'
  "`bmkx-image-jump', but in another window."
  (interactive
   (let ((alist  (bmkx-image-alist-only)))
     (list (bmkx-read-bookmark-for-type "image" alist t nil 'bmkx-image-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-image-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-info-jump "bookmark-x")
(defun bmkx-info-jump (bookmark &optional flip-use-region-p) ; `C-x j i', (`j' in Info)
  "Jump to an Info bookmark.
This is a specialization of `bmkx-jump' - see that, in particular
for info about using a prefix argument."
  (interactive
   (let ((alist  (bmkx-info-alist-only)))
     (list (bmkx-read-bookmark-for-type "Info" alist nil nil 'bmkx-info-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-info-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-info-jump-other-window "bookmark-x")
(defun bmkx-info-jump-other-window (bookmark &optional flip-use-region-p) ; `C-x 4 j i'
  "`bmkx-info-jump', but in another window."
  (interactive
   (let ((alist  (bmkx-info-alist-only)))
     (list (bmkx-read-bookmark-for-type "Info" alist t nil 'bmkx-info-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-info-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-local-file-jump "bookmark-x")
(defun bmkx-local-file-jump (bookmark &optional flip-use-region-p) ; `C-x j l'
  "Jump to a local file or directory bookmark.
This is a specialization of `bmkx-jump' - see that, in particular
for info about using a prefix argument."
  (interactive
   (let ((alist  (bmkx-local-file-alist-only)))
     (list (bmkx-read-bookmark-for-type "local file" alist nil nil 'bmkx-local-file-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-local-file-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-local-file-jump-other-window "bookmark-x")
(defun bmkx-local-file-jump-other-window (bookmark &optional flip-use-region-p) ; `C-x 4 j l'
  "`bmkx-local-file-jump', but in another window."
  (interactive
   (let ((alist  (bmkx-local-file-alist-only)))
     (list (bmkx-read-bookmark-for-type "local file" alist t nil 'bmkx-local-file-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-local-file-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-local-non-dir-file-jump "bookmark-x")
(defun bmkx-local-non-dir-file-jump (bookmark &optional flip-use-region-p) ; Not bound
  "Jump to a local nondirectory file bookmark.
This is a specialization of `bmkx-jump' - see that, in particular
for info about using a prefix argument."
  (interactive
   (let ((alist  (bmkx-local-non-dir-file-alist-only)))
     (list (bmkx-read-bookmark-for-type "local non-dir file" alist nil nil 'bmkx-local-file-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-local-non-dir-file-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-local-non-dir-file-jump-other-window "bookmark-x")
(defun bmkx-local-non-dir-file-jump-other-window (bookmark &optional flip-use-region-p) ; Not bound
  "`bmkx-local-non-dir-file-jump', but in another window."
  (interactive
   (let ((alist  (bmkx-local-non-dir-file-alist-only)))
     (list (bmkx-read-bookmark-for-type "local non-dir file" alist t nil 'bmkx-local-file-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-local-non-dir-file-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-man-jump "bookmark-x")
(defun bmkx-man-jump (bookmark &optional flip-use-region-p) ; `C-x j m', (`j' in Man)
  "Jump to a `man'-page bookmark.
This is a specialization of `bmkx-jump' - see that, in particular
for info about using a prefix argument."
  (interactive
   (let ((alist  (bmkx-man-alist-only)))
     (list (bmkx-read-bookmark-for-type "`man'" alist nil nil 'bmkx-man-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-man-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-man-jump-other-window "bookmark-x")
(defun bmkx-man-jump-other-window (bookmark &optional flip-use-region-p) ; `C-x 4 j m'
  "`bmkx-man-jump', but in another window."
  (interactive
   (let ((alist  (bmkx-man-alist-only)))
     (list (bmkx-read-bookmark-for-type "`man'" alist t nil 'bmkx-man-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-man-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-non-dir-file-jump "bookmark-x")
(defun bmkx-non-dir-file-jump (bookmark &optional flip-use-region-p) ; Not bound
  "Jump to a nondirectory file bookmark.
This is a specialization of `bmkx-jump' - see that, in particular
for info about using a prefix argument."
  (interactive
   (let ((alist  (bmkx-non-dir-file-alist-only)))
     (list (bmkx-read-bookmark-for-type "non-dir file" alist nil nil 'bmkx-file-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-non-dir-file-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-non-dir-file-jump-other-window "bookmark-x")
(defun bmkx-non-dir-file-jump-other-window (bookmark &optional flip-use-region-p) ; Not bound
  "`bmkx-non-dir-file-jump', but in another window."
  (interactive
   (let ((alist  (bmkx-non-dir-file-alist-only)))
     (list (bmkx-read-bookmark-for-type "non-dir file" alist t nil 'bmkx-file-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-non-dir-file-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-non-file-jump "bookmark-x")
(defun bmkx-non-file-jump (bookmark &optional flip-use-region-p) ; `C-x j b', (`j' in Buffer Menu)
  "Jump to a non-file (buffer) bookmark.
This is a specialization of `bmkx-jump' - see that, in particular
for info about using a prefix argument."
  (interactive
   (let ((alist  (bmkx-non-file-alist-only)))
     (list (bmkx-read-bookmark-for-type "non-file (buffer)" alist nil nil 'bmkx-non-file-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-non-file-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-non-file-jump-other-window "bookmark-x")
(defun bmkx-non-file-jump-other-window (bookmark &optional flip-use-region-p) ; `C-x 4 j b'
  "`bmkx-non-file-jump', but in another window."
  (interactive
   (let ((alist  (bmkx-non-file-alist-only)))
     (list (bmkx-read-bookmark-for-type "non-file (buffer)" alist t nil 'bmkx-non-file-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-non-file-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-region-jump "bookmark-x")
(defun bmkx-region-jump (bookmark) ; `C-x j r'
  "Jump to a region bookmark.  Select the region.
This is a specialization of `bmkx-jump', but without a prefix arg.
BOOKMARK is a bookmark name or a bookmark record."
  (interactive (list (bmkx-read-bookmark-for-type "region" (bmkx-region-alist-only) nil nil
                                                  'bmkx-region-history)))
  (let ((bmkx-use-region  t)) (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window)))

;;;###autoload (autoload 'bmkx-region-jump-other-window "bookmark-x")
(defun bmkx-region-jump-other-window (bookmark) ; `C-x 4 j r'
  "`bmkx-region-jump', but in another window."
  (interactive (list (bmkx-read-bookmark-for-type "region" (bmkx-region-alist-only) t nil
                                                  'bmkx-region-history)))
  (let ((bmkx-use-region  t)) (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window)))

;; This command accepts no argument.  It calls another command interactively, which reads the bookmark name.
;;
;;;###autoload (autoload 'bmkx-region-jump-narrow-indirect-other-window "bookmark-x")
(defun bmkx-region-jump-narrow-indirect-other-window ()
  "Jump to a region bookmark and narrow to it in a cloned indirect buffer.
You are prompted for the region bookmark.

The region is selected as usual, in the bookmarked file/buffer.  A
separate window is opened on the region text (which is unselected),
for the cloned indirect buffer.

If the major-mode symbol of the buffer with the selected region has
non-nil property `no-clone-indirect' then no indirect buffer clone is
created.  But unlike `clone-indirect-buffer' no error is raised."
  (interactive)
  (let ((bmkx-handle-region-function  'bmkx-handle-region+narrow-indirect))
    (call-interactively #'bmkx-region-jump-other-window)))

(defun bmkx-handle-region+narrow-indirect (bookmark)
  "`bmkx-handle-region-default', then narrow to region in cloned buffer."
  (let ((bmkx-handle-region-function  'bmkx-handle-region-default))
    (bmkx-handle-bookmark bookmark))
  (if (get major-mode 'no-clone-indirect) ; e.g., `Info-mode'
      (message "Cannot indirectly clone a buffer in `%s' mode" major-mode)
    (let ((start  (region-beginning))
          (end    (region-end)))
      (clone-indirect-buffer-other-window nil t)
      (narrow-to-region start end))))

;;;###autoload (autoload 'bmkx-remote-file-jump "bookmark-x")
(defun bmkx-remote-file-jump (bookmark &optional flip-use-region-p) ; `C-x j n'
  "Jump to a remote file or directory bookmark.
This is a specialization of `bmkx-jump' - see that, in particular
for info about using a prefix argument."
  (interactive
   (let ((alist  (bmkx-remote-file-alist-only)))
     (list (bmkx-read-bookmark-for-type "remote file" alist nil nil 'bmkx-remote-file-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-remote-file-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-remote-file-jump-other-window "bookmark-x")
(defun bmkx-remote-file-jump-other-window (bookmark &optional flip-use-region-p) ; `C-x 4 j n'
  "`bmkx-remote-file-jump', but in another window."
  (interactive
   (let ((alist  (bmkx-remote-file-alist-only)))
     (list (bmkx-read-bookmark-for-type "remote file" alist t nil 'bmkx-remote-file-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-remote-file-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-remote-non-dir-file-jump "bookmark-x")
(defun bmkx-remote-non-dir-file-jump (bookmark &optional flip-use-region-p) ; Not bound
  "Jump to a remote nondirectory file bookmark.
This is a specialization of `bmkx-jump' - see that, in particular
for info about using a prefix argument."
  (interactive
   (let ((alist  (bmkx-remote-non-dir-file-alist-only)))
     (list (bmkx-read-bookmark-for-type "remote non-dir file" alist nil nil 'bmkx-remote-file-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-remote-non-dir-file-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-remote-non-dir-file-jump-other-window "bookmark-x")
(defun bmkx-remote-non-dir-file-jump-other-window (bookmark &optional flip-use-region-p) ; Not bound
  "`bmkx-remote-non-dir-file-jump', but in another window."
  (interactive
   (let ((alist  (bmkx-remote-non-dir-file-alist-only)))
     (list (bmkx-read-bookmark-for-type "remote non-dir file" alist t nil 'bmkx-remote-file-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-remote-non-dir-file-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-specific-buffers-jump "bookmark-x")
(defun bmkx-specific-buffers-jump (buffers bookmark &optional flip-use-region-p) ; `C-x j = b'
  "Jump to a bookmark for a buffer in list BUFFERS.
Interactively, read buffer names and bookmark name, with completion.

This is a specialization of `bmkx-jump' - see that, in particular
for info about using a prefix argument."
  (interactive
   (let* ((buffs  (bmkx-read-buffers))
          (alist  (bmkx-specific-buffers-alist-only buffs)))
     (list buffs (bmkx-read-bookmark-for-type "specific-buffers" alist nil nil 'specific-buffers-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-specific-buffers-alist-only buffers))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-specific-buffers-jump-other-window "bookmark-x")
(defun bmkx-specific-buffers-jump-other-window (buffers bookmark
                                                        &optional flip-use-region-p) ; `C-x 4 j = b'
  "`bmkx-specific-buffers-jump', but in another window."
  (interactive
   (let* ((buffs  (bmkx-read-buffers))
          (alist  (bmkx-specific-buffers-alist-only buffs)))
     (list buffs (bmkx-read-bookmark-for-type "specific-buffers" alist t nil 'specific-buffers-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-specific-buffers-alist-only buffers))))
  (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-specific-files-jump "bookmark-x")
(defun bmkx-specific-files-jump (files bookmark &optional flip-use-region-p) ; `C-x j = f'
  "Jump to a bookmark for a file in list FILES.
Interactively, read file names and bookmark name, with completion.

This is a specialization of `bmkx-jump' - see that, in particular
for info about using a prefix argument."
  (interactive
   (let* ((fils   (bmkx-read-files))
          (alist  (bmkx-specific-files-alist-only fils)))
     (list fils
           (bmkx-read-bookmark-for-type "specific-files" alist nil nil 'specific-files-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-specific-files-alist-only files))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-specific-files-jump-other-window "bookmark-x")
(defun bmkx-specific-files-jump-other-window (files bookmark
                                                    &optional flip-use-region-p) ; `C-x 4 j = f'
  "`bmkx-specific-files-jump', but in another window."
  (interactive
   (let* ((fils   (bmkx-read-files))
          (alist  (bmkx-specific-files-alist-only fils)))
     (list fils
           (bmkx-read-bookmark-for-type "specific-files" alist t nil 'specific-files-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-specific-files-alist-only files))))
  (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-temporary-jump "bookmark-x")
(defun bmkx-temporary-jump (bookmark) ; `C-x j x'
  "Jump to a temporary bookmark.
This is a specialization of `bmkx-jump', but without a prefix arg."
  (interactive (list (bmkx-read-bookmark-for-type "temporary" (bmkx-temporary-alist-only) nil nil
                                                  'bmkx-temporary-history)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-temporary-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window))

;;;###autoload (autoload 'bmkx-temporary-jump-other-window "bookmark-x")
(defun bmkx-temporary-jump-other-window (bookmark) ; `C-x 4 j x'
  "`bmkx-temporary-jump', but in another window."
  (interactive (list (bmkx-read-bookmark-for-type "temporary" (bmkx-temporary-alist-only) t nil
                                                  'bmkx-temporary-history)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-temporary-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window))

;;;###autoload (autoload 'bmkx-this-buffer-jump "bookmark-x")
(defun bmkx-this-buffer-jump (bookmark &optional flip-use-region-p) ; `C-x j , ,'
  "Jump to a bookmark for the current buffer.
This is a specialization of `bmkx-jump' - see that, in particular
for info about using a prefix argument."
  (interactive
   (let ((alist  (bmkx-this-buffer-alist-only)))
     (unless alist  (error "No bookmarks for this buffer"))
     (list (bmkx-completing-read "Jump to bookmark for this buffer"
                                     (bmkx-default-bookmark-name alist) alist)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-this-buffer-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-this-buffer-jump-other-window "bookmark-x")
(defun bmkx-this-buffer-jump-other-window (bookmark &optional flip-use-region-p) ; `C-x 4 j , ,'
  "`bmkx-this-buffer-jump', but in another window."
  (interactive
   (let ((alist  (bmkx-this-buffer-alist-only)))
     (unless alist  (error "No bookmarks for this buffer"))
     (list (bmkx-completing-read "Jump to bookmark for this buffer in another window"
                                     (bmkx-default-bookmark-name alist) alist)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-this-buffer-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window flip-use-region-p))

;;; ;;;###autoload
;;; (defun bmkx-this-file-jump (bookmark-name &optional flip-use-region-p)
;;;   "Jump to a bookmark for the current file (absolute file name).
;;; This is a specialization of `bmkx-jump' - see that, in particular
;;; for info about using a prefix argument."
;;;   (interactive
;;;    (progn (unless (or (buffer-file-name)  (and (eq major-mode 'dired-mode)
;;;                                                (if (consp dired-directory)
;;;                                                    (car dired-directory)
;;;                                                  dired-directory)))
;;;             (error "This buffer is not associated with a file"))
;;;           (let ((alist  (bmkx-this-file-alist-only)))
;;;             (unless alist  (error "No bookmarks for this file"))
;;;             (list (bmkx-completing-read "Jump to bookmark for this file"
;;;                                             (bmkx-default-bookmark-name alist) alist)
;;;                   current-prefix-arg))))
;;;   (bmkx-jump-1 bookmark-name 'bmkx--pop-to-buffer-same-window flip-use-region-p))

;;; ;;;###autoload
;;; (defun bmkx-this-file-jump-other-window (bookmark-name &optional flip-use-region-p)
;;;   "`bmkx-this-file-jump', but in another window."
;;;   (interactive
;;;    (progn (unless (or (buffer-file-name)  (and (eq major-mode 'dired-mode)
;;;                                                (if (consp dired-directory)
;;;                                                    (car dired-directory)
;;;                                                  dired-directory)))
;;;             (error "This buffer is not associated with a file"))
;;;           (let ((alist  (bmkx-this-file-alist-only)))
;;;             (unless alist  (error "No bookmarks for this file"))
;;;             (list (bmkx-completing-read "Jump to bookmark for this file in another window"
;;;                                             (bmkx-default-bookmark-name alist) alist)
;;;                   current-prefix-arg))))
;;;   (bmkx-jump-1 bookmark-name 'bmkx-select-buffer-other-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-variable-list-jump "bookmark-x")
(defun bmkx-variable-list-jump (bookmark) ; `C-x j v'
  "Jump to a variable-list bookmark.
This is a specialization of `bmkx-jump'."
  (interactive
   (let ((alist  (bmkx-variable-list-alist-only)))
     (list (bmkx-read-bookmark-for-type "variable-list" alist nil nil 'bmkx-variable-list-history))))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-variable-list-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window))

;;;###autoload (autoload 'bmkx-url-jump "bookmark-x")
(defun bmkx-url-jump (bookmark &optional flip-use-region-p) ; `C-x j u'
  "Jump to a URL bookmark.
It can be an EWW bookmark, a W3M bookmark, or a browse-URL bookmark.
This is a specialization of `bmkx-jump' - see that, in particular
for info about using a prefix argument."
  (interactive
   (let ((alist  (bmkx-url-alist-only)))
     (list (bmkx-read-bookmark-for-type "URL" alist nil nil 'bmkx-url-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-url-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-url-jump-other-window "bookmark-x")
(defun bmkx-url-jump-other-window (bookmark &optional flip-use-region-p) ; `C-x 4 j u'
  "`bmkx-url-jump', but in another window."
  (interactive
   (let ((alist  (bmkx-url-alist-only)))
     (list (bmkx-read-bookmark-for-type "URL" alist t nil 'bmkx-url-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-url-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-w32-browser-jump "bookmark-x")
(defun bmkx-w32-browser-jump (bookmark) ; Not bound
  "Jump to a bookmark whose handler applies `w32-browser' to its file.
This is a specialization of `bmkx-jump'."
  (interactive
   (list (bmkx-read-bookmark-for-type "w32-browser" bookmark-alist nil
                                      ;; Use a predicate, since `w32-browser' is a handler, not a type name.
                                      (bmkx-handler-pred 'w32-browser)
                                      'bmkx-w32-browser-history)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR)))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window))

;;;###autoload (autoload 'bmkx-w3m-jump "bookmark-x")
(defun bmkx-w3m-jump (bookmark &optional flip-use-region-p) ; `C-x j w', (`j' in W3M)
  "Jump to a W3M bookmark.
This is a specialization of `bmkx-jump' - see that, in particular
for info about using a prefix argument."
  (interactive
   (let ((alist  (bmkx-w3m-alist-only)))
     (list (bmkx-read-bookmark-for-type "W3M" alist nil nil 'bmkx-w3m-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-w3m-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-w3m-jump-other-window "bookmark-x")
(defun bmkx-w3m-jump-other-window (bookmark &optional flip-use-region-p) ; `C-x 4 j w'
  "`bmkx-w3m-jump', but in another window."
  (interactive
   (let ((alist  (bmkx-w3m-alist-only)))
     (list (bmkx-read-bookmark-for-type "W3M" alist t nil 'bmkx-w3m-history)
           current-prefix-arg)))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-w3m-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-all-tags-jump "bookmark-x")
(defun bmkx-all-tags-jump (tags bookmark &optional interactivep) ; `C-x j t *'
  "Jump to a BOOKMARK whose tags are all contained in TAGS.
A candidate is any bookmark whose tag set is a (non-empty) subset of
TAGS.  In particular, a bookmark tagged \"foo\" and \"bar\" is a
candidate when TAGS is (\"foo\" \"bar\") or (\"foo\" \"bar\" \"baz\"),
but not when TAGS is (\"foo\") alone.  Bookmarks with no tags are
excluded.

To jump to a bookmark that has every name in a given tag set
\(\"tagged with foo and bar\"), use `bmkx-tag-jump' instead.

Hit `RET' to enter each tag, then hit `RET' again after the last tag.
You can use completion to enter the bookmark name and each tag.
If you specify no tags, then every bookmark that has some tags is a
candidate.

By default, the tag choices for completion are NOT refreshed, to save
time.  Use a prefix argument if you want to refresh them."
  (interactive
   (let* ((tgs    (bmkx-read-tags-completing nil nil current-prefix-arg))
          (alist  (bmkx-all-tags-alist-only tgs)))
     (unless alist (error "No bookmarks whose tags are all in the specified set"))
     (list tgs (bmkx-completing-read "Bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-all-tags-alist-only tags))
    (error "No bookmarks whose tags are all in the specified set"))
  (bmkx-jump bookmark))

;;;###autoload (autoload 'bmkx-all-tags-jump-other-window "bookmark-x")
(defun bmkx-all-tags-jump-other-window (tags bookmark &optional interactivep) ; `C-x 4 j t *'
  "`bmkx-all-tags-jump', but in another window.
See `bmkx-all-tags-jump' for the (subset) match semantics, and
`bmkx-tag-jump-other-window' for the more common \"has every tag in
TAGS\" variant."
  (interactive
   (let* ((tgs    (bmkx-read-tags-completing nil nil current-prefix-arg))
          (alist  (bmkx-all-tags-alist-only tgs)))
     (unless alist (error "No bookmarks whose tags are all in the specified set"))
     (list tgs (bmkx-completing-read "Bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-all-tags-alist-only tags))
    (error "No bookmarks whose tags are all in the specified set"))
  (bmkx-jump-other-window bookmark))

;;;###autoload (autoload 'bmkx-tag-jump "bookmark-x")
(defun bmkx-tag-jump (tags bookmark &optional interactivep) ; `C-x j t T'
  "Jump to a BOOKMARK that has every tag in TAGS.
TAGS is a tag-name string or a list of tag-name strings.  A bookmark
matches when, for every NAME in TAGS, the bookmark has a tag with
that name (other tags on the bookmark are allowed).

Contrast `bmkx-all-tags-jump', which matches when the bookmark's tag
set is a subset of TAGS.

Interactively, you are prompted for the tag(s) and then for the
bookmark, with completion restricted to the matching set.  Hit `RET'
to enter each tag, then `RET' again after the last tag.

By default, the tag choices for completion are NOT refreshed, to save
time.  Use a prefix argument if you want to refresh them.

In Lisp code:
TAGS is a string (treated as a one-element list) or a list of strings.
BOOKMARK is a bookmark name or a bookmark record.
Non-nil INTERACTIVEP signals that input came from the minibuffer; it
 suppresses the redundant no-match check the Lisp path performs."
  (interactive
   (let* ((tgs    (bmkx-read-tags-completing nil nil current-prefix-arg))
          (alist  (bmkx-has-tags-alist-only tgs)))
     (unless tgs   (error "You did not specify any tags"))
     (unless alist (error "No bookmarks have all of the specified tags"))
     (list tgs (bmkx-completing-read "Bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (let ((tag-list  (if (stringp tags) (list tags) tags)))
    (unless (or interactivep  (bmkx-has-tags-alist-only tag-list))
      (error "No bookmarks have all of the specified tags")))
  (bmkx-jump bookmark))

;;;###autoload (autoload 'bmkx-tag-jump-other-window "bookmark-x")
(defun bmkx-tag-jump-other-window (tags bookmark &optional interactivep) ; `C-x 4 j t T'
  "`bmkx-tag-jump', but in another window."
  (interactive
   (let* ((tgs    (bmkx-read-tags-completing nil nil current-prefix-arg))
          (alist  (bmkx-has-tags-alist-only tgs)))
     (unless tgs   (error "You did not specify any tags"))
     (unless alist (error "No bookmarks have all of the specified tags"))
     (list tgs (bmkx-completing-read "Bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (let ((tag-list  (if (stringp tags) (list tags) tags)))
    (unless (or interactivep  (bmkx-has-tags-alist-only tag-list))
      (error "No bookmarks have all of the specified tags")))
  (bmkx-jump-other-window bookmark))

;;;###autoload (autoload 'bmkx-all-tags-regexp-jump "bookmark-x")
(defun bmkx-all-tags-regexp-jump (regexp bookmark &optional interactivep) ; `C-x j t % *'
  "Jump to a BOOKMARK that has each tag matching REGEXP.
You are prompted for the REGEXP.
Then you are prompted for the BOOKMARK (with completion)."
  (interactive
   (let* ((rgx    (bmkx-read-regexp "Regexp for all tags: "))
          (alist  (bmkx-all-tags-regexp-alist-only rgx)))
     (unless alist (error "No bookmarks have tags that all match `%s'" rgx))
     (list rgx (bmkx-completing-read "Bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-all-tags-regexp-alist-only regexp))
    (error "No bookmarks have tags that all match `%s'" regexp))
  (bmkx-jump bookmark))

;;;###autoload (autoload 'bmkx-all-tags-regexp-jump-other-window "bookmark-x")
(defun bmkx-all-tags-regexp-jump-other-window (regexp bookmark &optional interactivep) ; `C-x 4 j t % *'
  "`bmkx-all-tags-regexp-jump', but in another window."
  (interactive
   (let* ((rgx    (bmkx-read-regexp "Regexp for all tags: "))
          (alist  (bmkx-all-tags-regexp-alist-only rgx)))
     (unless alist (error "No bookmarks have tags that all match `%s'" rgx))
     (list rgx (bmkx-completing-read "Bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-all-tags-regexp-alist-only regexp))
    (error "No bookmarks have tags that all match `%s'" regexp))
  (bmkx-jump-other-window bookmark))

;;;###autoload (autoload 'bmkx-some-tags-jump "bookmark-x")
(defun bmkx-some-tags-jump (tags bookmark &optional interactivep) ; `C-x j t +'
  "Jump to a BOOKMARK that has at least one of the TAGS.
Hit `RET' to enter each tag, then hit `RET' again after the last tag.
You can use completion to enter the bookmark name and each tag.

By default, the tag choices for completion are NOT refreshed, to save
time.  Use a prefix argument if you want to refresh them."
  (interactive
   (let* ((tgs    (bmkx-read-tags-completing nil nil current-prefix-arg))
          (alist  (bmkx-some-tags-alist-only tgs)))
     (unless tgs (error "You did not specify any tags"))
     (unless alist (error "No bookmarks have any of the specified tags"))
     (list tgs (bmkx-completing-read "Bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-some-tags-alist-only tags))
    (error "No bookmarks have any of the specified tags"))
  (bmkx-jump bookmark))

;;;###autoload (autoload 'bmkx-some-tags-jump-other-window "bookmark-x")
(defun bmkx-some-tags-jump-other-window (tags bookmark &optional interactivep) ; `C-x 4 j t +'
  "`bmkx-some-tags-jump', but in another window."
  (interactive
   (let* ((tgs    (bmkx-read-tags-completing nil nil current-prefix-arg))
          (alist  (bmkx-some-tags-alist-only tgs)))
     (unless tgs (error "You did not specify any tags"))
     (unless alist (error "No bookmarks have any of the specified tags"))
     (list tgs (bmkx-completing-read "Bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-some-tags-alist-only tags))
    (error "No bookmarks have any of the specified tags"))
  (bmkx-jump-other-window bookmark))

;;;###autoload (autoload 'bmkx-some-tags-regexp-jump "bookmark-x")
(defun bmkx-some-tags-regexp-jump (regexp bookmark &optional interactivep) ; `C-x j t % +'
  "Jump to a BOOKMARK that has a tag matching REGEXP.
You are prompted for the REGEXP.
Then you are prompted for the BOOKMARK (with completion)."
  (interactive
   (let* ((rgx    (bmkx-read-regexp "Regexp for tags: "))
          (alist  (bmkx-some-tags-regexp-alist-only rgx)))
     (unless alist (error "No bookmarks have any tags that match `%s'" rgx))
     (list rgx (bmkx-completing-read "Bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-some-tags-regexp-alist-only regexp))
    (error "No bookmarks have any tags that match `%s'" regexp))
  (bmkx-jump bookmark))

;;;###autoload (autoload 'bmkx-some-tags-regexp-jump-other-window "bookmark-x")
(defun bmkx-some-tags-regexp-jump-other-window (regexp bookmark &optional interactivep) ; `C-x 4 j t % +'
  "`bmkx-some-tags-regexp-jump', but in another window."
  (interactive
   (let* ((rgx    (bmkx-read-regexp "Regexp for tags: "))
          (alist  (bmkx-some-tags-regexp-alist-only rgx)))
     (unless alist (error "No bookmarks have any tags that match `%s'" rgx))
     (list rgx (bmkx-completing-read "Bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-some-tags-regexp-alist-only regexp))
    (error "No bookmarks have any tags that match `%s'" regexp))
  (bmkx-jump-other-window bookmark))

;;;###autoload (autoload 'bmkx-file-all-tags-jump "bookmark-x")
(defun bmkx-file-all-tags-jump (tags bookmark &optional interactivep) ; `C-x j t f *'
  "Jump to a file or directory BOOKMARK that has all of the TAGS.
Hit `RET' to enter each tag, then hit `RET' again after the last tag.
You can use completion to enter the bookmark name and each tag.
If you specify no tags, then every bookmark that has some tags is a
candidate.

By default, the tag choices for completion are NOT refreshed, to save
time.  Use a prefix argument if you want to refresh them."
  (interactive
   (let* ((tgs    (bmkx-read-tags-completing nil nil current-prefix-arg))
          (alist  (bmkx-file-all-tags-alist-only tgs)))
     (unless alist (error "No file or dir bookmarks have all of the specified tags"))
     (list tgs (bmkx-completing-read "File bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-file-all-tags-alist-only tags))
    (error "No file or dir bookmarks have all of the specified tags"))
  (bmkx-jump bookmark))

;;;###autoload (autoload 'bmkx-file-all-tags-jump-other-window "bookmark-x")
(defun bmkx-file-all-tags-jump-other-window (tags bookmark &optional interactivep) ; `C-x 4 j t f *'
  "`bmkx-file-all-tags-jump', but in another window."
  (interactive
   (let* ((tgs    (bmkx-read-tags-completing nil nil current-prefix-arg))
          (alist  (bmkx-file-all-tags-alist-only tgs)))
     (unless alist (error "No file or dir bookmarks have all of the specified tags"))
     (list tgs (bmkx-completing-read "File bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-file-all-tags-alist-only tags))
    (error "No file or dir bookmarks have all of the specified tags"))
  (bmkx-jump-other-window bookmark))

;;;###autoload (autoload 'bmkx-file-all-tags-regexp-jump "bookmark-x")
(defun bmkx-file-all-tags-regexp-jump (regexp bookmark &optional interactivep) ; `C-x j t f % *'
  "Jump to a file or directory BOOKMARK that has each tag matching REGEXP.
You are prompted for the REGEXP.
Then you are prompted for the BOOKMARK (with completion)."
  (interactive
   (let* ((rgx    (bmkx-read-regexp "Regexp for tags: "))
          (alist  (bmkx-file-all-tags-regexp-alist-only rgx)))
     (unless alist (error "No file or dir bookmarks have tags that all match `%s'" rgx))
     (list rgx (bmkx-completing-read "File bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-file-all-tags-regexp-alist-only regexp))
    (error "No file or dir bookmarks have tags that all match `%s'" regexp))
  (bmkx-jump bookmark))

;;;###autoload (autoload 'bmkx-file-all-tags-regexp-jump-other-window "bookmark-x")
(defun bmkx-file-all-tags-regexp-jump-other-window (regexp bookmark &optional interactivep) ; `C-x 4 j t f % *'
  "`bmkx-file-all-tags-regexp-jump', but in another window."
  (interactive
   (let* ((rgx    (bmkx-read-regexp "Regexp for tags: "))
          (alist  (bmkx-file-all-tags-regexp-alist-only rgx)))
     (unless alist (error "No file or dir bookmarks have tags that all match `%s'" rgx))
     (list rgx (bmkx-completing-read "File bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-file-all-tags-regexp-alist-only regexp))
    (error "No file or dir bookmarks have tags that all match `%s'" regexp))
  (bmkx-jump-other-window bookmark))

;;;###autoload (autoload 'bmkx-file-some-tags-jump "bookmark-x")
(defun bmkx-file-some-tags-jump (tags bookmark &optional interactivep) ; `C-x j t f +'
  "Jump to a file or directory BOOKMARK that has at least one of the TAGS.
Hit `RET' to enter each tag, then hit `RET' again after the last tag.
You can use completion to enter the bookmark name and each tag.

By default, the tag choices for completion are NOT refreshed, to save
time.  Use a prefix argument if you want to refresh them."
  (interactive
   (let* ((tgs    (bmkx-read-tags-completing nil nil current-prefix-arg))
          (alist  (bmkx-file-some-tags-alist-only tgs)))
     (unless tgs (error "You did not specify any tags"))
     (unless alist (error "No file or dir bookmarks have any of the specified tags"))
     (list tgs (bmkx-completing-read "File bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-file-some-tags-alist-only tags))
    (error "No file or dir bookmarks have any of the specified tags"))
  (bmkx-jump bookmark))

;;;###autoload (autoload 'bmkx-file-some-tags-jump-other-window "bookmark-x")
(defun bmkx-file-some-tags-jump-other-window (tags bookmark &optional interactivep) ; `C-x 4 j t f +'
  "`bmkx-file-some-tags-jump', but in another window."
  (interactive
   (let* ((tgs    (bmkx-read-tags-completing nil nil current-prefix-arg))
          (alist  (bmkx-file-some-tags-alist-only tgs)))
     (unless tgs (error "You did not specify any tags"))
     (unless alist (error "No file or dir bookmarks have any of the specified tags"))
     (list tgs (bmkx-completing-read "File bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-file-some-tags-alist-only tags))
    (error "No file or dir bookmarks have any of the specified tags"))
  (bmkx-jump-other-window bookmark))

;;;###autoload (autoload 'bmkx-file-some-tags-regexp-jump "bookmark-x")
(defun bmkx-file-some-tags-regexp-jump (regexp bookmark &optional interactivep) ; `C-x j t f % +'
  "Jump to a file or directory BOOKMARK that has a tag matching REGEXP.
You are prompted for the REGEXP.
Then you are prompted for the BOOKMARK (with completion)."
  (interactive
   (let* ((rgx    (bmkx-read-regexp "Regexp for tags: "))
          (alist  (bmkx-file-some-tags-regexp-alist-only rgx)))
     (unless alist (error "No file or dir bookmarks have any tags that match `%s'" rgx))
     (list rgx (bmkx-completing-read "File bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-file-some-tags-regexp-alist-only regexp))
    (error "No file or dir bookmarks have any tags that match `%s'" regexp))
  (bmkx-jump bookmark))

;;;###autoload (autoload 'bmkx-file-some-tags-regexp-jump-other-window "bookmark-x")
(defun bmkx-file-some-tags-regexp-jump-other-window (regexp bookmark &optional interactivep) ; `C-x 4 j t f % +'
  "`bmkx-file-some-tags-regexp-jump', but in another window."
  (interactive
   (let* ((rgx    (bmkx-read-regexp "Regexp for tags: "))
          (alist  (bmkx-file-some-tags-regexp-alist-only rgx)))
     (unless alist (error "No file or dir bookmarks have any tags that match `%s'" rgx))
     (list rgx (bmkx-completing-read "File bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-file-some-tags-regexp-alist-only regexp))
    (error "No file or dir bookmarks have any tags that match `%s'" regexp))
  (bmkx-jump-other-window bookmark))

;;;###autoload (autoload 'bmkx-file-this-dir-all-tags-jump "bookmark-x")
(defun bmkx-file-this-dir-all-tags-jump (tags bookmark &optional interactivep) ; `C-x j t . *'
  "Jump to a file BOOKMARK in this dir that has all of the TAGS.
Hit `RET' to enter each tag, then hit `RET' again after the last tag.
You can use completion to enter the bookmark name and each tag.
If you specify no tags, then every bookmark that has some tags is a
candidate.

By default, the tag choices for completion are NOT refreshed, to save
time.  Use a prefix argument if you want to refresh them."
  (interactive
   (let* ((tgs    (bmkx-read-tags-completing nil nil current-prefix-arg))
          (alist  (bmkx-file-this-dir-all-tags-alist-only tgs)))
     (unless alist (error "No file or dir bookmarks in this dir have all of the specified tags"))
     (list tgs (bmkx-completing-read "File bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-file-this-dir-all-tags-alist-only tags))
    (error "No file or dir bookmarks in this dir have all of the specified tags"))
  (bmkx-jump bookmark))

;;;###autoload (autoload 'bmkx-file-this-dir-all-tags-jump-other-window "bookmark-x")
(defun bmkx-file-this-dir-all-tags-jump-other-window (tags bookmark &optional interactivep) ; `C-x 4 j t . *'
  "`bmkx-file-this-dir-all-tags-jump', but in another window."
  (interactive
   (let* ((tgs    (bmkx-read-tags-completing nil nil current-prefix-arg))
          (alist  (bmkx-file-this-dir-all-tags-alist-only tgs)))
     (unless alist (error "No file or dir bookmarks in this dir have all of the specified tags"))
     (list tgs (bmkx-completing-read "File bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-file-this-dir-all-tags-alist-only tags))
    (error "No file or dir bookmarks in this dir have all of the specified tags"))
  (bmkx-jump-other-window bookmark))

;;;###autoload (autoload 'bmkx-file-this-dir-all-tags-regexp-jump "bookmark-x")
(defun bmkx-file-this-dir-all-tags-regexp-jump (regexp bookmark &optional interactivep) ; `C-x j t . % *'
  "Jump to a file BOOKMARK in this dir that has each tag matching REGEXP.
You are prompted for the REGEXP.
Then you are prompted for the BOOKMARK (with completion)."
  (interactive
   (let* ((rgx    (bmkx-read-regexp "Regexp for tags: "))
          (alist  (bmkx-file-this-dir-all-tags-regexp-alist-only rgx)))
     (unless alist (error "No file or dir bookmarks in this dir have all tags that match `%s'" rgx))
     (list rgx (bmkx-completing-read "File bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-file-this-dir-all-tags-regexp-alist-only regexp))
    (error "No file or dir bookmarks in this dir have all tags that match `%s'" regexp))
  (bmkx-jump bookmark))

;;;###autoload (autoload 'bmkx-file-this-dir-all-tags-regexp-jump-other-window "bookmark-x")
(defun bmkx-file-this-dir-all-tags-regexp-jump-other-window (regexp bookmark &optional interactivep)
                                        ; `C-x 4 j t . % *'
  "`bmkx-file-this-dir-all-tags-regexp-jump', but in another window."
  (interactive
   (let* ((rgx    (bmkx-read-regexp "Regexp for tags: "))
          (alist  (bmkx-file-this-dir-all-tags-regexp-alist-only rgx)))
     (unless alist (error "No file or dir bookmarks in this dir have all tags that match `%s'" rgx))
     (list rgx (bmkx-completing-read "File bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-file-this-dir-all-tags-regexp-alist-only regexp))
    (error "No file or dir bookmarks in this dir have all tags that match `%s'" regexp))
  (bmkx-jump-other-window bookmark))

;;;###autoload (autoload 'bmkx-file-this-dir-some-tags-jump "bookmark-x")
(defun bmkx-file-this-dir-some-tags-jump (tags bookmark &optional interactivep) ; `C-x j t . +'
  "Jump to a file BOOKMARK in this dir that has at least one of the TAGS.
Hit `RET' to enter each tag, then hit `RET' again after the last tag.
You can use completion to enter the bookmark name and each tag.

By default, the tag choices for completion are NOT refreshed, to save
time.  Use a prefix argument if you want to refresh them."
  (interactive
   (let* ((tgs    (bmkx-read-tags-completing nil nil current-prefix-arg))
          (alist  (bmkx-file-this-dir-some-tags-alist-only tgs)))
     (unless tgs (error "You did not specify any tags"))
     (unless alist (error "No file or dir bookmarks in this dir have any of the specified tags"))
     (list tgs (bmkx-completing-read "File bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-file-this-dir-some-tags-alist-only tags))
    (error "No file or dir bookmarks in this dir have any of the specified tags"))
  (bmkx-jump bookmark))

;;;###autoload (autoload 'bmkx-file-this-dir-some-tags-jump-other-window "bookmark-x")
(defun bmkx-file-this-dir-some-tags-jump-other-window (tags bookmark &optional interactivep) ; `C-x 4 j t . +'
  "`bmkx-file-this-dir-some-tags-jump', but in another window."
  (interactive
   (let* ((tgs    (bmkx-read-tags-completing nil nil current-prefix-arg))
          (alist  (bmkx-file-this-dir-some-tags-alist-only tgs)))
     (unless tgs (error "You did not specify any tags"))
     (unless alist (error "No file or dir bookmarks in this dir have any of the specified tags"))
     (list tgs (bmkx-completing-read "File bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-file-this-dir-some-tags-alist-only tags))
    (error "No file or dir bookmarks in this dir have any of the specified tags"))
  (bmkx-jump-other-window bookmark))

;;;###autoload (autoload 'bmkx-file-this-dir-some-tags-regexp-jump "bookmark-x")
(defun bmkx-file-this-dir-some-tags-regexp-jump (regexp bookmark &optional interactivep) ; `C-x j t . % +'
  "Jump to a file BOOKMARK in this dir that has a tag matching REGEXP.
You are prompted for the REGEXP.
Then you are prompted for the BOOKMARK (with completion)."
  (interactive
   (let* ((rgx    (bmkx-read-regexp "Regexp for tags: "))
          (alist  (bmkx-file-this-dir-some-tags-regexp-alist-only rgx)))
     (unless alist (error "No file or dir bookmarks in this dir have any tags that match `%s'" rgx))
     (list rgx (bmkx-completing-read "File bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-file-this-dir-some-tags-regexp-alist-only regexp))
    (error "No file or dir bookmarks in this dir have any tags that match `%s'" regexp))
  (bmkx-jump bookmark))

;;;###autoload (autoload 'bmkx-file-this-dir-some-tags-regexp-jump-other-window "bookmark-x")
(defun bmkx-file-this-dir-some-tags-regexp-jump-other-window (regexp bookmark &optional interactivep)
                                        ; `C-x 4 j t . % +'
  "`bmkx-file-this-dir-some-tags-regexp-jump', but in another window."
  (interactive
   (let* ((rgx    (bmkx-read-regexp "Regexp for tags: "))
          (alist  (bmkx-file-this-dir-some-tags-regexp-alist-only rgx)))
     (unless alist (error "No file or dir bookmarks in this dir have any tags that match `%s'" rgx))
     (list rgx (bmkx-completing-read "File bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-file-this-dir-some-tags-regexp-alist-only regexp))
    (error "No file or dir bookmarks in this dir have any tags that match `%s'" regexp))
  (bmkx-jump-other-window bookmark))

;;;###autoload (autoload 'bmkx-autofile-jump "bookmark-x")
(defun bmkx-autofile-jump (bookmark)    ; `C-x j a'
  "Jump to an autofile bookmark.
This is a specialization of `bmkx-jump'."
  (interactive
   (let ((alist  (bmkx-autofile-alist-only)))
     (list (bmkx-read-bookmark-for-type "autofile" alist nil nil 'bmkx-autofile-history))))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-autofile-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx--pop-to-buffer-same-window))

;;;###autoload (autoload 'bmkx-autofile-jump-other-window "bookmark-x")
(defun bmkx-autofile-jump-other-window (bookmark) ; `C-x 4 j a'
  "`bmkx-autofile-jump' but in another window."
  (interactive
   (let ((alist  (bmkx-autofile-alist-only)))
     (list (bmkx-read-bookmark-for-type "autofile" alist t nil 'bmkx-autofile-history))))
  (when (stringp bookmark)
    (setq bookmark  (bmkx-get-bookmark-in-alist bookmark 'NOERROR (bmkx-autofile-alist-only))))
  (bmkx-jump-1 bookmark 'bmkx-select-buffer-other-window))

;;;###autoload (autoload 'bmkx-autofile-all-tags-jump "bookmark-x")
(defun bmkx-autofile-all-tags-jump (tags bookmark &optional interactivep) ; `C-x j t a *'
  "Jump to an autofile BOOKMARK in this dir that has all of the TAGS.
Hit `RET' to enter each tag, then hit `RET' again after the last tag.
You can use completion to enter the bookmark name and each tag.
If you specify no tags, then every bookmark that has some tags is a
candidate.

By default, the tag choices for completion are NOT refreshed, to save
time.  Use a prefix argument if you want to refresh them."
  (interactive
   (let* ((tgs    (bmkx-read-tags-completing nil nil current-prefix-arg))
          (alist  (bmkx-autofile-all-tags-alist-only tgs)))
     (unless alist (error "No autofile bookmarks have all of the specified tags"))
     (list tgs (bmkx-completing-read "File bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-autofile-all-tags-alist-only tags))
    (error "No autofile bookmarks have all of the specified tags"))
  (bmkx-jump bookmark))

;;;###autoload (autoload 'bmkx-autofile-all-tags-jump-other-window "bookmark-x")
(defun bmkx-autofile-all-tags-jump-other-window (tags bookmark &optional interactivep) ; `C-x 4 j t a *'
  "`bmkx-autofile-all-tags-jump', but in another window."
  (interactive
   (let* ((tgs    (bmkx-read-tags-completing nil nil current-prefix-arg))
          (alist  (bmkx-autofile-all-tags-alist-only tgs)))
     (unless alist (error "No autofile bookmarks have all of the specified tags"))
     (list tgs (bmkx-completing-read "File bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-autofile-all-tags-alist-only tags))
    (error "No autofile bookmarks have all of the specified tags"))
  (bmkx-jump-other-window bookmark))

;;;###autoload (autoload 'bmkx-autofile-all-tags-regexp-jump "bookmark-x")
(defun bmkx-autofile-all-tags-regexp-jump (regexp bookmark &optional interactivep) ; `C-x j t a % *'
  "Jump to an autofile BOOKMARK in this dir that has each tag matching REGEXP.
You are prompted for the REGEXP.
Then you are prompted for the BOOKMARK (with completion)."
  (interactive
   (let* ((rgx    (bmkx-read-regexp "Regexp for tags: "))
          (alist  (bmkx-autofile-all-tags-regexp-alist-only rgx)))
     (unless alist (error "No autofile bookmarks have tags that all match `%s'" rgx))
     (list rgx (bmkx-completing-read "File bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-autofile-all-tags-regexp-alist-only regexp))
    (error "No autofile bookmarks have tags that all match `%s'" regexp))
  (bmkx-jump bookmark))

;;;###autoload (autoload 'bmkx-autofile-all-tags-regexp-jump-other-window "bookmark-x")
(defun bmkx-autofile-all-tags-regexp-jump-other-window (regexp bookmark &optional interactivep)
                                        ; `C-x 4 j t a % *'
  "`bmkx-autofile-all-tags-regexp-jump', but in another window."
  (interactive
   (let* ((rgx    (bmkx-read-regexp "Regexp for tags: "))
          (alist  (bmkx-autofile-all-tags-regexp-alist-only rgx)))
     (unless alist (error "No autofile bookmarks have tags that all match `%s'" rgx))
     (list rgx (bmkx-completing-read "File bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-autofile-all-tags-regexp-alist-only regexp))
    (error "No autofile bookmarks have tags that all match `%s'" regexp))
  (bmkx-jump-other-window bookmark))

;;;###autoload (autoload 'bmkx-autofile-some-tags-jump "bookmark-x")
(defun bmkx-autofile-some-tags-jump (tags bookmark &optional interactivep) ; `C-x j t a +'
  "Jump to an autofile BOOKMARK in this dir that has at least one of the TAGS.
Hit `RET' to enter each tag, then hit `RET' again after the last tag.
You can use completion to enter the bookmark name and each tag.

By default, the tag choices for completion are NOT refreshed, to save
time.  Use a prefix argument if you want to refresh them."
  (interactive
   (let* ((tgs    (bmkx-read-tags-completing nil nil current-prefix-arg))
          (alist  (bmkx-autofile-some-tags-alist-only tgs)))
     (unless tgs (error "You did not specify any tags"))
     (unless alist (error "No autofile bookmarks have any of the specified tags"))
     (list tgs (bmkx-completing-read "File bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-autofile-some-tags-alist-only tags))
    (error "No autofile bookmarks have any of the specified tags"))
  (bmkx-jump bookmark))

;;;###autoload (autoload 'bmkx-autofile-some-tags-jump-other-window "bookmark-x")
(defun bmkx-autofile-some-tags-jump-other-window (tags bookmark &optional interactivep) ; `C-x 4 j t a +'
  "`bmkx-autofile-some-tags-jump', but in another window."
  (interactive
   (let* ((tgs    (bmkx-read-tags-completing nil nil current-prefix-arg))
          (alist  (bmkx-autofile-some-tags-alist-only tgs)))
     (unless tgs (error "You did not specify any tags"))
     (unless alist (error "No autofile bookmarks have any of the specified tags"))
     (list tgs (bmkx-completing-read "File bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (bmkx-autofile-some-tags-alist-only tags))
    (error "No autofile bookmarks have any of the specified tags"))
  (bmkx-jump-other-window bookmark))

;;;###autoload (autoload 'bmkx-autofile-some-tags-regexp-jump "bookmark-x")
(defun bmkx-autofile-some-tags-regexp-jump (regexp bookmark &optional interactivep) ; `C-x j t a % +'
  "Jump to an autofile BOOKMARK in this dir that has a tag matching REGEXP.
You are prompted for the REGEXP.
Then you are prompted for the BOOKMARK (with completion)."
  (interactive
   (let* ((rgx    (bmkx-read-regexp "Regexp for tags: "))
          (alist  (bmkx-autofile-some-tags-regexp-alist-only rgx)))
     (unless alist (error "No autofile bookmarks have any tags that match `%s'" rgx))
     (list rgx (bmkx-completing-read "File bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (error "No autofile bookmarks have any tags that match `%s'" regexp))
    (error "No autofile bookmarks have any tags that match `%s'" regexp))
  (bmkx-jump bookmark))

;;;###autoload (autoload 'bmkx-autofile-some-tags-regexp-jump-other-window "bookmark-x")
(defun bmkx-autofile-some-tags-regexp-jump-other-window (regexp bookmark &optional interactivep)
                                        ; `C-x 4 j t a % +'
  "`bmkx-autofile-some-tags-regexp-jump', but in another window."
  (interactive
   (let* ((rgx    (bmkx-read-regexp "Regexp for tags: "))
          (alist  (bmkx-autofile-some-tags-regexp-alist-only rgx)))
     (unless alist (error "No autofile bookmarks have any tags that match `%s'" rgx))
     (list rgx (bmkx-completing-read "File bookmark" (bmkx-default-bookmark-name alist) alist) t)))
  (unless (or interactivep  (error "No autofile bookmarks have any tags that match `%s'" regexp))
    (error "No autofile bookmarks have any tags that match `%s'" regexp))
  (bmkx-jump-other-window bookmark))

(defun bmkx-find-file (&optional file create-autofile-p must-exist-p msg-p) ; `C-x j C-f'
  "Visit a file or directory, respecting any associated autofile handlers.
You are prompted for the file or directory name, FILE.

If FILE matches an entry in `bmkx-default-handlers-for-file-types'
then use the associated default handler to access the file.
Otherwise, just use `find-file'.

With a prefix arg, create an autofile bookmark if FILE does not
already have one.

Non-interactively:
* Non-nil MUST-EXIST-P means raise an error if FILE has no autofile
  bookmark.
* Non-nil MSG-P means display a status message."
  (interactive "i\nP\ni\np")
  (let* ((use-file-dialog                             nil)
         (fil                                         (or file  (read-file-name "Find file: " nil nil t)))
         (dir-to-use                                  (if (file-name-absolute-p fil)
                                                          (file-name-directory fil)
                                                        default-directory))
         (bmk                                         (bmkx-get-autofile-bookmark fil)))
    (if bmk
        (bmkx-jump bmk)
      (when must-exist-p (error "File `%s' is not an autofile (no bookmark)" fil))
      (when create-autofile-p           ; Create a new bookmark.
        (bmkx-file-target-set (expand-file-name fil dir-to-use) t nil 'NO-OVERWRITE msg-p)
        (when msg-p (message "Autofile bookmark set for `%s'" fil)))
      (let ((default-handler  (condition-case nil (bmkx-default-handler-for-file fil) (error nil))))
        (if default-handler (funcall default-handler fil) (find-file fil 'WILDCARDS))))))

(defun bmkx-find-file-other-window (&optional file create-autofile-p must-exist-p msg-p) ; `C-x 4 j C-f'
  "`bmkx-find-file', but in another window."
  (interactive "i\nP\ni\np")
  (let* ((use-file-dialog                             nil)
         (fil                                         (or file  (read-file-name "Find file: " nil nil t)))
         (dir-to-use                                  (if (file-name-absolute-p fil)
                                                          (file-name-directory fil)
                                                        default-directory))
         (bmk                                         (bmkx-get-autofile-bookmark fil dir-to-use)))
    (if bmk
        (bmkx-jump-other-window bmk)
      (when must-exist-p (error "File `%s' is not an autofile (no bookmark)" fil))
      (when create-autofile-p           ; Create a new bookmark.
        (bmkx-file-target-set (expand-file-name fil dir-to-use) t nil 'NO-OVERWRITE msg-p)
        (when msg-p (message "Autofile bookmark created for `%s'" fil)))
      (let ((default-handler  (condition-case nil (bmkx-default-handler-for-file fil) (error nil))))
        (if default-handler (funcall default-handler fil) (find-file-other-window fil 'WILDCARDS))))))


;;; We could allow these even for Emacs 20 for Icicles users,
;;; but the predicate would have no effect when not in Icicle mode.  So don't bother with Emacs 20.

(progn ; Needs `read-file-name' with a PREDICATE arg.
  (defun bmkx-find-file-all-tags (tags &optional file) ; `C-x j t C-f *'
    "Visit a file or directory that has all of the TAGS.
You are prompted first for the tags.  Hit `RET' to enter each tag,
then hit `RET' again after the last tag.  You can use completion to
enter each tag.  This completion is lax: you are not limited to
existing tags.

You are then prompted for the file name.  This is read using
`read-file-name', so you can browse up and down the file hierarchy.
The completion candidates are file names, not bookmark names.
However, only files that are bookmarked as autofiles are candidates.

If you specify no tags, then every file that has some tags is a
candidate.

By default, the tag choices for completion are NOT refreshed, to save
time.  Use a prefix argument if you want to refresh them."
    (interactive (list (bmkx-read-tags-completing nil nil current-prefix-arg)))
    (let* ((tgs              tags)
                   (use-file-dialog  nil)
                   (pred
                    (lambda (ff)
                      (let* ((bmk   (bmkx-get-autofile-bookmark ff))
                                     (btgs  (and bmk  (bmkx-get-tags bmk))))
                        (and btgs  (bmkx-every (lambda (tag) (bmkx-has-tag-p bmk tag))  tgs)))))
                   (fil                                         (or (and file  (funcall pred file)  file)
                                                                    (read-file-name
                                                                     "Find file: " nil nil t nil
                                                                     pred)))
                   (bmk                                         (bmkx-get-autofile-bookmark fil)))
      (when bmk  (bmkx-jump bmk)))))

(progn ; Needs `read-file-name' with a PREDICATE arg.
  (defun bmkx-find-file-all-tags-other-window (tags &optional file) ; `C-x 4 j t C-f *'
    "`bmkx-find-file-all-tags', but in another window."
    (interactive (list (bmkx-read-tags-completing nil nil current-prefix-arg)))
    (let* ((tgs              tags)
                   (use-file-dialog  nil)
                   (pred
                    (lambda (ff)
                      (let* ((bk    (bmkx-get-autofile-bookmark ff))
                                     (btgs  (and bk  (bmkx-get-tags bk))))
                        (and btgs  (bmkx-every (lambda (tag) (bmkx-has-tag-p bk tag))  tgs)))))
                   (fil                                         (or (and file  (funcall pred file)  file)
                                                                    (read-file-name
                                                                     "Find file: " nil nil t nil
                                                                     pred)))
                   (bmk                                         (bmkx-get-autofile-bookmark fil)))
      (bmkx-jump-other-window bmk))))

(progn ; Needs `read-file-name' with a PREDICATE arg.
  (defun bmkx-find-file-all-tags-regexp (regexp &optional file) ; `C-x j t C-f % *'
    "Visit a file or directory that has each tag matching REGEXP.
You are prompted for the REGEXP."
    (interactive (list (bmkx-read-regexp "Regexp for tags: ")))
    (let* ((rg               regexp)
                   (use-file-dialog  nil)
                   (pred
                    (lambda (ff)
                      (let* ((bk    (bmkx-get-autofile-bookmark ff))
                             (btgs  (and bk  (bmkx-get-tags bk))))
                        (and btgs  (bmkx-every (lambda (tag) (string-match-p rg (bmkx-tag-name tag)))
                                               btgs)))))
                   (fil                                         (or (and file  (funcall pred file)  file)
                                                                    (read-file-name
                                                                     "Find file: " nil nil t nil
                                                                     pred)))
                   (bmk                                         (bmkx-get-autofile-bookmark fil)))
      (bmkx-jump bmk))))

;;;###autoload (autoload 'bmkx-find-file-all-tags-regexp-other-window "bookmark-x")
(progn ; Needs `read-file-name' with a PREDICATE arg.
  (defun bmkx-find-file-all-tags-regexp-other-window (regexp &optional file) ; `C-x 4 j t C-f % *'
    "`bmkx-find-file-all-tags-regexp', but in another window."
    (interactive (list (bmkx-read-regexp "Regexp for tags: ")))
    (let* ((rg               regexp)
                   (use-file-dialog  nil)
                   (pred
                    (lambda (ff)
                      (let* ((bk    (bmkx-get-autofile-bookmark ff))
                             (btgs  (and bk  (bmkx-get-tags bk))))
                        (and btgs  (bmkx-every (lambda (tag) (string-match-p rg (bmkx-tag-name tag)))
                                               btgs)))))
                   (fil                                         (or (and file  (funcall pred file)  file)
                                                                    (read-file-name
                                                                     "Find file: " nil nil t nil
                                                                     pred)))
                   (bmk                                         (bmkx-get-autofile-bookmark fil)))
      (bmkx-jump-other-window bmk))))

;;;###autoload (autoload 'bmkx-find-file-some-tags "bookmark-x")
(progn ; Needs `read-file-name' with a PREDICATE arg.
  (defun bmkx-find-file-some-tags (tags &optional file) ; `C-x j t C-f +'
    "Visit a file or directory that has at least one of the TAGS.
You are prompted first for the tags.  Hit `RET' to enter each tag,
then hit `RET' again after the last tag.  You can use completion to
enter each tag.  This completion is lax: you are not limited to
existing tags.

You are then prompted for the file name.  This is read using
`read-file-name', so you can browse up and down the file hierarchy.
The completion candidates are file names, not bookmark names.
However, only files that are bookmarked as autofiles are candidates.

By default, the tag choices for completion are NOT refreshed, to save
time.  Use a prefix argument if you want to refresh them."
    (interactive (list (bmkx-read-tags-completing nil nil current-prefix-arg)))
    (let* ((tgs              tags)
                   (use-file-dialog  nil)
                   (pred
                    (lambda (ff)
                      (let* ((bk    (bmkx-get-autofile-bookmark ff))
                                     (btgs  (and bk  (bmkx-get-tags bk))))
                        (and btgs  (bmkx-some (lambda (tag) (bmkx-has-tag-p bk tag))  tgs)))))
                   (fil                                         (or (and file  (funcall pred file)  file)
                                                                    (read-file-name
                                                                     "Find file: " nil nil t nil
                                                                     pred)))
                   (bmk                                         (bmkx-get-autofile-bookmark fil)))
      (bmkx-jump bmk))))

;;;###autoload (autoload 'bmkx-find-file-some-tags-other-window "bookmark-x")
(progn ; Needs `read-file-name' with a PREDICATE arg.
  (defun bmkx-find-file-some-tags-other-window (tags &optional file) ; `C-x 4 j t C-f +'
    "`bmkx-find-file-some-tags', but in another window."
    (interactive (list (bmkx-read-tags-completing nil nil current-prefix-arg)))
    (let* ((tgs              tags)
                   (use-file-dialog  nil)
                   (pred
                    (lambda (ff)
                      (let* ((bk    (bmkx-get-autofile-bookmark ff))
                                     (btgs  (and bk  (bmkx-get-tags bk))))
                        (and btgs  (bmkx-some (lambda (tag) (bmkx-has-tag-p bk tag))  tgs)))))
                   (fil                                         (or (and file  (funcall pred file)  file)
                                                                    (read-file-name
                                                                     "Find file: " nil nil t nil
                                                                     pred)))
                   (bmk                                         (bmkx-get-autofile-bookmark fil)))
      (bmkx-jump-other-window bmk))))

;;;###autoload (autoload 'bmkx-find-file-some-tags-regexp "bookmark-x")
(progn ; Needs `read-file-name' with a PREDICATE arg.
  (defun bmkx-find-file-some-tags-regexp (regexp &optional file) ; `C-x j t C-f % +'
    "Visit a file or directory that has a tag matching REGEXP.
You are prompted for the REGEXP."
    (interactive (list (bmkx-read-regexp "Regexp for tags: ")))
    (let* ((rg               regexp)
                   (use-file-dialog  nil)
                   (pred
                    (lambda (ff)
                      (let* ((bk    (bmkx-get-autofile-bookmark ff))
                             (btgs  (and bk  (bmkx-get-tags bk))))
                        (and btgs  (bmkx-some (lambda (tag) (string-match-p rg (bmkx-tag-name tag)))
                                              btgs)))))
                   (fil                                         (or (and file  (funcall pred file)  file)
                                                                    (read-file-name
                                                                     "Find file: " nil nil t nil
                                                                     pred)))
                   (bmk                                         (bmkx-get-autofile-bookmark fil)))
      (bmkx-jump bmk))))

;;;###autoload (autoload 'bmkx-find-file-some-tags-regexp-other-window "bookmark-x")
(progn ; Needs `read-file-name' with a PREDICATE arg.
  (defun bmkx-find-file-some-tags-regexp-other-window (regexp &optional file) ; `C-x 4 j t C-f % +'
    "`bmkx-find-file-some-tags-regexp', but in another window."
    (interactive (list (bmkx-read-regexp "Regexp for tags: ")))
    (let* ((rg               regexp)
                   (use-file-dialog  nil)
                   (pred
                    (lambda (ff)
                      (let* ((bk    (bmkx-get-autofile-bookmark ff))
                             (btgs  (and bk  (bmkx-get-tags bk))))
                        (and btgs  (bmkx-some (lambda (tag) (string-match-p rg (bmkx-tag-name tag)))
                                              btgs)))))
                   (fil                                         (or (and file  (funcall pred file)  file)
                                                                    (read-file-name
                                                                     "Find file: " nil nil t nil
                                                                     pred)))
                   (bmk                                         (bmkx-get-autofile-bookmark fil)))
      (bmkx-jump-other-window bmk))))

;;;###autoload (autoload 'bmkx-jump-in-navlist "bookmark-x")
(defun bmkx-jump-in-navlist (bookmark-name &optional flip-use-region-p) ; `C-x j N'
  "Jump to a bookmark, choosing from those in the navigation list."
  (interactive
   (progn (unless bmkx-nav-alist
            (bmkx-maybe-load-default-file)
            (setq bmkx-nav-alist  bookmark-alist)
            (unless bmkx-nav-alist (error "No bookmarks"))
            (setq bmkx-current-nav-bookmark  (car bmkx-nav-alist))
            (message "Bookmark navigation list is now the global bookmark list") (sit-for 2))
          (let ((bookmark-alist  bmkx-nav-alist))
            (list (bmkx-completing-read "Jump to bookmark" (bmkx-default-bookmark-name))
                  current-prefix-arg))))
  (bmkx-jump-1 bookmark-name 'bmkx--pop-to-buffer-same-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-jump-in-navlist-other-window "bookmark-x")
(defun bmkx-jump-in-navlist-other-window (bookmark-name &optional flip-use-region-p) ; `C-x 4 j N'
  "Same as `bmkx-jump-in-navlist', but use another window."
  (interactive
   (progn (unless bmkx-nav-alist
            (bmkx-maybe-load-default-file)
            (setq bmkx-nav-alist  bookmark-alist)
            (unless bmkx-nav-alist (error "No bookmarks"))
            (setq bmkx-current-nav-bookmark  (car bmkx-nav-alist))
            (message "Bookmark navigation list is now the global bookmark list") (sit-for 2))
          (let ((bookmark-alist  bmkx-nav-alist))
            (list (bmkx-completing-read "Jump to bookmark (in another window)"
                                            (bmkx-default-bookmark-name))
                  current-prefix-arg))))
  (bmkx-jump-1 bookmark-name 'bmkx-select-buffer-other-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-cycle "bookmark-x")
(defun bmkx-cycle (increment &optional other-window startoverp)
  "Cycle through bookmarks in the navlist by INCREMENT (default: 1).
Positive INCREMENT cycles forward.  Negative INCREMENT cycles backward.
Interactively, the prefix arg determines INCREMENT:
 Plain `C-u': 1
 otherwise: the numeric prefix arg value

Plain `C-u' also means start over at first bookmark.

You can set the navigation list using commands
 `bmkx-choose-navlist-from-bookmark-list' and
 `bmkx-choose-navlist-of-type'.

You can cycle among bookmarks in the current buffer using
 `bmkx-cycle-this-buffer' and
 `bmkx-cycle-this-buffer-other-window.'

In Lisp code:
 Non-nil OTHER-WINDOW means jump to the bookmark in another window.
 Non-nil STARTOVERP means reset `bmkx-current-nav-bookmark' to the
 first bookmark in the navlist."
  (interactive (let ((startovr  (consp current-prefix-arg)))
                 (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) nil startovr)))
  (unless bmkx-nav-alist
    (bmkx-maybe-load-default-file)
    (when (and bookmark-alist  (y-or-n-p "No navigation list.  Use whole bookmark list? "))
      (setq bmkx-nav-alist  bookmark-alist)
      (message "Navigation list is now the global bookmark list") (sit-for 2))
    (unless bmkx-nav-alist (error "No bookmarks in navigation list"))
    (setq bmkx-current-nav-bookmark  (car bmkx-nav-alist)))
  (unless (and bmkx-current-nav-bookmark  (not startoverp)
               (bmkx-get-bookmark bmkx-current-nav-bookmark 'NOERROR))
    (setq bmkx-current-nav-bookmark  (car bmkx-nav-alist)))
  (if (bmkx-cycle-1 increment other-window startoverp)
      (unless (or (bmkx-sequence-bookmark-p bmkx-current-nav-bookmark)
                  (bmkx-function-bookmark-p bmkx-current-nav-bookmark))
        (message "Position: %9d, Bookmark: `%s'"
                 (point) (bmkx-bookmark-name-from-record bmkx-current-nav-bookmark)))
    (message "Invalid bookmark: `%s'" (bmkx-bookmark-name-from-record bmkx-current-nav-bookmark))))

;;;###autoload (autoload 'bmkx-cycle-other-window "bookmark-x")
(defun bmkx-cycle-other-window (increment &optional startoverp)
  "Same as `bmkx-cycle' but uses another window."
  (interactive "p")
  (bmkx-cycle increment 'OTHER-WINDOW startoverp))

;;;###autoload (autoload 'bmkx-cycle-this-file/buffer "bookmark-x")
(defun bmkx-cycle-this-file/buffer (increment &optional other-window startoverp)
  "Cycle through bookmarks for this file/buffer by INCREMENT (default: 1).
If visiting a file, this is `bmkx-cycle-this-file'.
Otherwise, this is `bmkx-cycle-this-buffer'."
  (interactive (let ((startovr  (consp current-prefix-arg)))
                 (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) nil startovr)))
  (if (buffer-file-name)
      (bmkx-cycle-this-file increment other-window startoverp)
    (bmkx-cycle-this-buffer increment other-window startoverp)))

;;;###autoload (autoload 'bmkx-cycle-this-file/buffer-other-window "bookmark-x")
(defun bmkx-cycle-this-file/buffer-other-window (increment &optional startoverp)
  "Same as `bmkx-cycle-this-file/buffer' but use other window."
  (interactive (let ((startovr  (consp current-prefix-arg)))
                 (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) startovr)))
  (bmkx-cycle-this-file/buffer increment 'OTHER-WINDOW startoverp))

;;;###autoload (autoload 'bmkx-cycle-this-file "bookmark-x")
(defun bmkx-cycle-this-file (increment &optional other-window startoverp)
  "Cycle through bookmarks for this file by INCREMENT (default: 1).
Positive INCREMENT cycles forward.  Negative INCREMENT cycles backward.
Interactively, the prefix arg determines INCREMENT:
 Plain `C-u': 1
 otherwise: the numeric prefix arg value

Plain `C-u' also means start over at first bookmark.

You can cycle among bookmarks beyond the current file using
`bmkx-cycle' and `bmkx-cycle-other-window.'

You can set your preferred sort order for this-file bookmarks by
customizing option `bmkx-this-file/buffer-cycle-sort-comparer'.

To change the sort order without customizing, you can use \
`\\[bmkx-this-file-bmenu-list]' to
show the `*Bmkx List*' with only this file's bookmarks, sort
them there, and use `\\[bmkx-choose-navlist-from-bookmark-list]', choosing \
`CURRENT *Bmkx List*' as
the navigation list.

Then you can cycle the bookmarks using `bmkx-cycle'
\(`\\[bmkx-next-bookmark-repeat]' etc.), instead of `bmkx-cycle-this-file'.

In Lisp code:
 Non-nil OTHER-WINDOW means jump to the bookmark in another window.
 Non-nil STARTOVERP means reset `bmkx-current-nav-bookmark' to the
 first bookmark in the navlist."
  (interactive (let ((startovr  (consp current-prefix-arg)))
                 (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) nil startovr)))
  (bmkx-maybe-load-default-file)
  (let ((bmkx-sort-comparer  bmkx-this-file/buffer-cycle-sort-comparer))
    (setq bmkx-nav-alist  (bmkx-sort-omit (bmkx-this-file-alist-only))))
  (unless bmkx-nav-alist (error "No bookmarks for this file"))
  (unless (and bmkx-current-nav-bookmark  (not startoverp)
               (bmkx-get-bookmark bmkx-current-nav-bookmark 'NOERROR)
               (bmkx-this-file-p bmkx-current-nav-bookmark)) ; Exclude desktops etc.
    (setq bmkx-current-nav-bookmark  (car bmkx-nav-alist)))
  (if (bmkx-cycle-1 increment other-window startoverp)
      (unless (or (bmkx-sequence-bookmark-p bmkx-current-nav-bookmark)
                  (bmkx-function-bookmark-p bmkx-current-nav-bookmark))
        (message "Position: %9d, Bookmark: `%s'"
                 (point) (bmkx-bookmark-name-from-record bmkx-current-nav-bookmark)))
    (message "Invalid bookmark: `%s'" (bmkx-bookmark-name-from-record bmkx-current-nav-bookmark))))

;;;###autoload (autoload 'bmkx-cycle-this-file-other-window "bookmark-x")
(defun bmkx-cycle-this-file-other-window (increment &optional startoverp)
  "Same as `bmkx-cycle-this-file' but use other window."
  (interactive (let ((startovr  (consp current-prefix-arg)))
                 (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) startovr)))
  (bmkx-cycle-this-file increment 'OTHER-WINDOW startoverp))

;;;###autoload (autoload 'bmkx-cycle-this-buffer "bookmark-x")
(defun bmkx-cycle-this-buffer (increment &optional other-window startoverp)
  "Cycle through bookmarks in this buffer by INCREMENT (default: 1).
Positive INCREMENT cycles forward.  Negative INCREMENT cycles backward.
Interactively, the prefix arg determines INCREMENT:
 Plain `C-u': 1
 otherwise: the numeric prefix arg value

Plain `C-u' also means start over at first bookmark.

You can cycle among bookmarks beyond the current buffer using
`bmkx-cycle' and `bmkx-cycle-other-window.'

You can set your preferred sort order for this-buffer bookmarks by
customizing option `bmkx-this-file/buffer-cycle-sort-comparer'.

To change the sort order without customizing, you can use \
`\\[bmkx-this-buffer-bmenu-list]' to
show the `*Bmkx List*' with only this buffer's bookmarks, sort
them there, and use `\\[bmkx-choose-navlist-from-bookmark-list]', choosing \
`CURRENT *Bmkx List*' as
the navigation list.

Then you can cycle the bookmarks using `bmkx-cycle'
\(`\\[bmkx-next-bookmark-repeat]' etc.), instead of `bmkx-cycle-this-buffer'.

In Lisp code:
 Non-nil OTHER-WINDOW means jump to the bookmark in another window.
 Non-nil STARTOVERP means reset `bmkx-current-nav-bookmark' to the
 first bookmark in the navlist."
  (interactive (let ((startovr  (consp current-prefix-arg)))
                 (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) nil startovr)))
  (bmkx-maybe-load-default-file)
  (let ((bmkx-sort-comparer  bmkx-this-file/buffer-cycle-sort-comparer))
    (setq bmkx-nav-alist  (bmkx-sort-omit (bmkx-this-buffer-alist-only))))
  (unless bmkx-nav-alist (error "No bookmarks in this buffer"))
  (unless (and bmkx-current-nav-bookmark  (not startoverp)
               (bmkx-get-bookmark bmkx-current-nav-bookmark 'NOERROR)
               (bmkx-this-buffer-p bmkx-current-nav-bookmark)) ; Exclude desktops etc.
    (setq bmkx-current-nav-bookmark  (car bmkx-nav-alist)))
  (if (bmkx-cycle-1 increment other-window startoverp)
      (unless (or (bmkx-sequence-bookmark-p bmkx-current-nav-bookmark)
                  (bmkx-function-bookmark-p bmkx-current-nav-bookmark))
        (message "Position: %9d, Bookmark: `%s'"
                 (point) (bmkx-bookmark-name-from-record bmkx-current-nav-bookmark)))
    (message "Invalid bookmark: `%s'" (bmkx-bookmark-name-from-record bmkx-current-nav-bookmark))))

;;;###autoload (autoload 'bmkx-cycle-this-buffer-other-window "bookmark-x")
(defun bmkx-cycle-this-buffer-other-window (increment &optional startoverp)
  "Same as `bmkx-cycle-this-buffer' but use other window."
  (interactive (let ((startovr  (consp current-prefix-arg)))
                 (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) startovr)))
  (bmkx-cycle-this-buffer increment 'OTHER-WINDOW startoverp))

(defun bmkx-cycle-1 (increment &optional other-window startoverp)
  "Helper for `bmkx-cycle*' commands.
Do nothing if `bmkx-current-nav-bookmark' is an invalid bookmark.
Return `bmkx-current-nav-bookmark', or nil if invalid.

NOTE: If `pop-up-frames' is non-nil, then cycling inhibits automatic
showing of annotations (`bookmark-automatically-show-annotations').
This is to prevent change of frame focus, so cycling can continue
properly.

See `bmkx-cycle' for descriptions of the arguments."
  (let ((bookmark-alist   bmkx-nav-alist)
        (bookmark         (bmkx-get-bookmark bmkx-current-nav-bookmark 'NOERROR))
        (bmkx-use-region  (eq 'cycling-too bmkx-use-region)))
    (unless bookmark-alist (error "No bookmarks for cycling"))
    (when bookmark                      ; Skip bookmarks with bad names.
      (setq bmkx-current-nav-bookmark
            (if startoverp
                (car bookmark-alist)
              (let ((index  (bmkx-list-position bookmark bookmark-alist #'eq)))
                (if index
                    (nth (mod (+ increment index) (length bookmark-alist)) bookmark-alist)
                  (message "bmkx-cycle-1: Bookmark `%s' is not in navlist"
                           (bmkx-bookmark-name-from-record bmkx-current-nav-bookmark))
                  (car bookmark-alist)))))
      (let ((bookmark-automatically-show-annotations ; Prevent possible frame focus change.
             (and bookmark-automatically-show-annotations  (not pop-up-frames))))
        (if other-window
            (bmkx-jump-other-window (bmkx-bookmark-name-from-record bmkx-current-nav-bookmark))
          (save-selected-window (bmkx-bookmark-name-from-record (bmkx-jump bmkx-current-nav-bookmark))))))
    (and bookmark  bmkx-current-nav-bookmark))) ; Return nil if not a valid bookmark.

;; Same as `icicle-list-position' in `icicles-fn.el'.
;; Simple version of `cl-position' for all Emacs versions.
(defun bmkx-list-position (item items &optional test)
  "Find the first occurrence of ITEM in list ITEMS.
Return the index of the matching item, or nil if not found.
Items are compared using binary predicate TEST, or `equal' if TEST is
nil."
  (unless test (setq test  'equal))
  (let ((pos  0))
    (catch 'bmkx-list-position
      (dolist (itm  items)
        (when (funcall test item itm) (throw 'bmkx-list-position pos))
        (setq pos  (1+ pos)))
      nil)))

;;;###autoload (autoload 'bmkx-next-bookmark "bookmark-x")
(defun bmkx-next-bookmark (n &optional startoverp) ; You can bind this to a repeatable key
  "Jump to the Nth next bookmark in the bookmark navigation list.
N defaults to 1, meaning the next bookmark.
Plain `C-u' means start over at first bookmark.
See also `bmkx-cycle'."
  (interactive (let ((startovr  (consp current-prefix-arg)))
                 (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) startovr)))
  (bmkx-cycle n nil startoverp))

;;;###autoload (autoload 'bmkx-previous-bookmark "bookmark-x")
(defun bmkx-previous-bookmark (n &optional startoverp) ; You can bind this to a repeatable key
  "Jump to the Nth previous bookmark in the bookmark navigation list.
See `bmkx-next-bookmark'."
  (interactive (let ((startovr  (consp current-prefix-arg)))
                 (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) startovr)))
  (bmkx-cycle (- n) nil startoverp))

;;;###autoload (autoload 'bmkx-next-bookmark-other-window "bookmark-x")
(defun bmkx-next-bookmark-other-window (n &optional startoverp) ; You can bind this to a repeatable key
  "Jump to Nth next bookmark in bookmark navlist in another window.
N defaults to 1, meaning the next bookmark.
Plain `C-u' means start over at first bookmark.
See also `bmkx-cycle'."
  (interactive (let ((startovr  (consp current-prefix-arg)))
                 (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) startovr)))
  (bmkx-cycle n 'OTHER-WINDOW startoverp))

;;;###autoload (autoload 'bmkx-previous-bookmark-other-window "bookmark-x")
(defun bmkx-previous-bookmark-other-window (n &optional startoverp) ; You can bind this to a repeatable key
  "Jump to Nth previous bookmark in bookmark navlist in another window.
See `bmkx-next-bookmark'."
  (interactive (let ((startovr  (consp current-prefix-arg)))
                 (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) startovr)))
  (bmkx-cycle (- n) 'OTHER-WINDOW startoverp))

;;;###autoload (autoload 'bmkx-next-bookmark-repeat "bookmark-x")
(defun bmkx-next-bookmark-repeat ()  ; `C-x x right', `C-x x f', `C-x x C-f'
  "Jump to the next bookmark in the bookmark navigation list.
This is a repeatable version of `bmkx-next-bookmark'."
  (interactive "P")
  (bmkx-repeat-command 'bmkx-next-bookmark))

;;;###autoload (autoload 'bmkx-previous-bookmark-repeat "bookmark-x")
(defun bmkx-previous-bookmark-repeat () ; `C-x x left', `C-x x b', `C-x x C-b'
  "Jump to the previous bookmark in the bookmark navigation list.
See `bmkx-next-bookmark-repeat'."
  (interactive "P")
  (bmkx-repeat-command 'bmkx-previous-bookmark))

;;;###autoload (autoload 'bmkx-next-bookmark-other-window-repeat "bookmark-x")
(defun bmkx-next-bookmark-other-window-repeat ()  ; `C-x x right', `C-x x f', `C-x x C-f'
  "Jump to next bookmark in bookmark navlist in another window.
This is a repeatable version of `bmkx-next-bookmark'."
  (interactive "P")
  (bmkx-repeat-command 'bmkx-next-bookmark-other-window))

;;;###autoload (autoload 'bmkx-previous-bookmark-other-window-repeat "bookmark-x")
(defun bmkx-previous-bookmark-other-window-repeat () ; `C-x x left', `C-x x b', `C-x x C-b'
  "Jump to previous bookmark in bookmark navlist in another window.
See `bmkx-next-bookmark-repeat'."
  (interactive "P")
  (bmkx-repeat-command 'bmkx-previous-bookmark-other-window))

;;;###autoload (autoload 'bmkx-next-bookmark-this-file/buffer "bookmark-x")
(defun bmkx-next-bookmark-this-file/buffer (n &optional startoverp) ; Bind to repeatable key, e.g. `S-f2'
  "Jump to the Nth-next bookmark for the current file/buffer.
N defaults to 1, meaning the next one.
Plain `C-u' means start over at the first one.
See also `bmkx-cycle-this-file/buffer'."
  (interactive (let ((startovr  (consp current-prefix-arg)))
                 (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) startovr)))
  (bmkx-cycle-this-file/buffer n nil startoverp))

;;;###autoload (autoload 'bmkx-previous-bookmark-this-file/buffer "bookmark-x")
(defun bmkx-previous-bookmark-this-file/buffer (n &optional startoverp) ; Bind to repeatable key, e.g. `f2'
  "Jump to the Nth-previous bookmark for the current file/buffer.
See `bmkx-next-bookmark-this-file/buffer'."
  (interactive (let ((startovr  (consp current-prefix-arg)))
                 (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) startovr)))
  (bmkx-cycle-this-file/buffer (- n) nil startoverp))

;;;###autoload (autoload 'bmkx-next-bookmark-this-file/buffer-repeat "bookmark-x")
(defun bmkx-next-bookmark-this-file/buffer-repeat ()
                                        ; `C-x x down', `C-x x n', `C-x x C-n', `C-x x mouse-wheel-up'
  "Jump to the next bookmark for the current file/buffer.
This is a repeatable version of `bmkx-next-bookmark-this-file/buffer'."
  (interactive)
  (bmkx-repeat-command 'bmkx-next-bookmark-this-file/buffer))

;;;###autoload (autoload 'bmkx-previous-bookmark-this-file/buffer-repeat "bookmark-x")
(defun bmkx-previous-bookmark-this-file/buffer-repeat ()
                                        ; `C-x x up', `C-x x p', `C-x x C-p', `C-x x mouse-wheel-down'
  "Jump to the previous bookmark for the current file/buffer.
See `bmkx-next-bookmark-this-file/buffer-repeat'."
  (interactive)
  (bmkx-repeat-command 'bmkx-previous-bookmark-this-file/buffer))

;;;###autoload (autoload 'bmkx-next-bookmark-this-file "bookmark-x")
(defun bmkx-next-bookmark-this-file (n &optional startoverp) ; Bind to repeatable key, e.g. `S-f2'
  "Jump to the Nth-next bookmark for the current file.
N defaults to 1, meaning the next one.
Plain `C-u' means start over at the first one.
See also `bmkx-cycle-this-file'."
  (interactive (let ((startovr  (consp current-prefix-arg)))
                 (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) startovr)))
  (bmkx-cycle-this-file n nil startoverp))

;;;###autoload (autoload 'bmkx-previous-bookmark-this-file "bookmark-x")
(defun bmkx-previous-bookmark-this-file (n &optional startoverp) ; Bind to repeatable key, e.g. `f2'
  "Jump to the Nth-previous bookmark for the current file.
See `bmkx-next-bookmark-this-file'."
  (interactive (let ((startovr  (consp current-prefix-arg)))
                 (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) startovr)))
  (bmkx-cycle-this-file (- n) nil startoverp))

;;;###autoload (autoload 'bmkx-next-bookmark-this-file-repeat "bookmark-x")
(defun bmkx-next-bookmark-this-file-repeat ()
  "Jump to the next bookmark for the current file.
This is a repeatable version of `bmkx-next-bookmark-this-file'."
  (interactive)
  (bmkx-repeat-command 'bmkx-next-bookmark-this-file))

;;;###autoload (autoload 'bmkx-previous-bookmark-this-file-repeat "bookmark-x")
(defun bmkx-previous-bookmark-this-file-repeat ()
  "Jump to the previous bookmark for the current file.
See `bmkx-next-bookmark-this-file-repeat'."
  (interactive)
  (bmkx-repeat-command 'bmkx-previous-bookmark-this-file))

;;;###autoload (autoload 'bmkx-next-bookmark-this-buffer "bookmark-x")
(defun bmkx-next-bookmark-this-buffer (n &optional startoverp) ; Bind to repeatable key, e.g. `S-f2'
  "Jump to the Nth-next bookmark in the current buffer.
N defaults to 1, meaning the next one.
Plain `C-u' means start over at the first one.
See also `bmkx-cycle-this-buffer'."
  (interactive (let ((startovr  (consp current-prefix-arg)))
                 (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) startovr)))
  (bmkx-cycle-this-buffer n nil startoverp))

;;;###autoload (autoload 'bmkx-previous-bookmark-this-buffer "bookmark-x")
(defun bmkx-previous-bookmark-this-buffer (n &optional startoverp) ; Bind to repeatable key, e.g. `f2'
  "Jump to the Nth-previous bookmark in the current buffer.
See `bmkx-next-bookmark-this-buffer'."
  (interactive (let ((startovr  (consp current-prefix-arg)))
                 (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) startovr)))
  (bmkx-cycle-this-buffer (- n) nil startoverp))

;;;###autoload (autoload 'bmkx-next-bookmark-this-buffer-repeat "bookmark-x")
(defun bmkx-next-bookmark-this-buffer-repeat ()
  "Jump to the next bookmark in the current buffer.
This is a repeatable version of `bmkx-next-bookmark-this-buffer'."
  (interactive)
  (bmkx-repeat-command 'bmkx-next-bookmark-this-buffer))

;;;###autoload (autoload 'bmkx-previous-bookmark-this-buffer-repeat "bookmark-x")
(defun bmkx-previous-bookmark-this-buffer-repeat ()
  "Jump to the previous bookmark in the current buffer.
See `bmkx-next-bookmark-this-buffer-repeat'."
  (interactive)
  (bmkx-repeat-command 'bmkx-previous-bookmark-this-buffer))

;;;###autoload (autoload 'bmkx-next-bookmark-w32 "bookmark-x")
(defun bmkx-next-bookmark-w32 (n &optional startoverp)       ; You can bind this to a repeatable key
  "Windows `Open' the Nth next bookmark in the bookmark navigation list.
MS Windows only.  Invokes the program associated with the file type.
N defaults to 1, meaning the next one.
Plain `C-u' means start over at the first one.
See also `bmkx-cycle'."
  (interactive (let ((startovr  (consp current-prefix-arg)))
                 (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) startovr)))
  (let ((bmkx-use-w32-browser-p  t))  (bmkx-cycle n nil startoverp)))

;;;###autoload (autoload 'bmkx-previous-bookmark-w32 "bookmark-x")
(defun bmkx-previous-bookmark-w32 (n &optional startoverp)   ; You can bind this to a repeatable key
  "Windows `Open' the Nth previous bookmark in the bookmark navlist.
See `bmkx-next-bookmark-w32'."
  (interactive (let ((startovr  (consp current-prefix-arg)))
                 (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) startovr)))
  (let ((bmkx-use-w32-browser-p  t))  (bmkx-cycle (- n) nil startoverp)))

;;;###autoload (autoload 'bmkx-next-bookmark-w32-repeat "bookmark-x")
(defun bmkx-next-bookmark-w32-repeat () ; `C-x x next'
  "Windows `Open' the next bookmark in the bookmark navigation list.
This is a repeatable version of `bmkx-next-bookmark'."
  (interactive)
  (let ((bmkx-use-w32-browser-p  t))  (bmkx-repeat-command 'bmkx-next-bookmark)))

;;;###autoload (autoload 'bmkx-previous-bookmark-w32-repeat "bookmark-x")
(defun bmkx-previous-bookmark-w32-repeat () ; `C-x x prior'
  "Windows `Open' the previous bookmark in the bookmark navlist.
See `bmkx-next-bookmark-w32-repeat'."
  (interactive)
  (let ((bmkx-use-w32-browser-p  t))  (bmkx-repeat-command 'bmkx-previous-bookmark)))

;; In spite of their names, `bmkx-cycle-specific-(buffers|files)*' just cycle bookmarks in the
;; current buffer or file.  There is no way to choose multiple buffers or files.
;;
;; `bmkx-cycle-autonamed', `bmkx-cycle-autonamed-other-window',
;; `bmkx-cycle-bookmark-list', `bmkx-cycle-bookmark-list-other-window',
;; `bmkx-cycle-desktop',
;; `bmkx-cycle-dired', `bmkx-cycle-dired-other-window',
;; `bmkx-cycle-eww', `bmkx-cycle-eww-other-window',
;; `bmkx-cycle-file', `bmkx-cycle-file-other-window',
;; `bmkx-cycle-gnus', `bmkx-cycle-gnus-other-window',
;; `bmkx-cycle-info', `bmkx-cycle-info-other-window',
;; `bmkx-cycle-lighted', `bmkx-cycle-lighted-other-window',
;; `bmkx-cycle-local-file', `bmkx-cycle-local-file-other-window',
;; `bmkx-cycle-man', `bmkx-cycle-man-other-window',
;; `bmkx-cycle-non-file', `bmkx-cycle-non-file-other-window',
;; `bmkx-cycle-remote-file', `bmkx-cycle-remote-file-other-window',
;; `bmkx-cycle-specific-buffers', `bmkx-cycle-specific-buffers-other-window',
;; `bmkx-cycle-specific-files', `bmkx-cycle-specific-files-other-window',
;; `bmkx-cycle-variable-list',
;; `bmkx-cycle-url', `bmkx-cycle-url-other-window',
;;
(bmkx-define-cycle-command "autonamed")
(bmkx-define-cycle-command "autonamed" 'OTHER-WINDOW)
(bmkx-define-cycle-command "bookmark-list") ; No other-window version needed
(bmkx-define-cycle-command "desktop")   ; No other-window version needed
(bmkx-define-cycle-command "dired")
(bmkx-define-cycle-command "dired" 'OTHER-WINDOW)
(bmkx-define-cycle-command "eww")
(bmkx-define-cycle-command "eww" 'OTHER-WINDOW)
(bmkx-define-cycle-command "file")
(bmkx-define-cycle-command "file" 'OTHER-WINDOW)
(bmkx-define-cycle-command "gnus")
(bmkx-define-cycle-command "gnus" 'OTHER-WINDOW)
(bmkx-define-cycle-command "info")
(bmkx-define-cycle-command "info" 'OTHER-WINDOW)
(when (featurep 'bookmark-x-lit)
  (bmkx-define-cycle-command "lighted")
  (bmkx-define-cycle-command "lighted" 'OTHER-WINDOW))
(bmkx-define-cycle-command "local-file")
(bmkx-define-cycle-command "local-file" 'OTHER-WINDOW)
(bmkx-define-cycle-command "man")
(bmkx-define-cycle-command "man" 'OTHER-WINDOW)
(bmkx-define-cycle-command "non-file")
(bmkx-define-cycle-command "non-file" 'OTHER-WINDOW)
(bmkx-define-cycle-command "remote-file")
(bmkx-define-cycle-command "remote-file" 'OTHER-WINDOW)
(bmkx-define-cycle-command "specific-buffers")
(bmkx-define-cycle-command "specific-buffers" 'OTHER-WINDOW)
(bmkx-define-cycle-command "specific-files")
(bmkx-define-cycle-command "specific-files" 'OTHER-WINDOW)
(bmkx-define-cycle-command "variable-list") ; No other-window version needed
(bmkx-define-cycle-command "url")
(bmkx-define-cycle-command "url" 'OTHER-WINDOW)

;; `bmkx-next-autonamed-bookmark', `bmkx-next-autonamed-bookmark-other-window',
;; `bmkx-next-autonamed-bookmark-repeat', `bmkx-next-autonamed-bookmark-other-window-repeat',
;; `bmkx-next-bookmark-list-bookmark',
;; `bmkx-next-bookmark-list-bookmark-repeat',
;; `bmkx-next-bookmark-list-bookmark-other-window',
;; `bmkx-next-bookmark-list-bookmark-other-window-repeat',
;; `bmkx-next-desktop-bookmark',
;; `bmkx-next-desktop-bookmark-repeat',
;; `bmkx-next-desktop-bookmark-other-window',
;; `bmkx-next-desktop-bookmark-other-window-repeat',
;; `bmkx-next-dired-bookmark',
;; `bmkx-next-dired-bookmark-repeat',
;; `bmkx-next-dired-bookmark-other-window',
;; `bmkx-next-dired-bookmark-other-window-repeat',
;; `bmkx-next-eww-bookmark',
;; `bmkx-next-eww-bookmark-repeat',
;; `bmkx-next-eww-bookmark-other-window',
;; `bmkx-next-eww-bookmark-other-window-repeat',
;; `bmkx-next-file-bookmark',
;; `bmkx-next-file-bookmark-repeat',
;; `bmkx-next-file-bookmark-other-window',
;; `bmkx-next-file-bookmark-other-window-repeat',
;; `bmkx-next-gnus-bookmark',
;; `bmkx-next-gnus-bookmark-repeat',
;; `bmkx-next-gnus-bookmark-other-window',
;; `bmkx-next-gnus-bookmark-other-window-repeat',
;; `bmkx-next-info-bookmark',
;; `bmkx-next-info-bookmark-repeat',
;; `bmkx-next-info-bookmark-other-window',
;; `bmkx-next-info-bookmark-other-window-repeat',
;; `bmkx-next-lighted-bookmark',
;; `bmkx-next-lighted-bookmark-repeat',
;; `bmkx-next-lighted-bookmark-other-window',
;; `bmkx-next-lighted-bookmark-other-window-repeat',
;; `bmkx-next-local-file-bookmark',
;; `bmkx-next-local-file-bookmark-repeat',
;; `bmkx-next-local-file-bookmark-other-window',
;; `bmkx-next-local-file-bookmark-other-window-repeat',
;; `bmkx-next-man-bookmark',
;; `bmkx-next-man-bookmark-repeat',
;; `bmkx-next-man-bookmark-other-window',
;; `bmkx-next-man-bookmark-other-window-repeat',
;; `bmkx-next-non-file-bookmark',
;; `bmkx-next-non-file-bookmark-repeat',
;; `bmkx-next-non-file-bookmark-other-window',
;; `bmkx-next-non-file-bookmark-other-window-repeat',
;; `bmkx-next-remote-file-bookmark',
;; `bmkx-next-remote-file-bookmark-repeat',
;; `bmkx-next-remote-file-bookmark-other-window',
;; `bmkx-next-remote-file-bookmark-other-window-repeat',
;; `bmkx-next-specific-buffers-bookmark',
;; `bmkx-next-specific-buffers-bookmark-repeat',
;; `bmkx-next-specific-buffers-bookmark-other-window',
;; `bmkx-next-specific-buffers-bookmark-other-window-repeat',
;; `bmkx-next-specific-files-bookmark',
;; `bmkx-next-specific-files-bookmark-repeat',
;; `bmkx-next-specific-files-bookmark-other-window',
;; `bmkx-next-specific-files-bookmark-other-window-repeat',
;; `bmkx-next-variable-list-bookmark',
;; `bmkx-next-variable-list-bookmark-repeat',
;; `bmkx-next-variable-list-bookmark-other-window',
;; `bmkx-next-variable-list-bookmark-other-window-repeat',
;; `bmkx-next-url-bookmark',
;; `bmkx-next-url-bookmark-repeat'.
;; `bmkx-next-url-bookmark-other-window',
;; `bmkx-next-url-bookmark-other-window-repeat'.
;;
;; `bmkx-previous-autonamed-bookmark',
;; `bmkx-previous-autonamed-bookmark-repeat',
;; `bmkx-previous-autonamed-bookmark-other-window',
;; `bmkx-previous-autonamed-bookmark-other-window-repeat',
;; `bmkx-previous-bookmark-list-bookmark',
;; `bmkx-previous-bookmark-list-bookmark-repeat',
;; `bmkx-previous-bookmark-list-bookmark-other-window',
;; `bmkx-previous-bookmark-list-bookmark-other-window-repeat',
;; `bmkx-previous-desktop-bookmark',
;; `bmkx-previous-desktop-bookmark-repeat',
;; `bmkx-previous-desktop-bookmark-other-window',
;; `bmkx-previous-desktop-bookmark--other-windowrepeat',
;; `bmkx-previous-dired-bookmark',
;; `bmkx-previous-dired-bookmark-repeat',
;; `bmkx-previous-dired-bookmark-other-window',
;; `bmkx-previous-dired-bookmark-other-window-repeat',
;; `bmkx-previous-eww-bookmark',
;; `bmkx-previous-eww-bookmark-repeat',
;; `bmkx-previous-eww-bookmark-other-window',
;; `bmkx-previous-eww-bookmark-other-window-repeat',
;; `bmkx-previous-file-bookmark',
;; `bmkx-previous-file-bookmark-repeat',
;; `bmkx-previous-file-bookmark-other-window',
;; `bmkx-previous-file-bookmark-other-window-repeat',
;; `bmkx-previous-gnus-bookmark',
;; `bmkx-previous-gnus-bookmark-repeat',
;; `bmkx-previous-gnus-bookmark-other-window',
;; `bmkx-previous-gnus-bookmark-other-window-repeat',
;; `bmkx-previous-info-bookmark',
;; `bmkx-previous-info-bookmark-repeat',
;; `bmkx-previous-info-bookmark-other-window',
;; `bmkx-previous-info-bookmark-other-window-repeat',
;; `bmkx-previous-lighted-bookmark',
;; `bmkx-previous-lighted-bookmark-repeat',
;; `bmkx-previous-lighted-bookmark-other-window',
;; `bmkx-previous-lighted-bookmark-other-window-repeat',
;; `bmkx-previous-local-file-bookmark',
;; `bmkx-previous-local-file-bookmark-repeat',
;; `bmkx-previous-local-file-bookmark-other-window',
;; `bmkx-previous-local-file-bookmark-other-window-repeat',
;; `bmkx-previous-man-bookmark',
;; `bmkx-previous-man-bookmark-repeat',
;; `bmkx-previous-man-bookmark-other-window',
;; `bmkx-previous-man-bookmark-other-window-repeat',
;; `bmkx-previous-non-file-bookmark',
;; `bmkx-previous-non-file-bookmark-repeat',
;; `bmkx-previous-non-file-bookmark-other-window',
;; `bmkx-previous-non-file-bookmark-other-window-repeat',
;; `bmkx-previous-remote-file-bookmark',
;; `bmkx-previous-remote-file-bookmark-repeat',
;; `bmkx-previous-remote-file-bookmark-other-window',
;; `bmkx-previous-remote-file-bookmark--other-windowrepeat',
;; `bmkx-previous-specific-buffers-bookmark',
;; `bmkx-previous-specific-buffers-bookmark-repeat',
;; `bmkx-previous-specific-buffers-bookmark-other-window',
;; `bmkx-previous-specific-buffers-bookmark-other-window-repeat',
;; `bmkx-previous-specific-files-bookmark',
;; `bmkx-previous-specific-files-bookmark-repeat',
;; `bmkx-previous-specific-files-bookmark-other-window',
;; `bmkx-previous-specific-files-bookmark-other-window-repeat',
;; `bmkx-previous-variable-list-bookmark',
;; `bmkx-previous-variable-list-bookmark-repeat',
;; `bmkx-previous-variable-list-bookmark-other-window',
;; `bmkx-previous-variable-list-bookmark-other-window-repeat',
;; `bmkx-previous-url-bookmark',
;; `bmkx-previous-url-bookmark-repeat'.
;; `bmkx-previous-url-bookmark-other-window',
;; `bmkx-previous-url-bookmark-other-window-repeat'.
;;
(bmkx-define-next+prev-cycle-commands "autonamed")
(bmkx-define-next+prev-cycle-commands "autonamed" 'OTHER-WINDOW)
(bmkx-define-next+prev-cycle-commands "bookmark-list")
(bmkx-define-next+prev-cycle-commands "desktop")
(bmkx-define-next+prev-cycle-commands "dired")
(bmkx-define-next+prev-cycle-commands "dired" 'OTHER-WINDOW)
(bmkx-define-next+prev-cycle-commands "eww")
(bmkx-define-next+prev-cycle-commands "eww" 'OTHER-WINDOW)
(bmkx-define-next+prev-cycle-commands "file")
(bmkx-define-next+prev-cycle-commands "file" 'OTHER-WINDOW)
(bmkx-define-next+prev-cycle-commands "gnus")
(bmkx-define-next+prev-cycle-commands "gnus" 'OTHER-WINDOW)
(bmkx-define-next+prev-cycle-commands "info")
(bmkx-define-next+prev-cycle-commands "info" 'OTHER-WINDOW)
(bmkx-define-next+prev-cycle-commands "lighted")
(bmkx-define-next+prev-cycle-commands "lighted" 'OTHER-WINDOW)
(bmkx-define-next+prev-cycle-commands "local-file")
(bmkx-define-next+prev-cycle-commands "local-file" 'OTHER-WINDOW)
(bmkx-define-next+prev-cycle-commands "man")
(bmkx-define-next+prev-cycle-commands "man" 'OTHER-WINDOW)
(bmkx-define-next+prev-cycle-commands "non-file")
(bmkx-define-next+prev-cycle-commands "non-file" 'OTHER-WINDOW)
(bmkx-define-next+prev-cycle-commands "remote-file")
(bmkx-define-next+prev-cycle-commands "remote-file" 'OTHER-WINDOW)
(bmkx-define-next+prev-cycle-commands "specific-buffers")
(bmkx-define-next+prev-cycle-commands "specific-buffers" 'OTHER-WINDOW)
(bmkx-define-next+prev-cycle-commands "specific-files")
(bmkx-define-next+prev-cycle-commands "specific-files" 'OTHER-WINDOW)
(bmkx-define-next+prev-cycle-commands "variable-list")
(bmkx-define-next+prev-cycle-commands "url")
(bmkx-define-next+prev-cycle-commands "url" 'OTHER-WINDOW)

;;;###autoload (autoload 'bmkx-toggle-autonamed-bmkx-set/delete "bookmark-x")
(defun bmkx-toggle-autonamed-bmkx-set/delete (&optional position allp)
                                        ; Bound globally to `C-x x RET', `C-x x c RET'
  "If there is an autonamed bookmark at point, delete it, else create one.
The bookmark created has no region.  Its name is formatted according
to option `bmkx-autoname-bookmark-function'.

With a prefix arg, delete *ALL* autonamed bookmarks for this buffer.

Non-interactively, act at POSITION, not point.  If nil, act at point."
  (interactive "d\nP")
  (unless position (setq position  (point)))
  (if allp
      (bmkx-delete-all-autonamed-for-this-buffer)
    (let ((bmk-name  (funcall bmkx-autoname-bookmark-function position)))
      (if (not (bmkx-get-bookmark-in-alist bmk-name 'NOERROR))
          (let ((mark-active  nil))     ; Do not set a region bookmark.
            (bmkx-set bmk-name)
            (message "Set bookmark `%s'" bmk-name))
        (bmkx-delete bmk-name)
        (message "Deleted bookmark `%s'" bmk-name)))))

;;;###autoload (autoload 'bmkx-set-autonamed-bookmark "bookmark-x")
(defun bmkx-set-autonamed-bookmark (&optional position msg-p)
  "Set an autonamed bookmark at point.
The bookmark created has no region.  Its name is formatted according
to option `bmkx-autoname-bookmark-function'.
Non-interactively:
 - Act at POSITION, not point.  If nil, act at point.
 - Non-nil optional arg MSG-P means display a status message."
  (interactive (list (point) 'MSG))
  (unless position (setq position  (point)))
  (let ((bmk-name     (funcall bmkx-autoname-bookmark-function position))
        (mark-active  nil))             ; Do not set a region bookmark.
    (bmkx-set bmk-name)
    (when msg-p (message "Set bookmark `%s'" bmk-name))))

;;;###autoload (autoload 'bmkx-set-autonamed-bookmark-at-line "bookmark-x")
(defun bmkx-set-autonamed-bookmark-at-line (&optional number)
  "Set an autonamed bookmark at the beginning of the current line.
With a prefix arg, set it at the line whose number is the numeric
prefix value."
  (interactive (list (and current-prefix-arg  (prefix-numeric-value current-prefix-arg))))
  (if (not number)
      (bmkx-set-autonamed-bookmark (line-beginning-position))
    (save-excursion
      (goto-char (point-min))
      (let ((inhibit-field-text-motion  t))
        (bmkx-set-autonamed-bookmark (line-beginning-position number))))))

(defun bmkx-occur-create-autonamed-bookmarks (&optional msg-p) ; Bound to `C-c C-M-B' (aka `C-c C-M-S-b')
    "Create an autonamed bookmark for each `occur' hit.
You can use this only in `Occur' mode (commands such as `occur' and
`multi-occur').
Non-interactively, non-nil MSG-P means display a status message."
    (interactive "p")
    (unless (eq major-mode 'occur-mode) (error "You must be in `occur-mode'"))
    (let ((count  0))
      (save-excursion
        (goto-char (point-min))
        (while (condition-case nil (progn (occur-next) t) (error nil))
          (let* ((pos   (get-text-property (point) 'occur-target))
                 (buf   (and pos  (marker-buffer pos))))
            (when buf
              (with-current-buffer buf
                (goto-char pos)
                (bmkx-set-autonamed-bookmark (point)))
              (setq count  (1+ count))))))
      (when msg-p (message "Created %d autonamed bookmarks" count))))

;;;###autoload (autoload 'bmkx-set-autonamed-regexp-buffer "bookmark-x")
(defun bmkx-set-autonamed-regexp-buffer (regexp &optional msg-p)
  "Set autonamed bookmarks at matches for REGEXP in the buffer.
Non-interactively, non-nil MSG-P means display a status message."
  (interactive (list (bmkx-read-regexp) 'MSG))
  (bmkx-set-autonamed-regexp-region regexp (point-min) (point-max) msg-p))

;;;###autoload (autoload 'bmkx-set-autonamed-regexp-region "bookmark-x")
(defun bmkx-set-autonamed-regexp-region (regexp beg end &optional msg-p)
  "Set autonamed bookmarks at matches for REGEXP in the region.
Non-interactively, non-nil MSG-P means display a status message."
  (interactive (list (bmkx-read-regexp) (region-beginning) (region-end) 'MSG))
  (let ((count  0))
    (save-excursion
      (goto-char beg)
      (while (re-search-forward regexp end t)
        (bmkx-set-autonamed-bookmark (point))
        (setq count  (1+ count))
        (forward-line 1)))
    (when msg-p (message "Set %d autonamed bookmarks" count))))

(defun bmkx-autoname-bookmark-function-default (position)
  "Return a bookmark name using POSITION and the current buffer name.
The name is composed as follows:
 POSITION followed by a space and then the buffer name.
 The position value is prefixed with zeros to comprise 9 characters.
 For example, for POSITION value 31416 and current buffer `my-buffer',
 the name returned would be `000031416 my-buffer'"
  (format "%09d %s" (abs position) (buffer-name)))

;;;###autoload (autoload 'bmkx-delete-all-autonamed-for-this-buffer "bookmark-x")
(defun bmkx-delete-all-autonamed-for-this-buffer (&optional msg-p)
  "Delete all autonamed bookmarks for the current buffer.
Interactively, or with non-nil arg MSG-P, require confirmation.
To be deleted, a bookmark name must be an autonamed bookmark whose
buffer part names the current buffer."
  (interactive "p")
  (let ((bmks-to-delete  (mapcar #'bmkx-bookmark-name-from-record
                                 (bmkx-autonamed-this-buffer-alist-only))))
    (if (null bmks-to-delete)
        (when msg-p (message "No autonamed bookmarks for buffer `%s'" (buffer-name)))
      (when (or (not msg-p)
                (y-or-n-p (format "Delete ALL autonamed bookmarks for buffer `%s'? " (buffer-name))))
        (let ((bookmark-save-flag   (and (not bmkx-count-multi-mods-as-one-flag)
                                         bookmark-save-flag))) ; Save at most once, after `dolist'.
          (dolist (bmk  bmks-to-delete)  (bmkx-delete bmk 'BATCHP))) ; No refresh yet.
        (bmkx-refresh/rebuild-menu-list nil (not msg-p)) ; Now refresh, after iterate.
        (when msg-p (message "Deleted all bookmarks for buffer `%s'" (buffer-name)))))))

;; You can use this in `kill-buffer-hook'.
(defun bmkx-delete-autonamed-this-buffer-no-confirm (&optional no-refresh-p)
  "Delete all autonamed bookmarks for this buffer, without confirmation.
Non-nil optional arg NO-REFRESH-P means do not refresh/rebuild the
bookmark-list."
  (when (and bmkx-bookmarks-already-loaded  bookmark-alist)
    (let ((bmks-to-delete      (mapcar #'bmkx-bookmark-name-from-record
                                       (bmkx-autonamed-this-buffer-alist-only)))
          (bookmark-save-flag  (and (not bmkx-count-multi-mods-as-one-flag)
                                    bookmark-save-flag))) ; Save at most once, after `dolist'.
      (dolist (bmk  bmks-to-delete)  (bmkx-delete bmk 'BATCHP))) ; No refresh yet.
    (unless no-refresh-p
      (bmkx-refresh/rebuild-menu-list nil 'BATCHP)))) ; Now refresh, after iterate.


;; You can use this in `kill-emacs-hook'.
(defun bmkx-delete-autonamed-no-confirm ()
  "Delete all autonamed bookmarks for all buffers, without confirmation."
  (when (and bmkx-bookmarks-already-loaded  bookmark-alist)
    (let ((bookmark-save-flag  (and (not bmkx-count-multi-mods-as-one-flag)
                                    bookmark-save-flag))) ; Save at most once, after `dolist'.
      (dolist (buf  (buffer-list))
        (with-current-buffer buf
          (bmkx-delete-autonamed-this-buffer-no-confirm 'NO-REFRESH-P)))) ; No refresh yet.
    (bmkx-refresh/rebuild-menu-list nil 'BATCHP))) ; Now refresh, after iterate.

(progn
  ;; `bmkx-automatic-bookmark-mode'.  The old Emacs-20 fallback branch is gone.
  (eval '(define-minor-mode bmkx-automatic-bookmark-mode
               "Toggle automatic setting of a bookmark when Emacs is idle.
Non-interactively, turn automatic bookmarking on for the current
buffer if and only if ARG is positive.

To enable or disable automatic bookmarking in all buffers, use
`bmkx-global-automatic-bookmark-mode'.

When the mode is enabled in the current buffer, a bookmark is
automatically set every `bmkx-automatic-bookmark-mode-delay' seconds,
using the setting function that is the value of option
`bmkx-automatic-bookmark-set-function'.  Note that a buffer must be
current (selected) for an automatic bookmark to be created there - it
is not enough that the mode be enabled in the buffer.

Turning the mode on and off runs hooks
`bmkx-automatic-bookmark-mode-on-hook' and
`bmkx-automatic-bookmark-mode-off-hook', respectively.

If you want the automatic bookmarks to be temporary (not saved to your
bookmark file), then customize option
`bmkx-autotemp-bookmark-predicates' so that it includes the kind of
bookmarks that are set by `bmkx-automatic-bookmark-set-function'.
For example, if automatic bookmarking sets autonamed bookmarks, then
`bmkx-autotemp-bookmark-predicates' should include
`bmkx-autonamed-bookmark-p' or
`bmkx-autonamed-this-buffer-bookmark-p'.

If you want the automatically created bookmarks to be highlighted,
then customize option `bmkx-auto-light-when-set' to highlight
bookmarks of the appropriate kind.  For example, to highlight
autonamed bookmarks set it to `autonamed-bookmark'.

NOTE: If you use Emacs 21 then there is no global version of the mode
- that is, there is no command `bmkx-global-automatic-bookmark-mode'."
               :init-value nil :group 'bookmark-plus :require 'bookmark-x
               :lighter bmkx-automatic-bookmark-mode-lighter
               :link `(url-link :tag "Send Bug Report"
                       ,(concat "mailto:" "drew.adams" "@" "oracle" ".com?subject=\
Bookmark bug: \
&body=Describe bug here, starting with `emacs -Q'.  \
Don't forget to mention your Emacs and library versions."))
               :link '(url-link :tag "Download" "https://www.emacswiki.org/emacs/download/bookmark%2b.el")
               :link '(url-link :tag "Description" "https://www.emacswiki.org/emacs/BookmarkPlus")
               :link '(emacs-commentary-link :tag "Commentary" "bookmark-x")
               (when bmkx-automatic-bookmark-mode-timer
                 (cancel-timer bmkx-automatic-bookmark-mode-timer)
                 (setq bmkx-automatic-bookmark-mode-timer  nil))
               (when bmkx-automatic-bookmark-mode
                 (setq bmkx-automatic-bookmark-mode-timer
                       (run-with-idle-timer bmkx-automatic-bookmark-mode-delay 'REPEAT
                                            (lambda ()
                                              (when bmkx-automatic-bookmark-mode
                                                (bmkx-set-automatic-bookmark))))))
               (when (called-interactively-p 'interactive)
                 (message "Automatic bookmarking is now %s in buffer `%s'"
                          (if bmkx-automatic-bookmark-mode "ON" "OFF") (buffer-name)))))

       (eval '(defun bmkx-turn-on-automatic-bookmark-mode ()
               "Turn on `bmkx-automatic-bookmark-mode'."
               (bmkx-automatic-bookmark-mode 1)))

       (progn ; Emacs 22+, not 21.
         (eval '(define-globalized-minor-mode bmkx-global-automatic-bookmark-mode
                 bmkx-automatic-bookmark-mode
                 bmkx-turn-on-automatic-bookmark-mode
                 :group 'bookmark-plus :require 'bookmark-x))))


;;(@* "Auto-update Bookmarks")
;;  *** Auto-update Bookmarks ***
;;
;; A bookmark tagged with `bmkx-auto-update-tag' (default "auto-update")
;; behaves as a "reading position" tracker: when `bmkx-auto-update-mode'
;; is on, the bookmark's position and context strings are refreshed to
;; the current point of the buffer visiting its filename, on three
;; triggers:
;;
;;   - An idle timer firing every `bmkx-auto-update-interval' seconds.
;;   - `kill-buffer-hook'         (catches "I'm closing this file").
;;   - `window-state-change-hook' (catches "I switched away from it").
;;
;; Untagged bookmarks are not touched.  Bookmarks whose file is not
;; currently visited (no live buffer for it) are not touched either.

(defcustom bmkx-auto-update-tag "auto-update"
  "Tag value that marks a bookmark as auto-updated.
A bookmark carrying this tag has its position and context strings
periodically refreshed to the current point of the buffer visiting
its filename, when `bmkx-auto-update-mode' is on."
  :type 'string :group 'bookmark-plus)

(defcustom bmkx-auto-update-interval 60
  "Seconds of idle time between ticks of `bmkx-auto-update-mode'."
  :type 'integer :group 'bookmark-plus)

(defvar bmkx-auto-update--timer nil
  "Internal idle timer for `bmkx-auto-update-mode'.")

(defun bmkx-auto-update--tagged-p (bm)
  "Return non-nil if bookmark record BM carries `bmkx-auto-update-tag'."
  (cl-some (lambda (tag)
             (equal (if (consp tag) (car tag) tag) bmkx-auto-update-tag))
           (bookmark-prop-get (car bm) 'tags)))

(defun bmkx-auto-update--refresh (bm buffer)
  "Refresh BM's location from BUFFER's current point.
Updates position, front/rear context strings, and last-modified;
leaves name, id, tags, annotation, handler intact."
  (with-current-buffer buffer
    (let ((fresh  (cdr (bookmark-make-record-default))))
      (dolist (field '(position front-context-string rear-context-string))
        (let ((val  (alist-get field fresh)))
          (when val (bookmark-prop-set bm field val))))
      (bookmark-prop-set bm 'last-modified (current-time)))))

(defun bmkx-auto-update--tick (&optional only-buffer)
  "Refresh auto-update bookmarks whose file is currently visited.
With ONLY-BUFFER non-nil, restrict to the bookmark whose file is
that buffer's `buffer-file-name'."
  (let ((target-file  (and only-buffer (buffer-file-name only-buffer))))
    (dolist (bm bookmark-alist)
      (when (bmkx-auto-update--tagged-p bm)
        (let* ((file (bookmark-get-filename bm))
               (buf  (cond
                      (target-file
                       (and file (bmkx-same-file-p file target-file) only-buffer))
                      (file
                       (find-buffer-visiting file)))))
          (when (buffer-live-p buf)
            (bmkx-auto-update--refresh bm buf)))))))

;;;###autoload (autoload 'bmkx-auto-update-now "bookmark-x")
(defun bmkx-auto-update-now ()
  "Force an immediate refresh of every auto-update bookmark.
Refreshes any bookmark tagged `bmkx-auto-update-tag' whose file is
currently visited by a live buffer.  See `bmkx-auto-update-mode'."
  (interactive)
  (bmkx-auto-update--tick)
  (when (called-interactively-p 'interactive)
    (message "Auto-update bookmarks refreshed.")))

(defun bmkx-auto-update--on-kill-buffer ()
  "Refresh auto-update bookmarks for the buffer being killed, then return."
  (when (and bmkx-auto-update-mode  (buffer-file-name))
    (bmkx-auto-update--tick (current-buffer))))

(defun bmkx-auto-update--on-window-state-change ()
  "Run a global auto-update tick on every window-state change.
Cheap: iterates only auto-update-tagged bookmarks."
  (when bmkx-auto-update-mode
    (bmkx-auto-update--tick)))

;;;###autoload (autoload 'bmkx-auto-update-mode "bookmark-x")
(define-minor-mode bmkx-auto-update-mode
  "Toggle global auto-tracking of bookmarks tagged `bmkx-auto-update-tag'.

When the mode is on, three triggers refresh a tagged bookmark's
position and context strings to the current point of the buffer
visiting its file:

  - An idle timer firing every `bmkx-auto-update-interval' seconds.
  - `kill-buffer-hook'         (catches \"closing the file\").
  - `window-state-change-hook' (catches \"switching away\").

Untagged bookmarks are not touched.  Files whose buffer is not
currently visited are not touched either.

Use `bmkx-auto-update-now' to force an immediate refresh."
  :init-value nil :global t :group 'bookmark-plus
  (when bmkx-auto-update--timer
    (cancel-timer bmkx-auto-update--timer)
    (setq bmkx-auto-update--timer nil))
  (cond
   (bmkx-auto-update-mode
    (setq bmkx-auto-update--timer
          (run-with-idle-timer bmkx-auto-update-interval 'REPEAT
                               #'bmkx-auto-update--tick))
    (add-hook 'kill-buffer-hook         #'bmkx-auto-update--on-kill-buffer)
    (add-hook 'window-state-change-hook #'bmkx-auto-update--on-window-state-change))
   (t
    (remove-hook 'kill-buffer-hook         #'bmkx-auto-update--on-kill-buffer)
    (remove-hook 'window-state-change-hook #'bmkx-auto-update--on-window-state-change))))


(defun bmkx-not-near-other-automatic-bmks (&optional position)
  "Is POSITION far enough from automatic bookmarks to create a new one?
Return non-nil if `bmkx-automatic-bookmark-min-distance' is nil or if
POSITION is at least `bmkx-automatic-bookmark-min-distance' chars from
all other automatic bookmarks in the same buffer.  Else return nil."
  (unless position (setq position  (point)))
  (or (not bmkx-automatic-bookmark-min-distance)
      (catch 'bmkx-not-near-other-automatic-bmks
        (let (bmk-pos)
          (dolist (bmk  bmkx-automatic-bookmarks)
            (when (and (bmkx-this-buffer-p bmk)
                       (setq bmk-pos  (bookmark-get-position bmk))
                       (or (not bmk-pos)  (< (abs (- position bmk-pos)) bmkx-automatic-bookmark-min-distance)))
              (throw 'bmkx-not-near-other-automatic-bmks nil)))
          t))))

(defun bmkx-set-automatic-bookmark ()
  "Invoke `bmkx-automatic-bookmark-set-function'.
Do nothing if bookmark would be too near another automatic bookmark."
  (when (bmkx-not-near-other-automatic-bmks)
    (let ((bmkx-setting-automatic-bmk-p  t)) (funcall bmkx-automatic-bookmark-set-function))))

(progn ; Emacs 22+ (need also `Info-selection-hook').

  ;; Eval this so that even if the library is byte-compiled with Emacs 20,
  ;; loading it into Emacs 22+ will define variable `bmkx-info-auto-bookmark-mode'.
  (eval '(define-minor-mode bmkx-info-auto-bookmark-mode
           "Toggle automatically setting a bookmark when you visit an Info node.
The bookmark name is \"(MANUAL) `NODE'\", where:

 MANUAL is the name of the current manual (the base file name).
 NODE is the name of the current node.

If option `bmkx-info-auto-type' is `create-or-update' then such a
bookmark is created for the node if none exists.  If the option value
is `update-only' then no new bookmark is created automatically, but an
existing bookmark is updated.  (Updating a bookmark increments the
recorded number of visits.)  You can toggle the option using
`\\[bmkx-toggle-info-auto-type]'."
           :init-value nil :global t :group 'bookmark-plus :require 'bookmark-x
           :lighter bmkx-automatic-bookmark-mode-lighter
           :link `(url-link :tag "Send Bug Report"
                            ,(concat "mailto:" "drew.adams" "@" "oracle" ".com?subject=\
Bookmark bug: \
&body=Describe bug here, starting with `emacs -Q'.  \
Don't forget to mention your Emacs and library versions."))
           :link '(url-link :tag "Download" "https://www.emacswiki.org/emacs/download/bookmark%2b.el")
           :link '(url-link :tag "Description" "https://www.emacswiki.org/emacs/BookmarkPlus")
           :link '(emacs-commentary-link :tag "Commentary" "bookmark-x")
           (if bmkx-info-auto-bookmark-mode
               (add-hook 'Info-selection-hook 'bmkx-set-info-bookmark-with-node-name)
             (remove-hook 'Info-selection-hook 'bmkx-set-info-bookmark-with-node-name))
           (when (called-interactively-p 'interactive)
             (message "Automatic Info bookmarking is now %s" (if bmkx-info-auto-bookmark-mode "ON" "OFF")))))

  (defun bmkx-set-info-bookmark-with-node-name (&optional nomsg)
    "Maybe bookmark the current Info node using name \"(MANUAL) `NODE'\".
MANUAL is the name of the current manual (the base file name).
NODE is the name of the current node.

If option `bmkx-info-auto-type' is `create-or-update' then a bookmark
is created for the node if none exists.  If it is `update-only' then
no new bookmark is created automatically, but an existing bookmark is
updated.  You can use toggle `bmkx-info-auto-type' using
`\\[bmkx-toggle-info-auto-type]'.

Non-nil optional arg NOMSG means do not display a message saying that
the node was bookmarked."
    (interactive)
    (when (and (derived-mode-p 'Info-mode)  Info-current-node)
      (save-excursion
        (goto-char (point-min))
        (let* ((bmk-name  (and (stringp Info-current-file)
                               (format "(%s) %s" (file-name-sans-extension
                                                  (file-name-nondirectory Info-current-file))
                                       Info-current-node)))
               (bmk       (bmkx-bookmark-record-from-name bmk-name 'NOERROR))
               (visits    (and bmk  (bookmark-prop-get bmk 'visits))))
          (when bmk-name
            (cond ((and (not visits)  (eq bmkx-info-auto-type 'create-or-update))
                   (bmkx-set bmk-name)
                   (unless nomsg (message "Created bookmark `%s' for Info node" bmk-name)))
                  (visits
                   (bmkx-record-visit bmk-name 'BATCHP)
                   (bmkx-refresh/rebuild-menu-list bmk-name nil)
                   (bmkx-maybe-save-bookmarks)
                   (unless nomsg (message "Updated bookmark `%s' for Info node" bmk-name)))))))))

  (defun bmkx-toggle-info-auto-type (&optional msgp)
    "Toggle the value of option `bmkx-info-auto-type'."
    (interactive "p")
    (setq bmkx-info-auto-type  (if (eq bmkx-info-auto-type 'create-or-update) 'update-only 'create-or-update))
    (when msgp (message "`bmkx-info-auto-bookmark-mode' now %s" 
                        (if (eq bmkx-info-auto-type 'create-or-update)
                            "CREATES, as well as updates, Info bookmarks"
                          "only UPDATES EXISTING Info bookmarks"))))

  )

;; Emacs 21 and later.  Eval this so that even if the library is byte-compiled with Emacs 20,
    ;; loading it into Emacs 21+ will define variable `bmkx-temporary-bookmarking-mode'.
    (eval '(define-minor-mode bmkx-temporary-bookmarking-mode ; `M-L' in `*Bmkx List*'.
             "Toggle temporary bookmarking.
Temporary bookmarking means that any bookmark changes (creation,
modification, deletion) are NOT automatically saved.

Interactively, you are required to confirm turning on the mode.

When the mode is turned ON:
 a. `bookmark-save-flag' is set to nil.
 b. `bmkx-current-bookmark-file' is set to a new, empty bookmark file
    in directory `temporary-file-directory' (via `make-temp-file').
 c. That file is not saved automatically.
 d. In the `*Bmkx List*' display, the major-mode mode-line
    indicator is set to `TEMPORARY ONLY'.

Non-interactively, turn temporary bookmarking on if and only if ARG is
positive.  Non-interactively there is no prompt for confirmation."
             :init-value nil :global t :group 'bookmark-plus :lighter bmkx-temporary-bookmarking-mode-lighter
             :link `(url-link :tag "Send Bug Report"
                              ,(concat "mailto:" "drew.adams" "@" "oracle" ".com?subject=\
Bookmark bug: \
&body=Describe bug here, starting with `emacs -Q'.  \
Don't forget to mention your Emacs and library versions."))
             :link '(url-link :tag "Download" "https://www.emacswiki.org/emacs/download/bookmark%2b.el")
             :link '(url-link :tag "Description" "https://www.emacswiki.org/emacs/BookmarkPlus")
             :link '(emacs-commentary-link :tag "Commentary" "bookmark-x")
             (cond ((not bmkx-temporary-bookmarking-mode) ; Turn off.
                    (when (fboundp 'bmkx-unlight-bookmarks) ; In `bookmark-x-lit.el'.
                      (bmkx-unlight-bookmarks ; Unhighlight the temporary (current) bookmarks.
                       '(bmkx-autonamed-overlays bmkx-non-autonamed-overlays) nil))
                    (bmkx-switch-to-last-bookmark-file)
                    (setq bmkx-last-bookmark-file  bmkx-current-bookmark-file) ; Forget last (temp file).
                    (when (called-interactively-p 'interactive)
                      (message "Bookmarking is NOT temporary now.  Restored previous bookmarks list")))
                   ((or (not (called-interactively-p 'interactive))
                        (y-or-n-p (format "%switch to only temporary bookmarking? "
                                          (if bookmark-save-flag "Save current bookmarks, then s" "S"))))
                    (when (and (> bookmark-alist-modification-count 0)  bookmark-save-flag)
                      (bmkx-save))
                    (let ((new-file  (make-temp-file "bmkx-temp-")))
                      (with-current-buffer (let ((enable-local-variables  ())) (find-file-noselect new-file))
                        (goto-char (point-min))
                        (delete-region (point-min) (point-max)) ; In case a find-file hook inserted a header.
                        (bookmark-insert-file-format-version-stamp coding-system-for-write)
                        (insert "(\n)"))
                      (bmkx-empty-file new-file)
                      (setq bmkx-last-as-first-bookmark-file  nil) ; Prevent starting from a file of temp bmks.
                      (bmkx-load new-file t 'nosave) ; Saving was done just above.
                      (when bookmark-save-flag (bmkx-toggle-saving-bookmark-file (called-interactively-p 'interactive))))
                    (when (called-interactively-p 'interactive) (message "Bookmarking is now TEMPORARY")))
                   (t                   ; User refused to confirm.
                    (message "OK, canceled - bookmarking is NOT temporary")
                    (setq bmkx-temporary-bookmarking-mode  nil)))))

;;;###autoload (autoload 'bmkx-toggle-autotemp-on-set "bookmark-x")
(defun bmkx-toggle-autotemp-on-set (&optional msg-p) ; Bound to `C-x x x'
  "Toggle automatically making any bookmark temporary whenever it is set.
Non-interactively, non-nil MSG-P means display a status message."
  (interactive "p")
  (setq bmkx-autotemp-all-when-set-p  (not bmkx-autotemp-all-when-set-p))
  (when msg-p (message "Automatically making bookmarks temporary when set is now %s"
                       (if bmkx-autotemp-all-when-set-p "ON" "OFF"))))

;;;###autoload (autoload 'bmkx-toggle-temporary-bookmark "bookmark-x")
(defun bmkx-toggle-temporary-bookmark (bookmark &optional msg-p)
  "Toggle whether BOOKMARK is temporary (not saved to disk).
Return the full updated bookmark.
BOOKMARK is a bookmark name or a bookmark record.
Non-interactively, non-nil MSG-P means display a status message."
  (interactive (list (bmkx-completing-read "Bookmark" (bmkx-default-bookmark-name)) 'MSG))
  (let ((was-temp  (bmkx-temporary-bookmark-p bookmark)))
    (bmkx-prop-set bookmark 'bmkx-temp (not was-temp))
    (when msg-p (message "Bookmark `%s' is now %s"
                         (if (stringp bookmark) bookmark (bmkx-bookmark-name-from-record bookmark))
                         (if was-temp "SAVABLE" "TEMPORARY"))))
  bookmark)

;;;###autoload (autoload 'bmkx-make-bookmark-temporary "bookmark-x")
(defun bmkx-make-bookmark-temporary (bookmark &optional msg-p)
  "Make BOOKMARK temporary (not saved to disk).
Return the full updated bookmark.
BOOKMARK is a bookmark name or a bookmark record.
Non-interactively, non-nil MSG-P means display a status message."
  (interactive (list (bmkx-completing-read "Bookmark" (bmkx-default-bookmark-name)) 'MSG))
  (bmkx-prop-set bookmark 'bmkx-temp t)
  (when msg-p (message "Bookmark `%s' is now TEMPORARY"
                       (if (stringp bookmark) bookmark (bmkx-bookmark-name-from-record bookmark))))
  bookmark)

;;;###autoload (autoload 'bmkx-make-bookmark-savable "bookmark-x")
(defun bmkx-make-bookmark-savable (bookmark &optional msg-p)
  "Make BOOKMARK savable to disk (not temporary).
Return the full updated bookmark.
BOOKMARK is a bookmark name or a bookmark record.
Non-interactively, non-nil MSG-P means display a status message."
  (interactive (list (bmkx-completing-read "Bookmark" (bmkx-default-bookmark-name)) 'MSG))
  (bmkx-prop-set bookmark 'bmkx-temp nil)
  (when msg-p (message "Bookmark `%s' is now SAVABLE"
                       (if (stringp bookmark) bookmark (bmkx-bookmark-name-from-record bookmark))))
  bookmark)

;;;###autoload (autoload 'bmkx-delete-all-temporary-bookmarks "bookmark-x")
(defun bmkx-delete-all-temporary-bookmarks (&optional msg-p)
  "Delete all temporary bookmarks, after confirmation.
These are bookmarks that are `bmkx-temporary-bookmark-p'.  You can
make a bookmark temporary using `bmkx-make-bookmark-temporary' or
`bmkx-toggle-temporary-bookmark'.
Non-interactively, non-nil MSG-P means display a status message."
  (interactive "p")
  (let ((bmks-to-delete  (mapcar #'bmkx-bookmark-name-from-record (bmkx-temporary-alist-only))))
    (if (null bmks-to-delete)
        (when msg-p (message "No temporary bookmarks to delete"))
      (when (and msg-p  (not (y-or-n-p (format "Delete ALL temporary bookmarks? "))))
        (error "OK - delete canceled"))
      (let ((bookmark-save-flag  (and (not bmkx-count-multi-mods-as-one-flag)
                                      bookmark-save-flag))) ; Save at most once, after `dolist'.
        (dolist (bmk  bmks-to-delete)  (bmkx-delete bmk 'BATCHP))) ; No refresh yet.
      (bmkx-refresh/rebuild-menu-list nil (not msg-p)) ; Now refresh, after iterate.
      (when msg-p (message "Deleted all temporary bookmarks")))))

;; You can use this in `kill-emacs-hook'.
(defun bmkx-delete-temporary-no-confirm ()
  "Delete all temporary bookmarks, without confirmation."
  (when (and bmkx-bookmarks-already-loaded  bookmark-alist)
    (let ((bmks-to-delete  (mapcar #'bmkx-bookmark-name-from-record (bmkx-temporary-alist-only)))
          (bookmark-save-flag  (and (not bmkx-count-multi-mods-as-one-flag)
                                    bookmark-save-flag))) ; Save at most once, after `dolist'.
      (dolist (bmk  bmks-to-delete)  (bmkx-delete bmk 'BATCHP))) ; No refresh yet.
    (bmkx-refresh/rebuild-menu-list nil 'BATCHP))) ; Now refresh, after iterate.

;;;###autoload (autoload 'bmkx-delete-bookmarks "bookmark-x")
(defun bmkx-delete-bookmarks (&optional position allp alist msg-p) ; Bound to `C-x x delete'
  "Delete some bookmarks at point or all bookmarks in the buffer.
With no prefix argument, delete some bookmarks at point.
If there is more than one, require confirmation for each.

With a prefix argument, delete *ALL* bookmarks in the current buffer.

Non-interactively:
* Delete at POSITION, not point.  If nil, delete at point.
* Non-nil optional arg ALLP means delete all bookmarks in the buffer.
* ALIST is the alist of bookmarks.
  If nil, use the bookmarks in the current buffer.
* Non-nil MSG-P means display informative messages."
  (interactive "d\nP\ni\np")
  (unless position (setq position  (point)))
  (let ((bmks-to-delete  (and allp  (mapcar #'bmkx-bookmark-name-from-record (bmkx-this-buffer-alist-only))))
        (bmks-deleted    ()))
    (when (and msg-p  bmks-to-delete  (not (y-or-n-p (format "Delete ALL bookmarks in buffer `%s'? "
                                                             (buffer-name)))))
      (error "Canceled - no bookmarks deleted"))
    (cond (bmks-to-delete               ; Delete all.
           (let ((bookmark-save-flag  (and (not bmkx-count-multi-mods-as-one-flag)
                                           bookmark-save-flag))) ; Save at most once, after `dolist'.
             (dolist (bname  bmks-to-delete) (bmkx-delete bname 'BATCHP))) ; No refresh yet.
           (bmkx-refresh/rebuild-menu-list nil (not msg-p)) ; Refresh now, after iterate.
           (when msg-p (message "Deleted all bookmarks in buffer `%s'" (buffer-name))))

          (allp ; Requested ALLP, but there are none.  (No-op if not interactive.)
           (when msg-p (message "No bookmarks to delete in buffer `%s'" (buffer-name))))

          (t                     ; Delete selected bookmarks at point.
           (let (bname)
             (dolist (bmk  (or alist  (bmkx-this-buffer-alist-only)))
               (when (eq position (bookmark-get-position bmk))
                 (setq bname  (bmkx-bookmark-name-from-record bmk))
                 ;; This is the same as `add-to-list' with `EQ' (not available for Emacs 20-21).
                 (unless (memq bname bmks-to-delete)
                   (setq bmks-to-delete  (cons bname bmks-to-delete)))))
             (cond ((cadr bmks-to-delete) ; More than one at point.
                    (let ((bookmark-save-flag  (and (not bmkx-count-multi-mods-as-one-flag)
                                                    bookmark-save-flag))) ; Save at most once, after `dolist'.
                      (dolist (bname  bmks-to-delete)
                        (when (or (not msg-p)  (y-or-n-p (format "Delete bookmark `%s'? " bname)))
                          (bmkx-delete bname 'BATCHP) ; No refresh yet.
                          ;; This is the same as `add-to-list' with `EQ' (not available for Emacs 20-21).
                          (unless (memq bname bmks-deleted) (setq bmks-deleted  (cons bname bmks-deleted))))))
                    (bmkx-refresh/rebuild-menu-list nil (not msg-p)) ; Refresh now.
                    (when msg-p
                      (message (if bmks-deleted
                                   (format "Deleted bookmarks: %s"
                                           (mapconcat (lambda (bname) (format "`%s'" bname)) bmks-deleted
                                                      ", "))
                                 "No bookmarks deleted"))))
                   (bmks-to-delete      ; Only one bookmark at point.
                    (bmkx-delete (car bmks-to-delete))
                    (when msg-p (message "Deleted bookmark `%s'" (car bmks-to-delete))))
                   (t
                    (when msg-p (message "No bookmarks at point to delete")))))))))

;; Because of Emacs bug #19915, we need to use `advice-add' for `org-store-link', so this feature
;; is available only for Emacs 24.4+.
(progn (defvar bmkx-store-org-link-checking-p nil
    "Whether `bmkx-(bmenu-)store-org-link(-1)' call is checking applicability.")

  (defun bmkx-store-org-link (_arg)
    "Store a link to a bookmark for insertion in an Org-mode buffer.
You are prompted for the bookmark name.

If you use a numeric prefix arg then the bookmark will be jumped to in
the same window.  Without a numeric prefix arg, the link will use
another window.  The link type is `bookmark' or `bookmark-other-win',
respectively."
    (interactive "P")
    (require 'org)
    (let ((org-store-link-functions  (append org-store-link-functions '(bmkx-store-org-link-1))))
      (call-interactively #'org-store-link)))

  (defun bmkx-store-org-link-1 ()
    "Store a link to a bookmark for insertion in an Org-mode buffer.
See command `bmkx-store-org-link'."
    (setq bmkx-store-org-link-checking-p  (not bmkx-store-org-link-checking-p))
    (require 'org)
    (or bmkx-store-org-link-checking-p  ; Non-nil return is all that is needed for checking.
        (let* ((other-win  (and current-prefix-arg  (not (consp current-prefix-arg))))
               (bmk        (bmkx-completing-read-lax
                            (format "Store %sOrg link for bookmark" (if other-win "other-window " ""))))
               (link       (format "bookmark%s:%s" (if other-win "-other-win" "") bmk))
               (bmk-desc   (format "Bookmark: %s" bmk)))
          (org-link-store-props :type "bookmark" :link link :description bmk-desc))))

  (advice-add 'org-store-link :before #'bmkx-reset-bmkx-store-org-link-checking-p)
  (defun bmkx-reset-bmkx-store-org-link-checking-p (&rest _IGNORE)
    "Reset `bmkx-store-org-link-checking-p' to nil."
    (setq bmkx-store-org-link-checking-p  nil)))

(defun bmkx-ffap-guesser ()
  "`ffap-guesser', but deactivate a large active region first."
  (and (require 'ffap nil t)
       ;; Prevent using a large active region to guess ffap: Emacs bug #25243.
       (let ((mark-active  (and mark-active  (< (buffer-size) bmkx-ffap-max-region-size))))
         (ffap-guesser))))

(defun bmkx-thing-at-point (thing &optional syntax-table)
  "Like `thing-at-point' but use SYNTAX-TABLE for the lookup when given."
  (if (syntax-table-p syntax-table)
      (with-syntax-table syntax-table (thing-at-point thing))
    (thing-at-point thing)))         ; Ignore any SYNTAX-TABLE arg for Emacs 20, for built-in.

(defun bmkx-get-external-annotation (annotation)
  "Return a cons (DESTINATION . TYPE) for ANNOTATION.
DESTINATION is a string naming a file, a URL, or a bookmark.
TYPE is `FILE', `URL', or `BOOKMARK', accordingly."
  (cond ((string-match "\\`\\s-*bmkx-annot-file:\\s-*\"\\(\.+\\)\"" annotation)
         (cons (match-string 1 annotation) 'FILE))
        ((string-match "\\`\\s-*bmkx-annot-url:\\s-*\"\\(\.+\\)\"" annotation)
         (cons (match-string 1 annotation) 'URL))
        ((string-match "\\`\\s-*bmkx-annot-bmk:\\s-*\"\\(\.+\\)\"" annotation)
         (cons (match-string 1 annotation) 'BOOKMARK))
        (t nil)))

(defun bmkx-visit-external-annotation (annotation.type msg-p)
  "Visit the external annotation represented by ANNOTATION.TYPE.
The first arg is a cons as returned by `bmkx-get-external-annotation'.
I MSG-P is non-nil then echo the annotation type."
  (let ((ann   (car annotation.type))
        (type  (cdr annotation.type)))
    (cl-case type
      (FILE       (find-file-other-window     ann))
      (URL        (browse-url                 ann))
      (BOOKMARK   (bmkx-jump-other-window ann))
      (otherwise  (error "`bmkx-visit-external-annotation': Bad annotation type: `%S'" type)))
    (when msg-p
      (message "Showing external annotation of type %s" type) (sit-for 1))))

;;;;;;;;;;;;;;;;;;;;;;;

(provide 'bookmark-x-1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; bookmark-x-1.el ends here
