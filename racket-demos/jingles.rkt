#lang circuit-playground

(set-package-path! "/Users/thoughtstem/Dev/circuit-playground")

(define-riff cool-song
  (C4 0.125)
  (C4 0.125)
  (E5 0.125)
  (F5 0.125)
  (REST 0.125)
  (A5 0.125)
  (A5 0.125))

(on-start
 (play-riff cool-song)
 (wait 2)
 (set-lights green))

