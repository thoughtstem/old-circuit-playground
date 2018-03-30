# Circuit Playground Express Demo Code
# Adjust the pulseio 'board.PIN' if using something else
import pulseio
import board
import adafruit_irremote

with pulseio.PulseIn(board.REMOTEIN, maxlen=120, idle_state=True) as p:
    d = adafruit_irremote.GenericDecode()
    code = bytearray(4)
    while True:
        d.decode_bits(p, code)
        print(code)
