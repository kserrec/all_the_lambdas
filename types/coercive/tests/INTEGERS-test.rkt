#lang s-exp "../../../macros/lazy-with-macros.rkt"
(require "../../../macros/macros.rkt")
(require "../CHURCH.rkt"
         "../INTEGERS.rkt"
         "../LOGIC.rkt"
         "../TYPES.rkt"
         "../../TYPES.rkt"
         "../../../tests/helpers/test-helpers.rkt")

; ====================================================================
; ~ COERCED TYPE INTEGERS TESTS ~
; ====================================================================

(define IS_ZEROz-tests (list 
    ; normal
    (test-list-element "IS_ZEROz(posZERO)" (read-any (IS_ZEROz posZERO)) "bool:TRUE")
    (test-list-element "IS_ZEROz(negONE)" (read-any (IS_ZEROz negONE)) "bool:FALSE")
    (test-list-element "IS_ZEROz(posTWO)" (read-any (IS_ZEROz posTWO)) "bool:FALSE")
    (test-list-element "IS_ZEROz(negFIVE)" (read-any (IS_ZEROz negFIVE)) "bool:FALSE")
    ; coercing
    (test-list-element "IS_ZEROz(THREE)" (read-any (IS_ZEROz THREE)) "bool:FALSE")
    (test-list-element "IS_ZEROz(TRUE)" (read-any (IS_ZEROz TRUE)) "bool:FALSE")
    (test-list-element "IS_ZEROz(FALSE)" (read-any (IS_ZEROz FALSE)) "bool:TRUE")
))

(show-results "IS_ZEROz" IS_ZEROz-tests)

; ====================================================================

(define ADDz-tests (list
    ; normal
    (test-list-element "ADDz(posZERO)(posZERO)" (read-any ((ADDz posZERO) posZERO)) "int:0")
    (test-list-element "ADDz(posONE)(posZERO)" (read-any ((ADDz posONE) posZERO)) "int:1")
    (test-list-element "ADDz(negZERO)(posONE)" (read-any ((ADDz negZERO) posONE)) "int:1")
    (test-list-element "ADDz(negFIVE)(posONE)" (read-any ((ADDz negFIVE) posONE)) "int:-4")
    (test-list-element "ADDz(negONE)(negTWO)" (read-any ((ADDz negONE) negTWO)) "int:-3")
    (test-list-element "ADDz(posTHREE)(negFOUR)" (read-any ((ADDz posTHREE) negFOUR)) "int:-1")
    (test-list-element "ADDz(negFOUR)(negTHREE)" (read-any ((ADDz negFOUR) negTHREE)) "int:-7")
    (test-list-element "ADDz(negTWO)(posTWO)" (read-any ((ADDz negTWO) posTWO)) "int:0")
    (test-list-element "ADDz(negFIVE)(posFIVE)" (read-any ((ADDz negFIVE) posFIVE)) "int:0")
    ; coercing
    (test-list-element "ADDz(TRUE)(FIVE)" (read-any ((ADDz TRUE) FIVE)) "int:6")
    (test-list-element "ADDz(TWO)(FOUR)" (read-any ((ADDz TWO) FOUR)) "int:6")
    (test-list-element "ADDz(FIVE)(FALSE)" (read-any ((ADDz FIVE) FALSE)) "int:5")
    (test-list-element "ADDz(FOUR)(ERROR)" (read-any ((ADDz FOUR) ERROR)) "int:4")
))

(show-results "ADDz" ADDz-tests)

; ====================================================================

(define SUBz-tests (list
    ; normal
    (test-list-element "SUBz(posZERO)(posZERO)" (read-any ((SUBz posZERO) posZERO)) "int:0")
    (test-list-element "SUBz(posONE)(posZERO)" (read-any ((SUBz posONE) posZERO)) "int:1")
    (test-list-element "SUBz(negZERO)(posONE)" (read-any ((SUBz negZERO) posONE)) "int:-1")
    (test-list-element "SUBz(negFIVE)(posONE)" (read-any ((SUBz negFIVE) posONE)) "int:-6")
    (test-list-element "SUBz(negONE)(negTWO)" (read-any ((SUBz negONE) negTWO)) "int:1")
    (test-list-element "SUBz(posTHREE)(negFOUR)" (read-any ((SUBz posTHREE) negFOUR)) "int:7")
    (test-list-element "SUBz(negFOUR)(negTHREE)" (read-any ((SUBz negFOUR) negTHREE)) "int:-1")
    (test-list-element "SUBz(negTWO)(posTWO)" (read-any ((SUBz negTWO) posTWO)) "int:-4")
    (test-list-element "SUBz(negFIVE)(posFIVE)" (read-any ((SUBz negFIVE) posFIVE)) "int:-10")
    ; coercing
    (test-list-element "SUBz(TRUE)(FIVE)" (read-any ((SUBz TRUE) FIVE)) "int:-4")
    (test-list-element "SUBz(TWO)(FOUR)" (read-any ((SUBz TWO) FOUR)) "int:-2")
    (test-list-element "SUBz(FIVE)(FALSE)" (read-any ((SUBz FIVE) FALSE)) "int:5")
    (test-list-element "SUBz(FOUR)(ERROR)" (read-any ((SUBz FOUR) ERROR)) "int:4")
))

