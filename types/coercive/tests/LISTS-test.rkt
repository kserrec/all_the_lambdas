#lang s-exp "../../../macros/lazy-with-macros.rkt"
(require "../../../macros/macros.rkt")
(require "../CHURCH.rkt"
         "../INTEGERS.rkt"
         "../LISTS.rkt"
         "../LOGIC.rkt"
         "../TYPES.rkt"
         "../../TYPES.rkt"
         "../../../tests/helpers/test-helpers.rkt")

; ====================================================================
; ~ COERCED TYPE LISTS TESTS ~
; ====================================================================


(define LEN-tests (list 
    ; normal cases
    (test-list-element "LEN(NIL-list)" (read-any (LEN NIL-list)) "nat:0")
    (test-list-element "LEN([TRUE])" (read-any (LEN LIST-T)) "nat:1")
    (test-list-element "LEN([FALSE])" (read-any (LEN LIST-F)) "nat:1")
    (test-list-element "LEN([nat:0,nat:1])" (read-any (LEN LIST-0-1)) "nat:2")
    (test-list-element "LEN([2,-3,0,4])" (read-any (LEN LIST-p2-n3-p0-p4)) "nat:4")
    ; coercing
    (test-list-element "LEN(FOUR)" (read-any (LEN FOUR)) "nat:1")
    (test-list-element "LEN(TRUE)" (read-any (LEN TRUE)) "nat:1")
))

(show-results "LEN" LEN-tests)

; ====================================================================


(define IS-NIL-tests (list 
    ; normal cases
    (test-list-element "IS-NIL(NIL-list)" (read-any (IS-NIL NIL-list)) "bool:TRUE")
    (test-list-element "IS-NIL([TRUE])" (read-any (IS-NIL LIST-T)) "bool:FALSE")
    (test-list-element "IS-NIL([FALSE])" (read-any (IS-NIL LIST-F)) "bool:FALSE")
    (test-list-element "IS-NIL([nat:0,nat:1])" (read-any (IS-NIL LIST-0-1)) "bool:FALSE")
    (test-list-element "IS-NIL([2,-3,0,4])" (read-any (IS-NIL LIST-p2-n3-p0-p4)) "bool:FALSE")
    ; coercing
    (test-list-element "IS-NIL(FALSE)" (read-any (IS-NIL FALSE)) "bool:TRUE")
    (test-list-element "IS-NIL(FOUR)" (read-any (IS-NIL FOUR)) "bool:FALSE")
))

(show-results "IS-NIL" IS-NIL-tests)

; ====================================================================

(define IND-tests (list
    ; normal cases
    (test-list-element "IND([TRUE])" (read-any ((IND LIST-T) ZERO)) "bool:TRUE")
    (test-list-element "IND([LIST-1-0])(0))" (read-any ((IND LIST-1-0) ZERO)) "nat:1")
    (test-list-element "IND([LIST-1-0])(1))" (read-any ((IND LIST-1-0) ONE)) "nat:0")
    (test-list-element "IND([LIST-p2-n3-p0-p4](0))" (read-any ((IND LIST-p2-n3-p0-p4) ZERO)) "int:2")
    ; coercing
    (test-list-element "IND([LIST-1-0])(1))" (read-any ((IND LIST-1-0) posONE)) "nat:0")
    (test-list-element "IND(TRUE)(0))" (read-any ((IND TRUE) ZERO)) "bool:TRUE")
))

(show-results "IND" IND-tests)