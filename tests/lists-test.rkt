#lang s-exp "../macros/lazy-with-macros.rkt"
(require "../macros/macros.rkt")
(require "../church.rkt"
         "../core.rkt"
         "../division.rkt"
         "../logic.rkt"
         "../lists.rkt"
         "helpers/test-helpers.rkt")

; ====================================================================
; ~ LISTS TESTS ~
; ====================================================================

(define pairTF ((pair true) false))
(define pairFT ((pair false) true))
(define pair01 ((pair zero) one))
(define pair53 ((pair five) three))

(define head-and-tail-tests (list 
    (test-list-element "head(pair(true)(false)" (b-read (head pairTF)) "true")
    (test-list-element "tail(pair(true)(false)" (b-read (tail pairTF)) "false")
    (test-list-element "head(pair(false)(true)" (b-read (head pairFT)) "false")
    (test-list-element "tail(pair(false)(true)" (b-read (tail pairFT)) "true")
    (test-list-element "head(pair(zero)(one)" (n-read (head pair01)) "0")
    (test-list-element "tail(pair(zero)(one)" (n-read (tail pair01)) "1")
    (test-list-element "head(pair(five)(three)" (n-read (head pair53)) "5")
    (test-list-element "tail(pair(five)(three)" (n-read (tail pair53)) "3")))

(show-results "head-and-tail" head-and-tail-tests)

; ====================================================================

(define l-nil nil)
(define l-true (onelist true))
(define l-false (onelist false))
(define l-0 (onelist zero))
(define l-4 (onelist four))
(define l-0-1 ((twolist zero) one))
(define l-4-2 ((twolist four) two))

(define list-read-tests (list 
    (test-list-element "onelist(nil)" ((l-read l-nil) b-read) "[]")
    (test-list-element "onelist(true)" ((l-read l-true) b-read) "[true]")
    (test-list-element "onelist(false)" ((l-read l-false) b-read) "[false]")
    (test-list-element "onelist(zero)" ((l-read l-0) n-read) "[0]")
    (test-list-element "onelist(four)" ((l-read l-4) n-read) "[4]")
    (test-list-element "twolist(zero)(one)" ((l-read l-0-1) n-read) "[0,1]")
    (test-list-element "twolist(four)(two)" ((l-read l-4-2) n-read) "[4,2]")))

(show-results "l-read" list-read-tests)

; ====================================================================

(define l-0-4-2 ((pair zero) l-4-2))

(define len-tests (list 
    (test-list-element "len(nil)" (n-read (len nil)) "0")
    (test-list-element "len([true])" (n-read (len l-true)) "1")
    (test-list-element "len([0])" (n-read (len l-0)) "1")
    (test-list-element "len([0,1])" (n-read (len l-0-1)) "2")
    (test-list-element "len([0,4,2])" (n-read (len l-0-4-2)) "3")))

(show-results "len" len-tests)

; ====================================================================

(define isNil-tests (list 
    (test-list-element "isNil(nil)" (b-read (isNil nil)) "true")
    (test-list-element "isNil([true])" (b-read (isNil l-true)) "false")
    (test-list-element "isNil([0])" (b-read (isNil l-0)) "false")
    (test-list-element "isNil([0,1])" (b-read (isNil l-0-1)) "false")
    (test-list-element "isNil([0,4,2])" (b-read (isNil l-0-4-2)) "false")))

(show-results "isNil" isNil-tests)

; ====================================================================

(define l-5-4-2 ((pair five) l-4-2))

(define ind-tests (list
    (test-list-element "ind(l-true[0])" (b-read ((ind l-true) zero)) "true")
    (test-list-element "ind(l-0[0])" (n-read ((ind l-0) zero)) "0")
    (test-list-element "ind(l-0-1[0])" (n-read ((ind l-0-1) zero)) "0")
    (test-list-element "ind(l-0-1[1])" (n-read ((ind l-0-1) one)) "1")
    (test-list-element "ind(l-5-4-2[0])" (n-read ((ind l-5-4-2) zero)) "5")
    (test-list-element "ind(l-5-4-2[1])" (n-read ((ind l-5-4-2) one)) "4")
    (test-list-element "ind(l-5-4-2[2])" (n-read ((ind l-5-4-2) two)) "2")))

(show-results "ind" ind-tests)

; ====================================================================

