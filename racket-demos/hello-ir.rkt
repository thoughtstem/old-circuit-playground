#lang circuit-playground

(define color green)
(define my-team 2)
(define other-team 1)

(on-start
 (play-riff jingle1))

(on-ir n
       (if (= n other-team)
           (set! color red)
           #f)) 

(on-down button_a
         (set-lights blue)
         (play-riff jingle1)
         (send-ir my-team)
         (set-lights green))

(forever
 (set-lights color))
