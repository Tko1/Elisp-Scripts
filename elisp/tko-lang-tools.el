(require 'cl-lib)
(load "tko-utils.el")
;;; tko-lang-tools-.el --- Test


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
; Constants
;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq +tko-comment-line-width+ 40)
(setq +tko-comment-line-height+ 6)
(setq +tko-comment-line-small-height+ 2)
(setq +languages+
      '(:c 
	'(:name "C"
	  :default-indent-spacing 2
	  :file-extensions '("c"))
	:java 
	'(:name "Java"
	  :default-indent-spacing 2
	  :file-extensions '("java"))
	:cpp
	'(:name "C++"
	  :default-indent-spacing 2
	  :file-extensions '("cpp" "c++"))
	:elisp
	'(:name "Emacs Lisp"
	  :default-indent-spacing 2
	  :file-extensions '("el"))))
(setq +code-types+
      '(:subvars '('+variable+)))
(setq +variable+
      '(:properties '(:type :name :val)
	:tag :variable
	:name "var"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; End Constants
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
; Comments
;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Low level
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(cl-defun tko-comment-line (&key (language :c)
				 (width +tko-comment-line-width+))
  (case language
    ((:c :c++ :java)
     (concat "/" (make-string width ?*) "/")
    ((:python :ruby)
     (make-string width ?#)
    ((:haskell)
     (make-string width ?-) 
    ((:lisp :elisp :clisp :common-lisp :clojure)
     (make-string width ?\;)))))))

(defun tko-create-appropriate-comment-line ())
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(cl-defun tko-comment-box (&key (language :c)
				(width +tko-comment-line-width+)
				(height +tko-comment-line-height+)
				(text ""))
  (interactive)
  (let ( (comment-box
	  (append
	   ;First member of list represents width of first line of comment box
	   (list width)
	   ;This is a list of 1st, representing that each indented line after is a 1 line comment
	   (mapcar (lambda (x) 1) (number-sequence 1 height))
	   ;Last line of comment box
	   (list width)))
	 (comment-line-func
	  (lambda (w) 
	    (tko-comment-line :language
			      language
			      :width
			      w)
	    (insert "\n"))))
         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	 (mapc comment-line-func comment-box)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;make it so when you type tko-create, it auto does this
(defun tko-create-open-comment-box (language)
  (insert (tko-comment-box :language language)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tko-create-close-comment-box (language)
  (insert (tko-comment-box :language language :height +tko-comment-line-small-height+)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tko-create-open-close-comment-box (language)
  (tko-create-open-comment-box language)
  (tko-create-close-comment-box language))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Comments
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
; Language
;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Haskell 
(defun tko-haskell-comment-line (width)
  (make-string width ?-))
(defun tko-haskell-named-comment-line (name width)
  (let* ((half-name-len (/ (+ (length name) 1) 2))
	(left-line-len (- width half-name-len))
	(right-line-len left-line-len))
    (concat
     (tko-haskell-comment-line left-line-len)
     name
     (tko-haskell-comment-line right-line-len))))

(defun tko-haskell-new-obj (name)
  (let* ((line-width 44)
	 (header (tko-haskell-named-comment-line name line-width)) 
	 (retval
	   (concat
	    header "\n"
	    "data " name " = " name "{}" "\n"
	    "--Modifiers" "\n"
	    "--Accessors" "\n"
	    "--Constructors" "\n"
	    "--Conversions" "\n"
	    )))
    retval))
	    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;All

(defun tko-get-language (lang)
  (plist-get +languages+ lang))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
; Indenting
;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun tko-language-default-indent-spacing (lang)
  (let ((language (tko-get-language :c)))
    (plist-get language :default-indent-spacing)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tko-c-default-indent-spacing ()
  (tko-language-default-indent-spacing :c))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tko-c-indent-string (x)
  (tko-raw-indent-string (* (tko-c-default-indent-spacing) x)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;  Grammar?
;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun tko-var-declr-to-text (var)
  (tko-pconcat var :type " " :name ";"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tko-var-expr-to-text (var)
  (tko-pconcat var :type " " :name " = " :val ";"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tko-var-assign-to-text (var)
  (tko-pconcat var :name " = " :val ";"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(cl-defun tko-make-var (&key (type "int")
			     (name "default_var")
			     (val nil))
  "Makes a variable, which holds all of the info a variable has,
   which is its type,  name, and value.  A variable can later be used
   to produce text as:
    A variable declaration (int a;)
    A variable expression  (int a = 1;)
    A variable assignment  (a = 1;)"
  (list :type type
	:name name
	:val  val))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;("int" ("length" "15) 
(defun tko-make-vars (type &rest var-tuples)
  (mapcar (lambda (var) (tko-make-var :type type :name (car var)  :val (cadr var))) var-tuples))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(cl-defun tko-make-statement (&key (type :var-expr
				    data: (tko-make-var)))
  "The type is how the data will be expressed; for instance,
   if the data is a variable, and the type is var-expr,  the
   type, name, and val will be used as 
    A variable expression  (int a = 1;)" 
  (list :type type
	:data data))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tko-make-var-expr (var)
  (tko-make-statement :type :var-expr 
		      :data var))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;End Var
;;TODO make return string, not draw string
(cl-defun tko-make-func   (&key (type "void")
				(name "default_func")
				(args (tko-make-var))
				statements))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(cl-defun tko-make-struct (&key (name "default_struct"
				(vars (tko-make-var))))
  (list :name name 
	:vars vars))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tko-struct-to-text (struct)
  (let ((name (plist-get struct :name))
	(vars (plist-get struct :vars)))
    (concat "struct " name "\n"
	    "{\n"
					;Convert vars to text, reduce into one string
	    (reduce (lambda (sum var)
		      (concat 
		       sum 
		       (tko-c-indent-string 1) 
		       (tko-var-declr-to-text var) 
		       "\n")) 
		    vars
		    :initial-value "")
	    "};\n")))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq +structs+
      (list 
       (:name "string"
        :vars (append 
	       (tko-make-vars "char*"
			      '("str" "(char*)malloc(sizeof(char) * 10)"))
	       (tko-make-vars "int" 
			      '("length" "0") 
			      '("bytes_allocated" "10"))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;;Struct <name>
;;insr
;;
;;
(defun tko-create-struct (name vars)
  (interactive "Enter struct name")
)  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;testing
;(tko-make-comment-box)
(tko-make-struct "string" (list (tko-make-var :type "int"   
					      :name "length" 
					      :val "0")
				(tko-make-var :type "char*" 
					      :name "str"    
					      :val "\"\"")))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;(provide 'tko_c_funcs)

;;; tko_c_funcs.el ends here
