#lang s-exp "../../../macros/lazy-with-macros.rkt"
(require "../../../macros/macros.rkt")
(require "../CHURCH.rkt"
         "../INTEGERS.rkt"
         "../LOGIC.rkt"
         "../TYPES.rkt"
         "../../TYPES.rkt"
         "../../../tests/helpers/test-helpers.rkt")

; ====================================================================
; ~ COERCED TYPE CHURCH TESTS ~
; ====================================================================

(define IS_ZERO-tests (list 
    ; normal
    (test-list-element "IS_ZERO(ZERO)" (read-any (IS_ZERO ZERO)) "bool:TRUE")
    (test-list-element "IS_ZERO(ONE)" (read-any (IS_ZERO ONE)) "bool:FALSE")
    (test-list-element "IS_ZERO(TWO)" (read-any (IS_ZERO TWO)) "bool:FALSE")
    (test-list-element "IS_ZERO(FIVE)" (read-any (IS_ZERO FIVE)) "bool:FALSE")
    ; coercing
    (test-list-element "IS_ZERO(negTHREE)" (read-any (IS_ZERO negTHREE)) "bool:FALSE")
    (test-list-element "IS_ZERO(TRUE)" (read-any (IS_ZERO TRUE)) "bool:FALSE")
    (test-list-element "IS_ZERO(TRUE)" (read-any (IS_ZERO FALSE)) "bool:TRUE")
))

(show-results "IS_ZERO" IS_ZERO-tests)

; ====================================================================

(define ADD-tests (list
    ; normal
    (test-list-element "ADD(ZERO)(ZERO)" (read-any ((ADD ZERO) ZERO)) "nat:0")
    (test-list-element "ADD(ONE)(ZERO)" (read-any ((ADD ONE) ZERO)) "nat:1")
    (test-list-element "ADD(ZERO)(ONE)" (read-any ((ADD ZERO) ONE)) "nat:1")
    (test-list-element "ADD(FIVE)(ONE)" (read-any ((ADD FIVE) ONE)) "nat:6")
    (test-list-element "ADD(ONE)(TWO)" (read-any ((ADD ONE) TWO)) "nat:3")
    (test-list-element "ADD(THREE)(FOUR)" (read-any ((ADD THREE) FOUR)) "nat:7")
    (test-list-element "ADD(FOUR)(THREE)" (read-any ((ADD FOUR) THREE)) "nat:7")
    (test-list-element "ADD(TWO)(TWO)" (read-any ((ADD TWO) TWO)) "nat:4")
    (test-list-element "ADD(FIVE)(FIVE)" (read-any ((ADD FIVE) FIVE)) "nat:10")
    ; coercing
    (test-list-element "ADD(TRUE)(FIVE)" (read-any ((ADD TRUE) FIVE)) "nat:6")
    (test-list-element "ADD(negTWO)(FIVE)" (read-any ((ADD negTWO) FIVE)) "nat:7")
    (test-list-element "ADD(FIVE)(FALSE)" (read-any ((ADD FIVE) FALSE)) "nat:5")
    (test-list-element "ADD(FIVE)(ERROR)" (read-any ((ADD FIVE) ERROR)) "nat:5")
))

(show-results "ADD" ADD-tests)

; ====================================================================

(define SUB-tests (list
    (test-list-element "SUB(ZERO)(ZERO)" (read-any ((SUB ZERO) ZERO)) "nat:0")
    (test-list-element "SUB(ONE)(ZERO)" (read-any ((SUB ONE) ZERO)) "nat:1")
    (test-list-element "SUB(ZERO)(ONE)" (read-any ((SUB ZERO) ONE)) "nat:0")
    (test-list-element "SUB(FIVE)(ONE)" (read-any ((SUB FIVE) ONE)) "nat:4")
    (test-list-element "SUB(ONE)(TWO)" (read-any ((SUB ONE) TWO)) "nat:0")
    (test-list-element "SUB(THREE)(FOUR)" (read-any ((SUB THREE) FOUR)) "nat:0")
    (test-list-element "SUB(FOUR)(THREE)" (read-any ((SUB FOUR) THREE)) "nat:1")
    (test-list-element "SUB(TWO)(TWO)" (read-any ((SUB TWO) TWO)) "nat:0")
    (test-list-element "SUB(FIVE)(FIVE)" (read-any ((SUB FIVE) TWO)) "nat:3")
    ; coercing
    (test-list-element "SUB(TRUE)(FIVE)" (read-any ((SUB TRUE) FIVE)) "nat:0")
    (test-list-element "SUB(negTWO)(FIVE)" (read-any ((SUB negTWO) FIVE)) "nat:0")
    (test-list-element "SUB(posFOUR)(TWO)" (read-any ((SUB posFOUR) TWO)) "nat:2")
    (test-list-element "SUB(FIVE)(FALSE)" (read-any ((SUB FIVE) FALSE)) "nat:5")
    (test-list-element "SUB(FOUR)(ERROR)" (read-any ((SUB FOUR) ERROR)) "nat:4")
))

