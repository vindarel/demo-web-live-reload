
(asdf:defsystem "web-live-reload"
  :depends-on (:hunchentoot
               :swank
               :easy-routes
               :djula)
  :description "Simple example on how a lisp web app can be modified as it runs."
  :components ((:module "src"
                        :components
                        ((:file "web")))))
