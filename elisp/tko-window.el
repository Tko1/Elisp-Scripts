;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				       
;  Constants 
;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq +tko-action-window-divider+
      4)
(setq +tko-action-window-width+
      (/ (window-total-width) 
	 +tko-action-window-divider+))
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;todo move ot utils
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun a-find (key list) (cdr (assoc key list)))
(defun tko-window (name size dir)
  (let* ((buffer        (get-buffer-create name))
	 (dir-lookup    '(("left"  . left)
			  ("right" . right)
			  ("up"    . above)
			  ("down"  . below)
			  ("above" . above)
			  ("below"  . below)))
	 (dir-sym       (a-find dir dir-lookup))
  ;Create window
	 (window        (split-window (selected-window) (- size) dir-sym)))
  
    (message (symbol-name dir-sym))
   ;fuuu-sion HA
   (set-window-buffer window buffer)))

;Creates::
;(tko-wind:ow-up)
;(tko-window-left)
;(tko-window-right)
;(tko-window-down)
(dolist (dir (list "up" "down" "left" "right"))
  (let* ((tko-window-fn-name (concat "tko-window-" dir))
	 (tko-window-fn      (intern tko-window-fn-name)))
    (eval `(defun ,tko-window-fn (name h-or-w)
	     (tko-window name h-or-w ,dir)))))
    
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; struct  default(button)
; {
;  int(b) as(n) = def(b);
;  add var(button)
; }
; Generate_code(button)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tko-struct-window ()
  (let((tko-window-right "tko-struct-window"))))
(defun tko-action-window (name action)
  (let* ((width +tko-action-window-width+))
    ;Create tko-window
    (tko-window-right name width)
    (with-current-buffer name
      (funcall action)
    )))

(defun tko-message-window (message)
  (let* (;What fraction of the window the message window will take
	(+window-fraction+ 6) 
	;This actual width
	(width (/ (window-total-width)
		  +window-fraction+)))
    ;Create tko-window
    (tko-window-right width)
    (with-current-buffer "tko-window"
      )
    ))
(cl-defun make-buffer-in-window-fraction-of-screen (&key (name "tko-window") (frac 1))
  (let* ( (oldbuffer (current-buffer)) 
	  (buffer (get-buffer-create name))
	  (width (/ (window-total-width)
		    frac)))
    (split-window-right (- width))
    buffer))

(defun make-game-window ()
  ;Make buffer and window
  (let* ( (buffer (make-buffer-in-window-fraction-of-screen
		   :name "tko-window"
		   :frac 6)))
    ;;Setup buffer
    (with-current-buffer buffer
    
    )))
