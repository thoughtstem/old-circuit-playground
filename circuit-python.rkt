#lang racket

(require "./python.rkt")
(require racket/draw)

(provide compile-circ
         circuit
         
         update

         BUTTON_A
         BUTTON_B
         on
         down
         initial-memory

         wait
         
         ->rgb
         pick-random

         get
         set
         loop
         repeat
         (rename-out [py-if if])
         (rename-out [py-begin begin])
         (rename-out [py-random random])
         
         define-function
         
         dim-color-by
         set-light
         set-lights

         play-once

         setup-code
         set-setup-code!

         time-since-start
         
         (all-from-out "./python.rkt"))






(define (->string x) (format "~a" x))

(define (racket->python x)
  (cond [(and (boolean? x) x) 'True]
        [(and (boolean? x) (not x)) 'False]
        [(number? x) x]
        [(list? x) x]
        [else (sym x)]))

(define (initial-memory . _kvs)
  (define h (apply hash _kvs))
  (define vs (map racket->python (hash-values h)))
  (define ks (map ->string (hash-keys h)))
  (define kvs (apply append (map list ks vs)))
  `(setv initial-memory {hy-CURLY ,@kvs}))


(define (wait t)
  `(do (render state)
       (time.sleep ,t)))

(define (pick-random (s 0) (e 1))
  `(int (+ ,s (* ,e (random.random)))))



(define-syntax (get stx)
  (syntax-case stx ()
    [(_ name things ...)
     (with-syntax ()
       #`(quote (hy-DOT name [hy-SQUARE things] ...)))]))


(define-syntax (set stx)
  (syntax-case stx ()
    [(_ (this args ...) that)
     (with-syntax ()
       #`(quasiquote (do
                         (setv ,(get this args ...)
                               ,that)
                         this
                         )))]))


(define-syntax (loop stx)
  (syntax-case stx ()
    [(_ var max lines ...)
     (with-syntax ()
       #`(quasiquote (for (var (range max))
                       ,lines ...)))]))

