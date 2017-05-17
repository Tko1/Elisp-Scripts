(require 'cl-lib)
(load "tko-utils.el")


(defun idn-create-java-class (name)
  (interactive "sEnter a name:")
  (insert 
   (concat "public class " name "\n"
	   "{\n"
	   "  public static void main(String[] args)\n"
	   "  {\n"
           "  }\n"
           "}\n")))
