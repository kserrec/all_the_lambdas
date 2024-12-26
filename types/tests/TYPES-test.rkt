#lang s-exp "../../macros/lazy-with-macros.rkt"
(require "../../macros/macros.rkt")
(require "../../logic.rkt"
         "../../church.rkt"
         "../../tests/helpers/test-helpers.rkt")
(require "../CHURCH.rkt"
         "../INTEGERS.rkt"
         "../LOGIC.rkt"
         "../TYPES.rkt")

; ====================================================================
; ~ TYPED LOGIC TESTS ~
; ====================================================================

(define make-err-tests (list
    (test-list-element "make-err(error-type)('err:err')" 
        (err-read ((make-error error-type) "err:err")) "err:err")
    (test-list-element "make-err(bool-type)('err:bool')" 
        (err-read ((make-error bool-type) "err:bool")) "err:bool")
    (test-list-element "make-err(nat-type)('err:nat')" 
        (err-read ((make-error nat-type) "err:nat")) "err:nat")
    (test-list-element "make-err(int-type)('err:int')" 
        (err-read ((make-error int-type) "err:int")) "err:int")
))

(show-results "make-err" make-err-tests)

; ====================================================================


(define is-type-tests (list
    (test-list-element "is-type(error-type)(TRUE)" (b-read ((is-type error-type) TRUE)) "false")
    (test-list-element "is-type(error-type)(FALSE)" (b-read ((is-type error-type) FALSE)) "false")
    (test-list-element "is-type(error-type)(THREE)" (b-read ((is-type error-type) THREE)) "false")
    (test-list-element "is-type(error-type)(ERROR)" (b-read ((is-type error-type) ERROR)) "true")
    (test-list-element "is-type(error-type)(posONE)" (b-read ((is-type error-type) posONE)) "false")

    (test-list-element "is-type(bool-type)(TRUE)" (b-read ((is-type bool-type) TRUE)) "true")
    (test-list-element "is-type(bool-type)(FALSE)" (b-read ((is-type bool-type) FALSE)) "true")
    (test-list-element "is-type(bool-type)(ONE)" (b-read ((is-type bool-type) ONE)) "false")
    (test-list-element "is-type(bool-type)(negONE)" (b-read ((is-type bool-type) negONE)) "false")

    (test-list-element "is-type(nat-type)(ZERO)" (b-read ((is-type nat-type) ZERO)) "true")
    (test-list-element "is-type(nat-type)(ONE)" (b-read ((is-type nat-type) ONE)) "true")
    (test-list-element "is-type(nat-type)(TWO)" (b-read ((is-type nat-type) TWO)) "true")
    (test-list-element "is-type(nat-type)(THREE)" (b-read ((is-type nat-type) THREE)) "true")
    (test-list-element "is-type(nat-type)(TRUE)" (b-read ((is-type nat-type) TRUE)) "false")
    (test-list-element "is-type(nat-type)(TRUE)" (b-read ((is-type nat-type) negTHREE)) "false")

    (test-list-element "is-type(int-type)(negONE)" (b-read ((is-type int-type) negONE)) "true")
    (test-list-element "is-type(int-type)(posONE)" (b-read ((is-type int-type) posONE)) "true")
    (test-list-element "is-type(int-type)(negTWO)" (b-read ((is-type int-type) negTWO)) "true")
    (test-list-element "is-type(int-type)(posTHREE)" (b-read ((is-type int-type) posTHREE)) "true")
    (test-list-element "is-type(int-type)(TRUE)" (b-read ((is-type int-type) TRUE)) "false")
    (test-list-element "is-type(int-type)(ERROR)" (b-read ((is-type int-type) ERROR)) "false")
))

(show-results "is-type" is-type-tests)

; ====================================================================
