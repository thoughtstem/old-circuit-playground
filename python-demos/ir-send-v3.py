import array
import digitalio
import pulseio
import board
import adafruit_irremote
import time


remote = adafruit_irremote.GenericTransmit((3350, 1675), (460, 1300), (460, 400), 465)

left = digitalio.DigitalInOut(board.D4)
right = digitalio.DigitalInOut(board.D5)
left.switch_to_input(pull=digitalio.Direction.INPUT)
right.switch_to_input(pull=digitalio.Direction.INPUT)

pwm = pulseio.PWMOut(board.REMOTEOUT, frequency=38000, duty_cycle=2 ** 15)
pulse = pulseio.PulseOut(pwm)


VOLUMEUP = array.array('H', [100,200,100,200])
remote.transmit(pulse, VOLUMEUP)
