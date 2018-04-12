#lang circuit-playground

(define rainbow-step 0)
(define rainbow-speed 10)
(define rainbow-dist 10)
(define sparkle-time 150)

(define (rainbow)
  (set-light 0 (color-from-hue (+ rainbow-step (* 0 rainbow-dist))))
  (set-light 1 (color-from-hue (+ rainbow-step (* 1 rainbow-dist))))
  (set-light 2 (color-from-hue (+ rainbow-step (* 2 rainbow-dist))))
  (set-light 3 (color-from-hue (+ rainbow-step (* 3 rainbow-dist))))
  (set-light 4 (color-from-hue (+ rainbow-step (* 4 rainbow-dist))))
  (set-light 5 (color-from-hue (+ rainbow-step (* 5 rainbow-dist))))
  (set-light 6 (color-from-hue (+ rainbow-step (* 6 rainbow-dist))))
  (set-light 7 (color-from-hue (+ rainbow-step (* 7 rainbow-dist))))
  (set-light 8 (color-from-hue (+ rainbow-step (* 8 rainbow-dist))))
  (set-light 9 (color-from-hue (+ rainbow-step (* 9 rainbow-dist))))
  (set! rainbow-step (% (+ rainbow-speed rainbow-step) 255)))

(define (sparkles)
  (repeat sparkle-time
          (set-lights black)
          (set-light (pick-random 0 10) white)))

(forever
 (if (shake 15)
     (sparkles)
     (rainbow))) 