#lang racket

(require "../api/main.rkt")

(define-user-function (setup)
  (set-lights purple)
  )

(define-user-function (update)
  #;(set-lights red))

(run) ;WART!
