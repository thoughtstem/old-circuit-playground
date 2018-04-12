#lang racket

(require "./circuit-python-base.rkt")
(require "./circuit-python.rkt")

(provide  on-down
          button_a
          button_b
          button-a
          button-b
          test
          touch-a1
          touch-a2
          touch-a3
          touch-a4
          touch-a5
          touch-a6
          touch-a7
          touch_a1
          touch_a2
          touch_a3
          touch_a4
          touch_a5
          touch_a6
          touch_a7)

(declare-imports 'board 'time 'digitalio 'touchio 'express)

(define test 42)

(define button_a 'express.cpx.button_a)
(define button_b 'express.cpx.button_b)

(define button-a 'express.cpx.button_a)
(define button-b 'express.cpx.button_b)

(define touch-a1 'express.cpx.touch_A1)
(define touch-a2 'express.cpx.touch_A2)
(define touch-a3 'express.cpx.touch_A3)
(define touch-a4 'express.cpx.touch_A4)
(define touch-a5 'express.cpx.touch_A5)
(define touch-a6 'express.cpx.touch_A6)
(define touch-a7 'express.cpx.touch_A7)

(define touch_a1 'express.cpx.touch_A1)
(define touch_a2 'express.cpx.touch_A2)
(define touch_a3 'express.cpx.touch_A3)
(define touch_a4 'express.cpx.touch_A4)
(define touch_a5 'express.cpx.touch_A5)
(define touch_a6 'express.cpx.touch_A6)
(define touch_a7 'express.cpx.touch_A7)



(define-syntax (on-down stx)
  (syntax-case stx ()
    [(_ b lines ...)
     (with-syntax ([p (string->symbol (format "~a_prev"  (syntax->datum #'b)))])
       #`(add-main-loop-code-begin `(if ,b
                                        (do
                                            ,lines ...))))]))




 