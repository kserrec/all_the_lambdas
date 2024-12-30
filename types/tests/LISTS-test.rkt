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

(define boolLIST-T ((_make-list bool) (onelist true)))
(define boolLIST-F ((_make-list bool) (onelist false)))
(define natLIST-0 ((_make-list nat) (onelist zero)))
(define natLIST-4 ((_make-list nat) (onelist four)))
(define natLIST-0-1 ((_make-list nat) ((twolist zero) one)))
(define natLIST-1-0 ((_make-list nat) ((twolist one) zero)))
(define intLIST-p2-n3-p0-p4 ((_make-list int) ((app ((twolist posTwo) negThree)) ((twolist posZero) posFour))))

(define read-any-LISTS-tests (list 
    ; normal cases
    (test-list-element "read-any(NIL-list)" (read-any NIL-list) "list[]")
    (test-list-element "read-any(boolLIST-T)" (read-any boolLIST-T) "list[bool:TRUE]")
    (test-list-element "read-any(boolLIST-F)" (read-any boolLIST-F) "list[bool:FALSE]")
    (test-list-element "read-any(natLIST-0)" (read-any natLIST-0) "list[nat:0]")
    (test-list-element "read-any(natLIST-4)" (read-any natLIST-4) "list[nat:4]")
    (test-list-element "read-any(natLIST-0-1)" (read-any natLIST-0-1) "list[nat:0,nat:1]")
    (test-list-element "read-any(intLIST-p2-n3-p0-p4)" (read-any intLIST-p2-n3-p0-p4) "list[int:2,int:-3,int:0,int:4]")
))

(show-results "read-any-LISTS-tests" read-any-LISTS-tests)

; ====================================================================

(define LEN-tests (list 
    (test-list-element "LEN(nil)" (read-any (LEN NIL-list)) "nat:0")
    (test-list-element "LEN([TRUE])" (read-any (LEN boolLIST-T)) "nat:1")
    (test-list-element "LEN([FALSE])" (read-any (LEN boolLIST-F)) "nat:1")
    (test-list-element "LEN([nat:0,nat:1])" (read-any (LEN natLIST-0-1)) "nat:2")
    (test-list-element "LEN([2,-3,0,4])" (read-any (LEN intLIST-p2-n3-p0-p4)) "nat:4")
))

(show-results "LEN" LEN-tests)

; ====================================================================

(define IS-NIL-tests (list 
    (test-list-element "IS-NIL(NIL-list)" (read-any (IS-NIL NIL-list)) "bool:TRUE")
    (test-list-element "IS-NIL([TRUE])" (read-any (IS-NIL boolLIST-T)) "bool:FALSE")
    (test-list-element "IS-NIL([FALSE])" (read-any (IS-NIL boolLIST-F)) "bool:FALSE")
    (test-list-element "IS-NIL([nat:0,nat:1])" (read-any (IS-NIL natLIST-0-1)) "bool:FALSE")
    (test-list-element "IS-NIL([2,-3,0,4])" (read-any (IS-NIL intLIST-p2-n3-p0-p4)) "bool:FALSE")
))

(show-results "IS-NIL" IS-NIL-tests)

; ====================================================================

(define IND-tests (list
    ; (test-list-element "IND([TRUE])" (read-any ((IND boolLIST-T) ZERO)) "bool:TRUE")
    (test-list-element "IND([natLIST-1-0](0))" (read-any ((IND natLIST-1-0) ZERO)) "nat:1")
    (test-list-element "IND([natLIST-1-0](1))" (read-any ((IND natLIST-1-0) ONE)) "nat:0")
    (test-list-element "IND([intLIST-p2-n3-p0-p4](0))" (read-any ((IND intLIST-p2-n3-p0-p4) ZERO)) "int:2")
))

(show-results "IND" IND-tests)

; ; ====================================================================

; (define app-tests (list
;     (test-list-element "app(nil)(l-true)" ((l-read ((app l-true) nil)) b-read) "[true]")
;     (test-list-element "app(l-false)(nil)" ((l-read ((app nil) l-false)) b-read) "[false]")
;     (test-list-element "app(l-true)(l-true)" ((l-read ((app l-true) l-true)) b-read) "[true,true]")
;     (test-list-element "app(l-false)(l-true)" ((l-read ((app l-false) l-true)) b-read) "[false,true]")
;     (test-list-element "app(l-0)(l-0)" ((l-read ((app l-0) l-0)) n-read) "[0,0]")
;     (test-list-element "app(l-0)(l-4)" ((l-read ((app l-0) l-4)) n-read) "[0,4]")
;     (test-list-element "app(l-0-1)(l-0)" ((l-read ((app l-0-1) l-0)) n-read) "[0,1,0]")
;     (test-list-element "app(l-0-4-2)(l-0-1)" ((l-read ((app l-0-4-2) l-0-1)) n-read) "[0,4,2,0,1]")))

