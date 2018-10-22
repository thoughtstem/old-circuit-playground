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
   
   (rename-out [py-begin begin]
               [py-set set!]
               [py-cond cond])
   (rename-out [define-user-function define])
   (except-out (all-from-out racket)
               begin
               define
               set!
               cond)
   #%module-begin)


  (require "./api/circuit-python-base.rkt")
  (require "./api/circuit-python.rkt")
  (require "./api/lights.rkt")
  (require "./api/sound.rkt")
  (require "./api/input.rkt")
  (require "./api/output.rkt")
  (require "./api/accel.rkt")
  (require "./api/servo.rkt")
  (require "./api/ir.rkt")
  (require "./api/rgb_helper.rkt")
 

  (and (eq? (system-type 'os) 'unix)
       (not 
        (string-contains? 
         (with-output-to-string 
           (thunk (system "hy --version")))
         "0.14"))
       (begin
         (displayln "One moment.  Installing hy.  This is a one-time thing.")
         (system "sudo pip install git+http://github.com/hylang/hy.git@0.14.0")))

  )