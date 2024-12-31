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
         "../TYPES.rkt"
         "../../tests/helpers/test-helpers.rkt")

; ====================================================================
; ~ LISTS TESTS ~
; ====================================================================

(define LIST-T ((_make-list bool) (_cons true)))
(define LIST-F ((_make-list bool) (_cons false)))
(define LIST-0 ((_make-list nat) (_cons zero)))
(define LIST-4 ((_make-list nat) (_cons four)))
(define LIST-0-1 ((_make-list nat) (_cons zero one)))
(define LIST-1-0 ((_make-list nat) (_cons one zero)))
(define LIST-1-3-4-2 ((_make-list nat) (_cons one three four two)))
(define LIST-p2-n3-p0-p4 ((_make-list int) ((app ((twolist posTwo) negThree)) ((twolist posZero) posFour))))
(define LIST-n2-p1-p2-n4-n5 ((_make-list int) (_cons negTwo posOne posTwo negFour negFive)))

(displayln (read-any LIST-n2-p1-p2-n4-n5))

(define read-any-LISTS-tests (list 
    ; normal cases
    (test-list-element "read-any(NIL-list)" (read-any NIL-list) "list[]")
    (test-list-element "read-any(LIST-T)" (read-any LIST-T) "list:bool[TRUE]")
    (test-list-element "read-any(LIST-F)" (read-any LIST-F) "list:bool[FALSE]")
    (test-list-element "read-any(LIST-0)" (read-any LIST-0) "list:nat[0]")
    (test-list-element "read-any(LIST-4)" (read-any LIST-4) "list:nat[4]")
    (test-list-element "read-any(LIST-0-1)" (read-any LIST-0-1) "list:nat[0,1]")
    (test-list-element "read-any(LIST-p2-n3-p0-p4)" (read-any LIST-p2-n3-p0-p4) "list:int[2,-3,0,4]")
    (test-list-element "read-any(LIST-n2-p1-p2-n4-n5)" (read-any LIST-n2-p1-p2-n4-n5) "list:int[2,-3,0,4]")
))

(show-results "read-any-LISTS-tests" read-any-LISTS-tests)

; ====================================================================

(define LEN-tests (list 
    (test-list-element "LEN(NIL-list)" (read-any (LEN NIL-list)) "nat:0")
    (test-list-element "LEN([TRUE])" (read-any (LEN LIST-T)) "nat:1")
    (test-list-element "LEN([FALSE])" (read-any (LEN LIST-F)) "nat:1")
    (test-list-element "LEN([nat:0,nat:1])" (read-any (LEN LIST-0-1)) "nat:2")
    (test-list-element "LEN([2,-3,0,4])" (read-any (LEN LIST-p2-n3-p0-p4)) "nat:4")
))

(show-results "LEN" LEN-tests)

; ====================================================================

(define IS-NIL-tests (list 
    (test-list-element "IS-NIL(NIL-list)" (read-any (IS-NIL NIL-list)) "bool:TRUE")
    (test-list-element "IS-NIL([TRUE])" (read-any (IS-NIL LIST-T)) "bool:FALSE")
    (test-list-element "IS-NIL([FALSE])" (read-any (IS-NIL LIST-F)) "bool:FALSE")
    (test-list-element "IS-NIL([nat:0,nat:1])" (read-any (IS-NIL LIST-0-1)) "bool:FALSE")
    (test-list-element "IS-NIL([2,-3,0,4])" (read-any (IS-NIL LIST-p2-n3-p0-p4)) "bool:FALSE")
))

(show-results "IS-NIL" IS-NIL-tests)

; ====================================================================

(define IND-tests (list
    (test-list-element "IND([TRUE])" (read-any ((IND LIST-T) ZERO)) "bool:TRUE")
    (test-list-element "IND([LIST-1-0](0))" (read-any ((IND LIST-1-0) ZERO)) "nat:1")
    (test-list-element "IND([LIST-1-0](1))" (read-any ((IND LIST-1-0) ONE)) "nat:0")
    (test-list-element "IND([LIST-p2-n3-p0-p4](0))" (read-any ((IND LIST-p2-n3-p0-p4) ZERO)) "int:2")
))