; (show-results "app" app-tests)

; ; ====================================================================

; (define l-5-4-2-0-4-2 ((app l-5-4-2) l-0-4-2))

; (define rev-tests (list
;     (test-list-element "rev(nil)" ((l-read (rev nil)) b-read) "[]")
;     (test-list-element "rev(l-false)" ((l-read (rev l-false)) b-read) "[false]")
;     (test-list-element "rev(l-true)" ((l-read (rev l-true)) b-read) "[true]")
;     (test-list-element "rev(l-false)" ((l-read (rev l-false)) b-read) "[false]")
;     (test-list-element "rev(l-0)" ((l-read (rev l-0)) n-read) "[0]")
;     (test-list-element "rev(l-4-2)" ((l-read (rev l-4-2)) n-read) "[2,4]")
;     (test-list-element "rev(l-0-4-2)" ((l-read (rev l-0-4-2)) n-read) "[2,4,0]")
;     (test-list-element "rev(l-5-4-2-0-4-2)" ((l-read (rev l-5-4-2-0-4-2)) n-read) "[2,4,0,2,4,5]")))

; (show-results "rev" rev-tests)

; ; ====================================================================

; (define add2 (lambda (x) ((add x) two)))
; (define _andTrue (lambda (x) ((_and x) true)))
; (define square (lambda (x) ((mult x) x)))
; (define l-t-f-f-t ((pair true) ((pair false) ((twolist false) true))))

; (define _map-tests (list
;     (test-list-element "_map(_andTrue)(l-false)" ((l-read ((_map _andTrue) l-false)) b-read) "[false]")
;     (test-list-element "_map(_andTrue)(l-true)" ((l-read ((_map _andTrue) l-true)) b-read) "[true]")
;     (test-list-element "_map(_not)(l-false)" ((l-read ((_map _not) l-false)) b-read) "[true]")
;     (test-list-element "_map(_not)(l-t-f-f-t)" ((l-read ((_map _not) l-t-f-f-t)) b-read) "[false,true,true,false]")
;     (test-list-element "_map(add2)(l-0)" ((l-read ((_map add2) l-0)) n-read) "[2]")
;     (test-list-element "_map(add2)(l-5-4-2-0-4-2)" ((l-read ((_map add2) l-5-4-2-0-4-2)) n-read) "[7,6,4,2,6,4]")
;     (test-list-element "_map(square)(l-5-4-2-0-4-2)" ((l-read ((_map square) l-5-4-2-0-4-2)) n-read) "[25,16,4,0,16,4]")
;     (test-list-element "_map(lambda (x) ((_exp x) x))(l-5-4-2-0-4-2)" ((l-read ((_map (lambda (x) ((_exp x) x))) l-5-4-2-0-4-2)) n-read) "[3125,256,4,1,256,4]")))

; (show-results "_map" _map-tests)

; ; ====================================================================

; (define _filter-tests (list
;     (test-list-element "_filter(_andTrue)(l-t-f-f-t)" ((l-read ((_filter _andTrue) l-t-f-f-t)) b-read) "[true,true]")
;     (test-list-element "_filter(isEven)(l-0)" ((l-read ((_filter isEven) l-0)) n-read) "[0]")
;     (test-list-element "_filter(isEven)(l-5-4-2-0-4-2)" ((l-read ((_filter isEven) l-5-4-2-0-4-2)) n-read) "[4,2,0,4,2]")
;     (test-list-element "_filter(isOdd)(l-5-4-2-0-4-2)" ((l-read ((_filter isOdd) l-5-4-2-0-4-2)) n-read) "[5]")
;     (test-list-element "_filter(l-5-4-2-0-4-2)" ((l-read ((_filter (lambda (x) ((eq x) two))) l-5-4-2-0-4-2)) n-read) "[2,2]")))

; (show-results "_filter" _filter-tests)

; ; ====================================================================

; (define _fold-tests (list
;     (test-list-element "_fold(add)(0)(l-5-4-2-0-4-2)" (n-read (((_fold add) zero) l-5-4-2-0-4-2)) "17")
;     (test-list-element "_fold(mult)(1)(l-5-4-2)" (n-read (((_fold mult) one) l-5-4-2)) "40")
;     (test-list-element "_fold(mult)(2)(l-4-2)" (n-read (((_fold _exp) two) l-4-2)) "256")
; ))

; (show-results "_fold" _fold-tests)

; ; ====================================================================

