;;; casual-bmkx.el --- Casual Transient menus for Bookmark-X   -*- lexical-binding:t -*-
;;
;; Filename:    casual-bmkx.el
;; Description: Optional Casual-style Transient menu for the `*Bmkx List*' buffer.
;;              Part of Bookmark-X.
;;
;; Author:     Daniel M. German
;; Maintainer: Daniel M. German <dmg@turingmachine.org>
;;
;; Copyright (C) 2026, Daniel M. German, all rights reserved.
;;
;; Created: Mon Jun  1 11:46:29 2026 (-0700)
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
;; A discoverable Transient-based UI for the `*Bmkx List*' buffer, in
;; the style of the Casual suite (casual-info, casual-dired, ...).
;;
;; Hard-requires `casual-lib' so that its styling helpers and Unicode
;; symbols are available; the parent `bookmark-x.el' loads this file
;; with a soft require, so if `casual-lib' is not installed the menu
;; simply does not appear and Bookmark-X runs unchanged.
;;
;; Activation:
;;
;;   When loaded, this file binds `casual-bmkx-tmenu' to `c' in
;;   `bmkx-list-mode-map'.  (Casual's own ecosystem uses `C-o' as the
;;   entry-point key, but in `bmkx-list-mode' `C-o' is already taken
;;   by `bmkx-list-switch-other-window' and `c' is otherwise free.)
;;
;; Commands are organised by intent: move, mark/unmark, delete,
;; filter/show, sort, edit, files, preview, help.  Sort, Tags, and
;; Type-filter live in their own submenus.
;;
;; The menu is persistent: every command keeps the menu open.  Users
;; dismiss it explicitly with `q' (one level up) or `Q' (close all).
;; The exception is `X' in the main menu, which kills *Bmkx List*
;; itself -- the menu has nothing to overlay afterward.

;;; Code:

(require 'transient)
(require 'casual-lib)
(require 'bookmark)

;; Forward decls — bookmark-x-bmu / bookmark-x-1 / bookmark-x-preview define these.
(declare-function bmkx-list-mark                                 "bookmark-x-bmu")
(declare-function bmkx-list-unmark                               "bookmark-x-bmu")
(declare-function bmkx-list-this-window                          "bookmark-x-bmu")
(declare-function bmkx-list-other-window                         "bookmark-x-bmu")
(declare-function bmkx-list-switch-other-window                  "bookmark-x-bmu")
(declare-function bmkx-list-execute-deletions                    "bookmark-x-bmu")
(declare-function bmkx-bmenu-edit-bookmark-name-and-location     "bookmark-x-bmu")
(declare-function bmkx-list-show-annotation                      "bookmark-x-bmu")
(declare-function bmkx-list-toggle-filenames                     "bookmark-x-bmu")
(declare-function bmkx-bmenu-cycle-filename-style                "bookmark-x-bmu")
(declare-function bmkx-bmenu-set-filename-style                  "bookmark-x-bmu")
(declare-function bmkx-bmenu-toggle-tags-column                  "bookmark-x-bmu")
(declare-function bmkx-bmenu-set-tags-column-width               "bookmark-x-bmu")
(declare-function bmkx-bmenu-set-name-column-width               "bookmark-x-bmu")
(defvar bmkx-bmenu-filename-style)
(defvar bmkx-bmenu-show-tags-flag)
(defvar bmkx-bmenu-tags-column-width)
(declare-function bmkx-list-preview-mode                         "bookmark-x-preview")
(declare-function bmkx-bmenu-flag-for-deletion                   "bookmark-x-bmu")
(declare-function bmkx-bmenu-delete-marked                       "bookmark-x-bmu")
(declare-function bmkx-bmenu-refresh-menu-list                   "bookmark-x-bmu")
(declare-function bmkx-bmenu-mark-all                            "bookmark-x-bmu")
(declare-function bmkx-bmenu-unmark-all                          "bookmark-x-bmu")
(declare-function bmkx-bmenu-toggle-marks                        "bookmark-x-bmu")
(declare-function bmkx-bmenu-show-all                            "bookmark-x-bmu")
(declare-function bmkx-bmenu-toggle-show-only-marked             "bookmark-x-bmu")
(declare-function bmkx-bmenu-toggle-show-only-unmarked           "bookmark-x-bmu")
(declare-function bmkx-bmenu-regexp-mark                         "bookmark-x-bmu")
(declare-function bmkx-bmenu-edit-bookmark-record                "bookmark-x-bmu")
(declare-function bmkx-bmenu-edit-marked                         "bookmark-x-bmu")
(declare-function bmkx-bmenu-quit                                "bookmark-x-bmu")
(declare-function bmkx-bmenu-describe-this-bookmark              "bookmark-x-bmu")
(declare-function bmkx-bmenu-describe-marked                     "bookmark-x-bmu")
(declare-function bmkx-bmenu-change-sort-order-repeat            "bookmark-x-bmu")
(declare-function bmkx-reverse-sort-order                        "bookmark-x-bmu")
(declare-function bmkx-bmenu-sort-by-bookmark-name               "bookmark-x-bmu")
(declare-function bmkx-bmenu-sort-by-last-bookmark-access        "bookmark-x-bmu")
(declare-function bmkx-bmenu-sort-by-last-buffer-or-file-access  "bookmark-x-bmu")
(declare-function bmkx-bmenu-sort-by-bookmark-type               "bookmark-x-bmu")
(declare-function bmkx-bmenu-sort-by-file-name                   "bookmark-x-bmu")
(declare-function bmkx-bmenu-sort-by-creation-time               "bookmark-x-bmu")
(declare-function bmkx-bmenu-sort-annotated-before-unannotated   "bookmark-x-bmu")
(declare-function bmkx-bmenu-sort-flagged-before-unflagged       "bookmark-x-bmu")
(declare-function bmkx-bmenu-sort-marked-before-unmarked         "bookmark-x-bmu")
(declare-function bmkx-save                                      "bookmark-x-1")
(declare-function bmkx-load                                      "bookmark-x-1")
(declare-function bmkx-switch-bookmark-file-create               "bookmark-x-1")
(declare-function bmkx-bmenu-edit-annotation                     "bookmark-x-bmu")
(declare-function bmkx-rename-tag                                "bookmark-x-1")
(declare-function bmkx-list-all-tags                             "bookmark-x-1")
(declare-function bmkx-bmenu-add-tags                            "bookmark-x-bmu")
(declare-function bmkx-bmenu-remove-tags                         "bookmark-x-bmu")
(declare-function bmkx-bmenu-remove-all-tags                     "bookmark-x-bmu")
(declare-function bmkx-bmenu-set-tag-value                       "bookmark-x-bmu")
(declare-function bmkx-bmenu-add-tags-to-marked                  "bookmark-x-bmu")
(declare-function bmkx-bmenu-remove-tags-from-marked             "bookmark-x-bmu")
(declare-function bmkx-bmenu-list-tags-of-marked                 "bookmark-x-bmu")
(declare-function bmkx-bmenu-mark-bookmarks-tagged-all           "bookmark-x-bmu")
(declare-function bmkx-bmenu-mark-bookmarks-tagged-some          "bookmark-x-bmu")
(declare-function bmkx-bmenu-mark-bookmarks-tagged-regexp        "bookmark-x-bmu")
(declare-function bmkx-bmenu-show-only-tagged-bookmarks          "bookmark-x-bmu")
(declare-function bmkx-bmenu-show-only-untagged-bookmarks        "bookmark-x-bmu")
(declare-function bmkx-bmenu-sort-tagged-before-untagged         "bookmark-x-bmu")


;; Every command in the submenus uses `:transient t' so the menu
;; stays open after each invocation -- it only closes on explicit
;; `q' (one level up) or `Q' (quit all).  Submenu openers in the
;; main menu use the same default; transient walks back to the
;; parent prefix on `transient-quit-one'.

;;; Tags submenu --------------------------------------------------------

(transient-define-prefix casual-bmkx-tags-tmenu ()
  "Tag commands for the bookmark on this line, or for marked bookmarks."
  [["This bookmark"
    ("+" "Add tags"            bmkx-bmenu-add-tags                      :transient t)
    ("-" "Remove tags"         bmkx-bmenu-remove-tags                   :transient t)
    ("0" "Remove all tags"     bmkx-bmenu-remove-all-tags               :transient t)
    ("e" "Edit tags"           bmkx-bmenu-edit-tags                     :transient t)
    ("v" "Set tag value"       bmkx-bmenu-set-tag-value                 :transient t)]
   ["Marked"
    ("M-+" "Add tags"          bmkx-bmenu-add-tags-to-marked            :transient t)
    ("M--" "Remove tags"       bmkx-bmenu-remove-tags-from-marked       :transient t)
    ("M-l" "List union of tags" bmkx-bmenu-list-tags-of-marked          :transient t)]
   ["Mark by tag"
    ("m*"  "All given tags"    bmkx-bmenu-mark-bookmarks-tagged-all     :transient t)
    ("m+"  "Some given tags"   bmkx-bmenu-mark-bookmarks-tagged-some    :transient t)
    ("m%"  "Tag matches regex" bmkx-bmenu-mark-bookmarks-tagged-regexp  :transient t)]]

  [["Show / sort"
    ("S" "Only tagged"         bmkx-bmenu-show-only-tagged-bookmarks    :transient t)
    ("U" "Only untagged"       bmkx-bmenu-show-only-untagged-bookmarks  :transient t)
    ("." "Show all"            bmkx-bmenu-show-all                      :transient t)
    ("s" "Sort: tagged first"  bmkx-bmenu-sort-tagged-before-untagged   :transient t)]
   ["Display"
    ("M-T" "Tags column..."    bmkx-bmenu-toggle-tags-column
     :description casual-bmkx--tags-column-label                        :transient t)
    ("w"   "Set tags width"    bmkx-bmenu-set-tags-column-width         :transient t)
    ("W"   "Set name width"    bmkx-bmenu-set-name-column-width         :transient t)]
   ["Global"
    ("l" "List all tags"       bmkx-list-all-tags                       :transient t)
    ("r" "Rename tag"          bmkx-rename-tag                          :transient t)]
   ["Exit"
    ("q" "Back"                transient-quit-one)
    ("Q" "Quit menu"           transient-quit-all)]])


;;; Type-filter submenu ------------------------------------------------

(transient-define-prefix casual-bmkx-type-filter-tmenu ()
  "Show only bookmarks of one type in `*Bmkx List*'."
  [["Locations"
    ("f" "File / directory"     bmkx-bmenu-show-only-file-bookmarks      :transient t)
    ("r" "Region"               bmkx-bmenu-show-only-region-bookmarks    :transient t)
    ("a" "Autofile"             bmkx-bmenu-show-only-autofile-bookmarks  :transient t)
    ("b" "Non-file buffer"      bmkx-bmenu-show-only-non-file-bookmarks  :transient t)
    ("#" "Autonamed"            bmkx-bmenu-show-only-autonamed-bookmarks :transient t)]
   ["Apps"
    ("i" "Info node"            bmkx-bmenu-show-only-info-bookmarks      :transient t)
    ("d" "Dired"                bmkx-bmenu-show-only-dired-bookmarks     :transient t)
    ("e" "EWW page"             bmkx-bmenu-show-only-eww-bookmarks       :transient t)
    ("g" "Gnus article"         bmkx-bmenu-show-only-gnus-bookmarks      :transient t)
    ("m" "man / woman page"     bmkx-bmenu-show-only-man-bookmarks       :transient t)
    ("I" "Image"                bmkx-bmenu-show-only-image-bookmarks     :transient t)]
   ["Other"
    ("k" "Desktop"              bmkx-bmenu-show-only-desktop-bookmarks   :transient t)
    ("y" "Bookmark-file"        bmkx-bmenu-show-only-bookmark-file-bookmarks :transient t)
    ("z" "Bookmark-list view"   bmkx-bmenu-show-only-bookmark-list-bookmarks :transient t)
    ("v" "Variable list"        bmkx-bmenu-show-only-variable-list-bookmarks :transient t)
    ("F" "Function"             bmkx-bmenu-show-only-function-bookmarks  :transient t)
    ("w" "Snippet"              bmkx-bmenu-show-only-snippet-bookmarks   :transient t)
    ("u" "URL"                  bmkx-bmenu-show-only-url-bookmarks       :transient t)]]

  [["Status"
    ("X" "Temporary"            bmkx-bmenu-show-only-temporary-bookmarks :transient t)
    ("-" "Omitted"              bmkx-bmenu-show-only-omitted-bookmarks   :transient t)]
   ["All"
    ("." "Show all"             bmkx-bmenu-show-all                      :transient t)]
   ["Exit"
    ("q" "Back"                 transient-quit-one)
    ("Q" "Quit menu"            transient-quit-all)]])


