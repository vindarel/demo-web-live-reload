(defpackage web-live-reload
  (:use :cl)
  (:export :start))

(in-package :web-live-reload)

(setf *config*
  '((:key "foo"
     :val "is foo")
    (:key "best language?"
     :val "Lisp")))

(defparameter *port* 7890
  "See also (start :port xxxx)")

(defparameter *server* nil)

;; Register the templates directory.
(djula:add-template-directory
 (asdf:system-relative-pathname "web-live-reload" "src/templates/"))

;; Load our template.
(defparameter +base.html+ (djula:compile-template* "base.html"))

;; Routes: /
(easy-routes:defroute root ("/" :method :get) ()
  (djula:render-template* +base.html+ nil
                          :title "Lisp web live reload example"
                          :config *config*))

(export 'start)
(defun start (&key port)
  (format t "~&Starting the web server on port ~a" (or port *port*))
  (force-output)
  (setf *server* (make-instance 'easy-routes:routes-acceptor
                                :port (or port *port*)))
  (hunchentoot:start *server*)
  (format t "~&Ready. You can access the application!~&")
  (force-output))
