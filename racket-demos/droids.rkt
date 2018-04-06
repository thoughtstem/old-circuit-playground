#lang circuit-playground

;TODO:
;  All tech is working.  
;  Go back through all examples.  Make sure all tech works.
;  Resolve the pin i/o dichotomy
;  Get servos to not cause delay
;  Shrink code as much as possible
;  Error reporting
;  Shipping new firmware with github repo / racket package?
;  Get working on Chromebooks

(define (flicker)
  (set-brightness (random))
  (wait (/ (random) 20))
  (set-lights (get state.memory.main-color))
  (set-servo 'board.A1  ;Wart!
             90
             0.05))


(define (angry)
  (repeat (int (* 12 (random)))
          #;(set-servo 'board.A1   ;Ugh... I want to be able to not have the timeout baked in...
                     (pick-random 45 90)
                     0.5)
          (set-brightness 1)
          (set-lights red)
          (wait 0.025)
          #;(set-servo 'board.A1
                     (pick-random 90 135)
                     0.5)
          (set-lights black)
          (play-tone (pick-random 100 500)
                     0.1)
          (wait 0.01))
  (wait 0.5)
  (set-servo 'board.A1  ;Wart!
             90
             0.05))


(define (setup)
  (play-riff jingle1)
  (set-brightness 0.5)
  (set state.memory.main-color blue)
  (set-lights (get state.memory.main-color))
  (set-servo 'board.A1  ;Wart!
             90
             1))

;MAIN FUNCTION
(define (update)
  (if (shake 10)
      (angry)
      (flicker)))




(run) ;WART!

