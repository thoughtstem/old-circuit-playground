#lang racket

(require "./circuit-python.rkt")

(define test
  (circuit
   (on-tick
    (neopixel 0 "red")
    (neopixel 1 "OrangeRed")
    (neopixel 2 "orange")
    (neopixel 3 "DarkOrange")
    (neopixel 4 "yellow")
    (neopixel 5 "GreenYellow")
    (neopixel 6 "green")
    (neopixel 7 "MediumAquamarine")
    (neopixel 8 "blue")
    (neopixel 9 "purple"))))

(compile-circ test)