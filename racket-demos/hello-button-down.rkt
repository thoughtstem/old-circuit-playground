#lang circuit-playground

(define color blue)

;SETUP 
(on-start
 (set! color pink))

(forever
 (set-lights color))

;EVENTS
#;(on-down BUTTON_A
         (set state.memory.color (->rgb "red")))

#;(on-down BUTTON_B
         (set state.memory.color (->rgb "green")))

