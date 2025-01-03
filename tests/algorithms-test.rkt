#lang s-exp "../macros/lazy-with-macros.rkt"
(require "../macros/macros.rkt")
(require "../algorithms.rkt"
         "../core.rkt"
         "../integers.rkt"
         "../lists.rkt"
         "../logic.rkt"
         "../church.rkt"
         "helpers/test-helpers.rkt")

; ====================================================================
; ~ ALGORITHMS TESTS ~
; ====================================================================

(define six ((mult three) two))
(define nine ((mult three) three))
(define ten ((mult five) two))
(define twelve ((mult three) four))
(define fifteen ((mult three) five))
(define eighteen ((mult three) six))
(define twenty ((mult four) five))

(define l-0-2-3-6-9-10-12-15-18-20 ((pair zero) ((pair two) ((pair three) ((pair six) ((pair nine) ((pair ten) ((pair twelve) ((pair fifteen) ((pair eighteen) ((pair twenty) nil)))))))))))

; (displayln ((l-read l-0-2-3-6-9-10-12-15-18-20) n-read))

(define binarySearch-tests (list
    (test-list-element "binarySearch(l-0-2-3-6-9-10-12-15-18-20)(three)" (n-read ((binarySearch l-0-2-3-6-9-10-12-15-18-20) three)) "2")
    (test-list-element "binarySearch(l-0-2-3-6-9-10-12-15-18-20)(twenty)" (n-read ((binarySearch l-0-2-3-6-9-10-12-15-18-20) twenty)) "9")
    (test-list-element "binarySearch(l-0-2-3-6-9-10-12-15-18-20)(zero)" (n-read ((binarySearch l-0-2-3-6-9-10-12-15-18-20) zero)) "0")
    (test-list-element "binarySearch(l-0-2-3-6-9-10-12-15-18-20)(four)" (b-read ((binarySearch l-0-2-3-6-9-10-12-15-18-20) four)) "true")
))

(show-results "binarySearch" binarySearch-tests)

; ====================================================================

(define posTwelve ((makeZ true) twelve))
(define posFifteen ((makeZ true) fifteen))
(define posEighteen ((makeZ true) eighteen))
(define posTwenty ((makeZ true) twenty))

(define l-neg5-neg4-neg3-neg1-0-2-5-12-15-18-20 ((pair negFive) ((pair negFour) ((pair negThree) ((pair negOne) ((pair posZero) ((pair posTwo) ((pair posFive) ((pair posTwelve) ((pair posFifteen) ((pair posEighteen) ((pair posTwenty) nil))))))))))))

(define binarySearchZ-tests (list
    (test-list-element "binarySearchZ(l-neg5-neg4-neg3-neg1-0-2-5-12-15-18-20)()" (z-read ((binarySearchZ l-neg5-neg4-neg3-neg1-0-2-5-12-15-18-20) negThree)) "2")
    (test-list-element "binarySearchZ(l-neg5-neg4-neg3-neg1-0-2-5-12-15-18-20)()" (z-read ((binarySearchZ l-neg5-neg4-neg3-neg1-0-2-5-12-15-18-20) posTwenty)) "10")
    (test-list-element "binarySearchZ(l-neg5-neg4-neg3-neg1-0-2-5-12-15-18-20)()" (z-read ((binarySearchZ l-neg5-neg4-neg3-neg1-0-2-5-12-15-18-20) posTwo)) "5")
    (test-list-element "binarySearchZ(l-neg5-neg4-neg3-neg1-0-2-5-12-15-18-20)()" (z-read ((binarySearchZ l-neg5-neg4-neg3-neg1-0-2-5-12-15-18-20) posFour)) "-1")
))

(show-results "binarySearchZ" binarySearchZ-tests)