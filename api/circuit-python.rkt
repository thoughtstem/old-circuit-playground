#lang racket

(require "./python.rkt")
(require "./circuit-python-base.rkt")
(require racket/draw)

(provide compile-circ
         run

         define-function

         add-setup-code

         add-main-loop-code-begin
         add-main-loop-code-end

         declare-imports

         add-setup-code
         
         (all-from-out "./circuit-python-base.rkt"))


(define-syntax (define-function stx)
  (syntax-case stx ()
    [(_ (name params ...) lines ...)
     (with-syntax ([name-s (syntax->datum #'name)])
       #`(begin
           (provide name)
           
           (define (name params ...)
             `(name ,params ...))

           (set-setup-code!
            (append (list (quasiquote (defn name (params ...)
                                        (do
                                            ;(global state)
                                            ,lines ...)
                                        )))

                    setup-code
                    
                    ))))]))


(define (set-setup-code! thing)
  (set! setup-code thing))  

(define setup-code '())

(define (add-setup-code . lines)
  (set-setup-code! (append setup-code lines)))


(define (set-main-loop-code! thing)
  (set! main-loop-code thing))  

(define main-loop-code '())

(define (add-main-loop-code-end . lines)
  (set-main-loop-code! (append main-loop-code lines)))

(define (add-main-loop-code-begin . lines)
  (set-main-loop-code! (append lines main-loop-code)))

(define (compile-circ p)
  (define file-name "/Volumes/CIRCUITPY/code.py")
  (with-output-to-file file-name #:exists 'replace
      (lambda () (printf (compile-py p))))
  (system (string-append "cat " file-name)))



(define (->string x) (format "~a" x))

(define (racket->python x)
  (cond [(and (boolean? x) x) 'True]
        [(and (boolean? x) (not x)) 'False]
        [(number? x) x]
        [(list? x) x]
        [else (sym x)]))


(define (rand-var-name)
  (sym "var" (random 10000000)))

(define (sym . xs)
  (define (to-string t)
    (format "~a" t))
  (string->symbol (apply string-append (map to-string xs))))

(define imports '(board time random))

(define (declare-imports . things)
  (set! imports (remove-duplicates (append imports things))))

(define (run)
  (define (to-statement x) `(import ,x))
  (define import-statements (map to-statement imports))

  (compile-circ
   (list `(
           ,@import-statements

           (setv initial-memory {hy-CURLY })
           (setv state {hy-CURLY "hardware" {hy-CURLY "audio" [hy-SQUARE ]}
                                 "memory"   initial-memory})

           ,@setup-code

           (setv start-time (time.monotonic))
           (defn time-since-start ()
             (- (time.monotonic) start-time))

          
           (defn hardware-update (state)
             (global strip)
            
             (hardware-update-lights)
            
             ,(set state.hardware.audio '[hy-SQUARE ])
             ,(set state.hardware.mic-level '(mic-level)))

          
           (defn render (state)
             (global strip)
             ,(loop n 10
                    `(setv ,(get strip._n)
                           ,(get state.hardware.light._n)))
             (strip.show)
             (while (< 0 (len ,(get state.hardware.audio)))
                    (do
                        (play_file ((hy-DOT ,(get state.hardware.audio) pop)))
                      )))
          
           (while True
                  ,@main-loop-code
                  (hardware-update state) ;Set extra values based on hardware.  Convenience things like sampling...
                  (update)
                  (render state))))))












