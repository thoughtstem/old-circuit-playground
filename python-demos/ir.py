# Circuit Playground Express Demo Code
# Adjust the pulseio 'board.PIN' if using something else
import pulseio
import board
import adafruit_irremote
import time

#decoder = adafruit_irremote.GenericDecode()

pulsein = pulseio.PulseIn(board.REMOTEIN, maxlen=120, idle_state=True)

while True:
    print("Start ----------------------------")

    # Wait for an active pulse
    print("Waiting...")

    while len(pulsein) == 0:
        pass

    # Pause while we do something with the pulses
    pulsein.pause()

    a = [pulsein[x] for x in range(len(pulsein))] 
    print(a)

    # Clear the rest
    pulsein.clear()

    # Resume with an 80 microsecond active pulse
    pulsein.resume(80)

   # pulses = decoder.read_pulses(pulsein)
   # print("Heard", len(pulses), "Pulses:", pulses)
   # try:
   #     code = decoder.decode_bits(pulses, debug=False)
   #     print("Decoded:", code)
   # except adafruit_irremote.IRNECRepeatException:  # unusual short code!
   #     print("NEC repeat!")
   # except adafruit_irremote.IRDecodeException as e:     # failed to decode
   #     print("Failed to decode: ", e.args)

    print("End ----------------------------")
