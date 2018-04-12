#lang circuit-playground

(define angle 90)

(forever
  (print angle)
  (set-servo output-a1 angle))  

(on-down button-a
         (print "A")
         (set! angle 180))

(on-down button-b
         (print "B")
         (set! angle 0))
