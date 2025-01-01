#lang s-exp "../../macros/lazy-with-macros.rkt"
(require "../../macros/macros.rkt")
(require "../../church.rkt"
        "../../integers.rkt"
        "../../lists.rkt"
        "../../logic.rkt"
         "../CHURCH.rkt"
         "../INTEGERS.rkt"
         "../LISTS.rkt"
         "../LOGIC.rkt"
         "../RECURSION.rkt"
         "../TYPES.rkt"
         "../../tests/helpers/test-helpers.rkt")

; ====================================================================
; ~ RECURSION TESTS ~
; ====================================================================

(define FACT-tests (list 
    ; normal cases
    (test-list-element "FACT ZERO" (read-any (FACT ZERO)) "nat:1")
    (test-list-element "FACT ONE" (read-any (FACT ONE)) "nat:1")
    (test-list-element "FACT TWO" (read-any (FACT TWO)) "nat:2")
    (test-list-element "FACT THREE" (read-any (FACT THREE)) "nat:6")
    (test-list-element "FACT FOUR" (read-any (FACT FOUR)) "nat:24")
    (test-list-element "FACT FIVE" (read-any (FACT FIVE)) "nat:120")
    (test-list-element "FACT SIX" (read-any (FACT (SUCC FIVE))) "nat:720")
    (test-list-element "FACT SEVEN" (read-any (FACT (SUCC (SUCC FIVE)))) "nat:5040")
    (test-list-element "FACT EIGHT" (read-any (FACT (SUCC (SUCC (SUCC FIVE))))) "nat:40320")
    ; error cases
    (test-list-element "FACT FALSE" (read-any (FACT FALSE)) "FACT(err:nat)")
    (test-list-element "FACT posTWO" (read-any (FACT posTWO)) "FACT(err:nat)")
))

(show-results "FACT-tests" FACT-tests)

; ====================================================================

(define FIB-tests (list 
    ; normal cases
    (test-list-element "FIB ZERO" (read-any (FIB ZERO)) "nat:0")
    (test-list-element "FIB ONE" (read-any (FIB ONE)) "nat:1")
    (test-list-element "FIB TWO" (read-any (FIB TWO)) "nat:1")
    (test-list-element "FIB THREE" (read-any (FIB THREE)) "nat:2")
    (test-list-element "FIB FOUR" (read-any (FIB FOUR)) "nat:3")
    (test-list-element "FIB FIVE" (read-any (FIB FIVE)) "nat:5")
    (test-list-element "FIB SIX" (read-any (FIB (SUCC FIVE))) "nat:8")
    (test-list-element "FIB SEVEN" (read-any (FIB (SUCC (SUCC FIVE)))) "nat:13")
    (test-list-element "FIB EIGHT" (read-any (FIB (SUCC (SUCC (SUCC FIVE))))) "nat:21")
    ; error cases
    (test-list-element "FIB FALSE" (read-any (FIB FALSE)) "FIB(err:nat)")
    (test-list-element "FIB posTWO" (read-any (FIB posTWO)) "FIB(err:nat)")
))

(show-results "FIB-tests" FIB-tests)

; ====================================================================
(define N-SUM-tests (list 
    ; normal cases
    (test-list-element "N-SUM ZERO" (read-any (N-SUM ZERO)) "nat:0")
    (test-list-element "N-SUM ONE" (read-any (N-SUM ONE)) "nat:1")
    (test-list-element "N-SUM TWO" (read-any (N-SUM TWO)) "nat:3")
    (test-list-element "N-SUM THREE" (read-any (N-SUM THREE)) "nat:6")
    (test-list-element "N-SUM FOUR" (read-any (N-SUM FOUR)) "nat:10")
    (test-list-element "N-SUM FIVE" (read-any (N-SUM FIVE)) "nat:15")
    (test-list-element "N-SUM SIX" (read-any (N-SUM (SUCC FIVE))) "nat:21")
    (test-list-element "N-SUM SEVEN" (read-any (N-SUM (SUCC (SUCC FIVE)))) "nat:28")
    (test-list-element "N-SUM EIGHT" (read-any (N-SUM (SUCC (SUCC (SUCC FIVE))))) "nat:36")
    ; error cases
    (test-list-element "N-SUM FALSE" (read-any (N-SUM FALSE)) "N-SUM(err:nat)")
    (test-list-element "N-SUM posTWO" (read-any (N-SUM posTWO)) "N-SUM(err:nat)")
))

(show-results "N-SUM-tests" N-SUM-tests)

; ====================================================================
