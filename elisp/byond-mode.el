;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.

(defvar byond-mode-hook nil)
(defvar byond-mode-map 
  (let ((byond-mode-map (make-keymap)))
    (define-key byond-mode-map "\C-j" 'newline-and-indent)
    byond-mode-map)
  "Keymap for byond major mode")


(add-to-list 'auto-mode-alist '("\\.dm\\'" . byond-mode))

(defconst byond-font-lock-keywords-1
  (list
   '("\\<\\(as\\|for\\|i[fn]\\|proc\\|return\\|var\\)\\>" 
     .
     font-lock-builtin-face))
   ;;'("
  "Highlighting expressions")

(defun byond-indent-line ()
  "Indent current line as Byond code"
  (interactive)
  (beginning-of-line)
  (if (bobp) ; Check for rule 1
      (indent-line-to 0)
    (let ((not-indented t) cur-indent)
      (if (looking-at "^[ \t]*END_") ; Check for rule 2
	  (progn
	    (save-excursion
	      (forward-line -1)
	      (setq cur-indent (- (current-indentation) default-tab-width)))
	    (if (< cur-indent 0)
		(setq cur-indent 0)))

(defun byond-mode ()
  "Major mode for byond editing"
  (interactive)
  (kill-all-local-variables)
  (use-local-map byond-mode-map))
  
