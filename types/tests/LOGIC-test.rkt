#lang s-exp "../../macros/lazy-with-macros.rkt"
(require "../../macros/macros.rkt")
(require "../CHURCH.rkt"
         "../INTEGERS.rkt"
         "../LOGIC.rkt"
         "../TYPES.rkt"
         "../../tests/helpers/test-helpers.rkt")

; ====================================================================
; ~ TYPED LOGIC TESTS ~
; ====================================================================

(define NOT-tests (list 
    ; normal
    (test-list-element "NOT(TRUE)" (read-any (NOT TRUE)) "bool:FALSE")
    (test-list-element "NOT(FALSE)" (read-any (NOT FALSE)) "bool:TRUE")
    ; type fails
    (test-list-element "NOT(ONE)" (read-any (NOT ONE)) "NOT(err:bool)")
    (test-list-element "NOT(FIVE)" (read-any (NOT FIVE)) "NOT(err:bool)")
    (test-list-element "NOT(negTHREE)" (read-any (NOT negTHREE)) "NOT(err:bool)")
))

(show-results "NOT" NOT-tests)

; ====================================================================

(define AND-tests (list
    ; normal
    (test-list-element "AND(TRUE)(TRUE)" (read-any ((AND TRUE) TRUE)) "bool:TRUE")
    (test-list-element "AND(TRUE)(FALSE)" (read-any ((AND TRUE) FALSE)) "bool:FALSE")
    (test-list-element "AND(FALSE)(TRUE)" (read-any ((AND FALSE) TRUE)) "bool:FALSE")
    (test-list-element "AND(FALSE)(FALSE)" (read-any ((AND FALSE) FALSE)) "bool:FALSE")
    ; type fails
    (test-list-element "AND(negTHREE)(TRUE)" (read-any ((AND negTHREE) TRUE)) "AND(arg1(err:bool))")
    (test-list-element "AND(FALSE)(TWO)" (read-any ((AND FALSE) TWO)) "AND(arg2(err:bool))")
))

(show-results "AND" AND-tests)

; ====================================================================

(define OR-tests (list 
    ; normal
    (test-list-element "OR(TRUE)(TRUE)" (read-any ((OR TRUE) TRUE)) "bool:TRUE")
    (test-list-element "OR(TRUE)(FALSE)" (read-any ((OR TRUE) FALSE)) "bool:TRUE")
    (test-list-element "OR(FALSE)(TRUE)" (read-any ((OR FALSE) TRUE)) "bool:TRUE")
    (test-list-element "OR(FALSE)(FALSE)" (read-any ((OR FALSE) FALSE)) "bool:FALSE")
    ; type fails
    (test-list-element "OR(negTHREE)(TRUE)" (read-any ((OR negTHREE) TRUE)) "OR(arg1(err:bool))")
    (test-list-element "OR(FALSE)(TWO)" (read-any ((OR FALSE) TWO)) "OR(arg2(err:bool))")
))

(show-results "OR" OR-tests)

; ====================================================================

(define XOR-tests (list 
    ; normal
    (test-list-element "XOR(TRUE)(TRUE)" (read-any ((XOR TRUE) TRUE)) "bool:FALSE")
    (test-list-element "XOR(TRUE)(FALSE)" (read-any ((XOR TRUE) FALSE)) "bool:TRUE")
    (test-list-element "XOR(FALSE)(TRUE)" (read-any ((XOR FALSE) TRUE)) "bool:TRUE")
    (test-list-element "XOR(FALSE)(FALSE)" (read-any ((XOR FALSE) FALSE)) "bool:FALSE")
    ; type fails
    (test-list-element "XOR(negTHREE)(TRUE)" (read-any ((XOR negTHREE) TRUE)) "XOR(arg1(err:bool))")
    (test-list-element "XOR(FALSE)(TWO)" (read-any ((XOR FALSE) TWO)) "XOR(arg2(err:bool))")
))

(show-results "XOR" XOR-tests)

; ====================================================================

(define NOR-tests (list
    ; normal
    (test-list-element "NOR(TRUE)(TRUE)" (read-any ((NOR TRUE) TRUE)) "bool:FALSE")
    (test-list-element "NOR(TRUE)(FALSE)" (read-any ((NOR TRUE) FALSE)) "bool:FALSE")
    (test-list-element "NOR(FALSE)(TRUE)" (read-any ((NOR FALSE) TRUE)) "bool:FALSE")
    (test-list-element "NOR(FALSE)(FALSE)" (read-any ((NOR FALSE) FALSE)) "bool:TRUE")
    ; type fails
    (test-list-element "NOR(negTHREE)(TRUE)" (read-any ((NOR negTHREE) TRUE)) "NOR(arg1(err:bool))")
    (test-list-element "NOR(FALSE)(TWO)" (read-any ((NOR FALSE) TWO)) "NOR(arg2(err:bool))")
))

(show-results "NOR" NOR-tests)

; ====================================================================

(define NAND-tests (list 
    ; normal
    (test-list-element "NAND(TRUE)(TRUE)" (read-any ((NAND TRUE) TRUE)) "bool:FALSE")
    (test-list-element "NAND(TRUE)(FALSE)" (read-any ((NAND TRUE) FALSE)) "bool:TRUE")
    (test-list-element "NAND(FALSE)(TRUE)" (read-any ((NAND FALSE) TRUE)) "bool:TRUE")
    (test-list-element "NAND(FALSE)(FALSE)" (read-any ((NAND FALSE) FALSE)) "bool:TRUE")
    ; type fails
    (test-list-element "NAND(negTHREE)(TRUE)" (read-any ((NAND negTHREE) TRUE)) "NAND(arg1(err:bool))")
    (test-list-element "NAND(FALSE)(TWO)" (read-any ((NAND FALSE) TWO)) "NAND(arg2(err:bool))")
))

(show-results "NAND" NAND-tests)