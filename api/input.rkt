#lang racket

(require "./circuit-python-base.rkt")
(require "./circuit-python.rkt")

(provide  on-down
          on-up
          button_a
          button_b
          touch_a1
          touch_a2
          touch_a3
          touch_a4
          touch_a5
          touch_a6
          touch_a7)

(declare-imports 'board 'time 'digitalio 'touchio 'express)

(define button_a 'express.cpx.button_a)
(define button_b 'express.cpx.button_b)

(define touch_a1 'express.cpx.touch_A1)
(define touch_a2 'express.cpx.touch_A2)
(define touch_a3 'express.cpx.touch_A3)
(define touch_a4 'express.cpx.touch_A4)
(define touch_a5 'express.cpx.touch_A5)
(define touch_a6 'express.cpx.touch_A6)
(define touch_a7 'express.cpx.touch_A7)

(define (cache-touch-val tval)
  (define prev_val    (string->symbol (format "touch_~a_prev" tval)))
  (define current_val (string->symbol (format "express.cpx.touch_~a" (string-upcase (~a tval)))))
  (define hidden_val  (string->symbol (format "express.cpx._touch_~a" (string-upcase (~a tval)))))
  (define deinit      (string->symbol (format "express.cpx._touch_~a.deinit" (string-upcase (~a tval)))))
  `(do
     (if (not (= ,prev_val "DISABLE"))
         (setv ,prev_val ,current_val)
         #;(print "Disabled current_val"))
     ))

;For when we need to disable input pins, for doing output.  E.g. servo writes and pwm...
(define-syntax (enable-touch stx)
  (syntax-case stx ()
    [(_ pin)
     (with-syntax ([touch_p_prev (string->symbol (format "touch_~a_prev"  (syntax->datum #'pin)))]
                   [enable-touch-p (string->symbol (format "enable-touch-~a"  (syntax->datum #'pin)))]
                   [deinit (string->symbol (format "express.cpx._touch_~a.deinit" (string-upcase (symbol->string (syntax->datum #'pin)))))]
                   [hidden_val (string->symbol (format "express.cpx._touch_~a" (string-upcase (symbol->string (syntax->datum #'pin)))))])
       #`(define-function (enable-touch-p yn)
           '(global touch_p_prev)
           '(if (not yn)
                (do
                    (if hidden_val
                        (do
                          (deinit)
                          (setv hidden_val None)))
                  (setv touch_p_prev "DISABLE"))
                (setv touch_p_prev #f))))]
    [(_ pins ...)
     (with-syntax ()
       #`(begin
           (enable-touch pins)
           ...))]))


(enable-touch a1 a2 a3 a4 a5 a6 a7)


(define-function (update-buttons)
  '(global button_a_prev)
  '(global button_b_prev)
  '(global touch_a1_prev)
  '(global touch_a2_prev)
  '(global touch_a3_prev)
  '(global touch_a4_prev)
  '(global touch_a5_prev)
  '(global touch_a6_prev)
  '(global touch_a7_prev)
  '(setv button_a_prev express.cpx.button_a)
  '(setv button_b_prev express.cpx.button_b)
  
  (cache-touch-val 'a1)
  (cache-touch-val 'a2)
  (cache-touch-val 'a3)
  (cache-touch-val 'a4)
  (cache-touch-val 'a5)
  (cache-touch-val 'a6)
  (cache-touch-val 'a7))

(add-setup-code
  '(setv button_a_prev #f)
  '(setv button_b_prev #f)
  '(setv touch_a1_prev #f)
  '(setv touch_a2_prev #f)
  '(setv touch_a3_prev #f)
  '(setv touch_a4_prev #f)
  '(setv touch_a5_prev #f)
  '(setv touch_a6_prev #f)
  '(setv touch_a7_prev #f))
  

(add-main-loop-code-end
 (update-buttons))


(define-syntax (on-down stx)
  (syntax-case stx ()
    [(_ b lines ...)
     (with-syntax ([p (string->symbol (format "~a_prev"  (syntax->datum #'b)))])
       #`(add-main-loop-code-begin `(if (not (= ,b p))
                                        (if ,b
                                            (do
                                                ,lines ...)))))]))

(define-syntax (on-up stx)
  (syntax-case stx ()
    [(_ b lines ...)
     (with-syntax ([p (string->symbol (format "~a_prev" (syntax->datum #'b)))])
       #`(add-main-loop-code-begin `(if (not (= ,b p))
                                        (if (not ,b)
                                            (do
                                                ,lines ...)))))]))




 