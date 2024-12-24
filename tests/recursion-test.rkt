#lang s-exp "../macros/lazy-with-macros.rkt"
(require "../macros/macros.rkt")
(require "../logic.rkt"
         "../church.rkt"
         "../recursion.rkt"
         "helpers/test-helpers.rkt")
         
; ====================================================================
; ~ RECURSION TESTS ~
; ====================================================================

(define fact-tests (list 
    (test-list-element "fact(zero)" (n-read (fact zero)) "1")
    (test-list-element "fact(one)" (n-read (fact one)) "1")
    (test-list-element "fact(two)" (n-read (fact two)) "2")
    (test-list-element "fact(three)" (n-read (fact three)) "6")
    (test-list-element "fact(four)" (n-read (fact four)) "24")
    (test-list-element "fact(five)" (n-read (fact five)) "120")))

(show-results "fact" fact-tests)

; ====================================================================

(define fib-tests (list 
    (test-list-element "fib(zero)" (n-read (fib zero)) "0")
    (test-list-element "fib(one)" (n-read (fib one)) "1")
    (test-list-element "fib(two)" (n-read (fib two)) "1")
    (test-list-element "fib(three)" (n-read (fib three)) "2")
    (test-list-element "fib(four)" (n-read (fib four)) "3")
    (test-list-element "fib(five)" (n-read (fib five)) "5")))

(show-results "fib" fib-tests)

; ====================================================================

(define sum-to-n-tests (list 
    (test-list-element "n-sum(zero)" (n-read (nSum zero)) "0")
    (test-list-element "n-sum(one)" (n-read (nSum one)) "1")
    (test-list-element "n-sum(two)" (n-read (nSum two)) "3")
    (test-list-element "n-sum(three)" (n-read (nSum three)) "6")
    (test-list-element "n-sum(four)" (n-read (nSum four)) "10")
    (test-list-element "n-sum(five)" (n-read (nSum five)) "15")))

(show-results "nSum" sum-to-n-tests)