(show-results "IND" IND-tests)

; ====================================================================

(define APP-tests (list
    (test-list-element "APP(NIL-list)(NIL-list)" (read-any ((APP NIL-list) NIL-list)) "list[]")
    (test-list-element "APP(LIST-T)(NIL-list)" (read-any ((APP LIST-T) NIL-list)) "list:bool[TRUE]")
    (test-list-element "APP(NIL-list)(LIST-F)" (read-any ((APP NIL-list) LIST-F)) "list:bool[FALSE]")
    (test-list-element "APP(LIST-T)(LIST-T)" (read-any ((APP LIST-T) LIST-T)) "list:bool[TRUE,TRUE]")
    (test-list-element "APP(LIST-F)(LIST-T)" (read-any ((APP LIST-F) LIST-T)) "list:bool[FALSE,TRUE]")
    (test-list-element "APP(LIST-n2-p1-p2-n4-n5)(NIL-list)" (read-any ((APP LIST-n2-p1-p2-n4-n5) NIL-list)) "list:int[-2,1,2,-4,-5]")
    (test-list-element "APP(LIST-n2-p1-p2-n4-n5)(LIST-n2-p1-p2-n4-n5)" (read-any ((APP LIST-n2-p1-p2-n4-n5) LIST-n2-p1-p2-n4-n5)) "list:int[-2,1,2,-4,-5,-2,1,2,-4,-5]")
    (test-list-element "APP(LIST-n2-p1-p2-n4-n5)(LIST-p2-n3-p0-p4)" (read-any ((APP LIST-n2-p1-p2-n4-n5) LIST-p2-n3-p0-p4)) "list:int[-2,1,2,-4,-5,2,-3,0,4]")
    (test-list-element "APP(LIST-0-1)(LIST-4)" (read-any ((APP LIST-0-1) LIST-4)) "list:nat[0,1,4]")
    (test-list-element "APP(LIST-0)(LIST-1-0)" (read-any ((APP LIST-0) LIST-1-0)) "list:nat[0,1,0]")
    (test-list-element "APP(LIST-0)(LIST-T)" (read-any ((APP LIST-0) LIST-T)) "APP(err:lists must be same type)")
    ))

(show-results "APP" APP-tests)

; ====================================================================

; (define REV-tests (list
;     (test-list-element "REV(NIL-list)" (read-any (REV NIL-list)) "list[]")
;     (test-list-element "REV(LIST-F)" (read-any (REV LIST-F)) "list:bool[FALSE]")
;     (test-list-element "REV(LIST-T)" (read-any (REV LIST-T)) "list:bool[TRUE]")
;     (test-list-element "REV(LIST-F)" (read-any (REV LIST-F)) "list:bool[FALSE]")
;     (test-list-element "REV(l-0)" (read-any (REV l-0)) "list:nat[0]")
;     (test-list-element "REV(l-4-2)" (read-any (REV l-4-2)) "list:nat[2,4]")
;     (test-list-element "REV(l-0-4-2)" (read-any (REV l-0-4-2)) "list:nat[2,4,0]")
;     (test-list-element "REV(l-5-4-2-0-4-2)" (read-any (REV l-5-4-2-0-4-2)) "list:nat[2,4,0,2,4,5]")))

; (show-results "REV" REV-tests)

; ====================================================================

(def AND-T B = ((AND B) TRUE))
(def ADD-2 N = ((ADD N) TWO))
(def SQ-Z Z = ((MULTz Z) Z))
(def LIST-T-F-F-T = ((_make-list bool) (_cons true false false true)))

