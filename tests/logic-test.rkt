#lang s-exp "../macros/lazy-with-macros.rkt"
(require "../macros/macros.rkt")
(require "../logic.rkt"
         "helpers/test-helpers.rkt")

; ====================================================================
; ~ LOGIC TESTS ~
; ====================================================================

(define _not-tests (list 
    (test-list-element "_not(true)" (b-read (_not true)) "false")
    (test-list-element "_not(false)" (b-read (_not false)) "true")))

(show-results "_not" _not-tests)

; ====================================================================

(define _and-tests (list
    (test-list-element "_and(true)(true)" (b-read ((_and true) true)) "true")
    (test-list-element "_and(true)(false)" (b-read ((_and true) false)) "false")
    (test-list-element "_and(false)(true)" (b-read ((_and false) true)) "false")
    (test-list-element "_and(false)(false)" (b-read ((_and false) false)) "false")))

(show-results "_and" _and-tests)

; ====================================================================

(define _or-tests (list
    (test-list-element "_or(true)(true)" (b-read ((_or true) true)) "true")
    (test-list-element "_or(true)(false)" (b-read ((_or true) false)) "true")
    (test-list-element "_or(false)(true)" (b-read ((_or false) true)) "true")
    (test-list-element "_or(false)(false)" (b-read ((_or false) false)) "false")))

(show-results "_or" _or-tests)

; ====================================================================

(define xor-tests (list
    (test-list-element "xor(true)(true)" (b-read ((xor true) true)) "false")
    (test-list-element "xor(true)(false)" (b-read ((xor true) false)) "true")
    (test-list-element "xor(false)(true)" (b-read ((xor false) true)) "true")
    (test-list-element "xor(false)(false)" (b-read ((xor false) false)) "false")))

(show-results "xor" xor-tests)

; ====================================================================

(define nor-tests (list
    (test-list-element "nor(true)(true)" (b-read ((nor true) true)) "false")
    (test-list-element "nor(true)(false)" (b-read ((nor true) false)) "false")
    (test-list-element "nor(false)(true)" (b-read ((nor false) true)) "false")
    (test-list-element "nor(false)(false)" (b-read ((nor false) false)) "true")))

(show-results "nor" nor-tests)

; ====================================================================

(define nand-tests (list
    (test-list-element "nand(true)(true)" (b-read ((nand true) true)) "false")
    (test-list-element "nand(true)(false)" (b-read ((nand true) false)) "true")
    (test-list-element "nand(false)(true)" (b-read ((nand false) true)) "true")
    (test-list-element "nand(false)(false)" (b-read ((nand false) false)) "true")))

(show-results "nand" nand-tests)