#lang racket

(require "../api/main.rkt")

;SETUP
(add-setup-code
 (set state.memory.color (->rgb "green"))
 (set state.memory.blade-on #f))

;EVENTS
(on-down BUTTON_A
         (set state.memory.blade-on
              (not (get state.memory.blade-on))))


;FUNCTIONS
(define-function (flicker-fx)
  (set-lights (dim-color-by
               (get state.memory.color)
               (pick-random 0 255))))


(define-function (clash-fx)
  (play-tone 0.1 G4)
  (play-tone 0.05 A3)
  (repeat 2
          (set-lights (->rgb "white"))
          (wait 0.2)
          (set-lights (->rgb "red"))
          (wait 0.2)))

(define-function (loud-noise)
  (< 5
     (get state.hardware.mic-level)))


;MAIN FUNCTION
(define-function (update)
  (if (get state.memory.blade-on)
      (if (loud-noise)
          (clash-fx)
          (flicker-fx))
      (set-lights (->rgb "black"))))




(run) ;WART!




