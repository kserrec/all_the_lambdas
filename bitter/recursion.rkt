#lang lazy
(provide (all-defined-out))
(require "logic.rkt"
         "church.rkt")

;===================================================
; RECURSION
;===================================================

#|
    ~ Y-COMBINATOR ~
    - Contract: YF => F(YF)
    - Logic: Classic Y-Combinator:
                Takes function f and uses double self-application with it to make fixed point
|#
(define Y 
    (lambda (f)
        ((lambda (x) (f (x x)))
         (lambda (x) (f (x x))))
    )
)

;===================================================

#|
    ~ FACTORIAL ~
    - Contract: nat => nat
    - Logic: Classic Factorial:
                def fact(n) = if(n==0)
                                then 1
                                else n*fact(n-1)
|#
(define fact  (Y fact-helper))

; FACT-HELPER
(define fact-helper
    (lambda (f)
        (lambda (n)
            (((isZero n)              
                one)                    
                ((mult n) (f (pred n)))
            )
        )
    )
)

;===================================================

#|
    ~ FIBONACCI ~
    - Contract: nat => nat
    - Logic: Classic Fibonacci:
                def fib(n) = if(n==0)
                                then 0
                                else if(n==1)
                                    then 1
                                    else fib(n-2)+fib(n-1)
|#
(define fib  (Y fib-helper))

; FIB-HELPER
(define fib-helper
    (lambda (f)
        (lambda (n)
            (((isZero n)
                zero)
                (((isZero (pred n))
                    one)
                    ((add (f ((two pred) n))) (f (pred n)))
                )
            )
        )
    )
)

;===================================================

#|
    ~ SUM-UP-TO-N ~
    - Contract: nat => nat
    - Logic: Classic Sum Up To N:
                def nSum(n) = if(n==0)
                                then 0
                                else n+nSum(n-1)
|#
(define nSum  (Y nSum-helper))

; N-SUM
(define nSum-helper
    (lambda (f)
        (lambda (n)
            (((isZero n)
                zero)
                ((add n) (f (pred n)))
            )
        )
    )
)

;===================================================
