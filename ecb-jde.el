;;; ecb-jde.el: ECB JDE integrations

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

;; $Id: ecb-jde.el,v 1.2 2003/02/24 12:40:16 berndl Exp $

;;; Commentary:
;;
;; Contains code for JDEE integrations into ECB or vice versa
;; JDEE is available at http://jdee.sunsite.dk/

;;; Code

(eval-when-compile
  (require 'silentcomp))

(silentcomp-defun jde-show-class-source)
(silentcomp-defvar jde-open-class-at-point-find-file-function)
(silentcomp-defun jde-open-functions-exist)
(silentcomp-defun jde-parse-java-variable-at-point)
(silentcomp-defun jde-open-get-class-to-open)
(silentcomp-defun jde-open-get-path-prefix-list)
(silentcomp-defun jde-open-find-java-file-name)
(silentcomp-defun jde-gen-class-buffer)

(silentcomp-defun end-of-thing)

(require 'ecb-util)
(require 'ecb-layout)

(defun ecb-jde-display-class-at-point ()
  "Displays in the ECB-methods-buffer the contents \(methods, attributes
etc...) of the class which contains the definition of the \"thing\" under
point \(this can be a variablename, classname, methodname, attributename).
This function needs the same requirements to work as the method-completion
feature of JDE \(see `jde-complete-at-point')!. The source-file is searched
first in `jde-sourcepath', then in `jde-global-classpath', then in $CLASSPATH,
then in current-directory.

Works only for classes where the source-code \(i.e. the *.java-file) is
available."
  (interactive)
  (when (and ecb-minor-mode
             (ecb-point-in-edit-window)
             (equal major-mode 'jde-mode))
    (if (jde-open-functions-exist)
        (let* (
               (thing-of-interest (thing-at-point 'symbol))
               (pair (save-excursion (end-of-thing 'symbol)
                                     (jde-parse-java-variable-at-point)))
               (class-to-open (jde-open-get-class-to-open
                               pair thing-of-interest))
               (source-path-prefix-list (jde-open-get-path-prefix-list)) 
               (java-file-name nil)
               )
          (if (and class-to-open (stringp class-to-open))
              (progn
                (setq java-file-name (jde-open-find-java-file-name
                                      class-to-open source-path-prefix-list))
                (if (not java-file-name)
                    (ecb-error "Can not find the sourcecode-file for \"%s\""
                               thing-of-interest)

                  ;; TODO: Klaus Berndl <klaus.berndl@sdm.de>: 
                  ;; The following two lines of code are the only difference
                  ;; between this function and `jde-open-class-at-point'.
                  ;; Therefore it would be nice if the whole stuff necessary
                  ;; for finding the source-file of `thing-of-interest' would
                  ;; be extracted in an own function of JDE.
                  
                  ;; we have found the java-sourcefile. So let�s display its
                  ;; contents in the method-buffer of ECB
                  (ecb-exec-in-methods-window
                   (ecb-set-selected-source java-file-name nil t))))
            
            (ecb-error "Can not parse the thing at point!")))
      (message "You need JDE >= 2.2.6 and Senator for using this feature!"))))


(defun ecb-jde-show-class-source (unqual-class)
  "Calls `jde-show-class-source' for UNQUAL-CLASS and returns t if no error
occurs."
  (when (eq major-mode 'jde-mode)
    (condition-case nil
        (progn
          (jde-show-class-source unqual-class)
          t)
      (error nil))))


(defun ecb-jde-open-class-at-point-ff-function (filename &optional wildcards)
  "Special handling of the class opening at point JDE feature. This function
calls the value of `jde-open-class-at-point-find-file-function' with activated
ECB-adviced functions."
  (ecb-with-adviced-functions
   (if (and (boundp 'jde-open-class-at-point-find-file-function)
            (fboundp jde-open-class-at-point-find-file-function))
       (funcall jde-open-class-at-point-find-file-function
                filename wildcards))))


(defun ecb-jde-gen-class-buffer (dir filename)
  "Calls `jde-gen-class-buffer' for the file FILENAME in DIR. If this function
is not available then `find-file' is called."
  (let ((file (concat dir "/" filename)))
    (if (fboundp 'jde-gen-class-buffer)
        (jde-gen-class-buffer file)
      (find-file file))))
  

(silentcomp-provide 'ecb-jde)

;;; ecb-jde.el ends here
