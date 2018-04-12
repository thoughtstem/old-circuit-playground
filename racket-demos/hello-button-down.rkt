#lang circuit-playground

(define color blue)

(forever
 (if button-b 
     (set-lights green)
     (set-lights color)))

(on-down button-a
         (set! color red))