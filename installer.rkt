#lang racket 

(and (eq? (system-type 'os) 'unix)
     (not 
      (string-contains? 
       (with-output-to-string 
         (thunk (system "hy --version")))
       "0.14"))
     (begin
       (displayln "One moment.  Installing hy.  This is a one-time thing.")
       (system "sudo pip install git+http://github.com/hylang/hy.git@0.14.0")))
