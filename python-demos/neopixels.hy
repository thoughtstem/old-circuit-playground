(import time)
(import board)
(import neopixel)


(setv pixels (neopixel.NeoPixel board.NEOPIXEL 10 :auto_write False))

(while True
    (print "LOOP")
    (pixels.fill [0 0 0])

    (for [i (range 10)]
        (setv (. pixels [i]) [10 0 0])
        (pixels.show)
        (time.sleep .1)))
