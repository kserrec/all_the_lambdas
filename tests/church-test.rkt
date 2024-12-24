#lang s-exp "../macros/lazy-with-macros.rkt"
(require "../macros/macros.rkt")
(require "../logic.rkt"
         "../church.rkt"
         "helpers/test-helpers.rkt")

; ====================================================================
; ~ CHURCH TESTS ~
; ====================================================================

(define succ-tests (list 
    (test-list-element "succ(zero)" (n-read (succ zero)) "1")
    (test-list-element "succ(one)" (n-read (succ one)) "2")
    (test-list-element "succ(two)" (n-read (succ two)) "3")
    (test-list-element "succ(three)" (n-read (succ three)) "4")
    (test-list-element "succ(four)" (n-read (succ four)) "5")
    (test-list-element "succ(five)" (n-read (succ five)) "6")))

(show-results "succ" succ-tests)

; ====================================================================

(define pred-tests (list 
    (test-list-element "pred(zero)" (n-read (pred zero)) "0")
    (test-list-element "pred(one)" (n-read (pred one)) "0")
    (test-list-element "pred(two)" (n-read (pred two)) "1")
    (test-list-element "pred(three)" (n-read (pred three)) "2")
    (test-list-element "pred(four)" (n-read (pred four)) "3")
    (test-list-element "pred(five)" (n-read (pred five)) "4")))

(show-results "pred" pred-tests)

; ====================================================================

(define add-tests (list 
    (test-list-element "add(zero)(zero)" (n-read ((add zero) zero)) "0")
    (test-list-element "add(zero)(one)" (n-read ((add zero) one)) "1")
    (test-list-element "add(one)(zero)" (n-read ((add one) zero)) "1")
    (test-list-element "add(five)(zero)" (n-read ((add five) zero)) "5")
    (test-list-element "add(one)(one)" (n-read ((add one) one)) "2")
    (test-list-element "add(one)(two)" (n-read ((add one) two)) "3")
    (test-list-element "add(two)(two)" (n-read ((add two) two)) "4")
    (test-list-element "add(four)(five)" (n-read ((add four) five)) "9")
))

(show-results "add" add-tests)

; ====================================================================

(define sub-tests (list 
    (test-list-element "sub(zero)(zero)" (n-read ((sub zero) zero)) "0")
    (test-list-element "sub(zero)(one)" (n-read ((sub zero) one)) "0")
    (test-list-element "sub(one)(zero)" (n-read ((sub one) zero)) "1")
    (test-list-element "sub(five)(zero)" (n-read ((sub five) zero)) "5")
    (test-list-element "sub(one)(one)" (n-read ((sub one) one)) "0")
    (test-list-element "sub(one)(two)" (n-read ((sub one) two)) "0")
    (test-list-element "sub(two)(two)" (n-read ((sub two) two)) "0")
    (test-list-element "sub(five)(three)" (n-read ((sub five) three)) "2")
))

(show-results "sub" sub-tests)

; ====================================================================

(define mult-tests (list 
    (test-list-element "mult(zero)(zero)" (n-read ((mult zero) zero)) "0")
    (test-list-element "mult(zero)(one)" (n-read ((mult zero) one)) "0")
    (test-list-element "mult(one)(zero)" (n-read ((mult one) zero)) "0")
    (test-list-element "mult(five)(zero)" (n-read ((mult five) zero)) "0")
    (test-list-element "mult(one)(one)" (n-read ((mult one) one)) "1")
    (test-list-element "mult(one)(two)" (n-read ((mult one) two)) "2")
    (test-list-element "mult(two)(two)" (n-read ((mult two) two)) "4")
    (test-list-element "mult(five)(three)" (n-read ((mult five) three)) "15")
))

(show-results "mult" mult-tests)

; ====================================================================

(define _exp-tests (list 
    (test-list-element "_exp(zero)(zero)" (n-read ((_exp zero) zero)) "1")
    (test-list-element "_exp(zero)(one)" (n-read ((_exp zero) one)) "0")
    (test-list-element "_exp(one)(zero)" (n-read ((_exp one) zero)) "1")
    (test-list-element "_exp(five)(zero)" (n-read ((_exp five) zero)) "1")
    (test-list-element "_exp(one)(one)" (n-read ((_exp one) one)) "1")
    (test-list-element "_exp(one)(two)" (n-read ((_exp one) two)) "1")
    (test-list-element "_exp(two)(two)" (n-read ((_exp two) two)) "4")
    (test-list-element "_exp(two)(three)" (n-read ((_exp two) three)) "8")
    (test-list-element "_exp(five)(three)" (n-read ((_exp five) three)) "125")
))

(show-results "_exp" _exp-tests)

; ====================================================================

