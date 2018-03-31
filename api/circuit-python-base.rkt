#lang racket

(require "./python.rkt")
(require racket/draw)

(require (for-syntax racket))


(provide 
         update

         wait
         
         ->rgb
         pick-random

         get
         set
         loop
         repeat
         (rename-out [py-if if])
         ;(rename-out [py-begin begin])
         py-begin ;Causes issues to redefine begin here.  Maybe it'll work farther downstream
         (rename-out [py-random random])
         
    


         time-since-start
         
         (all-from-out "./python.rkt"))

 

(define (->string x) (format "~a" x))



(define (wait t)
  `(do (render)
       (time.sleep ,t)))

(define (pick-random (s 0) (e 1))
  `(int (+ ,s (* ,e (random.random)))))

(define-for-syntax (split-dots syntax)
  (define (fix-numbers s)
    (if (string->number s)
        (string->number s)
        s))
  (define (fix-vars s)
    (if (string=? "_" (substring s 0 1))
        (string->symbol (substring s 1))
        s))
  (map fix-vars
       (map fix-numbers
            (string-split (format "~a" (syntax->datum syntax)) "."))))

(define-syntax (get2 stx)
  (syntax-case stx ()
    [(_ name (things ...))
     (with-syntax ()
       #`(quote (hy-DOT name [hy-SQUARE things] ...)))]))

(define-syntax (get stx)
  (syntax-case stx ()
    [(_ dotted-datum)
     (with-syntax ([r (rest (split-dots #'dotted-datum))]
                   [f (string->symbol (first (split-dots #'dotted-datum)))])
       #`(get2 f r))]))


(define-syntax (set2 stx)
  (syntax-case stx ()
    [(_ (this (args ...)) that)
     (with-syntax ()
       #`(quasiquote (do
                         (setv ,(get2 this (args ...))
                               ,that)
                         this
                         )))]))

(define-syntax (set stx)
  (syntax-case stx ()
    [(_ dotted-datum other)
     (with-syntax ([r (rest (split-dots #'dotted-datum))]
                   [f (string->symbol (first (split-dots #'dotted-datum)))])
       #`(set2 (f r) other))]))



(define-syntax (loop stx)
  (syntax-case stx ()
    [(_ var max lines ...)
     (with-syntax ()
       #`(let ([var 'n])
           (quasiquote (for (var (range max))
                       ,lines ...))))]))

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
                       ,lines ...)))]))


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

(define-op py-not not)

(define-op py-time-sleep time.sleep)

(define-op py-in in)
(define-op py-print print)

(define-op py-int int)

(define time-since-start '(time-since-start))

(define (py-random) '(random.random))


(define (update . lines)
  `(defn update (state)
     ,@lines))

(define (->rgb color)
  (if (string? color)
      `(hy-COMMA ,@(color-lookup color))
      color))

(define (color-lookup s)
  (define color (send the-color-database find-color s))
  (list (send color red)
        (send color green)
        (send color blue)))

