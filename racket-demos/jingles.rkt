#lang racket

(require "../api/main.rkt")

(define (setup)
 (set state.memory.team-color (->rgb "blue"))
 (play-riff jingle1))

(define (update)
 (wait 1))

(run)