(define-syntax (repeat stx)
  (syntax-case stx ()
    [(_ max lines ...)
     (with-syntax ()
       #`(loop n max lines ... ))]))


(define (py-if c t f)
  `(if ,c ,t ,f))

(define-syntax (py-begin stx)
  (syntax-case stx ()
    [(_ lines ...)
     (with-syntax ()
       #`(quasiquote (do
                       lines ...)))]))


(define-syntax-rule (define-op local-name real-name)
  (begin
    (provide (rename-out [local-name real-name]))
    (define (local-name . args)
      `(real-name ,@args ))))

(define-op py-gt >)
(define-op py-lt <)
(define-op py-lte <=)
(define-op py-gte >=)
(define-op py-eq  =)
(define-op py-add +)
(define-op py-sub -)
(define-op py-mul *)
(define-op py-div /)
(define-op py-mod %)

(define-op py-time-sleep time.sleep)
(define-op py-play-tone play-tone)


(define-op py-int int)

(define time-since-start '(time-since-start))

(define (py-random) '(random.random))

(define-syntax (define-function stx)
  (syntax-case stx ()
    [(_ (name params ...) lines ...)
     (with-syntax ([name-s (syntax->datum #'name)])
       #`(begin
           (define (name params ...)
             `(name ,params ...))

           (set-setup-code!
            (append setup-code
                    (list (quasiquote (defn name (params ...)
                                        (do
                                            ;(global state)
                                            ,lines ...)
                                        )))
                    ))))]))


(define (set-setup-code! thing)
  (set! setup-code thing))





(define BUTTON_A 'BUTTON_A)
(define BUTTON_B 'BUTTON_B)



(define (update . lines)
  `(defn update (state)
     ,@lines))


(struct event (code))
(define (on condition . lines)
  
  (event `(if ,condition
           ,@lines
           )))

(define setup-code '())

(define (rand-var-name)
  (sym "var" (random 10000000)))

(define (sym . xs)
  (define (to-string t)
    (format "~a" t))
  (string->symbol (apply string-append (map to-string xs))))

;Nope, need a way to split -- put some things
;   before the while loop and some things after...
;Also need to be able to generate random names for things.
;  "button" isn't going to cut it...
(define (down button-name)
  (define v (rand-var-name))
  (define full-name (sym "board." button-name))
  (set! setup-code
        (append setup-code
                (list
                 `(setv ,v (DigitalInOut ,full-name))
                 `(setv ,(sym v ".direction") Direction.INPUT)
                 `(setv ,(sym v ".pull") Pull.DOWN))))
  (sym v ".value"))

(define (->rgb color)
  (if (string? color)
      `[hy-SQUARE ,@(color-lookup color)]
      color))

(define (color-lookup s)
  (define color (send the-color-database find-color s))
  (list (send color red)
        (send color green)
        (send color blue)))

(define (compile-circ p)
  (define file-name "/Volumes/CIRCUITPY/code.py")
  (with-output-to-file file-name #:exists 'replace
      (lambda () (printf (compile-py p))))
  (system (string-append "cat " file-name)))


(define (circuit . setup)
  
  ;Calculate these imports better
  (define imports '((import board)
                    (import time)
                    (import neopixel)
                    (import random)
                    (import audioio)
                    (import array)
                    (import audiobusio)
                    (import math)

                    (import (digitalio (DigitalInOut Direction Pull)))
                    ))

  (define events     (map event-code (filter event? setup)))
  (define non-events (filter (λ (x) (not (event? x))) setup))
  
  (list `(
          ,@imports ;Calc from setup

          ,@(append api setup-code non-events)   ;Calc from specs

          ;Time tracking
          (setv start-time (time.monotonic))
          (defn time-since-start ()
            (- (time.monotonic) start-time))

          (setv state {hy-CURLY "hardware" {hy-CURLY "light" [hy-SQUARE 0 0 0 0 0 0 0 0 0 0]
                                                     "audio" [hy-SQUARE ]}
                                "memory"   initial-memory})


          (setv spkrenable (DigitalInOut board.SPEAKER_ENABLE))
          (setv spkrenable.direction Direction.OUTPUT)
          (setv spkrenable.value True)

          
          (defn hardware-update (state)
            (global strip)
            (for (n (range 10))
              (setv ,(get state "hardware" "light" n)
                    ,(get strip n)))

            ,(set (state "hardware" "audio") '[hy-SQUARE ])
            ,(set (state "hardware" "mic-level") '(mic-level)))

          
          (defn render (state)
            (global strip)
            ,(loop n 10
                   `(setv ,(get strip n)
                          ,(get state "hardware" "light" n)))
            (strip.show)
            (while (< 0 (len ,(get state "hardware" "audio")))
                (do
                    (play_file ((hy-DOT (get state "hardware" "audio") pop)))
                  )))
          
          (while True
                 (hardware-update state) ;Set extra values based on hardware.  Convenience things like sampling...
                 (update state)
                 (render state)))))





;Stuff we write that we want people to have access to.
;   Optimization, filter out ones that aren't called...
;   Also, factor into different files
(define api
  '(
    ;Factor into neopixel deps
    (setv pixpin board.NEOPIXEL)
    (setv numpix 10)
    (setv strip (neopixel.NeoPixel pixpin numpix :brightness 0.3 :auto_write False))

    (setv already-played-list [hy-SQUARE])

    (defn already-played (id)
      (for (p already-played-list)
        (if (= p id)
            (return True)))
      (return False))
    
    (defn play-file (to-play)
      (setv id (hy-DOT to-play [hy-SQUARE 1]))
      (if (already-played id)
          (return))
      (already-played-list.append id)
      (setv filename (hy-DOT to-play [hy-SQUARE 0]))
      (print (+ "playing file " filename))
      (setv f (open filename "rb"))
      (setv a (audioio.AudioOut board.A0 f))
      (a.play)
      (while a.playing
        (setv dummy 0)))




    (setv CURVE 2)
    (setv SCALE_EXPONENT (math.pow 10 (* CURVE -0.1)))

    (setv NUM_SAMPLES 160)

    (defn constrain (value floor ceiling)
      (return (max floor (min value ceiling))))

    (defn log_scale (input_value input_min input_max output_min output_max)
      (setv normalized_input_value (/ (- input_value  input_min) (- input_max input_min)))
      (return (+ output_min (* (math.pow normalized_input_value SCALE_EXPONENT)
                               (- output_max output_min)))))

    (defn normalized_rms (values)
      (setv minbuf (int (mean values)))
      (return (math.sqrt
               (/
                (sum
                 (list-comp  (float (* (- sample minbuf) (- sample minbuf)))
                             (sample values)))
                (len values)))))

    (defn mean (values)
      (return (/ (sum values)
                 (len values))))

    (defn mic-level ()
      (mic.record samples (len samples))
           (setv magnitude (normalized_rms samples))
           (setv c (log_scale
                     (constrain magnitude input_floor input_ceiling)
                     input_floor
                     input_ceiling
                     0
                     10))
           c)


    (setv mic (audiobusio.PDMIn board.MICROPHONE_CLOCK board.MICROPHONE_DATA :frequency 16000 :bit_depth 16))

    (setv samples (array.array "H" (* [hy-SQUARE 0] NUM_SAMPLES)))
    (mic.record samples (len samples))

    (setv input_floor (+ (normalized_rms samples) 10))

    (setv input_ceiling (+ input_floor 500))

    (setv peak 0)




    (setv SAMPLERATE 8000)

    (defn play-tone (beats freq)
      (setv length (int (/ SAMPLERATE freq)))
      (setv sine_wave (array.array "H" (* [hy-SQUARE 0] length)))
      (for (i (range length))
        (setv (hy-DOT sine_wave [hy-SQUARE i]) (+ (* (int (*
                                                           (math.sin (/ (* math.pi 2 i) 18))
                                                           (** 2 15))))
                                                  (** 2 15))))

      (setv sample (audioio.AudioOut board.SPEAKER sine_wave))
      (setv sample.frequency SAMPLERATE)
      (sample.play :loop True)  
      (time.sleep beats)          
      (sample.stop))
    ))

;AUDIO

(define (play-once file id)
  `[hy-SQUARE [hy-SQUARE ,file ,id]])

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

;END AUDIO




;LIGHTS

(define (dim-color-by c n)
  `[hy-SQUARE (max 0 (- (hy-DOT ,c [hy-SQUARE 0]) ,n))
              (max 0 (- (hy-DOT ,c [hy-SQUARE 1]) ,n))
              (max 0 (- (hy-DOT ,c [hy-SQUARE 2]) ,n))])



(define-function (set-lights c)
  (loop n 10
    `(set-light n c)))
  

(define-function (set-light n c)
  (set (state "hardware" "light" n)
       'c))

;END LIGHTS
