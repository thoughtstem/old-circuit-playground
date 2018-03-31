#lang racket

(require "../api/main.rkt")

(define-user-function (update)
  (set-lights (->rgb "green")))

(run) ;WART!