(define app-tests (list
    (test-list-element "app(nil)(l-true)" ((l-read ((app l-true) nil)) b-read) "[true]")
    (test-list-element "app(l-false)(nil)" ((l-read ((app nil) l-false)) b-read) "[false]")
    (test-list-element "app(l-true)(l-true)" ((l-read ((app l-true) l-true)) b-read) "[true,true]")
    (test-list-element "app(l-false)(l-true)" ((l-read ((app l-false) l-true)) b-read) "[false,true]")
    (test-list-element "app(l-0)(l-0)" ((l-read ((app l-0) l-0)) n-read) "[0,0]")
    (test-list-element "app(l-0)(l-4)" ((l-read ((app l-0) l-4)) n-read) "[0,4]")
    (test-list-element "app(l-0-1)(l-0)" ((l-read ((app l-0-1) l-0)) n-read) "[0,1,0]")
    (test-list-element "app(l-0-4-2)(l-0-1)" ((l-read ((app l-0-4-2) l-0-1)) n-read) "[0,4,2,0,1]")))

(show-results "app" app-tests)

; ====================================================================

(define l-5-4-2-0-4-2 ((app l-5-4-2) l-0-4-2))

(define rev-tests (list
    (test-list-element "rev(nil)" ((l-read (rev nil)) b-read) "[]")
    (test-list-element "rev(l-false)" ((l-read (rev l-false)) b-read) "[false]")
    (test-list-element "rev(l-true)" ((l-read (rev l-true)) b-read) "[true]")
    (test-list-element "rev(l-false)" ((l-read (rev l-false)) b-read) "[false]")
    (test-list-element "rev(l-0)" ((l-read (rev l-0)) n-read) "[0]")
    (test-list-element "rev(l-4-2)" ((l-read (rev l-4-2)) n-read) "[2,4]")
    (test-list-element "rev(l-0-4-2)" ((l-read (rev l-0-4-2)) n-read) "[2,4,0]")
    (test-list-element "rev(l-5-4-2-0-4-2)" ((l-read (rev l-5-4-2-0-4-2)) n-read) "[2,4,0,2,4,5]")))

(show-results "rev" rev-tests)

; ====================================================================

(define add2 (lambda (x) ((add x) two)))
(define _andTrue (lambda (x) ((_and x) true)))
(define square (lambda (x) ((mult x) x)))
(define l-t-f-f-t ((pair true) ((pair false) ((twolist false) true))))

(define _map-tests (list
    (test-list-element "_map(_andTrue)(l-false)" ((l-read ((_map _andTrue) l-false)) b-read) "[false]")
    (test-list-element "_map(_andTrue)(l-true)" ((l-read ((_map _andTrue) l-true)) b-read) "[true]")
    (test-list-element "_map(_not)(l-false)" ((l-read ((_map _not) l-false)) b-read) "[true]")
    (test-list-element "_map(_not)(l-t-f-f-t)" ((l-read ((_map _not) l-t-f-f-t)) b-read) "[false,true,true,false]")
    (test-list-element "_map(add2)(l-0)" ((l-read ((_map add2) l-0)) n-read) "[2]")
    (test-list-element "_map(add2)(l-5-4-2-0-4-2)" ((l-read ((_map add2) l-5-4-2-0-4-2)) n-read) "[7,6,4,2,6,4]")
    (test-list-element "_map(square)(l-5-4-2-0-4-2)" ((l-read ((_map square) l-5-4-2-0-4-2)) n-read) "[25,16,4,0,16,4]")
    (test-list-element "_map(lambda (x) ((_exp x) x))(l-5-4-2-0-4-2)" ((l-read ((_map (lambda (x) ((_exp x) x))) l-5-4-2-0-4-2)) n-read) "[3125,256,4,1,256,4]")))

(show-results "_map" _map-tests)

; ====================================================================

(define _filter-tests (list
    (test-list-element "_filter(_andTrue)(l-t-f-f-t)" ((l-read ((_filter _andTrue) l-t-f-f-t)) b-read) "[true,true]")
    (test-list-element "_filter(isEven)(l-0)" ((l-read ((_filter isEven) l-0)) n-read) "[0]")
    (test-list-element "_filter(isEven)(l-5-4-2-0-4-2)" ((l-read ((_filter isEven) l-5-4-2-0-4-2)) n-read) "[4,2,0,4,2]")
    (test-list-element "_filter(isOdd)(l-5-4-2-0-4-2)" ((l-read ((_filter isOdd) l-5-4-2-0-4-2)) n-read) "[5]")
    (test-list-element "_filter(l-5-4-2-0-4-2)" ((l-read ((_filter (lambda (x) ((eq x) two))) l-5-4-2-0-4-2)) n-read) "[2,2]")))

(show-results "_filter" _filter-tests)

; ====================================================================

(define _fold-tests (list
    (test-list-element "_fold(add)(0)(l-5-4-2-0-4-2)" (n-read (((_fold add) zero) l-5-4-2-0-4-2)) "17")
    (test-list-element "_fold(mult)(1)(l-5-4-2)" (n-read (((_fold mult) one) l-5-4-2)) "40")
    (test-list-element "_fold(mult)(2)(l-4-2)" (n-read (((_fold _exp) two) l-4-2)) "256")
))

