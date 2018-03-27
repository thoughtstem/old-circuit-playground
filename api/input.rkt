#lang racket

(require "./circuit-python-base.rkt")
(require "./circuit-python.rkt")

(provide  on-down
          on-up)

(declare-imports 'board 'time 'digitalio)

(add-setup-code
 '(setv BUTTON_A (digitalio.DigitalInOut board.BUTTON_A))
 '(setv BUTTON_A.direction digitalio.Direction.INPUT)
 '(setv BUTTON_A.pull digitalio.Pull.DOWN)
 '(setv BUTTON_A_prev BUTTON_A.value ))


(add-main-loop-code-end
 '(setv BUTTON_A_prev BUTTON_A.value))


(define-syntax (on-down stx)
  (syntax-case stx ()
    [(_ b lines ...)
     (with-syntax ([v (string->symbol (format "~a.value" (syntax->datum #'b)))]
                   [p (string->symbol (format "~a_prev" (syntax->datum #'b)))])
       #`(add-main-loop-code-begin `(if (not (= v p))
                                        (if v
                                            ,lines ...))))]))

(define-syntax (on-up stx)
  (syntax-case stx ()
    [(_ b lines ...)
     (with-syntax ([v (string->symbol (format "~a.value" (syntax->datum #'b)))]
                   [p (string->symbol (format "~a_prev" (syntax->datum #'b)))])
       #`(add-main-loop-code-begin `(if (not (= v p))
                                        (if (not v)
                                            ,lines ...))))]))





;Detect button down, button up, and button down/up (click)

;Make sure this works with the analog pins too...


 