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