(show-results "SUBz" SUBz-tests)

; ====================================================================

(define MULTz-tests (list
    ; normal
    (test-list-element "MULTz(posZERO)(posZERO)" (read-any ((MULTz posZERO) posZERO)) "int:0")
    (test-list-element "MULTz(posONE)(posZERO)" (read-any ((MULTz posONE) posZERO)) "int:0")
    (test-list-element "MULTz(negZERO)(posONE)" (read-any ((MULTz negZERO) posONE)) "int:0")
    (test-list-element "MULTz(negFIVE)(posONE)" (read-any ((MULTz negFIVE) posONE)) "int:-5")
    (test-list-element "MULTz(negONE)(negTWO)" (read-any ((MULTz negONE) negTWO)) "int:2")
    (test-list-element "MULTz(posTHREE)(negFOUR)" (read-any ((MULTz posTHREE) negFOUR)) "int:-12")
    (test-list-element "MULTz(negFOUR)(negTHREE)" (read-any ((MULTz negFOUR) negTHREE)) "int:12")
    (test-list-element "MULTz(negTWO)(posTWO)" (read-any ((MULTz negTWO) posTWO)) "int:-4")
    (test-list-element "MULTz(negFIVE)(posFIVE)" (read-any ((MULTz negFIVE) posFIVE)) "int:-25")
    ; coercing
    (test-list-element "MULTz(TRUE)(FIVE)" (read-any ((MULTz TRUE) FIVE)) "int:5")
    (test-list-element "MULTz(TWO)(FOUR)" (read-any ((MULTz TWO) FOUR)) "int:8")
    (test-list-element "MULTz(FIVE)(FALSE)" (read-any ((MULTz FIVE) FALSE)) "int:0")
    (test-list-element "MULTz(FOUR)(ERROR)" (read-any ((MULTz FOUR) ERROR)) "int:0")
))

(show-results "MULTz" MULTz-tests)

; ====================================================================

(define DIVz-tests (list
    ; normal
    (test-list-element "DIVz(posZERO)(posZERO)" (read-any ((DIVz posZERO) posZERO)) "err:div by 0") ; division by zero
    (test-list-element "DIVz(posONE)(posZERO)" (read-any ((DIVz posONE) posZERO)) "err:div by 0") ; division by zero
    (test-list-element "DIVz(negZERO)(posONE)" (read-any ((DIVz negZERO) posONE)) "int:0")
    (test-list-element "DIVz(negFIVE)(posONE)" (read-any ((DIVz negFIVE) posONE)) "int:-5")
    (test-list-element "DIVz(negONE)(negTWO)" (read-any ((DIVz negONE) negTWO)) "int:0")
    (test-list-element "DIVz(posTHREE)(negFOUR)" (read-any ((DIVz posTHREE) negFOUR)) "int:0")
    (test-list-element "DIVz(negFOUR)(negTHREE)" (read-any ((DIVz negFOUR) negTHREE)) "int:1")
    (test-list-element "DIVz(negTWO)(posTWO)" (read-any ((DIVz negTWO) posTWO)) "int:-1")
    (test-list-element "DIVz(negFIVE)(posFIVE)" (read-any ((DIVz negFIVE) posFIVE)) "int:-1")
    ; coercing
    (test-list-element "DIVz(TRUE)(FIVE)" (read-any ((DIVz TRUE) FIVE)) "int:0")
    (test-list-element "DIVz(TWO)(FOUR)" (read-any ((DIVz TWO) FOUR)) "int:0")
    (test-list-element "DIVz(FIVE)(FALSE)" (read-any ((DIVz FIVE) FALSE)) "err:div by 0") ; division by zero
    (test-list-element "DIVz(FOUR)(ERROR)" (read-any ((DIVz FOUR) ERROR)) "err:div by 0") ; division by zero
))

(show-results "DIVz" DIVz-tests)

; ====================================================================

