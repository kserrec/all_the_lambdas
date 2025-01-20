#lang s-exp "../../../macros/lazy-with-macros.rkt"
(require "../../../macros/macros.rkt")
(require "../CHURCH.rkt"
         "../INTEGERS.rkt"
         "../LOGIC.rkt"
         "../TYPES.rkt"
         "../../TYPES.rkt"
         "../../../tests/helpers/test-helpers.rkt")

; ====================================================================
; ~ COERCED TYPE LOGIC TESTS ~
; ====================================================================

(define NOT-tests (list 
    ; normal
    (test-list-element "NOT(FALSE)" (read-any (NOT FALSE)) "bool:TRUE")
    (test-list-element "NOT(TRUE)" (read-any (NOT TRUE)) "bool:FALSE")
    ; coercing
    (test-list-element "NOT(TWO)" (read-any (NOT TWO)) "bool:FALSE")
    (test-list-element "NOT(ZERO)" (read-any (NOT ZERO)) "bool:TRUE")
    (test-list-element "NOT(negTHREE)" (read-any (NOT negTHREE)) "bool:FALSE")
))

(show-results "NOT" NOT-tests)

; ====================================================================

(define AND-tests (list
    (test-list-element "AND(TRUE)(TRUE)" (read-any ((AND TRUE) TRUE)) "bool:TRUE")
    (test-list-element "AND(TRUE)(FALSE)" (read-any ((AND TRUE) FALSE)) "bool:FALSE")
    (test-list-element "AND(FALSE)(TRUE)" (read-any ((AND FALSE) TRUE)) "bool:FALSE")
    (test-list-element "AND(FALSE)(FALSE)" (read-any ((AND FALSE) FALSE)) "bool:FALSE")
    ; coercing
    (test-list-element "AND(TRUE)(FIVE)" (read-any ((AND TRUE) FIVE)) "bool:TRUE")
    (test-list-element "AND(posFOUR)(FALSE)" (read-any ((AND posFOUR) FALSE)) "bool:FALSE")
))

(show-results "AND" AND-tests)

; ====================================================================

(define OR-tests (list
    (test-list-element "OR(TRUE)(TRUE)" (read-any ((OR TRUE) TRUE)) "bool:TRUE")
    (test-list-element "OR(TRUE)(FALSE)" (read-any ((OR TRUE) FALSE)) "bool:TRUE")
    (test-list-element "OR(FALSE)(TRUE)" (read-any ((OR FALSE) TRUE)) "bool:TRUE")
    (test-list-element "OR(FALSE)(FALSE)" (read-any ((OR FALSE) FALSE)) "bool:FALSE")
    ; coercing
    (test-list-element "OR(TRUE)(FIVE)" (read-any ((OR TRUE) FIVE)) "bool:TRUE")
    (test-list-element "OR(posFOUR)(FALSE)" (read-any ((OR posFOUR) FALSE)) "bool:TRUE")
))

(show-results "OR" OR-tests)

; ====================================================================

(define XOR-tests (list
    (test-list-element "XOR(TRUE)(TRUE)" (read-any ((XOR TRUE) TRUE)) "bool:FALSE")
    (test-list-element "XOR(TRUE)(FALSE)" (read-any ((XOR TRUE) FALSE)) "bool:TRUE")
    (test-list-element "XOR(FALSE)(TRUE)" (read-any ((XOR FALSE) TRUE)) "bool:TRUE")
    (test-list-element "XOR(FALSE)(FALSE)" (read-any ((XOR FALSE) FALSE)) "bool:FALSE")
    ; coercing
    (test-list-element "XOR(TRUE)(FIVE)" (read-any ((XOR TRUE) FIVE)) "bool:FALSE")
    (test-list-element "XOR(posFOUR)(FALSE)" (read-any ((XOR posFOUR) FALSE)) "bool:TRUE")
))

(show-results "XOR" XOR-tests)

; ====================================================================

(define NOR-tests (list
    (test-list-element "NOR(TRUE)(TRUE)" (read-any ((NOR TRUE) TRUE)) "bool:FALSE")
    (test-list-element "NOR(TRUE)(FALSE)" (read-any ((NOR TRUE) FALSE)) "bool:FALSE")
    (test-list-element "NOR(FALSE)(TRUE)" (read-any ((NOR FALSE) TRUE)) "bool:FALSE")
    (test-list-element "NOR(FALSE)(FALSE)" (read-any ((NOR FALSE) FALSE)) "bool:TRUE")
    ; coercing
    (test-list-element "NOR(TRUE)(FIVE)" (read-any ((NOR TRUE) FIVE)) "bool:FALSE")
    (test-list-element "NOR(posFOUR)(FALSE)" (read-any ((NOR posFOUR) FALSE)) "bool:FALSE")
))

(show-results "NOR" NOR-tests)

; ====================================================================

(define NAND-tests (list
    (test-list-element "NAND(TRUE)(TRUE)" (read-any ((NAND TRUE) TRUE)) "bool:FALSE")
    (test-list-element "NAND(TRUE)(FALSE)" (read-any ((NAND TRUE) FALSE)) "bool:TRUE")
    (test-list-element "NAND(FALSE)(TRUE)" (read-any ((NAND FALSE) TRUE)) "bool:TRUE")
    (test-list-element "NAND(FALSE)(FALSE)" (read-any ((NAND FALSE) FALSE)) "bool:TRUE")
    ; coercing
    (test-list-element "NAND(TRUE)(FIVE)" (read-any ((NAND TRUE) FIVE)) "bool:FALSE")
    (test-list-element "NAND(posFOUR)(FALSE)" (read-any ((NAND posFOUR) FALSE)) "bool:TRUE")
))

(show-results "NAND" NAND-tests)

; ====================================================================