(define isZero-tests (list
    (test-list-element "isZero(zero)" (b-read (isZero zero)) "true")
    (test-list-element "isZero(one)" (b-read (isZero one)) "false")
    (test-list-element "isZero(two)" (b-read (isZero two)) "false")
    (test-list-element "isZero(three)" (b-read (isZero three)) "false")
    (test-list-element "isZero(four)" (b-read (isZero four)) "false")
    (test-list-element "isZero(five)" (b-read (isZero five)) "false")))

(show-results "isZero" isZero-tests)

; ====================================================================

(define gte-tests (list
    (test-list-element "gte(zero)(zero)" (b-read ((gte zero) zero)) "true")
    (test-list-element "gte(zero)(one)" (b-read ((gte zero) one)) "false")
    (test-list-element "gte(one)(zero)" (b-read ((gte one) zero)) "true")
    (test-list-element "gte(five)(zero)" (b-read ((gte five) zero)) "true")
    (test-list-element "gte(one)(one)" (b-read ((gte one) one)) "true")
    (test-list-element "gte(one)(two)" (b-read ((gte one) two)) "false")
    (test-list-element "gte(two)(two)" (b-read ((gte two) two)) "true")
    (test-list-element "gte(two)(three)" (b-read ((gte two) three)) "false")
    (test-list-element "gte(five)(three)" (b-read ((gte five) three)) "true")
))

(show-results "gte" gte-tests)

; ====================================================================

(define lte-tests (list
    (test-list-element "lte(zero)(zero)" (b-read ((lte zero) zero)) "true")
    (test-list-element "lte(zero)(one)" (b-read ((lte zero) one)) "true")
    (test-list-element "lte(one)(zero)" (b-read ((lte one) zero)) "false")
    (test-list-element "lte(five)(zero)" (b-read ((lte five) zero)) "false")
    (test-list-element "lte(one)(one)" (b-read ((lte one) one)) "true")
    (test-list-element "lte(one)(two)" (b-read ((lte one) two)) "true")
    (test-list-element "lte(two)(two)" (b-read ((lte two) two)) "true")
    (test-list-element "lte(two)(three)" (b-read ((lte two) three)) "true")
    (test-list-element "lte(five)(three)" (b-read ((lte five) three)) "false")
))

(show-results "lte" lte-tests)

; ====================================================================

(define eq-tests (list
    (test-list-element "eq(zero)(zero)" (b-read ((eq zero) zero)) "true")
    (test-list-element "eq(zero)(one)" (b-read ((eq zero) one)) "false")
    (test-list-element "eq(one)(zero)" (b-read ((eq one) zero)) "false")
    (test-list-element "eq(five)(zero)" (b-read ((eq five) zero)) "false")
    (test-list-element "eq(one)(one)" (b-read ((eq one) one)) "true")
    (test-list-element "eq(one)(two)" (b-read ((eq one) two)) "false")
    (test-list-element "eq(two)(two)" (b-read ((eq two) two)) "true")
    (test-list-element "eq(two)(three)" (b-read ((eq two) three)) "false")
    (test-list-element "eq(five)(three)" (b-read ((eq five) three)) "false")
))

(show-results "eq" eq-tests)

; ====================================================================

(define gt-tests (list
    (test-list-element "gt(zero)(zero)" (b-read ((gt zero) zero)) "false")
    (test-list-element "gt(zero)(one)" (b-read ((gt zero) one)) "false")
    (test-list-element "gt(one)(zero)" (b-read ((gt one) zero)) "true")
    (test-list-element "gt(five)(zero)" (b-read ((gt five) zero)) "true")
    (test-list-element "gt(one)(one)" (b-read ((gt one) one)) "false")
    (test-list-element "gt(one)(two)" (b-read ((gt one) two)) "false")
    (test-list-element "gt(two)(two)" (b-read ((gt two) two)) "false")
    (test-list-element "gt(two)(three)" (b-read ((gt two) three)) "false")
    (test-list-element "gt(five)(three)" (b-read ((gt five) three)) "true")
))

(show-results "gt" gt-tests)

; ====================================================================

(define lt-tests (list
    (test-list-element "lt(zero)(zero)" (b-read ((lt zero) zero)) "false")
    (test-list-element "lt(zero)(one)" (b-read ((lt zero) one)) "true")
    (test-list-element "lt(one)(zero)" (b-read ((lt one) zero)) "false")
    (test-list-element "lt(five)(zero)" (b-read ((lt five) zero)) "false")
    (test-list-element "lt(one)(one)" (b-read ((lt one) one)) "false")
    (test-list-element "lt(one)(two)" (b-read ((lt one) two)) "true")
    (test-list-element "lt(two)(two)" (b-read ((lt two) two)) "false")
    (test-list-element "lt(two)(three)" (b-read ((lt two) three)) "true")
    (test-list-element "lt(five)(three)" (b-read ((lt five) three)) "false")
))

(show-results "lt" lt-tests)
