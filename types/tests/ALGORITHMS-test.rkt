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
(def twenty-six = (succ twenty-five))

(def FIFTEEN = (make-nat fifteen))
(def TWENTY-TWO = (make-nat twenty-two))
(def TWENTY-SIX = (make-nat twenty-six))

; LIST-0-1-3-3-4-5-7-9-10-12-15-22-22-23-25
(def LONG-LIST = 
    ((_make-list nat) (_cons zero one three three four five seven nine ten twelve fifteen twenty-two twenty-two twenty-three twenty-five)))
(def POSITIVE-LIST = ((_make-list nat) (_cons one three)))

(define BINARY-SEARCH-tests (list 
    ; found values return Option-wrapped natural indexes
    (test-list-element "BINARY-SEARCH LONG-LIST ZERO" (read-any ((BINARY-SEARCH LONG-LIST) ZERO)) "option:some(nat:0)")
    (test-list-element "BINARY-SEARCH LONG-LIST ONE" (read-any ((BINARY-SEARCH LONG-LIST) ONE)) "option:some(nat:1)")
    (test-list-element "BINARY-SEARCH LONG-LIST THREE" (read-any ((BINARY-SEARCH LONG-LIST) THREE)) "option:some(nat:3)")
    (test-list-element "BINARY-SEARCH LONG-LIST FIFTEEN" (read-any ((BINARY-SEARCH LONG-LIST) FIFTEEN)) "option:some(nat:10)")
    (test-list-element "BINARY-SEARCH LONG-LIST FIVE" (read-any ((BINARY-SEARCH LONG-LIST) FIVE)) "option:some(nat:5)")
    (test-list-element "BINARY-SEARCH LONG-LIST TWENTY-TWO" (read-any ((BINARY-SEARCH LONG-LIST) TWENTY-TWO)) "option:some(nat:11)")
    ; expected absence returns none and terminates at every boundary
    (test-list-element "BINARY-SEARCH LONG-LIST TWO" (read-any ((BINARY-SEARCH LONG-LIST) TWO)) "option:none")
    (test-list-element "BINARY-SEARCH POSITIVE-LIST ZERO" (read-any ((BINARY-SEARCH POSITIVE-LIST) ZERO)) "option:none")
    (test-list-element "BINARY-SEARCH LONG-LIST TWENTY-SIX" (read-any ((BINARY-SEARCH LONG-LIST) TWENTY-SIX)) "option:none")
    (test-list-element "BINARY-SEARCH NIL-list ZERO" (read-any ((BINARY-SEARCH NIL-list) ZERO)) "option:none")
    ; error cases
    (test-list-element "BINARY-SEARCH FALSE ZERO" (read-any ((BINARY-SEARCH FALSE) ZERO)) "BINARY-SEARCH(arg1(err:list))")
    (test-list-element "BINARY-SEARCH LIST-ERROR ZERO" (read-any ((BINARY-SEARCH LIST-ERROR) ZERO)) "err:list->BINARY-SEARCH(arg1(err:list))")
    (test-list-element "BINARY-SEARCH LONG-LIST FALSE" (read-any ((BINARY-SEARCH LONG-LIST) FALSE)) "BINARY-SEARCH(arg2(err:nat))")
    (test-list-element "BINARY-SEARCH LONG-LIST posTWO" (read-any ((BINARY-SEARCH LONG-LIST) posTWO)) "BINARY-SEARCH(arg2(err:nat))")
    (test-list-element "BINARY-SEARCH LONG-LIST NAT-ERROR" (read-any ((BINARY-SEARCH LONG-LIST) NAT-ERROR)) "err:nat->BINARY-SEARCH(arg2(err:nat))")
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
(def posTWENTY-SIX = ((new-int true) twenty-six))
(def negTWENTY-FIVE = ((new-int false) twenty-five))


; LIST-n22-n15-n10-n5-n4-n3-n1-0-1-2-4--7--9--12--15--22--23--25
    ;   0   1   2   3  4  5  6 7 8 9 10 11 12 13  14  15  16  17
(def LONG-LISTz = ((pair _list) (_cons negTWENTY-TWO negFIFTEEN negTEN negFIVE negFOUR negTHREE negONE posZERO posONE posTWO posFOUR posSEVEN posNINE posTWELVE posFIFTEEN posTWENTY-TWO posTWENTY-THREE posTWENTY-FIVE)))

(define BINARY-SEARCHz-tests (list 
    ; searched values are integers; returned indexes are Option-wrapped naturals
    (test-list-element "BINARY-SEARCHz LONG-LISTz posZERO" (read-any ((BINARY-SEARCHz LONG-LISTz) posZERO)) "option:some(nat:7)")
    (test-list-element "BINARY-SEARCHz LONG-LISTz posONE" (read-any ((BINARY-SEARCHz LONG-LISTz) posONE)) "option:some(nat:8)")
    (test-list-element "BINARY-SEARCHz LONG-LISTz negFIFTEEN" (read-any ((BINARY-SEARCHz LONG-LISTz) negFIFTEEN)) "option:some(nat:1)")
    (test-list-element "BINARY-SEARCHz LONG-LISTz negFIVE" (read-any ((BINARY-SEARCHz LONG-LISTz) negFIVE)) "option:some(nat:3)")
    (test-list-element "BINARY-SEARCHz LONG-LISTz posTWENTY-TWO" (read-any ((BINARY-SEARCHz LONG-LISTz) posTWENTY-TWO)) "option:some(nat:15)")
    ; expected absence is none, including below-first, above-last, and empty searches
    (test-list-element "BINARY-SEARCHz LONG-LISTz posTHREE" (read-any ((BINARY-SEARCHz LONG-LISTz) posTHREE)) "option:none")
    (test-list-element "BINARY-SEARCHz LONG-LISTz negTWO" (read-any ((BINARY-SEARCHz LONG-LISTz) negTWO)) "option:none")
    (test-list-element "BINARY-SEARCHz LONG-LISTz negTWENTY-FIVE" (read-any ((BINARY-SEARCHz LONG-LISTz) negTWENTY-FIVE)) "option:none")
    (test-list-element "BINARY-SEARCHz LONG-LISTz posTWENTY-SIX" (read-any ((BINARY-SEARCHz LONG-LISTz) posTWENTY-SIX)) "option:none")
    (test-list-element "BINARY-SEARCHz NIL-list posZERO" (read-any ((BINARY-SEARCHz NIL-list) posZERO)) "option:none")
    ; error cases
    (test-list-element "BINARY-SEARCHz FALSE posZERO" (read-any ((BINARY-SEARCHz FALSE) posZERO)) "BINARY-SEARCH(arg1(err:list))")
    (test-list-element "BINARY-SEARCHz LIST-ERROR posZERO" (read-any ((BINARY-SEARCHz LIST-ERROR) posZERO)) "err:list->BINARY-SEARCH(arg1(err:list))")
    (test-list-element "BINARY-SEARCHz LONG-LISTz FALSE" (read-any ((BINARY-SEARCHz LONG-LISTz) FALSE)) "BINARY-SEARCH(arg2(err:int))")
    (test-list-element "BINARY-SEARCHz LONG-LISTz posTWO" (read-any ((BINARY-SEARCHz LONG-LISTz) TWO)) "BINARY-SEARCH(arg2(err:int))")
    (test-list-element "BINARY-SEARCHz LONG-LISTz INT-ERROR" (read-any ((BINARY-SEARCHz LONG-LISTz) INT-ERROR)) "err:int->BINARY-SEARCH(arg2(err:int))")
))

(show-results "BINARY-SEARCHz-tests" BINARY-SEARCHz-tests)

; ====================================================================
