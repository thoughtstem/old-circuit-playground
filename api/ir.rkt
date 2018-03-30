#lang racket

(require "./circuit-python-base.rkt")
(require "./circuit-python.rkt")

(provide on-ir
         send-ir
         )

(declare-imports 'board
                 'time
                 'IRLibDecodeBase
                 'IRLib_P01_NECd
                 'IRLib_P02_Sonyd
                 'IRLib_P03_RC5d
                 'IRrecvPCI
                 'IRLib_P01_NECs)

(add-setup-code
 '(defclass MyDecodeClass (IRLibDecodeBase.IRLibDecodeBase)
   (defn __init__ (self)
     (IRLibDecodeBase.IRLibDecodeBase.__init__ self))
  
   (defn decode (self)
     (if (IRLib_P01_NECd.IRdecodeNEC.decode self) 
         True
         False)))
                
  '(setv myDecoder (MyDecodeClass))

  '(setv myReceiver (IRrecvPCI.IRrecvPCI board.REMOTEIN))
  
  '(myReceiver.enableIRIn) 
  '(setv last-ir-number False) 
  '(setv current-ir-number False)
  

  '(setv last-sent-time False)
  '(setv last-recieved-address False)
  '(setv mySend (IRLib_P01_NECs.IRsendNEC board.REMOTEOUT)))

(add-main-loop-code-end
 '(try
   
   (if (= last-sent-time 0)
       (do
         (myReceiver.getResults)
         (if (myDecoder.decode)
             (do
               (setv last-ir-number myDecoder.value)
               (setv last-received-address myDecoder.address)
               (setv current-ir-number myDecoder.value))
             (setv current-ir-number False))
         (myReceiver.enableIRIn))
       (do
         (setv last-sent-time (- last-sent-time 1))
         (print last-sent-time)
         (myReceiver.getResults)
         ))
       
   (except [hy-SQUARE]
           (setv current-ir-number False))))

(define-syntax (on-ir stx)
  (syntax-case stx ()
    [(_ n lines ...)
     (with-syntax ()
       #`(let ([n 'current-ir-number])
           (add-main-loop-code-end
            `(do
                 ,lines ...))))]))

(define-function (send-ir n)
  '(global mySend)
  '(global last-sent-time)
  '(setv   last-sent-time 20) ;;This is not working...
  `(mySend.send ,n 0x6))

(define-function (hardware-update-ir)
  '(global last-ir-number)
  '(global current-ir-number)
  (set state.hardware.last-ir-number 'last-ir-number)
  (set state.hardware.current-ir-number 'current-ir-number))

(add-to-hardware-update
  '(hardware-update-ir))
