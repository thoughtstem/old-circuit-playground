#lang racket

(require (for-syntax racket))
(require (for-syntax racket/syntax))

(require "./circuit-python-base.rkt")
(require "./circuit-python.rkt")

(provide set-servo)

(declare-imports 'board 'pulseio 'servo)

(add-setup-code
 '(setv output-pins [hy-SQUARE ])
 '(setv pwms        [hy-SQUARE ]))

(define-function (get-pwm pin)
  '(if (in pin output-pins)
       (fetch-existing-pwm pin)
       (create-new-pwm pin)))

(define-function (fetch-existing-pwm pin)
  '(setv i (output-pins.index pin))
  '(hy-DOT pwms [hy-SQUARE i]))

(define-function (create-new-pwm pin)
  '(setv pwm (pulseio.PWMOut
              pin             
              :frequency 50))
  '(pwms.append pwm)
  '(output-pins.append pin)
  'pwm)

(define-function (free-servo-pin pin)
  '(setv i (output-pins.index pin))
  '(pwms.pop i)
  '(output-pins.pop i))

(define-function (set-servo-f pin angle)
  `(setv pwm (get-pwm pin))
  `(setv s   (servo.Servo pwm))
  `(setv s.angle angle))


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
                    [p-num (string->number (substring (symbol->string (syntax->datum #'p)) 1))])
       #`(list 'do
              ; `(enable-touch p-num #f)
               `(set-servo-f cap_p ,angle)
           ))]))
