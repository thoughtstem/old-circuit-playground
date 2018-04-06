#lang racket

(require "../api/main.rkt")

;TODO:
;  Analog pin down/up events
;  Reenable sound.  Memory allocation error!

;SETUP
(define (setup)
 (set state.memory.team-color blue)
 (set state.memory.ammo       3)
 (play-riff jingle1))

(define (flash-effect c1 c2)
  (repeat 4
          (set-lights c1)
          (wait 0.20)
          (set-lights c2)
          (wait 0.20)))

;FUNCTIONS
(on-ir n
       (if (= n 5)
           (begin
             (print "GOT SIGNAL...")
             (set state.memory.team-color green))
           #f)) 

;MAIN FUNCTION
(define (update)
  (if (= 0 (get state.memory.ammo))
      (flash-effect white black)
      (if (get state.hardware.BUTTON_A)       
          (begin
            (set state.memory.ammo
                 (- (get state.memory.ammo)
                    1))
            (flash-effect red orange)
            (send-ir 5))
          (set-lights (get state.memory.team-color)))))

(run) ;WART!




