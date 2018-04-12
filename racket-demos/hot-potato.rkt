#lang circuit-playground

(define delay 10)

(on-down button-a
         (set! delay (+ 20 (pick-random 0 10)))
         (set-lights green)
         (while (< 0 delay)
                (set! delay (- delay 1))
                (play-tone A5 0.1)
                (wait (min 10 (/ delay 5))))
         (play-tone G4 0.5)
         (set-lights red))   