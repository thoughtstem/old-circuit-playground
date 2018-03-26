import array
import audiobusio
import board
import math
import neopixel
 
CURVE = 2
SCALE_EXPONENT = math.pow(10, CURVE*-0.1)
 
PEAK_COLOR = (100, 0, 255)
NUM_PIXELS = 10
 
NUM_SAMPLES = 160
 
def constrain(value, floor, ceiling):
    return max(floor, min(value, ceiling))
 
def log_scale(input_value, input_min, input_max, output_min, output_max):
    normalized_input_value = (input_value - input_min) / (input_max - input_min)
    return output_min + math.pow(normalized_input_value, SCALE_EXPONENT) * (output_max - output_min)
 
def normalized_rms(values):
    minbuf = int(mean(values))
    return math.sqrt(sum(float((sample-minbuf)*(sample-minbuf)) for sample in values)/len(values))
 
def mean(values):
    return (sum(values) / len(values))
 
 
mic = audiobusio.PDMIn(board.MICROPHONE_CLOCK, board.MICROPHONE_DATA, frequency=16000, bit_depth=16)

samples = array.array('H', [0] * NUM_SAMPLES)
mic.record(samples, len(samples))

input_floor = normalized_rms(samples) + 10

input_ceiling = input_floor + 500
 
peak = 0
while True:
    mic.record(samples, len(samples))
    magnitude = normalized_rms(samples)

    c = log_scale(constrain(magnitude, input_floor, input_ceiling), input_floor, input_ceiling, 0, NUM_PIXELS)
 
    print(c)
