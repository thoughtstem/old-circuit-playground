#lang racket

(require "./circuit-python-base.rkt")
(require "./circuit-python.rkt")
(require racket/draw)

(provide  dim-color-by
          ->rgb)




(declare-imports 'neopixel 'digitalio)

(add-setup-code
 '(setv pixpin board.NEOPIXEL)
 '(setv numpix 10)
 '(setv strip (neopixel.NeoPixel pixpin numpix :brightness 0.3 :auto_write False)))

(define (dim-color-by c n)
  `[hy-SQUARE (max 0 (- (hy-DOT ,c [hy-SQUARE 0]) ,n))
              (max 0 (- (hy-DOT ,c [hy-SQUARE 1]) ,n))
              (max 0 (- (hy-DOT ,c [hy-SQUARE 2]) ,n))])


(define-function (hardware-update-lights)
  (if `(not ,(in "lights" (get state.hardware )))
         (set state.hardware.light '[hy-SQUARE 0 0 0 0 0 0 0 0 0 0])
         '(setv dummy "dummy"))
            
  (loop n 10
    (set state.hardware.light._n
         (get strip._n))))


(define-function (set-light n c)
  (set state.hardware.light._n
       'c))

(define-function (set-lights c)
  (loop n 10
    `(set-light n c)))

(add-to-hardware-update
  (hardware-update-lights))


(define (->rgb color)
  (if (string? color)
      `(hy-COMMA ,@(color-lookup color))
      color))

(define (color-lookup s)
  (define color (send the-color-database find-color s))
  (list (send color red)
        (send color green)
        (send color blue)))

(define-syntax (define-color stx)
  (syntax-case stx ()
    [(_ name)
     (with-syntax ([name-s (regexp-replace*
                            #rx"-"
                            (format "~a" (syntax->datum #'name))
                            ""
                            )])
       #`(begin (define name (->rgb name-s))
                (provide name)))]))

(define-syntax (define-colors stx)
  (syntax-case stx ()
    [(_ names ...)
     (with-syntax ()
       #`(begin (define-color names)
                ...))]))
  
(define-colors
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
