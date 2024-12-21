#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
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
(def Y f = ((lambda (x) (f (x x)))
         (lambda (x) (f (x x)))))

;===================================================

#|
    ~ FACTORIAL ~
    - Contract: nat => nat
    - Logic: Classic Factorial:
                def fact(n) = 
                    if(n==0)
                        then 1
                        else n*fact(n-1)
|#
(define fact (Y fact-helper))

; FACT-HELPER
(def fact-helper f n = 
    (_if (isZero n)              
        _then one                   
        _else ((mult n) (f (pred n)))
    )
)

;===================================================

#|
    ~ FIBONACCI ~
    - Contract: nat => nat
    - Logic: Classic Fibonacci:
                def fib(n) = 
                    if(n==0)
                        then 0
                        else if(n==1)
                            then 1
                            else fib(n-2)+fib(n-1)
|#
(define fib  (Y fib-helper))

; FIB-HELPER
(def fib-helper f n = 
    (_if (isZero n)
        _then zero
        _else (_if (isZero (pred n))
                _then one
                _else ((add (f ((two pred) n))) (f (pred n))))))

;===================================================

#|
    ~ SUM-UP-TO-N ~
    - Contract: nat => nat
    - Logic: Classic Sum Up To N:
                def nSum(n) = 
                    if(n==0)
                        then 0
                        else n+nSum(n-1)
|#
(define nSum (Y nSum-helper))

; N-SUM
(def nSum-helper f n =
    (_if (isZero n)
        _then zero
        _else ((add n) (f (pred n)))))

;===================================================
