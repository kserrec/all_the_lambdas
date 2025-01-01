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

(define read-any-LISTS-tests (list 
    ; normal cases
    (test-list-element "read-any(NIL-list)" (read-any NIL-list) "list[]")
    (test-list-element "read-any(LIST-T)" (read-any LIST-T) "list:bool[TRUE]")
    (test-list-element "read-any(LIST-F)" (read-any LIST-F) "list:bool[FALSE]")
    (test-list-element "read-any(LIST-0)" (read-any LIST-0) "list:nat[0]")
    (test-list-element "read-any(LIST-4)" (read-any LIST-4) "list:nat[4]")
    (test-list-element "read-any(LIST-0-1)" (read-any LIST-0-1) "list:nat[0,1]")
    (test-list-element "read-any(LIST-p2-n3-p0-p4)" (read-any LIST-p2-n3-p0-p4) "list:int[2,-3,0,4]")
    (test-list-element "read-any(LIST-n2-p1-p2-n4-n5)" (read-any LIST-n2-p1-p2-n4-n5) "list:int[-2,1,2,-4,-5]")
))

(show-results "read-any-LISTS-tests" read-any-LISTS-tests)

; ====================================================================

(define LEN-tests (list 
    ; normal cases
    (test-list-element "LEN(NIL-list)" (read-any (LEN NIL-list)) "nat:0")
    (test-list-element "LEN([TRUE])" (read-any (LEN LIST-T)) "nat:1")
    (test-list-element "LEN([FALSE])" (read-any (LEN LIST-F)) "nat:1")
    (test-list-element "LEN([nat:0,nat:1])" (read-any (LEN LIST-0-1)) "nat:2")
    (test-list-element "LEN([2,-3,0,4])" (read-any (LEN LIST-p2-n3-p0-p4)) "nat:4")
    ; error cases
    (test-list-element "LEN(FOUR)" (read-any (LEN FOUR)) "LEN(err:list)")
    (test-list-element "LEN(TRUE)" (read-any (LEN TRUE)) "LEN(err:list)")
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
    ; error cases
    (test-list-element "IS-NIL(FALSE)" (read-any (IS-NIL FALSE)) "IS-NIL(err:list)")
    (test-list-element "IS-NIL(FOUR)" (read-any (IS-NIL FOUR)) "IS-NIL(err:list)")
))

(show-results "IS-NIL" IS-NIL-tests)

; ====================================================================

(define IND-tests (list
    ; normal cases
    (test-list-element "IND([TRUE])" (read-any ((IND LIST-T) ZERO)) "bool:TRUE")
    (test-list-element "IND([LIST-1-0])(0))" (read-any ((IND LIST-1-0) ZERO)) "nat:1")
    (test-list-element "IND([LIST-1-0])(1))" (read-any ((IND LIST-1-0) ONE)) "nat:0")
    (test-list-element "IND([LIST-p2-n3-p0-p4](0))" (read-any ((IND LIST-p2-n3-p0-p4) ZERO)) "int:2")
    ; error cases
    (test-list-element "IND([LIST-1-0])(1))" (read-any ((IND LIST-1-0) posONE)) "IND(arg2(err:nat))")
    (test-list-element "IND(TRUE)(1))" (read-any ((IND TRUE) ONE)) "IND(arg1(err:list))")
))

(show-results "IND" IND-tests)

; ====================================================================

(define APP-tests (list
    ; normal cases
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
    ; error cases
    (test-list-element "APP(TRUE)(LIST-1-0)" (read-any ((APP TRUE) LIST-1-0)) "APP(arg1(err:list))")
    (test-list-element "APP(LIST-T)(LIST-1-0)" (read-any ((APP LIST-T) LIST-1-0)) "list:bool[TRUE,nat:1,nat:0]")
))

(show-results "APP" APP-tests)

; ====================================================================

(def LIST-T-F-F-T = ((_make-list bool) (_cons true false false true)))

