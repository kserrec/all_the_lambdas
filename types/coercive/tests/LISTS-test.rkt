#lang s-exp "../../../macros/lazy-with-macros.rkt"
(require "../../../macros/macros.rkt")
(require "../../../core.rkt"
         "../CHURCH.rkt"
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

; ====================================================================

(define APP-tests (list
    ; normal cases
    (test-list-element "APP(NIL-list)(NIL-list)" (read-any ((APP NIL-list) NIL-list)) "list[]")
    (test-list-element "APP(LIST-T)(NIL-list)" (read-any ((APP LIST-T) NIL-list)) "list[bool:TRUE]")
    (test-list-element "APP(NIL-list)(LIST-F)" (read-any ((APP NIL-list) LIST-F)) "list[bool:FALSE]")
    (test-list-element "APP(LIST-T)(LIST-T)" (read-any ((APP LIST-T) LIST-T)) "list[bool:TRUE,bool:TRUE]")
    (test-list-element "APP(LIST-F)(LIST-T)" (read-any ((APP LIST-F) LIST-T)) "list[bool:FALSE,bool:TRUE]")
    (test-list-element "APP(LIST-n2-p1-p2-n4-n5)(NIL-list)" (read-any ((APP LIST-n2-p1-p2-n4-n5) NIL-list)) "list[int:-2,int:1,int:2,int:-4,int:-5]")
    (test-list-element "APP(LIST-n2-p1-p2-n4-n5)(LIST-n2-p1-p2-n4-n5)" (read-any ((APP LIST-n2-p1-p2-n4-n5) LIST-n2-p1-p2-n4-n5)) "list[int:-2,int:1,int:2,int:-4,int:-5,int:-2,int:1,int:2,int:-4,int:-5]")
    (test-list-element "APP(LIST-n2-p1-p2-n4-n5)(LIST-p2-n3-p0-p4)" (read-any ((APP LIST-n2-p1-p2-n4-n5) LIST-p2-n3-p0-p4)) "list[int:-2,int:1,int:2,int:-4,int:-5,int:2,int:-3,int:0,int:4]")
    (test-list-element "APP(LIST-0-1)(LIST-4)" (read-any ((APP LIST-0-1) LIST-4)) "list[nat:0,nat:1,nat:4]")
    (test-list-element "APP(LIST-0)(LIST-1-0)" (read-any ((APP LIST-0) LIST-1-0)) "list[nat:0,nat:1,nat:0]")
    ; multi-type
    (test-list-element "APP(LIST-T)(LIST-1-0)" (read-any ((APP LIST-0-1) LIST-F)) "list[nat:0,nat:1,bool:FALSE]")
    ; coercing
    (test-list-element "APP(TRUE)(LIST-1-0)" (read-any ((APP TRUE) LIST-1-0)) "list[bool:TRUE,nat:1,nat:0]")
    (test-list-element "APP(TRUE)(LIST-1-0)" (read-any ((APP LIST-n2-p1-p2-n4-n5) FALSE)) "list[int:-2,int:1,int:2,int:-4,int:-5]")
))

(show-results "APP" APP-tests)

; ====================================================================

(define REV-tests (list
    ; normal cases
    (test-list-element "REV(NIL-list)" (read-any (REV NIL-list)) "list[]")
    (test-list-element "REV(LIST-F)" (read-any (REV LIST-F)) "list[bool:FALSE]")
    (test-list-element "REV(LIST-T)" (read-any (REV LIST-T)) "list[bool:TRUE]")
    (test-list-element "REV(LIST-F)" (read-any (REV LIST-F)) "list[bool:FALSE]")
    (test-list-element "REV(LIST-1-0)" (read-any (REV LIST-1-0)) "list[nat:0,nat:1]")
    (test-list-element "REV(LIST-0)" (read-any (REV LIST-0)) "list[nat:0]")
    (test-list-element "REV(LIST-n2-p1-p2-n4-n5)" (read-any (REV LIST-n2-p1-p2-n4-n5)) "list[int:-5,int:-4,int:2,int:1,int:-2]")
    (test-list-element "REV(LIST-1-3-4-2)" (read-any (REV LIST-1-3-4-2)) "list[nat:2,nat:4,nat:3,nat:1]")
    (test-list-element "REV(LIST-T-F-F-T)" (read-any (REV LIST-T-F-F-T)) "list[bool:TRUE,bool:FALSE,bool:FALSE,bool:TRUE]")
    ; coercing
    (test-list-element "REV(TRUE)" (read-any (REV TRUE)) "list[bool:TRUE]")
    (test-list-element "REV(FALSE)" (read-any (REV FALSE)) "list[]")
    (test-list-element "REV(ZERO)" (read-any (REV ZERO)) "list[]")
    (test-list-element "REV(ONE)" (read-any (REV ONE)) "list[nat:1]")
    (test-list-element "REV(posTWO)" (read-any (REV posTWO)) "list[int:2]")
))

(show-results "REV" REV-tests)

; ====================================================================

(def AND-T B = ((AND B) TRUE))
(def ADD-2 N = ((ADD N) TWO))
(def SQ-Z Z = ((MULTz Z) Z))

(define MAP-tests (list
    ; normal cases
    (test-list-element "MAP(AND-T)(NIL-list)" (read-any ((MAP AND-T) NIL-list)) "list[]")
    (test-list-element "MAP(AND-T)(LIST-F)" (read-any ((MAP AND-T) LIST-F)) "list[bool:FALSE]")
    (test-list-element "MAP(AND-T)(LIST-T)" (read-any ((MAP AND-T) LIST-T)) "list[bool:TRUE]")
    (test-list-element "MAP(NOT)(LIST-F)" (read-any ((MAP NOT) LIST-F)) "list[bool:TRUE]")
    (test-list-element "MAP(NOT)(LIST-T-F-F-T)" (read-any ((MAP NOT) LIST-T-F-F-T)) "list[bool:FALSE,bool:TRUE,bool:TRUE,bool:FALSE]")
    (test-list-element "MAP(ADD-2)(LIST-0)" (read-any ((MAP ADD-2) LIST-0)) "list[nat:2]")
    (test-list-element "MAP(ADD-2)(LIST-1-3-4-2)" (read-any ((MAP ADD-2) LIST-1-3-4-2)) "list[nat:3,nat:5,nat:6,nat:4]")
    (test-list-element "MAP(SQ-Z)(LIST-n2-p1-p2-n4-n5)" (read-any ((MAP SQ-Z) LIST-n2-p1-p2-n4-n5)) "list[int:4,int:1,int:4,int:16,int:25]")
    (test-list-element "MAP(lambda (x) ((EXPz x) posTHREE))(LIST-n2-p1-p2-n4-n5)" (read-any ((MAP (lambda (x) ((EXPz x) posTHREE))) LIST-n2-p1-p2-n4-n5)) "list[int:-8,int:1,int:8,int:-64,int:-125]")
    ; coercing
    (test-list-element "MAP(AND-T)(LIST-0)" (read-any ((MAP AND-T) LIST-0)) "list[bool:FALSE]")
    (test-list-element "MAP(AND-T)(LIST-0)" (read-any ((MAP AND-T) LIST-1-0)) "list[bool:TRUE,bool:FALSE]")
    (test-list-element "MAP(ADD-2)(LIST-T-F-F-T)" (read-any ((MAP ADD-2) LIST-T-F-F-T)) "list[nat:3,nat:2,nat:2,nat:3]")
))

(show-results "MAP" MAP-tests)

; ====================================================================

(define FILTER-tests (list
    ; normal cases
    (test-list-element "FILTER(AND-T)(LIST-T-F-F-T)" (read-any ((FILTER AND-T) LIST-T-F-F-T)) "list[bool:TRUE,bool:TRUE]")
    (test-list-element "FILTER(IS_EVEN)(LIST-1-3-4-2)" (read-any ((FILTER IS_EVEN) LIST-1-3-4-2)) "list[nat:4,nat:2]")
    (test-list-element "FILTER(IS_ODD)(LIST-1-3-4-2)" (read-any ((FILTER IS_ODD) LIST-1-3-4-2)) "list[nat:1,nat:3]")
    (test-list-element "FILTER(LIST-n2-p1-p2-n4-n5)" (read-any ((FILTER (lambda (x) ((EQz x) posTWO))) LIST-n2-p1-p2-n4-n5)) "list[int:2]")
    ; coercing
    (test-list-element "FILTER(IS_ODD)(FALSE)" (read-any ((FILTER IS_ODD) FALSE)) "list[]")
    (test-list-element "FILTER(IS_ODD)(ZERO)" (read-any ((FILTER IS_ODD) ZERO)) "list[]")
    (test-list-element "FILTER(IS_ODD)(posTHREE)" (read-any ((FILTER IS_ODD) posTHREE)) "list[int:3]")
))

(show-results "FILTER" FILTER-tests)

; ====================================================================

(def LIST-OF-LISTS-test = ((pair _list) (_cons LIST-n2-p1-p2-n4-n5 LIST-1-3-4-2 LIST-0-1 LIST-T-F-F-T)))

(define FOLD-tests (list
    ; normal cases
    (test-list-element "FOLD(ADDz)(0)(LIST-n2-p1-p2-n4-n5)" (read-any (((FOLD ADDz) posZERO) LIST-n2-p1-p2-n4-n5)) "int:-8")
    (test-list-element "FOLD(MULT)(1)(LIST-1-3-4-2)" (read-any (((FOLD MULT) ONE) LIST-1-3-4-2)) "nat:24")
    (test-list-element "FOLD(EXP)(1)(LIST-2-3)" (read-any (((FOLD EXP) ONE) ((pair _list) (_cons TWO THREE)))) "nat:1")
    (test-list-element "FOLD(EXP)(2)(LIST-1-3-2)" (read-any (((FOLD EXP) TWO) ((pair _list) (_cons ONE THREE TWO)))) "nat:64")
    (test-list-element "FOLD(APP)(nil)(LIST-OF-LISTS)" (read-any (((FOLD APP) NIL-list) LIST-OF-LISTS-test)) "list[bool:TRUE,bool:FALSE,bool:FALSE,bool:TRUE,nat:0,nat:1,nat:1,nat:3,nat:4,nat:2,int:-2,int:1,int:2,int:-4,int:-5]")
    ; coercing
    (test-list-element "FOLD(ADD)(TWO)(LIST-2-3-2)" (read-any (((FOLD ADD) TWO) ((pair _list) (_cons TWO THREE TWO)))) "nat:9")
    (test-list-element "FOLD(ADD)(posTHREE)(LIST-2-3-2)" (read-any (((FOLD ADD) posTHREE) ((pair _list) (_cons TWO THREE TWO)))) "nat:10")
    (test-list-element "FOLD(EXP)(ONE)(LIST-p2-p3)" (read-any (((FOLD EXP) ONE) ((pair _list) (_cons posTWO posTHREE)))) "nat:1")
    (test-list-element "FOLD(EXP)(posTHREE)(LIST-3-2)" (read-any (((FOLD EXP) posTHREE) ((pair _list) (_cons THREE TWO)))) "nat:729")
    (test-list-element "FOLD(EXPz)(TRUE)(LIST-3-2)" (read-any (((FOLD EXPz) TRUE) ((pair _list) (_cons LIST-1-3-4-2 FIVE)))) "int:1")
))

(show-results "FOLD" FOLD-tests)

; ====================================================================

(define TAKE-tests (list
    ; normal cases
    (test-list-element "TAKE(FOUR)(NIL-list)" (read-any ((TAKE FOUR) NIL-list)) "list[]")
    (test-list-element "TAKE(FOUR)(LIST-n2-p1-p2-n4-n5)" (read-any ((TAKE FOUR) LIST-n2-p1-p2-n4-n5)) "list[int:-2,int:1,int:2,int:-4]")
    (test-list-element "TAKE(FIVE)(LIST-n2-p1-p2-n4-n5)" (read-any ((TAKE (SUCC FOUR)) LIST-n2-p1-p2-n4-n5)) "list[int:-2,int:1,int:2,int:-4,int:-5]")
    (test-list-element "TAKE(ZERO)(LIST-n2-p1-p2-n4-n5)" (read-any ((TAKE ZERO) LIST-n2-p1-p2-n4-n5)) "list[]")
    (test-list-element "TAKE(TWO)(LIST-1-3-4-2)" (read-any ((TAKE TWO) LIST-1-3-4-2)) "list[nat:1,nat:3]")
    (test-list-element "TAKE(THREE)(LIST-T-F-F-T)" (read-any ((TAKE THREE) LIST-T-F-F-T)) "list[bool:TRUE,bool:FALSE,bool:FALSE]")
    ; coercing
    (test-list-element "TAKE(posTHREE)(LIST-T-F-F-T)" (read-any ((TAKE posTHREE) LIST-T-F-F-T)) "list[bool:TRUE,bool:FALSE,bool:FALSE]")
    (test-list-element "TAKE(THREE)(FALSE)" (read-any ((TAKE THREE) FALSE)) "list[]")
))

(show-results "TAKE" TAKE-tests)

; ====================================================================

(define TAKE-TAIL-tests (list
    ; normal cases
    (test-list-element "TAKE(FOUR)(LIST-n2-p1-p2-n4-n5)" (read-any ((TAKE-TAIL FOUR) LIST-n2-p1-p2-n4-n5)) "list[int:1,int:2,int:-4,int:-5]")
    (test-list-element "TAKE(FIVE)(LIST-n2-p1-p2-n4-n5)" (read-any ((TAKE-TAIL (SUCC FOUR)) LIST-n2-p1-p2-n4-n5)) "list[int:-2,int:1,int:2,int:-4,int:-5]")
    (test-list-element "TAKE(ZERO)(LIST-n2-p1-p2-n4-n5)" (read-any ((TAKE-TAIL ZERO) LIST-n2-p1-p2-n4-n5)) "list[]")
    (test-list-element "TAKE(TWO)(LIST-1-3-4-2)" (read-any ((TAKE-TAIL TWO) LIST-1-3-4-2)) "list[nat:4,nat:2]")
    (test-list-element "TAKE(THREE)(LIST-T-F-F-T)" (read-any ((TAKE-TAIL THREE) LIST-T-F-F-T)) "list[bool:FALSE,bool:FALSE,bool:TRUE]")
    ; coercing
    (test-list-element "TAKE-TAIL(posTHREE)(LIST-T-F-F-T)" (read-any ((TAKE-TAIL posTHREE) LIST-T-F-F-T)) "list[bool:FALSE,bool:FALSE,bool:TRUE]")
    (test-list-element "TAKE-TAIL(THREE)(FALSE)" (read-any ((TAKE-TAIL THREE) FALSE)) "list[]")
))

(show-results "TAKE-TAIL" TAKE-TAIL-tests)

; ====================================================================

(define INSERT-tests (list
    ; normal cases
    (test-list-element "INSERT(posFOUR)(LIST-n2-p1-p2-n4-n5)(ZERO)" (read-any (((INSERT posFOUR) LIST-n2-p1-p2-n4-n5) ZERO)) "list[int:4,int:-2,int:1,int:2,int:-4,int:-5]")
    (test-list-element "INSERT(negTHREE)(LIST-n2-p1-p2-n4-n5)(TWO)" (read-any (((INSERT negTHREE) LIST-n2-p1-p2-n4-n5) TWO)) "list[int:-2,int:1,int:-3,int:2,int:-4,int:-5]")
    (test-list-element "INSERT(FIVE)(LIST-1-3-4-2)(ONE)" (read-any (((INSERT FIVE) LIST-1-3-4-2) ONE)) "list[nat:1,nat:5,nat:3,nat:4,nat:2]")
    (test-list-element "INSERT(MULT(5)(2))(LIST-1-3-4-2)(FOUR)" (read-any (((INSERT ((MULT FIVE) TWO)) LIST-1-3-4-2) FOUR)) "list[nat:1,nat:3,nat:4,nat:2,nat:10]")
    (test-list-element "INSERT(TRUE)(LIST-T-F-F-T)(TWO)" (read-any (((INSERT TRUE) LIST-T-F-F-T) TWO)) "list[bool:TRUE,bool:FALSE,bool:TRUE,bool:FALSE,bool:TRUE]")
    ; coercing
    (test-list-element "INSERT(TRUE)(TRUE)(TWO)" (read-any (((INSERT TRUE) TRUE) TWO)) "list[bool:TRUE,bool:TRUE]")
    (test-list-element "INSERT(THREE)(LIST-T-F-F-T)(negTWO)" (read-any (((INSERT THREE) LIST-T-F-F-T) negTWO)) "list[bool:TRUE,bool:FALSE,nat:3,bool:FALSE,bool:TRUE]")
))

(show-results "INSERT" INSERT-tests)

; ====================================================================

(define REPLACE-tests (list
    ; normal cases
    (test-list-element "REPLACE(posFOUR)(LIST-n2-p1-p2-n4-n5)(ZERO)" (read-any (((REPLACE posFOUR) LIST-n2-p1-p2-n4-n5) ZERO)) "list[int:4,int:1,int:2,int:-4,int:-5]")
    (test-list-element "REPLACE(negTHREE)(LIST-n2-p1-p2-n4-n5)(TWO)" (read-any (((REPLACE negTHREE) LIST-n2-p1-p2-n4-n5) TWO)) "list[int:-2,int:1,int:-3,int:-4,int:-5]")
    (test-list-element "REPLACE(MULT(5)(2))(LIST-1-3-4-2)(FOUR)" (read-any (((REPLACE ((MULT FIVE) TWO)) LIST-1-3-4-2) FOUR)) "list[nat:1,nat:3,nat:4,nat:2,nat:10]")
    (test-list-element "REPLACE(TRUE)(LIST-T-F-F-T)(TWO)" (read-any (((REPLACE TRUE) LIST-T-F-F-T) TWO)) "list[bool:TRUE,bool:FALSE,bool:TRUE,bool:TRUE]")
    ; coercing
    (test-list-element "REPLACE(TRUE)(FALSE)(TWO)" (read-any (((REPLACE TRUE) FALSE) TWO)) "list[bool:TRUE]")
    (test-list-element "REPLACE(FOUR)(LIST-T-F-F-T)(posTWO)" (read-any (((REPLACE FOUR) LIST-T-F-F-T) posTWO)) "list[bool:TRUE,bool:FALSE,nat:4,bool:TRUE]")
))

(show-results "REPLACE" REPLACE-tests)

; ; ====================================================================

(define DROP-tests (list
    ; normal cases
    (test-list-element "DROP(ZERO)(LIST-T-F-F-T)" (read-any ((DROP ZERO) LIST-T-F-F-T)) "list[bool:TRUE,bool:FALSE,bool:FALSE,bool:TRUE]")
    (test-list-element "DROP(TWO)(LIST-1-3-4-2)" (read-any ((DROP TWO) LIST-1-3-4-2)) "list[nat:4,nat:2]")
    (test-list-element "DROP(FIVE)(LIST-n2-p1-p2-n4-n5)" (read-any ((DROP FIVE) LIST-n2-p1-p2-n4-n5)) "list[]")
    (test-list-element "DROP(THREE)(LIST-n2-p1-p2-n4-n5)" (read-any ((DROP THREE) LIST-n2-p1-p2-n4-n5)) "list[int:-4,int:-5]")
    ; coercing
    (test-list-element "DROP(posTHREE)(LIST-n2-p1-p2-n4-n5)" (read-any ((DROP posTHREE) LIST-n2-p1-p2-n4-n5)) "list[int:-4,int:-5]")
    (test-list-element "DROP(THREE)(FOUR)" (read-any ((DROP THREE) FOUR)) "list[]")
))

(show-results "DROP" DROP-tests)