(show-results "SUB" SUB-tests)

; ====================================================================

(define MULT-tests (list
    (test-list-element "MULT(ZERO)(ZERO)" (read-any ((MULT ZERO) ZERO)) "nat:0")
    (test-list-element "MULT(ONE)(ZERO)" (read-any ((MULT ONE) ZERO)) "nat:0")
    (test-list-element "MULT(ZERO)(ONE)" (read-any ((MULT THREE) ONE)) "nat:3")
    (test-list-element "MULT(FIVE)(ONE)" (read-any ((MULT FIVE) ONE)) "nat:5")
    (test-list-element "MULT(ONE)(TWO)" (read-any ((MULT ONE) TWO)) "nat:2")
    (test-list-element "MULT(THREE)(FOUR)" (read-any ((MULT THREE) FOUR)) "nat:12")
    (test-list-element "MULT(FOUR)(THREE)" (read-any ((MULT FOUR) THREE)) "nat:12")
    (test-list-element "MULT(TWO)(TWO)" (read-any ((MULT TWO) TWO)) "nat:4")
    (test-list-element "MULT(FIVE)(FIVE)" (read-any ((MULT FIVE) TWO)) "nat:10")
    ; coercing
    (test-list-element "MULT(TRUE)(FIVE)" (read-any ((MULT TRUE) FIVE)) "nat:5")
    (test-list-element "MULT(negTWO)(FIVE)" (read-any ((MULT negTWO) FIVE)) "nat:10")
    (test-list-element "MULT(FIVE)(FALSE)" (read-any ((MULT FIVE) FALSE)) "nat:0")
    (test-list-element "MULT(FOUR)(ERROR)" (read-any ((MULT FIVE) ERROR)) "nat:0")
))

(show-results "MULT" MULT-tests)

; ====================================================================

(define DIV-tests (list
    (test-list-element "DIV(ZERO)(ONE)" (read-any ((DIV ZERO) ONE)) "nat:0")
    (test-list-element "DIV(ZERO)(FOUR)" (read-any ((DIV ZERO) ONE)) "nat:0")
    (test-list-element "DIV(FIVE)(ONE)" (read-any ((DIV FIVE) ONE)) "nat:5")
    (test-list-element "DIV(ONE)(TWO)" (read-any ((DIV ONE) TWO)) "nat:0")
    (test-list-element "DIV(THREE)(FOUR)" (read-any ((DIV THREE) FOUR)) "nat:0")
    (test-list-element "DIV(FOUR)(THREE)" (read-any ((DIV FOUR) THREE)) "nat:1")
    (test-list-element "DIV(TWO)(TWO)" (read-any ((DIV TWO) TWO)) "nat:1")
    (test-list-element "DIV(FIVE)(FIVE)" (read-any ((DIV FIVE) FIVE)) "nat:1")
    (test-list-element "DIV(FOUR)(TWO)" (read-any ((DIV FOUR) TWO)) "nat:2")
    (test-list-element "DIV(SUCC(FIVE))(TWO)" (read-any ((DIV (SUCC FIVE)) TWO)) "nat:3")
    ; coercing
    (test-list-element "DIV(TRUE)(FIVE)" (read-any ((DIV TRUE) FIVE)) "nat:0")
    (test-list-element "DIV(posFOUR)(TWO)" (read-any ((DIV posFOUR) TWO)) "nat:2")
    (test-list-element "DIV(posFOUR)(negTWO)" (read-any ((DIV negTWO) negTWO)) "nat:1")
    ; fails
    (test-list-element "DIV(TWO)(ZERO)" (read-any ((DIV TWO) ZERO)) "err:div by 0")
    (test-list-element "DIV(FIVE)(FALSE)" (read-any ((DIV FIVE) FALSE)) "err:div by 0")
    (test-list-element "DIV(FOUR)(ERROR)" (read-any ((DIV FOUR) ERROR)) "err:div by 0")
))

(show-results "DIV" DIV-tests)

; ====================================================================

