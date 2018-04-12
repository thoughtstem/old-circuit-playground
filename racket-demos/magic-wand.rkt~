#lang circuit-playground

(define (fx1 c1 c2)
  (set-light 0 c1)
  (set-light 1 c1)
  (set-light 2 c1)
  (set-light 3 c1)
  (set-light 4 c1)
  (set-light 5 c2)
  (set-light 6 c2)
  (set-light 7 c2)
  (set-light 8 c2)
  (set-light 9 c2))

(forever
 (fx1 red blue)
 (wait 0.5)
 (fx1 blue red)
 (wait 0.5))

