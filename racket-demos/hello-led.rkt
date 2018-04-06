#lang circuit-playground

(define speed 1)

(forever
 (pin-write output_a7 #t)
 (wait speed)
 (pin-write output_a7 #f)
 (wait speed))

(on-down touch_a1
         (set! speed 0.5))

(on-down touch_a2
         (set! speed 1))