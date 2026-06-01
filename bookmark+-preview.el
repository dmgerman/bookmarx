;;; bookmark+-preview.el --- Live preview for Bookmark+   -*- lexical-binding:t -*-
;;
;; Two ways to preview a bookmark's destination without committing to a jump:
;;
;;   `bmkp-list-preview-mode' — buffer-local minor mode in `*Bmkp List*'.
;;       Modeled on the built-in `next-error-follow-minor-mode' (simple.el):
;;       a `post-command-hook' watches point motion and dispatches the
;;       bookmark on the current line into another window without selecting
;;       it.  Toggle with `P' in `bmkp-list-mode'.
;;
;;   `bmkp-jump' minibuffer preview — when `consult' is loaded and
;;       `bmkp-preview-use-consult-flag' is non-nil, the interactive
;;       bookmark-name read for `bmkp-jump' (and its other-window /
;;       other-frame variants) is routed through `consult--read' with
;;       `consult--bookmark-preview' as the `:state' callback, the same
;;       mechanism `consult-bookmark' uses.

;;; Code:

(require 'bookmark)

(declare-function bmkp-list-bookmark             "bookmark+-bmu")
(declare-function bmkp-jump-1                    "bookmark+-1")
(declare-function bmkp-maybe-load-default-file   "bookmark+-1")
(declare-function bmkp-completing-read           "bookmark+-1")
(declare-function bmkp-default-bookmark-name     "bookmark+-1")

;; Soft consult deps — only used when `(featurep 'consult)'.
(declare-function consult--read                  "consult")
(declare-function consult--bookmark-preview      "consult")


;;; Customization --------------------------------------------------------

(defcustom bmkp-preview-use-consult-flag t
  "Non-nil means use `consult' for live preview in `bmkp-jump' commands.
Only takes effect when the `consult' package is loaded.  When nil, or
when `consult' is not loaded, `bmkp-jump' reads bookmark names through
the usual `completing-read', with no preview."
  :type 'boolean :group 'bookmark-plus)

(defcustom bmkp-list-preview-display-action
  '(display-buffer-use-some-window . ((inhibit-same-window . t)))
  "`display-buffer' action used to show preview windows.
Used by `bmkp-list-preview-mode'.  The default opens the preview in
some other window without stealing focus from `*Bmkp List*'."
  :type '(cons function alist) :group 'bookmark-plus)


;;; Buffer-side: `bmkp-list-preview-mode' -------------------------------

(defvar bmkp-list-preview-mode)         ; Forward decl (defined by `define-minor-mode' below).

(defvar-local bmkp-list-preview--last-line nil
  "Line number of the bookmark last previewed in the current buffer.")

(defvar-local bmkp-list-preview--saved-window-config nil
  "Window configuration saved when `bmkp-list-preview-mode' was enabled.")

(defun bmkp-list-preview--show ()
  "Preview the bookmark on the current line, leaving point in `*Bmkp List*'."
  (when bmkp-list-preview-mode
    (let ((line  (line-number-at-pos)))
      (unless (eq line bmkp-list-preview--last-line)
        (setq bmkp-list-preview--last-line  line)
        (let ((bmk  (ignore-errors (bmkp-list-bookmark))))
          (when bmk
            (save-selected-window
              (condition-case _err
                  (let ((display-buffer-overriding-action  bmkp-list-preview-display-action))
                    (bmkp-jump-1 bmk #'pop-to-buffer nil))
                (error nil)))))))))

;;;###autoload
(define-minor-mode bmkp-list-preview-mode
  "Toggle live preview of the bookmark on point in `*Bmkp List*'.

When enabled, moving point onto a bookmark line opens its destination
in another window without changing the selected window.  This is the
bookmark-list analog of `next-error-follow-minor-mode'.

Disabling the mode restores the window configuration that was in
effect when the mode was enabled."
  :lighter " Pv"
  :group 'bookmark-plus
  (cond
   (bmkp-list-preview-mode
    (setq bmkp-list-preview--saved-window-config  (current-window-configuration))
    (setq bmkp-list-preview--last-line            nil)
    (add-hook 'post-command-hook #'bmkp-list-preview--show nil 'local)
    (bmkp-list-preview--show))
   (t
    (remove-hook 'post-command-hook #'bmkp-list-preview--show 'local)
    (when bmkp-list-preview--saved-window-config
      (set-window-configuration bmkp-list-preview--saved-window-config)
      (setq bmkp-list-preview--saved-window-config  nil)))))


;;; Minibuffer-side: consult integration for `bmkp-jump' ---------------

;;;###autoload
(defun bmkp-read-bookmark-for-jump (prompt &optional default)
  "Read a bookmark name with live preview, for the `bmkp-jump' commands.

When the `consult' package is loaded and `bmkp-preview-use-consult-flag'
is non-nil, read through `consult--read' with the same preview state
function `consult-bookmark' uses.  Otherwise fall back to
`bmkp-completing-read'."
  (bmkp-maybe-load-default-file)
  (if (and bmkp-preview-use-consult-flag
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
    (bmkp-completing-read prompt default)))


(provide 'bookmark+-preview)

;;; bookmark+-preview.el ends here
