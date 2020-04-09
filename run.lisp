
(load "project.asd")

(ql:quickload "web-live-reload")

(format t "package: ~a~&" *package*)
(in-package :web-live-reload)
(start)
(format t "package: ~a~&" *package*)
