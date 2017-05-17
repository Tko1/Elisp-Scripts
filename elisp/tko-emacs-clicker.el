;; Tkg - Tko graphics
(defun tkg-insert-clickable-text-button (text action)
  (insert-text-button text 'follow-link 't 'action action))

(defun tkec-game (cookies)
  `(:cookies ,cookies))

(defun tkec-render (obj))

(defun tkec-add-buffer-data (data name))