(define REV-tests (list
    ; normal cases
    (test-list-element "REV(NIL-list)" (read-any (REV NIL-list)) "list[]")
    (test-list-element "REV(LIST-F)" (read-any (REV LIST-F)) "list:bool[FALSE]")
    (test-list-element "REV(LIST-T)" (read-any (REV LIST-T)) "list:bool[TRUE]")
    (test-list-element "REV(LIST-F)" (read-any (REV LIST-F)) "list:bool[FALSE]")
    (test-list-element "REV(LIST-1-0)" (read-any (REV LIST-1-0)) "list:nat[0,1]")
    (test-list-element "REV(LIST-0)" (read-any (REV LIST-0)) "list:nat[0]")
    (test-list-element "REV(LIST-n2-p1-p2-n4-n5)" (read-any (REV LIST-n2-p1-p2-n4-n5)) "list:int[-5,-4,2,1,-2]")
    (test-list-element "REV(LIST-1-3-4-2)" (read-any (REV LIST-1-3-4-2)) "list:nat[2,4,3,1]")
    (test-list-element "REV(LIST-T-F-F-T)" (read-any (REV LIST-T-F-F-T)) "list:bool[TRUE,FALSE,FALSE,TRUE]")
    ; error cases
    (test-list-element "REV(TRUE)" (read-any (REV TRUE)) "REV(err:list)")
))

(show-results "REV" REV-tests)

; ====================================================================

(def AND-T B = ((AND B) TRUE))
(def ADD-2 N = ((ADD N) TWO))
(def SQ-Z Z = ((MULTz Z) Z))

(define MAP-tests (list
    ; normal cases
    (test-list-element "MAP(AND-T)(NIL-list)" (read-any ((MAP AND-T) NIL-list)) "list[]")
    (test-list-element "MAP(AND-T)(LIST-F)" (read-any ((MAP AND-T) LIST-F)) "list:bool[FALSE]")
    (test-list-element "MAP(AND-T)(LIST-T)" (read-any ((MAP AND-T) LIST-T)) "list:bool[TRUE]")
    (test-list-element "MAP(NOT)(LIST-F)" (read-any ((MAP NOT) LIST-F)) "list:bool[TRUE]")
    (test-list-element "MAP(NOT)(LIST-T-F-F-T)" (read-any ((MAP NOT) LIST-T-F-F-T)) "list:bool[FALSE,TRUE,TRUE,FALSE]")
    (test-list-element "MAP(ADD-2)(LIST-0)" (read-any ((MAP ADD-2) LIST-0)) "list:nat[2]")
    (test-list-element "MAP(ADD-2)(LIST-1-3-4-2)" (read-any ((MAP ADD-2) LIST-1-3-4-2)) "list:nat[3,5,6,4]")
    (test-list-element "MAP(SQ-Z)(LIST-n2-p1-p2-n4-n5)" (read-any ((MAP SQ-Z) LIST-n2-p1-p2-n4-n5)) "list:int[4,1,4,16,25]")
    (test-list-element "MAP(lambda (x) ((EXPz x) posTHREE))(LIST-n2-p1-p2-n4-n5)" (read-any ((MAP (lambda (x) ((EXPz x) posTHREE))) LIST-n2-p1-p2-n4-n5)) "list:int[-8,1,8,-64,-125]")
    ; error cases
    (test-list-element "MAP(AND-T)(LIST-0)" (read-any ((MAP AND-T) LIST-0)) "list[AND(arg1(err:bool))]")
    (test-list-element "MAP(AND-T)(LIST-0-1)" (read-any ((MAP AND-T) LIST-0-1)) "list[AND(arg1(err:bool)),AND(arg1(err:bool))]")
    (test-list-element "MAP(AND-T)(TRUE)" (read-any ((MAP AND-T) TRUE)) "MAP(arg2(err:list))")
))

(show-results "MAP" MAP-tests)

; ====================================================================