(define MAP-tests (list
    (test-list-element "MAP(AND-T)(LIST-F)" (read-any ((MAP AND-T) LIST-F)) "list:bool[FALSE]")
    (test-list-element "MAP(AND-T)(LIST-T)" (read-any ((MAP AND-T) LIST-T)) "list:bool[TRUE]")
    (test-list-element "MAP(NOT)(LIST-F)" (read-any ((MAP NOT) LIST-F)) "list:bool[TRUE]")
    (test-list-element "MAP(NOT)(LIST-T-F-F-T)" (read-any ((MAP NOT) LIST-T-F-F-T)) "list:bool[FALSE,TRUE,TRUE,FALSE]")
    (test-list-element "MAP(ADD-2)(LIST-0)" (read-any ((MAP ADD-2) LIST-0)) "list:nat[2]")
    (test-list-element "MAP(ADD-2)(LIST-1-3-4-2)" (read-any ((MAP ADD-2) LIST-1-3-4-2)) "list:nat[3,5,6,4]")
    (test-list-element "MAP(SQ-Z)(LIST-n2-p1-p2-n4-n5)" (read-any ((MAP SQ-Z) LIST-n2-p1-p2-n4-n5)) "list:int[4,1,4,16,25]")
    (test-list-element "MAP(lambda (x) ((EXPz x) posTHREE))(LIST-n2-p1-p2-n4-n5)" (read-any ((MAP (lambda (x) ((EXPz x) posTHREE))) LIST-n2-p1-p2-n4-n5)) "list:int[-8,1,8,-64,-125]")
))

(show-results "MAP" MAP-tests)

; ====================================================================

(define FILTER-tests (list
    (test-list-element "FILTER(AND-T)(LIST-T-F-F-T)" (read-any ((FILTER AND-T) LIST-T-F-F-T)) "list:bool[TRUE,TRUE]")
    (test-list-element "FILTER(IS_EVEN)(LIST-1-3-4-2)" (read-any ((FILTER IS_EVEN) LIST-1-3-4-2)) "list:nat[4,2]")
    (test-list-element "FILTER(IS_ODD)(LIST-1-3-4-2)" (read-any ((FILTER IS_ODD) LIST-1-3-4-2)) "list:nat[1,3]")
    (test-list-element "FILTER(LIST-n2-p1-p2-n4-n5)" (read-any ((FILTER (lambda (x) ((EQz x) posTWO))) LIST-n2-p1-p2-n4-n5)) "list:int[2]")
))

(show-results "FILTER" FILTER-tests)

; ====================================================================

(define FOLD-tests (list
    (test-list-element "FOLD(ADDz)(0)(LIST-n2-p1-p2-n4-n5)" (read-any (((FOLD ADDz) posZERO) LIST-n2-p1-p2-n4-n5)) "int:-8")
    (test-list-element "FOLD(MULT)(1)(LIST-1-3-4-2)" (read-any (((FOLD MULT) ONE) LIST-1-3-4-2)) "nat:24")
    (test-list-element "FOLD(EXP)(2)(LIST-2-3)" (read-any (((FOLD EXP) ONE) ((_make-list nat) (_cons two three)))) "nat:8")
))

(show-results "FOLD" FOLD-tests)

; ====================================================================

(define TAKE-tests (list
    (test-list-element "TAKE(FOUR)(LIST-n2-p1-p2-n4-n5)" (read-any ((TAKE FOUR) LIST-n2-p1-p2-n4-n5)) "list:int[-2,1,2,-4]")
    (test-list-element "TAKE(FIVE)(LIST-n2-p1-p2-n4-n5)" (read-any ((TAKE (SUCC FOUR)) LIST-n2-p1-p2-n4-n5)) "list:int[-2,1,2,-4,-5]")
    (test-list-element "TAKE(ZERO)(LIST-n2-p1-p2-n4-n5)" (read-any ((TAKE ZERO) LIST-n2-p1-p2-n4-n5)) "list[]")
    (test-list-element "TAKE(TWO)(LIST-1-3-4-2)" (read-any ((TAKE TWO) LIST-1-3-4-2)) "list:nat[1,3]")
    (test-list-element "TAKE(THREE)(LIST-T-F-F-T)" (read-any ((TAKE THREE) LIST-T-F-F-T)) "list:bool[TRUE,FALSE,FALSE]")
))

(show-results "TAKE" TAKE-tests)

; ====================================================================

