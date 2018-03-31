#lang racket

(require "../api/main.rkt")

;SETUP
(define (setup)
 (set state.memory.color
      (->rgb "blue")))

(define (update)
 (set-lights
  (get state.memory.color)))

;EVENTS
(on-down BUTTON_A
         (set state.memory.color (->rgb "red")))

(on-down BUTTON_B
         (set state.memory.color (->rgb "green")))




(run) ;WART!

