#lang racket

(require "../api/main.rkt")

#;(define (flickerrr)
  (set-brightness (random))
  (wait (/ (random) 20))
  (set-lights (get state.memory.main-color))
  (set-servo 'board.A1  ;Wart!
             90
             0.05))

(define (temp)
  (print "hello")
  #;(print "hello"))

(define (angry)
  (repeat (int (* 12 random))
          (set-servo 'board.A1
                     (pick-random 45 90)
                     0.5)
          (set-brightness 1)
          (set-lights red)
          (wait 0.05)
          (set-servo 'board.A1
                     (pick-random 90 135)
                     0.5)
          (set-lights black)
          (play-tone (pick-random 100 500)
                     0.25)
          (play-tone REST
                     0.25)
          (wait 0.05))
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
  #;(if (shake 10)
      (angry)
      (flicker)))




(run) ;WART!

