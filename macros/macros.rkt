#lang lazy
(require (for-syntax racket/base))
(provide def _let _if)

(define-syntax (def stx)
  (syntax-case stx (=)
    [(_ name arg = body)
     #'(define name (lambda (arg) body))]
    [(_ name arg1 arg2 = body)
     #'(define name
         (lambda (arg1)
           (lambda (arg2) body)))]
    [(_ name arg1 arg2 arg3 = body)
     #'(define name
         (lambda (arg1)
           (lambda (arg2)
             (lambda (arg3) body))))]
    [(_ name arg1 arg2 arg3 arg4 = body)
     #'(define name
         (lambda (arg1)
           (lambda (arg2)
             (lambda (arg3)
               (lambda (arg4) body)))))]
    [(_ name arg1 arg2 arg3 arg4 arg5 = body)
     #'(define name
         (lambda (arg1)
           (lambda (arg2)
             (lambda (arg3)
               (lambda (arg4)
                 (lambda (arg5) body))))))]
    [(_ name arg1 arg2 arg3 arg4 arg5 arg6 = body)
     #'(define name
         (lambda (arg1)
           (lambda (arg2)
             (lambda (arg3)
               (lambda (arg4)
                 (lambda (arg5) 
                   (lambda (arg6) body)))))))]))

(define-syntax (_let stx)
  (syntax-case stx (=)
    [(_ name = expr body)
     #'((lambda (name) body) expr)]))

(define-syntax (_if stx)
  (syntax-case stx (_then)
    [(_ CONDITION _then THEN _else ELSE)
     #'((CONDITION THEN) ELSE)]))