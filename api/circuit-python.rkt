#lang racket

(require "./python.rkt")
;(require "./circuit-python-base.rkt")
(require racket/draw
         setup/dirs)

(provide compile-circ
         run

         define-function
         define-user-function
         forever
         on-start

         pick-random

         add-setup-code

         add-main-loop-code-begin
         add-main-loop-code-end

         declare-imports

         add-to-hardware-update

         set-cplayboot-path!
         set-circuitpy-path!
         set-package-path!)




(define-syntax (define-function stx)
  (syntax-case stx ()
    [(_ (name params ...) lines ...)
     (with-syntax ([name-s (syntax->datum #'name)])
       #`(begin
           (provide name)
           
           (define (name params ...)
             `(name ,params ...))

           (set-setup-code!
            
            (append (list
                     (let ([params 'params] ...)
                       (quasiquote (defn name (params ...)
                                     (do
                                         ;(global state)
                                         ,lines ...)
                                     ))))

                    setup-code))))]
    [(_ name val)
     (with-syntax ()
       #`(begin
           (define name 'name)
           (add-global-var `(setv name ,val))))]))

(define-syntax (define-user-function stx)
  (syntax-case stx ()
    [(_ (name params ...) lines ...)
     (with-syntax ([name-s (syntax->datum #'name)])
       #`(begin
           
           (define (name params ...)
             `(name ,params ...))

           (set-user-functions!
            
            (append (list
                     (let ([params 'params] ...)
                       (quasiquote (defn name (params ...)
                                     (do
                                         
                                         ,lines ...)
                                     ))))

                    user-functions))))]
    [(_ name val)
     (with-syntax ()
       #`(begin
           (define name 'name)
           (add-global-var `(setv name ,val))))]))

(define-syntax (forever stx)
  (syntax-case stx ()
    [(_ lines ...)
     (with-syntax ()
       #`(define-user-function (update)
           lines
           ...))]))

(define-syntax (on-start stx)
  (syntax-case stx ()
    [(_ lines ...)
     (with-syntax ()
       #`(define-user-function (setup)
           lines
           ...))]))


(define (set-user-functions! thing)
  (set! user-functions thing))

(define (add-user-function f)
  (set-user-functions! (cons f user-functions)))

(define user-functions '())


(define (set-global-vars! thing)
  (set! global-vars thing))

(define (add-global-var f)
  (set-global-vars! (cons f global-vars)))

(define global-vars '())

;fns is a list of hy dfns e.g. (defn update () (print "hi") (print "HI again"))
(define (function-names fns)
  (map second fns))  


(define (set-setup-code! thing)
  (set! setup-code thing))  

(define setup-code '())

(define (add-setup-code . lines)
  (set-setup-code! (append setup-code lines)))

(define hardware-update-code '())

(define (add-to-hardware-update . lines)
  (set! hardware-update-code (append hardware-update-code lines)))

(define (set-main-loop-code! thing)
  (set! main-loop-code thing))  

(define main-loop-code '())

(define (add-main-loop-code-end . lines)
  (set-main-loop-code! (append main-loop-code lines)))

(define (add-main-loop-code-begin . lines)
  (set-main-loop-code! (append lines main-loop-code)))

(define (is-linux?)
  (eq? (system-type 'os) 'unix))

(define (default-cplayboot-path)
  (match (system-type 'os)
    ('macosx    "/Volumes/CPLAYBOOT/")
    ('unix      "/media/usb/")
    ('windows   "D:/")))

(define (default-circuitpy-path)
  (match (system-type 'os)
    ('macosx    "/Volumes/CIRCUITPY/")
    ('unix      "/media/usb/")
    ('windows   "D:/")))

(define (default-package-path)
  (string-append
   (path->string (find-user-pkgs-dir))
   "/circuit-playground/"))

(define cplayboot-path (default-cplayboot-path))
(define circuitpy-path (default-circuitpy-path))
(define package-path   (default-package-path))

(define (set-cplayboot-path! s) (set! cplayboot-path s))
(define (set-circuitpy-path! s) (set! circuitpy-path s))
(define (set-package-path! s)   (set! package-path s))

(define (cplayboot-mode?)
  (and
   (directory-exists? cplayboot-path)
   (file-exists? (string-append cplayboot-path "INDEX.HTM"))))

(define (circuitpy-mode?)
  (and
   (directory-exists? circuitpy-path)
   (not (cplayboot-mode?))))

(current-library-collection-paths)

(define (compile-circ output p)
  (define file-name output)
  (with-output-to-file file-name #:exists 'replace
      (lambda () (printf (strip-hy-imports (compile-py p)))))
  (system (string-append "cat " file-name)))

(define (strip-hy-imports s)
  (define lines (string-split s "\n"))
  (define filtered
    (filter (λ(x)
              (not (regexp-match #rx"hy.core" x)))
            lines))
  (string-join filtered "\n"))


(define (random)
  '(random.random))

(define-function (pick-random s e)
  '(int (+ s (* (- e s) (random.random)))))


(define (sym . xs)
  (define (to-string t)
    (format "~a" t))
  (string->symbol (apply string-append (map to-string xs))))

(define imports '(board time random))

(define (declare-imports . things)
  (set! imports (remove-duplicates (append imports things))))


(define (add-function-if-not-there name)
  (or  (member name (function-names user-functions))
       (add-user-function `(defn ,name ()))))



(define (shove-in-globals-1 fn)
  (append (take fn 3)
          (map (λ(x) `(global ,(second x))) global-vars)
          (drop fn 3)))

(define (shove-in-globals fns)
  (map shove-in-globals-1 fns))


(define (user-code)
  (add-function-if-not-there 'update)
  (add-function-if-not-there 'setup)
  
  (list `(
           (import express)
           (import tslib)
           (import [tslib [*]])
           
           ,@global-vars
           ,@(shove-in-globals user-functions)


           (setup)
           (while True
                  ,@main-loop-code
                  ;(hardware-update) ;Set extra values based on hardware.  Convenience things like sampling...
                  (update)))))


(define (library-code)
  (define (to-statement x) `(import ,x))
  (define import-statements (map to-statement imports))
  
  (list `(
           ,@import-statements

           ,@setup-code)))

(define (run)
  (cond [(circuitpy-mode?) (simple-run)]
        [(cplayboot-mode?) (full-flash)]
        [else (raise "Where's the device?  You may need to plug it in.  Or find the path and call (set-cplayboot-path! s) and (set-circuitpy-path! s).")]))


(define (simple-run)
  (compile-circ
   (string-append circuitpy-path "code.py")
   (user-code))

  ;Uncomment to put the tslib.py file on the CPX.  Doesn't work, though, because CPX doesn't have enough RAM to
  ; load the library.  I'll keep this here in case something changes.
  #;(compile-circ
   (string-append circuitpy-path "tslib.py")
   (library-code))

  
  (and (is-linux?)
   (system "ampy --port /dev/ttyACM0 reset & sleep 2 ; kill $!")) ;This makes the device pick up the changes immediately
  "Success!")

(define (full-flash)
  (copy-file
   (string-append
    package-path
    "/tools/firmware.uf2")
   (string-append cplayboot-path "firmware.uf2"))
  "Device flashing.  Wait a moment and run your program again.")













