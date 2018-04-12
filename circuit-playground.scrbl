#lang scribble/manual
 
@title{#lang circuit-playground}

This language allows you to code the Circuit Playground Express (CPX) in DrRacket.  Here's
an overview of what you can do:

@itemlist[@item{Colored lights}
          @item{Sounds of different pitches}
          @item{Digitally write on various pins}
          @item{Control servos on various pins}
          @item{Send signals to other CPX devices via infrared}
          @item{Capacative sensing on various pins}
          @item{Detect button presses}
          @item{Detect acceleration (e.g. shaking)}]

We've tried to hide a lot of the details related to allocating and deallocating hardware 
resources.  Wherever possible, we've tried to keep things at the same level of abstraction
as the language you use in the online IDE https://makecode.adafruit.com.

This doc takes the form of various examples that demonstrate the full range of supported
features.

@section{Basic Lights}

@codeblock|{
#lang circuit-playground
 
(on-start
 (set-lights red)
 (wait 2))

(forever
  (set-lights blue))
}|

This sets the neopixel lights to red when the CPX boots.  Two seconds later, the lights turn
blue.

@image[#:scale 1]{./doc-images/RedBlue.gif}

All colors in the list below are available for use in any call to set-lights.

@codeblock|{
(list 
  orange-red
  tomato
  dark-red
  red
  firebrick
  crimson
  deep-pink
  maroon
  indian-red
  medium-violet-red
  violet-red
  light-coral
  hot-pink
  pale-violet-red
  light-pink
  rosy-brown
  pink
  orchid
  lavender-blush
  snow
  chocolate
  saddle-brown
  brown
  dark-orange
  coral
  sienna
  orange
  salmon
  peru
  dark-golden-rod
  goldenrod
  sandy-brown
  light-salmon
  dark-salmon
  gold
  yellow
  olive
  burlywood
  tan
  navajo-white
  peach-puff
  khaki
  dark-khaki
  moccasin
  wheat
  bisque
  pale-golden-rod
  blanched-almond
  medium-golden-rod
  papaya-whip
  misty-rose
  lemon-chiffon
  antique-white
  corn-silk
  light-goldenrod-yellow
  oldlace
  linen
  light-yellow
  seashell
  beige
  floral-white
  ivory
  green
  lawn-green
  chartreuse
  green-yellow
  yellow-green
  olivedrab
  medium-forest-green
  dark-olive-green
  dark-seagreen
  lime
  dark-green
  lime-green
  forest-green
  springgreen
  medium-spring-green
  seagreen
  medium-seagreen
  aquamarine
  light-green
  pale-green
  medium-aquamarine
  turquoise
  light-seagreen
  medium-turquoise
  honeydew
  mintcream
  royal-blue
  dodger-blue
  deep-skyblue
  cornflower-blue
  steel-blue
  light-skyblue
  dark-turquoise
  cyan
  aqua
  dark-cyan
  teal
  sky-blue
  cadet-blue
  dark-slate-gray
  light-slate-gray
  slate-gray
  light-steelblue
  light-blue
  powder-blue
  pale-turquoise
  light-cyan
  alice-blue
  azure
  medium-blue
  dark-blue
  midnight-blue
  navy
  blue
  indigo
  blueviolet
  medium-slate-blue
  slate-blue
  purple
  dark-slate-blue
  dark-violet
  dark-orchid
  medium-purple
  corn-flowerblue
  medium-orchid
  magenta
  fuchsia
  dark-magenta
  violet
  plum
  lavender
  thistle
  ghost-white
  white
  white-smoke
  gainsboro
  light-gray
  silver
  gray
  dark-gray
  dim-gray
  black)
}|


@section{Basic Buttons}


@codeblock|{
#lang circuit-playground

(define color blue)

(forever
 (if button-b 
     (set-lights green)
     (set-lights color)))

(on-down button-a
         (set! color red))
}|


@image[#:scale 1]{./doc-images/ButtonPressDemo.gif}


@section{Basic Sound}

When it comes to sound, we can play tones and custom "riffs".

@codeblock|{
(define-riff cool-song
  (C4 0.125)
  (C4 0.125)
  (E5 0.125)
  (F5 0.125)
  (REST 0.125)
  (A5 0.125)
  (A5 0.125))

(on-start
 (play-tone A5 1)
 (play-riff cool-song)
 (set-lights green))
}|

No sound in GIFs.  You'll have to take my word that it works. :)

@image[#:scale 1]{./doc-images/SoundDemo.gif}


@section{Intermediate: LED write + Capacative touch}


@codeblock|{
#lang circuit-playground

(define speed 1)

(forever
 (pin-write output-a7 #t)
 (wait speed)
 (pin-write output-a7 #f)
 (wait speed))

(on-down touch-a1
         (set! speed 0.1))

(on-down touch-a2
         (set! speed 1)) 
}|

Okay, here's my attempt at demoing the above code in a GIF.  Since there's no sound,
I'm using American Sign Language to try to help clarify that I'm attaching the red wire 
to pin A7 and the green wire to GND.  I then speed up the blinking LED by touching the 
A1 pad.  

@image[#:scale 1]{./doc-images/LEDCapDemo.gif}


@section{Intermediate: Laser Tag}


@codeblock|{
#lang circuit-playground

(define color green)
(define my-team 2)      ;NOTE: Reverse these on the other CPX!
(define other-team 1)

(on-start
 (play-riff jingle1))

(on-ir n
       (if (= n other-team)
           (set! color red)
           #f)) 

(on-down button_a
         (set-lights blue)
         (play-riff jingle1)
         (send-ir my-team)
         (set-lights green))

(forever
 (set-lights color))

}|

In the GIF below, I press the button on one CPX and the other CPX turns red.  It doesn't work the first time,
but it works the second time.  This is pretty common.  IR sending/receiving does not have 100% 
accuracy.  The ambient light in the room can affect things greatly.

@image[#:scale 1]{./doc-images/IRDemo.gif}


@section{Intermediate: Servo Control}

@codeblock|{
#lang circuit-playground

(define angle 90)

(forever
  (set-servo output-a1 angle))  

(on-down button-a
         (set! angle 180))

(on-down button-b
         (set! angle 0))
}|

In this GIF, I'm pressing the A and B buttons and changing the servo angle from 0 to 180.  The wiring is kind of 
confusing, so I don't show it in detail in the GIF.  Here's the gist, though: Servos have three wires. One conncets to
GND, one connects to 3.3v, the other connects to the control pin (which in this case is A1, as you can see in the code).
Depending on your servo, it can be hard to tell which wire is which.  To be honest, I usually just do trial and error 
to figure that out.

@image[#:scale 1]{./doc-images/ServoDemo.gif}
