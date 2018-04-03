#lang racket

(require "./circuit-python-base.rkt")
(require "./circuit-python.rkt")
(require (for-syntax racket/syntax))

(provide pin-write)

(declare-imports 'board 'time 'digitalio)

(define-function (pin-write pin val)
  `(print val)
  `(setv p (digitalio.DigitalInOut pin))
  `(setv p.direction digitalio.Direction.OUTPUT)
  `(setv p.value val))

(define-syntax (define-pin stx)
  (syntax-case stx ()
    [(_ name)
     (with-syntax ([pin-name (format-id stx "PIN_~a" #'name)]
                   [board-name (string->symbol
                                (format "board.~a" (syntax->datum #'name)))])
       #`(begin (define pin-name 'board-name)
                (provide pin-name)))]))

(define-syntax (define-pins stx)
  (syntax-case stx ()
    [(_ names ...)
     (with-syntax ()
       #`(begin (define-pin names)
                ...))]))

(define-pins
  A1
  A2
  A3
  A4
  A5
  A6
  A7)

 