#lang racket

(require (for-syntax racket))
(require (for-syntax racket/syntax))

(require "./circuit-python-base.rkt")
(require "./circuit-python.rkt")

(provide set-servo)

(declare-imports 'board 'pulseio 'servo)


(define-function (set-servo-f pin angle)
  `(setv pwm (pulseio.PWMOut
              pin             
              :frequency 50))
  `(setv s   (servo.Servo pwm))
  `(setv s.angle angle)
  )


(define-syntax (set-servo stx)
  (syntax-case stx ()
    [(_ output_p angle)
     (with-syntax* ([p (string->symbol
                        (second
                         (string-split
                          (format "~a"
                                  (syntax->datum #'output_p))
                          "_")))]
                    [cap_p (string->symbol
                            (format "board.~a"
                                    (string->symbol
                                     (string-upcase
                                      (symbol->string
                                       (syntax->datum #'p))))))]
                    [enable-pin-p (format-id stx "enable-pin-~a"  (syntax->datum #'p))])
       #`(begin
           `(enable-pin-p #f)
           `(set-servo-f cap_p ,angle)
           ))]))
