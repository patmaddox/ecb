;;; ecb-tod.el: ECB tip od the day

;; Copyright (C) 2003 Jesper Nordenberg
;; Copyright (C) 2003 Free Software Foundation, Inc.
;; Copyright (C) 2003 Klaus Berndl <klaus.berndl@sdm.de>

;; Author: Klaus Berndl <klaus.berndl@sdm.de>
;; Maintainer: Klaus Berndl <klaus.berndl@sdm.de>
;; Keywords: java, class, browser

;; This program is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by the Free
;; Software Foundation; either version 2, or (at your option) any later
;; version.

;; This program is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
;; FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
;; more details.

;; You should have received a copy of the GNU General Public License along
;; with GNU Emacs; see the file COPYING. If not, write to the Free Software
;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

;;; Commentary:
;;
;; Contains code for tips of the day

;;; Code

(eval-when-compile
  (require 'silentcomp))

(require 'ecb-util)

(silentcomp-defvar ecb-tod-cursor)

(defcustom ecb-tip-of-the-day t
  "*Show tip of the day at start time of ECB."
  :group 'ecb-general
  :type 'boolean)

(defcustom ecb-tip-of-the-day-file "~/.ecb-tip-of-day.el"
  "*File where tip-of-the-day cursor is stored."
  :group 'ecb-general
  :type 'file)

(defconst ecb-tod-tip-list
  '("You can expand the ECB-methods-buffer with `ecb-expand-methods-nodes' [C-c . x]."
    "You can toggle between different layouts with `ecb-toggle-layout' [C-c . t]."
    "You can toggle displaying the ECB-windows with `ecb-toggle-ecb-windows' [C-c . w]."
    "You can use speedbar as directory browser with option `ecb-use-speedbar-for-directories'."
    "You can speedup access for big directories with option `ecb-cache-directory-contents'."
    "You can display the online help also in HTML-format with option `ecb-show-help-format'."
    "You can interactively create your own layouts with the command `ecb-create-new-layout'."
    "You can start the eshell in the compile-window with `ecb-eshell-goto-eshell' [C-c . e]."
    "You can \(de)activate ECB on a major-mode basis with `ecb-major-modes-activate' and `ecb-major-modes-deactivate'."
    "Use the incremental search in the methods-buffer for fast node-selecting; see `ecb-tree-incremental-search'."
    "You can cycle through all currently opened \"compile-buffers\" with `ecb-cycle-through-compilation-buffers'."
    "You can change the window-sizes by dragging the mouse and storing the new sizes with `ecb-store-window-sizes'."
    "You can get a quick overlook of all builtin layouts with `ecb-show-layout-help'."
    "Browse your sources as with a web-browser with `ecb-nav-goto-next' \[C-c . n], `ecb-nav-goto-previous' \[C-c . p]."
    "Download latest ECB direct from the website with `ecb-download-ecb'."
    "Customize the look\&feel of the tree-buffers with `ecb-tree-expand-symbol-before' and `ecb-tree-indent'."
    "Customize the contents of the methods-buffer with `ecb-token-display-function', `ecb-type-token-display', `ecb-show-tokens'."
    "Customize the main mouse-buttons of the tree-buffers with `ecb-primary-secondary-mouse-buttons'."
    "Customize with `ecb-tree-RET-selects-edit-window' in which tree-buffer a RETURN selects the edit-window."
    "Grep a directory \(recurive) by using the popup-menu \(the right mouse-button) in the directories buffer."
    "Customize the sorting of the sources with the option `ecb-sources-sort-method'."
    "Narrow the source-buffer to the selected token in the methods-buffer with `ecb-token-jump-narrow'."
    "Enable autom. enlarging of the compile-window by select with the option `ecb-compile-window-enlarge-by-select'."
    "Customize with `ecb-compile-window-temporally-enlarge' the situations the compile-window is allowed to enlarge."
    "Customize the jump-behavior of `other-window' [C-x o] with the option `ecb-other-window-jump-behavior'."
    "Customize height and width of the ECB-windows with `ecb-windows-height' and `ecb-windows-width'."
    "Define with `ecb-compilation-buffer-names' and `ecb-compilation-major-modes' which buffers are \"compile-buffers\"."
    "Customize all faces used by ECB with the customize-groups `ecb-face-options' and `ecb-faces'."
    "Auto-activate eshell with the option `ecb-eshell-auto-activate'."
    "Get best use of big screen-displays with leftright-layouts like \"leftright1\" or \"leftright2\"."
    "Use the POWER-click in the methods-buffer to narrow the clicked node in the edit-window."
    "Use the POWER-click in the sources- and history-buffer to get only an overlook of the source-contents."
    "Exclude not important sources from being displayed in the sources-buffer with `ecb-source-file-regexps'."
    "Use left- and right-arrow for smart expanding/collapsing tree-buffer-nodes; see `ecb-tree-navigation-by-arrow'."
    "Add personal keybindings to the tree-buffers with `ecb-common-tree-buffer-after-create-hook'."
    "Add personal keybindings to the directories-buffer with `ecb-directories-buffer-after-create-hook'."
    "Add personal keybindings to the sources-buffer with `ecb-sources-buffer-after-create-hook'."
    "Add personal keybindings to the methods-buffer with `ecb-methods-buffer-after-create-hook'."
    "Add personal keybindings to the history-buffer with `ecb-history-buffer-after-create-hook'."
    "Pop up a menu with the right mouse-button and do senseful things in the tree-buffers."
    "Call `ecb-show-help' [C-c . o] with a prefix-argument [C-u] and choose the help-format."
    "You can change the prefix [C-c .] of all ECB-keybindings quick and easy with `ecb-key-map'."
    "Send a problem-report to the ECB-mailing-list quick and easy with `ecb-submit-problem-report'."
    )
  "List of all available tips of the day.")



;; Klaus Berndl <klaus.berndl@sdm.de>: just a first try to get current
;; day and display simple message boxes. But maybe i will add the complete
;; tip-of-the-day-stuff........
;; (defun ecb-tip-of-the-day ()
;;   (let ((current-day (nth 3 (decode-time))))
;;     (message "Tip for the %s. of current month" current-day)
;;     (ecb-message-box "Have you already known..." "Tip of the day" "Close")))



(defun ecb-show-tip-of-the-day ()
  "Show tip of the day if `ecb-tip-of-the-day' is not nil or if called
interactively."
  (interactive)
  (when (or (interactive-p) ecb-tip-of-the-day)
    (ignore-errors (load-file ecb-tip-of-the-day-file))
    (let* ((cursor (if (boundp 'ecb-tod-cursor)
                       ecb-tod-cursor
                     0))
           (tip (or (ignore-errors (nth cursor ecb-tod-tip-list))
                    (nth 0 ecb-tod-tip-list))))
      ;; show tip
      (ecb-message-box tip "Tip of the day" "Close")
      ;; change cursor
      (ecb-tod-move-cursor cursor))))

(defun ecb-tod-move-cursor (cursor)
  (with-temp-file (expand-file-name ecb-tip-of-the-day-file)
    (erase-buffer)
    (insert (format "(defvar ecb-tod-cursor 0)\n(setq ecb-tod-cursor %d)"
                    (if (< (1+ cursor) (length ecb-tod-tip-list))
                        (1+ cursor)
                      0)))))

(silentcomp-provide 'ecb-tod)

;; ecb-tod.el ends here