(show-results "_fold" _fold-tests)

; ====================================================================

(define take-tests (list
    (test-list-element "take(four)(l-5-4-2-0-4-2)" ((l-read ((_take zero) l-5-4-2-0-4-2)) n-read) "[]")
    (test-list-element "take(four)(l-5-4-2-0-4-2)" ((l-read ((_take (succ five)) l-5-4-2-0-4-2)) n-read) "[5,4,2,0,4,2]")
    (test-list-element "take(four)(l-5-4-2-0-4-2)" ((l-read ((_take four) l-5-4-2-0-4-2)) n-read) "[5,4,2,0]")
    (test-list-element "take(two)(l-5-4-2-0-4-2)" ((l-read ((_take two) l-5-4-2-0-4-2)) n-read) "[5,4]")
    (test-list-element "take(three)(l-t-f-f-t)" ((l-read ((_take three) l-t-f-f-t)) b-read) "[true,false,false]")
))

(show-results "take" take-tests)

; ====================================================================

(define takeTail-tests (list
    (test-list-element "takeTail(four)(l-5-4-2-0-4-2)" ((l-read ((takeTail zero) l-5-4-2-0-4-2)) n-read) "[]")
    (test-list-element "takeTail(four)(l-5-4-2-0-4-2)" ((l-read ((takeTail (succ five)) l-5-4-2-0-4-2)) n-read) "[5,4,2,0,4,2]")
    (test-list-element "takeTail(four)(l-5-4-2-0-4-2)" ((l-read ((takeTail four) l-5-4-2-0-4-2)) n-read) "[2,0,4,2]")
    (test-list-element "takeTail(two)(l-5-4-2-0-4-2)" ((l-read ((takeTail two) l-5-4-2-0-4-2)) n-read) "[4,2]")
    (test-list-element "takeTail(three)(l-t-f-f-t)" ((l-read ((takeTail three) l-t-f-f-t)) b-read) "[false,false,true]")
))

(show-results "takeTail" takeTail-tests)

; ====================================================================

(define insert-tests (list
    (test-list-element "insert(four)(l-5-4-2-0-4-2)(three)" ((l-read (((insert four) l-5-4-2-0-4-2) three)) n-read) "[5,4,2,4,0,4,2]")
    (test-list-element "insert(five)(l-5-4-2-0-4-2)(two)" ((l-read (((insert five) l-5-4-2-0-4-2) two)) n-read) "[5,4,5,2,0,4,2]")
    (test-list-element "insert(mult(5)(2))(l-4-2)(one)" ((l-read (((insert ((mult five) two)) l-4-2) one)) n-read) "[4,10,2]")
    (test-list-element "insert(one)(l-4-2)(zero)" ((l-read (((insert one) l-4-2) zero)) n-read) "[1,4,2]")
    (test-list-element "insert(five)(l-4-2)(two)" ((l-read (((insert five) l-4-2) two)) n-read) "[4,2,5]")
))

(show-results "insert" insert-tests)

; ====================================================================

(define replace-tests (list
    (test-list-element "replace(four)(l-5-4-2-0-4-2)(three)" ((l-read (((replace four) l-5-4-2-0-4-2) three)) n-read) "[5,4,2,4,4,2]")
    (test-list-element "replace(five)(l-5-4-2-0-4-2)(two)" ((l-read (((replace five) l-5-4-2-0-4-2) two)) n-read) "[5,4,5,0,4,2]")
    (test-list-element "replace(mult(5)(2))(l-4-2)(one)" ((l-read (((replace ((mult five) two)) l-4-2) one)) n-read) "[4,10]")
    (test-list-element "replace(one)(l-4-2)(zero)" ((l-read (((replace one) l-4-2) zero)) n-read) "[1,2]")
    (test-list-element "replace(five)(l-4-2)(one)" ((l-read (((replace five) l-4-2) one)) n-read) "[4,5]")
))

(show-results "replace" replace-tests)

; ====================================================================

(define drop-tests (list
    (test-list-element "drop(zero)(l-5-4-2-0-4-2)" ((l-read ((_drop zero) l-5-4-2-0-4-2)) n-read) "[5,4,2,0,4,2]")
    (test-list-element "drop(zero)(l-5-4-2-0-4-2)" ((l-read ((_drop two) l-5-4-2-0-4-2)) n-read) "[2,0,4,2]")
    (test-list-element "drop(three)(l-t-f-f-t)" ((l-read ((_drop three) l-t-f-f-t)) b-read) "[true]")
    (test-list-element "drop(four)(l-t-f-f-t)" ((l-read ((_drop four) l-t-f-f-t)) b-read) "[]")
))

(show-results "drop" drop-tests)
