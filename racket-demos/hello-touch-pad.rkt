#lang circuit-playground

;Global variable
(define color blue)

(forever
 (if touch_a1 ;You can check a button val whenever you want....
     (set-lights green)
     (set-lights color)))

;Or you can register an event to happen when a button
; val changes...
(on-down touch_a7
         (set! color red))
