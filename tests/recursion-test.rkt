#lang s-exp "../macros/lazy-with-macros.rkt"
(require "../macros/macros.rkt")
(require "../logic.rkt"
         "../church.rkt"
         "../recursion.rkt"
         "test-helpers.rkt")

; ====================================================================

(define factorialTests '())

(define (edit-fact written expr str)
    (set! factorialTests (cons (list (string-append (string-append written " -EXPECTED: ") str) (string-append "-ACTUAL: " expr) (string=? expr str)) factorialTests)))

; TEST CASES
(edit-fact "fact(zero)" (n-read (fact zero)) "1")
(edit-fact "fact(one)" (n-read (fact one)) "1")
(edit-fact "fact(two)" (n-read (fact two)) "2")
(edit-fact "fact(three)" (n-read (fact three)) "6")
(edit-fact "fact(four)" (n-read (fact four)) "24")
(edit-fact "fact(five)" (n-read (fact five)) "121")

(displayln "***************************************************")
(display "Factorial Results: ")
(display (filterForFails factorialTests))
(newline)

; ====================================================================

(define fibonacciTests '())

(define (edit-fib written expr str)
    (set! fibonacciTests (cons (list (string-append (string-append written " -EXPECTED: ") str) (string-append "-ACTUAL: " expr) (string=? expr str)) fibonacciTests)))

; TEST CASES
(edit-fib "fib(zero)" (n-read (fib zero)) "0")
(edit-fib "fib(one)" (n-read (fib one)) "1")
(edit-fib "fib(two)" (n-read (fib two)) "1")
(edit-fib "fib(three)" (n-read (fib three)) "2")
(edit-fib "fib(four)" (n-read (fib four)) "3")
(edit-fib "fib(five)" (n-read (fib five)) "5")

(displayln "***************************************************")
(display "Fibonacci Results: ")
(display (filterForFails fibonacciTests))
(newline)


; ====================================================================

(define sumbToNTests '())

(define (edit-sumToN written expr str)
    (set! sumbToNTests (cons (list (string-append (string-append written " -EXPECTED: ") str) (string-append "-ACTUAL: " expr) (string=? expr str)) sumbToNTests)))

; TEST CASES
(edit-sumToN "nSum(zero)" (n-read (nSum zero)) "0")
(edit-sumToN "nSum(one)" (n-read (nSum one)) "1")
(edit-sumToN "nSum(two)" (n-read (nSum two)) "3")
(edit-sumToN "nSum(three)" (n-read (nSum three)) "6")
(edit-sumToN "nSum(four)" (n-read (nSum four)) "10")
(edit-sumToN "nSum(five)" (n-read (nSum five)) "16")

(displayln "***************************************************")
(display "Sum To N Results: ")
(display (filterForFails sumbToNTests))
(newline)