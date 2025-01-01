#lang s-exp "../../macros/lazy-with-macros.rkt"
(require "../../macros/macros.rkt")
(require "../../church.rkt"
        "../../integers.rkt"
        "../../lists.rkt"
        "../../logic.rkt"
        "../ALGORITHMS.rkt"
         "../CHURCH.rkt"
         "../INTEGERS.rkt"
         "../LISTS.rkt"
         "../LOGIC.rkt"
         "../RECURSION.rkt"
         "../TYPES.rkt"
         "../../tests/helpers/test-helpers.rkt")

; ====================================================================
; ~ ALGORITHMS TESTS ~
; ====================================================================
(def seven = (succ (succ five)))
(def nine = ((mult three) three))
(def ten = (succ nine))
(def twelve = (succ (succ ten)))
(def fifteen = ((mult three) five))
(def twenty-two = (succ (succ ((mult ten) two))))
(def twenty-three = (succ twenty-two))
(def twenty-five = ((mult five) five))

(def FIFTEEN = (make-nat fifteen))
(def TWENTY-TWO = (make-nat twenty-two))

; LIST-0-1-3-3-4-5-7-9-10-12-15-22-22-23-25
(def LONG-LIST = 
    ((_make-list nat) (_cons zero one three three four five seven nine ten twelve fifteen twenty-two twenty-two twenty-three twenty-five)))

(define BINARY-SEARCH-tests (list 
    ; normal cases
    (test-list-element "BINARY-SEARCH LONG-LIST ZERO" (read-any ((BINARY-SEARCH LONG-LIST) ZERO)) "nat:0")
    (test-list-element "BINARY-SEARCH LONG-LIST ONE" (read-any ((BINARY-SEARCH LONG-LIST) ONE)) "nat:1")
    (test-list-element "BINARY-SEARCH LONG-LIST THREE" (read-any ((BINARY-SEARCH LONG-LIST) THREE)) "nat:3")
    (test-list-element "BINARY-SEARCH LONG-LIST FIFTEEN" (read-any ((BINARY-SEARCH LONG-LIST) FIFTEEN)) "nat:10")
    (test-list-element "BINARY-SEARCH LONG-LIST FIVE" (read-any ((BINARY-SEARCH LONG-LIST) FIVE)) "nat:5")
    (test-list-element "BINARY-SEARCH LONG-LIST TWENTY-TWO" (read-any ((BINARY-SEARCH LONG-LIST) TWENTY-TWO)) "nat:11")
    ; error cases
    (test-list-element "BINARY-SEARCH LONG-LIST FALSE" (read-any ((BINARY-SEARCH LONG-LIST) FALSE)) "BINARY-SEARCH(arg2(err:nat))")
    (test-list-element "BINARY-SEARCH LONG-LIST posTWO" (read-any ((BINARY-SEARCH LONG-LIST) posTWO)) "BINARY-SEARCH(arg2(err:nat))")
))

(show-results "BINARY-SEARCH-tests" BINARY-SEARCH-tests)

; ====================================================================