; (define take-tests (list
;     (test-list-element "take(four)(l-5-4-2-0-4-2)" ((l-read ((_take zero) l-5-4-2-0-4-2)) n-read) "[]")
;     (test-list-element "take(four)(l-5-4-2-0-4-2)" ((l-read ((_take (succ five)) l-5-4-2-0-4-2)) n-read) "[5,4,2,0,4,2]")
;     (test-list-element "take(four)(l-5-4-2-0-4-2)" ((l-read ((_take four) l-5-4-2-0-4-2)) n-read) "[5,4,2,0]")
;     (test-list-element "take(two)(l-5-4-2-0-4-2)" ((l-read ((_take two) l-5-4-2-0-4-2)) n-read) "[5,4]")
;     (test-list-element "take(three)(l-t-f-f-t)" ((l-read ((_take three) l-t-f-f-t)) b-read) "[true,false,false]")
; ))

; (show-results "take" take-tests)

; ; ====================================================================

; (define takeTail-tests (list
;     (test-list-element "takeTail(four)(l-5-4-2-0-4-2)" ((l-read ((takeTail zero) l-5-4-2-0-4-2)) n-read) "[]")
;     (test-list-element "takeTail(four)(l-5-4-2-0-4-2)" ((l-read ((takeTail (succ five)) l-5-4-2-0-4-2)) n-read) "[5,4,2,0,4,2]")
;     (test-list-element "takeTail(four)(l-5-4-2-0-4-2)" ((l-read ((takeTail four) l-5-4-2-0-4-2)) n-read) "[2,0,4,2]")
;     (test-list-element "takeTail(two)(l-5-4-2-0-4-2)" ((l-read ((takeTail two) l-5-4-2-0-4-2)) n-read) "[4,2]")
;     (test-list-element "takeTail(three)(l-t-f-f-t)" ((l-read ((takeTail three) l-t-f-f-t)) b-read) "[false,false,true]")
; ))

; (show-results "takeTail" takeTail-tests)

; ; ====================================================================

; (define insert-tests (list
;     (test-list-element "insert(four)(l-5-4-2-0-4-2)(three)" ((l-read (((insert four) l-5-4-2-0-4-2) three)) n-read) "[5,4,2,4,0,4,2]")
;     (test-list-element "insert(five)(l-5-4-2-0-4-2)(two)" ((l-read (((insert five) l-5-4-2-0-4-2) two)) n-read) "[5,4,5,2,0,4,2]")
;     (test-list-element "insert(mult(5)(2))(l-4-2)(one)" ((l-read (((insert ((mult five) two)) l-4-2) one)) n-read) "[4,10,2]")
;     (test-list-element "insert(one)(l-4-2)(zero)" ((l-read (((insert one) l-4-2) zero)) n-read) "[1,4,2]")
;     (test-list-element "insert(five)(l-4-2)(two)" ((l-read (((insert five) l-4-2) two)) n-read) "[4,2,5]")
; ))

; (show-results "insert" insert-tests)

; ; ====================================================================

; (define replace-tests (list
;     (test-list-element "replace(four)(l-5-4-2-0-4-2)(three)" ((l-read (((replace four) l-5-4-2-0-4-2) three)) n-read) "[5,4,2,4,4,2]")
;     (test-list-element "replace(five)(l-5-4-2-0-4-2)(two)" ((l-read (((replace five) l-5-4-2-0-4-2) two)) n-read) "[5,4,5,0,4,2]")
;     (test-list-element "replace(mult(5)(2))(l-4-2)(one)" ((l-read (((replace ((mult five) two)) l-4-2) one)) n-read) "[4,10]")
;     (test-list-element "replace(one)(l-4-2)(zero)" ((l-read (((replace one) l-4-2) zero)) n-read) "[1,2]")
;     (test-list-element "replace(five)(l-4-2)(one)" ((l-read (((replace five) l-4-2) one)) n-read) "[4,5]")
; ))

; (show-results "replace" replace-tests)

; ; ====================================================================

; (define drop-tests (list
;     (test-list-element "drop(zero)(l-5-4-2-0-4-2)" ((l-read ((_drop zero) l-5-4-2-0-4-2)) n-read) "[5,4,2,0,4,2]")
;     (test-list-element "drop(zero)(l-5-4-2-0-4-2)" ((l-read ((_drop two) l-5-4-2-0-4-2)) n-read) "[2,0,4,2]")
;     (test-list-element "drop(three)(l-t-f-f-t)" ((l-read ((_drop three) l-t-f-f-t)) b-read) "[true]")
;     (test-list-element "drop(four)(l-t-f-f-t)" ((l-read ((_drop four) l-t-f-f-t)) b-read) "[]")
; ))

; (show-results "drop" drop-tests)