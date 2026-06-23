;;; bookmark-x.el --- Extended bookmarks: types, tags, highlights, autofile, more  -*- lexical-binding:t -*-
;;
;; Filename:    bookmark-x.el
;; Description: Bookmark-X: extensions to standard library `bookmark.el'.
;;              Fork of Drew Adams' Bookmark+, modernized for Emacs 30+.
;;
;; Author:     Drew Adams, Thierry Volpiatto
;; Maintainer: Daniel M. German <dmg@turingmachine.org>
;;
;; Copyright (C) 2000-2025, Drew Adams, all rights reserved.
;; Copyright (C) 2009, Thierry Volpiatto, all rights reserved.
;; Copyright (C) 2026, Daniel M. German, all rights reserved.
;;
;; Created: Fri Sep 15 07:58:41 2000
;; Version: 2026.06.23
;;
;; URL: https://github.com/dmgerman/bookmarx
;;
;; Keywords:         convenience, hypermedia, bookmarks, projects, placeholders, annotations, search, info, url, eww, gnus
;; Package-Requires: ((emacs "30.1"))
;; Compatibility:    GNU Emacs 30+
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
;;    Bookmark-X: extensions to standard library `bookmark.el'.
;;
;;    The Bookmark-X libraries are these:
;;
;;    `bookmark-x.el'     - main (driver) library (this file)
;;    `bookmark-x-mac.el' - Lisp macros
;;    `bookmark-x-lit.el' - (optional) code for highlighting bookmarks
;;    `bookmark-x-bmu.el' - code for the `*Bmkx List*' (bmenu)
;;    `bookmark-x-1.el'   - other required code (non-bmenu)
;;    `bookmark-x-key.el' - key and menu bindings
;;
;;    User documentation is the `bookmark-x' Info manual.  See
;;    `M-x info RET m bookmark-x RET' or the source in
;;    `doc/bookmark-x.texi'.
;;
;;    To report Bookmark-X bugs: `M-x customize-group bookmark-plus'
;;    and then follow (e.g. click) the link `Send Bug Report', which
;;    helps you prepare an email to me.
;;
;;
;;    ****** NOTE ******
;;
;;      Whenever you update Bookmark-X (i.e., download new versions of
;;      Bookmark-X source files), I recommend that you do the
;;      following:
;;
;;      1. Delete all existing byte-compiled Bookmark-X files
;;         (bookmark-x*.elc).
;;      2. Load Bookmark-X (`load-library' or `require').
;;      3. Byte-compile the source files.
;;
;;      In particular, always load `bookmark-x-mac.el' (not
;;      `bookmark-x-mac.elc') before you byte-compile new versions of
;;      the files, in case there have been any changes to Lisp macros
;;      (in `bookmark-x-mac.el').
;;
;;    ******************
;;
;;
;;    ****** NOTE ******
;;
;;      On 2010-06-18, I changed the prefix used by package Bookmark-X
;;      from `bookmarkp-' to `bmkx-'.  THIS IS AN INCOMPATIBLE CHANGE.
;;      I apologize for the inconvenience, but the new prefix is
;;      preferable for a number of reasons, including easier
;;      distinction from standard `bookmark.el' names.
;;
;;      This change means that YOU MUST MANUALLY REPLACE ALL
;;      OCCURRENCES of `bookmarkp-' by `bmkx-' in the following
;;      places, if you used Bookmark-X prior to this change:
;;
;;      1. In your init file (`~/.emacs') or your `custom-file', if
;;         you have one.  This is needed if you customized any
;;         Bookmark-X features.
;;
;;      2. In your default bookmark file, `bookmark-default-file'
;;         (`~/.emacs.bmk'), and in any other bookmark files you might
;;         have.
;;
;;      3. In your `*Bmkx List*' state file,
;;         `bmkx-bmenu-state-file' (`~/.emacs-bmk-bmenu-state.el').
;;
;;      4. In your `*Bmkx List*' commands file,
;;         `bmkx-bmenu-commands-file' (`~/.emacs-bmk-bmenu-commands.el'),
;;         if you have one.
;;
;;      You can do this editing in a virgin Emacs session (`emacs
;;      -Q'), that is, without loading Bookmark-X.
;;
;;      Alternatively, you can do this editing in an Emacs session
;;      where Bookmark-X has been loaded, but in that case you must
;;      TURN OFF AUTOMATIC SAVING of both your default bookmark file
;;      and your `*Bmkx List*' state file.  Otherwise, when you
;;      quit Emacs your manually edits will be overwritten.
;;
;;      To turn off this automatic saving, you can use `M-~' and `M-l'
;;      in buffer `*Bmkx List*' (commands
;;      `bmkx-toggle-saving-bookmark-file' and
;;      `bmkx-toggle-saving-menu-list-state' - they are also in the
;;      `Bookmark-X' menu).
;;
;;
;;      Again, sorry for this inconvenience.
;;
;;    ******************
;;
;;
;;  Commands defined here:
;;
;;    `bmkx-version'.
;;
;;  Internal variables defined here:
;;
;;    `bmkx-version-number'.
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

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;

(when (< emacs-major-version 30)
  (error "Bookmark-X requires Emacs 30 or newer (this is Emacs %s)"
         emacs-version))

(require 'bookmark)                     ; Built-in.

;;;###autoload (autoload 'bmkx-version-number "bookmark-x")
(defconst bmkx-version-number "2023.10.26")

;;;###autoload (autoload 'bmkx-version "bookmark-x")
(defun bmkx-version ()
  "Show version number of library `bookmark-x.el'."
  (interactive)
  (message "Bookmark-X, version %s" bmkx-version-number))

;; This was made automatically buffer-local for built-in Emacs 28.  Do it here, for all Bookmark-X files.
(defvar bookmark-annotation-name nil
  "Name of bookmark under edit in `bookmark-edit-annotation-mode'.")
(make-variable-buffer-local 'bookmark-annotation-name)

;;;###autoload (autoload 'bookmark-bmenu-buffer "bookmark-x")
;; This was added for built-in Emacs 28.  Add it here for older releases.
(defconst bookmark-bmenu-buffer "*Bmkx List*"
  "Name of buffer used by built-in Emacs for the bookmark-list display.")

;;;###autoload (autoload 'bookmark-plus "bookmark-x")
(defgroup bookmark-plus nil
  "Bookmark enhancements."
  :prefix "bmkx-" :group 'bookmark
  :link `(url-link :tag "Send Bug Report"
          ,(concat "mailto:" "drew.adams" "@" "oracle" ".com?subject=\
Bookmark-X bug: \
&body=Describe bug here, starting with `emacs -Q'.  \
Don't forget to mention your Emacs and library versions."))
  :link '(url-link :tag "Download" "https://www.emacswiki.org/emacs/download/bookmark%2b.el")
  :link '(url-link :tag "Description" "https://www.emacswiki.org/emacs/BookmarkPlus")
  :link '(emacs-commentary-link :tag "Commentary" "bookmark-x"))

;; NOTE:
;; $$$$$$ Currently all built-in Emacs functions that use constant `bookmark-bmenu-buffer' are
;; already redefined for Bookmark-X.  But if built-in Emacs adds more such functions, and if those
;; functions could be invoked somehow when using Bookmark-X, and if `bmkx-bmenu-buffer' has a
;; different value from `bookmark-bmenu-buffer', then some adjustment of Bookmark-X code will be
;; needed, to make sure the `bmkx-bmenu-buffer' value gets used instead.
;;
;;;###autoload (autoload 'bmkx-bmenu-buffer "bookmark-x")
(defcustom bmkx-bmenu-buffer bookmark-bmenu-buffer
  "Name of buffer used by Bookmark-X for the bookmark-list display.
The default value is that of built-in Emacs constant `bookmark-bmenu-buffer'."
  :type 'string :group 'bookmark-plus)



;; Load Bookmark-X libraries.
;;
(eval-when-compile
 (or (condition-case nil
         (load-library "bookmark-x-mac") ; Lisp macros.
       (error nil))                     ; Use load-library to ensure latest .elc.
     (require 'bookmark-x-mac)))         ; Require, so can load separately if not on `load-path'.

(require 'bookmark-x-lit nil t)          ; Optional (soft require) - no error if not found.  If you do
                                        ; not want to use `bookmark-x-lit.el' then simply do not put
                                        ; that file in your `load-path'.
(require 'bookmark-x-bmu)                ; `*Bmkx List*' (aka "menu list") stuff.
(require 'bookmark-x-1)                  ; Rest of Bookmark-X, except keys & menus.
(require 'bookmark-x-key)                ; Keys & menus.
(require 'bookmark-x-preview)            ; Live preview for jump and `*Bmkx List*'.
;; Optional Casual transient menu.  Try eagerly (in case `casual-lib' is
;; already available or installable now) and also defer until after
;; `casual-lib' loads -- whichever fires first.  The require is soft in
;; both branches, so if `casual-lib' is never installed nothing breaks.
(when (locate-library "casual-lib")
  (require 'casual-bmkx nil t))
(with-eval-after-load 'casual-lib
  (require 'casual-bmkx nil t))

;;;;;;;;;;;;;;;;;;;;;;;

(provide 'bookmark-x)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; bookmark-x.el ends here
