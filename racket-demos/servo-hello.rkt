#lang circuit-playground

(define angle 90)

(forever
  (set-servo output_a1 angle))  

(on-down button_a
         (set! angle 180))

(on-down button_b
         (set! angle 0))

(on-down touch_a7
         (set! angle 90))