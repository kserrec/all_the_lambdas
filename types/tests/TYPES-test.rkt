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

(define make-error-tests (list
    (test-list-element "make-error(error-type)('err:err')" 
        (read-any ((make-error error-type) "err:err")) "err:err")
    (test-list-element "make-error(bool)('err:bool')" 
        (read-any ((make-error bool) "err:bool")) "err:bool")
    (test-list-element "make-error(nat)('err:nat')" 
        (read-any ((make-error nat) "err:nat")) "err:nat")
    (test-list-element "make-error(int)('err:int')" 
        (read-any ((make-error int) "err:int")) "err:int")
))

(show-results "make-error" make-error-tests)

; ====================================================================


(define is-type-tests (list
    (test-list-element "is-type(error-type)(TRUE)" (b-read ((is-type error-type) TRUE)) "false")
    (test-list-element "is-type(error-type)(FALSE)" (b-read ((is-type error-type) FALSE)) "false")
    (test-list-element "is-type(error-type)(THREE)" (b-read ((is-type error-type) THREE)) "false")
    (test-list-element "is-type(error-type)(ERROR)" (b-read ((is-type error-type) ERROR)) "true")
    (test-list-element "is-type(error-type)(posONE)" (b-read ((is-type error-type) posONE)) "false")

    (test-list-element "is-type(bool)(TRUE)" (b-read ((is-type bool) TRUE)) "true")
    (test-list-element "is-type(bool)(FALSE)" (b-read ((is-type bool) FALSE)) "true")
    (test-list-element "is-type(bool)(ONE)" (b-read ((is-type bool) ONE)) "false")
    (test-list-element "is-type(bool)(negONE)" (b-read ((is-type bool) negONE)) "false")

    (test-list-element "is-type(nat)(ZERO)" (b-read ((is-type nat) ZERO)) "true")
    (test-list-element "is-type(nat)(ONE)" (b-read ((is-type nat) ONE)) "true")
    (test-list-element "is-type(nat)(TWO)" (b-read ((is-type nat) TWO)) "true")
    (test-list-element "is-type(nat)(THREE)" (b-read ((is-type nat) THREE)) "true")
    (test-list-element "is-type(nat)(TRUE)" (b-read ((is-type nat) TRUE)) "false")
    (test-list-element "is-type(nat)(TRUE)" (b-read ((is-type nat) negTHREE)) "false")

    (test-list-element "is-type(int)(negONE)" (b-read ((is-type int) negONE)) "true")
    (test-list-element "is-type(int)(posONE)" (b-read ((is-type int) posONE)) "true")
    (test-list-element "is-type(int)(negTWO)" (b-read ((is-type int) negTWO)) "true")
    (test-list-element "is-type(int)(posTHREE)" (b-read ((is-type int) posTHREE)) "true")
    (test-list-element "is-type(int)(TRUE)" (b-read ((is-type int) TRUE)) "false")
    (test-list-element "is-type(int)(ERROR)" (b-read ((is-type int) ERROR)) "false")
))

(show-results "is-type" is-type-tests)