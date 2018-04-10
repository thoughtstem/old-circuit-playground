#lang racket

(require "./circuit-python-base.rkt")
(require "./circuit-python.rkt")

(provide on-ir
         send-ir
         )

(declare-imports 'sys
                 'board
                 'time
                 'IRLibDecodeBase
                 'IRLib_P01_NECd
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

(define-function (reset-receiver)
  '(myReceiver.recvBuffer.deinit)
  '(myReceiver.enableIRIn))

(define-function (ir-receive)
  '(global last-sent-time)
  '(global current-ir-number)
  '(global state)

  '(do
       (if (= last-sent-time 0) 
           (do
               ;(print "Results??")
               (setv can_decode False)
               (try
                (do
                  
                  (setv can_decode (myReceiver.getResults)))
                (except [hy-SQUARE]
                        (reset-receiver)))
               (if (and can_decode (myDecoder.decode))
                   (do
                     (print "Results!!")
                     (setv last-ir-number myDecoder.value)
                     (print myDecoder.value)
                     (setv last-received-address myDecoder.address)
                     (setv current-ir-number last-ir-number)
                     ;(print "RESETTING")
                     (reset-receiver))
                   #;(do
                     ;(print "Resetting current")
                     (setv current-ir-number False))))
           (do
               (setv last-sent-time (- last-sent-time 1))))))

(add-main-loop-code-end
 (ir-receive))

(define-syntax (on-ir stx)
  (syntax-case stx ()
    [(_ n lines ...)
     (with-syntax ()
       #`(let ([n 'tslib.current-ir-number])
           (add-main-loop-code-end
            `(do
                 ,lines ...
                 (setv tslib.current-ir-number False)))))]))

(define-function (send-ir n)
  '(global mySend)
  '(global last-sent-time)
  '(setv   last-sent-time 20)
  '(print "SENDING")
  '(if (hasattr mySend "irSend")   (mySend.irSend.deinit))
  '(if (hasattr mySend "irPWM")    (mySend.irPWM.deinit))
  '(if express.cpx._sample         (express.cpx._sample.deinit))
  '(if express.cpx._sample         (setv express.cpx._sample None))
  '(if express.cpx._speaker_enable (express.cpx._speaker_enable.deinit))
  '(if express.cpx._speaker_enable (setv express.cpx._speaker_enable None))
  `(mySend.send ,n 0x6))



