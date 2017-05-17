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
(defun a-find (key list) (cdr (assoc key list))) ;
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
(defun tko-action-window (name action &optional width)
  (if (not width) (setq width +tko-action-window-width+))
    ;Create tko-window
  (tko-window-right name width)
  (with-current-buffer name
    (funcall action)))
(defun tko-message-window (message)
  (let* (;What fraction of the window the message window will take
	(+window-fraction+ 6) 
	;This actual width
	(width (/ (window-total-width)
		  +window-fraction+)))
    ;Create tko-window
    (tko-window-right "tko-window" width)
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				       
;  Constants 
;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(load "tko-window.el")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Server
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq +tko-chat-server-name+ "tko-chat-server")
(setq +tko-chat-server-buffer+ "tko-chat-server-buffer")

(setq +tko-chat-server-host+ "127.0.0.1")
(setq +tko-chat-server-port+ 9999)

(setq tko-chat-server-users '())

;;TODO remove
(setq +username+ "Tko")

(defun tko-chat-server-string-to-plist (string))
(defun tko-proc-debug-info (proc))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Clients
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq +tko-chat-client-buffer+ "tko-chat-client-buffer")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Server
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;TODO class stuff
(defun tko-chat-server-buffer (servername)
  (concat servername "-buffer"))
(defun tko-new-server (servername
		       buffer
		       host
		       port
		       sentinal
		       filter)
  `((:name . ,servername)
    (:buffer . ,buffer)
    (:host   . ,host)
    (:service . ,port)
    (:family . 'ipv4)
    (:sentinal . ,sentinal)
    (:filter . 'filter)
    (:on . 'f)

    (:start-server . lambda()
		   (make-network-process 
		    :name +tko-chat-server-name+ 
		    :buffer +tko-chat-server-buffer+ 
		    :host +tko-chat-server-host+
		    :service +tko-chat-server-port+
		    :family 'ipv4
		    :sentinal 'tko-chat-server-sentinal ;; TODO update
		    :filter 'tko-chat-server-filter ;;TODO update
		    :server 't))

(defun tko-new-chat-server (servername
			    host
			    port)
  `((:server .
	     '((:name    . ,servername)
	       (:buffer  . ,(tko-chat-server-buffer servername)
	       (:host    . ,host)
	       (:service . ,port)
	       (:family  . 'ipv4)
	       (:sentinal . 'tko-chat-server-sentinal)
	       (:filter . 'tko-chat-server-filter)))
    (:usernames . '())
    ;;Fns
    (:start-server . (lambda () ))
    (:try-login . (lambda (username) 't))
    (:login . (lambda (username)))))
		
     
(setq +tko-server-users+)
(defun tko-chat-server-start ()
  (interactive)
  (make-network-process 
   :name +tko-chat-server-name+ 
   :buffer +tko-chat-server-buffer+ 
   :host +tko-chat-server-host+
   :service +tko-chat-server-port+
   :family 'ipv4
   :sentinal 'tko-chat-server-sentinal ;; TODO update
   :filter 'tko-chat-server-filter ;;TODO update
   :server 't)
  (setq tko-chat-server-users '()))
(defun tko-chat-server-login (username))
(defun tko-chat-server-stop ()
  (delete-process +tko-chat-server-name+))
(defun tko-chat-server-send-string (msg)
  (process-send-string +tko-chat-server-name+ msg))
(defun tko-chat-server-filter (proc msg)
  (dolist (i (list
	      +tko-chat-server-buffer+
	      +tko-chat-client-buffer+))
    (with-current-buffer i
      (insert msg "\n")
      (message (concat "Server: " msg)))))
(defun tko-chat-server-sentinal (proc msg)
  (with-current-buffer +tko-chat-server-buffer+
    (insert msg "Sentinal: \n")
    (tko-proc-debug-info proc)
    (message (concat "Sentinal: " msg))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Clients
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tko-chat-client-process-name (username)
  (concat "tko-chat-client(" username ")"))

(defun tko-chat-client-send-string (username msg)
  (process-send-string (tko-chat-client-process-name username)
		       msg))

(defun tko-chat-client-connect (username host-ip host-port)
  (make-network-process 
   :name (tko-chat-client-process-name username)  
   :buffer +tko-chat-client-buffer+ 
   :host host-ip
   :service host-port
   :family 'ipv4
   :sentinal 'tko-chat-client-sentinal
   :filter 'tko-chat-client-filter
   :server nil))
  ;(tko-chat-server-send-string username))
  ;(open-network-stream
  ; "tko-chat-client"
  ; "tko-chat-client-buffer"
  ; +tko-chat-server-host+
  ; (number-to-string +tko-chat-server-port+)))
(defun tko-chat-client-send-message (username)
  (interactive)
  (let ((msg (buffer-string)))
    (erase-buffer)
    (tko-chat-client-send-string username (concat username ": " msg))))
(defun tko-chat-current-client-send-message ()
  (interactive)
  (tko-chat-client-send-message +username+))
(defun tko-chat-client-filter (proc msg)
  (with-current-buffer +tko-chat-client-buffer+ 
    (insert msg "\n")
    (message (concat "Client: " msg))))


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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Starting a message window
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Opens a buffer for sending messages, changes it so that
;; enter will send messages in that buffer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro tko-start-chat-message-window (username)
  `(let ((tko-message-buffer "tko-chat-message-buffer"))
     (tko-window-down tko-message-buffer (/ (window-total-height) 5))
     (with-current-buffer tko-message-buffer
       (tko-buffer-local-set-key [return] 'tko-chat-current-client-send-message))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Connects user and sets up full chat window
;; 
;; Opens a buffer for recieving messages,
;; Connects the user to the server
;; Opens a message buffer using the above function
;; Sends "Client has connected" message
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tko-start-chat-window (username)
  (tko-action-window +tko-chat-client-buffer+ 
   (lambda ()
     (tko-chat-client-connect username)
     (tko-start-chat-message-window username)
     (tko-chat-client-send-string username (concat username " has connected.")))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tests logging in to server, logs in as Tko
;; (or whatever +username+ is)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tko-start-chat-window-TEST ()
  (interactive)
  (tko-start-chat-window +username+))
(defun tko-start-server-and-login-TEST ()
  (interactive)
  (tko-chat-server-start)
  (tko-start-chat-window-TEST))
