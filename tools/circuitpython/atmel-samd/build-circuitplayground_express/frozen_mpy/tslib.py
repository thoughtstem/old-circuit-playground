import board
import time
import random
import neopixel
import digitalio
import audioio
import audiobusio
import array
import math
import express
import touchio
import pulseio
import servo
import sys
import IRLibDecodeBase
import IRLib_P01_NECd
import IRrecvPCI
import IRLib_P01_NECs


def send_ir(n):
    global mySend
    global last_sent_time
    last_sent_time = 20
    print('SENDING')
    mySend.irSend.deinit() if hasattr(mySend, 'irSend') else None
    mySend.irPWM.deinit() if hasattr(mySend, 'irPWM') else None
    express.cpx._sample.deinit() if express.cpx._sample else None
    if express.cpx._sample:
        express.cpx._sample = None
        _hy_anon_var_1 = None
    else:
        _hy_anon_var_1 = None
    express.cpx._speaker_enable.deinit(
        ) if express.cpx._speaker_enable else None
    if express.cpx._speaker_enable:
        express.cpx._speaker_enable = None
        _hy_anon_var_2 = None
    else:
        _hy_anon_var_2 = None
    return mySend.send(n, 6)


def ir_receive():
    global last_sent_time
    global current_ir_number
    global state
    if last_sent_time == 0:
        can_decode = False
        try:
            can_decode = myReceiver.getResults()
            _hy_anon_var_4 = None
        except:
            _hy_anon_var_4 = reset_receiver()
        if can_decode and myDecoder.decode():
            print('Results!!')
            last_ir_number = myDecoder.value
            print(myDecoder.value)
            last_received_address = myDecoder.address
            current_ir_number = last_ir_number
            _hy_anon_var_5 = reset_receiver()
        else:
            _hy_anon_var_5 = None
        _hy_anon_var_6 = _hy_anon_var_5
    else:
        last_sent_time = last_sent_time - 1
        _hy_anon_var_6 = None
    return _hy_anon_var_6


def reset_receiver():
    myReceiver.recvBuffer.deinit()
    return myReceiver.enableIRIn()


def set_servo_f(pin, angle):
    pwm = get_pwm(pin)
    s = servo.Servo(pwm)
    s.angle = angle


def free_servo_pin(pin):
    i = output_pins.index(pin)
    pwms.pop(i)
    return output_pins.pop(i)


def create_new_pwm(pin):
    pwm = pulseio.PWMOut(pin, frequency=50)
    pwms.append(pwm)
    output_pins.append(pin)
    return pwm


def fetch_existing_pwm(pin):
    i = output_pins.index(pin)
    return pwms[i]


def get_pwm(pin):
    return fetch_existing_pwm(pin) if pin in output_pins else create_new_pwm(
        pin)


def shake(thresh):
    return express.cpx.shake(shake_threshold=thresh)


def pin_write_f(pin, val):
    p = digitalio.DigitalInOut(pin)
    p.direction = digitalio.Direction.OUTPUT
    p.value = val


def mic_level():
    mic.record(samples, len(samples))
    magnitude = normalized_rms(samples)
    c = log_scale(constrain(magnitude, input_floor, input_ceiling),
        input_floor, input_ceiling, 0, 10)
    return c


def mean(values):
    return sum(values) / len(values)


def normalized_rms(values):
    minbuf = int(mean(values))
    sum = 0
    for i in range(len(values)):
        sample = values[i]
        curr = float((sample - minbuf) * (sample - minbuf))
        sum = sum + curr
    return math.sqrt(sum / len(values))


def log_scale(input_value, input_min, input_max, output_min, output_max):
    normalized_input_value = (input_value - input_min) / (input_max - input_min
        )
    return output_min + math.pow(normalized_input_value, SCALE_EXPONENT) * (
        output_max - output_min)


def constrain(value, floor, ceiling):
    return max(floor, min(value, ceiling))


def play_riff(riff):
    for note in riff:
        play_tone(note[0], note[1])


def play_tone(freq, beats):
    if not express.cpx._speaker_enable:
        express.cpx._speaker_enable = digitalio.DigitalInOut(board.
            SPEAKER_ENABLE)
        _hy_anon_var_22 = express.cpx._speaker_enable.switch_to_output(value
            =False)
    else:
        _hy_anon_var_22 = None
    return express.cpx.play_tone(freq, beats)


def set_lights(c):
    for n in range(10):
        set_light(n, c)
    return express.cpx.pixels.show()


def set_light(n, c):
    express.cpx.pixels[n] = c


def set_brightness(n):
    express.cpx.pixels.brightness = n


def pick_random(s, e):
    return int(s + (e - s) * random.random())


pixpin = board.NEOPIXEL
express.cpx.pixels.auto_write = False
express.cpx.pixels.brightness = 1
CURVE = 2
SCALE_EXPONENT = math.pow(10, CURVE * -0.1)
NUM_SAMPLES = 160
mic = audiobusio.PDMIn(board.MICROPHONE_CLOCK, board.MICROPHONE_DATA,
    frequency=16000, bit_depth=16)
samples = array.array('H', [0] * NUM_SAMPLES)
mic.record(samples, len(samples))
input_floor = normalized_rms(samples) + 10
input_ceiling = input_floor + 500
peak = 0
SAMPLERATE = 8000
output_pins = []
pwms = []


class MyDecodeClass(IRLibDecodeBase.IRLibDecodeBase):

    def __init__(self):
        IRLibDecodeBase.IRLibDecodeBase.__init__(self)
        return None

    def decode(self):
        return True if IRLib_P01_NECd.IRdecodeNEC.decode(self) else False


myDecoder = MyDecodeClass()
myReceiver = IRrecvPCI.IRrecvPCI(board.REMOTEIN)
myReceiver.enableIRIn()
last_ir_number = False
current_ir_number = False
last_sent_time = False
last_recieved_address = False
mySend = IRLib_P01_NECs.IRsendNEC(board.REMOTEOUT)
