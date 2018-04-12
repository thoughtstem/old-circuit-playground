#lang circuit-playground

(define angle 90)

(forever
  (print angle)
  (set-servo output_a1 angle))  

(on-down button_a
         (print "A")
         (set! angle 180))

(on-down button_b
         (print "B")
         (set! angle 0))

(on-down touch_a7
         (set! angle 90))