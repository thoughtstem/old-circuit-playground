(import board)
(import digitalio)
(import time)

(setv led (digitalio.DigitalInOut board.D13))
(setv led.direction digitalio.Direction.OUTPUT)


(while True 
  (print "Hello from CP")
  (setv led.value True)
  (time.sleep 0.5)
  (setv led.value False)
  (time.sleep 0.5))

