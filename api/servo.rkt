#lang racket

(require "./circuit-python-base.rkt")
(require "./circuit-python.rkt")

(provide set-servo)

(declare-imports 'board 'pulseio 'servo)

(define-function (deinit-pin pin)
  `(if (and (= pin board.A1) express.cpx._touch_A1)
       (do (express.cpx._touch_A1.deinit)  ;FUCKING GROSS.  Shouldn't be messing with touch stuff in servo lib...
           (setv express.cpx._touch_A1 None))
       (and (= pin board.A2) express.cpx._touch_A2)
       (do (express.cpx._touch_A2.deinit)  ;FUCKING GROSS
           (setv express.cpx._touch_A2 None))
       (and (= pin board.A3) express.cpx._touch_A3)
       (do (express.cpx._touch_A3.deinit)  ;FUCKING GROSS
           (setv express.cpx._touch_A3 None))
       (and (= pin board.A4) express.cpx._touch_A4)
       (do (express.cpx._touch_A4.deinit)  ;FUCKING GROSS
           (setv express.cpx._touch_A4 None))
       (and (= pin board.A5) express.cpx._touch_A5)
       (do (express.cpx._touch_A5.deinit)  ;FUCKING GROSS
           (setv express.cpx._touch_A5 None))
       (and (= pin board.A6) express.cpx._touch_A6)
       (do (express.cpx._touch_A6.deinit)  ;FUCKING GROSS
           (setv express.cpx._touch_A6 None))
       (and (= pin board.A7) express.cpx._touch_A7)
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


 