#lang s-exp "../macros/lazy-with-macros.rkt"
(require "../macros/macros.rkt")
(require "../church.rkt"
         "../logic.rkt"
         "../lists.rkt"
         "helpers/test-helpers.rkt")

; ====================================================================
; ~ LIST TESTS ~
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
