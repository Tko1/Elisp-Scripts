(require 'cl-lib)
(require 'tko-utils)
;;; tko_c_funcs.el --- Test

;;; Conventions
;;

;;; Commentary:
;; 
(setq +tko-comment-line-width+ 40)
(setq +tko-comment-line-height+ 6)
(cl-defun tko-make-comment-line (&key (language :c)
				      (width +tko-comment-line-width+))
  (case language
    ((:c :c++ :java)
     (insert "/")
     (dotimes (i width) (insert "*"))
     (insert "/"))
    ((:python :ruby):
	     (dotimes (i width) (insert "#")))
    ((:lisp :elisp :clisp :common-lisp :clojure)
     (dotimes (i width) (insert ";")))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(cl-defun tko-make-comment-box (&key (language :c)
				     (width +tko-comment-line-width+)
				     (height +tko-comment-line-height+)
				     (text ""))
  (let ( (comment-box
	  (append
	   ;First member of list represents width of first line of comment box
	   (list width)
	   ;This is a list of 1st, representing that each indented line after is a 1 line comment
	   (mapcar (lambda (x) 1) (number-sequence 1 +tko-comment-line-height+))
	   ;Last line of comment box
	   (list width)))
	 (comment-line-func
	  (lambda (w) 
	    (tko-make-comment-line :language
				   language
				   :width
				   w)
	    (insert "\n"))))
         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	 (mapc comment-line-func comment-box)))
(defun tko-get-val (alis val)
  (cdr (assoc val alis)))

(defun tko-get-properties (plis properties)
  (mapcar (apply-partially 'plist-get var) properties))
(defun tko-pconcat (&rest concats)
  
)
;;All
(setq +code-types+
      '(:subvars '('+variable+))
;;Variable
(setq +variable+
      '(:properties '(:type :name :val)
	:tag :variable
	:name "var"))
(defun tko-var-to-text (var)
  (concat
   (reduce 'concat (tko-get-properties var '(:type :name))))
(defun tko-var-declr-to-text (var)
  (reduce 'concat (tko-get-properties var '(:type :name :val))))
(cl-defun tko-make-var (&key t n v)
  (list :type t
	:name n
	:val  v))
;End Var
;;TODO make return string, not draw string
(defun tko-make-struct (name vars)
  (insert 
   (concat "struct " name "\n"
    "{\n"
    ;Convert vars to text, reduce into one string
    (reduce (lambda (sum var) 
	      (concat sum (tko-var-declr-to-text var) "\n")) 
	    vars)
    "}\n")))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Testing
(tko-make-comment-box)/****************************************/
/*/
/*/
/*/
/*/
/*/
/*/
/****************************************/
/****************************************/
/*/
/*/
/*/
/*/
/*/
/*/
/****************************************/
/****************************************/
/*/
/*/
/*/
/*/
/*/
/*/
/****************************************/
/****************************************/
/*/
/*/
/*/
/*/
/*/
/*/
/****************************************/
/****************************************/
/*/
/*/
/*/
/*/
/*/
/*/
/****************************************/

(tko-make-struct "string" '( (tko-make-var :t "int"   :n "length" :v "0")
			     (tko-make-var :t "char*" :n "str"    :v "\"\"")))  

;(provide 'tko_c_funcs)

;;; tko_c_funcs.el ends here