(define MOD-tests (list
    (test-list-element "MOD(ZERO)(ONE)" (read-any ((MOD ZERO) ONE)) "nat:0")
    (test-list-element "MOD(ZERO)(FOUR)" (read-any ((MOD ZERO) ONE)) "nat:0")
    (test-list-element "MOD(FIVE)(ONE)" (read-any ((MOD FIVE) ONE)) "nat:0")
    (test-list-element "MOD(ONE)(TWO)" (read-any ((MOD ONE) TWO)) "nat:1")
    (test-list-element "MOD(THREE)(FOUR)" (read-any ((MOD THREE) FOUR)) "nat:3")
    (test-list-element "MOD(FOUR)(THREE)" (read-any ((MOD FOUR) THREE)) "nat:1")
    (test-list-element "MOD(TWO)(TWO)" (read-any ((MOD TWO) TWO)) "nat:0")
    (test-list-element "MOD(FIVE)(FIVE)" (read-any ((MOD FIVE) FOUR)) "nat:1")
    (test-list-element "MOD(FOUR)(TWO)" (read-any ((MOD FOUR) TWO)) "nat:0")
    (test-list-element "MOD(SUCC(FIVE))(TWO)" (read-any ((MOD (SUCC FIVE)) TWO)) "nat:0")
    ; coercing
    (test-list-element "MOD(TRUE)(FIVE)" (read-any ((MOD TRUE) FIVE)) "nat:1")
    (test-list-element "MOD(negTWO)(FIVE)" (read-any ((MOD negTWO) FIVE)) "nat:2")
    ; fails
    (test-list-element "MOD(FIVE)(ZERO)" (read-any ((MOD FIVE) ZERO)) "err:div by 0")
    (test-list-element "MOD(FIVE)(FALSE)" (read-any ((MOD FIVE) FALSE)) "err:div by 0")
    (test-list-element "MOD(posFOUR)(ERROR)" (read-any ((MOD posFOUR) ERROR)) "err:div by 0")
))

(show-results "MOD" MOD-tests)
; ; ====================================================================

(define IS_EVEN-tests (list
    (test-list-element "IS_EVEN(ZERO)" (read-any (IS_EVEN ZERO)) "bool:TRUE")
    (test-list-element "IS_EVEN(FIVE)" (read-any (IS_EVEN FIVE)) "bool:FALSE")
    (test-list-element "IS_EVEN(ONE)" (read-any (IS_EVEN ONE)) "bool:FALSE")
    (test-list-element "IS_EVEN(THREE)" (read-any (IS_EVEN THREE)) "bool:FALSE")
    (test-list-element "IS_EVEN(FOUR)" (read-any (IS_EVEN FOUR)) "bool:TRUE")
    ; coercing
    (test-list-element "IS_EVEN(TRUE)" (read-any (IS_EVEN TRUE)) "bool:FALSE")
    (test-list-element "IS_EVEN(negTWO)" (read-any (IS_EVEN negTWO)) "bool:TRUE")
))

(show-results "IS_EVEN" IS_EVEN-tests)

; ; ====================================================================

(define IS_ODD-tests (list
    (test-list-element "IS_ODD(ZERO)" (read-any (IS_ODD ZERO)) "bool:FALSE")
    (test-list-element "IS_ODD(FIVE)" (read-any (IS_ODD FIVE)) "bool:TRUE")
    (test-list-element "IS_ODD(ONE)" (read-any (IS_ODD ONE)) "bool:TRUE")
    (test-list-element "IS_ODD(THREE)" (read-any (IS_ODD THREE)) "bool:TRUE")
    (test-list-element "IS_ODD(FOUR)" (read-any (IS_ODD FOUR)) "bool:FALSE")
    (test-list-element "IS_ODD(SUCC(FIVE))" (read-any (IS_ODD (SUCC FIVE))) "bool:FALSE")
    ; coercing
    (test-list-element "IS_ODD(TRUE)" (read-any (IS_ODD TRUE)) "bool:TRUE")
    (test-list-element "IS_ODD(negTWO)" (read-any (IS_ODD negTWO)) "bool:FALSE")
))

(show-results "IS_ODD" IS_ODD-tests)
; ; ====================================================================

(define GTE-tests (list
    (test-list-element "GTE(ZERO)(ZERO)" (read-any ((GTE ZERO) ZERO)) "bool:TRUE")
    (test-list-element "GTE(ONE)(ZERO)" (read-any ((GTE ONE) ZERO)) "bool:TRUE")
    (test-list-element "GTE(ZERO)(ONE)" (read-any ((GTE ZERO) ONE)) "bool:FALSE")
    (test-list-element "GTE(FIVE)(TWO)" (read-any ((GTE FIVE) TWO)) "bool:TRUE")
    (test-list-element "GTE(THREE)(FOUR)" (read-any ((GTE THREE) FOUR)) "bool:FALSE")
    (test-list-element "GTE(FOUR)(FOUR)" (read-any ((GTE FOUR) FOUR)) "bool:TRUE")
    ; coercing
    (test-list-element "GTE(TRUE)(FIVE)" (read-any ((GTE TRUE) FIVE)) "bool:FALSE")
    (test-list-element "GTE(FIVE)(FALSE)" (read-any ((GTE FIVE) FALSE)) "bool:TRUE")
))

