;;; ecb-help.el --- online help for ECB

;; Copyright (C) 2001 Jesper Nordenberg
;; Copyright (C) 2001 Free Software Foundation, Inc.
;; Copyright (C) 2001 Klaus Berndl <klaus.berndl@sdm.de>

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
;; Contains all online-help for ECB (stolen something from recentf.el)

;; $Id: ecb-help.el,v 1.5 2001/04/22 18:52:23 berndl Exp $

;;; Code

(require 'ecb-layout)

(defconst ecb-help-message
  "
                              ===================
                              General description
                              ===================      

ECB offers a few ECB-windows for browsing your sources comfortable with the
mouse. There are currently three different types of ECB-windows:

1. ECB Directories:

- Select directories \(and - if enabled - source files) in the \"*ECB
  Directories*\" buffer by clicking a mouse button (see \"Usage of ECB\"
  below) on the directory name or by hitting ENTER/RETURN when the cursor is
  placed on the item line.

- Directory names with a \"[+]\" symbol after \(or before) them can be
  expanded/collapsed by clicking on the symbol, pressing the TAB key when the
  cursor is placed on the package line or clicking a mouse button (see \"Usage
  of ECB\" below) on the item.

- Right clicking on an item will open a popup menu where different operations
  on the item under the mouse cursor can be performed.

- Pressing F1 in the directories buffer will update it. Pressing F2 will open
  the ECB customization group in the edit window ECB Sources:

2. ECB Sources:

- Source files can be selected by clicking a mouse button (see \"Usage of
  ECB\" below) or hitting ENTER/RETURN on the source row in the \"*ECB
  Sources*\" or \"*ECB History*\" windows.

  IMPORTANT: If you hold down the SHIFT-key while clicking with the primary
  mouse button (see \"Usage of ECB\" below) on a source row in the \"*ECB
  Sources*\" or \"*ECB History*\" windows then the source will not be
  displayed in the edit-window but it will be scanned in the background and
  all it�s methods and variables are listed in the \"ECB Methods\" window. So
  you can get an overlook over the source without changing the buffer in the
  edit-window.

- Clicking on the source file with the secondary mouse button (see \"Usage of
  ECB\" below) will open the class file in the other edit window.

- Right clicking on a source file will open a popup menu where different
  operation on the item under the mouse cursor can be performed.

3. ECB Methods:

- The \"*ECB Methods*\" buffer contains the methods \(and variables, if you
  want) in the selected source file. When a method/variable is selected with
  the primary mouse button (see \"Usage of ECB\" below) or ENTER/RETURN the
  edit buffer will jump to the method/variable.

- Clicking on a method/variable with the secondary mouse button (see \"Usage
  of ECB\" below) will jump to the method in the other edit window.

In addition to these ECB-windows you have always one or two edit-windows in
the ECB-frame and \(if you want) at the bottom a compilation-window, where all
the output of Emacs-compilation \(compile, grep etc.) is shown.


                          ===========================
                          Activation and deactivation
                          ===========================

Call M-x `ecb-activate' and M-x `ecb-deactivate' to activate or deactivate
ECB.


                                 ============
                                 Usage of ECB
                                 ============                    

Working with the mouse in the ECB-buffers:
------------------------------------------

Normally you get best usage if you use ECB with a mouse.

ECB distinguishes between a primary and a secondary mouse-button:

A click with the primary button causes the main effect in each ECB-buffer:
- ECB Directories: Expanding/collapsing nodes and displaying files in the ECB
  Sources buffer.
- ECB sources/history: Opening the file in that edit-window specified by the
  option `ecb-primary-mouse-jump-destination'.
- ECB Methods: Jumping to the method in that edit-window specified by the
  option `ecb-primary-mouse-jump-destination'.
A click with the primary mouse-button while the SHIFT-key is pressed only
displays the complete clicked node in the minibuffer. This is useful if the
node is longer as the window-width of the ECB-window and `ecb-truncate-lines'
is not nil.
IMPORTANT: Doing this in the \"*ECB Sources*\" or \"*ECB History*\" windows
does not only show the node in the echo area but it also opens the clicked
source only in the background and shows all its methods/variables in \"ECB
Methods\"; the buffer of the edit-window is not changed!

The secondary mouse-button is for opening \(jumping to) the file in the other
window \(see the documentation `ecb-primary-mouse-jump-destination').

With the option `ecb-primary-secondary-mouse-buttons' the following
combinations of primary and secondary mouse-buttons are possible:
- primary: mouse-2, secondary: C-mouse-2 \(means mouse-2 while CTRL-key is
  pressed). This is the default setting.
- primary: mouse-1, secondary: C-mouse-1
- primary: mouse-1, secondary: mouse-2
If you change this during ECB is activated you must deactivate and activate
ECB again to take effect

In each ECB-buffer mouse-3 \(= right button) opens a special context
popup-menu for the clicked item where you can choose several senseful actions.


Working with the keyboard in the ECB-buffers:
---------------------------------------------

In the ECB-buffers RET and TAB work as primary \"buttons\" \(see above), means
RET opens a source or jumps to a method and TAB toggles expanding/collapsing
of an expandable node.

For easy jumping to a certain ECB-buffer with the keyboard you should set
`ecb-other-window-jump-behavior' to 'all.

Tip: You can install the package windmove.el for selection of windows in a
frame geometrically. This makes window-selection a child�s play.


Working with the edit-window of ECB:
------------------------------------

ECB offers you all what you need to work with the edit-window as if the
edit-window would be the only window of the ECB-frame.

ECB offers you to advice the following functions so they work best with ECB
- `other-window'
- `delete-window'
- `delete-other-windows'
- `split-window-horizontally'
- `split-window-vertically'
- `find-file-other-window'
- `switch-to-buffer-other-window'

The behavior of the adviced functions is:
- All these adviced functions behaves exactly like their corresponding
  original functons but they always act as if the edit-window\(s) of ECB would
  be the only window\(s) of the ECB-frame. So the edit-window\(s) of ECB seems
  to be a normal Emacs-frame to the user.
- If called in a not edit-window of ECB all these function jumps first to the
  \(first) edit-window, so you can never destroy the ECB-window layout
  unintentionally.

**Attention**:
If you want to work within the edit-window with splitting and unsplitting the
edit-window\(s) it is highly recommended to use the adviced-functions of ECB
instead of the original Emacs-functions \(see above). For example the adviced
`other-window' can only work correct if you split the edit window with the
adviced `split-window-vertically' \(or horizontally) and NOT with the original
`split-window-vertically'!

Per default ECB advices all the functions mentioned above but with the option
`ecb-advice-window-functions' you can customizes which functions should be
adviced by ECB.

The jump-behavior of the advices `other-window' can be customized with
`ecb-other-window-jump-behavior'!


Working with or without a compile window:
-----------------------------------------

With the option `ecb-compile-window-height' you can define if the ECB layout
should contain per default a compilation-window at the bottom \(and if yes the
height of it). If yes ECB displays all output of compilation-mode \(compile,
grep etc.) in this special window. If not ECB splits the edit-window \(or uses
the \"other\" edit-window if already splitted) vertically and displays the
compilation-output there.
Same for displaying help-buffers or similar stuff.

With the option `ecb-compile-window-temporally-enlarge' you can allow Emacs to
enlarge temporally the ECB-compile-window after finishing compilation-output.

Know Bug: The setting in `ecb-compile-window-height' works correct for all
compilation-output of Emacs (compile, grep etc.) but for some other output
like help-buffers etc. Emacs enlarges the height of the compile-window for
it�s output. Currently ECB can�t restore auto. the height of the
compile-window for such outputs. But you can always restore the correct layout
by calling `ecb-redraw-layout'!.


Redrawing the ECB-layout:
-------------------------

If you have unintenionally destroyed the ECB-layout, you can always restore the
layout with calling `ecb-redraw-layout'.


Available interactive ECB commands:
-----------------------------------

- `ecb-activate'
- `ecb-deactivate'
- `ecb-update-directories-buffer' (normally not needed)
- `ecb-current-buffer-sync' (normally not needed)
- `ecb-redraw-layout'
- `ecb-clear-history'
- `ecb-show-help'


                             ====================
                             Customization of ECB
                             ====================

All customization of ECB is divided into the following customize groups:
- ecb-general: General customization of ECB
- ecb-directories: Customization of the ECB-directories buffer.
- ecb-sources: Customization of the ECB-sources buffer.
- ecb-methods: Customization of the ECB-methods buffer.
- ecb-history: Customization of the ECB-history buffer.
- ecb-layout: Customization of the layout of ECB.

You can highly customize all the ECB behavior/layout so just go to this groups
and you will see all well documented ECB-options.

But you must always customize the option `ecb-source-path'!
Maybe you should also check all the options in the customize group
'ecb-layout' before you begin to work with ECB.

Available hooks:
- `ecb-activate-before-layout-draw-hook'
- `ecb-activate-hook'
- `ecb-deactivate-hook'
Look at the documentation of these hooks to get description.


                      ===================================
                      Known conflicts with other packages
                      ===================================

Here is a list of known conflicts of ECB with other packages and helpful
workarounds:

1. Package VC
   The variable `vc-delete-logbuf-window' must be set to nil during active
   ECB. This can be done with the hooks mentioned above.
")

(defconst ecb-help-buffer-name "*ECB help*")

(defvar ecb-buffer-before-help nil)

(defun ecb-cancel-dialog (&rest ignore)
  "Cancel the ECB dialog."
  (interactive)
  (kill-buffer (current-buffer))
  (if ecb-buffer-before-help
      (switch-to-buffer ecb-buffer-before-help t))
  (setq ecb-buffer-before-help nil)
  (message "ECB dialog canceled."))

(defvar ecb-dialog-mode-map nil
  "`ecb-dialog-mode' keymap.")

(if ecb-dialog-mode-map
    ()
  (setq ecb-dialog-mode-map (make-sparse-keymap))
  (define-key ecb-dialog-mode-map "q" 'ecb-cancel-dialog)
  (define-key ecb-dialog-mode-map (kbd "C-x k") 'ecb-cancel-dialog)
  (set-keymap-parent ecb-dialog-mode-map help-mode-map))

(defun ecb-dialog-mode ()
  "Major mode used to display the ECB-help

These are the special commands of `ecb-dialog-mode' mode:
    q -- cancel this dialog."
  (interactive)
  (setq major-mode 'ecb-dialog-mode)
  (setq mode-name "ecb-dialog")
  (use-local-map ecb-dialog-mode-map))

(defun ecb-show-help ()
  "Shows the online help of ECB."
  (interactive)
  (if (not (ecb-point-in-edit-window))
      (ecb-other-window))
  (if (get-buffer ecb-help-buffer-name)
      (switch-to-buffer ecb-help-buffer-name t)
    (if (not ecb-buffer-before-help)
        (setq ecb-buffer-before-help (current-buffer)))
    (with-current-buffer (get-buffer-create ecb-help-buffer-name)
      (switch-to-buffer (current-buffer) t)
      (kill-all-local-variables)
      (let ((inhibit-read-only t))
        (erase-buffer))
      (let ((all (overlay-lists)))
        ;; Delete all the overlays.
        (mapcar 'delete-overlay (car all))
        (mapcar 'delete-overlay (cdr all)))
      ;; Insert the dialog header
      (insert "Type \"q\" to quit.\n")
      (insert ecb-help-message)
      (insert "\n\n")
      (make-variable-buffer-local 'buffer-read-only)
      (setq buffer-read-only t)
      (ecb-dialog-mode)
      (goto-char (point-min))
      (help-make-xrefs)
      (goto-char (point-min)))))


(provide 'ecb-help)

;; ecb-help.el ends here