;;; Sort submenu --------------------------------------------------------

(transient-define-prefix casual-bmkx-sort-tmenu ()
  "Sort the `*Bmkx List*' buffer."
  [["Sort by"
    ("n" "Name"                bmkx-bmenu-sort-by-bookmark-name        :transient t)
    ("d" "Last bookmark access" bmkx-bmenu-sort-by-last-bookmark-access :transient t)
    ("b" "Last buffer/file access" bmkx-bmenu-sort-by-last-buffer-or-file-access :transient t)
    ("k" "Bookmark type"       bmkx-bmenu-sort-by-bookmark-type        :transient t)
    ("f" "File name"           bmkx-bmenu-sort-by-file-name            :transient t)
    ("0" "Creation time"       bmkx-bmenu-sort-by-creation-time        :transient t)]
   ["Group"
    ("a" "Annotated first"     bmkx-bmenu-sort-annotated-before-unannotated :transient t)
    ("D" "Flagged-D first"     bmkx-bmenu-sort-flagged-before-unflagged :transient t)
    (">" "Marked first"        bmkx-bmenu-sort-marked-before-unmarked  :transient t)]
   ["Misc"
    ("r" "Reverse current order" bmkx-reverse-sort-order               :transient t)
    ("s" "Cycle sort orders"   bmkx-bmenu-change-sort-order-repeat     :transient t)]
   ["Exit"
    ("q" "Back"                transient-quit-one)
    ("Q" "Quit menu"           transient-quit-all)]])


