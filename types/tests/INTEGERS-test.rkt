#lang s-exp "../../macros/lazy-with-macros.rkt"
(require "../../macros/macros.rkt")
(require "../CHURCH.rkt"
         "../INTEGERS.rkt"
         "../LOGIC.rkt"
         "../TYPES.rkt"
         "../../tests/helpers/test-helpers.rkt")

; ====================================================================
; ~ TYPED INTEGERS TESTS ~
; ====================================================================

(define IS_ZEROz-tests
    (list
        (test-list-element "IS_ZEROz(posZERO)" (read-any (IS_ZEROz posZERO)) "bool:TRUE")
        (test-list-element "IS_ZEROz(negZERO)" (read-any (IS_ZEROz negZERO)) "bool:TRUE")
        (test-list-element "IS_ZEROz(negZERO)" (read-any (IS_ZEROz posTHREE)) "bool:FALSE")
        (test-list-element "IS_ZEROz(posONE)" (read-any (IS_ZEROz posONE)) "bool:FALSE")
        ; type fails
        (test-list-element "IS_ZEROz(TRUE)" (read-any (IS_ZEROz TRUE)) "IS_ZEROz(err:int)")))
(show-results "IS_ZEROz" IS_ZEROz-tests)

; ====================================================================

(define ADDz-tests
    (list
        (test-list-element "ADDz(posONE)(posTWO)" (read-any ((ADDz posONE) posTWO)) "int:3")
        (test-list-element "ADDz(negTWO)(posONE)" (read-any ((ADDz negTWO) posONE)) "int:-1")
        (test-list-element "ADDz(posTWO)(negONE)" (read-any ((ADDz posTWO) negONE)) "int:1")
        (test-list-element "ADDz(negONE)(negTWO)" (read-any ((ADDz negONE) negTWO)) "int:-3")
        ; type fails
        (test-list-element "ADDz(TRUE)(posONE)" (read-any ((ADDz TRUE) posONE)) "ADDz(arg1(err:int))")))
(show-results "ADDz" ADDz-tests)

; ====================================================================

(define SUBz-tests
    (list
        (test-list-element "SUBz(posTWO)(posONE)" (read-any ((SUBz posTWO) posONE)) "int:1")
        (test-list-element "SUBz(posONE)(posTWO)" (read-any ((SUBz posONE) posTWO)) "int:-1")
        (test-list-element "SUBz(negONE)(negTWO)" (read-any ((SUBz negONE) negTWO)) "int:1")
        ; type fails
        (test-list-element "SUBz(FALSE)(posONE)" (read-any ((SUBz FALSE) posONE)) "SUBz(arg1(err:int))")))
(show-results "SUBz" SUBz-tests)

; ====================================================================

(define MULTz-tests
    (list
        (test-list-element "MULTz(posZERO)(negONE)" (read-any ((MULTz posZERO) negONE)) "int:0")
        (test-list-element "MULTz(posONE)(negTWO)" (read-any ((MULTz posONE) negTWO)) "int:-2")
        (test-list-element "MULTz(negTWO)(negTWO)" (read-any ((MULTz negTWO) negTWO)) "int:4")
        ; type fails
        (test-list-element "MULTz(TRUE)(posONE)" (read-any ((MULTz TRUE) posONE)) "MULTz(arg1(err:int))")))
(show-results "MULTz" MULTz-tests)

; ====================================================================

(define DIVz-tests
    (list
        (test-list-element "DIVz(posTWO)(posONE)" (read-any ((DIVz posTWO) posONE)) "int:2")
        (test-list-element "DIVz(negTWO)(posONE)" (read-any ((DIVz negTWO) posONE)) "int:-2")
        (test-list-element "DIVz(posONE)(negTWO)" (read-any ((DIVz posONE) negTWO)) "int:0")
        ; type fails
        (test-list-element "DIVz(posONE)(FALSE)" (read-any ((DIVz posONE) FALSE)) "DIVz(arg2(err:int))")))
(show-results "DIVz" DIVz-tests)

; ====================================================================

(define GTEz-tests
    (list
        (test-list-element "GTEz(posONE)(negONE)" (read-any ((GTEz posONE) negONE)) "bool:TRUE")
        (test-list-element "GTEz(negTWO)(posTWO)" (read-any ((GTEz negTWO) posTWO)) "bool:FALSE")
        (test-list-element "GTEz(posTWO)(posTWO)" (read-any ((GTEz posTWO) posTWO)) "bool:TRUE")
        ; type fails
        (test-list-element "GTEz(TRUE)(posONE)" (read-any ((GTEz TRUE) posONE)) "GTEz(arg1(err:int))")))
(show-results "GTEz" GTEz-tests)

; ====================================================================

(define LTEz-tests
    (list
        (test-list-element "LTEz(negONE)(posONE)" (read-any ((LTEz negONE) posONE)) "bool:TRUE")
        (test-list-element "LTEz(posTWO)(negTWO)" (read-any ((LTEz posTWO) negTWO)) "bool:FALSE")
        (test-list-element "LTEz(posONE)(posONE)" (read-any ((LTEz posONE) posONE)) "bool:TRUE")
        ; type fails
        (test-list-element "LTEz(FALSE)(negONE)" (read-any ((LTEz FALSE) negONE)) "LTEz(arg1(err:int))")))
(show-results "LTEz" LTEz-tests)

; ====================================================================

(define EQz-tests
    (list
        (test-list-element "EQz(posZERO)(negZERO)" (read-any ((EQz posZERO) negZERO)) "bool:TRUE")
        (test-list-element "EQz(posONE)(posONE)" (read-any ((EQz posONE) posONE)) "bool:TRUE")
        (test-list-element "EQz(posONE)(negONE)" (read-any ((EQz posONE) negONE)) "bool:FALSE")
        ; type fails
        (test-list-element "EQz(TRUE)(posZERO)" (read-any ((EQz TRUE) posZERO)) "EQz(arg1(err:int))")))
(show-results "EQz" EQz-tests)

; ====================================================================

(define GTz-tests
    (list
        (test-list-element "GTz(posONE)(negONE)" (read-any ((GTz posONE) negONE)) "bool:TRUE")
        (test-list-element "GTz(negTWO)(posZERO)" (read-any ((GTz negTWO) posZERO)) "bool:FALSE")
        (test-list-element "GTz(posONE)(posONE)" (read-any ((GTz posONE) posONE)) "bool:FALSE")
        ; type fails
        (test-list-element "GTz(FALSE)(posONE)" (read-any ((GTz FALSE) posONE)) "GTz(arg1(err:int))")))
(show-results "GTz" GTz-tests)

; ====================================================================

(define LTz-tests
    (list
        (test-list-element "LTz(negONE)(posONE)" (read-any ((LTz negONE) posONE)) "bool:TRUE")
        (test-list-element "LTz(posTWO)(negTWO)" (read-any ((LTz posTWO) negTWO)) "bool:FALSE")
        (test-list-element "LTz(posONE)(posONE)" (read-any ((LTz posONE) posONE)) "bool:FALSE")
        ; type fails
        (test-list-element "LTz(posONE)(TRUE)" (read-any ((LTz posONE) TRUE)) "LTz(arg2(err:int))")))
(show-results "LTz" LTz-tests)