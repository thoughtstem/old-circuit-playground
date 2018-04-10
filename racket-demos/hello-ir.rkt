#lang circuit-playground

(define color green)

(on-start
 (play-riff jingle1))

(on-ir n
       (if (= n 5)
           (begin
             (print "GOT SIGNAL...")
             (set! color red))
           #f)) 

(on-down button_a
         (set-lights blue)
         (send-ir 5)
         (set-lights green))

(forever
 (set-lights color))