(show-results "GTE" GTE-tests)

; ; ====================================================================

(define LTE-tests (list
    (test-list-element "LTE(ZERO)(ZERO)" (read-any ((LTE ZERO) ZERO)) "bool:TRUE")
    (test-list-element "LTE(ONE)(ZERO)" (read-any ((LTE ONE) ZERO)) "bool:FALSE")
    (test-list-element "LTE(ZERO)(ONE)" (read-any ((LTE ZERO) ONE)) "bool:TRUE")
    (test-list-element "LTE(TWO)(FIVE)" (read-any ((LTE TWO) FIVE)) "bool:TRUE")
    (test-list-element "LTE(FOUR)(THREE)" (read-any ((LTE FOUR) THREE)) "bool:FALSE")
    (test-list-element "LTE(THREE)(THREE)" (read-any ((LTE THREE) THREE)) "bool:TRUE")
    ; coercing
    (test-list-element "LTE(TRUE)(FIVE)" (read-any ((LTE TRUE) FIVE)) "bool:TRUE")
    (test-list-element "LTE(FIVE)(FALSE)" (read-any ((LTE FIVE) FALSE)) "bool:FALSE")
))

(show-results "LTE" LTE-tests)

; ; ====================================================================

(define EQ-tests (list
    (test-list-element "EQ(ZERO)(ZERO)" (read-any ((EQ ZERO) ZERO)) "bool:TRUE")
    (test-list-element "EQ(ONE)(ZERO)" (read-any ((EQ ONE) ZERO)) "bool:FALSE")
    (test-list-element "EQ(ZERO)(ONE)" (read-any ((EQ ZERO) ONE)) "bool:FALSE")
    (test-list-element "EQ(FIVE)(FIVE)" (read-any ((EQ FIVE) FIVE)) "bool:TRUE")
    (test-list-element "EQ(THREE)(FOUR)" (read-any ((EQ THREE) FOUR)) "bool:FALSE")
    ; coercing
    (test-list-element "EQ(TRUE)(posONE)" (read-any ((EQ TRUE) posONE)) "bool:TRUE")
    (test-list-element "EQ(TRUE)(FIVE)" (read-any ((EQ TRUE) FIVE)) "bool:FALSE")
    (test-list-element "EQ(FIVE)(FALSE)" (read-any ((EQ FIVE) FALSE)) "bool:FALSE")
))

(show-results "EQ" EQ-tests)

; ; ====================================================================

(define GT-tests (list
    (test-list-element "GT(ZERO)(ZERO)" (read-any ((GT ZERO) ZERO)) "bool:FALSE")
    (test-list-element "GT(ONE)(ZERO)" (read-any ((GT ONE) ZERO)) "bool:TRUE")
    (test-list-element "GT(ZERO)(ONE)" (read-any ((GT ZERO) ONE)) "bool:FALSE")
    (test-list-element "GT(FIVE)(TWO)" (read-any ((GT FIVE) TWO)) "bool:TRUE")
    (test-list-element "GT(THREE)(FOUR)" (read-any ((GT THREE) FOUR)) "bool:FALSE")
    (test-list-element "GT(FOUR)(FOUR)" (read-any ((GT FOUR) FOUR)) "bool:FALSE")
    ; coercing
    (test-list-element "GT(TRUE)(FIVE)" (read-any ((GT TRUE) FIVE)) "bool:FALSE")
    (test-list-element "GT(FIVE)(FALSE)" (read-any ((GT FIVE) FALSE)) "bool:TRUE")
))

(show-results "GT" GT-tests)

; ; ====================================================================

(define LT-tests (list
    (test-list-element "LT(ZERO)(ZERO)" (read-any ((LT ZERO) ZERO)) "bool:FALSE")
    (test-list-element "LT(ONE)(ZERO)" (read-any ((LT ONE) ZERO)) "bool:FALSE")
    (test-list-element "LT(ZERO)(ONE)" (read-any ((LT ZERO) ONE)) "bool:TRUE")
    (test-list-element "LT(TWO)(FIVE)" (read-any ((LT TWO) FIVE)) "bool:TRUE")
    (test-list-element "LT(FOUR)(THREE)" (read-any ((LT FOUR) THREE)) "bool:FALSE")
    (test-list-element "LT(THREE)(THREE)" (read-any ((LT THREE) THREE)) "bool:FALSE")
    ; coercing
    (test-list-element "LT(TRUE)(FIVE)" (read-any ((LT TRUE) FIVE)) "bool:TRUE")
    (test-list-element "LT(FIVE)(FALSE)" (read-any ((LT FIVE) FALSE)) "bool:FALSE")
))

(show-results "LT" LT-tests)