(define TAKE-TAIL-tests (list
    (test-list-element "TAKE(FOUR)(LIST-n2-p1-p2-n4-n5)" (read-any ((TAKE-TAIL FOUR) LIST-n2-p1-p2-n4-n5)) "list:int[1,2,-4,-5]")
    (test-list-element "TAKE(FIVE)(LIST-n2-p1-p2-n4-n5)" (read-any ((TAKE-TAIL (SUCC FOUR)) LIST-n2-p1-p2-n4-n5)) "list:int[-2,1,2,-4,-5]")
    (test-list-element "TAKE(ZERO)(LIST-n2-p1-p2-n4-n5)" (read-any ((TAKE-TAIL ZERO) LIST-n2-p1-p2-n4-n5)) "list[]")
    (test-list-element "TAKE(TWO)(LIST-1-3-4-2)" (read-any ((TAKE-TAIL TWO) LIST-1-3-4-2)) "list:nat[4,2]")
    (test-list-element "TAKE(THREE)(LIST-T-F-F-T)" (read-any ((TAKE-TAIL THREE) LIST-T-F-F-T)) "list:bool[FALSE,FALSE,TRUE]")
))

(show-results "TAKE-TAIL" TAKE-TAIL-tests)

; ; ====================================================================

; (define insert-tests (list
;     (test-list-element "insert(four)(l-5-4-2-0-4-2)(three)" (read-any (((insert four) l-5-4-2-0-4-2) three)) "list:nat[5,4,2,4,0,4,2]")
;     (test-list-element "insert(five)(l-5-4-2-0-4-2)(two)" (read-any (((insert five) l-5-4-2-0-4-2) two)) "list:nat[5,4,5,2,0,4,2]")
;     (test-list-element "insert(mult(5)(2))(l-4-2)(one)" (read-any (((insert ((mult five) two)) l-4-2) one)) "list:nat[4,10,2]")
;     (test-list-element "insert(one)(l-4-2)(zero)" (read-any (((insert one) l-4-2) zero)) "list:nat[1,4,2]")
;     (test-list-element "insert(five)(l-4-2)(two)" (read-any (((insert five) l-4-2) two)) "list:nat[4,2,5]")
; ))

; (show-results "insert" insert-tests)

; ; ====================================================================

; (define REPLACE-tests (list
;     (test-list-element "REPLACE(four)(l-5-4-2-0-4-2)(three)" (read-any (((REPLACE four) l-5-4-2-0-4-2) three)) "list:nat[5,4,2,4,4,2]")
;     (test-list-element "REPLACE(five)(l-5-4-2-0-4-2)(two)" (read-any (((REPLACE five) l-5-4-2-0-4-2) two)) "list:nat[5,4,5,0,4,2]")
;     (test-list-element "REPLACE(mult(5)(2))(l-4-2)(one)" (read-any (((REPLACE ((mult five) two)) l-4-2) one)) "list:nat[4,10]")
;     (test-list-element "REPLACE(one)(l-4-2)(zero)" (read-any (((REPLACE one) l-4-2) zero)) "list:nat[1,2]")
;     (test-list-element "REPLACE(five)(l-4-2)(one)" (read-any (((REPLACE five) l-4-2) one)) "list:nat[4,5]")
; ))

; (show-results "REPLACE" REPLACE-tests)

; ; ====================================================================

; (define DROP-tests (list
;     (test-list-element "DROP(zero)(l-5-4-2-0-4-2)" (read-any ((_DROP zero) l-5-4-2-0-4-2)) "list:nat[5,4,2,0,4,2]")
;     (test-list-element "DROP(zero)(l-5-4-2-0-4-2)" (read-any ((_DROP two) l-5-4-2-0-4-2)) "list:nat[2,0,4,2]")
;     (test-list-element "DROP(three)(l-t-f-f-t)" (read-any ((_DROP three) l-t-f-f-t)) "list:bool[TRUE]")
;     (test-list-element "DROP(four)(l-t-f-f-t)" (read-any ((_DROP four) l-t-f-f-t)) "list[]")
; ))

; (show-results "DROP" DROP-tests)
