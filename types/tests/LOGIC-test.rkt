#lang s-exp "../../macros/lazy-with-macros.rkt"
(require "../../macros/macros.rkt")
(require "../CHURCH.rkt"
         "../INTEGERS.rkt"
         "../LOGIC.rkt"
         "../../tests/helpers/test-helpers.rkt")

; ====================================================================
; ~ TYPED LOGIC TESTS ~
; ====================================================================

(define t-not-tests (list 
    (test-list-element "t-not(TRUE)" (bool-read (t-not TRUE)) "bool:FALSE")
    (test-list-element "t-not(FALSE)" (bool-read (t-not FALSE)) "bool:TRUE")
    (test-list-element "t-not(ONE)" (bool-read (t-not ONE)) "t-not(err:bool)")
    (test-list-element "t-not(FIVE)" (bool-read (t-not FIVE)) "t-not(err:bool)")
    (test-list-element "t-not(negTHREE)" (bool-read (t-not negTHREE)) "t-not(err:bool)")
))

(show-results "t-not" t-not-tests)

; ====================================================================

(define t-and-tests (list
    (test-list-element "t-and(TRUE)(TRUE)" (bool-read ((t-and TRUE) TRUE)) "bool:TRUE")
    (test-list-element "t-and(TRUE)(FALSE)" (bool-read ((t-and TRUE) FALSE)) "bool:FALSE")
    (test-list-element "t-and(FALSE)(TRUE)" (bool-read ((t-and FALSE) TRUE)) "bool:FALSE")
    (test-list-element "t-and(FALSE)(FALSE)" (bool-read ((t-and FALSE) FALSE)) "bool:FALSE")
    (test-list-element "t-and(negTHREE)(TRUE)" (bool-read ((t-and negTHREE) TRUE)) "t-and(arg1(err:bool))")
    (test-list-element "t-and(FALSE)(TWO)" (bool-read ((t-and FALSE) TWO)) "t-and(arg2(err:bool))")
))

(show-results "t-and" t-and-tests)

; ====================================================================

(define t-or-tests (list 
    (test-list-element "t-or(TRUE)(TRUE)" (bool-read ((t-or TRUE) TRUE)) "bool:TRUE")
    (test-list-element "t-or(TRUE)(FALSE)" (bool-read ((t-or TRUE) FALSE)) "bool:TRUE")
    (test-list-element "t-or(FALSE)(TRUE)" (bool-read ((t-or FALSE) TRUE)) "bool:TRUE")
    (test-list-element "t-or(FALSE)(FALSE)" (bool-read ((t-or FALSE) FALSE)) "bool:FALSE")
    (test-list-element "t-or(negTHREE)(TRUE)" (bool-read ((t-or negTHREE) TRUE)) "t-or(arg1(err:bool))")
    (test-list-element "t-or(FALSE)(TWO)" (bool-read ((t-or FALSE) TWO)) "t-or(arg2(err:bool))")
))

(show-results "t-or" t-or-tests)

; ====================================================================

(define t-xor-tests (list 
    (test-list-element "t-xor(TRUE)(TRUE)" (bool-read ((t-xor TRUE) TRUE)) "bool:FALSE")
    (test-list-element "t-xor(TRUE)(FALSE)" (bool-read ((t-xor TRUE) FALSE)) "bool:TRUE")
    (test-list-element "t-xor(FALSE)(TRUE)" (bool-read ((t-xor FALSE) TRUE)) "bool:TRUE")
    (test-list-element "t-xor(FALSE)(FALSE)" (bool-read ((t-xor FALSE) FALSE)) "bool:FALSE")
    (test-list-element "t-xor(negTHREE)(TRUE)" (bool-read ((t-xor negTHREE) TRUE)) "t-xor(arg1(err:bool))")
    (test-list-element "t-xor(FALSE)(TWO)" (bool-read ((t-xor FALSE) TWO)) "t-xor(arg2(err:bool))")
))

(show-results "t-xor" t-xor-tests)

; ====================================================================

(define t-nor-tests (list 
    (test-list-element "t-nor(TRUE)(TRUE)" (bool-read ((t-nor TRUE) TRUE)) "bool:FALSE")
    (test-list-element "t-nor(TRUE)(FALSE)" (bool-read ((t-nor TRUE) FALSE)) "bool:FALSE")
    (test-list-element "t-nor(FALSE)(TRUE)" (bool-read ((t-nor FALSE) TRUE)) "bool:FALSE")
    (test-list-element "t-nor(FALSE)(FALSE)" (bool-read ((t-nor FALSE) FALSE)) "bool:TRUE")
    (test-list-element "t-nor(negTHREE)(TRUE)" (bool-read ((t-nor negTHREE) TRUE)) "t-nor(arg1(err:bool))")
    (test-list-element "t-nor(FALSE)(TWO)" (bool-read ((t-nor FALSE) TWO)) "t-nor(arg2(err:bool))")
))

(show-results "t-nor" t-nor-tests)

; ====================================================================

(define t-nand-tests (list 
    (test-list-element "t-nand(TRUE)(TRUE)" (bool-read ((t-nand TRUE) TRUE)) "bool:FALSE")
    (test-list-element "t-nand(TRUE)(FALSE)" (bool-read ((t-nand TRUE) FALSE)) "bool:TRUE")
    (test-list-element "t-nand(FALSE)(TRUE)" (bool-read ((t-nand FALSE) TRUE)) "bool:TRUE")
    (test-list-element "t-nand(FALSE)(FALSE)" (bool-read ((t-nand FALSE) FALSE)) "bool:TRUE")
    (test-list-element "t-nand(negTHREE)(TRUE)" (bool-read ((t-nand negTHREE) TRUE)) "t-nand(arg1(err:bool))")
    (test-list-element "t-nand(FALSE)(TWO)" (bool-read ((t-nand FALSE) TWO)) "t-nand(arg2(err:bool))")
))

(show-results "t-nand" t-nand-tests)