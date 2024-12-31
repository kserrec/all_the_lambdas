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
(define LIST-1-3-4-2 ((_make-list int) (_cons one three four two)))
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
    (test-list-element "LEN(nil)" (read-any (LEN NIL-list)) "nat:0")
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

; ; ====================================================================

(define l-5-4-2-0-4-2 ((app l-5-4-2) l-0-4-2))

(define REV-tests (list
    (test-list-element "REV(nil)" (read-any (REV nil)) "list[]")
    (test-list-element "REV(l-false)" (read-any (REV l-false)) "list:bool[FALSE]")
    (test-list-element "REV(l-true)" (read-any (REV l-true)) "list:bool[TRUE]")
    (test-list-element "REV(l-false)" (read-any (REV l-false)) "list:bool[FALSE]")
    (test-list-element "REV(l-0)" (read-any (REV l-0)) "list:nat[0]")
    (test-list-element "REV(l-4-2)" (read-any (REV l-4-2)) "list:nat[2,4]")
    (test-list-element "REV(l-0-4-2)" (read-any (REV l-0-4-2)) "list:nat[2,4,0]")
    (test-list-element "REV(l-5-4-2-0-4-2)" (read-any (REV l-5-4-2-0-4-2)) "list:nat[2,4,0,2,4,5]")))

(show-results "REV" REV-tests)

; ; ====================================================================

; (define add2 (lambda (x) ((add x) two)))
; (define _andTrue (lambda (x) ((_and x) true)))
; (define square (lambda (x) ((mult x) x)))
; (define l-t-f-f-t ((pair true) ((pair false) ((twolist false) true))))

(define MAP-tests (list
    (test-list-element "MAP(_andTrue)(l-false)" (read-any ((MAP _andTrue) l-false)) "list:bool[FALSE]")
    (test-list-element "MAP(_andTrue)(l-true)" (read-any ((MAP _andTrue) l-true)) "list:bool[TRUE]")
    (test-list-element "MAP(_not)(l-false)" (read-any ((MAP _not) l-false)) "list:bool[TRUE]")
    (test-list-element "MAP(_not)(l-t-f-f-t)" (read-any ((MAP _not) l-t-f-f-t)) "list:bool[FALSE,TRUE,TRUE,FALSE]")
    (test-list-element "MAP(add2)(l-0)" (read-any ((MAP add2) l-0)) "list:nat[2]")
    (test-list-element "MAP(add2)(l-5-4-2-0-4-2)" (read-any ((MAP add2) l-5-4-2-0-4-2)) "list:nat[7,6,4,2,6,4]")
    (test-list-element "MAP(square)(l-5-4-2-0-4-2)" (read-any ((MAP square) l-5-4-2-0-4-2)) "list:nat[25,16,4,0,16,4]")
    (test-list-element "MAP(lambda (x) ((_exp x) x))(l-5-4-2-0-4-2)" (read-any ((MAP (lambda (x) ((_exp x) x))) l-5-4-2-0-4-2)) "list:nat[3125,256,4,1,256,4]")))

(show-results "MAP" MAP-tests)

; ====================================================================

(define FILTER-tests (list
    (test-list-element "FILTER(_andTrue)(l-t-f-f-t)" (read-any ((FILTER _andTrue) l-t-f-f-t)) "list:bool[TRUE,TRUE]")
    (test-list-element "FILTER(isEven)(l-0)" (read-any ((FILTER isEven) l-0)) "list:nat[0]")
    (test-list-element "FILTER(isEven)(l-5-4-2-0-4-2)" (read-any ((FILTER isEven) l-5-4-2-0-4-2)) "list:nat[4,2,0,4,2]")
    (test-list-element "FILTER(isOdd)(l-5-4-2-0-4-2)" (read-any ((FILTER isOdd) l-5-4-2-0-4-2)) "list:nat[5]")
    (test-list-element "FILTER(l-5-4-2-0-4-2)" (read-any ((FILTER (lambda (x) ((eq x) two))) l-5-4-2-0-4-2)) "list:nat[2,2]")))

(show-results "FILTER" FILTER-tests)

; ====================================================================

(define FOLD-tests (list
    (test-list-element "FOLD(add)(0)(l-5-4-2-0-4-2)" (read-any (((FOLD add) zero) l-5-4-2-0-4-2)) "nat:17")
    (test-list-element "FOLD(mult)(1)(l-5-4-2)" (read-any (((FOLD mult) one) l-5-4-2)) "nat:40")
    (test-list-element "FOLD(mult)(2)(l-4-2)" (read-any (((FOLD _exp) two) l-4-2)) "nat:256")
))

(show-results "FOLD" FOLD-tests)

; ====================================================================

