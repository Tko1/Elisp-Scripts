(defun tko-insert-clickable-text-button (text action)
   (insert-text-button text 'follow-link 't 'action action))

;(tko-insert-clickable-text-button "This is a test" (lambda (x) (message "This i;s a test")))
