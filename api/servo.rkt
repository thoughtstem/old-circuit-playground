#lang racket

(require "./circuit-python-base.rkt")
(require "./circuit-python.rkt")

(provide set-servo)

(declare-imports 'board 'pulseio 'servo)

(define-function (deinit-pin pin)
  `(if (= pin board.A1)
       (do (express.cpx._touch_A1.deinit)  ;FUCKING GROSS.  Shouldn't be messing with touch stuff in servo lib...
           (setv express.cpx._touch_A1 None))
       (= pin board.A2)
       (do (express.cpx._touch_A2.deinit)  ;FUCKING GROSS
           (setv express.cpx._touch_A2 None))
       (= pin board.A3)
       (do (express.cpx._touch_A3.deinit)  ;FUCKING GROSS
           (setv express.cpx._touch_A3 None))
       (= pin board.A4)
       (do (express.cpx._touch_A4.deinit)  ;FUCKING GROSS
           (setv express.cpx._touch_A4 None))
       (= pin board.A5)
       (do (express.cpx._touch_A5.deinit)  ;FUCKING GROSS
           (setv express.cpx._touch_A5 None))
       (= pin board.A6)
       (do (express.cpx._touch_A6.deinit)  ;FUCKING GROSS
           (setv express.cpx._touch_A6 None))
       (= pin board.A7)
       (do (express.cpx._touch_A7.deinit)  ;FUCKING GROSS
           (setv express.cpx._touch_A7 None))))

(define-function (set-servo pin angle t)
  `(deinit-pin pin)
  `(setv pwm (pulseio.PWMOut
              pin             
              :frequency 50))
  `(setv s   (servo.Servo pwm))
  `(setv s.angle angle)
  `(time.sleep t)
  `(pwm.deinit)
  )


 