#lang circuit-playground

(define lights-on #f)
(define thresh 100)

(forever
 (if lights-on
     (set-lights green)
     (set-lights black))
 (if (< (light-level) thresh)
     (set! lights-on #t)
     #f))