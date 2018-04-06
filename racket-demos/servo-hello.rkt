#lang circuit-playground

;Also do a demo of digital write....

(define angle 90)

(forever
 (set-servo output_a1 angle))  ;;Broken because set-servo isn't idempotent...  Pin in use on next frame

#;(on-down button_a
         (set! angle 0))

#;(on-down button_b
         (set! angle 90))
