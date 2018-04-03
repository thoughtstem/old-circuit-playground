#lang racket

(require "../api/main.rkt")

;TODO:
;  Analog pin down/up events
;  Reenable sound.  Memory allocation error!

;SETUP
(define (setup)
  ;(pin-write PIN_A7 #t)
 )

;MAIN FUNCTION
(define (update)
;  (pin-write PIN_D13 #f)
;  (wait 1)
;  (pin-write PIN_D13 #t)
;  (wait 1)
 )

(on-down PIN_A4
         (play-tone 0.1 G4)
         (play-tone 0.1 C5)
         (pin-write PIN_A7 #t))

(on-down PIN_A5
         (play-tone 0.1 G4)
         (play-tone 0.1 C5)
         (pin-write PIN_A7 #f))

(on-down PIN_A6
         (repeat 10
                 (pin-write PIN_A7 #t)
                 (play-tone 0.1 C5)
                 (pin-write PIN_A7 #f)
                 (play-tone 0.1 C4)))

(on-down PIN_A1
         (loop n 100
               (play-tone 0.05 (* 2 (+ 200 n)))
               (print (* 2 (+ 200 n)))
               ;(wait 0.5)
               ;(set-brigtness random...)
               ;(set-lights green)
               ))

(run) ;WART!

