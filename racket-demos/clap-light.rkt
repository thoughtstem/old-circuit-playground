#lang circuit-playground

(define on-color white)
(define off-color black)
(define lights #t)

(define (toggle-lights)
  (set! lights (not lights))
  (wait 1))

(define (show-lights)
  (if lights
      (set-lights on-color)
      (set-lights off-color)))

(forever
 (if (>= (mic-level) 5)
     (toggle-lights)
     #f)
 (show-lights))