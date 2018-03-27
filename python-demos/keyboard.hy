(import (digitalio (DigitalInOut Direction Pull)))
(import touchio)
(import board)
(import time)
(import (adafruit_hid.keyboard (Keyboard)))
(import (adafruit_hid.keycode (Keycode)))
(import (adafruit_hid.keyboard_layout_us (KeyboardLayoutUS)))
 
(setv buttonpins [board.BUTTON_A board.BUTTON_B])
(setv buttons [])
(setv buttonkeys [Keycode.LEFT_ARROW Keycode.RIGHT_ARROW])
(setv controlkey Keycode.SHIFT)
 
(time.sleep 1)

(setv kbd (Keyboard))
(setv layout (KeyboardLayoutUS kbd))
 
(for (pin buttonpins)
    (setv button (DigitalInOut pin))
    (setv button.direction Direction.INPUT)
    (setv button.pull Pull.DOWN)
    (buttons.append button))
 
(setv led (DigitalInOut board.D13))
(setv led.direction Direction.OUTPUT)
 
(print "Waiting for button presses")
 
(while True
    (for (button buttons)
        (if button.value
            (do
              (print (% "Button #%d Pressed"  i))
              (setv i (buttons.index button))
              (setv led.value True)
              (setv k (. buttonkeys [i]))

              (if (is (type k) str)
                  (layout.write k)
                  (kbd.press controlkey k))
   
              (setv led.value False))
            (do
              (setv i (buttons.index button))
              (setv k (. buttonkeys [i]))
              (kbd.release controlkey  k)))))