(define FILTER-tests (list
    ; normal cases
    (test-list-element "FILTER(AND-T)(LIST-T-F-F-T)" (read-any ((FILTER AND-T) LIST-T-F-F-T)) "list:bool[TRUE,TRUE]")
    (test-list-element "FILTER(IS_EVEN)(LIST-1-3-4-2)" (read-any ((FILTER IS_EVEN) LIST-1-3-4-2)) "list:nat[4,2]")
    (test-list-element "FILTER(IS_ODD)(LIST-1-3-4-2)" (read-any ((FILTER IS_ODD) LIST-1-3-4-2)) "list:nat[1,3]")
    (test-list-element "FILTER(LIST-n2-p1-p2-n4-n5)" (read-any ((FILTER (lambda (x) ((EQz x) posTWO))) LIST-n2-p1-p2-n4-n5)) "list:int[2]")
    ; error cases
    (test-list-element "FILTER(IS_ODD)(LIST-T-F-F-T)" (read-any ((FILTER IS_ODD) LIST-T-F-F-T)) "list[IS_ODD(err:nat),IS_ODD(err:nat),IS_ODD(err:nat),IS_ODD(err:nat)]")
    (test-list-element "FILTER(IS_ODD)(FALSE)" (read-any ((FILTER IS_ODD) FALSE)) "FILTER(arg2(err:list))")
    (test-list-element "FILTER(IS_ODD)(posTWO)" (read-any ((FILTER IS_ODD) posTWO)) "FILTER(arg2(err:list))")
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

; ====================================================================

(define INSERT-tests (list
    (test-list-element "INSERT(posFOUR)(LIST-n2-p1-p2-n4-n5)(ZERO)" (read-any (((INSERT posFOUR) LIST-n2-p1-p2-n4-n5) ZERO)) "list:int[4,-2,1,2,-4,-5]")
    (test-list-element "INSERT(negTHREE)(LIST-n2-p1-p2-n4-n5)(TWO)" (read-any (((INSERT negTHREE) LIST-n2-p1-p2-n4-n5) TWO)) "list:int[-2,1,-3,2,-4,-5]")
    (test-list-element "INSERT(FIVE)(LIST-1-3-4-2)(ONE)" (read-any (((INSERT FIVE) LIST-1-3-4-2) ONE)) "list:nat[1,5,3,4,2]")
    (test-list-element "INSERT(MULT(5)(2))(LIST-1-3-4-2)(FOUR)" (read-any (((INSERT ((MULT FIVE) TWO)) LIST-1-3-4-2) FOUR)) "list:nat[1,3,4,2,10]")
    (test-list-element "INSERT(TRUE)(LIST-T-F-F-T)(TWO)" (read-any (((INSERT TRUE) LIST-T-F-F-T) TWO)) "list:bool[TRUE,FALSE,TRUE,FALSE,TRUE]")
))

(show-results "INSERT" INSERT-tests)

; ====================================================================

(define REPLACE-tests (list
    (test-list-element "REPLACE(posFOUR)(LIST-n2-p1-p2-n4-n5)(ZERO)" (read-any (((REPLACE posFOUR) LIST-n2-p1-p2-n4-n5) ZERO)) "list:int[4,1,2,-4,-5]")
    (test-list-element "REPLACE(negTHREE)(LIST-n2-p1-p2-n4-n5)(TWO)" (read-any (((REPLACE negTHREE) LIST-n2-p1-p2-n4-n5) TWO)) "list:int[-2,1,-3,-4,-5]")
    (test-list-element "REPLACE(FIVE)(LIST-1-3-4-2)(ONE)" (read-any (((REPLACE FIVE) LIST-1-3-4-2) ONE)) "list:nat[1,5,4,2]")
    (test-list-element "REPLACE(MULT(5)(2))(LIST-1-3-4-2)(FOUR)" (read-any (((REPLACE ((MULT FIVE) TWO)) LIST-1-3-4-2) FOUR)) "list:nat[1,3,4,2,10]")
    (test-list-element "REPLACE(TRUE)(LIST-T-F-F-T)(TWO)" (read-any (((REPLACE TRUE) LIST-T-F-F-T) TWO)) "list:bool[TRUE,FALSE,TRUE,TRUE]")
))

(show-results "REPLACE" REPLACE-tests)

; ; ====================================================================

(define DROP-tests (list
    (test-list-element "DROP(ZERO)(LIST-T-F-F-T)" (read-any ((DROP ZERO) LIST-T-F-F-T)) "list:bool[TRUE,FALSE,FALSE,TRUE]")
    (test-list-element "DROP(TWO)(LIST-1-3-4-2)" (read-any ((DROP TWO) LIST-1-3-4-2)) "list:nat[4,2]")
    (test-list-element "DROP(FIVE)(LIST-n2-p1-p2-n4-n5)" (read-any ((DROP FIVE) LIST-n2-p1-p2-n4-n5)) "list[]")
    (test-list-element "DROP(THREE)(LIST-n2-p1-p2-n4-n5)" (read-any ((DROP THREE) LIST-n2-p1-p2-n4-n5)) "list:int[-4,-5]")
))

(show-results "DROP" DROP-tests)
