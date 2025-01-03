#lang s-exp "../../macros/lazy-with-macros.rkt"
(require "../../macros/macros.rkt")
(require "../../church.rkt"
        "../../core.rkt"
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

(def negTWENTY-TWO = ((new-int false) twenty-two))
(def negFIFTEEN = ((new-int false) ((mult three) five)))
(def negTEN = ((new-int false) (succ nine)))
(def posSEVEN = ((new-int true) (succ (succ five))))
(def posNINE = ((new-int true) ((mult three) three)))
(def posTWELVE = ((new-int true) (succ (succ ten))))
(def posFIFTEEN = ((new-int true) fifteen))
(def posTWENTY-TWO = ((new-int true) (succ (succ ((mult ten) two)))))
(def posTWENTY-THREE = ((new-int true) (succ twenty-two)))
(def posTWENTY-FIVE = ((new-int true) ((mult five) five)))


; LIST-n22-n15-n10-n5-n4-n3-n1-0-1-2-4--7--9--12--15--22--23--25
    ;   0   1   2   3  4  5  6 7 8 9 10 11 12 13  14  15  16  17
(def LONG-LISTz = ((pair _list) (_cons negTWENTY-TWO negFIFTEEN negTEN negFIVE negFOUR negTHREE negONE posZERO posONE posTWO posFOUR posSEVEN posNINE posTWELVE posFIFTEEN posTWENTY-TWO posTWENTY-THREE posTWENTY-FIVE)))

(define BINARY-SEARCHz-tests (list 
    ; normal cases
    (test-list-element "BINARY-SEARCHz LONG-LISTz posZERO" (read-any ((BINARY-SEARCHz LONG-LISTz) posZERO)) "int:7")
    (test-list-element "BINARY-SEARCHz LONG-LISTz posONE" (read-any ((BINARY-SEARCHz LONG-LISTz) posONE)) "int:8")
    (test-list-element "BINARY-SEARCHz LONG-LISTz negFIFTEEN" (read-any ((BINARY-SEARCHz LONG-LISTz) negFIFTEEN)) "int:1")
    (test-list-element "BINARY-SEARCHz LONG-LISTz negFIVE" (read-any ((BINARY-SEARCHz LONG-LISTz) negFIVE)) "int:3")
    (test-list-element "BINARY-SEARCHz LONG-LISTz posTWENTY-TWO" (read-any ((BINARY-SEARCHz LONG-LISTz) posTWENTY-TWO)) "int:15")
    (test-list-element "BINARY-SEARCHz LONG-LISTz posTHREE" (read-any ((BINARY-SEARCHz LONG-LISTz) posTHREE)) "int:-1")
    (test-list-element "BINARY-SEARCHz LONG-LISTz negTWO" (read-any ((BINARY-SEARCHz LONG-LISTz) negTWO)) "int:-1")
    ; error cases
    (test-list-element "BINARY-SEARCHz LONG-LISTz FALSE" (read-any ((BINARY-SEARCHz LONG-LISTz) FALSE)) "BINARY-SEARCH(arg2(err:int))")
    (test-list-element "BINARY-SEARCHz LONG-LISTz posTWO" (read-any ((BINARY-SEARCHz LONG-LISTz) TWO)) "BINARY-SEARCH(arg2(err:int))")
))

(show-results "BINARY-SEARCHz-tests" BINARY-SEARCHz-tests)

; ====================================================================

