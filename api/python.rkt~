#lang racket

(provide python
         compile-py)

(define-syntax (python stx)
  (syntax-case stx ()
    [(_ lines ... )
     #`(list '(lines ...))]))




(define (id-to-hy i)
  (cond [(string=? "hy-DOT" (format "~s" i)) "."]
        [else (format "~s" i)]))


(define (fix-square-brackets s)
  (format "[~a]" (substring s 1 (- (string-length s) 1))))

(define (fix-curly-brackets s)
  (format "{~a}" (substring s 1 (- (string-length s) 1))))

(define (list-to-hy l)
  (cond [(and (list? l) (not (empty? l)) (string=? "hy-SQUARE" (format "~a" (first l)))) (fix-square-brackets (format "~a" (map line-to-hy (rest l))))]
        [(and (list? l) (not (empty? l)) (string=? "hy-CURLY" (format "~a" (first l)))) (fix-curly-brackets (format "~a" (map line-to-hy (rest l))))]
        
        [else (format "~a" (map line-to-hy l))]))

(define (line-to-hy l)
  (if (list? l)
      (list-to-hy l)
      (id-to-hy l)))

(define (compile-phase-1 p)
  (define s (line-to-hy (first p))) ;Peel off the extra list nesting created by python macro...
  (substring
   s
   1
   (- (string-length s) 1))) ;Peel off the outer parens...

(define (compile-py p)
  (make-directory* "py-compile")
  (with-output-to-file "py-compile/out.hy" #:exists 'replace
      (lambda () (printf (compile-phase-1 p))))
  (define s
    (with-output-to-string
      (lambda () (system "hy2py py-compile/out.hy"))))
  s)
