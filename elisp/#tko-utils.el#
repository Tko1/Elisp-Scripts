;;List Functions
(defun empty? (x) 
  (eq x ()))
(defun tail (x)
  (cdr x))
(defun head (x)
  (car x))
;;String functions
;;TODO check online if this is neccesarry
(defun char-at (string x)
  (char-to-string (aref string x)))
;(defun to-string (obj)
;  (case (type-o obj)
;    (('symbol)
     

;;Interactive functions
;;Indenting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
; Constants
;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq +tko-default-indent-spacing+ 2)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; End constants
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
;
;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun tko-raw-indent-string (x)
  (make-string x ? ))
(defun tko-raw-indent (x)
  (insert (tko-raw-indent-string x)))
(defun tko-indent (x)
  (tko-raw-indent (* x +tko-default-indent-spacing+)))
(defun tko-raw-indent-line (x)
  (save-excursion
    (beginning-of-line)
    (tko-raw-ident x)))
(defun tko-indent-line (x)
  (tko-raw-indent-line (*x +tko-default-indent-spacing+)))

;;Window stuff

;;Dealing with assoc arrays
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tko-get-val (alis val)
  (cdr (assoc val alis)))

;;Dealing with maps
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tko-get-properties (plis properties)
  (mapcar (apply-partially 'plist-get plis) properties))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(:name "cameron" :lastname "cooper)
;(:tko-pconcat :name "is of the" :lastname "clan) 
(defun tko-pconcat (plist &rest concats)
  (reduce (lambda (sum x)
	    (concat;
	     sum
	     (case (type-of x) 
	       ;;
	       ((symbol)
		(plist-get plist x))
	       ((string)
		x))))
	  concats
	  :initial-value ""))
(defun tko-interlace-lists (a b)
  (if (eq (length a) 1)
      (append a b)
    (append (list (car a) (car b)) 
	    (tko-interlace-lists (cdr a) (cdr b)))))


