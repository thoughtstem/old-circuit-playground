(module circuit-playground-module racket
  (provide
   
   (all-from-out "./api/circuit-python-base.rkt")
   (all-from-out "./api/circuit-python.rkt")
   (all-from-out "./api/lights.rkt")
   (all-from-out "./api/sound.rkt")
   (all-from-out "./api/input.rkt")
   (all-from-out "./api/output.rkt")
   (all-from-out "./api/accel.rkt")
   (all-from-out "./api/servo.rkt")
   (all-from-out "./api/ir.rkt")
   (all-from-out "./api/rgb_helper.rkt")
   (rename-out [begin racket-begin])
   
   (rename-out [fancy-begin begin]
               [py-set set!]
               [py-cond cond])
   (rename-out [define-user-function define])
   (except-out (all-from-out racket)
               begin
               define
               set!
               cond)
   #%module-begin)


  (require (for-syntax racket))
  (define-syntax (fancy-begin stx)
    (define full-s (~a (syntax->datum stx)))
    (define inners (rest (syntax->datum stx)))

    (if (string-contains? full-s "(require ")
        #`(r:begin #,@inners)
        #`(py-begin #,@inners)))
    

  (require (prefix-in r: racket))
  (require "./installer.rkt")
  (require "./api/circuit-python-base.rkt")
  (require "./api/circuit-python.rkt")
  (require "./api/lights.rkt")
  (require "./api/sound.rkt")
  (require "./api/input.rkt")
  (require "./api/output.rkt")
  (require "./api/accel.rkt")
  (require "./api/servo.rkt")
  (require "./api/ir.rkt")
  (require "./api/rgb_helper.rkt") )
