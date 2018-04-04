#lang racket

(require "./circuit-python-base.rkt")
(require "./circuit-python.rkt")

(provide shake)

(declare-imports 'express)


(define-function (shake thresh)
  `(express.cpx.shake :shake_threshold ,thresh))


 