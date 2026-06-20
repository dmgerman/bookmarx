;;; bookmark-x-mac.el --- Macros for Bookmark-X.   -*- lexical-binding:t -*-
;;
;; Filename:    bookmark-x-mac.el
;; Description: Macros for Bookmark-X.
;;              Fork of Drew Adams' Bookmark+, modernized for Emacs 30+.
;;
;; Author:     Drew Adams
;; Maintainer: Daniel M. German <dmg@turingmachine.org>
;;
;; Copyright (C) 2000-2024, Drew Adams, all rights reserved.
;; Copyright (C) 2026, Daniel M. German, all rights reserved.
;;
;; Created: Sun Aug 15 11:12:30 2010 (-0700)
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
;;   None
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;;    Macros for Bookmark-X.
;;
;;    The Bookmark-X libraries are these:
;;
;;    `bookmark-x.el'     - main (driver) library
;;    `bookmark-x-mac.el' - Lisp macros (this file)
;;    `bookmark-x-bmu.el' - code for the `*Bmkx List*' (bmenu)
;;    `bookmark-x-1.el'   - other (non-bmenu) required code
;;    `bookmark-x-lit.el' - (optional) code for highlighting bookmarks
;;    `bookmark-x-key.el' - key and menu bindings
;;
;;    User documentation is the `bookmark-x' Info manual.  See
;;    `M-x info RET m bookmark-x RET' or the source in
;;    `doc/bookmark-x.texi'.
;;
;;
;;    ****** NOTE ******
;;
;;      WHENEVER you update Bookmark-X (i.e., download new versions of
;;      Bookmark-X source files), I recommend that you do the
;;      following:
;;
;;      1. Delete ALL existing BYTE-COMPILED Bookmark-X files
;;         (bookmark-x*.elc).
;;      2. Load Bookmark-X (`load-library' or `require').
;;      3. Byte-compile the source files.
;;
;;      In particular, ALWAYS LOAD `bookmark-x-mac.el' (not
;;      `bookmark-x-mac.elc') BEFORE YOU BYTE-COMPILE new versions of
;;      the files, in case there have been any changes to Lisp macros
;;      (in `bookmark-x-mac.el').
;;
;;      (This is standard procedure for Lisp: code that depends on
;;      macros needs to be byte-compiled anew after loading the
;;      updated macros.)
;;
;;    ******************
 
;;(@> "Index")
;;
;;  Tip: run `M-x outline-minor-mode' with `outline-regexp' set to
;;  `";;[ \\t]*(@[*>@]"' to fold and navigate the sections of this file.
;;
;;  (@> "Things Defined Here")
;;  (@> "Functions")
;;  (@> "Macros")
 
;;(@* "Things Defined Here")
;;
;;  Things Defined Here
;;  -------------------
;;
;;  Macros defined here:
;;
;;    `bmkx-define-cycle-command', `bmkx-define-file-sort-predicate',
;;    `bmkx-define-history-variables',
;;    `bmkx-define-next+prev-cycle-commands',
;;    `bmkx-define-show-only-command', `bmkx-define-sort-command',
;;    `bmkx-define-type-from-hander', `bmkx-lexlet', `bmkx-lexlet*',
;;    `bmkx-make-plain-predicate', `bmkx-menu-bar-make-toggle',
;;    `bmkx-with-bookmark-dir', `bmkx-with-help-window',
;;    `bmkx-with-output-to-plain-temp-buffer'.
;;
;;  Non-interactive functions defined here:
;;
;;    `bmkx-bookmark-data-from-record',
;;    `bmkx-bookmark-name-from-record',
;;    `bmkx-replace-regexp-in-string', `bmkx-types-alist',
;;    `bookmark-name-from-full-record', `bookmark-name-from-record'.
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

(require 'bookmark)
;; bmkx-list-bookmark, bmkx-list-ensure-position,
;; bmkx-list-surreptitiously-rebuild-list, bmkx-get-bookmark,
;; bookmark-get-filename

 
;;(@* "Functions")

;; Some general Renamings.
;;
;; 1. Fix incompatibility introduced by gratuitous Emacs name change.
;;
(cond ((and (fboundp 'bookmark-name-from-record) (not (fboundp 'bookmark-name-from-full-record)))
       (defalias 'bookmark-name-from-full-record 'bookmark-name-from-record))
      ((and (fboundp 'bookmark-name-from-full-record) (not (fboundp 'bookmark-name-from-record)))
       (defalias 'bookmark-name-from-record 'bookmark-name-from-full-record)))

;; 2. The vanilla name of the first is misleading, as it returns only the cdr of the record.
;;    The second is for consistency.
;;
(defalias 'bmkx-bookmark-data-from-record 'bookmark-get-bookmark-record)
(defalias 'bmkx-bookmark-name-from-record 'bookmark-name-from-full-record)


;; (eval-when-compile (require 'bookmark-x-bmu))
;; bmkx-assoc-delete-all, bmkx-bmenu-barf-if-not-in-menu-list,
;; bmkx-bmenu-goto-bookmark-named, bmkx-sort-orders-alist

;; (eval-when-compile (require 'bookmark-x-1))
;; bmkx-file-bookmark-p, bmkx-float-time, bmkx-local-file-bookmark-p,
;; bmkx-msg-about-sort-order, bmkx-reverse-sort-p, bmkx-sort-comparer


;;; This is also defined in `bookmark-x-bmu.el'.  It is used here to produce the code for
;;; `bmkx-define-show-only-command' and `bmkx-define-sort-command'.
;;;
(defalias 'bmkx-replace-regexp-in-string #'replace-regexp-in-string)
 
;;(@* "Macros")

;;; Macros -----------------------------------------------------------

;;;###autoload (autoload 'bmkx-with-help-window "bookmark-x")
(defmacro bmkx-with-help-window (buffer &rest body)
  "Like `with-help-window', for the side-effect of `*Help*' navigation."
  `(with-help-window ,buffer ,@body))

(put 'bmkx-with-help-window 'common-lisp-indent-function '(4 &body))


;;;###autoload (autoload 'bmkx-with-output-to-plain-temp-buffer "bookmark-x")
(defmacro bmkx-with-output-to-plain-temp-buffer (buf &rest body)
  "Like `with-output-to-temp-buffer', but with no `*Help*' navigation stuff."
  `(unwind-protect
    (progn
      (remove-hook 'temp-buffer-setup-hook 'help-mode-setup)
      (remove-hook 'temp-buffer-show-hook  'help-mode-finish)
      (with-output-to-temp-buffer ,buf ,@body))
    (add-hook 'temp-buffer-setup-hook 'help-mode-setup)
    (add-hook 'temp-buffer-show-hook  'help-mode-finish)))

(put 'bmkx-with-output-to-plain-temp-buffer 'common-lisp-indent-function '(4 &body))


;;;###autoload (autoload 'bmkx-make-plain-predicate "bookmark-x")
(defmacro bmkx-make-plain-predicate (pred &optional final-pred)
  "Return a plain predicate that corresponds to component-predicate PRED.
PRED and FINAL-PRED correspond to their namesakes in
`bmkx-sort-comparer' (which see).

PRED should return `(t)', `(nil)', or nil.

Optional arg FINAL-PRED is the final predicate to use if PRED cannot
decide (returns nil).  If FINAL-PRED is nil, then `bmkx-alpha-p', the
plain-predicate equivalent of `bmkx-alpha-cp' is used as the final
predicate."
  `(lambda (b1 b2) (let ((res  (funcall ',pred b1 b2)))
                     (if res (car res) (funcall ',(or final-pred  'bmkx-alpha-p) b1 b2)))))

;;;###autoload (autoload 'bmkx-define-cycle-command "bookmark-x")
(defmacro bmkx-define-cycle-command (type &optional otherp)
  "Define a cycling command for bookmarks of type TYPE.
Non-nil OTHERP means define a command that cycles in another window."
  `(defun ,(intern (format "bmkx-cycle-%s%s" type (if otherp "-other-window" "")))
    (increment &optional startoverp)
    ,(if otherp
         (format "Same as `bmkx-cycle-%s', but use other window." type)
         (format "Cycle through %s bookmarks by INCREMENT (default: 1).
Positive INCREMENT cycles forward.  Negative INCREMENT cycles backward.
Interactively, the prefix arg determines INCREMENT:
 Plain `C-u': 1
 otherwise: the numeric prefix arg value

Plain `C-u' also means start over at first bookmark.

In Lisp code:
 Non-nil STARTOVERP means reset `bmkx-current-nav-bookmark' to the
 first bookmark in the navlist." type))
    (interactive (let ((startovr  (consp current-prefix-arg)))
                   (list (if startovr 1 (prefix-numeric-value current-prefix-arg))
                         startovr)))
    (let ((bmkx-nav-alist  (bmkx-sort-omit (,(intern (format "bmkx-%s-alist-only" type))))))
      (bmkx-cycle increment ,otherp startoverp))))

;;;###autoload (autoload 'bmkx-define-next+prev-cycle-commands "bookmark-x")
(defmacro bmkx-define-next+prev-cycle-commands (type &optional otherp)
  "Define `next' and `previous' commands for bookmarks of type TYPE.
Non-nil OTHERP means define a command that cycles in another window."
  `(progn
    ;; `next' command.
    (defun ,(intern (format "bmkx-next-%s-bookmark%s" type (if otherp "-other-window" "")))
        (n &optional startoverp)
      ,(if otherp
           (format "Same as `bmkx-next-%s-bookmark', but use other window." type)
           (format "Jump to the Nth-next %s bookmark.
N defaults to 1, meaning the next one.
Plain `C-u' means start over at the first one.
See also `bmkx-cycle-%s'." type type))
      (interactive (let ((startovr  (consp current-prefix-arg)))
                     (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) startovr)))
      (,(intern (format "bmkx-cycle-%s%s" type (if otherp "-other-window" ""))) n startoverp))

    ;; `previous' command.
    (defun ,(intern (format "bmkx-previous-%s-bookmark%s" type (if otherp "-other-window" "")))
        (n &optional startoverp)
      ,(if otherp
           (format "Same as `bmkx-previous-%s-bookmark', but use other window." type)
           (format "Jump to the Nth-previous %s bookmark.
See `bmkx-next-%s-bookmark'." type type))
      (interactive (let ((startovr  (consp current-prefix-arg)))
                     (list (if startovr 1 (prefix-numeric-value current-prefix-arg)) startovr)))
      (,(intern (format "bmkx-cycle-%s%s" type (if otherp "-other-window" "")))
        (- n) startoverp))

    ;; `next' repeating command.
    (defun ,(intern (format "bmkx-next-%s-bookmark%s-repeat"
                            type
                            (if otherp "-other-window" "")))
        ()
      ,(if otherp
           (format "Same as `bmkx-next-%s-bookmark-repeat', but use other window." type)
           (format "Jump to the next %s bookmark.
This is a repeatable version of `bmkx-next-%s-bookmark'." type type))
      (interactive)
      (require 'repeat)
      (bmkx-repeat-command
       ',(intern (format "bmkx-next-%s-bookmark%s" type (if otherp "-other-window" "")))))

    ;; `previous repeating command.
    (defun ,(intern (format "bmkx-previous-%s-bookmark%s-repeat"
                            type
                            (if otherp "-other-window" "")))
        ()
      ,(if otherp
           (format "Same as `bmkx-previous-%s-bookmark-repeat', but use other window." type)
           (format "Jump to the previous %s bookmark.
See `bmkx-next-%s-bookmark-repeat'." type type))
      (interactive)
      (require 'repeat)
      (bmkx-repeat-command
       ',(intern (format "bmkx-previous-%s-bookmark%s" type (if otherp "-other-window" "")))))))

;; We don't bother making this hygienic.  Presumably only the Bookmark-X code will call it.
;;;###autoload (autoload 'bmkx-define-show-only-command "bookmark-x")
(defmacro bmkx-define-show-only-command (type doc-string filter-function)
  "Define a command to show only bookmarks of TYPE in *Bmkx List*.
TYPE is a short string or symbol describing the type of bookmarks.

The new command is named `bmkx-bmenu-show-only-TYPED-bookmarks', where
TYPED is TYPE, but with any spaces replaced by hyphens (`-').
Example: `bmkx-bmenu-show-only-tagged-bookmarks', for TYPE `tagged'.

DOC-STRING is the doc string of the new command.

The command shows only the bookmarks allowed by FILTER-FUNCTION.

In case of error, variables `bmkx-bmenu-filter-function',
`bmkx-bmenu-title', and `bmkx-latest-bookmark-alist' are reset to
their values before the command was invoked."
  (unless (stringp type) (setq type  (symbol-name type)))
  (let* ((type--   (bmkx-replace-regexp-in-string "\\s-+" "-" type))
         (command  (intern (format "bmkx-bmenu-show-only-%s-bookmarks" type--))))
    `(progn
      (defun ,command ()
        ,doc-string
        (interactive)
        (bmkx-bmenu-barf-if-not-in-menu-list)
        (let ((orig-filter-fn      bmkx-bmenu-filter-function)
              (orig-title          bmkx-bmenu-title)
              (orig-latest-alist   bmkx-latest-bookmark-alist))
          (condition-case err
              (progn (setq bmkx-bmenu-filter-function  ',filter-function
                           bmkx-bmenu-title            ,(format "%s Bookmarks" (capitalize type)))
                     (let ((bookmark-alist  (funcall bmkx-bmenu-filter-function)))
                       (setq bmkx-latest-bookmark-alist  bookmark-alist)
                       (bmkx-list 'filteredp))
                     (when (called-interactively-p 'interactive)
                       (bmkx-msg-about-sort-order (bmkx-current-sort-order)
                                                  ,(format "Only %s bookmarks are shown" type))))
            (error (progn (setq bmkx-bmenu-filter-function  orig-filter-fn
                                bmkx-bmenu-title            orig-title
                                bmkx-latest-bookmark-alist  orig-latest-alist)
                          (error "%s" (error-message-string err))))))))))

;;;###autoload (autoload 'bmkx-define-sort-command "bookmark-x")
(defmacro bmkx-define-sort-command (sort-order comparer doc-string)
  "Define a command to sort bookmarks in the bookmark list by SORT-ORDER.
SORT-ORDER is a short string or symbol describing the sorting method.
Examples: \"by last access time\", \"by bookmark name\".

The new command is named by replacing any spaces in SORT-ORDER with
hyphens (`-') and then adding the prefix `bmkx-bmenu-sort-'.  Example:
`bmkx-bmenu-sort-by-bookmark-name', for SORT-ORDER `by bookmark name'.

COMPARER compares two bookmarks, returning non-nil if and only if the
first bookmark sorts before the second.  It must be acceptable as a
value of `bmkx-sort-comparer'.  That is, it is either nil, a
predicate, or a list ((PRED...) FINAL-PRED).  See the doc for
`bmkx-sort-comparer'.

DOC-STRING is the doc string of the new command."
  (unless (stringp sort-order) (setq sort-order  (symbol-name sort-order)))
  (let ((command  (intern (concat "bmkx-bmenu-sort-" (bmkx-replace-regexp-in-string
                                                      "\\s-+" "-" sort-order)))))
    `(progn
      (setq bmkx-sort-orders-alist  (bmkx-assoc-delete-all ,sort-order (copy-sequence
                                                                        bmkx-sort-orders-alist)))
      (setq bmkx-sort-orders-alist  (cons (cons ,sort-order ',comparer) bmkx-sort-orders-alist))
      (defun ,command ()
        ,(concat doc-string "\nRepeating this command cycles among normal sort, reversed \
sort, and unsorted.")
        (interactive)
        (bmkx-bmenu-barf-if-not-in-menu-list)
        (cond (;; Not this sort order - make it this sort order.
               (not (equal bmkx-sort-comparer ',comparer))
               (setq bmkx-sort-comparer   ',comparer
                     bmkx-reverse-sort-p  nil))
              (;; Not this sort order reversed - make it reversed.
               (not bmkx-reverse-sort-p)
               (setq bmkx-reverse-sort-p  t))
              (t;; This sort order reversed.  Change to unsorted.
               (setq bmkx-sort-comparer   nil)))
        (message "Sorting...")
        (bmkx-list-ensure-position)
        (let ((current-bmk  (bmkx-list-bookmark)))
          (bmkx-list-surreptitiously-rebuild-list)
          (when current-bmk             ; Should be non-nil, but play safe.
            (bmkx-bmenu-goto-bookmark-named current-bmk))) ; Put cursor back on right line.
        (when (called-interactively-p 'interactive)
          (bmkx-msg-about-sort-order
           ,sort-order
           nil
           (cond ((and (not bmkx-reverse-sort-p)
                       (equal bmkx-sort-comparer ',comparer)) "(Repeat: reverse)")
                 ((equal bmkx-sort-comparer ',comparer)       "(Repeat: unsorted)")
                 (t                                           "(Repeat: sort)"))))))))

;;;###autoload (autoload 'bmkx-define-file-sort-predicate "bookmark-x")
(defmacro bmkx-define-file-sort-predicate (att-nb)
  "Define a predicate for sorting bookmarks by file attribute ATT-NB.
See function `file-attributes' for the meanings of the various file
attribute numbers.

String attribute values sort alphabetically; numerical values sort
numerically; nil sorts before t.

For ATT-NB 0 (file type), a file sorts before a symlink, which sorts
before a directory.

For ATT-NB 2 or 3 (uid, gid), a numerical value sorts before a string
value.

A bookmark that has file attributes sorts before a bookmark that does
not.  A file bookmark sorts before a non-file bookmark.  Only local
files are tested for attributes - remote-file bookmarks are treated
here like non-file bookmarks."
  `(defun ,(intern (format "bmkx-file-attribute-%d-cp" att-nb)) (b1 b2)
    ,(format "Sort file bookmarks by attribute %d.
Sort bookmarks with file attributes before those without attributes
Sort file bookmarks before non-file bookmarks.
Treat remote file bookmarks like non-file bookmarks.

B1 and B2 are full bookmarks (records) or bookmark names.
If either is a record then it need not belong to `bookmark-alist'."
             att-nb)
    (setq b1  (bmkx-get-bookmark b1))
    (setq b2  (bmkx-get-bookmark b2))
    (let (a1 a2)
      (cond (;; Both are file bookmarks.
             (and (bmkx-file-bookmark-p b1) (bmkx-file-bookmark-p b2))
             (setq a1  (file-attributes (bookmark-get-filename b1))
                   a2  (file-attributes (bookmark-get-filename b2)))
             (cond (;; Both have attributes.
                    (and a1 a2)
                    (setq a1  (nth ,att-nb a1)
                          a2  (nth ,att-nb a2))
                    ;; Convert times and maybe inode number to floats.
                    ;; The inode conversion is kludgy, but is probably OK in practice.
                    (when (consp a1) (setq a1  (bmkx-float-time a1)))
                    (when (consp a2) (setq a2  (bmkx-float-time a2)))
                    (cond (;; (1) links, (2) maybe uid, (3) maybe gid, (4, 5, 6) times
                           ;; (7) size, (10) inode, (11) device.
                           (numberp a1)
                           (cond ((< a1 a2)  '(t))
                                 ((> a1 a2)  '(nil))
                                 (t          nil)))
                          ((= 0 ,att-nb) ; (0) file (nil) < symlink (string) < dir (t)
                           (cond ((and a2 (not a1))               '(t)) ; file vs (symlink or dir)
                                 ((and a1 (not a2))               '(nil))
                                 ((and (eq t a2) (not (eq t a1))) '(t)) ; symlink vs dir
                                 ((and (eq t a1) (not (eq t a2))) '(t))
                                 ((and (stringp a1) (stringp a2))
                                  (if (string< a1 a2) '(t) '(nil)))
                                 (t                               nil)))
                          ((stringp a1) ; (2, 3) string uid/gid, (8) modes
                           (cond ((string< a1 a2)  '(t))
                                 ((string< a2 a1)  '(nil))
                                 (t                nil)))
                          ((eq ,att-nb 9) ; (9) gid would change if re-created. nil < t
                           (cond ((and a2 (not a1))  '(t))
                                 ((and a1 (not a2))  '(nil))
                                 (t                  nil)))))
                   (;; First has attributes, but not second.
                    a1
                    '(t))
                   (;; Second has attributes, but not first.
                    a2
                    '(nil))
                   (;; Neither has attributes.
                    t
                    nil)))
            (;; First is a file, second is not.
             (bmkx-local-file-bookmark-p b1)
             '(t))
            (;; Second is a file, first is not.
             (bmkx-local-file-bookmark-p b2)
             '(nil))
            (t;; Neither is a file.
             nil)))))

;;; This is also defined in `bookmark-x-1.el'.  It is used here to produce the code for
;;; `bmkx-define-history-variables' and `bmkx-define-sort-command'.
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

;; Macro that defines Bookmark-X history variables.
;; Use this after you define any new filter function, `bmkx-*-alist-only',
;; for a new kind of bookmark.
;;
;;;###autoload (autoload 'bmkx-define-history-variables "bookmark-x")
(defmacro bmkx-define-history-variables ()
  "Create and eval defvars for Bookmark-X history variables.
The variables are the cdrs of `bmkx-types-alist'.  They are used in
commands such as `bmkx-jump-to-type'."
  (let ((dfvars  ()))
    (dolist (entry  (bmkx-types-alist))
      (push `(defvar ,(cdr entry) () ,(format "History for %s bookmarks." (car entry)))
            dfvars))
    `(progn ,@dfvars)))

;; This macro is not used in the Bookmark-X code.  It's available for users who want to define
;; simple bookmark types that are based only on a handler.
;;
;;;###autoload (autoload 'bmkx-define-type-from-hander "bookmark-x")
(defmacro bmkx-define-type-from-hander (type handler)
  "Define a TYPE of bookmarks based only on a HANDLER function.
TYPE is a short string or symbol.

Define predicate `bmkx-TYPE-bookmark-p', which returns non-nil if its
bookmark argument has HANDLER.

Define filter function `bmkx-TYPE-alist-only', which returns only the
TYPE bookmarks from the current bookmark list.

Define command `bmkx-bmenu-show-only-TYPE-bookmarks', which shows only
the TYPE bookmarks, in the bookmark-list display."
  (let  ((predicate-doc   (format "Return non-nil if BOOKMARK is a %s bookmark." type))
         (predicate-symb  (intern (format "bmkx-%s-bookmark-p" type)))
         (predicate       `(eq (bookmark-get-handler bmk) ',handler))
         (alist-only-doc  (format "`bookmark-alist', filtered to retain only %s bookmarks." type))
         (alist-only-fn   (intern (format "bmkx-%s-alist-only" type)))
         (show-only-doc   (format "Display (only) the %s bookmarks." type)))
    `(progn (defun ,predicate-symb (bookmark)
              ,predicate-doc
              ,predicate)
            (defun ,alist-only-fn ()
              ,alist-only-doc
              (bmkx-maybe-load-default-file)
              (bmkx-remove-if-not (lambda (bmk) ,predicate) bookmark-alist))
            (bmkx-define-show-only-command ,type ,show-only-doc ,alist-only-fn)
            (bmkx-define-history-variables))))

;;;###autoload (autoload 'bmkx-menu-bar-make-toggle "bookmark-x")
(defmacro bmkx-menu-bar-make-toggle (command variable item-name message help
                                     &optional setting-sexp &rest keywords)
  "Define a menu-bar toggle command.
COMMAND (a symbol) is the toggle command to define.
VARIABLE (a symbol) is the variable to set.
ITEM-NAME (a string) is the menu-item name.
MESSAGE is a format string for the toggle message, with %s for the new
 status.
HELP (a string) is the `:help' tooltip text and the doc string first
 line (minus final period) for the command.
SETTING-SEXP is a Lisp sexp that sets VARIABLE, or it is nil meaning
 set it according to its `defcustom' or using `set-default'.
KEYWORDS is a plist for `menu-item' for keywords other than `:help'."
  `(progn
    (defun ,command (&optional interactively)
      ,(concat help ".
In an interactive call, record this option as a candidate for saving
by \"Save Options\" in Custom buffers.")
      (interactive "p")
      (if ,(if setting-sexp
               `,setting-sexp
               `(progn
		 (custom-load-symbol ',variable)
		 (let ((set (or (get ',variable 'custom-set) 'set-default))
		       (get (or (get ',variable 'custom-get) 'default-value)))
		   (funcall set ',variable (not (funcall get ',variable))))))
          (message ,message "enabled globally")
        (message ,message "disabled globally"))
      ;; `customize-mark-as-set' must only be called when a variable is set interactively,
      ;; because the purpose is to mark the variable as a candidate for `Save Options', and we
      ;; do not want to save options that the user has already set explicitly in the init file.
      (when interactively (customize-mark-as-set ',variable)))
    '(menu-item ,item-name ,command
      :help ,help
      :button (:toggle . (and (default-boundp ',variable) (default-value ',variable)))
      ,@keywords)))

;;; Not used currently.  Provided so you can use it in your own code, if appropriate.
;;;###autoload (autoload 'bmkx-with-bookmark-dir "bookmark-x")
(defmacro bmkx-with-bookmark-dir (bookmark &rest body)
  "Evaluate BODY forms with BOOKMARK location as `default-directory'.
If BOOKMARK has no location then use nil as `default-directory'."
  `(let* ((loc                (bmkx-location ,bookmark))
          (default-directory  (and (stringp loc)  (not (member loc (list bmkx-non-file-filename
                                                                    "-- Unknown location --")))
                               (if (file-directory-p loc) loc (file-name-directory loc)))))
    ,@body))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'bookmark-x-mac)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; bookmark-x-mac.el ends here