(defun casual-bmkx--filename-style-label ()
  "Transient description for the filename-style cycle entry.
Shows the current value of `bmkx-bmenu-filename-style' inline."
  (format "Filename style: %s"
          (if (boundp 'bmkx-bmenu-filename-style)
              bmkx-bmenu-filename-style
            'abbreviate)))

(defun casual-bmkx--tags-column-label ()
  "Transient description for the tags-column toggle entry.
Shows whether the tags column is on and at what width."
  (if (and (boundp 'bmkx-bmenu-show-tags-flag) bmkx-bmenu-show-tags-flag)
      (format "Tags column: on (%d chars)"
              (if (boundp 'bmkx-bmenu-tags-column-width)
                  bmkx-bmenu-tags-column-width
                18))
    "Tags column: off"))


;;; Main menu -----------------------------------------------------------

;;;###autoload (autoload 'casual-bmkx-tmenu "casual-bmkx" nil t)
(transient-define-prefix casual-bmkx-tmenu ()
  "Casual menu for the `*Bmkx List*' buffer.

The menu persists between commands.  Press \\`Q' to dismiss it
explicitly, \\`X' to kill the `*Bmkx List*' buffer."
  [["Move"
    ("n"   "Next line"          next-line                             :transient t)
    ("p"   "Prev line"          previous-line                         :transient t)
    ("RET" "Open here"          bmkx-list-this-window                 :transient t)
    ("o"   "Open other window"  bmkx-list-other-window                :transient t)
    ("O"   "Switch other window" bmkx-list-switch-other-window        :transient t)]
   ["Mark"
    ("m"   "Mark"               bmkx-list-mark                        :transient t)
    ("u"   "Unmark"             bmkx-list-unmark                      :transient t)
    ("t"   "Toggle marks"       bmkx-bmenu-toggle-marks               :transient t)
    ("M"   "Mark all"           bmkx-bmenu-mark-all                   :transient t)
    ("U"   "Unmark all"         bmkx-bmenu-unmark-all                 :transient t)
    ("%"   "Mark by regexp"     bmkx-bmenu-regexp-mark                :transient t)]
   ["Delete"
    ("d"   "Flag for delete"    bmkx-bmenu-flag-for-deletion          :transient t)
    ("x"   "Execute D flags"    bmkx-list-execute-deletions           :transient t)
    ("D"   "Delete marked"      bmkx-bmenu-delete-marked              :transient t)]]

  [["Filter / Show"
    ("."   "Show all"           bmkx-bmenu-show-all                   :transient t)
    (">"   "Only marked"        bmkx-bmenu-toggle-show-only-marked    :transient t)
    ("<"   "Only unmarked"      bmkx-bmenu-toggle-show-only-unmarked  :transient t)
    ("M-t" "Toggle file column" bmkx-list-toggle-filenames            :transient t)
    ("M-F" "Filename style..."  bmkx-bmenu-cycle-filename-style
     :description casual-bmkx--filename-style-label                    :transient t)]
   ["Edit"
    ("e"   "Edit record"        bmkx-bmenu-edit-bookmark-record       :transient t)
    ("E"   "Edit marked"        bmkx-bmenu-edit-marked                :transient t)
    ("r"   "Rename"             bmkx-bmenu-edit-bookmark-name-and-location :transient t)
    ("a"   "Show annotation"    bmkx-list-show-annotation             :transient t)
    ;; Edit pops up an annotation-compose buffer for the user to work
    ;; in; close the menu so they can edit without it overlaying.
    ("A"   "Edit annotation"    bmkx-bmenu-edit-annotation            :transient nil)]
   ["Files"
    ("S"   "Save"               bmkx-save                             :transient t)
    ("L"   "Switch bmk file"    bmkx-switch-bookmark-file-create      :transient t)
    ("l"   "Load"               bmkx-load                             :transient t)]]

  [["Preview"
    ("P"   "Toggle live preview" bmkx-list-preview-mode               :transient t)]
   ["Help"
    ("H"   "Describe this"      bmkx-bmenu-describe-this-bookmark     :transient t)
    ("M-H" "Describe marked"    bmkx-bmenu-describe-marked            :transient t)]
   ["Submenus"
    ("s"   "Sort menu..."       casual-bmkx-sort-tmenu                :transient t)
    ("T"   "Tag menu..."        casual-bmkx-tags-tmenu                :transient t)
    ("f"   "Type filter..."     casual-bmkx-type-filter-tmenu         :transient t)]
   ["Exit"
    ("g"   "Refresh"            bmkx-bmenu-refresh-menu-list          :transient t)
    ("X"   "Kill *Bmkx List*"   bmkx-bmenu-quit                       :transient nil)
    ("Q"   "Quit menu"          transient-quit-all)]])


;;; Bind into `bmkx-list-mode-map' when that map is defined ------------

(with-eval-after-load 'bookmark-x-bmu
  (when (boundp 'bmkx-list-mode-map)
    (define-key bmkx-list-mode-map "c" #'casual-bmkx-tmenu)))


(provide 'casual-bmkx)

;;; casual-bmkx.el ends here
