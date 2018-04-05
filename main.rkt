#lang racket

(module reader syntax/module-reader
  circuit-playground/circuit-playground-module
  #:wrapper1 (lambda (t)
               (define exp-t (t))
               
               (append exp-t
                       '((run)))))
