#lang circuit-playground

(define speed 1)

(forever
 (pin-write output-a7 #t)
 (wait speed)
 (pin-write output-a7 #f)
 (wait speed))

(on-down touch-a1
         (set! speed 0.1))

(on-down touch-a2
         (set! speed 1))



