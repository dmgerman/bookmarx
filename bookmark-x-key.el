;;; bookmark-x-key.el --- Bookmark-X key and menu bindings.   -*- lexical-binding:t -*-
;;
;; Filename:    bookmark-x-key.el
;; Description: Bookmark-X key and menu bindings.
;;              Fork of Drew Adams' Bookmark+, modernized for Emacs 30+.
;;
;; Author:     Drew Adams
;; Maintainer: Daniel M. German <dmg@turingmachine.org>
;;
;; Copyright (C) 2010-2023, Drew Adams, all rights reserved.
;; Copyright (C) 2026, Daniel M. German, all rights reserved.
;;
;; Created: Fri Apr  1 15:34:50 2011 (-0700)
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
;;    The Bookmark-X libraries are these:
;;
;;    `bookmark-x.el'     - main (driver) library
;;    `bookmark-x-mac.el' - Lisp macros
;;    `bookmark-x-lit.el' - (optional) code for highlighting bookmarks
;;    `bookmark-x-bmu.el' - code for the `*Bmkx List*' (bmenu)
;;    `bookmark-x-1.el'   - other (non-bmenu) required code
;;    `bookmark-x-key.el' - key and menu bindings (this file)
;;
;;    User documentation is the `bookmark-x' Info manual.  See
;;    `M-x info RET m bookmark-x RET' or the source in
;;    `doc/bookmark-x.texi'.
;;
;;
;;  User options defined here:
;;
;;    `bmkx-add-bookmarks-here-menu-flag',
;;    `bmkx-bookmark-map-prefix-key', `bmkx-jump-map-prefix-key',
;;    `bmkx-jump-other-window-map-prefix-key'.
;;
;;  Non-interactive functions defined here:
;;
;;    `bmkx-bookmark-data-from-record',
;;    `bmkx-bookmark-name-from-record',
;;    `bmkx-exists-bookmark-satisfying-p',
;;    `bmkx-exists-this-file/buffer-bookmarks-p',
;;    `bmkx-set-map-prefix-key', `bookmark-name-from-full-record',
;;    `bookmark-name-from-record'.
;;
;;  Internal variables defined here:
;;
;;    `bmkx-annotate-map', `bmkx-annotate-menu', `bmkx-here-menu',
;;    `bmkx-bookmarks-here-menu-command-entries',
;;    `bmkx-find-file-menu', `bmkx-highlight-menu', `bmkx-jump-map',
;;    `bmkx-jump-menu', `bmkx-jump-other-window-map',
;;    `bmkx-jump-tags-menu', `bmkx-set-map', `bmkx-tags-map',
;;    `bmkx-tags-menu'.
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

;;;;;;;;;;;;;;;;;;;;;

(eval-when-compile
 (or (condition-case nil
         (load-library "bookmark-x-mac") ; Use load-library to ensure latest .elc.
       (error nil))
     (require 'bookmark-x-mac)))         ; Require, so can load separately if not on `load-path'.
;; bmkx-menu-bar-make-toggle

