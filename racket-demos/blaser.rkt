#lang racket

(require "../api/main.rkt")

;TODO:
;  Analog pin down/up events
;  Reenable sound.  Memory allocation error!

;SETUP
(define (setup)
 (set state.memory.team-color (->rgb "blue")))

;FUNCTIONS
(on-ir n
       (if (= n 5)
           (begin
             (print "GOT SIGNAL...")
             (set state.memory.team-color
                  (->rgb "green")))
           #f)) 

;MAIN FUNCTION
(define (update)
  (if 'BUTTON_A.value       ;WART: (get state.hardware.BUTTON_A)
      (begin
        (print "Shooting")
        (set-lights (->rgb "red"))
        ;'(hardware-update state)
        (send-ir 5)
        (print "DONE SHOOTING"))
      (set-lights (get state.memory.team-color))))

(run) ;WART!




