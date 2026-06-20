;;; bookmark-x-lit.el --- Bookmark highlighting for Bookmark-X.   -*- lexical-binding:t -*-
;;
;; Filename:    bookmark-x-lit.el
;; Description: Bookmark highlighting for Bookmark-X.
;;              Fork of Drew Adams' Bookmark+, modernized for Emacs 30+.
;;
;; Author:     Drew Adams
;; Maintainer: Daniel M. German <dmg@turingmachine.org>
;;
;; Copyright (C) 2010-2023, Drew Adams, all rights reserved.
;; Copyright (C) 2026, Daniel M. German, all rights reserved.
;;
;; Created: Wed Jun 23 07:49:32 2010 (-0700)
;;
;; URL: https://github.com/dmgerman/bookmarx
;;
;; Keywords:      bookmarks, highlighting
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
;;   `macroexp', `pp', `pp+', `replace', `syntax', `text-mode',
;;   `thingatpt', `vline'.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;;    Bookmark highlighting for Bookmark-X (library `bookmark-x.el').
;;
;;    The Bookmark-X libraries are:
;;
;;    `bookmark-x.el'     - main code library
;;    `bookmark-x-mac.el' - Lisp macros
;;    `bookmark-x-lit.el' - code for highlighting bookmarks (this file)
;;    `bookmark-x-bmu.el' - code for the `*Bmkx List*'
;;    `bookmark-x-1.el'   - other required code (non-bmenu)
;;    `bookmark-x-key.el' - key and menu bindings
;;
;;    This library (`bookmark-x-lit.el') is a Bookmark-X option.  If you
;;    want to use it then load it before loading `bookmark-x.el', so
;;    that its commands can be bound to keys and menu items.
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
;;  (@> "Faces (Customizable)")
;;  (@> "User Options (Customizable)")
;;  (@> "Internal Variables")
;;  (@> "Functions")
;;    (@> "Menu-List (`*-bmenu-*') Commands")
;;    (@> "General Highlight Commands")
;;    (@> "Other Functions")
 
;;(@* "Things Defined Here")
;;
;;  Things Defined Here
;;  -------------------
;;
;;  Commands defined here:
;;
;;
;;    `bmkx-bmenu-light', `bmkx-bmenu-light-marked',
;;    `bmkx-bmenu-set-lighting', `bmkx-bmenu-set-lighting-for-marked',
;;    `bmkx-bmenu-show-only-lighted-bookmarks', `bmkx-bmenu-unlight',
;;    `bmkx-bmenu-unlight-marked', `bmkx-bookmarks-lighted-at-point',
;;    `bmkx-cycle-lighted-this-buffer',
;;    `bmkx-cycle-lighted-this-buffer-other-window',
;;    `bmkx-describe-bookmark-lighted-on-this-line',
;;    `bmkx-light-autonamed-this-buffer', `bmkx-light-bookmark',
;;    `bmkx-light-bookmark-this-buffer', `bmkx-light-bookmarks',
;;    `bmkx-light-bookmarks-in-region',
;;    `bmkx-light-navlist-bookmarks',
;;    `bmkx-light-non-autonamed-this-buffer',
;;    `bmkx-light-this-buffer', `bmkx-lighted-here-jump-to-list',
;;    `bmkx-lighted-jump', `bmkx-lighted-jump-other-window',
;;    `bmkx-next-lighted-this-buffer',
;;    `bmkx-next-lighted-this-buffer-repeat',
;;    `bmkx-previous-lighted-this-buffer',
;;    `bmkx-previous-lighted-this-buffer-repeat',
;;    `bmkx-set-lighting-for-bookmark',
;;    `bmkx-set-lighting-for-buffer',
;;    `bmkx-set-lighting-for-this-buffer',
;;    `bmkx-toggle-auto-light-when-jump',
;;    `bmkx-toggle-auto-light-when-set',
;;    `bmkx-unlight-autonamed-this-buffer', `bmkx-unlight-bookmark',
;;    `bmkx-unlight-bookmark-on-this-line',
;;    `bmkx-unlight-bookmark-this-buffer', `bmkx-unlight-bookmarks',
;;    `bmkx-unlight-non-autonamed-this-buffer',
;;    `bmkx-unlight-this-buffer'.
;;
;;  User options defined here:
;;
;;    `bmkx-auto-light-relocate-when-jump-flag',
;;    `bmkx-auto-light-when-jump', `bmkx-auto-light-when-set',
;;    `bmkx-light-left-fringe-bitmap' (Emacs 22+),
;;    `bmkx-light-priorities', `bmkx-light-right-fringe-bitmap' (Emacs
;;    22+), `bmkx-light-style-autonamed',
;;    `bmkx-light-style-non-autonamed', `bmkx-light-threshold',
;;    `bmkx-tooltip-content-function'.
;;
;;  Faces defined here:
;;
;;    `bmkx-light-autonamed', `bmkx-light-fringe-autonamed' (Emacs
;;    22+), `bmkx-light-fringe-non-autonamed' (Emacs 22+),
;;    `bmkx-light-mark', `bmkx-light-non-autonamed'.
;;
;;  Non-interactive functions defined here:
;;
;;    `bmkx-a-bookmark-lighted-at-pos',
;;    `bmkx-a-bookmark-lighted-on-this-line',
;;    `bmkx-bookmark-data-from-record',
;;    `bmkx-bookmark-name-from-record', `bmkx-bookmark-overlay-p',
;;    `bmkx-choose-bookmark-lighted-at-point', `bmkx-default-lighted',
;;    `bmkx-fringe-string' (Emacs 22+), `bmkx-get-lighting',
;;    `bmkx-lighted-p', `bmkx-light-face', `bmkx-light-style',
;;    `bmkx-light-style-choices', `bmkx-light-when',
;;    `bmkx-lighted-alist-only', `bmkx-lighting-attribute',
;;    `bmkx-lighting-face', `bmkx-lighting-style',
;;    `bmkx-lighting-when', `bmkx-make/move-fringe' (Emacs 22+),
;;    `bmkx-make/move-overlay-of-style', `bmkx-make-obsolete',
;;    `bmkx-number-lighted', `bmkx-overlay-of-bookmark',
;;    `bmkx--pop-to-buffer-same-window',
;;    `bmkx-read-set-lighting-args',
;;    `bmkx-set-lighting-for-bookmarks',
;;    `bmkx-this-buffer-lighted-alist-only',
;;    `bookmark-name-from-full-record', `bookmark-name-from-record'.
;;
;;  Internal variables defined here:
;;
;;    `bmkx-autonamed-overlays', `bmkx-last-auto-light-when-jump',
;;    `bmkx-last-auto-light-when-set', `bmkx-light-styles-alist',
;;    `bmkx-non-autonamed-overlays'.
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

(require 'bookmark)
;; bookmark-alist, bmkx-list-bookmark, bmkx-completing-read, bmkx-get-bookmark,
;; bookmark-get-position, bmkx-handle-bookmark, bmkx-maybe-load-default-file,
;; bookmark-name-from-full-record, bookmark-name-from-record, bookmark-prop-get, bmkx-prop-set
;; (Note: bmkx-prop-set is provided by bookmark-x-1.el.)


;; Just repeat definition of `bmkx-make-obsolete', to make requires less complicated.
;;   (require 'bookmark-x-1) ;; bmkx-make-obsolete
;;
(defun bmkx-make-obsolete (obsolete-name current-name &optional when)
  "Same as `make-obsolete'."
  (make-obsolete obsolete-name current-name when))


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


(eval-when-compile
 (or (condition-case nil
         (load-library "bookmark-x-mac") ; Use load-library to ensure latest .elc.
       (error nil))
     (require 'bookmark-x-mac)))         ; Require, so can load separately if not on `load-path'.
;; bmkx-define-show-only-command


(require 'bookmark-x-bmu)
;; bmkx-bmenu-barf-if-not-in-menu-list, bmkx-bmenu-filter-function,
;; bmkx-bmenu-title

(require 'bookmark-x-1)
;; bmkx-autonamed-bookmark-p, bmkx-autonamed-this-buffer-alist-only,
;; bmkx-autoname-format, bmkx-current-nav-bookmark,
;; bmkx-current-sort-order, bmkx-cycle-1, bmkx-default-bookmark-name,
;; bmkx-function-bookmark-p, bmkx-get-bookmark-in-alist, bmkx-get-buffer-name, bmkx-jump-1,
;; bmkx-latest-bookmark-alist, bmkx-marked-bookmarks-only,
;; bmkx-msg-about-sort-order, bmkx-nav-alist, bmkx-refresh-menu-list,
;; bmkx-remove-if, bmkx-remove-if-not, bmkx-repeat-command,
;; bmkx-sequence-bookmark-p, bmkx-sort-omit,
;; bmkx-specific-buffers-alist-only, bmkx-this-buffer-alist-only,
;; bmkx-this-file/buffer-cycle-sort-comparer, bmkx-this-buffer-p

(require 'pp+ nil t) ;; pp-read-expression-map

;;;;;;;;;;;;;;;;;;;;;;;

;; Quiet the byte-compiler
;;
(defvar bmkx-autoname-format)           ; In `bookmark-x-1.el'.
(defvar bmkx-bmenu-buffer)              ; In `bookmark-x.el'
(defvar bmkx-current-nav-bookmark)      ; In `bookmark-x-1.el'.
(defvar bmkx-latest-bookmark-alist)     ; In `bookmark-x-1.el'.
(defvar bmkx-light-left-fringe-bitmap)  ; Defined in this file for Emacs 22+.
(defvar bmkx-light-right-fringe-bitmap) ; Defined in this file for Emacs 22+.
(defvar bmkx-nav-alist)                 ; In `bookmark-x-1.el'.
(defvar bmkx-this-file/buffer-cycle-sort-comparer) ; In `bookmark-x-1.el'.
(defvar fringe-bitmaps)                 ; Built-in for Emacs 22+.

 
;;(@* "Faces (Customizable)")
;;; Faces (Customizable) ---------------------------------------------

(defface bmkx-light-autonamed
    '((((background dark)) (:background "#00004AA652F1")) ; a dark cyan
      (t (:background "misty rose")))   ; a light pink
  "*Face used to highlight an autonamed bookmark (except in the fringe)."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-light-autonamed-region
    '((((background dark)) (:background "#22225F5F2222")) ; a dark green
      (t (:background "plum")))   ; a light magenta
  "*Face used to highlight an autonamed bookmark (except in the fringe)."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-light-fringe-autonamed
    '((((background dark)) (:background "#B19E6A64B19E")) ; a dark magenta
      (t (:background "#691DC8A2691D"))) ; a medium green
  "*Face used to highlight an autonamed bookmark in the fringe."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-light-fringe-non-autonamed
    '((((background dark)) (:background "#691DC8A2691D")) ; a medium green
      (t (:foreground "Black" :background "Plum"))) ; a light magenta
  "*Face used to highlight a non-autonamed bookmark in the fringe."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-light-mark '((t (:background "Plum")))
  "*Face used to mark bookmarks with highlight overrides, in bookmark list.
This face must be combinable with face `bmkx-t-mark'."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-light-non-autonamed
    '((((background dark)) (:background "#B19E6A64B19E")) ; a dark magenta
      (t (:background "DarkSeaGreen1"))) ; a light green
  "*Face used to highlight a non-autonamed bookmark (except in the fringe)."
  :group 'bookmark-plus :group 'faces)

(defface bmkx-light-non-autonamed-region
    '((((background dark)) (:background "#BFBF1F1F2F2F")) ; a dark red
      (t (:background "turquoise")))
  "*Face used to highlight a non-autonamed bookmark (except in the fringe)."
  :group 'bookmark-plus :group 'faces)

;; Emacs bug # prevents making use of a face in a tooltip.
;;
;; (defface bmkx-tooltip-content-face
;;   '((((class color))
;;      :background "lightyellow"
;;      :foreground "black"
;;      :family     "Courier")
;;     (t
;;      :family     "Courier"))
;;   "Face for mouseover tooltip content for highlighted bookmarks."
;;   :group 'bookmark-plus :group 'faces :group 'tooltip)
 
;;(@* "User Options (Customizable)")
;;; User Options (Customizable) --------------------------------------

;;;###autoload (autoload 'bmkx-auto-light-relocate-when-jump-flag "bookmark-x")
(defcustom bmkx-auto-light-relocate-when-jump-flag t
  "*Non-nil means highlight the relocated, instead of the recorded, position.
This has an effect only when the highlighting style for the bookmark
is `point'."
  :type 'boolean :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-auto-light-when-jump "bookmark-x")
(defcustom bmkx-auto-light-when-jump nil
  "*Which bookmarks to automatically highlight when jumped to.
NOTE: The values that specify highlighting in the current buffer
highlight bookmarks in the buffer that is current after jumping.  If
the bookmark does not really have an associated buffer, for example a
bookmark with a handler such as `w32-browser' that just invokes a
separate, non-Emacs program, then the current buffer after jumping
will be the buffer before jumping."
  :type '(choice
          (const :tag "Autonamed bookmark"                 autonamed-bookmark)
          (const :tag "Non-autonamed bookmark"             non-autonamed-bookmark)
          (const :tag "Any bookmark"                       any-bookmark)
          (const :tag "Autonamed bookmarks in buffer"      autonamed-in-buffer)
          (const :tag "Non-autonamed bookmarks in buffer"  non-autonamed-in-buffer)
          (const :tag "All bookmarks in buffer"            all-in-buffer)
          (const :tag "None (no automatic highlighting)"   nil))
  :group 'bookmark-plus)

;; The value is not correct if user customizes `bmkx-auto-light-when-jump' to non-nil.
;; So must compensate in `bmkx-toggle-auto-light-when-jump'.
(defvar bmkx-last-auto-light-when-jump (and (not bmkx-auto-light-when-jump)  'all-in-buffer)
  "Last value of `bmkx-auto-light-when-jump'.")

;;;###autoload (autoload 'bmkx-auto-light-when-set "bookmark-x")
(defcustom bmkx-auto-light-when-set nil
  "*Which bookmarks to automatically highlight when set."
  :type '(choice
          (const :tag "Autonamed bookmark"                 autonamed-bookmark)
          (const :tag "Non-autonamed bookmark"             non-autonamed-bookmark)
          (const :tag "Any bookmark"                       any-bookmark)
          (const :tag "Autonamed bookmarks in buffer"      autonamed-in-buffer)
          (const :tag "Non-autonamed bookmarks in buffer"  non-autonamed-in-buffer)
          (const :tag "All bookmarks in buffer"            all-in-buffer)
          (const :tag "None (no automatic highlighting)"   nil))
  :group 'bookmark-plus)

;; The value is not correct if user customizes `bmkx-auto-light-when-set' to non-nil.
;; So must compensate in `bmkx-toggle-auto-light-when-set'.
(defvar bmkx-last-auto-light-when-set (and (not bmkx-auto-light-when-set)  'all-in-buffer)
  "Last value of `bmkx-auto-light-when-set'.")

;;;###autoload (autoload 'bmkx-light-priorities "bookmark-x")
(defcustom bmkx-light-priorities '((bmkx-autonamed-overlays        . 160)
                                   (bmkx-non-autonamed-overlays    . 150))
  "*Priorities of bookmark highlighting overlay types.
As an idea, `isearch' uses 1000 and 1001."
  :group 'bookmark-plus :type '(alist :key-type symbol :value-type integer))

;; Not used on Emacs built without fringe support.
(when (boundp 'fringe-bitmaps)
  (defcustom bmkx-light-left-fringe-bitmap 'left-triangle
    "*Symbol for the left fringe bitmap to use to highlight a bookmark."
    :type (cons 'choice (mapcar (lambda (bb) (list 'const bb)) fringe-bitmaps))
    :group 'bookmark-plus)

  (defcustom bmkx-light-right-fringe-bitmap 'right-triangle
    "*Symbol for the right fringe bitmap to use to highlight a bookmark."
    :type (cons 'choice (mapcar (lambda (bb) (list 'const bb)) fringe-bitmaps))
    :group 'bookmark-plus))

;; Must be before any options that use it.
(defvar bmkx-light-styles-alist '(("Region"              . region)
                                  ("Line Beginning"      . bol)
                                  ("Position"            . point)
                                  ("Line"                . line)
                                  ("None"                . none)
                                  ("Left Fringe"         . lfringe)
                                  ("Right Fringe"        . rfringe)
                                  ("Left Fringe + Line"  . line+lfringe)
                                  ("Right Fringe + Line" . line+rfringe))
  "Alist of highlighting styles.  Key: string description.  Value: symbol.")

;; Must be before options that use it.
(defun bmkx-light-style-choices ()
  "Return custom `:type' used for bookmark highlighting style choices."
  (cons 'choice
        (mapcar (lambda (xx) (list 'const :tag (car xx) (cdr xx))) bmkx-light-styles-alist)))

;;;###autoload (autoload 'bmkx-light-style-autonamed "bookmark-x")
(defcustom bmkx-light-style-autonamed 'line+lfringe
  "*Default highlight style for autonamed bookmarks."
  :group 'bookmark-plus :type (bmkx-light-style-choices))

;;;###autoload (autoload 'bmkx-light-style-non-autonamed "bookmark-x")
(defcustom bmkx-light-style-non-autonamed 'line+rfringe
  "*Default highlight style for non-autonamed bookmarks."
  :group 'bookmark-plus :type (bmkx-light-style-choices))

;;;###autoload (autoload 'bmkx-light-style-autonamed-region "bookmark-x")
(defcustom bmkx-light-style-autonamed-region  'region
  "*Default highlight style for autonamed region bookmarks."
  :group 'bookmark-plus :type (bmkx-light-style-choices))

;;;###autoload (autoload 'bmkx-light-style-non-autonamed-region "bookmark-x")
(defcustom bmkx-light-style-non-autonamed-region 'region
  "*Default highlight style for non-autonamed region bookmarks."
  :group 'bookmark-plus :type (bmkx-light-style-choices))

;;;###autoload (autoload 'bmkx-light-threshold "bookmark-x")
(defcustom bmkx-light-threshold 100000
  "*Maximum number of bookmarks to highlight."
  :type 'integer :group 'bookmark-plus)

;;;###autoload (autoload 'bmkx-tooltip-content-function "bookmark-x")
(defcustom bmkx-tooltip-content-function 'bmkx-bookmark-description
  "Function providing mouseover tooltip content for highlighted bookmarks.
It should accept a bookmark name or record as its first arg and return
a value acceptable as a `help-echo' property value.

One alternative to the default value of `bmkx-bookmark-description' is
`bmkx-annotation-or-bookmark-description', which shows the bookmark
annotation if there is one, or the full description if not.

To prevent showing any tooltip you can use a function, such as
`ignore', that returns nil."
  :type 'function :group 'bookmark-plus :group 'tooltip)
 
;;(@* "Internal Variables")
;;; Internal Variables -----------------------------------------------

(defvar bmkx-autonamed-overlays nil
  "Overlays used to highlight autonamed bookmarks.")

(defvar bmkx-non-autonamed-overlays nil
  "Overlays used to highlight non-autonamed bookmarks.")
 
;;(@* "Functions")
;;; Functions --------------------------------------------------------


;;(@* "Menu-List (`*-bmenu-*') Commands")
;;  *** Menu-List (`*-bmenu-*') Commands ***

;;;###autoload (autoload 'bmkx-bmenu-show-only-lighted-bookmarks "bookmark-x")
(bmkx-define-show-only-command lighted "Display (only) the highlighted bookmarks." ; `H S' in bookmark list
                               bmkx-lighted-alist-only)

;;;###autoload (autoload 'bmkx-bmenu-light "bookmark-x")
(defun bmkx-bmenu-light ()              ; `H H' in bookmark list
  "Highlight the location of this line's bookmark."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-light-bookmark (bmkx-list-bookmark) nil nil 'MSG))

;;;###autoload (autoload 'bmkx-bmenu-light-marked "bookmark-x")
(defun bmkx-bmenu-light-marked (&optional msgp) ; `H > H' in bookmark list
  "Highlight the marked bookmarks.
When called from Lisp, non-nil MSGP means echo status messages."
  (interactive (list 'MSG))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (when msgp (message "Highlighting marked bookmarks..."))
  (let ((marked  (bmkx-marked-bookmarks-only)))
    (unless marked (error "No marked bookmarks"))
    (dolist (bmk  marked) (bmkx-light-bookmark bmk)))
  (when msgp (message "Highlighting marked bookmarks...done")))

;;;###autoload (autoload 'bmkx-bmenu-unlight "bookmark-x")
(defun bmkx-bmenu-unlight ()            ; `H U' in bookmark list
  "Unhighlight the location of this line's bookmark."
  (interactive)
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-unlight-bookmark (bmkx-list-bookmark) 'NOERROR))

;;;###autoload (autoload 'bmkx-bmenu-unlight-marked "bookmark-x")
(defun bmkx-bmenu-unlight-marked (&optional msgp) ; `H > U' in bookmark list
  "Unhighlight the marked bookmarks.
When called from Lisp, non-nil MSGP means echo status messages."
  (interactive (list 'MSG))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (when msgp (message "Unhighlighting marked bookmarks..."))
  (let ((marked  (bmkx-marked-bookmarks-only)))
    (unless marked (error "No marked bookmarks"))
    (dolist (bmk  marked) (bmkx-unlight-bookmark bmk t)))
  (when msgp (message "Unhighlighting marked bookmarks...done")))

;;;###autoload (autoload 'bmkx-bmenu-set-lighting "bookmark-x")
(defun bmkx-bmenu-set-lighting (style face when &optional msgp) ; `H +' in bookmark list
  "Set the `lighting' entry for this line's bookmark.
You are prompted for the highlight STYLE, FACE, and condition (WHEN)
that make up the property-list value of the `lighting' entry.

When called from Lisp, the arguments are passed to
`bmkx-set-lighting-for-bookmark' for the current line's bookmark."
  (interactive
   (let* ((bmk        (bmkx-list-bookmark))
          (bmk-style  (bmkx-lighting-style bmk))
          (bmk-face   (bmkx-lighting-face bmk))
          (bmk-when   (bmkx-lighting-when bmk)))
     (append (bmkx-read-set-lighting-args
              (and bmk-style  (format "%s" (car (rassq bmk-style bmkx-light-styles-alist))))
              (and bmk-face   (format "%S" bmk-face))
              (and bmk-when   (format "%S" bmk-when)))
             '(MSG))))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (bmkx-set-lighting-for-bookmark (bmkx-list-bookmark) style face when msgp))

;;;###autoload (autoload 'bmkx-bmenu-set-lighting-for-marked "bookmark-x")
(defun bmkx-bmenu-set-lighting-for-marked (style face when &optional msgp) ; `H > +' in bookmark list
  "Set the `lighting' entry for the marked bookmarks.
You are prompted for the highlight STYLE, FACE, and condition (WHEN)
that make up the property-list value of the `lighting' entry.

When called from Lisp, the args are passed to `bmkx-prop-set' for
the current line's bookmark."
  (interactive (append (bmkx-read-set-lighting-args) '(MSG)))
  (bmkx-bmenu-barf-if-not-in-menu-list)
  (when msgp (message "Setting highlighting..."))
  (let ((marked    (bmkx-marked-bookmarks-only))
        (curr-bmk  (bmkx-list-bookmark)))
    (unless marked (error "No marked bookmarks"))
    (dolist (bmk  marked)
      (bmkx-prop-set bmk 'lighting (if (or face  style  when)
                                           `(,@(and face   (not (eq face 'auto))   `(:face ,face))
                                             ,@(and style  (not (eq style 'none))  `(:style ,style))
                                             ,@(and when   (not (eq when 'auto))   `(:when ,when)))
                                         ())))
    (when (get-buffer-create bmkx-bmenu-buffer) (bmkx-refresh-menu-list curr-bmk)))
  (when msgp (message "Setting highlighting...done")))


;;(@* "General Highlight Commands")
;;  *** General Highlight Commands ***

;;;###autoload (autoload 'bmkx-bookmarks-lighted-at-point "bookmark-x")
(defun bmkx-bookmarks-lighted-at-point (&optional position fullp msgp) ; `C-x x ='
  "Return a list of the bookmarks highlighted at point.
Include only those in the current bookmark list (`bookmark-alist').
With no prefix arg, return the bookmark names.
With a prefix arg, return the full bookmark data.
Interactively, display the info.

Non-interactively:
 Use the bookmarks at optional arg POSITION (default: point).
 Optional arg FULLP means return full bookmark data.
 Optional arg MSGP means display the info."
  (interactive (list (point) current-prefix-arg 'MSG))
  (unless position (setq position  (point)))
  (let ((bmks  ())
        bmk)
    (dolist (ov  (overlays-at position))
      (when (setq bmk  (overlay-get ov 'bookmark))
        (when (setq bmk  (bmkx-get-bookmark-in-alist bmk 'NOERROR)) ; Ensure it's in current bookmark list.
          (push (if fullp bmk (bmkx-bookmark-name-from-record bmk)) bmks))))
    (if (not fullp)
        (when msgp (message "%s" bmks))
      (setq bmks  (mapcar #'bmkx-get-bookmark bmks))
      (when msgp (pp-eval-expression 'bmks)))
    bmks))

;;;###autoload (autoload 'bmkx-toggle-auto-light-when-jump "bookmark-x")
(defun bmkx-toggle-auto-light-when-jump (&optional msgp) ; Not bound.
  "Toggle automatic bookmark highlighting when a bookmark is jumped to.
Set option `bmkx-auto-light-when-jump' to nil if non-nil, and to its
last non-nil value if nil.

Non-interactively, non-nil MSGP means echo a status message."
  (interactive "p")
  (when (and bmkx-auto-light-when-jump  bmkx-last-auto-light-when-jump) ; Compensate for wrong default
    (setq bmkx-last-auto-light-when-jump  nil))
  (setq bmkx-last-auto-light-when-jump
        (prog1 bmkx-auto-light-when-jump ; Swap
          (setq bmkx-auto-light-when-jump  bmkx-last-auto-light-when-jump)))
  (when msgp (message "Automatic highlighting of bookmarks when jumping is now %s"
                      (if bmkx-auto-light-when-jump
                          (upcase (symbol-name bmkx-auto-light-when-jump))
                        "OFF"))))
                                        
;;;###autoload (autoload 'bmkx-lighted-jump "bookmark-x")
(defun bmkx-lighted-jump (bookmark-name &optional flip-use-region-p) ; `C-x j h'
  "Jump to a highlighted bookmark.
This is a specialization of `bmkx-jump' - see that, in particular
for info about using a prefix argument."
  (interactive
   (let ((alist  (bmkx-lighted-alist-only)))
     (unless alist  (error "No highlighted bookmarks"))
     (list (bmkx-completing-read "Jump to highlighted bookmark" nil alist) current-prefix-arg)))
  (bmkx-jump-1 bookmark-name 'bmkx--pop-to-buffer-same-window flip-use-region-p))

;;;###autoload (autoload 'bmkx-lighted-jump-other-window "bookmark-x")
(defun bmkx-lighted-jump-other-window (bookmark-name &optional flip-use-region-p) ; `C-x 4 j h'
  "Jump to a highlighted bookmark in another window.
See `bmkx-lighted-jump'."
  (interactive
   (let ((alist  (bmkx-lighted-alist-only)))
     (unless alist  (error "No highlighted bookmarks"))
     (list (bmkx-completing-read "Jump to highlighted bookmark in another window" nil alist)
           current-prefix-arg)))
  (bmkx-jump-1 bookmark-name 'bmkx-select-buffer-other-window flip-use-region-p))

;; Keep the alias for a while, in case someone has it referenced in a state file.
(defalias 'bmkx-lighted-jump-to-list 'bmkx-lighted-here-jump-to-list)
(bmkx-make-obsolete 'bmkx-lighted-jump-to-list 'bmkx-lighted-here-jump-to-list "2022-11-12")

;;;###autoload (autoload 'bmkx-lighted-here-jump-to-list "bookmark-x")
(defun bmkx-lighted-here-jump-to-list (bookmark) ; Not bound.
  "Jump to location in `*Bmkx List*' for a lighted BOOKMARK at point.
If there's more than one such bookmark then you're prompted for the
bookmark name.  Completion candidates are the names of the lighted
bookmarks at point."
  (interactive (list (bmkx-choose-bookmark-lighted-at-point)))
  (pop-to-buffer (get-buffer-create bmkx-bmenu-buffer))
  (bmkx-list)
  (bmkx-bmenu-goto-bookmark-named (setq bmkx-last-bmenu-bookmark  bookmark)))

(defun bmkx-choose-bookmark-lighted-at-point (&optional position noerrorp)
  "Return the name of a bookmark lighted at POSITION (default: point).
If there is more than one such, prompt user to choose one.
Optional arg POSITION is a buffer position to use instead of point.

Raise an error if there is no highlighted bookmark present, unless
optional arg NOERRORP is non-nil, in which case return nil."
  (let ((lbmks  (bmkx-bookmarks-lighted-at-point position)))
    (unless (or lbmks  noerrorp) (error "No highlighted bookmark %s" (if position "" "at point")))
    (if (cdr lbmks)
        (bmkx-completing-read "Bookmark" (car lbmks) lbmks)
      (car lbmks))))

;;;###autoload (autoload 'bmkx-unlight-bookmark "bookmark-x")
(defun bmkx-unlight-bookmark (bookmark &optional noerrorp msgp) ; Not bound
  "Unhighlight BOOKMARK.
BOOKMARK is a bookmark name or a bookmark record.
When called from Lisp:
 Non-nil NOERRORP means don't raise an error if not highlighted.
 NOn-nil MSGP means echo a status message."
  (interactive
   (let ((lighted-bmks  (bmkx-lighted-alist-only)))
     (unless lighted-bmks (error "No highlighted bookmarks"))
     (list (bmkx-completing-read "UNhighlight bookmark" (bmkx-default-lighted) lighted-bmks)
           nil
           'MSG)))
  (let* ((bmk         (bmkx-get-bookmark bookmark 'NOERROR))
         (bmk-name    (bmkx-bookmark-name-from-record bmk))
         (autonamedp  (and bmk  (bmkx-autonamed-bookmark-p bmk))))
    (when bmk                           ; Skip bad bookmark, but not already highlighted bookmark.
      (unless (or noerrorp  (bmkx-lighted-p bmk-name)) (error "Bookmark `%s' is not highlighted" bmk-name))
      (dolist (ov  (if autonamedp bmkx-autonamed-overlays bmkx-non-autonamed-overlays))
        (when (eq bmk (overlay-get ov 'bookmark))  (delete-overlay ov)))) ; Check full bookmark, not name.
    (when msgp (message "UNhighlighted bookmark `%s'" bmk-name))))

;; Keep the alias for a while, in case someone has it referenced in a state file.
(defalias 'bmkx-unlight-bookmark-here 'bmkx-unlight-bookmark-on-this-line)
(bmkx-make-obsolete 'bmkx-unlight-bookmark-here 'bmkx-unlight-bookmark-on-this-line "2022-11-12")

;;;###autoload (autoload 'bmkx-unlight-bookmark-on-this-line "bookmark-x")
(defun bmkx-unlight-bookmark-on-this-line (&optional noerrorp msgp) ; `C-x x C-u'
  "Unhighlight a highlighted bookmark on this line, preferably at point.
Other than preferring a bookmark at point, if more than one
highlighted bookmark is present then which one gets unhighlighted is
undefined.  When multiple highlighted bookmarks are present you might
want to use `\\[bmkx-bookmarks-lighted-at-point]' to see the names of all of the bookmarks at
point.

When called from Lisp:
 Non-nil NOERRORP means don't raise an error if not highlighted.
 NOn-nil MSGP means echo a status message."
  (interactive (list nil 'MSG))
  (let ((bmk  (or (bmkx-a-bookmark-lighted-at-pos)  (bmkx-a-bookmark-lighted-on-this-line))))
    (unless bmk (error "No highlighted bookmark on this line"))
    (bmkx-unlight-bookmark bmk noerrorp msgp)))

;;;###autoload (autoload 'bmkx-unlight-bookmark-this-buffer "bookmark-x")
(defun bmkx-unlight-bookmark-this-buffer (bookmark &optional noerrorp msgp) ; `C-x x u'
  "Unhighlight a BOOKMARK in this buffer.
BOOKMARK is a bookmark name or a bookmark record.
With a prefix arg, choose from all lighted bookmarks, not just those
in this buffer.

When called from Lisp:
 Non-nil NOERRORP means don't raise an error if not highlighted.
 NOn-nil MSGP means echo a status message."
  (interactive
   (let ((lighted-bmks  (if current-prefix-arg
                            (bmkx-lighted-alist-only)
                          (bmkx-this-buffer-lighted-alist-only)))
         (msg-suffix    (if current-prefix-arg "" " in this buffer")))
     (unless lighted-bmks (error "No highlighted bookmarks%s" msg-suffix))
     (list (bmkx-completing-read (format "UNhighlight bookmark%s in this buffer" msg-suffix)
                                     (bmkx-default-lighted)
                                     lighted-bmks
                                     nil
                                     nil
                                     'USE-NIL-ALIST-P)
           nil
           'MSG)))
  (bmkx-unlight-bookmark bookmark noerrorp msgp))

;;;###autoload (autoload 'bmkx-unlight-bookmarks "bookmark-x")
(defun bmkx-unlight-bookmarks (&optional overlays-symbols this-buffer-p msgp) ; `C-x x U'
  "Unhighlight lighted bookmarks.
A prefix argument determines which bookmarks to unhighlight:
 none    - Current buffer, all lighted bookmarks.
 >= 0    - Current buffer, only autonamed lighted bookmarks.
 < 0     - Current buffer, only non-autonamed lighted bookmarks.
 C-u     - All buffers (all lighted bookmarks).

Non-nil optional args used when called from Lisp:
 OVERLAYS-SYMBOLS is a list whose possible elements are
  `bmkx-autonamed-overlays' and `bmkx-non-autonamed-overlays'.
  These name the kinds of highlighting overlays to delete.
  An empty list is the same as a list with both symbols.
 THIS-BUFFER-P means delete only overlays in this buffer.
 MSGP means echo an action summary."
  (interactive (list (cond ((or (not current-prefix-arg)  (consp current-prefix-arg))
                            '(bmkx-autonamed-overlays bmkx-non-autonamed-overlays))
                           ((natnump current-prefix-arg) '(bmkx-autonamed-overlays))
                           (current-prefix-arg           '(bmkx-non-autonamed-overlays)))
                     (or (not current-prefix-arg)  (atom current-prefix-arg))
                     'MSG))
  (unless overlays-symbols (setq overlays-symbols  '(bmkx-autonamed-overlays bmkx-non-autonamed-overlays)))
  (let ((count           0)
        (count-auto      0)
        (count-non-auto  0)
        (this-buf        (current-buffer)))
    (dolist (ov-symb  overlays-symbols)
      (dolist (ov  (symbol-value ov-symb))
        (let ((ov-buf  (overlay-buffer ov)))
          (when (and ov-buf  (or (not this-buffer-p)  (eq ov-buf this-buf)))
            (when (eq 'bmkx-autonamed-overlays ov-symb)
              (setq count-auto  (1+ count-auto)
                    count       (1+ count)))
            (when (eq 'bmkx-non-autonamed-overlays ov-symb)
              (setq count-non-auto  (1+ count-non-auto)
                    count           (1+ count)))
            (delete-overlay ov)))))
    (when msgp (message "UNhighlighted %d bookmarks %s: %d autonamed, %d other"
                        count (if this-buffer-p "in this buffer" "(all buffers)")
                        count-auto count-non-auto))))

;;;###autoload (autoload 'bmkx-unlight-autonamed-this-buffer "bookmark-x")
(defun bmkx-unlight-autonamed-this-buffer (&optional everywherep) ; Not bound
  "Unhighlight autonamed bookmarks.
No prefix arg: unhighlight them only in the current buffer.
Prefix arg, unhighlight them everywhere.

Non-interactively, non-nil EVERYWHEREP means unhighlight everywhere."
  (interactive "P")
  (bmkx-unlight-bookmarks '(bmkx-autonamed-overlays) (not everywherep)))

;;;###autoload (autoload 'bmkx-unlight-non-autonamed-this-buffer "bookmark-x")
(defun bmkx-unlight-non-autonamed-this-buffer (&optional everywherep) ; Not bound
  "Unhighlight non-autonamed bookmarks.
No prefix arg: unhighlight them only in the current buffer.
Prefix arg, unhighlight them everywhere.

Non-interactively, non-nil EVERYWHEREP means unhighlight everywhere."
  (interactive "P")
  (bmkx-unlight-bookmarks '(bmkx-non-autonamed-overlays) (not everywherep)))

;;;###autoload (autoload 'bmkx-unlight-this-buffer "bookmark-x")
(defun bmkx-unlight-this-buffer ()      ; Not bound
  "Unhighlight all bookmarks in the current buffer."
  (interactive)
  (bmkx-unlight-bookmarks))

;;;###autoload (autoload 'bmkx-toggle-auto-light-when-set "bookmark-x")
(defun bmkx-toggle-auto-light-when-set (&optional msgp) ; Not bound.
  "Toggle automatic bookmark highlighting when a bookmark is set.
Set option `bmkx-auto-light-when-set' to nil if non-nil, and to its
last non-nil value if nil.

When called from Lisp, non-nil MSGP means echo the new status."
  (interactive "p")
  (when (and bmkx-auto-light-when-set  bmkx-last-auto-light-when-set) ; Compensate for wrong default
    (setq bmkx-last-auto-light-when-set  nil))
  (setq bmkx-last-auto-light-when-set  (prog1 bmkx-auto-light-when-set ; Swap
                                         (setq bmkx-auto-light-when-set  bmkx-last-auto-light-when-set)))
  (when msgp (message "Automatic highlighting of bookmarks when setting is now %s"
                      (if bmkx-auto-light-when-set
                          (upcase (symbol-name bmkx-auto-light-when-set))
                        "OFF"))))
                                        
;;;###autoload (autoload 'bmkx-set-lighting-for-bookmark "bookmark-x")
(defun bmkx-set-lighting-for-bookmark (bookmark-name style face when &optional msgp light-now-p) ; Not bound
  "Set the `lighting' entry for bookmark BOOKMARK-NAME.
You are prompted for the bookmark, highlight STYLE, FACE, and
condition (WHEN) that make up the property-list value of the
`lighting' entry.

With a prefix argument, do not highlight now.

If there's a highlighted bookmark at point or on its line, then that's
the default for BOOKMARK-NAME - use `\\<minibuffer-local-map>\\[next-history-element]' to retrieve it.

Non-interactively:
 STYLE, FACE, and WHEN are as for a bookmark's `lighting' entry
   properties, or nil if no such property.
 Non-nil MSGP means display a highlighting progress message.
 Non-nil LIGHT-NOW-P means apply the highlighting now."
  (interactive
   (let* ((bmk        (bmkx-completing-read "Highlight bookmark"
                                                (or (bmkx-default-lighted)  (bmkx-default-bookmark-name))))
          (bmk-style  (bmkx-lighting-style bmk))
          (bmk-face   (bmkx-lighting-face bmk))
          (bmk-when   (bmkx-lighting-when bmk)))
     (append (list bmk)
             (bmkx-read-set-lighting-args
              (and bmk-style  (format "%s" (car (rassq bmk-style bmkx-light-styles-alist))))
              (and bmk-face   (format "%S" bmk-face))
              (and bmk-when   (format "%S" bmk-when)))
             (list 'MSGP (not current-prefix-arg)))))
  (when msgp (message "Setting highlighting..."))
  (bmkx-prop-set bookmark-name 'lighting (if (or face  style  when)
                                                 `(,@(and face   (not (eq face 'auto))   `(:face ,face))
                                                   ,@(and style  (not (eq style 'none))  `(:style ,style))
                                                   ,@(and when   (not (eq when 'auto))   `(:when ,when)))
                                               ()))
  (when (get-buffer-create bmkx-bmenu-buffer) (bmkx-refresh-menu-list bookmark-name))
  (when msgp (message "Setting highlighting...done"))
  (when light-now-p (bmkx-light-bookmark bookmark-name nil nil msgp))) ; This msg is more informative.

;;;###autoload (autoload 'bmkx-set-lighting-for-buffer "bookmark-x")
(defun bmkx-set-lighting-for-buffer (buffer style face when &optional msgp light-now-p) ; Not bound
  "Set the `lighting' entry for each of the bookmarks for BUFFER.
You are prompted for the highlight STYLE, FACE, and condition (WHEN).
With a prefix argument, do not highlight now.

Non-interactively:
 STYLE, FACE, and WHEN are as for a bookmark's `lighting' entry
   properties, or nil if no such property.
 Non-nil MSGP means display a highlighting progress message.
 Non-nil LIGHT-NOW-P means apply the highlighting now."
  (interactive (append (list (bmkx-completing-read-buffer-name))
                       (bmkx-read-set-lighting-args)
                       (list 'MSGP (not current-prefix-arg))))
  (bmkx-set-lighting-for-bookmarks
   (let ((bmkx-last-specific-buffer  buffer)) (bmkx-last-specific-buffer-alist-only))
   style face when msgp light-now-p))

;;;###autoload (autoload 'bmkx-set-lighting-for-this-buffer "bookmark-x")
(defun bmkx-set-lighting-for-this-buffer (style face when &optional msgp light-now-p) ; Not bound
  "Set the `lighting' entry for each of the bookmarks for this buffer.
You are prompted for the highlight STYLE, FACE, and condition (WHEN).
With a prefix argument, do not highlight now.

Non-interactively:
 STYLE, FACE, and WHEN are as for a bookmark's `lighting' entry
   properties, or nil if no such property.
 Non-nil MSGP means display a highlighting progress message.
 Non-nil LIGHT-NOW-P means apply the highlighting now."
  (interactive (append (bmkx-read-set-lighting-args) (list 'MSGP (not current-prefix-arg))))
  (bmkx-set-lighting-for-bookmarks (bmkx-this-buffer-alist-only) style face when msgp light-now-p))

(defun bmkx-set-lighting-for-bookmarks (alist style face when &optional msgp light-now-p)
  "Set the `lighting' entry for each of the bookmarks in ALIST.
Non-interactively:
 STYLE, FACE, and WHEN are as for a bookmark's `lighting' entry
   properties, or nil if no such property.
 Non-nil MSGP means display a highlighting progress message.
 Non-nil LIGHT-NOW-P means apply the highlighting now."
  (when msgp (message "Setting highlighting..."))
  (dolist (bmk  alist) (bmkx-set-lighting-for-bookmark bmk style face when)) ; No MSGP arg here.
  (when msgp (message "Setting highlighting...done"))
  (when light-now-p (bmkx-light-bookmarks alist nil msgp))) ; Do separately so we get its message.

;;;###autoload (autoload 'bmkx-light-bookmark "bookmark-x")
(defun bmkx-light-bookmark (bookmark &optional style face msgp pointp) ; Not bound
  "Highlight BOOKMARK.
With a prefix arg you are prompted for the style and/or face to use:
 Plain prefix arg (`C-u'): prompt for both style and face.
 Numeric non-negative arg: prompt for face.
 Numeric negative arg: prompt for style.

Non-interactively:
 BOOKMARK is a bookmark name or a bookmark record, or it is ignored.
 STYLE and FACE override the defaults.
 POINT-P non-nil means highlight point rather than the recorded
  bookmark position."
  (interactive
   (let* ((bmk  (bmkx-completing-read "Highlight bookmark" (bmkx-default-bookmark-name)))
          (sty  (and current-prefix-arg  (or (consp current-prefix-arg)
                                             (<= (prefix-numeric-value current-prefix-arg) 0))
                     (cdr (assoc (let ((completion-ignore-case  t))
                                   (completing-read
                                    "Style: " bmkx-light-styles-alist nil t nil nil
                                    (and (bmkx-lighting-style bmk)
                                         (format "%s" (car (rassq (bmkx-lighting-style bmk)
                                                                  bmkx-light-styles-alist))))))
                                 bmkx-light-styles-alist))))
          (fac  (and current-prefix-arg  (or (consp current-prefix-arg)
                                             (natnump (prefix-numeric-value current-prefix-arg)))
                     (not (member sty '(lfringe rfringe none))) ; No face possible for these.
                     (condition-case nil ; Emacs 22+ accepts a default.
                         (read-face-name "Face: " (format "%S" (bmkx-lighting-face  bmk)))
                       (wrong-number-of-arguments (read-face-name "Face: "))))))
     (list bmk sty fac 'MSG)))
  (let* ((bmkx-use-region  nil)         ; Inhibit region handling.
         (bmk              (bmkx-get-bookmark bookmark (not msgp))) ; Error if interactive.
         (bmk-name         (bmkx-bookmark-name-from-record bmk))
         (pos              (and bmk  (bookmark-get-position bmk)))
         (buf              (and bmk  (bmkx-get-buffer-name bmk)))
         (autonamedp       (and bmk  (bmkx-autonamed-bookmark-p bmk)))
         (styl             (or style  (and bmk  (bmkx-light-style bmk))))
         (fac              (or face   (and bmk
                                           (not (member styl '(lfringe rfringe none)))
                                           (bmkx-light-face  bmk))))
         (passes-when-p    (and bmk  (or face
                                         style ; Always highlight if changed face or style.
                                         (bmkx-light-when bmk))))
         (nb-lit           (bmkx-number-lighted))
         bmk-ov)
    (catch 'bmkx-light-bookmark
      (when bmk                         ; Just skip bad bookmark if not interactive.
        (cond ((setq bmk-ov  (bmkx-overlay-of-bookmark bmk)) ; Already highlighted.
               (if (not (or style  face))
                   (when msgp           ; No-op batch.
                     (error "Already highlighted - use prefix arg to change"))
                 (when style (bmkx-make/move-overlay-of-style style pos autonamedp bmk bmk-ov))
                 (when (and face  (not (memq styl '(lfringe rfringe none))))
                   (overlay-put bmk-ov 'face face)))
               (when msgp (message "%sighlighted bookmark `%s'" (if bmk-ov "H" "UNh") bmk-name)))
              (passes-when-p
               (save-excursion

                 ;; See note in comments of `bmkx-light-bookmarks' - same considerations here.
                 ;; (let ((bmkx-jump-display-function  nil)) (bmkx-handle-bookmark bmk))
                 ;;
                 (with-current-buffer (or (and buf  (get-buffer buf))  (current-buffer))

                   ;; POINTP is non-nil when `bmkx-light-bookmark' is called from
                   ;; `bmkx--jump-via'.
                   (when (and pointp  bmkx-auto-light-relocate-when-jump-flag)
                     (setq pos  (point)))
                   (when (and pos  (< pos (point-max)))
                     (let ((ov  (bmkx-make/move-overlay-of-style styl pos autonamedp bmk)))
                       (when ov         ; nil means `none' style.
                         (let ((ovs  (if autonamedp 'bmkx-autonamed-overlays 'bmkx-non-autonamed-overlays)))
                           (push ov (symbol-value ovs)))
                         (when (and (not (bmkx-lighted-p bmk))
                                    (> (setq nb-lit  (1+ nb-lit)) bmkx-light-threshold))
                           (setq nb-lit  (1- nb-lit))
                           (throw 'bmkx-light-bookmark bmk))
                         (overlay-put ov 'priority
                                      (or (cdr (assoc (if autonamedp
                                                          'bmkx-autonamed-overlays
                                                        'bmkx-non-autonamed-overlays)
                                                      bmkx-light-priorities))
                                          (apply #'min (mapcar #'cdr bmkx-light-priorities))))
                         (unless (memq styl '(lfringe rfringe none)) (overlay-put ov 'face fac))
                         (overlay-put ov 'evaporate  t)
                         (overlay-put ov 'category   'bookmark-plus)
                         (overlay-put ov 'bookmark   bmk)) ; Use full bookmark, because name can change.
                       (when msgp
                         (message "%sighlighted bookmark `%s'" (if ov "H" "UNh") bmk-name)))))))
              (t
               (when msgp (message "Bookmark's condition canceled highlighting"))))))))

;;;###autoload (autoload 'bmkx-light-bookmark-this-buffer "bookmark-x")
(defun bmkx-light-bookmark-this-buffer (bookmark &optional style face msgp) ; `C-x x h'
  "Highlight a BOOKMARK in the current buffer.
With a prefix arg you are prompted for the style and/or face to use:
 Plain prefix arg (`C-u'): prompt for both style and face.
 Numeric non-negative arg: prompt for face.
 Numeric negative arg: prompt for style.
See `bmkx-light-bookmark' for arguments when called from Lisp."
  (interactive
   (let* ((bmk  (bmkx-completing-read "Highlight bookmark"
                                          nil
                                          (bmkx-this-buffer-alist-only)
                                          nil
                                          nil
                                          'USE-NIL-ALIST-P))
          (sty  (and current-prefix-arg  (or (consp current-prefix-arg)
                                             (<= (prefix-numeric-value current-prefix-arg) 0))
                     (cdr (assoc (let ((completion-ignore-case  t))
                                   (completing-read
                                    "Style: " bmkx-light-styles-alist nil t nil nil
                                    (and (bmkx-lighting-style bmk)
                                         (format "%s" (car (rassq (bmkx-lighting-style bmk)
                                                                  bmkx-light-styles-alist))))))
                                 bmkx-light-styles-alist))))
          (fac  (and current-prefix-arg  (or (consp current-prefix-arg)
                                             (natnump (prefix-numeric-value current-prefix-arg)))
                     (not (member sty '(lfringe rfringe none))) ; No face possible for these.
                     (condition-case nil ; Emacs 22+ accepts a default.
                         (read-face-name "Face: " (format "%S" (bmkx-lighting-face  bmk)))
                       (wrong-number-of-arguments (read-face-name "Face: "))))))
     (list bmk sty fac 'MSG)))
  (bmkx-light-bookmark bookmark style face msgp))

;;;###autoload (autoload 'bmkx-light-bookmarks "bookmark-x")
(defun bmkx-light-bookmarks (alist &optional overlays-symbols msgp) ; `C-x x H'
  "Highlight bookmarks.
A prefix argument determines which bookmarks to highlight:
 none    - Current buffer, all bookmarks.
 = 0     - Current buffer, highlighted bookmarks only (rehighlight).
 > 0     - Current buffer, autonamed bookmarks only.
 < 0     - Current buffer, non-autonamed bookmarks only.
 C-u     - All buffers (all bookmarks) - after confirmation.
 C-u C-u - Navlist (all bookmarks).

Non-interactively, ALIST is the alist of bookmarks to highlight.
 It must be provided: if nil then do not highlight any bookmarks.
Non-nil optional args used when called from Lisp:
 OVERLAYS-SYMBOLS is a list whose possible elements are
  `bmkx-autonamed-overlays' and `bmkx-non-autonamed-overlays'.
  These name the kinds of highlighting overlays to highlight.
  An empty list is the same as a list with both symbols.
 MSGP means echo an action summary."
  (interactive
   (list (cond ((not current-prefix-arg)     (bmkx-this-buffer-alist-only))
               ((consp current-prefix-arg)   (if (> (prefix-numeric-value current-prefix-arg) 4)
                                                 bmkx-nav-alist
                                               (unless (y-or-n-p
                                                        "Confirm highlighting bookmarks in ALL buffers ")
                                                 (error "Canceled highlighting"))
                                               (bmkx-specific-buffers-alist-only
                                                (mapcar #'buffer-name (buffer-list)))))
               ((> current-prefix-arg 0)     (bmkx-autonamed-this-buffer-alist-only))
               ((< current-prefix-arg 0)     (bmkx-remove-if #'bmkx-autonamed-bookmark-p
                                                             (bmkx-this-buffer-alist-only)))
               ((= current-prefix-arg 0)     (bmkx-this-buffer-lighted-alist-only)))
         (cond ((or (not current-prefix-arg)  (consp current-prefix-arg))
                '(bmkx-autonamed-overlays bmkx-non-autonamed-overlays))
               ((natnump current-prefix-arg) '(bmkx-autonamed-overlays))
               (current-prefix-arg           '(bmkx-non-autonamed-overlays)))
         'MSG))
  (unless overlays-symbols (setq overlays-symbols  '(bmkx-autonamed-overlays bmkx-non-autonamed-overlays)))
  (let ((bmkx-use-region  nil)          ; Inhibit region handling.
        (total            0)
        (nb-auto          0)
        (nb-non-auto      0)
        (new-auto         0)
        (new-non-auto     0)
        (nb-lit           (bmkx-number-lighted))
        bmk bmk-name autonamedp face style pos buf bmk-ov passes-when-p)
    (catch 'bmkx-light-bookmarks
      (dolist (bookmark  alist)
        (setq bmk            (bmkx-get-bookmark bookmark 'NOERROR) ; Should be a no-op.
              bmk-name       (and bmk  (bmkx-bookmark-name-from-record bmk))
              autonamedp     (and bmk  (bmkx-autonamed-bookmark-p bmk-name))
              face           (and bmk  (bmkx-light-face bmk))
              style          (and bmk  (bmkx-light-style bmk))
              bmk-ov         (bmkx-overlay-of-bookmark bmk)
              passes-when-p  (and bmk  (or bmk-ov ; Always highlight if already highlighted.
                                           (bmkx-light-when bmk))))
        (when (and bmk  passes-when-p)  ; Skip bad bookmark and respect `:when' (unless highlighted).
          (setq pos  (bookmark-get-position bmk)
                buf  (bmkx-get-buffer-name bmk))
          (save-excursion
            ;; An alternative here would be to call the handler and let it do the highlighting.
            ;; In that case, we would need at least to bind the display function to nil while
            ;; handling, so we don't also do the jump.  In particular, we don't want to pop to
            ;; the bookmark in a new window or frame.
            ;; Calling the handler would be good for some cases, such as Info, where the
            ;; highlighting is not really specific to the buffer but to a narrowed part of it.
            ;;
            ;; (let ((bmkx-jump-display-function  nil)) (bmkx-handle-bookmark bmk))
            ;;
            ;; But calling the handler is in general the wrong thing.  We don't want highlighting
            ;; all Dired bookmarks in a given directory to also do all the file marking and
            ;; subdir hiding associated with each of the bookmarks.  So we do just the
            ;; highlighting, no handling, putting the code in side `with-current-buffer'.
            (with-current-buffer (or (and buf  (get-buffer buf))
                                     (current-buffer))
              (when (and pos  (< pos (point-max)))
                (dolist (ov-symb  overlays-symbols)
                  (when (or (and (eq 'bmkx-autonamed-overlays     ov-symb)  autonamedp)
                            (and (eq 'bmkx-non-autonamed-overlays ov-symb)  (not autonamedp)))
                    (let ((ov  (bmkx-make/move-overlay-of-style style pos autonamedp bmk bmk-ov)))
                      (when ov          ; nil means `none' style.
                        (add-to-list ov-symb ov)
                        (when (eq 'bmkx-autonamed-overlays ov-symb)
                          (unless bmk-ov (setq new-auto  (1+ new-auto)))
                          (setq nb-auto  (1+ nb-auto)))
                        (when (eq 'bmkx-non-autonamed-overlays ov-symb)
                          (unless bmk-ov (setq new-non-auto  (1+ new-non-auto)))
                          (setq nb-non-auto  (1+ nb-non-auto)))
                        (when (and (not bmk-ov)  (> (setq nb-lit  (1+ nb-lit)) bmkx-light-threshold))
                          (setq nb-lit  (1- nb-lit))
                          (throw 'bmkx-light-bookmarks bmk))
                        (setq total  (1+ total))
                        (overlay-put ov 'priority ; > ediff's 100+, < isearch-overlay's 1001.
                                     (or (cdr (assoc ov-symb bmkx-light-priorities))
                                         (apply #'min (mapcar #'cdr bmkx-light-priorities))))
                        (unless (memq style '(lfringe rfringe none)) (overlay-put ov 'face face))
                        (overlay-put ov 'evaporate  t)
                        (overlay-put ov 'category  'bookmark-plus)
                        (overlay-put ov 'bookmark  bmk))))))))))) ; Use full bookmark - name can change.
    (when msgp (message "%s New: %d auto + %d other,  Total: %d auto + %d other = %d"
                        (if (consp current-prefix-arg)
                            (if (> (prefix-numeric-value current-prefix-arg) 4)
                                "[Navlist]"
                              "[All buffers]")
                          "[This buffer]")
                        new-auto new-non-auto nb-auto nb-non-auto total))))

;;;###autoload (autoload 'bmkx-light-navlist-bookmarks "bookmark-x")
(defun bmkx-light-navlist-bookmarks (&optional overlays-symbols msgp) ; Not bound
  "Highlight bookmarks in the navigation list.
No prefix arg:   all bookmarks.
Prefix arg >= 0: autonamed bookmarks only.
Prefix arg < 0:  non-autonamed bookmarks only.

\(See `bmkx-light-bookmarks' for arguments when called from Lisp.)"
  (interactive
   (list (cond ((not current-prefix-arg) '(bmkx-autonamed-overlays bmkx-non-autonamed-overlays))
               ((natnump (prefix-numeric-value current-prefix-arg)) '(bmkx-autonamed-overlays))
               (current-prefix-arg '(bmkx-non-autonamed-overlays)))
         'MSG))
  (bmkx-light-bookmarks bmkx-nav-alist overlays-symbols msgp))

;;;###autoload (autoload 'bmkx-light-this-buffer "bookmark-x")
(defun bmkx-light-this-buffer (&optional overlays-symbols msgp) ; Not bound
  "Highlight bookmarks in the current buffer.
No prefix arg:   all bookmarks.
Prefix arg >= 0: autonamed bookmarks only.
Prefix arg < 0:  non-autonamed bookmarks only.

\(See `bmkx-light-bookmarks' for arguments when called from Lisp.)"
  (interactive
   (list (cond ((not current-prefix-arg) '(bmkx-autonamed-overlays bmkx-non-autonamed-overlays))
               ((natnump (prefix-numeric-value current-prefix-arg)) '(bmkx-autonamed-overlays))
               (current-prefix-arg '(bmkx-non-autonamed-overlays)))
         'MSG))
  (bmkx-light-bookmarks (bmkx-this-buffer-alist-only) overlays-symbols msgp))

;;;###autoload (autoload 'bmkx-light-bookmarks-in-region "bookmark-x")
(defun bmkx-light-bookmarks-in-region (start end &optional overlays-symbols msgp) ; Not bound
  "Highlight bookmarks in the region.
No prefix arg:   all bookmarks.
Prefix arg >= 0: autonamed bookmarks only.
Prefix arg < 0:  non-autonamed bookmarks only.

\(See `bmkx-light-bookmarks' for arguments when called from Lisp.)"
  (interactive
   (list (region-beginning)
         (region-end)
         (cond ((not current-prefix-arg) '(bmkx-autonamed-overlays bmkx-non-autonamed-overlays))
               ((natnump (prefix-numeric-value current-prefix-arg)) '(bmkx-autonamed-overlays))
               (current-prefix-arg '(bmkx-non-autonamed-overlays)))
         'MSG))
  (bmkx-light-bookmarks (bmkx-remove-if-not (lambda (bmk) (let ((pos  (bookmark-get-position bmk)))
                                                       (and (>= pos start)  (<= pos end))))
                                            (bmkx-this-buffer-alist-only))
                        overlays-symbols msgp))

;;;###autoload (autoload 'bmkx-light-autonamed-this-buffer "bookmark-x")
(defun bmkx-light-autonamed-this-buffer (&optional msgp) ; Not bound
  "Highlight all autonamed bookmarks.
When called from Lisp non-nil MSGP is passed to `bmkx-light-bookmarks'."
  (interactive (list 'MSG))
  (bmkx-light-bookmarks (bmkx-autonamed-this-buffer-alist-only) '(bmkx-autonamed-overlays) msgp))

;;;###autoload (autoload 'bmkx-light-non-autonamed-this-buffer "bookmark-x")
(defun bmkx-light-non-autonamed-this-buffer (&optional msgp) ; Not bound
  "Highlight all non-autonamed bookmarks.
When called from Lisp non-nil MSGP is passed to `bmkx-light-bookmarks'."
  (interactive (list 'MSG))
  (bmkx-light-bookmarks (bmkx-remove-if #'bmkx-autonamed-bookmark-p (bmkx-this-buffer-alist-only))
                        '(bmkx-non-autonamed-overlays) msgp))

;;;###autoload (autoload 'bmkx-cycle-lighted-this-buffer "bookmark-x")
(defun bmkx-cycle-lighted-this-buffer (increment &optional other-window startoverp) ; Not bound
  "Cycle through highlighted bookmarks in this buffer by INCREMENT.
Positive INCREMENT cycles forward.  Negative INCREMENT cycles backward.
Interactively, the prefix arg determines INCREMENT:
 Plain `C-u': 1
 otherwise: the numeric prefix arg value

To change the sort order, you can filter the `*Bmkx List*' to show
only highlighted bookmarks for this buffer, sort the bookmarks there,
and use `\\[bmkx-choose-navlist-from-bookmark-list]', choosing `CURRENT *Bmkx List*' as the
navigation list.

Then you can cycle the bookmarks using `bookmark-cycle'
\(`\\[bmkx-next-bookmark-repeat]' etc.), instead of `bookmark-cycle-lighted-this-buffer'.

In Lisp code:
 Non-nil OTHER-WINDOW means jump to the bookmark in another window.
 Non-nil STARTOVERP means reset `bmkx-current-nav-bookmark' to the
  first bookmark in the navlist."
  (interactive (let ((startovr  (consp current-prefix-arg)))
                 (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) nil startovr)))
  (bmkx-maybe-load-default-file)
  (let ((bmkx-sort-comparer  bmkx-this-file/buffer-cycle-sort-comparer))
    (setq bmkx-nav-alist  (bmkx-sort-omit (bmkx-this-buffer-lighted-alist-only))))
  (unless bmkx-nav-alist (error "No lighted bookmarks for cycling"))
  (unless (and bmkx-current-nav-bookmark
               (not startoverp)
               (bmkx-get-bookmark bmkx-current-nav-bookmark 'NOERROR)
               (bmkx-this-buffer-p bmkx-current-nav-bookmark)) ; Exclude desktops etc.
    (setq bmkx-current-nav-bookmark  (car bmkx-nav-alist)))
  (if (bmkx-cycle-1 increment other-window startoverp)
      (unless (or (bmkx-sequence-bookmark-p bmkx-current-nav-bookmark)
                  (bmkx-function-bookmark-p bmkx-current-nav-bookmark))
        (message "Position: %9d, Bookmark: `%s'" (point) (bmkx-bookmark-name-from-record
                                                          bmkx-current-nav-bookmark)))
    (message "Invalid bookmark: `%s'" (bmkx-bookmark-name-from-record bmkx-current-nav-bookmark))))

;;;###autoload (autoload 'bmkx-cycle-lighted-this-buffer-other-window "bookmark-x")
(defun bmkx-cycle-lighted-this-buffer-other-window (increment &optional startoverp) ; Not bound
  "Same as `bmkx-cycle-lighted-this-buffer' but uses another window."
  (interactive (let ((startovr  (consp current-prefix-arg)))
                 (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) startovr)))
  (bmkx-cycle-lighted-this-buffer increment 'OTHER-WINDOW startoverp))

;;;###autoload (autoload 'bmkx-next-lighted-this-buffer "bookmark-x")
(defun bmkx-next-lighted-this-buffer (n &optional startoverp) ; Repeatable key (e.g. `S-f2'), not bound
  "Jump to the Nth-next highlighted bookmark in the current buffer.
N defaults to 1, meaning the next one.
Plain `C-u' means start over at the first one.
See also `bmkx-cycle-lighted-this-buffer'."
  (interactive (let ((startovr  (consp current-prefix-arg)))
                 (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) startovr)))
  (bmkx-cycle-lighted-this-buffer n nil startoverp))

;;;###autoload (autoload 'bmkx-previous-lighted-this-buffer "bookmark-x")
(defun bmkx-previous-lighted-this-buffer (n &optional startoverp) ; Repeatable key (e.g. `f2'), not bound
  "Jump to the Nth-previous highlighted bookmark in the current buffer.
See `bmkx-next-lighted-this-buffer'."
  (interactive (let ((startovr  (consp current-prefix-arg)))
                 (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) startovr)))
  (bmkx-cycle-lighted-this-buffer (- n) nil startoverp))

;;;###autoload (autoload 'bmkx-next-lighted-this-buffer-repeat "bookmark-x")
(defun bmkx-next-lighted-this-buffer-repeat () ; `C-x x C-down'
  "Jump to the next highlighted bookmark in the current buffer.
This is a repeatable version of `bmkx-next-bookmark-this-buffer'."
  (interactive)
  (require 'repeat)
  (bmkx-repeat-command 'bmkx-next-lighted-this-buffer))

;;;###autoload (autoload 'bmkx-previous-lighted-this-buffer-repeat "bookmark-x")
(defun bmkx-previous-lighted-this-buffer-repeat () ; `C-x x C-up'
  "Jump to the previous highlighted bookmark in the current buffer.
See `bmkx-next-lighted-this-buffer-repeat'."
  (interactive)
  (require 'repeat)
  (bmkx-repeat-command 'bmkx-previous-lighted-this-buffer))

;; Keep the alias for a while, in case someone has it referenced in a state file.
(defalias 'bmkx-describe-bookmark-lighted-here 'bmkx-describe-bookmark-lighted-on-this-line)
(bmkx-make-obsolete 'bmkx-describe-bookmark-lighted-here 'bmkx-describe-bookmark-lighted-on-this-line
                    "2022-11-12")

;;;###autoload (autoload 'bmkx-describe-bookmark-lighted-here "bookmark-x")
;;;###autoload (autoload 'bmkx-describe-bookmark-lighted-on-this-line "bookmark-x")
(defun bmkx-describe-bookmark-lighted-on-this-line (&optional position defn) ; `C-x x ?'
  "Describe a highlighted bookmark on this line, preferably one at point.
Other than preferring a bookmark at point, if more than one
highlighted bookmark is present then which one is described is
undefined.  When multiple highlighted bookmarks are present you might
want to use `\\[bmkx-bookmarks-lighted-at-point]' to see the names of all of the bookmarks at
point, and then use `\\[bmkx-describe-bookmark]' to describe one of them.

When called from Lisp:
 Use POSITION, not point.
 DEFN corresponds to the prefix arg: non-nil means show the internal
  definition of the bookmark."
  (interactive (list (point) current-prefix-arg))
  (let ((bmk  (or (bmkx-a-bookmark-lighted-at-pos position 'FULL)
                  (bmkx-a-bookmark-lighted-on-this-line 'FULL))))
    (unless bmk (error "No highlighted bookmark on this line"))
    (bmkx-describe-bookmark bmk defn)))


;;(@* "Other Functions")
;;  *** Other Functions ***

(defun bmkx-light-face (bookmark)
  "Return the face to use to highlight BOOKMARK.
BOOKMARK is a bookmark name or a bookmark record.
Returns:
 nil if BOOKMARK is not a valid bookmark;
 the `:face', if any, specified by BOOKMARK's `lighting' entry;
 `bmkx-light-autonamed-region' if an autonamed region bookmark;
 `bmkx-light-non-autonamed-region' if a non-autonamed region bookmark;
 `bmkx-light-autonamed' if an autonamed non-region bookmark;
 `bmkx-light-non-autonamed' otherwise."
  (setq bookmark  (bmkx-get-bookmark bookmark 'NOERROR))
  (or (bmkx-lighting-face bookmark)
      (and bookmark  (if (bmkx-region-bookmark-p bookmark)
                         (if (bmkx-autonamed-bookmark-p bookmark)
                             'bmkx-light-autonamed-region
                           'bmkx-light-non-autonamed-region)
                       (if (bmkx-autonamed-bookmark-p bookmark)
                           'bmkx-light-autonamed
                         'bmkx-light-non-autonamed)))))

(defun bmkx-light-style (bookmark)
  "Return the style to use to highlight BOOKMARK.
BOOKMARK is a bookmark name or a bookmark record.
Returns:
 * nil if BOOKMARK is not a valid bookmark;
 * the `:style', if any, specified by BOOKMARK's `lighting' entry;
 * the value of `bmkx-light-style-autonamed-region' if autonamed and
     recording a region
 * the value of `bmkx-light-style-non-autonamed-region' if autonamed
     and recording a region
 * the value of `bmkx-light-style-autonamed' if autonamed and not
     recording a region
 * the value of `bmkx-light-style-non-autonamed-region' if autonamed
     and not recording a region"
  (setq bookmark  (bmkx-get-bookmark bookmark 'NOERROR))
  (or (bmkx-lighting-style bookmark)
      (and bookmark  (if (bmkx-region-bookmark-p bookmark)
                         (if (bmkx-autonamed-bookmark-p bookmark)
                             bmkx-light-style-autonamed-region
                           bmkx-light-style-non-autonamed-region)
                       (if (bmkx-autonamed-bookmark-p bookmark)
                           bmkx-light-style-autonamed
                         bmkx-light-style-non-autonamed)))))

(defun bmkx-light-when (bookmark)
  "Return non-nil if BOOKMARK should be highlighted.
BOOKMARK's  `:when' condition is used to determine this.
BOOKMARK is a bookmark name or a bookmark record."
  (setq bookmark  (bmkx-get-bookmark bookmark 'NOERROR))
  (and bookmark  (not (eq :no-light (eval (bmkx-lighting-when bookmark))))))

(defun bmkx-lighting-face (bookmark)
  "`:face' specified by BOOKMARK's `lighting', or nil if no `:face' entry.
BOOKMARK is a bookmark name or a bookmark record.

The `:face' entry is the face (a symbol) used to highlight BOOKMARK.
Alternatively, it can be `auto' or nil, which both mean the same as
having no `:face' entry: do not override automatic face choice."
  (bmkx-lighting-attribute bookmark :face))

(defun bmkx-lighting-style (bookmark)
  "`:style' specified by BOOKMARK's `lighting', or nil if no `:style' entry.
BOOKMARK is a bookmark name or a bookmark record.

The `:style' entry is the style used to highlight BOOKMARK.
It is a value acceptable for `bmkx-light-style-non-autonamed'.
Alternatively, it can be `auto' or nil, which both mean the same as
having no `:style' entry: do not override automatic style choice."
  (bmkx-lighting-attribute bookmark :style))

(defun bmkx-lighting-when (bookmark)
  "`:when' specified by BOOKMARK's `lighting', or nil if no `:when' entry.
BOOKMARK is a bookmark name or a bookmark record.

The `:when' entry is a sexp that is eval'd when you try to highlight
BOOKMARK.  If the result is the symbol `:no-light', then do not
highlight.  Otherwise, highlight.  (Note that highlighting happens if
the value is nil or there is no `:when' entry.)"
  (bmkx-lighting-attribute bookmark :when))

(defun bmkx-lighting-attribute (bookmark attribute)
  "ATTRIBUTE specified by BOOKMARK's `lighting', or nil if no such attribute.
BOOKMARK is a bookmark name or a bookmark record.
ATTRIBUTE is `:style' or `:face'."
  (setq bookmark  (bmkx-get-bookmark bookmark 'NOERROR))
  (let* ((lighting  (and bookmark  (bmkx-get-lighting bookmark)))
         (attr      (and (consp lighting)  (plist-get lighting attribute))))
    (when (and (eq 'auto attr)  (not (eq :when attribute)))
      (setq attr  nil))
    attr))

(defun bmkx-get-lighting (bookmark)
  "Return the `lighting' property list for BOOKMARK.
This is the cdr of the `lighting' entry (i.e. the rest of the entry,
  with `lighting' removed).
BOOKMARK is a bookmark name or a bookmark record."
  (bookmark-prop-get bookmark 'lighting))

(defun bmkx-bookmark-overlay-p (overlay)
  "Return non-nil if OVERLAY is a bookmark overlay.
The non-nil value returned is in fact the full bookmark."
  (and (overlayp overlay)  (overlay-get overlay 'bookmark)))

(defun bmkx-default-lighted ()
  "Return a highlighted bookmark at point or on this line, or nil if none.
If there is at least one highlighted bookmark at point, return a list
of all such."
  (or (bmkx-bookmarks-lighted-at-point)
      (bmkx-a-bookmark-lighted-on-this-line)))

(defun bmkx-a-bookmark-lighted-on-this-line (&optional fullp)
  "Return a bookmark highlighted on the current line or nil if none.
The search for a highlighted bookmark moves left to bol from point,
 then right to eol from point.
Return the bookmark name or, if FULLP non-nil, the full bookmark data."
  (let ((pos  (point))
        (bol  (1+ (line-beginning-position)))
        (eol  (1- (line-end-position)))
        bmk)
    (catch 'bmkx-a-bookmark-lighted-on-this-line
      (while (>= pos bol)
        (when (setq bmk  (bmkx-a-bookmark-lighted-at-pos pos))
          (throw 'bmkx-a-bookmark-lighted-on-this-line bmk))
        (setq pos  (1- pos)))
      (while (<= pos eol)
        (when (setq bmk  (bmkx-a-bookmark-lighted-at-pos pos))
          (throw 'bmkx-a-bookmark-lighted-on-this-line bmk))
        (setq pos  (1+ pos)))
      nil)
    (when (and bmk  fullp)  (setq bmk  (bmkx-get-bookmark bmk)))
    bmk))

(defun bmkx-a-bookmark-lighted-at-pos (&optional position fullp)
  "Return a bookmark (in current bookmark list) highlighted at POSITION.
Return nil if there is none such.
POSITION defaults to point.
Return the bookmark name or, if FULLP non-nil, the full bookmark data."
  (unless position (setq position  (point)))
  (let (bmk)
    (catch 'bmkx-a-bookmark-lighted-at-pos
      (dolist (ov  (overlays-at position))
        (when (setq bmk  (overlay-get ov 'bookmark))
          (throw 'bmkx-a-bookmark-lighted-at-pos bmk)))
      nil)
    (let ((b-in-list  (bmkx-get-bookmark-in-alist bmk 'NOERROR)))
      (and b-in-list                    ; Must be in current bookmark list.
           (if fullp b-in-list (bmkx-bookmark-name-from-record bmk))))))

(defun bmkx-read-set-lighting-args (&optional default-style default-face default-when)
  "Read args STYLE, FACE, and WHEN for commands that set `lighting' prop.
Optional args are the default values (strings) for reading new values."
  (let* ((style       (cdr (assoc (let ((completion-ignore-case  t))
                                    (completing-read "Style: " bmkx-light-styles-alist
                                                     nil t nil nil default-style))
                                  bmkx-light-styles-alist)))
         (face        (and (not (member style '(lfringe rfringe none))) ; No face possible for these.
                           (y-or-n-p "Change face? ") ; Allow nil, for `auto'.
                           (condition-case nil ; Emacs 22+ accepts a default.
                               (read-face-name "Face: " default-face)
                             (wrong-number-of-arguments (read-face-name "Face: ")))))
         (when-cands  `(("auto" . nil)
                        ("conditionally (read sexp)")
                        ("never"  . :no-light)))
         (when         (completing-read "When: " when-cands nil t nil nil
                                        (if default-when "conditionally (read sexp)" "auto")))
         (evald       (if (string-match-p "^con" when)
                          (read-from-minibuffer "Highlight when (sexp): " nil
                                                (if (boundp 'pp-read-expression-map)
                                                    pp-read-expression-map
                                                  read-expression-map)
                                                t 'read-expression-history default-when)
                        (cdr (assoc when when-cands)))))
    (list style face evald)))

(defun bmkx-lighted-alist-only ()
  "`bookmark-alist', with only highlighted bookmarks.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not (lambda (bmk) (bmkx-lighted-p bmk)) bookmark-alist))

(defun bmkx-this-buffer-lighted-alist-only ()
  "`bookmark-alist', with only highlighted bookmarks for the current buffer.
A new list is returned (no side effects)."
  (bmkx-maybe-load-default-file)
  (bmkx-remove-if-not (lambda (bmk) (and (bmkx-this-buffer-p bmk)  (bmkx-lighted-p bmk)))
                      bookmark-alist))

(defun bmkx-number-lighted (&optional overlays-symbols)
  "Number of bookmarks highlighted.
\(See `bmkx-light-bookmarks' for argument when called from Lisp.)"
  (unless overlays-symbols (setq overlays-symbols  '(bmkx-autonamed-overlays bmkx-non-autonamed-overlays)))
  (let ((count  0))
    (dolist (ov-symb  overlays-symbols)
      (dolist (ov  (symbol-value ov-symb)) (when (overlay-buffer ov) (setq count  (1+ count)))))
    count))

(defalias 'bmkx-lighted-p 'bmkx-overlay-of-bookmark)
(defun bmkx-overlay-of-bookmark (bookmark &optional overlays)
  "Return the overlay for BOOKMARK in OVERLAYS, or nil if none.
BOOKMARK is a bookmark name or a bookmark record.
Optional arg OVERLAYS is the list of overlays to check.
If nil, check overlays for both autonamed and non-autonamed bookmarks."
  (setq bookmark  (bmkx-get-bookmark bookmark 'NOERROR))
  (and bookmark                         ; Return nil for no such bookmark.
       (catch 'bmkx-overlay-of-bookmark
         (dolist (ov  (if overlays
                          (apply #'append (mapcar #'symbol-value overlays))
                        (append bmkx-autonamed-overlays bmkx-non-autonamed-overlays)))
           (when (and (overlay-buffer ov)  (eq bookmark (overlay-get ov 'bookmark)))
             (throw 'bmkx-overlay-of-bookmark ov)))
         nil)))

(defun bmkx-make/move-overlay-of-style (style pos autonamedp bookmark &optional overlay)
  "Return a bookmark overlay of STYLE at position POS for BOOKMARK.
AUTONAMEDP non-nil means the bookmark is autonamed.
Regardless of STYLE, set `help-echo' to the bookmark description.
If OVERLAY is non-nil:
  Then it is the overlay to use - change to STYLE and return overlay.
  Otherwise, create a new overlay and return it.
If STYLE is `none' then:
  If OVERLAY is non-nil, delete it and return nil."
  (let ((ov  overlay))
    (cl-case style
      (region        (and (bmkx-region-bookmark-p bookmark)
                          (let ((end  (bmkx-get-end-position bookmark)))
                            (if (not ov)
                                (setq ov  (make-overlay pos end nil 'FRONT-ADVANCE))
                              (move-overlay ov pos end)))))
      (line          (if (not ov)
                         (setq ov  (save-excursion
                                     (make-overlay
                                      (progn (goto-char pos) (line-beginning-position 1))
                                      (progn (goto-char pos) (line-beginning-position 2))
                                      nil
                                      'FRONT-ADVANCE)))
                       (overlay-put ov 'before-string nil) ; Remove any fringe highlighting.
                       (save-excursion
                         (move-overlay ov
                                       (progn (goto-char pos) (line-beginning-position 1))
                                       (progn (goto-char pos) (line-beginning-position 2))))))
      (lfringe       (setq ov  (bmkx-make/move-fringe 'left  pos autonamedp ov)))
      (rfringe       (setq ov  (bmkx-make/move-fringe 'right pos autonamedp ov)))
      (line+lfringe  (setq ov  (bmkx-make/move-fringe 'left  pos autonamedp ov 'LINEP)))
      (line+rfringe  (setq ov  (bmkx-make/move-fringe 'right pos autonamedp ov 'LINEP)))
      (bol           (if (not ov)
                         (setq ov  (save-excursion (goto-char pos)
                                                   (make-overlay (line-beginning-position)
                                                                 (1+ (line-beginning-position))
                                                                 nil
                                                                 'FRONT-ADVANCE)))
                       (overlay-put ov 'before-string nil) ; Remove any fringe highlighting.
                       (save-excursion (goto-char pos)
                                       (move-overlay ov (line-beginning-position)
                                                     (1+ (line-beginning-position))))))
      (point         (if (not ov)
                         (setq ov  (make-overlay pos (1+ pos) nil 'FRONT-ADVANCE))
                       (overlay-put ov 'before-string nil) ; Remove any fringe highlighting.
                       (move-overlay ov pos (1+ pos))))
      (none          (when ov (delete-overlay ov))  (setq ov nil)))

    ;; Emacs bug # prevents making use of a face in a `help-echo' tooltip.
    ;; (when ov (overlay-put ov 'help-echo (bmkx-propertize (funcall bmkx-tooltip-content-function bookmark)
    ;;                                                      'face 'bmkx-tooltip-content-face)))
    ;;
    ;; The `help-echo' property accepts a function -- Emacs only calls it on
    ;; demand (when the user actually hovers).  Pass a lambda so we do not pay
    ;; the cost of `bmkx-tooltip-content-function' on every overlay creation.
    ;; This matters: the default function `bmkx-bookmark-description' runs
    ;; `image-dired-get-thumbnail-image' and `exiftool' for files matching
    ;; `image-file-name-regexp'.  Eager evaluation made every auto-light pay
    ;; that cost (and errored on PDFs when "pdf" was in `image-file-name-extensions',
    ;; because ImageMagick refuses PDF conversion under default CVE-2018-16509
    ;; policy).
    (when ov
      (overlay-put ov 'help-echo
                   (lambda (_window _object _pos)
                     (funcall bmkx-tooltip-content-function bookmark))))
    ov))

;; Not used for Emacs 20-21.
(defun bmkx-make/move-fringe (side pos autonamedp &optional overlay linep)
  "Return an overlay that uses the fringe.
If SIDE is `right' then use the right fringe, otherwise left.
POS is the overlay position.
AUTONAMEDP: non-nil means use face `bmkx-light-fringe-autonamed'.
            nil means use face `bmkx-light-fringe-non-autonamed'.
If OVERLAY is non-nil it is the overlay to use.
 Otherwise, create a new overlay.
Non-nil LINEP means also highlight the line containing POS."
  (let ((ov  overlay))
    (if ov
        (save-excursion (move-overlay overlay (progn (goto-char pos)
                                                     (goto-char (line-beginning-position)))
                                      (1+ (point))))
      (setq ov  (save-excursion (make-overlay (progn (goto-char pos)
                                                     (goto-char (line-beginning-position)))
                                              (1+ (point))
                                              nil
                                              'FRONT-ADVANCE))))
    (overlay-put ov 'before-string (bmkx-fringe-string side autonamedp))
    (if linep
        (move-overlay ov (save-excursion (goto-char pos) (line-beginning-position 1))
                      (save-excursion (goto-char pos) (line-beginning-position 2)))
      (overlay-put ov 'face nil))       ; Remove any non-fringe highlighting.
    ov))

(defun bmkx-fringe-string (side autonamedp)
  "Return a fringe string for a bookmark overlay.
If SIDE is `right' then use the right fringe, otherwise left.
AUTONAMEDP: non-nil means use face `bmkx-light-fringe-autonamed'.
            nil means use face `bmkx-light-fringe-non-autonamed'."
  (let ((fringe-string  (copy-sequence (if autonamedp "*AUTO*" "*NONAUTO*"))))
    (put-text-property 0         (length fringe-string)
                       'display  (if (eq side 'right)
                                     (list 'right-fringe
                                           bmkx-light-right-fringe-bitmap
                                           (if autonamedp
                                               'bmkx-light-fringe-autonamed
                                             'bmkx-light-fringe-non-autonamed))
                                   (list 'left-fringe
                                         bmkx-light-left-fringe-bitmap
                                         (if autonamedp
                                             'bmkx-light-fringe-autonamed
                                           'bmkx-light-fringe-non-autonamed)))
                       fringe-string)
    fringe-string))

;; This is also in `bookmark-x-bmu.el', since `bookmark-x-lit.el' is loaded first but is optional.
;;
(defalias 'bmkx--pop-to-buffer-same-window 'pop-to-buffer-same-window)


;;;;;;;;;;;;;;;;;;;

(provide 'bookmark-x-lit)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; bookmark-x-lit.el ends here