(eval-when-compile (unless (require 'cl-lib nil t)
                     (require 'cl)
                     (defalias 'cl-case 'case)))

;;;;;;;;;;;;;;;;;;;;;;;

;; Quiet the byte-compiler

(defvar bmkx-bmenu-buffer) ; In `bookmark-x.el'
(defvar grep-mode-map)
(defvar compilation-mode-map)              ; In `compile.el'
(defvar compilation-minor-mode-map)        ; In `compile.el'
(defvar compilation-shell-minor-mode-map)  ; In `compile.el'


;; Prefix keys.
;;
;; These two maps are always on `bookmark-map', wherever it is: `bmkx-set-map', `bmkx-tags-map'.
;;
(defun bmkx-set-map-prefix-key (pref-keys-option keys)
  "Set prefix key option SYMBOL to key-sequence VALUE."
  (set pref-keys-option keys)
  (let* ((g-map  (current-global-map))
         (b-map  (cl-case pref-keys-option
                   (bmkx-bookmark-map-prefix-keys          'bookmark-map)
                   (bmkx-jump-map-prefix-keys              'bmkx-jump-map)
                   (bmkx-jump-other-window-map-prefix-keys 'bmkx-jump-other-window-map))))
    (dolist (key  (where-is-internal b-map g-map))
      (define-key g-map key nil))
    (dolist (key  keys)
      (define-key g-map key b-map))))

(defcustom bmkx-bookmark-map-prefix-keys (list (kbd "C-x x"))
  "Prefix keys for `bookmark-map' in `current-global-map'.
Each value of the list is a prefix key bound to keymap `bookmark-map'."
  :type '(repeat (key-sequence :tag "Key" :value [ignore]))
  :set 'bmkx-set-map-prefix-key
  :group 'bookmark-plus)

(defcustom bmkx-jump-map-prefix-keys (list (kbd "C-x j"))
  "Prefix keys for `bmkx-jump-map' in `current-global-map'.
Each value of the list is a prefix key bound to keymap
`bmkx-jump-map'."
  :type '(repeat (key-sequence :tag "Key" :value [ignore]))
  :set 'bmkx-set-map-prefix-key
  :group 'bookmark-plus)

(defcustom bmkx-jump-other-window-map-prefix-keys (list (kbd "C-x 4 j"))
  "Prefix keys for `bmkx-jump-other-window-map' in `current-global-map'.
Each value of the list is a prefix key bound to keymap
`bmkx-jump-other-window-map'."
  :type '(repeat (key-sequence :tag "Key" :value [ignore]))
  :set 'bmkx-set-map-prefix-key
  :group 'bookmark-plus)

(defcustom bmkx-add-bookmarks-here-menu-flag nil
  "Non-nil means add a `Bookmarks Here' menu to some menu-bar menus.
The menu is added only if there are in fact bookmarks for the current
buffer or file.  The default value is nil because checking whether
there are such bookmarks can take a little time."
  :type 'boolean :group 'bookmark-plus)



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


;; Quiet the byte-compiler
(defvar bmkx-bmenu-menubar-menu)        ; In `bookmark-x-bmu.el'.
(defvar bmkx-bmenu-toggle-menu)         ; In `bookmark-x-bmu.el'.
(defvar bmkx-highlight-on-jump-flag)    ; In `bookmark-x-1.el'.
(defvar bmkx-eww-replace-keys-flag)     ; In `bookmark-x-1.el' (Emacs 25+).
(defvar bmkx-prompt-for-tags-flag)      ; In `bookmark-x-1.el'.
(defvar bmkx-save-new-location-flag)    ; In `bookmark-x-1.el'.
(defvar diredp-bookmark-menu)           ; In `dired+.el'.
(defvar eww-mode-map)                   ; In `eww.el' (Emacs 24.4+).
(defvar gnus-summary-mode-map)          ; In `gnus-sum.el'.
(defvar Info-mode-map)                  ; In `info.el'.
(defvar Info-mode-menu)                 ; In `info.el'.
(defvar Man-mode-map)                   ; In `man.el'.
(defvar mouse-wheel-down-event)         ; In `mwheel.el'.
(defvar mouse-wheel-up-event)           ; In `mwheel.el'.
(defvar woman-menu)                     ; In `woman.el'.
(defvar woman-mode-map)                 ; In `woman.el'.
 
;;(@* "Keymaps")
;;; Keymaps ----------------------------------------------------------

;; `help-map'
(define-key help-map "M"  'bmkx-describe-bookmark)

;; `bookmark-map'

;; (define-key ctl-x-map "x" bookmark-map)
;; (define-key ctl-x-map "xj" 'bmkx-jump-other-window)               ; `C-x x j' (also `C-x 4 j j')
(define-key ctl-x-map "rK" 'bmkx-set-desktop-bookmark)        ; `C-x r K' (also `C-x x K', `C-x x c K')

(define-key bookmark-map "0"      'bmkx-empty-file)                                   ; `C-x x 0'
(define-key bookmark-map "2"      'bmkx-clone-bookmark)                               ; `C-x x 2'
(define-key bookmark-map "5"      'bmkx-jump-other-frame)                         ; `C-x x 5'
(define-key bookmark-map "B"      'bmkx-choose-navlist-from-bookmark-list)            ; `C-x x B'
;; `e' is `edit-bookmarks' (aka `bmkx-list', from built-in Emacs.
(define-key bookmark-map "E"      'bmkx-edit-bookmark-record)                         ; `C-x x E'
;; The original `bmkx-insert-location' in `bookmark.el' was `f'.
(define-key bookmark-map "I"      'bmkx-insert-location)                          ; `C-x x I'
(define-key bookmark-map (kbd "C-j")   'bmkx-jump-to-list)                                 ; `C-x x C-j'
(define-key bookmark-map "K"      'bmkx-set-desktop-bookmark) ; `C-x x K' (also `C-x r K', `C-x x c K')
(define-key bookmark-map "L"      'bmkx-switch-bookmark-file-create)                  ; `C-x x L'
(define-key bookmark-map (kbd "C-l")   'bmkx-switch-to-bookmark-file-this-file/buffer)     ; `C-x x C-l'
(define-key bookmark-map "m"      'bmkx-bookmark-set-confirm-overwrite)               ; `C-x x m'
(define-key bookmark-map "N"      'bmkx-navlist-bmenu-list)                           ; `C-x x N'
(define-key bookmark-map "o"      'bmkx-jump-other-window)           ; `C-x x o' (also `C-x 4 j j')
(define-key bookmark-map "q"      'bmkx-jump-other-window)           ; `C-x x q' (also `C-x 4 j j')
(define-key bookmark-map "r"      'bmkx-edit-bookmark-name-and-location)              ; `C-x x r'
(define-key bookmark-map (kbd "C-s")   'bmkx-save-bookmarks-this-file/buffer)              ; `C-x x C-s'
(define-key bookmark-map (kbd "M-w")   'bmkx-set-snippet-bookmark)        ; `C-x x M-w' (also `C-x x c M-w')
(define-key bookmark-map "x"      'bmkx-toggle-autotemp-on-set)                       ; `C-x x x'
(define-key bookmark-map "y"      'bmkx-set-bookmark-file-bookmark)                   ; `C-x x y'
(when (featurep 'bookmark-x-lit)
  (define-key bookmark-map "h"    'bmkx-light-bookmark-this-buffer)                   ; `C-x x h'
  (define-key bookmark-map "H"    'bmkx-light-bookmarks)                              ; `C-x x H'
  (define-key bookmark-map "u"    'bmkx-unlight-bookmark-this-buffer)                 ; `C-x x u'
  (define-key bookmark-map "U"    'bmkx-unlight-bookmarks)                            ; `C-x x U'
  (define-key bookmark-map (kbd "C-u") 'bmkx-unlight-bookmark-here)                        ; `C-x x C-u'
  (define-key bookmark-map "="    'bmkx-bookmarks-lighted-at-point))                  ; `C-x x ='
(define-key bookmark-map ","      'bmkx-this-file/buffer-bmenu-list)                  ; `C-x x ,'
(define-key bookmark-map "?"      'bmkx-describe-bookmark-lighted-here)               ; `C-x x ?'
(define-key bookmark-map ":"      'bmkx-choose-navlist-of-type)                       ; `C-x x :'
(define-key bookmark-map "\r"     'bmkx-toggle-autonamed-bmkx-set/delete)         ; `C-x x RET'
(define-key bookmark-map [delete] 'bmkx-delete-bookmarks)                             ; `C-x x delete'

(substitute-key-definition 'kill-line 'bmkx-delete-bookmarks          ; `C-x x C-k', `C-x x deleteline'
                           bookmark-map (current-global-map))
(define-key bookmark-map [deletechar] 'bmkx-delete-bookmarks)                      ; `C-x x deletechar'
;; For Mac Book:
(define-key bookmark-map [kp-delete] 'bmkx-delete-bookmarks)                        ; `C-x x kp-delete'

(define-key bookmark-map "n"          'bmkx-next-bookmark-this-file/buffer-repeat) ; `C-x x n'
(define-key bookmark-map (kbd "C-n")       'bmkx-next-bookmark-this-file/buffer-repeat) ; `C-x x C-n'
(define-key bookmark-map [down]       'bmkx-next-bookmark-this-file/buffer-repeat) ; `C-x x down'
(put 'bmkx-next-bookmark-this-file/buffer-repeat :advertised-binding (kbd "C-x x <down>"))

(when (boundp 'mouse-wheel-up-event)
  (define-key bookmark-map (vector (list mouse-wheel-up-event))
    'bmkx-next-bookmark-this-file/buffer-repeat))                              ; `C-x x mouse-wheel-up'

(define-key bookmark-map "p"          'bmkx-previous-bookmark-this-file/buffer-repeat) ; `C-x x p'
(define-key bookmark-map (kbd "C-p")       'bmkx-previous-bookmark-this-file/buffer-repeat) ; `C-x x C-p'
(define-key bookmark-map [up]         'bmkx-previous-bookmark-this-file/buffer-repeat) ; `C-x x up'
(put 'bmkx-previous-bookmark-this-file/buffer-repeat :advertised-binding (kbd "C-x x <up>"))

(when (boundp 'mouse-wheel-down-event)
  (define-key bookmark-map (vector (list mouse-wheel-down-event))
    'bmkx-previous-bookmark-this-file/buffer-repeat))                          ; `C-x x mouse-wheel-down'

(define-key bookmark-map "f"          'bmkx-next-bookmark-repeat)              ; `C-x x f'
(define-key bookmark-map (kbd "C-f")       'bmkx-next-bookmark-repeat)              ; `C-x x C-f'
(define-key bookmark-map [right]      'bmkx-next-bookmark-repeat)              ; `C-x x right'
(put 'bmkx-next-bookmark-repeat :advertised-binding (kbd "C-x x <right>"))
(define-key bookmark-map "b"          'bmkx-previous-bookmark-repeat)          ; `C-x x b'
(define-key bookmark-map (kbd "C-b")       'bmkx-previous-bookmark-repeat)          ; `C-x x C-b'
(define-key bookmark-map [left]       'bmkx-previous-bookmark-repeat)          ; `C-x x left'
(put 'bmkx-previous-bookmark-repeat :advertised-binding (kbd "C-x x <left>"))
(define-key bookmark-map [next]       'bmkx-next-bookmark-w32-repeat)          ; `C-x x next'
(define-key bookmark-map [prior]      'bmkx-previous-bookmark-w32-repeat)      ; `C-x x prior'
(when (featurep 'bookmark-x-lit)
  (define-key bookmark-map [C-down]   'bmkx-next-lighted-this-buffer-repeat)   ; `C-x x C-down'
  (define-key bookmark-map [C-up]     'bmkx-previous-lighted-this-buffer-repeat)) ; `C-x x C-up'


;; `bmkx-annotate-map': prefix `C-x x a'

(defvar bmkx-annotate-map nil "Keymap containing bindings for bookmark annotation commands.")

(define-prefix-command 'bmkx-annotate-map)
(define-key bookmark-map "a"      bmkx-annotate-map)                           ; `C-x x a' for annotate

(define-key bmkx-annotate-map "a" 'bmkx-annotate-bookmark)                     ; `C-x x a a'
(define-key bmkx-annotate-map "b" 'bmkx-annotate-bookmark-this-file/buffer)    ; `C-x x a b'
(define-key bmkx-annotate-map "B" 'bmkx-annotate-all-bookmarks-this-file/buffer) ; `C-x x a B'
(define-key bmkx-annotate-map "e" 'bmkx-edit-annotation)                   ; `C-x x a e'
(define-key bmkx-annotate-map "s" 'bmkx-show-annotation)                   ; `C-x x a s'
(define-key bmkx-annotate-map "S" 'bmkx-show-all-annotations)              ; `C-x x a S'


;; `bmkx-set-map': prefix `C-x x c'

(defvar bmkx-set-map nil "Keymap containing bindings for bookmark set commands.")

(define-prefix-command 'bmkx-set-map)
(define-key bookmark-map "c"    bmkx-set-map)                                  ; `C-x x c' for create

(define-key bmkx-set-map "a"    'bmkx-autofile-set)                            ; `C-x x c a'
(define-key bmkx-set-map "f"    'bmkx-file-target-set)                         ; `C-x x c f'
(define-key bmkx-set-map "F"    'bmkx-make-function-bookmark)                  ; `C-x x c F'
(define-key bmkx-set-map "K"    'bmkx-set-desktop-bookmark)                    ; `C-x x c K'
(define-key bmkx-set-map (kbd "C-k") 'bmkx-wrap-bookmark-with-last-kbd-macro)       ; `C-x x C-k'
(define-key bmkx-set-map "m"    'bmkx-bookmark-set-confirm-overwrite)          ; `C-x x c m'
(define-key bmkx-set-map "M"    'bmkx-set)                                 ; `C-x x c M'
(define-key bmkx-set-map "s"    'bmkx-set-sequence-bookmark)                   ; `C-x x c s'
(define-key bmkx-set-map "u"    'bmkx-url-target-set)                          ; `C-x x c u'
(define-key bmkx-set-map (kbd "M-w") 'bmkx-set-snippet-bookmark)                    ; `C-x x c M-w'
(define-key bmkx-set-map "y"    'bmkx-set-bookmark-file-bookmark)              ; `C-x x c y'
(define-key bmkx-set-map "\r"   'bmkx-toggle-autonamed-bmkx-set/delete)    ; `C-x x c RET'


;; Add set commands to other keymaps: occur, compilation: `C-c C-b', `C-c C-M-b', `C-c C-M-B'.
;; See `dired+.el' for Dired bookmarking keys, which are different.

(add-hook 'occur-mode-hook
          (lambda ()
            (unless (lookup-key occur-mode-map "\C-c\C-b")
              (define-key occur-mode-map (kbd "C-c C-b") 'bmkx-occur-target-set)) ; `C-c C-b'
            (unless (lookup-key occur-mode-map "\C-c\C-\M-b")
              (define-key occur-mode-map (kbd "C-c C-M-b") 'bmkx-occur-target-set-all)) ; `C-c C-M-b'
            (unless (lookup-key occur-mode-map [(control ?c) (control meta shift ?b)])
              (define-key occur-mode-map [(control ?c) (control meta shift ?b)]
                'bmkx-occur-create-autonamed-bookmarks)))) ; `C-c C-M-B' (aka `C-c C-M-S-b')

(when (fboundp 'bmkx-compilation-target-set) ; Emacs 22+

  (add-hook 'compilation-mode-hook
            (lambda ()
              (unless (lookup-key compilation-mode-map "\C-c\C-b")
                (define-key compilation-mode-map (kbd "C-c C-b") 'bmkx-compilation-target-set)) ; `C-c C-b'
              (unless (lookup-key compilation-mode-map "\C-c\C-\M-b") ; `C-c C-M-b'
                (define-key compilation-mode-map (kbd "C-c C-M-b") 'bmkx-compilation-target-set-all))))

  (when (fboundp 'compilation-minor-mode) ; Emacs 26+

    (add-hook
     'grep-mode-hook
     (lambda ()
       (unless (lookup-key grep-mode-map "\C-c\C-b")
         (define-key grep-mode-map (kbd "C-c C-b") 'bmkx-compilation-target-set)) ; `C-c C-b'
       (unless (lookup-key grep-mode-map "\C-c\C-\M-b") ; `C-c C-M-b'
         (define-key grep-mode-map (kbd "C-c C-M-b") 'bmkx-compilation-target-set-all))))

    (add-hook
     'compilation-minor-mode-hook
     (lambda ()
       (unless (lookup-key compilation-minor-mode-map "\C-c\C-b")
         (define-key compilation-minor-mode-map (kbd "C-c C-b") 'bmkx-compilation-target-set)) ; `C-c C-b'
       (unless (lookup-key compilation-minor-mode-map "\C-c\C-\M-b") ; `C-c C-M-b'
         (define-key compilation-minor-mode-map (kbd "C-c C-M-b") 'bmkx-compilation-target-set-all))))

    (add-hook
     'compilation-shell-minor-mode-hook
     (lambda ()
       (unless (lookup-key compilation-shell-minor-mode-map "\C-c\C-b")
         (define-key compilation-shell-minor-mode-map
           "\C-c\C-b" 'bmkx-compilation-target-set)) ; `C-c C-b'
       (unless (lookup-key compilation-shell-minor-mode-map "\C-c\C-\M-b") ; `C-c C-M-b'
         (define-key compilation-shell-minor-mode-map
           "\C-c\C-\M-b" 'bmkx-compilation-target-set-all))))))


;; `bmkx-tags-map': prefix `C-x x t'

(defvar bmkx-tags-map nil "Keymap containing bindings for bookmark tag commands.")

(define-prefix-command 'bmkx-tags-map)
(define-key bookmark-map "t"  bmkx-tags-map)                                      ; `C-x x t' for tags

(define-key bmkx-tags-map "0"    'bmkx-remove-all-tags)                           ; `C-x x t 0'
(define-key bmkx-tags-map "+b"   'bmkx-add-tags)                                  ; `C-x x t + b'
(define-key bmkx-tags-map "-b"   'bmkx-remove-tags)                               ; `C-x x t - b'
(define-key bmkx-tags-map "+a"   'bmkx-tag-a-file)                                ; `C-x x t + a'
(define-key bmkx-tags-map "-a"   'bmkx-untag-a-file)                              ; `C-x x t - a'
(define-key bmkx-tags-map "c"    'bmkx-copy-tags)                                 ; `C-x x t c'
(define-key bmkx-tags-map "d"    'bmkx-remove-tags-from-all)                      ; `C-x x t d'
(define-key bmkx-tags-map "e"    'bmkx-edit-tags)                                 ; `C-x x t e'
(define-key bmkx-tags-map "l"    'bmkx-list-all-tags)                             ; `C-x x t l'
(define-key bmkx-tags-map "p"    'bmkx-paste-add-tags)                            ; `C-x x t p'
(define-key bmkx-tags-map "q"    'bmkx-paste-replace-tags)                        ; `C-x x t q'
(define-key bmkx-tags-map "r"    'bmkx-rename-tag)                                ; `C-x x t r'
(define-key bmkx-tags-map "v"    'bmkx-set-tag-value)                             ; `C-x x t v'
(define-key bmkx-tags-map "V"    'bmkx-set-tag-value-for-navlist)                 ; `C-x x t V'
(define-key bmkx-tags-map (kbd "M-w") 'bmkx-copy-tags)                                 ; `C-x x t M-w'
(define-key bmkx-tags-map (kbd "C-y") 'bmkx-paste-add-tags)                            ; `C-x x t C-y'


;; `bmkx-jump-map' and `bmkx-jump-other-window-map': prefixes `C-x j' and `C-x 4 j'

(defvar bmkx-jump-map nil "Keymap containing bindings for bookmark jump commands.")

(defvar bmkx-jump-other-window-map nil
  "Keymap containing bindings for bookmark jump other-window commands.")

(define-prefix-command 'bmkx-jump-map)
(define-prefix-command 'bmkx-jump-other-window-map)
;; (define-key ctl-x-map   "j" bmkx-jump-map)
;; (define-key ctl-x-4-map "j" bmkx-jump-other-window-map)
(define-key bmkx-list-mode-map "J"  bmkx-jump-map)
(define-key bmkx-list-mode-map "j"  bmkx-jump-other-window-map)
(define-key bmkx-list-mode-map "j>" 'bmkx-bmenu-jump-to-marked)                           ; `j >'

(define-key ctl-x-5-map                "B"    'bmkx-jump-other-frame)       ; `C-x j 5', `C-x 5 B'
(define-key bmkx-jump-map              "5"    'bmkx-jump-other-frame )                     ; `J 5'
(define-key bmkx-jump-map              ".d"   'bmkx-dired-this-dir-jump)                 ; `C-x j . d'
(define-key bmkx-jump-other-window-map ".d"   'bmkx-dired-this-dir-jump-other-window)  ; `C-x 4 j . d'
(define-key bmkx-jump-map              ".f"   'bmkx-file-this-dir-jump)                  ; `C-x j . f'
(define-key bmkx-jump-other-window-map ".f"   'bmkx-file-this-dir-jump-other-window)   ; `C-x 4 j . f'

(define-key bmkx-jump-map              ",,"   'bmkx-this-buffer-jump)                    ; `C-x j , ,'
(define-key bmkx-jump-other-window-map ",,"   'bmkx-this-buffer-jump-other-window)     ; `C-x 4 j , ,'
(define-key bmkx-jump-map              ",#"   'bmkx-autonamed-this-buffer-jump)          ; `C-x j , #'
(define-key bmkx-jump-other-window-map ",#"
  'bmkx-autonamed-this-buffer-jump-other-window)                                       ; `C-x 4 j , #'

(define-key bmkx-jump-map              "#"    'bmkx-autonamed-jump)                        ; `C-x j #'
(define-key bmkx-jump-other-window-map "#"    'bmkx-autonamed-jump-other-window)         ; `C-x 4 j #'

(define-key bmkx-jump-map              "=b"   'bmkx-specific-buffers-jump)                ; `C-x j = b'
(define-key bmkx-jump-other-window-map "=b"   'bmkx-specific-buffers-jump-other-window) ; `C-x 4 j = b'
(define-key bmkx-jump-map              "=f"   'bmkx-specific-files-jump)                  ; `C-x j = f'
(define-key bmkx-jump-other-window-map "=f"   'bmkx-specific-files-jump-other-window)   ; `C-x 4 j = f'

(define-key bmkx-jump-map              "a"    'bmkx-autofile-jump)                          ; `C-x j a'
(define-key bmkx-jump-other-window-map "a"    'bmkx-autofile-jump-other-window)           ; `C-x 4 j a'
(define-key bmkx-jump-map              "b"    'bmkx-non-file-jump)                          ; `C-x j b'
(define-key bmkx-jump-other-window-map "b"    'bmkx-non-file-jump-other-window)           ; `C-x 4 j b'
(define-key bmkx-jump-map              "B"    'bmkx-bookmark-list-jump)                     ; `C-x j B'
(define-key bmkx-jump-other-window-map "B"    'bmkx-bookmark-list-jump)     ; SAME COMMAND: `C-x 4 j B'
(define-key bmkx-jump-map              "d"    'bmkx-dired-jump)                             ; `C-x j d'
(define-key bmkx-jump-other-window-map "d"    'bmkx-dired-jump-other-window)              ; `C-x 4 j d'

(eval-after-load "eww"
  '(progn
     (when bmkx-eww-replace-keys-flag
       (bmkx-remap 'eww-add-bookmark       'bmkx-set                eww-mode-map)
       (bmkx-remap 'eww-list-bookmarks     'bmkx-list               eww-mode-map)
       (bmkx-remap 'eww-next-bookmark      'bmkx-next-url-bookmark  eww-mode-map)
       (bmkx-remap 'eww-previous-bookmark  'bmkx-previous-url-bookmark eww-mode-map))
     (define-key bmkx-jump-map              "e"  'bmkx-eww-jump)            ; `C-x j e'
     (define-key bmkx-jump-other-window-map "e"  'bmkx-eww-jump-other-window))) ; `C-x 4 j e'

(define-key bmkx-jump-map              "f"    'bmkx-file-jump)                              ; `C-x j f'
(define-key bmkx-jump-other-window-map "f"    'bmkx-file-jump-other-window)               ; `C-x 4 j f'
(define-key bmkx-jump-map              (kbd "C-f") 'bmkx-find-file)                            ; `C-x j C-f'
(define-key bmkx-jump-other-window-map (kbd "C-f") 'bmkx-find-file-other-window)             ; `C-x 4 j C-f'
(define-key bmkx-jump-map              "g"    'bmkx-gnus-jump)                              ; `C-x j g'
(define-key bmkx-jump-other-window-map "g"    'bmkx-gnus-jump-other-window)               ; `C-x 4 j g'
(define-key bmkx-jump-map              "h"    'bmkx-lighted-jump)                           ; `C-x j h'
(define-key bmkx-jump-other-window-map "h"    'bmkx-lighted-jump-other-window)            ; `C-x 4 j h'
(define-key bmkx-jump-map              "i"    'bmkx-info-jump)                              ; `C-x j i'
(define-key bmkx-jump-other-window-map "i"    'bmkx-info-jump-other-window)               ; `C-x 4 j i'
(define-key bmkx-jump-map              (kbd "M-i") 'bmkx-image-jump)                           ; `C-x j M-i'
(define-key bmkx-jump-other-window-map (kbd "M-i") 'bmkx-image-jump-other-window)            ; `C-x 4 j M-i'
(define-key bmkx-jump-map              "j"    'bmkx-jump)                               ; `C-x j j'
(put 'bmkx-jump :advertised-binding "\C-xjj")

(define-key bmkx-jump-other-window-map "j"    'bmkx-jump-other-window)                ; `C-x 4 j j'
(put 'bmkx-jump-other-window :advertised-binding "\C-x4jj")
(put 'jump-other :advertised-binding "\C-x4jj")

(define-key bmkx-jump-map              (kbd "C-j") 'bmkx-jump-to-list)                         ; `C-x j C-j'
(define-key bmkx-jump-map              "K"    'bmkx-desktop-jump)                           ; `C-x j K'
(define-key bmkx-jump-other-window-map "K"    'bmkx-desktop-jump)           ; SAME COMMAND: `C-x 4 j K'
(define-key bmkx-jump-map              "l"    'bmkx-local-file-jump)                        ; `C-x j l'
(define-key bmkx-jump-other-window-map "l"    'bmkx-local-file-jump-other-window)         ; `C-x 4 j l'
(define-key bmkx-jump-map              "m"    'bmkx-man-jump)                               ; `C-x j m'
(define-key bmkx-jump-other-window-map "m"    'bmkx-man-jump-other-window)                ; `C-x 4 j m'
(define-key bmkx-jump-map              "n"    'bmkx-remote-file-jump)         ; `C-x j n' ("_n_etwork")
(define-key bmkx-jump-other-window-map "n"    'bmkx-remote-file-jump-other-window)        ; `C-x 4 j n'
(define-key bmkx-jump-map              "N"    'bmkx-jump-in-navlist)                        ; `C-x j N'
(define-key bmkx-jump-other-window-map "N"    'bmkx-jump-in-navlist-other-window)         ; `C-x 4 j N'
(define-key bmkx-jump-map              "r"    'bmkx-region-jump)                            ; `C-x j r'
(define-key bmkx-jump-other-window-map "r"    'bmkx-region-jump-other-window)             ; `C-x 4 j r'
(define-key bmkx-jump-other-window-map "R"
  'bmkx-region-jump-narrow-indirect-other-window)                                         ; `C-x 4 j R'

(define-key bmkx-jump-map              "t*"   'bmkx-all-tags-jump)                        ; `C-x j t *'
(define-key bmkx-jump-other-window-map "t*"   'bmkx-all-tags-jump-other-window)         ; `C-x 4 j t *'
(define-key bmkx-jump-map              "t+"   'bmkx-some-tags-jump)                       ; `C-x j t +'
(define-key bmkx-jump-other-window-map "t+"   'bmkx-some-tags-jump-other-window)        ; `C-x 4 j t +'
(define-key bmkx-jump-map              "tT"   'bmkx-tag-jump)                          ; `C-x j t T'
(define-key bmkx-jump-other-window-map "tT"   'bmkx-tag-jump-other-window)           ; `C-x 4 j t T'

(define-key bmkx-jump-map              "t%*"  'bmkx-all-tags-regexp-jump)               ; `C-x j t % *'
(define-key bmkx-jump-other-window-map "t%*"
  'bmkx-all-tags-regexp-jump-other-window)                                            ; `C-x 4 j t % *'
(define-key bmkx-jump-map              "t%+"  'bmkx-some-tags-regexp-jump)              ; `C-x j t % +'
(define-key bmkx-jump-other-window-map "t%+"
  'bmkx-some-tags-regexp-jump-other-window)                                           ; `C-x 4 j t % +'

(define-key bmkx-jump-map              "t.*" 'bmkx-file-this-dir-all-tags-jump)         ; `C-x j t . *'
(define-key bmkx-jump-other-window-map "t.*"
  'bmkx-file-this-dir-all-tags-jump-other-window)                                     ; `C-x 4 j t . *'
(define-key bmkx-jump-map              "t.+" 'bmkx-file-this-dir-some-tags-jump)        ; `C-x j t . +'
(define-key bmkx-jump-other-window-map "t.+"
  'bmkx-file-this-dir-some-tags-jump-other-window)                                    ; `C-x 4 j t . +'

(define-key bmkx-jump-map              "t.%*"
  'bmkx-file-this-dir-all-tags-regexp-jump)                                           ; `C-x j t . % *'
(define-key bmkx-jump-other-window-map "t.%*"
  'bmkx-file-this-dir-all-tags-regexp-jump-other-window)                            ; `C-x 4 j t . % *'
(define-key bmkx-jump-map              "t.%+"
  'bmkx-file-this-dir-some-tags-regexp-jump)                                          ; `C-x j t . % +'
(define-key bmkx-jump-other-window-map "t.%+"
  'bmkx-file-this-dir-some-tags-regexp-jump-other-window)                           ; `C-x 4 j t . % +'


(define-key bmkx-jump-map              "ta*"  'bmkx-autofile-all-tags-jump)             ; `C-x j t a *'
(define-key bmkx-jump-other-window-map "ta*"
  'bmkx-autofile-all-tags-jump-other-window)                                          ; `C-x 4 j t a *'
(define-key bmkx-jump-map              "ta+"  'bmkx-autofile-some-tags-jump)            ; `C-x j t a +'
(define-key bmkx-jump-other-window-map "ta+"
  'bmkx-autofile-some-tags-jump-other-window)                                         ; `C-x 4 j t a +'

(define-key bmkx-jump-map              "ta%*" 'bmkx-autofile-all-tags-regexp-jump)    ; `C-x j t a % *'
(define-key bmkx-jump-other-window-map "ta%*"
  'bmkx-autofile-all-tags-regexp-jump-other-window)                                 ; `C-x 4 j t a % *'
(define-key bmkx-jump-map              "ta%+" 'bmkx-autofile-some-tags-regexp-jump)   ; `C-x j t a % +'
(define-key bmkx-jump-other-window-map "ta%+"
  'bmkx-autofile-some-tags-regexp-jump-other-window)                                ; `C-x 4 j t a % +'

(define-key bmkx-jump-map              "tf*"  'bmkx-file-all-tags-jump)                 ; `C-x j t f *'
(define-key bmkx-jump-other-window-map "tf*"  'bmkx-file-all-tags-jump-other-window)  ; `C-x 4 j t f *'
(define-key bmkx-jump-map              "tf+"  'bmkx-file-some-tags-jump)                ; `C-x j t f +'
(define-key bmkx-jump-other-window-map "tf+"  'bmkx-file-some-tags-jump-other-window) ; `C-x 4 j t f +'

(define-key bmkx-jump-map              "tf%*" 'bmkx-file-all-tags-regexp-jump)        ; `C-x j t f % *'
(define-key bmkx-jump-other-window-map "tf%*"
  'bmkx-file-all-tags-regexp-jump-other-window)                                     ; `C-x 4 j t f % *'
(define-key bmkx-jump-map              "tf%+" 'bmkx-file-some-tags-regexp-jump)       ; `C-x j t f % +'
(define-key bmkx-jump-other-window-map "tf%+"
  'bmkx-file-some-tags-regexp-jump-other-window)                                    ; `C-x 4 j t f % +'

(define-key bmkx-jump-map              "t\C-f*" 'bmkx-find-file-all-tags)             ; `C-x j t C-f *'
(define-key bmkx-jump-other-window-map "t\C-f*"
  'bmkx-find-file-all-tags-other-window)                                              ; `C-x 4 j t C-f *'
(define-key bmkx-jump-map              "t\C-f+" 'bmkx-find-file-some-tags)            ; `C-x j t C-f +'
(define-key bmkx-jump-other-window-map "t\C-f+"
  'bmkx-find-file-some-tags-other-window)                                             ; `C-x 4 j t C-f +'
(define-key bmkx-jump-map              "t\C-f%*" 'bmkx-find-file-all-tags-regexp)     ; `C-x j t C-f % *'
(define-key bmkx-jump-other-window-map "t\C-f%*"
  'bmkx-find-file-all-tags-regexp-other-window)                                       ; `C-x 4 j t C-f % *'
(define-key bmkx-jump-map              "t\C-f%+"
  'bmkx-find-file-some-tags-regexp)                                                   ; `C-x j t C-f % +'
(define-key bmkx-jump-other-window-map "t\C-f%+"
  'bmkx-find-file-some-tags-regexp-other-window)                                      ; `C-x 4 j t C-f % +'

(define-key bmkx-jump-map              "u"    'bmkx-url-jump)                               ; `C-x j u'
(define-key bmkx-jump-other-window-map "u"    'bmkx-url-jump-other-window)                ; `C-x 4 j u'
(define-key bmkx-jump-map              "v"    'bmkx-variable-list-jump)                     ; `C-x j v'
(define-key bmkx-jump-map              "w"    'bmkx-w3m-jump)                               ; `C-x j w'
(define-key bmkx-jump-other-window-map "w"    'bmkx-w3m-jump-other-window)                ; `C-x 4 j w'
(define-key bmkx-jump-map              (kbd "M-w") 'bmkx-snippet-to-kill-ring)                 ; `C-x j M-w'
(define-key bmkx-jump-other-window-map (kbd "M-w") 'bmkx-snippet-to-kill-ring)     ; SAME CMD: `C-x 4 j M-w'
(define-key bmkx-jump-map              "x"    'bmkx-temporary-jump)                         ; `C-x j x'
(define-key bmkx-jump-other-window-map "x"    'bmkx-temporary-jump-other-window)          ; `C-x 4 j x'
(define-key bmkx-jump-map              "y"    'bmkx-bookmark-file-jump)                     ; `C-x j y'
(define-key bmkx-jump-map              ":"    'bmkx-jump-to-type)                           ; `C-x j :'
(define-key bmkx-jump-other-window-map ":"    'bmkx-jump-to-type-other-window)            ; `C-x 4 j :'

(defun bmkx-exists-bookmark-satisfying-p (predicate &optional alist)
  "Return t if there is a bookmark in ALIST that satisfies PREDICATE.
Else return nil.  ALIST defaults to `bookmark-alist'.
Put differently, return t iff the filtered alist is non-empty."
  (catch 'bmkx-exists-bookmark-satisfying-p
    (dolist (bmk  (or alist  bookmark-alist))
      (when (funcall predicate bmk) (throw 'bmkx-exists-bookmark-satisfying-p t)))
    nil))

(defun bmkx-exists-this-file/buffer-bookmarks-p (&optional alist)
  "Return t if there is a this-file or this-buffer bookmark in ALIST."
  (bmkx-exists-bookmark-satisfying-p (if (buffer-file-name) #'bmkx-this-file-p #'bmkx-this-buffer-p)
                                     alist))

(defvar bmkx-bookmarks-here-menu-command-entries
  (list (list 'bmkx-next-bookmark-this-file/buffer-repeat
	      'menu-item
	      "Next Bookmark Here"
	      'bmkx-next-bookmark-this-file/buffer-repeat
	      :help "Jump to the next bookmark in this buffer")
	(list 'bmkx-previous-bookmark-this-file/buffer-repeat
	      'menu-item
	      "Previous Bookmark Here"
	      'bmkx-previous-bookmark-this-file/buffer-repeat
	      :help "Jump to the previous bookmark in this buffer")
        (list 'bmkx-here-sep1 'menu-item "--")
	(list 'bmkx-annotate-bookmark-this-file/buffer
	      'menu-item
	      "Annotate a Bookmark Here"
	      'bmkx-annotate-bookmark-this-file/buffer
	      :help "Annotate a bookmark in this buffer")
	(list 'bmkx-annotate-all-bookmarks-this-file/buffer
	      'menu-item
	      "Annotate All Bookmarks Here"
	      'bmkx-annotate-all-bookmarks-this-file/buffer
	      :help "Annotate each bookmark in this buffer")
	(list 'bmkx-edit-bookmark-record-file/buffer
	      'menu-item
	      "Edit a Bookmark Record Here"
	      'bmkx-edit-bookmark-record-file/buffer
	      :help "Edit the full record (Lisp) of a bookmark in this buffer")
        (list 'bmkx-here-sep2 'menu-item "--")
        (list 'bmkx-describe-bookmark-lighted-here
              'menu-item
              "Describe Highlighted Bookmark This Line (`C-u': internal form)"
              'bmkx-describe-bookmark-lighted-here
              :help "Describe a highlighted bookmark on this line.  `C-u': internal description"
              :enable '(and (fboundp 'bmkx-describe-bookmark-lighted-here)
                            (or (bmkx-a-bookmark-lighted-at-pos (point) 'FULL)
                                (bmkx-a-bookmark-lighted-on-this-line 'FULL))))
        (list 'bmkx-bookmarks-lighted-at-point
              'menu-item
              "List Highlighted Bookmarks at Point"
              'bmkx-bookmarks-lighted-at-point
              :help "List the bookmarks at point that are highlighted"
              :enable '(bmkx-bookmarks-lighted-at-point))
	(list 'bmkx-set-lighting-for-this-buffer
	      'menu-item
	      "Set Highlighting for All Bookmarks Here"
	      'bmkx-set-lighting-for-this-buffer
	      :help "Set the `lighting' entry for all of the bookmarks for this buffer"
              :visible (featurep 'bookmark-x-lit))
	(list 'bmkx-light-this-buffer
	      'menu-item
	      "Highlight All Bookmarks Here"
	      'bmkx-light-this-buffer
	      :help "Highlight the bookmarks in this buffer"
              :keys "(C-x x H)" ; Really bound to `bmkx-light-bookmarks'
              :visible (featurep 'bookmark-x-lit))
	(list 'bmkx-unlight-this-buffer
	      'menu-item
	      "Unhighlight All Bookmarks Here"
	      'bmkx-unlight-this-buffer
	      :help "Highlight the bookmarks in this buffer"
              :keys "(C-x x U)" ; Really bound to `bmkx-unlight-bookmarks'
              :visible (featurep 'bookmark-x-lit))
	(list 'bmkx-light-autonamed-this-buffer
	      'menu-item
	      "Highlight Autonamed Bookmarks Here"
	      'bmkx-light-autonamed-this-buffer
	      :help "Highlight the autonamed bookmarks in this buffer"
              :visible (featurep 'bookmark-x-lit))
	(list 'bmkx-unlight-autonamed-this-buffer
	      'menu-item
	      "Unhighlight Autonamed Bookmarks Here"
	      'bmkx-unlight-autonamed-this-buffer
	      :help "Unhighlight the autonamed bookmarks in this buffer"
              :visible (featurep 'bookmark-x-lit))
	(list 'bmkx-light-non-autonamed-this-buffer
	      'menu-item
	      "Highlight Non-Autonamed Bookmarks Here"
	      'bmkx-light-non-autonamed-this-buffer
	      :help "Highlight the non-autonamed bookmarks in this buffer"
              :visible (featurep 'bookmark-x-lit))
	(list 'bmkx-unlight-non-autonamed-this-buffer
	      'menu-item
	      "Unhighlight Non-Autonamed Bookmarks Here"
	      'bmkx-unlight-non-autonamed-this-buffer
	      :help "Unhighlight the non-autonamed bookmarks in this buffer"
              :visible (featurep 'bookmark-x-lit))
        (list 'bmkx-here-sep3 'menu-item "--")
	(list 'bmkx-this-file/buffer-bmenu-list
	      'menu-item
	      "Show Bookmark List for Bookmarks Here"
	      'bmkx-this-file/buffer-bmenu-list
	      :help "Show the bookmark list for bookmarks in this buffer")
        (list 'bmkx-switch-to-bookmark-file-this-file/buffer
	      'menu-item
	      "Switch to Bookmark File for Bookmarks Here..."
	      'bmkx-switch-to-bookmark-file-this-file/buffer
	      :help "Switch to a bookmark file for bookmarks in this buffer")
	(list 'bmkx-save-bookmarks-this-file/buffer
	      'menu-item
	      "Save Bookmarks Here To Bookmark File..."
	      'bmkx-save-bookmarks-this-file/buffer
	      :help "Save all bookmarks defined for this file/buffer to a file"))
  "Menu entries for general commands in `Bookmarks' > `Here' menu.")

(progn
  (defvar bmkx-here-menu (make-sparse-keymap)
    "`Here' submenu for menu-bar `Bookmarks' menu.
Menu for bookmarks that target this file or buffer.")
  (define-prefix-command 'bmkx-here-menu)
  (setcdr bmkx-here-menu bmkx-bookmarks-here-menu-command-entries))

;; Add commands to other keymaps: Buffer-menu, Dired, EWW, Gnus, Info, Man, Woman, W3M.

(add-hook (if (boundp 'Buffer-menu-mode-hook) 'Buffer-menu-mode-hook 'buffer-menu-mode-hook)
          (lambda ()
            (unless (lookup-key Buffer-menu-mode-map "j")
              (define-key Buffer-menu-mode-map "j" 'bmkx-non-file-jump)) ; `j'
            (define-key Buffer-menu-mode-map [menu-bar Buffer-menu-mode here]
              `(menu-item "Bookmarks Here" bmkx-here-menu
                          :enable (and bmkx-add-bookmarks-here-menu-flag
                                       (bmkx-exists-this-file/buffer-bookmarks-p))))))

(add-hook 'dired-mode-hook
          (lambda ()
            (let ((now  (lookup-key dired-mode-map "J")))
              ;; Uppercase, since `j' is `dired-goto-file'.
              (unless (and now  (not (eq now 'undefined))) ; `dired+.el' uses `undefined'.
                (define-key dired-mode-map "J" 'bmkx-dired-jump)) ; `j'
              (setq now  (lookup-key dired-mode-map "\C-j"))
              (unless (and now  (not (eq now 'undefined))) ; `dired+.el' uses `undefined'.
                (define-key dired-mode-map (kbd "C-j") 'bmkx-dired-this-dir-jump))) ; `C-j'
            (let ((map   dired-mode-map)
                  (sep   '(menu-bar subdir separator-bmkx))
                  (bdj   '(menu-bar subdir bmkx-dired-jump))
                  (bdjc  '(menu-bar subdir bmkx-dired-this-dir-jump)))
              (cond ((boundp 'diredp-bookmark-menu) ; In `dired+el'.
                     (setq map   diredp-bookmark-menu
                           sep   (cddr sep)
                           bdj   (cddr bdj)
                           bdjc  (cddr bdjc))
                     (define-key map (apply #'vector bdjc)
                       '(menu-item "Jump to a Dired Bookmark For This Dir" bmkx-dired-this-dir-jump
                         :help "Jump to a bookmarked Dired buffer for this directory"))
                     (define-key map (apply #'vector bdj)
                       '(menu-item "Jump to a Dired Bookmark" bmkx-dired-jump
                                   :help "Jump to a bookmarked Dired buffer"))
                     (define-key map [bookmarks-here]
                       `(menu-item "Here" bmkx-here-menu
                                   :enable (and bmkx-add-bookmarks-here-menu-flag
                                                (bmkx-exists-this-file/buffer-bookmarks-p)))))
                    (t
                     (define-key map (apply #'vector sep) '("--")) ;------------------------
                     (define-key map (apply #'vector bdjc)
                       '(menu-item "Jump to a Dired Bookmark For This Dir" bmkx-dired-this-dir-jump
                         :help "Jump to a bookmarked Dired buffer for this directory"))
                     (define-key map (apply #'vector bdj)
                       '(menu-item "Jump to a Dired Bookmark" bmkx-dired-jump
                                   :help "Jump to a bookmarked Dired buffer"))
                     (define-key map [bookmarks-here]
                       `(menu-item "Here" bmkx-here-menu
                                   :enable (and bmkx-add-bookmarks-here-menu-flag
                                                (bmkx-exists-this-file/buffer-bookmarks-p)))))))))

(when (fboundp 'bmkx-eww-jump)          ; Emacs 24.4+
  (add-hook 'eww-mode-hook
            (lambda () (unless (lookup-key eww-mode-map "j")
                    (define-key eww-mode-map "j" 'bmkx-eww-jump)))))

(add-hook 'gnus-summary-mode-hook
          (lambda () (unless (lookup-key gnus-summary-mode-map "j")
                       (define-key gnus-summary-mode-map "j" 'bmkx-gnus-jump))))

(add-hook 'Info-mode-hook
          (lambda ()
            (unless (lookup-key Info-mode-map "j")
              (define-key Info-mode-map "j" 'bmkx-info-jump))
            (define-key-after Info-mode-menu [bmkx-info-jump]
              '(menu-item "Jump to an Info Bookmark" bmkx-info-jump
                          :help "Jump to a bookmarked Info node")
              'Go\ to\ Node\.\.\.) ; Used by `info(+).el' - corresponds to `Info-goto-node'.
            (define-key Info-mode-menu [bookmarks-here]
              `(menu-item "Bookmarks Here" bmkx-here-menu
                          :enable (and bmkx-add-bookmarks-here-menu-flag
                                       (bmkx-exists-this-file/buffer-bookmarks-p))))))

(add-hook 'Man-mode-hook
          (lambda () (unless (lookup-key Man-mode-map "j")
                       (define-key Man-mode-map "j" 'bmkx-man-jump))))

(add-hook 'woman-mode-hook
          (lambda ()
            (unless (lookup-key woman-mode-map "j") (define-key woman-mode-map "j" 'bmkx-man-jump))
            (when (boundp 'woman-menu)
              (define-key-after woman-menu [bmkx-man-jump]
                '(menu-item "Jump to a `man'-page Bookmark" bmkx-man-jump
                  :help "Jump to a bookmarked `man' page")
                'WoMan\.\.\.))))        ; Used by `woman.el' - corresponds to command `woman'.


;;; Vanilla Emacs `Bookmarks' menu (see also [jump] from `Bookmark-X' menu, below).

(define-key-after menu-bar-bookmark-map [separator-edit] '("--") ;-------------------------------------
                  'jump)
;; Remove this predefined item - we use `bmkx-edit-bookmark-name-and-location' instead.
(define-key menu-bar-bookmark-map [rename] nil)

(define-key-after menu-bar-bookmark-map [bmkx-clone-bookmark]
  '(menu-item "Clone (Duplicate) Bookmark" bmkx-clone-bookmark
    :help "Duplicate a bookmark.  (`\\[bmkx-edit-bookmark-record]' to edit definition.)")
  'separator-edit)
(define-key-after menu-bar-bookmark-map [bmkx-edit-annotation]
  '(menu-item "Edit Bookmark Annotation" bmkx-edit-annotation
    :help "Edit annotation for a bookmark (create if none)")
  'bmkx-clone-bookmark)
(define-key-after menu-bar-bookmark-map [bmkx-edit-bookmark-name-and-location]
  '(menu-item "Rename, Relocate Bookmark..." bmkx-edit-bookmark-name-and-location
    :help "Rename and/or relocate a bookmark")
  'bmkx-edit-annotation)
(define-key-after menu-bar-bookmark-map [bmkx-edit-bookmark-record]
  '(menu-item "Edit Bookmark Record (Lisp)..." bmkx-edit-bookmark-record
    :help "Edit the full record (Lisp sexp) of a bookmark")
  'bmkx-edit-bookmark-name-and-location)

(define-key-after menu-bar-bookmark-map [separator-show] '("--") ;-------------------------------------
                  'bmkx-edit-bookmark-record)
(define-key-after menu-bar-bookmark-map [edit]
  '(menu-item "Show Bookmark List" bmkx-list
    :help "Open the list of bookmarks in buffer `*Bmkx List*'")
  'separator-show)
(define-key-after menu-bar-bookmark-map [bmkx-this-file/buffer-bmenu-list]
  '(menu-item "Show Bookmark List for This File/Buffer" bmkx-this-file/buffer-bmenu-list
    :help "Open `*Bmkx List*' for the bookmarks in the current buffer (only)")
  'edit)
(define-key-after menu-bar-bookmark-map [bmkx-navlist-bmenu-list]
  '(menu-item "Show Bookmark List for Navlist" bmkx-navlist-bmenu-list
    :help "Open `*Bmkx List*' for bookmarks in navlist (only)")
  'bmkx-this-file/buffer-bmenu-list)

(define-key-after menu-bar-bookmark-map [separator-2] '("--") ;-------------------------------------
                  'bmkx-navlist-bmenu-list)
(define-key-after menu-bar-bookmark-map [bmkx-choose-navlist-of-type]
  '(menu-item "Set Navlist to Bookmarks of Type..." bmkx-choose-navlist-of-type
    :help "Set the navigation list to the bookmarks of a certain type")
  'separator-2)
(define-key-after menu-bar-bookmark-map [bmkx-choose-navlist-from-bookmark-list]
  '(menu-item "Set Navlist from Bookmark-List Bookmark..." bmkx-choose-navlist-from-bookmark-list
    :help "Set the navigation list from a bookmark-list bookmark")
  'bmkx-choose-navlist-of-type)
(define-key-after menu-bar-bookmark-map [bmkx-list-defuns-in-commands-file]
  '(menu-item "List User-Defined Bookmark Commands" bmkx-list-defuns-in-commands-file
    :help "List the functions defined in `bmkx-bmenu-commands-file'"
    :enable (and bmkx-bmenu-commands-file  (file-readable-p bmkx-bmenu-commands-file)))
  'bmkx-choose-navlist-from-bookmark-list)
(define-key-after menu-bar-bookmark-map [insert]
  '(menu-item "Insert Bookmark Contents..." bmkx-insert :help "Insert bookmarked text")
  'bmkx-list-defuns-in-commands-file)
(define-key-after menu-bar-bookmark-map [locate]
  '(menu-item "Insert Bookmark Location..." bookmark-locate ; Alias for `bmkx-insert-location'.
    :help "Insert a bookmark's file or buffer name")
  'insert)
(progn ; Emacs 24.4+.
  (define-key-after menu-bar-bookmark-map [bmkx-store-org-link]
    '(menu-item "Store Org Link To..." bmkx-store-org-link
      :help "Store a link to a bookmark for insertion in an Org-mode buffer")
    'locate))

(define-key-after menu-bar-bookmark-map [separator-3] '("--") ;-------------------------------------
                  'bmkx-store-org-link)
(define-key-after menu-bar-bookmark-map [save]
  '(menu-item "Save Bookmarks" bmkx-save :help "Save currently defined bookmarks")
  'separator-3)
(define-key-after menu-bar-bookmark-map [write]
  '(menu-item "Save Bookmarks As..." bookmark-write
    :help "Write current bookmarks to a bookmark file")
  'save)
(define-key-after menu-bar-bookmark-map [bmkx-switch-bookmark-file-create]
  '(menu-item "Switch to Bookmark File..." bmkx-switch-bookmark-file-create
    :help "Switch to a different bookmark file, *replacing* the current set of bookmarks")
  'write)
(define-key-after menu-bar-bookmark-map [load]
  '(menu-item "Add Bookmarks from File..." bmkx-load
    :help "Load additional bookmarks from a bookmark file")
  'bmkx-switch-bookmark-file-create)
(define-key-after menu-bar-bookmark-map [bmkx-empty-file]
  '(menu-item "Empty Bookmark File..." bmkx-empty-file
    :help "Empty an existing bookmark file or create a new, empty bookmark file")
  'load)

(define-key-after menu-bar-bookmark-map [separator-4] '("--") ;-------------------------------------
                  'bmkx-empty-file)
(define-key-after menu-bar-bookmark-map [bmkx-send-bug-report]
  '(menu-item "Send Bug Report" bmkx-send-bug-report
    :help "Send an email reporting a Bookmark-X bug")
  'separator-4)



;; `bmkx-annotate-menu' of built-in `Bookmarks' menu: `Annotate'

(defvar bmkx-annotate-menu (make-sparse-keymap)
  "`Annotate' submenu for menu-bar `Bookmarks' menu.")
(define-key menu-bar-bookmark-map [annotate] (cons "Annotate" bmkx-annotate-menu))

(define-key bmkx-annotate-menu [bmkx-show-all-annotations]
  '(menu-item "Show All Annotations" bmkx-show-all-annotations
              :help "Show the annotations for all bookmarks"))
(define-key bmkx-annotate-menu [bmkx-show-annotation]
  '(menu-item "Show an Annotation" bmkx-show-annotation
              :help "Show the annotation for a bookmark, or follow it if external"))
(define-key bmkx-annotate-menu [bmkx-annotate-all-bookmarks-this-file/buffer]
  '(menu-item "Annotate All Bookmarks Here" bmkx-annotate-all-bookmarks-this-file/buffer
              :help "Pop up an annotation-editing buffer for each bookmark in this buffer"))
(define-key bmkx-annotate-menu [bmkx-annotate-bookmark-this-file/buffer]
  '(menu-item "Annotate a Bookmark Here" bmkx-annotate-bookmark-this-file/buffer
              :help "Annotate an existing bookmark in this buffer"))
(define-key bmkx-annotate-menu [bmkx-annotate-bookmark]
  '(menu-item "Annotate a Bookmark" bmkx-annotate-bookmark
              :help "Pop up a buffer to add or edit an annotation for a bookmark"))


;; `bmkx-highlight-menu' of built-in `Bookmarks' menu: `Highlight'

(when (or (featurep 'bookmark-x-lit)
          (and (fboundp 'diredp-highlight-autofiles-mode)  (featurep 'highlight)))
  (defvar bmkx-highlight-menu (make-sparse-keymap)
    "`Highlight' submenu for menu-bar `Bookmarks' menu.")
  (define-key menu-bar-bookmark-map [highlight] (cons "Highlight" bmkx-highlight-menu))

  (when (featurep 'bookmark-x-lit)
    (define-key bmkx-highlight-menu [bmkx-unlight-bookmarks]
      '(menu-item "Unhighlight All" bmkx-unlight-bookmarks
                  :help "Unhighlight all bookmarks (everywhere)"))
    (define-key bmkx-highlight-menu [bmkx-unlight-this-buffer]
      '(menu-item "Unhighlight All in Buffer" bmkx-unlight-this-buffer
                  :help "Unhighlight all bookmarks in this buffer"))
    (define-key bmkx-highlight-menu [bmkx-unlight-non-autonamed-this-buffer]
      '(menu-item "Unhighlight All Non-Autonamed in Buffer" bmkx-unlight-non-autonamed-this-buffer
                  :help "Unhighlight all non-autonamed bookmarks in this buffer"))
    (define-key bmkx-highlight-menu [bmkx-unlight-autonamed-this-buffer]
      '(menu-item "Unhighlight All Autonamed in Buffer" bmkx-unlight-autonamed-this-buffer
                  :help "Unhighlight all autonamed bookmarks in this buffer"))
    (define-key bmkx-highlight-menu [bmkx-unlight-bookmark]
      '(menu-item "Unhighlight One..." bmkx-unlight-bookmark
                  :help "Unhighlight a bookmark"))
    (define-key bmkx-highlight-menu [bmkx-unlight-bookmark-this-buffer]
      '(menu-item "Unhighlight One in Buffer..." bmkx-unlight-bookmark-this-buffer
                  :help "Unhighlight a bookmark in this buffer"))
    (define-key bmkx-highlight-menu [bmkx-unlight-bookmark-here]
      '(menu-item "Unhighlight This One" bmkx-unlight-bookmark-here
                  :help "Unhighlight a bookmark at point or on its line"))

    (define-key bmkx-highlight-menu [separator-2] '("--")) ;------------------------------------------
    (define-key bmkx-highlight-menu [bmkx-light-bookmarks-in-region]
      '(menu-item "Highlight All in Region" bmkx-light-bookmarks-in-region
                  :help "Highlight all bookmarks in the region"))
    (define-key bmkx-highlight-menu [bmkx-light-this-buffer]
      '(menu-item "Highlight All in Buffer" bmkx-light-this-buffer
                  :help "Highlight all bookmarks in this buffer"))
    (define-key bmkx-highlight-menu [bmkx-light-non-autonamed-this-buffer]
      '(menu-item "Highlight All Non-Autonamed in Buffer" bmkx-light-non-autonamed-this-buffer
                  :help "Highlight all non-autonamed bookmarks in this buffer"))
    (define-key bmkx-highlight-menu [bmkx-light-autonamed-this-buffer]
      '(menu-item "Highlight All Autonamed in Buffer" bmkx-light-autonamed-this-buffer
                  :help "Highlight all autonamed bookmarks in this buffer"))
    (define-key bmkx-highlight-menu [bmkx-light-navlist-bookmarks]
      '(menu-item "Highlight All in Navigation List" bmkx-light-navlist-bookmarks
                  :help "Highlight all bookmarks in the navigation list"))
    (define-key bmkx-highlight-menu [bmkx-light-bookmark-this-buffer]
      '(menu-item "Highlight One in Buffer..." bmkx-light-bookmark-this-buffer
                  :help "Highlight a bookmark in this buffer"))
    (define-key bmkx-highlight-menu [bmkx-light-bookmark]
      '(menu-item "Highlight One..." bmkx-light-bookmark
                  :help "Highlight a bookmark"))

    (define-key bmkx-highlight-menu [separator-1] '("--")) ;------------------------------------------
    (define-key bmkx-highlight-menu [bmkx-describe-bookmark-lighted-here]
      '(menu-item "Describe Highlighted Here (`C-u': internal form)"
                  bmkx-describe-bookmark-lighted-here
                  :help "Describe a highlighted bookmark on this line."
                  :enable (and (fboundp 'bmkx-describe-bookmark-lighted-here)
                               (or (bmkx-a-bookmark-lighted-at-pos (point) 'FULL)
                                   (bmkx-a-bookmark-lighted-on-this-line 'FULL)))))
    (define-key bmkx-highlight-menu [bmkx-bookmarks-lighted-at-point]
      '(menu-item "List Highlighted at Point" bmkx-bookmarks-lighted-at-point
                  :help "List the bookmarks at point that are highlighted"
                  :enable (bmkx-bookmarks-lighted-at-point)))
    (define-key bmkx-highlight-menu [bmkx-next-lighted-this-buffer]
      '(menu-item "Next in Buffer" bmkx-next-lighted-this-buffer
                  :help "Cycle to the next highlighted bookmark in this buffer"))
    (define-key bmkx-highlight-menu [bmkx-previous-lighted-this-buffer]
      '(menu-item "Previous in Buffer" bmkx-previous-lighted-this-buffer
                  :help "Cycle to the previous highlighted bookmark in this buffer"))
    (define-key bmkx-highlight-menu [separator-0] '("--")) ;------------------------------------------
    )

  (define-key bmkx-highlight-menu [diredp-highlight-autofiles-mode]
    (bmkx-menu-bar-make-toggle diredp-highlight-autofiles-mode
                               diredp-highlight-autofiles-mode
                               "Toggle Autofile Highlighting in Dired"
                               "Whether to highlight autofile bookmarks in Dired us biw %s"
                               "Toggle `diredp-highlight-autofiles-mode'"
                               nil
                               :visible (and (fboundp 'diredp-highlight-autofiles-mode)
                                             (featurep 'highlight))))

  (when (featurep 'bookmark-x-lit)
    (define-key bmkx-highlight-menu [bmkx-set-lighting-for-bookmark]
      '(menu-item "Set Highlighting for One..." bmkx-set-lighting-for-bookmark
                  :help "Set individual highlighting for a bookmark"))))


;; `bmkx-here-menu' of built-in `Bookmarks' menu: `Here'

(define-key menu-bar-bookmark-map [bookmarks-here]
  `(menu-item "Here (This File/Buffer)" bmkx-here-menu
              :enable (and bmkx-add-bookmarks-here-menu-flag
                           (bmkx-exists-this-file/buffer-bookmarks-p))))


;; `bmkx-delete-menu' of built-in `Bookmarks' menu: `Delete'

(defvar bmkx-delete-menu (make-sparse-keymap)
  "`Delete' submenu for menu-bar `Bookmarks' menu.")
(define-key menu-bar-bookmark-map [delete-menu] (cons "Delete" bmkx-delete-menu))

(define-key bmkx-delete-menu [bmkx-delete-all-temporary-bookmarks]
  '(menu-item "Delete All Temporaries..." bmkx-delete-all-temporary-bookmarks
    :help "Delete the temporary bookmarks, (`X') whether visible here or not"))

;;; $$$$$$ NOTE: Here and below, the definitions with logically correct `:enable' filters are
;;;              commented out.  This is because evaluation of these filters is too slow, especially
;;;              in older Emacs versions.  If you want to try some or all of the definitions with the
;;;              `:enable' conditions, just uncomment them and comment out or remove the corresponding
;;;              definitions without such conditions.

;;;;; (define-key bmkx-delete-menu [bmkx-delete-all-autonamed-for-this-buffer]
;;;;;   '(menu-item "Delete All Autonamed Bookmarks Here..."
;;;;;     bmkx-delete-all-autonamed-for-this-buffer
;;;;;     :help "Delete all autonamed bookmarks for the current buffer"
;;;;;     :enable (mapcar #'bmkx-bookmark-name-from-record (bmkx-autonamed-this-buffer-alist-only))))
(define-key bmkx-delete-menu [bmkx-delete-all-autonamed-for-this-buffer]
  '(menu-item "Delete All Autonamed Bookmarks Here..."
    bmkx-delete-all-autonamed-for-this-buffer
    :help "Delete all autonamed bookmarks for the current buffer"))
(define-key bmkx-delete-menu [bmkx-toggle-autoname-bmkx-delete]
  '(menu-item "Delete Autonamed Bookmark" bmkx-toggle-autonamed-bmkx-set/delete
    :help "Delete the autonamed bookmark at point"
    :visible (bmkx-get-bookmark-in-alist (funcall bmkx-autoname-bookmark-function (point))
              'noerror)))
;;;;; (define-key bmkx-delete-menu [bmkx-delete-bookmarks]
;;;;;   '(menu-item "Delete Bookmarks Here..." bmkx-delete-bookmarks
;;;;;     :help "Delete some bookmarks at point or, with `C-u', all bookmarks in the buffer"
;;;;;     :enable (mapcar #'bmkx-bookmark-name-from-record (bmkx-this-buffer-alist-only))))
(define-key bmkx-delete-menu [bmkx-delete-bookmarks]
  '(menu-item "Delete Bookmarks Here..." bmkx-delete-bookmarks
    :help "Delete some bookmarks at point or, with `C-u', all bookmarks in the buffer"))
(define-key bmkx-delete-menu [delete]
  '(menu-item "Delete Bookmark..." bmkx-delete :help "Delete the bookmark you choose by name"))
(define-key bmkx-delete-menu [bmkx-purge-notags-autofiles]
  '(menu-item "Purge Autofiles with No Tags..." bmkx-purge-notags-autofiles
    :help "Delete all autofile bookmarks that have no tags"))

;; Remove built-in `bmkx-delete' entry from main `Bookmarks' menu.
(define-key menu-bar-bookmark-map [delete] nil)


;; `bmkx-set-bookmark-menu' of built-in `Bookmarks' menu: `New/Update'
(defvar bmkx-set-bookmark-menu (make-sparse-keymap)
  "`New/Update' submenu for menu-bar `Bookmarks' menu.")
(define-key menu-bar-bookmark-map [set-bookmark] (cons "New/Update" bmkx-set-bookmark-menu))

(defun bmkx-menu-bar-set-bookmark ()
  "Set a bookmark, prompting for the name."
  (interactive)
  (call-interactively #'bmkx-bookmark-set-confirm-overwrite))
  
(define-key bmkx-set-bookmark-menu [bmkx-make-function-bookmark]
  '(menu-item "Function Bookmark..." bmkx-make-function-bookmark
    :help "Create a bookmark that will invoke a function when \"jumped\" to"))
(define-key bmkx-set-bookmark-menu [bmkx-toggle-autoname-bmkx-set]
  '(menu-item "Autonamed Bookmark" bmkx-toggle-autonamed-bmkx-set/delete
    :help "Set an autonamed bookmark at point"
    :visible (not (bmkx-get-bookmark-in-alist (funcall bmkx-autoname-bookmark-function (point))
                                              'NOERROR))))
(define-key bmkx-set-bookmark-menu [bmkx-set-bookmark-file-bookmark]
  '(menu-item "Bookmark-File Bookmark..." bmkx-set-bookmark-file-bookmark
    :help "Set a bookmark that loads a bookmark file when jumped to"))
(define-key bmkx-set-bookmark-menu [bmkx-set-desktop-bookmark]
  '(menu-item "Desktop Bookmark" bmkx-set-desktop-bookmark
    :help "Save the current desktop as a bookmark"))
(define-key bmkx-set-bookmark-menu [bmkx-url-target-set]
  '(menu-item "URL Bookmark..." bmkx-url-target-set
    :help "Set a bookmark for a given URL"))
(define-key bmkx-set-bookmark-menu [bmkx-file-target-set]
  '(menu-item "File Bookmark..." bmkx-file-target-set
    :help "Set a bookmark with a given name for a given file"))
(define-key bmkx-set-bookmark-menu [bmkx-autofile-set]
  '(menu-item "Autofile Bookmark..." bmkx-autofile-set
    :help "Set and automatically name a bookmark for a given file"))
(define-key bmkx-set-bookmark-menu [bmkx-menu-bar-set-bookmark]
  '(menu-item "Ordinary Bookmark..." bmkx-menu-bar-set-bookmark
    :help "Set a bookmark at point" :keys "(C-x x m)")) ; Really bound to `bmkx-set'


;; Remove built-in `bmkx-set' from main `Bookmarks' menu.
(define-key menu-bar-bookmark-map [set] nil)


;; `bmkx-options-menu' of built-in `Bookmarks' menu: `Toggle'.  Reuse `bmkx-bmenu-toggle-menu'.
(define-key menu-bar-bookmark-map [options] (cons "Toggle" bmkx-bmenu-toggle-menu))


;; `bmkx-tags-menu' of built-in `Bookmarks' menu: `Tags'

(defvar bmkx-tags-menu (make-sparse-keymap)
  "`Tags' submenu for menu-bar `Bookmarks' menu.")
(define-key menu-bar-bookmark-map [tags] (cons "Tags" bmkx-tags-menu))

(define-key bmkx-tags-menu [bmkx-list-all-tags]
  '(menu-item "List All Tags" bmkx-list-all-tags :help "List all tags used for any bookmarks"))
(define-key bmkx-tags-menu [bmkx-purge-notags-autofiles]
  '(menu-item "Purge Autofiles with No Tags..." bmkx-purge-notags-autofiles
    :help "Delete all autofile bookmarks that have no tags"))
(define-key bmkx-tags-menu [bmkx-untag-a-file]
  '(menu-item "Untag a File (Remove Some)..." bmkx-untag-a-file
    :help "Remove some tags from autofile bookmark for a file"))
(define-key bmkx-tags-menu [bmkx-tag-a-file]
  '(menu-item "Tag a File (Add Some)..." bmkx-tag-a-file
    :help "Add some tags to the autofile bookmark for a file"))

(define-key bmkx-tags-menu [tags-sep1] '("--")) ;----------------------------------------------
(define-key bmkx-tags-menu [bmkx-rename-tag]
  '(menu-item "Rename Tag..." bmkx-rename-tag :help "Rename a tag in all bookmarks"))
(define-key bmkx-tags-menu [bmkx-set-tag-value]
  '(menu-item "Set Tag Value..." bmkx-set-tag-value :help "Set the tag value for a given bookmark"))
(define-key bmkx-tags-menu [bmkx-remove-tags-from-all]
  '(menu-item "Remove Some Tags from All..." bmkx-remove-tags-from-all
    :help "Remove a set of tags from all bookmarks"))
(define-key bmkx-tags-menu [bmkx-remove-tags]
  '(menu-item "Remove Some Tags..." bmkx-remove-tags :help "Remove a set of tags from a bookmark"))
(define-key bmkx-tags-menu [bmkx-add-tags]
  '(menu-item "Add Some Tags..." bmkx-add-tags :help "Add a set of tags to a bookmark"))
(define-key bmkx-tags-menu [bmkx-paste-replace-tags]
  '(menu-item "Paste Tags (Replace)..." bmkx-paste-replace-tags
    :help "Replace tags for a bookmark with tags copied from another"))
(define-key bmkx-tags-menu [bmkx-paste-add-tags]
  '(menu-item "Paste Tags (Add)..." bmkx-paste-add-tags
    :help "Add tags to a bookmark that were previously copied from another"))
(define-key bmkx-tags-menu [bmkx-copy-tags]
  '(menu-item "Copy Tags..." bmkx-copy-tags
    :help "Copy the tags from a bookmark, so you can paste them to another"))
(define-key bmkx-tags-menu [bmkx-edit-tags]
  '(menu-item "Edit Tags..." bmkx-edit-tags :help "Edit the tags of a bookmark"))


;; `bmkx-jump-menu' of built-in `Bookmarks' menu: `Jump To'

(defvar bmkx-jump-menu (make-sparse-keymap)
  "`Jump To' submenu for menu-bar `Bookmarks' menu.")
;; Add jump menu to built-in Emacs `Bookmarks' menu and remove the two jump commands already there.
(define-key menu-bar-bookmark-map [jump] nil)
(define-key menu-bar-bookmark-map [jump-other] nil)
(define-key menu-bar-bookmark-map [bmkx-jump] (cons "Jump To" bmkx-jump-menu))

;; `Jump To': Add jump menu also to the `Bookmark-X' menu, and remove the two jump commands there.
(define-key bmkx-bmenu-menubar-menu [jump] (cons "Jump To" bmkx-jump-menu))

(define-key bmkx-jump-menu [bmkx-temporary-jump-other-window]
  '(menu-item "Temporary..." bmkx-temporary-jump-other-window
    :help "Jump to a temporary bookmark"))
(define-key bmkx-jump-menu [bmkx-autofile-jump-other-window]
  '(menu-item "Autofile..." bmkx-autofile-jump-other-window
    :help "Jump to an autofile bookmark"))
(define-key bmkx-jump-menu [bmkx-autonamed-this-buffer-jump]
  '(menu-item "Autonamed for This Buffer..." bmkx-autonamed-this-buffer-jump
    :help "Jump to an autonamed bookmark in this buffer"))
(define-key bmkx-jump-menu [bmkx-autonamed-jump-other-window]
  '(menu-item "Autonamed..." bmkx-autonamed-jump-other-window
    :help "Jump to an autonamed bookmark"))
(define-key bmkx-jump-menu [bmkx-specific-files-jump-other-window]
  '(menu-item "For Specific Files..." bmkx-specific-files-jump-other-window
    :help "Jump to a bookmark for specific files"))
(define-key bmkx-jump-menu [bmkx-specific-buffers-jump-other-window]
  '(menu-item "For Specific Buffers..." bmkx-specific-buffers-jump-other-window
    :help "Jump to a bookmark for specific buffers"))
;;;;; (define-key bmkx-jump-menu [bmkx-this-buffer-jump]
;;;;;   '(menu-item "For This Buffer..." bmkx-this-buffer-jump
;;;;;     :help "Jump to a bookmark for the current buffer"
;;;;;     :enable (mapcar #'bmkx-bookmark-name-from-record (bmkx-this-buffer-alist-only))))
(define-key bmkx-jump-menu [bmkx-this-buffer-jump]
  '(menu-item "For This Buffer..." bmkx-this-buffer-jump
    :help "Jump to a bookmark for the current buffer"))
;;;;; (when (featurep 'bookmark-x-lit)
;;;;;   (define-key bmkx-jump-menu [bmkx-lighted-jump-other-window]
;;;;;     '(menu-item "Highlighted..." bmkx-lighted-jump-other-window
;;;;;       :help "Jump to a highlighted bookmark"
;;;;;       :enable (bmkx-lighted-alist-only))))
(when (featurep 'bookmark-x-lit)
  (define-key bmkx-jump-menu [bmkx-lighted-jump-other-window]
    '(menu-item "Highlighted..." bmkx-lighted-jump-other-window
      :help "Jump to a highlighted bookmark")))
(define-key bmkx-jump-menu [bmkx-jump-in-navlist-other-window]
  '(menu-item "In Navigation List..." bmkx-jump-in-navlist-other-window
    :help "Jump to a bookmark that is in the navigation list" :enable bmkx-nav-alist))

(define-key bmkx-jump-menu [jump-sep0] '("--")) ;---------------------------------------------------
;;;;; (define-key bmkx-jump-menu [bmkx-url-jump-other-window]
;;;;;   '(menu-item "URL..." bmkx-url-jump-other-window :help "Jump to a URL bookmark"
;;;;;     :enable (bmkx-url-alist-only)))
(define-key bmkx-jump-menu [bmkx-url-jump-other-window]
  '(menu-item "URL..." bmkx-url-jump-other-window :help "Jump to a URL bookmark"))
;;;;; (define-key bmkx-jump-menu [bmkx-gnus-jump-other-window]
;;;;;   '(menu-item "Gnus..." bmkx-gnus-jump-other-window :help "Jump to a Gnus bookmark"
;;;;;     :enable (bmkx-gnus-alist-only)))
(define-key bmkx-jump-menu [bmkx-gnus-jump-other-window]
  '(menu-item "Gnus..." bmkx-gnus-jump-other-window :help "Jump to a Gnus bookmark"))
;;;;; (define-key bmkx-jump-menu [bmkx-man-jump-other-window]
;;;;;   '(menu-item "Man Page..." bmkx-man-jump-other-window :help "Jump to a `man'-page bookmark"
;;;;;     :enable (bmkx-man-alist-only)))
(define-key bmkx-jump-menu [bmkx-man-jump-other-window]
  '(menu-item "Man Page..." bmkx-man-jump-other-window :help "Jump to a `man'-page bookmark"))
;;;;; (define-key bmkx-jump-menu [bmkx-info-jump-other-window]
;;;;;   '(menu-item "Info Node..." bmkx-info-jump-other-window :help "Jump to an Info bookmark"
;;;;;     :enable (bmkx-info-alist-only)))
(define-key bmkx-jump-menu [bmkx-info-jump-other-window]
  '(menu-item "Info Node..." bmkx-info-jump-other-window :help "Jump to an Info bookmark"))
;;;;; (define-key bmkx-jump-menu [bmkx-image-jump-other-window]
;;;;;   '(menu-item "Image..." bmkx-image-jump-other-window :help "Jump to an image-file bookmark"
;;;;;     :enable (bmkx-image-alist-only)))
(define-key bmkx-jump-menu [bmkx-image-jump-other-window]
  '(menu-item "Image..." bmkx-image-jump-other-window :help "Jump to an image-file bookmark"))
;;;;; (define-key bmkx-jump-menu [bmkx-non-file-jump-other-window]
;;;;;   '(menu-item "Buffer (Non-File)..." bmkx-non-file-jump-other-window
;;;;;     :help "Jump to a non-file (buffer) bookmark" :enable (bmkx-non-file-alist-only)))
(define-key bmkx-jump-menu [bmkx-non-file-jump-other-window]
  '(menu-item "Buffer (Non-File)..." bmkx-non-file-jump-other-window
    :help "Jump to a non-file (buffer) bookmark"))
;;;;; (define-key bmkx-jump-menu [bmkx-region-jump-other-window]
;;;;;   '(menu-item "Region..." bmkx-region-jump-other-window
;;;;;     :help "Jump to a bookmark that defines the active region" :enable (bmkx-region-alist-only)))
(define-key bmkx-jump-menu [bmkx-region-jump-other-window]
  '(menu-item "Region..." bmkx-region-jump-other-window
    :help "Jump to a bookmark that defines the active region"))
;;;;; (define-key bmkx-jump-menu [bmkx-remote-file-jump-other-window]
;;;;;   '(menu-item "Remote File..." bmkx-remote-file-jump-other-window
;;;;;     :help "Jump to a remote file or directory bookmark" :enable (bmkx-remote-file-alist-only)))
(define-key bmkx-jump-menu [bmkx-remote-file-jump-other-window]
  '(menu-item "Remote File..." bmkx-remote-file-jump-other-window
    :help "Jump to a remote file or directory bookmark"))
;;;;; (define-key bmkx-jump-menu [bmkx-local-file-jump-other-window]
;;;;;   '(menu-item "Local File..." bmkx-local-file-jump-other-window
;;;;;     :help "Jump to a local file or directory bookmark" :enable (bmkx-local-file-alist-only)))
(define-key bmkx-jump-menu [bmkx-local-file-jump-other-window]
  '(menu-item "Local File..." bmkx-local-file-jump-other-window
    :help "Jump to a local file or directory bookmark"))
;;;;; (define-key bmkx-jump-menu [bmkx-file-this-dir-jump-other-window]
;;;;;   '(menu-item "File in This Dir..." bmkx-file-this-dir-jump-other-window
;;;;;     :help "Jump to a bookmark for a file or subdirectory in the `default-directory'."
;;;;;     :enable (bmkx-file-alist-only)))
(define-key bmkx-jump-menu [bmkx-file-this-dir-jump-other-window]
  '(menu-item "File in This Dir..." bmkx-file-this-dir-jump-other-window
    :help "Jump to a bookmark for a file or subdirectory in the `default-directory'."))
;;;;; (define-key bmkx-jump-menu [bmkx-file-jump-other-window]
;;;;;   '(menu-item "File..." bmkx-file-jump-other-window :help "Jump to a file or directory bookmark"
;;;;;     :enable (bmkx-file-alist-only)))
(define-key bmkx-jump-menu [bmkx-file-jump-other-window]
  '(menu-item "File..." bmkx-file-jump-other-window :help "Jump to a file or directory bookmark"))
;;;;; (define-key bmkx-jump-menu [bmkx-dired-this-dir-jump-other-window]
;;;;;   '(menu-item "Dired for This Dir..." bmkx-dired-this-dir-jump-other-window
;;;;;     :help "Jump to a Dired bookmark for `default-directory', restoring recorded state"
;;;;;     :enable (bmkx-dired-alist-only)))
(define-key bmkx-jump-menu [bmkx-dired-this-dir-jump-other-window]
  '(menu-item "Dired for This Dir..." bmkx-dired-this-dir-jump-other-window
    :help "Jump to a Dired bookmark for `default-directory', restoring recorded state"))
;;;;; (define-key bmkx-jump-menu [bmkx-dired-jump-other-window]
;;;;;   '(menu-item "Dired..." bmkx-dired-jump-other-window
;;;;;     :help "Jump to a Dired bookmark, restoring the recorded Dired state"
;;;;;     :enable (bmkx-dired-alist-only)))
(define-key bmkx-jump-menu [bmkx-dired-jump-other-window]
  '(menu-item "Dired..." bmkx-dired-jump-other-window
    :help "Jump to a Dired bookmark, restoring the recorded Dired state"))
;;;;; (define-key bmkx-jump-menu [bmkx-variable-list-jump]
;;;;;   '(menu-item "Variable List..." bmkx-variable-list-jump :help "Jump to a variable-list bookmark"
;;;;;     :enable (bmkx-variable-list-alist-only)))
(define-key bmkx-jump-menu [bmkx-variable-list-jump]
  '(menu-item "Variable List..." bmkx-variable-list-jump :help "Jump to a variable-list bookmark"))
;;;;; (define-key bmkx-jump-menu [bmkx-bookmark-file-jump]
;;;;;   '(menu-item "Bookmark File..." bmkx-bookmark-file-jump
;;;;;     :help "Jump to (load) a bookmark-file bookmark" :enable (bmkx-bookmark-file-alist-only)))
(define-key bmkx-jump-menu [bmkx-bookmark-file-jump]
  '(menu-item "Bookmark File..." bmkx-bookmark-file-jump
    :help "Jump to (load) a bookmark-file bookmark"))
;;;;; (define-key bmkx-jump-menu [bmkx-bookmark-list-jump]
;;;;;   '(menu-item "Bookmark List..." bmkx-bookmark-list-jump :help "Jump to a bookmark-list bookmark"
;;;;;     :enable (bmkx-bookmark-list-alist-only)))
(define-key bmkx-jump-menu [bmkx-bookmark-list-jump]
  '(menu-item "Bookmark List..." bmkx-bookmark-list-jump :help "Jump to a bookmark-list bookmark"))
;;;;; (define-key bmkx-jump-menu [bmkx-desktop-jump]
;;;;;   '(menu-item "Desktop..." bmkx-desktop-jump :help "Jump to a desktop bookmark"
;;;;;     :enable (bmkx-desktop-alist-only)))
(define-key bmkx-jump-menu [bmkx-desktop-jump]
  '(menu-item "Desktop..." bmkx-desktop-jump :help "Jump to a desktop bookmark"))
(define-key bmkx-jump-menu [bmkx-jump-to-type-other-window]
  '(menu-item "Of Type..." bmkx-jump-to-type-other-window
    :help "Jump to a bookmark of a type that you specify"))

(define-key bmkx-jump-menu [bmkx-jump-other-window]
  '(menu-item "Any in Other Window..." bmkx-jump-other-window
    :help "Jump to a bookmark of any type, in another window"))
(define-key bmkx-jump-menu [bmkx-jump]
  '(menu-item "Any..." bmkx-jump :help "Jump to a bookmark of any type, in this window"))

(define-key bmkx-jump-menu [bmkx-bmenu-jump-to-marked]
  '(menu-item "Marked" bmkx-bmenu-jump-to-marked
    :help "Jump to each bookmark marked `>', in another window"
    :enable (and bmkx-bmenu-marked-bookmarks  (equal (buffer-name (current-buffer))
                                               bmkx-bmenu-buffer))))


;; `bmkx-jump-tags-menu' of built-in `Bookmarks' menu: `Jump To' > `With Tags'

(defvar bmkx-jump-tags-menu (make-sparse-keymap)
  "`With Tags' submenu for `Jump To' submenu of `Bookmarks' menu.")
(define-key bmkx-jump-menu [bmkx-tags] (cons "With Tags" bmkx-jump-tags-menu))
(define-key bmkx-jump-tags-menu [bmkx-file-this-dir-all-tags-regexp-jump-other-window]
  '(menu-item "File in This Dir, All Tags Matching Regexp..."
    bmkx-file-this-dir-all-tags-regexp-jump-other-window
    :help "Jump to a file bookmark in this dir where each tag matches a regexp"))
(define-key bmkx-jump-tags-menu [bmkx-file-this-dir-some-tags-regexp-jump-other-window]
  '(menu-item "File in This Dir, Any Tag Matching Regexp..."
    bmkx-file-this-dir-some-tags-regexp-jump-other-window
    :help "Jump to a file bookmark in this dir where at least one tag matches a regexp"))
(define-key bmkx-jump-tags-menu [bmkx-file-this-dir-all-tags-jump-other-window]
  '(menu-item "File in This Dir, All Tags in Set..." bmkx-file-this-dir-all-tags-jump-other-window
    :help "Jump to a file bookmark in this dir that has all of a set of tags that you enter"))
(define-key bmkx-jump-tags-menu [bmkx-file-this-dir-some-tags-jump-other-window]
  '(menu-item "File in This Dir, Any Tag in Set..." bmkx-file-this-dir-some-tags-jump-other-window
    :help "Jump to a file bookmark in this dir that has some of a set of tags that you enter"))

(define-key bmkx-jump-tags-menu [jump-sep5] '("--")) ;----------------------------------------------
(define-key bmkx-jump-tags-menu [bmkx-file-all-tags-regexp-jump-other-window]
  '(menu-item "File, All Tags Matching Regexp..." bmkx-file-all-tags-regexp-jump-other-window
    :help "Jump to a file or dir bookmark where each tag matches a regexp that you enter"))
(define-key bmkx-jump-tags-menu [bmkx-file-some-tags-regexp-jump-other-window]
  '(menu-item "File, Any Tag Matching Regexp..." bmkx-file-some-tags-regexp-jump-other-window
    :help "Jump to a file or dir bookmark where at least one tag matches a regexp that you enter"))
(define-key bmkx-jump-tags-menu [bmkx-file-all-tags-jump-other-window]
  '(menu-item "File, All Tags in Set..." bmkx-file-all-tags-jump-other-window
    :help "Jump to a file or dir bookmark that has all of a set of tags that you enter"))
(define-key bmkx-jump-tags-menu [bmkx-file-some-tags-jump-other-window]
  '(menu-item "File, Any Tag in Set..." bmkx-file-some-tags-jump-other-window
    :help "Jump to a file or dir bookmark that has some of a set of tags that you enter"))

(define-key bmkx-jump-tags-menu [jump-sep4] '("--")) ;----------------------------------------------
(define-key bmkx-jump-tags-menu [bmkx-autofile-all-tags-regexp-jump-other-window]
  '(menu-item "Autofile, All Tags Matching Regexp..."
    bmkx-autofile-all-tags-regexp-jump-other-window
    :help "Jump to an autofile bookmark where each tag matches a regexp that you enter"))
(define-key bmkx-jump-tags-menu [bmkx-autofile-some-tags-regexp-jump-other-window]
  '(menu-item "Autofile, Any Tag Matching Regexp..."
    bmkx-autofile-some-tags-regexp-jump-other-window
    :help "Jump to an autofile bookmark where at least one tag matches a regexp that you enter"))
(define-key bmkx-jump-tags-menu [bmkx-autofile-all-tags-jump-other-window]
  '(menu-item "Autofile, All Tags in Set..."
    bmkx-autofile-all-tags-jump-other-window
    :help "Jump to an autofile bookmark that has all of a set of tags that you enter"))
(define-key bmkx-jump-tags-menu [bmkx-autofile-some-tags-jump-other-window]
  '(menu-item "Autofile, Any Tag in Set..." bmkx-autofile-some-tags-jump-other-window
    :help "Jump to an autofile bookmark that has some of a set of tags that you enter"))

(when (fboundp 'bmkx-find-file-all-tags) ; Emacs 21+
  (define-key bmkx-jump-tags-menu [jump-sep3] '("--")) ;----------------------------------------------
  (define-key bmkx-jump-tags-menu [bmkx-find-file-all-tags-regexp-other-window]
    '(menu-item "Find Autofile, All Tags Matching Regexp..."
      bmkx-find-file-all-tags-regexp-other-window
      :help "Visit a bookmarked file where each tag matches a regexp that you enter"))
  (define-key bmkx-jump-tags-menu [bmkx-find-file-some-tags-regexp-other-window]
    '(menu-item "Find Autofile, Any Tag Matching Regexp..."
      bmkx-find-file-some-tags-regexp-other-window
      :help "Visit a bookmarked file where at least one tag matches a regexp that you enter"))
  (define-key bmkx-jump-tags-menu [bmkx-find-file-all-tags-other-window]
    '(menu-item "Find Autofile, All Tags in Set..."
      bmkx-find-file-all-tags-other-window
      :help "Visit a bookmarked file that has all of a set of tags that you enter"))
  (define-key bmkx-jump-tags-menu [bmkx-find-file-some-tags-other-window]
    '(menu-item "Find Autofile, Any Tag in Set..." bmkx-find-file-some-tags-other-window
      :help "Visit a bookmarked file that has some of a set of tags that you enter")))

(define-key bmkx-jump-tags-menu [jump-sep2] '("--")) ;----------------------------------------------
(define-key bmkx-jump-tags-menu [bmkx-all-tags-regexp-jump-other-window]
  '(menu-item "All Tags Matching Regexp..." bmkx-all-tags-regexp-jump-other-window
    :help "Jump to a bookmark that has each tag matching a regexp that you enter"))
(define-key bmkx-jump-tags-menu [bmkx-some-tags-regexp-jump-other-window]
  '(menu-item "Any Tag Matching Regexp..." bmkx-some-tags-regexp-jump-other-window
    :help "Jump to a bookmark that has at least one tag matching a regexp that you enter"))
(define-key bmkx-jump-tags-menu [bmkx-all-tags-jump-other-window]
  '(menu-item "All Tags in Set..." bmkx-all-tags-jump-other-window
    :help "Jump to a bookmark whose tags are all contained in a set you enter"))
(define-key bmkx-jump-tags-menu [bmkx-tag-jump-other-window]
  '(menu-item "Carrying Every Tag..." bmkx-tag-jump-other-window
    :help "Jump to a bookmark that has every tag in a set you enter"))
(define-key bmkx-jump-tags-menu [bmkx-some-tags-jump-other-window]
  '(menu-item "Any Tag in Set..." bmkx-some-tags-jump-other-window
    :help "Jump to a bookmark that has at least one tag in a set you enter"))


;; `File' > `Find File or Autofile' submenu
;; or, for Emacs 20-21, single item `File' > `Find File or Autofile...'.
(if (not (fboundp 'bmkx-find-file-all-tags))
    (define-key menu-bar-file-menu [bmkx-find-file-other-window] ; Emacs 20-21
      '(menu-item "Find File or Autofile..." bmkx-find-file-other-window))
  (defvar bmkx-find-file-menu (make-sparse-keymap)
    "`Find File or Autofile' submenu for menu-bar `File' menu.")
  (define-key menu-bar-file-menu [bmkx-find-file-menu]
    (list 'menu-item "Find File or Autofile" bmkx-find-file-menu))
  (define-key bmkx-find-file-menu [bmkx-find-file-all-tags-regexp-other-window]
    '(menu-item "All Tags Matching Regexp..." bmkx-find-file-all-tags-regexp-other-window
      :help "Visit a file or dir where each tag matches a regexp that you enter"))
  (define-key bmkx-find-file-menu [bmkx-find-file-some-tags-regexp-other-window]
    '(menu-item "Any Tag Matching Regexp..." bmkx-find-file-some-tags-regexp-other-window
      :help "Jump to a file or dir bookmark where at least one tag matches a regexp that you enter"))
  (define-key bmkx-find-file-menu [bmkx-find-file-all-tags-other-window]
    '(menu-item "All Tags in Set..." bmkx-find-file-all-tags-other-window
      :help "Visit a file or dir that has all of a set of tags that you enter"))
  (define-key bmkx-find-file-menu [bmkx-find-file-some-tags-other-window]
    '(menu-item "Any Tag in Set..." bmkx-find-file-some-tags-other-window
      :help "Visit a file or dir that has some of a set of tags that you enter"))
  (define-key bmkx-find-file-menu [find-file-sep2] '("--")) ;---------
  (define-key bmkx-find-file-menu [bmkx-find-file-other-window]
    '(menu-item "Any File or Autofile..." bmkx-find-file-other-window
      :help "Visit a bookmarked file or directory: an autofile bookmark.")))

;;;;;;;;;;;;;;;;;;;;;

(provide 'bookmark-x-key)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; bookmark-x-key.el ends here
