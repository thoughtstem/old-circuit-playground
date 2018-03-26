(import time)
(import board)
(import neopixel)
(import touchio)
 
(setv pixpin board.NEOPIXEL)
(setv numpix 10)

(setv touch_A1 (touchio.TouchIn board.A1))
 
(setv strip (neopixel.NeoPixel pixpin numpix :brightness 0.3 :auto_write False))
 
(defn wheel [pos]
    (if (or (< pos 0) (> pos 255))
        (return [0 0 0]))

    (if (< pos 85)
        (return [(int (* pos 3))
                 (int (- 255 (* pos 3))) 
                 0])

        (< pos 170)
        (do (setv pos (- pos 85))
            (return [(int (- 255 (* pos 3)))
                     0
                     (int (* pos 3))]))
       
        
        (do
           (setv pos (- pos 170))
           (return [0
                    (int (* pos 3))
                    (int (- 255 (* pos 3)))]))))
 

(defn rainbow_cycle [wait]
    (for [j (range 255)]
        (for [i (range (len strip))]
            (setv idx (+ (int (/ (* i 256) (len strip))) j))
            (setv (. strip [i]) (wheel (& idx 255))))
        (if touch_A1.value
            (strip.fill [255 0 0]))
        (strip.write)
        (time.sleep wait)))
 

(while True
       (rainbow_cycle 0.001))


