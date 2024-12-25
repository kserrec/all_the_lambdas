#lang s-exp "../macros/lazy-with-macros.rkt"
(require "../macros/macros.rkt")
(require "../division.rkt"
         "../logic.rkt"
         "../church.rkt"
         "helpers/test-helpers.rkt")

; ====================================================================
; ~ DIVISION TESTS ~
; ====================================================================

(define div-tests (list
    (test-list-element "div(zero)(two)" (n-read ((div zero) two)) "0")
    (test-list-element "div(one)(two)" (n-read ((div one) two)) "0")
    (test-list-element "div(two)(two)" (n-read ((div two) two)) "1")
    (test-list-element "div(three)(three)" (n-read ((div three) three)) "1")
    (test-list-element "div(four)(two)" (n-read ((div four) two)) "2")
    (test-list-element "div(five)(two)" (n-read ((div five) two)) "2")
    ))

(show-results "div" div-tests)

; ====================================================================

(define mod-tests (list
    (test-list-element "mod(zero)(two)" (n-read ((mod zero) two)) "0")
    (test-list-element "mod(one)(two)" (n-read ((mod one) two)) "1")
    (test-list-element "mod(two)(two)" (n-read ((mod two) two)) "0")
    (test-list-element "mod(three)(three)" (n-read ((mod three) three)) "0")
    (test-list-element "mod(four)(two)" (n-read ((mod four) two)) "0")
    (test-list-element "mod(five)(two)" (n-read ((mod five) two)) "1")
    (test-list-element "mod(add(five)(two))(four)" (n-read ((mod ((add five) two)) four)) "3")
    ))

(show-results "mod" mod-tests)

; ====================================================================

(define isEven-tests (list
    (test-list-element "isEven(zero)" (b-read (isEven zero)) "true")
    (test-list-element "isEven(one)" (b-read (isEven one)) "false")
    (test-list-element "isEven(two)" (b-read (isEven two)) "true")
    (test-list-element "isEven(three)" (b-read (isEven three)) "false")
    (test-list-element "isEven(four)" (b-read (isEven four)) "true")
    (test-list-element "isEven(five)" (b-read (isEven five)) "false")
    ))

(show-results "isEven" isEven-tests)

; ====================================================================

(define isOdd-tests (list
    (test-list-element "isOdd(zero)" (b-read (isOdd zero)) "false")
    (test-list-element "isOdd(one)" (b-read (isOdd one)) "true")
    (test-list-element "isOdd(two)" (b-read (isOdd two)) "false")
    (test-list-element "isOdd(three)" (b-read (isOdd three)) "true")
    (test-list-element "isOdd(four)" (b-read (isOdd four)) "false")
    (test-list-element "isOdd(five)" (b-read (isOdd five)) "true")
    ))

(show-results "isOdd" isOdd-tests)

