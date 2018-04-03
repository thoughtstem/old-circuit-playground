#lang racket

(require "./circuit-python-base.rkt")
(require "./circuit-python.rkt")

(provide pin-write)

(declare-imports 'board 'time 'digitalio)

#;(add-setup-code
 (init-button-a)
 (init-button-b))




 