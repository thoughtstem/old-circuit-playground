#lang racket

(require racket/draw)


(provide rgb->hue
         name->hue
         )

(define (rgb->hue red green blue)
  (define r (/ red 255))
  (define g (/ green 255))
  (define b (/ blue 255))
  (define mx (max r g b))
  (define mn (min r g b))
  (define d (- mx mn))
  (cond
    [(= mx mn) (define h 0)
                 (exact-round (* h 42.5))]
    [(= mx r)   (define h (+ (/ (- g b) d) (if (< g b) 6 0)))
                 (exact-round (* h 42.5))]
    [(= mx g)   (define h (+ (/ (- b r) d) 2))
                 (exact-round (* h 42.5))]
    [(= mx b)   (define h (+ (/ (- r g) d) 4))
                 (exact-round (* h 42.5))]))

(define (color-lookup s)
  (define color (send the-color-database find-color s))
  (list (send color red)
        (send color green)
        (send color blue)))


(define (name->hue name)
  (rgb->hue (first (color-lookup name))
            (second (color-lookup name))
            (third (color-lookup name))))