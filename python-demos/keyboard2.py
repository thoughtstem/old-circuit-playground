from digitalio import DigitalInOut, Direction, Pull
import touchio
import board
import time
from adafruit_hid.keyboard import Keyboard
from adafruit_hid.keycode import Keycode
from adafruit_hid.keyboard_layout_us import KeyboardLayoutUS
buttonpins = [board.BUTTON_A, board.BUTTON_B]
buttons = []
buttonkeys = [Keycode.LEFT_ARROW, Keycode.RIGHT_ARROW]
controlkey = Keycode.SHIFT
time.sleep(1)
kbd = Keyboard()
layout = KeyboardLayoutUS(kbd)
for pin in buttonpins:
    button = DigitalInOut(pin)
    button.direction = Direction.INPUT
    button.pull = Pull.DOWN
    buttons.append(button)
led = DigitalInOut(board.D13)
led.direction = Direction.OUTPUT
print('Waiting for button presses')
while True:
    for button in buttons:
        if button.value:
            print('Button #%d Pressed' % i)
            i = buttons.index(button)
            led.value = True
            k = buttonkeys[i]
            layout.write(k) if type(k) is str else kbd.press(controlkey, k)
            led.value = False
            _hy_anon_var_1 = None
        else:
            i = buttons.index(button)
            k = buttonkeys[i]
            _hy_anon_var_1 = kbd.release(controlkey, k)

