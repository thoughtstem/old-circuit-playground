#lang circuit-playground

(define main-color green)

(define (flicker)
  (set-brightness (random))
  (wait (/ (random) 20))
  (set-lights main-color)
  (set-servo output-a1 90))

(define (angry)
  (repeat (int (* 12 (random)))
          (set-brightness 1)
          (set-servo output-a1 (* 180 (random)))
          (set-lights red)
          (wait 0.025)
          (set-lights black)
          (play-tone (pick-random 100 500)
                     0.1)
          (wait 0.01))
  (wait 0.5)
  (set-servo output-a1 90))

(on-start
  (play-riff jingle1)
  (set-brightness 0.5)
  (set! main-color blue)
  (set-lights main-color)
  (set-servo output-a1 90))

(forever
  (if (shake 10)
      (angry)
      (flicker)))