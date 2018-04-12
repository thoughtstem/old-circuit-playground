#lang circuit-playground

;SETUP
(define beam-start #f)

(define (flash c1 c2)
  (repeat 10
          (set-brightness (random))
          (set-lights c1)
          (play-tone (+ 100 (* 300 (random))) 0.08)
          (set-lights c2)
          (play-tone (+ 100 (* 300 (random))) 0.08)))

(define (destroy-effect)
  (flash red white)
  (flash orange yellow)
  (set-lights black))

;MAIN FUNCTION
(forever
  (if (shake 15)
      (destroy-effect)
      #f))

(on-down touch-a4
         (set-lights green)
         (play-tone G4 0.1)
         (play-tone C5 0.1)
         (pin-write output-a7 #t))

(on-down touch-a5
         (set-lights red)
         (play-tone G4 0.1)
         (play-tone C5 0.1)
         (pin-write output-a7 #f))

(on-down touch-a6
         (repeat 10
                 (pin-write output-a7 #t)
                 (play-tone C5 0.1)
                 (pin-write output-a7 #f)
                 (play-tone C4 0.1)))

(on-down touch-a3
         (loop n 100
                 (play-tone (* 2 (+ 200 n)) 0.05)
                 (set-brightness (random))  
                 (set-lights green))
         (play-riff jingle1)
         (set! beam-start #t))

(on-down touch-a1
         (if beam-start
             (begin
               (play-riff jingle1)
               (loop n 10
                       (set-light n black)
                       (wait 0.25)))
             #f))


