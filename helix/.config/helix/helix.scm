;; Register and Configure CodeSnap
(require (only-in "codesnap/codesnap.scm" codesnap codesnap-configure!))
(require (only-in "codesnap/codesnap-menu.scm" codesnap-menu))

(codesnap-configure! #:theme "Dracula"
                     #:shadow-blur 15
                     #:show-title? #t
                     #:clipboard-command "wl-copy -t image/png <")

(provide codesnap codesnap-menu)
