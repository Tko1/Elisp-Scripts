;I dunno wtf this will all be fr
(require 'cl-lib)
(defun tko-range (start &optional end step)
  (unless end 
    (setq end start
	  start 0))
  (number-sequence start end step))
(defun tko-comment-line (width)
  (insert "/")
  (dotimes (i width) (insert "*"))
  (insert "/"))
(defun tko-window (width)
  (let ( (buffer (get-buffer-create "tko-window"))
	 (window (split-window-right (- width))))
    (set-window-buffer window buffer)))

(defun tko-message-window ()
  (let* (;What fraction of the window the message window will take
	(+window-fraction+ 6) 
	;This actual width
	(width (/ (window-total-width)
		  +window-fraction+)))
    ;Create tko-window
    (tko-window width)))
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
      
    )

;    (save-current-buffer
;      (set-window-buffer window buffer)
;      (set-buffer buffer)
;      (insert-text-button "Light fire")
; (read-only-mod))))
;;Game
(defun tko-start-game ()
  ;Open window to right of screen for game
   (let* (;Constants
	  (+game-window-width-divider 6)  
	  (+game-window-name+ "tko-window")
	  
	  (buffer (make-buffer-in-window-fraction-of-screen 
	   :name +game-window-name+ 
	   :frac 6)) 
	  (oldbuffer (current-buffer)) 
	  (buffer (get-buffer-create +game-window-name+))
	  (window (split-window-right (- width))))
     
     
    
)
(defun ask-name-and-age (x y)
  "Ask name and age"
  (interactive "sEnter you name:
nEnter your age: ")
  (message "Name is: %s, Age is: %d" x y))
;(defvar tko-mode-map
;  (let ((map (make-keymap)))
;    (define-key map "
