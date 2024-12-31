#lang lazy
(require (for-syntax racket/base))
(provide def _let _if _cons)

(define _pair
    (lambda (a)
        (lambda (b)
            (lambda (f) 
                ((f a) b)
            )
        )
    )
)

(define _nil 
    (lambda (x) 
        (lambda (y) y)
    )
)

(define-syntax (def stx)
  (syntax-case stx (=)
    [(_ name = body)
     #'(define name body)]
    [(_ name arg1 = body)
     #'(define name (lambda (arg1) body))]
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
                   (lambda (arg6) body)))))))]
    [(_ name arg1 arg2 arg3 arg4 arg5 arg6 arg7 = body)
     #'(define name
         (lambda (arg1)
           (lambda (arg2)
             (lambda (arg3)
               (lambda (arg4)
                 (lambda (arg5) 
                   (lambda (arg6) 
                    (lambda (arg7) body))))))))]
    [(_ name arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 = body)
     #'(define name
         (lambda (arg1)
           (lambda (arg2)
             (lambda (arg3)
               (lambda (arg4)
                 (lambda (arg5) 
                   (lambda (arg6) 
                    (lambda (arg7) 
                      (lambda (arg8) body)))))))))]
    [(_ name arg1 arg2 arg3 arg4 arg5 arg6 arg7 arg8 arg9 = body)
     #'(define name
         (lambda (arg1)
           (lambda (arg2)
             (lambda (arg3)
               (lambda (arg4)
                 (lambda (arg5) 
                   (lambda (arg6) 
                    (lambda (arg7) 
                      (lambda (arg8) 
                        (lambda (arg9) body))))))))))]))

(define-syntax (_let stx)
  (syntax-case stx (=)
    [(_ name = expr body)
     #'((lambda (name) body) expr)]))

(define-syntax (_if stx)
  (syntax-case stx (_then)
    [(_ CONDITION _then THEN _else ELSE)
     #'((CONDITION THEN) ELSE)]))

(define-syntax _cons
  (syntax-rules ()
    [(_)
     _nil]
    [(_ head rest ...)
     ;; Construct the pair by partially applying _pair to head,
     ;; then recursively expand the remaining elements.
     ((_pair head) (_cons rest ...))]))