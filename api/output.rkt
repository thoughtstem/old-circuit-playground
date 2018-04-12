#lang racket

(require "./circuit-python-base.rkt")
(require "./circuit-python.rkt")
(require (for-syntax racket/syntax))
(require (for-syntax racket))


(provide pin-write)

(declare-imports 'board 'time 'digitalio)

(define-function (pin-write-f pin val)
  `(setv p (digitalio.DigitalInOut pin))
  `(setv p.direction digitalio.Direction.OUTPUT)
  `(setv p.value val))


(define-syntax (pin-write stx)
  (syntax-case stx ()
    [(_ output_p val)
     (with-syntax* ([p (string->symbol
                        (second
                         (string-split
                          (format "~a"
                                  (syntax->datum #'output_p))
                          "-")))]
                    [cap_p (string->symbol
                            (format "board.~a"
                                    (string->symbol
                                     (string-upcase
                                      (symbol->string
                                       (syntax->datum #'p))))))]
                    [p-num (string->number (substring (symbol->string (syntax->datum #'p)) 1))])
       #`(list 'do
             ;  `(enable-touch p-num #f)
               `(pin-write-f cap_p ,val)))]))




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

 