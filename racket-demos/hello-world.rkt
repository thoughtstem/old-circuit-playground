#lang circuit-playground

(set-package-path! "/Users/thoughtstem/Dev/circuit-playground/")

(on-start
 (set-lights red)
 (wait 2))

(forever
  (set-lights blue))
