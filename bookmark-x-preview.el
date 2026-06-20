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

;;; Code:

(require 'bookmark)

(declare-function bmkx-list-bookmark             "bookmark-x-bmu")
(declare-function bmkx-jump-1                    "bookmark-x-1")
(declare-function bmkx-maybe-load-default-file   "bookmark-x-1")
(declare-function bmkx-completing-read           "bookmark-x-1")
(declare-function bmkx-default-bookmark-name     "bookmark-x-1")

;; Soft consult deps — only used when `(featurep 'consult)'.
(declare-function consult--read                  "consult")
(declare-function consult--bookmark-preview      "consult")


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

;;;###autoload
(defun bmkx-read-bookmark-for-jump (prompt &optional default)
  "Read a bookmark name with live preview, for the `bmkx-jump' commands.

When the `consult' package is loaded and `bmkx-preview-use-consult-flag'
is non-nil, read through `consult--read' with the same preview state
function `consult-bookmark' uses.  Otherwise fall back to
`bmkx-completing-read'."
  (bmkx-maybe-load-default-file)
  (if (and bmkx-preview-use-consult-flag
           (featurep 'consult)
           (fboundp 'consult--read)
           (fboundp 'consult--bookmark-preview))
      (consult--read
       (mapcar #'car bookmark-alist)
       :prompt        (concat prompt
                              (if default
                                  (format " (%s): "
                                          (if (consp default) (car default) default))
                                ": "))
       :require-match t
       :default       (if (consp default) (car default) default)
       :history       'bookmark-history
       :category      'bookmark
       :state         (consult--bookmark-preview))
    (bmkx-completing-read prompt default)))


(provide 'bookmark-x-preview)

;;; bookmark-x-preview.el ends here
