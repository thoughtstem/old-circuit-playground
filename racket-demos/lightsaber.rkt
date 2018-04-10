#lang circuit-playground

;SETUP
(define color green)
(define blade-on #f)


;FUNCTIONS
(define (blade-on-effect)
  (loop n 10
        (set-light n color)
        (wait 0.05))
  (set! blade-on #t))

(define (blade-off-effect)
  (loop n 10
        (set-light n black)
        (wait 0.025))
  (set! blade-on #f))


(define (flicker-fx)
  (set-lights (dim-color-by
               color
               (pick-random 0 255))))


(define (clash-fx)
  (play-tone G4 0.1)
  (play-tone A4 0.05)
  (repeat 2
          (set-lights white)
          (wait 0.2)
          (set-lights red)
          (wait 0.2)))


(define (loud-noise)
  (< 5 (mic-level)))


;MAIN FUNCTION
(forever
  (if blade-on
      (if (loud-noise)
          (clash-fx)
          (flicker-fx))
      (set-lights black)))


;EVENTS
(on-down button_a
         (if blade-on
             (blade-off-effect)
             (blade-on-effect)))