(define TAKE-tests (list
    (test-list-element "TAKE(four)(l-5-4-2-0-4-2)" (read-any ((TAKE zero) l-5-4-2-0-4-2)) "list[]")
    (test-list-element "TAKE(four)(l-5-4-2-0-4-2)" (read-any ((TAKE (succ five)) l-5-4-2-0-4-2)) "list:nat[5,4,2,0,4,2]")
    (test-list-element "TAKE(four)(l-5-4-2-0-4-2)" (read-any ((TAKE four) l-5-4-2-0-4-2)) "list:nat[5,4,2,0]")
    (test-list-element "TAKE(two)(l-5-4-2-0-4-2)" (read-any ((TAKE two) l-5-4-2-0-4-2)) "list:nat[5,4]")
    (test-list-element "TAKE(three)(l-t-f-f-t)" (read-any ((TAKE three) l-t-f-f-t)) "list:bool[TRUE,FALSE,FALSE]")
))

(show-results "TAKE" TAKE-tests)

; ====================================================================

(define TAKE-TAIL-tests (list
    (test-list-element "TAKE-TAIL(four)(l-5-4-2-0-4-2)" (read-any ((TAKE-TAIL zero) l-5-4-2-0-4-2)) "list[]")
    (test-list-element "TAKE-TAIL(four)(l-5-4-2-0-4-2)" (read-any ((TAKE-TAIL (succ five)) l-5-4-2-0-4-2)) "list:nat[5,4,2,0,4,2]")
    (test-list-element "TAKE-TAIL(four)(l-5-4-2-0-4-2)" (read-any ((TAKE-TAIL four) l-5-4-2-0-4-2)) "list:nat[2,0,4,2]")
    (test-list-element "TAKE-TAIL(two)(l-5-4-2-0-4-2)" (read-any ((TAKE-TAIL two) l-5-4-2-0-4-2)) "list:nat[4,2]")
    (test-list-element "TAKE-TAIL(three)(l-t-f-f-t)" (read-any ((TAKE-TAIL three) l-t-f-f-t)) "list:bool[FALSE,FALSE,TRUE]")
))

(show-results "TAKE-TAIL" TAKE-TAIL-tests)

; ====================================================================

(define insert-tests (list
    (test-list-element "insert(four)(l-5-4-2-0-4-2)(three)" (read-any (((insert four) l-5-4-2-0-4-2) three)) "list:nat[5,4,2,4,0,4,2]")
    (test-list-element "insert(five)(l-5-4-2-0-4-2)(two)" (read-any (((insert five) l-5-4-2-0-4-2) two)) "list:nat[5,4,5,2,0,4,2]")
    (test-list-element "insert(mult(5)(2))(l-4-2)(one)" (read-any (((insert ((mult five) two)) l-4-2) one)) "list:nat[4,10,2]")
    (test-list-element "insert(one)(l-4-2)(zero)" (read-any (((insert one) l-4-2) zero)) "list:nat[1,4,2]")
    (test-list-element "insert(five)(l-4-2)(two)" (read-any (((insert five) l-4-2) two)) "list:nat[4,2,5]")
))

(show-results "insert" insert-tests)

; ====================================================================

(define REPLACE-tests (list
    (test-list-element "REPLACE(four)(l-5-4-2-0-4-2)(three)" (read-any (((REPLACE four) l-5-4-2-0-4-2) three)) "list:nat[5,4,2,4,4,2]")
    (test-list-element "REPLACE(five)(l-5-4-2-0-4-2)(two)" (read-any (((REPLACE five) l-5-4-2-0-4-2) two)) "list:nat[5,4,5,0,4,2]")
    (test-list-element "REPLACE(mult(5)(2))(l-4-2)(one)" (read-any (((REPLACE ((mult five) two)) l-4-2) one)) "list:nat[4,10]")
    (test-list-element "REPLACE(one)(l-4-2)(zero)" (read-any (((REPLACE one) l-4-2) zero)) "list:nat[1,2]")
    (test-list-element "REPLACE(five)(l-4-2)(one)" (read-any (((REPLACE five) l-4-2) one)) "list:nat[4,5]")
))

(show-results "REPLACE" REPLACE-tests)

; ====================================================================

(define DROP-tests (list
    (test-list-element "DROP(zero)(l-5-4-2-0-4-2)" (read-any ((_DROP zero) l-5-4-2-0-4-2)) "list:nat[5,4,2,0,4,2]")
    (test-list-element "DROP(zero)(l-5-4-2-0-4-2)" (read-any ((_DROP two) l-5-4-2-0-4-2)) "list:nat[2,0,4,2]")
    (test-list-element "DROP(three)(l-t-f-f-t)" (read-any ((_DROP three) l-t-f-f-t)) "list:bool[TRUE]")
    (test-list-element "DROP(four)(l-t-f-f-t)" (read-any ((_DROP four) l-t-f-f-t)) "list[]")
))

(show-results "DROP" DROP-tests)
