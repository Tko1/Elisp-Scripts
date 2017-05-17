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
;  int(b) ass(n) = def(b);
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

;;(load "tko-window.el")
(setq +tko-chat-server-port+ 9999)
(setq +tko-chat-server-host+ "127.0.0.1")


(setq +username+ "Tko")
(defun tko-chat-server-start () 
  (make-network-process 
   :name "tko-chat-server" 
   :buffer "tko-chat-server-buffer" 
   :host +tko-chat-server-host+
   :service +tko-chat-server-port+
   :family 'ipv4
   :sentinal 'tko-server-sentinal
   :filter 'tko-server-filter
   :server 't)
  (setq tko-server-clients '()))
(defun tko-chat-client-connect ()
  (make-network-process 
   :name "tko-chat-client" 
   :buffer "tko-chat-buffer" 
   :host +tko-chat-server-host+
   :service +tko-chat-server-port+
   :family 'ipv4
   :sentinal 'tko-char-server-sentinal
   :filter 'tko-chat-client-filter
   :server nil)
)
  ;(open-network-stream
  ; "tko-chat-client"
  ; "tko-chat-client-buffer"
  ; +tko-chat-server-host+
  ; (number-to-string +tko-chat-server-port+)))
(defun tko-chat-client-send-string (msg)
  (process-send-string "tko-chat-client" (concat msg " Sending message to client"))
  (process-send-string "tko-chat-server" "Sending msg to server"))
(defun tko-chat-client-send-message ()
  (interactive)
  (let ((msg (buffer-string)))
    (erase-buffer)
    (tko-chat-client-send-string (concat +username+ ": " msg))))
(defun tko-chat-client-filter (proc msg)
  (with-current-buffer "tko-chat-buffer"
    (insert msg "\n")
    (message (concat "Client: " msg))))
(defun tko-chat-server-stop ()
  (delete-process "tko-chat-server"))
(defun tko-server-filter (proc msg)
  (with-current-buffer "tko-chat-server-buffer"
    (insert msg "\n")
    (message (concat "Server: " msg))))
(defun tko-server-sentinal (proc msg)
  (with-current-buffer "tko-chat-server-buffer"
    (insert msg "\n")
    (message (concat "Sentinal: " msg))))

(defun tko-buffer-local-set-key (key func)
      (interactive "KSet key on this buffer: \naCommand: ")
      (let ((name (format "%s-magic" (buffer-name))))
        (eval
         `(define-minor-mode ,(intern name)
            "Automagically built minor mode to define buffer-local keys."))
        (let* ((mapname (format "%s-map" name))
               (map (intern mapname)))
          (unless (boundp (intern mapname))
            (set map (make-sparse-keymap)))
          (eval
           `(define-key ,map ,key func)))
        (funcall (intern name) t)))
(defun tko-start-chat-message-window ()
  (tko-window-down "tko-chat-message-buffer" (/ (window-total-height) 5))
  (with-current-buffer "tko-chat-message-buffer"
    (tko-buffer-local-set-key [return] 'tko-chat-client-send-message)))
(defun tko-start-chat-window ()
  (tko-action-window "tko-chat-buffer" 
   (lambda ()
     (tko-chat-client-connect)
     (tko-start-chat-message-window)
     (insert "Client has connected\n"))))
