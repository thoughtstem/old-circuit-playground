#lang racket

(define (read-hook)
  (printf "Read thread started ...")
  (read-loop))

(define (read-loop)
  (displayln "READ")
  (process-input (read-byte in))
  (read-loop))

(define (process-input data)
  (displayln data))

(define port-name "/dev/tty.usbmodem1411")

(define call-string (string-append "stty -F " port-name " cs8 115200 cread clocal")) 

(define out (open-output-file port-name #:mode 'binary #:exists 'append)) 
(define in  (open-input-file  port-name #:mode 'binary)) 
(file-stream-buffer-mode out 'none)

(sleep 2)
(if (system call-string) ;; here we set the port
    (begin
      (sleep 1)
      (let ([ read-thread (thread (lambda ()  (read-hook)))]) ;; we set the reading thread
       
        (printf "Success opening port\n")
        #t))
    (error "Failed to open the connection with " port-name " verify if your microcontroller is plugged in correctly"))            
