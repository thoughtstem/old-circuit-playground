#lang racket

(require "../api/main.rkt")

;TODO:
;  Analog pin down/up events
;  Reenable sound.  Memory allocation error!

;SETUP
(add-setup-code
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
(define-function (update)
  (if 'BUTTON_A.value       ;WART: (get state.hardware.BUTTON_A)
      (begin
        (print "Shooting")
        (set-lights (->rgb "red"))
        ;'(hardware-update state)
        (send-ir 5))
      (set-lights (get state.memory.team-color))))

(run) ;WART!




