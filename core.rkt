#lang lazy
(provide (all-defined-out))

#|
    ~ PAIR ~
    - Contract: (func,func) => {func,func}
    - Logic: Takes two arguments and stores them together,
                with both ready to be applied to by any function the pair applies to
|#
(define pair
    (lambda (a)
        (lambda (b)
            (lambda (f) 
                ((f a) b)
            )
        )
    )
)

#|
    ~ NIL ~
    - Contract: (func,func) => func
    - Logic: This is a simple placeholder for building lists off of.
|#
(define nil 
    (lambda (x)
        (lambda (y) y)
    )
)