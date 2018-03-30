# Circuit Playground Express Demo Code
# Adjust the pulseio 'board.PIN' if using something else
import pulseio
import board
import time
import array
import adafruit_irremote

pwm = pulseio.PWMOut(board.IR_TX, frequency=38000, duty_cycle=2**15)
#pwm = pulseio.PWMOut(board.IR_TX, duty_cycle=2**15)

pulseout = pulseio.PulseOut(pwm)

#transmitter = adafruit_irremote.GenericTransmit((3350, 1675), (460, 1300), (460, 400), 465)
#msg = array.array('H',bytearray(b'green'))
msg = array.array('H', [100, 200, 100])

while True:
  print(msg)
  pulseout.send(msg)
  #transmitter.transmit(pulseout, bytearray(b'green'))
  time.sleep(2)
