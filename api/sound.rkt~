#lang racket

(require "./circuit-python-base.rkt")
(require "./circuit-python.rkt")



(provide play-riff
         define-riff)


(declare-imports 'audioio 'audiobusio 'array 'math 'express)

(add-setup-code
 '(setv CURVE 2)
 '(setv SCALE_EXPONENT (math.pow 10 (* CURVE -0.1)))

 '(setv NUM_SAMPLES 160)

 '(setv mic (audiobusio.PDMIn board.MICROPHONE_CLOCK board.MICROPHONE_DATA :frequency 16000 :bit_depth 16))

 '(setv samples (array.array "H" (* [hy-SQUARE 0] NUM_SAMPLES)))
 '(mic.record samples (len samples))

 '(setv input_floor (+ (normalized_rms samples) 10))

 '(setv input_ceiling (+ input_floor 500))

 '(setv peak 0)

 '(setv SAMPLERATE 8000)
 )





(define-function (play-tone freq beats)
  '(if (= 0 freq)
       (do (time.sleep beats)
           (return)))
  
  '(if (not express.cpx._speaker_enable)
       (do
          (setv express.cpx._speaker_enable
                (digitalio.DigitalInOut board.SPEAKER_ENABLE))
          (express.cpx._speaker_enable.switch_to_output :value #f)))
  '(express.cpx.play_tone freq beats))


(define-syntax (define-note stx)
  (syntax-case stx ()
    [(_ name freq)
     (with-syntax ()
       #`(begin (define name freq)
                (provide name)))]))


(define-note A3	220.00)
(define-note A#3/Bb3 233.08)
(define-note B3	246.94)
(define-note C4	261.63)
(define-note C#4/Db4 277.18)
(define-note D4	293.66)
(define-note D#4/Eb4 311.13)
(define-note E4	329.63)
(define-note F4	349.23)
(define-note F#4/Gb4 369.99)
(define-note G4	392.00)
(define-note G#4/Ab4 415.30)
(define-note A4	440.00)
(define-note A#4/Bb4 466.16)
(define-note B4	493.88)
(define-note C5	523.25)
(define-note C#5/Db5 554.37)
(define-note D5	587.33)
(define-note D#5/Eb5 622.25)
(define-note E5	659.25)
(define-note F5	698.46)
(define-note F#5/Gb5 739.99)
(define-note G5	783.99)
(define-note G#5/Ab5 830.61)
(define-note A5	880.00)
(define-note REST 0)


(define-syntax (define-riff stx)
  (syntax-case stx ()
    [(_ name (note beats) ...)
     (with-syntax ()
       #`(begin (define name
                  `[hy-COMMA
                    [hy-COMMA ,note beats]
                    ...])
                (provide name)))]))

(define-riff jingle1
  (C4 0.125)
  (D4 0.125)
  (E5 0.125)
  (F5 0.125)
  (G5 0.125)
  (A5 0.125))


(define-function (play-riff riff)
  '(for (note riff)
    (play-tone (hy-DOT note [hy-SQUARE 0])
               (hy-DOT note [hy-SQUARE 1])) ))
    

(define-function (constrain value floor ceiling)
  '(return (max floor (min value ceiling))))

(define-function (log_scale input_value input_min input_max output_min output_max)
  '(setv normalized_input_value (/ (- input_value  input_min) (- input_max input_min)))
  '(return (+ output_min (* (math.pow normalized_input_value SCALE_EXPONENT)
                           (- output_max output_min)))))

(define-function (normalized_rms values)
  '(setv minbuf (int (mean values)))
  '(setv sum 0)

  '(for (i (range (len values)))
     (setv sample (hy-DOT values [hy-SQUARE i]))
     (setv curr (float (* (- sample minbuf) (- sample minbuf))))
     (setv sum (+ sum curr))
     )
  
  '(return (math.sqrt
           (/
            sum
            (len values)))))

(define-function (mean values)
  '(return (/ (sum values)
              (len values))))

(define-function (mic-level)
  '(mic.record samples (len samples))
  '(setv magnitude (normalized_rms samples))
  '(setv c (log_scale
           (constrain magnitude input_floor input_ceiling)
           input_floor
           input_ceiling
           0
           10))
  'c)

