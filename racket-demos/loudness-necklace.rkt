#lang circuit-playground

(define (show-volume level)
  (set-lights black)
  (loop n level
        (set-light n red)))

(forever
 (show-volume (mic-level)))