#lang s-exp "../macros/lazy-with-macros.rkt"
(require "../macros/macros.rkt")
(require "../algorithms.rkt"
         "../church.rkt"
         "../core.rkt"
         "../integers.rkt"
         "../lists.rkt"
         "../logic.rkt"
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
(define twenty-one (succ twenty))

(define l-0-2-3-6-9-10-12-15-18-20 ((pair zero) ((pair two) ((pair three) ((pair six) ((pair nine) ((pair ten) ((pair twelve) ((pair fifteen) ((pair eighteen) ((pair twenty) nil)))))))))))
(define l-1-3 ((pair one) ((pair three) nil)))

; (displayln ((l-read l-0-2-3-6-9-10-12-15-18-20) n-read))

(define binarySearch-three-result ((binarySearch l-0-2-3-6-9-10-12-15-18-20) three))
(define binarySearch-twenty-result ((binarySearch l-0-2-3-6-9-10-12-15-18-20) twenty))
(define binarySearch-zero-result ((binarySearch l-0-2-3-6-9-10-12-15-18-20) zero))
(define binarySearch-gap-result ((binarySearch l-0-2-3-6-9-10-12-15-18-20) four))
(define binarySearch-below-first-result ((binarySearch l-1-3) zero))
(define binarySearch-above-last-result ((binarySearch l-0-2-3-6-9-10-12-15-18-20) twenty-one))
(define binarySearch-empty-result ((binarySearch nil) zero))

(define binarySearch-tests (list
    ; found => {true,index}
    (test-list-element "binarySearch naturals finds three" (b-read (head binarySearch-three-result)) "true")
    (test-list-element "binarySearch naturals indexes three" (n-read (tail binarySearch-three-result)) "2")
    (test-list-element "binarySearch naturals finds twenty" (b-read (head binarySearch-twenty-result)) "true")
    (test-list-element "binarySearch naturals indexes twenty" (n-read (tail binarySearch-twenty-result)) "9")
    (test-list-element "binarySearch naturals finds zero" (b-read (head binarySearch-zero-result)) "true")
    (test-list-element "binarySearch naturals indexes zero" (n-read (tail binarySearch-zero-result)) "0")
    ; absent => {false,zero}; cover both directions, the former underflow, and empty input
    (test-list-element "binarySearch naturals rejects internal gap four" (b-read (head binarySearch-gap-result)) "false")
    (test-list-element "binarySearch naturals gives gap canonical payload" (n-read (tail binarySearch-gap-result)) "0")
    (test-list-element "binarySearch naturals terminates below first" (b-read (head binarySearch-below-first-result)) "false")
    (test-list-element "binarySearch naturals gives below-first canonical payload" (n-read (tail binarySearch-below-first-result)) "0")
    (test-list-element "binarySearch naturals terminates above last" (b-read (head binarySearch-above-last-result)) "false")
    (test-list-element "binarySearch naturals gives above-last canonical payload" (n-read (tail binarySearch-above-last-result)) "0")
    (test-list-element "binarySearch naturals terminates on empty list" (b-read (head binarySearch-empty-result)) "false")
    (test-list-element "binarySearch naturals gives empty-list canonical payload" (n-read (tail binarySearch-empty-result)) "0")
))

(show-results "binarySearch" binarySearch-tests)

; ====================================================================

(define posTwelve ((makeZ true) twelve))
(define posFifteen ((makeZ true) fifteen))
(define posEighteen ((makeZ true) eighteen))
(define posTwenty ((makeZ true) twenty))
(define posTwentyOne ((makeZ true) twenty-one))
(define negSix ((makeZ false) six))

(define l-neg5-neg4-neg3-neg1-0-2-5-12-15-18-20 ((pair negFive) ((pair negFour) ((pair negThree) ((pair negOne) ((pair posZero) ((pair posTwo) ((pair posFive) ((pair posTwelve) ((pair posFifteen) ((pair posEighteen) ((pair posTwenty) nil))))))))))))

(define binarySearchZ-negThree-result ((binarySearchZ l-neg5-neg4-neg3-neg1-0-2-5-12-15-18-20) negThree))
(define binarySearchZ-posTwenty-result ((binarySearchZ l-neg5-neg4-neg3-neg1-0-2-5-12-15-18-20) posTwenty))
(define binarySearchZ-posTwo-result ((binarySearchZ l-neg5-neg4-neg3-neg1-0-2-5-12-15-18-20) posTwo))
(define binarySearchZ-gap-result ((binarySearchZ l-neg5-neg4-neg3-neg1-0-2-5-12-15-18-20) posFour))
(define binarySearchZ-below-first-result ((binarySearchZ l-neg5-neg4-neg3-neg1-0-2-5-12-15-18-20) negSix))
(define binarySearchZ-above-last-result ((binarySearchZ l-neg5-neg4-neg3-neg1-0-2-5-12-15-18-20) posTwentyOne))
(define binarySearchZ-empty-result ((binarySearchZ nil) posZero))

(define binarySearchZ-tests (list
    ; found => {true,natural-index}, even though list values are signed integers
    (test-list-element "binarySearchZ finds negThree" (b-read (head binarySearchZ-negThree-result)) "true")
    (test-list-element "binarySearchZ indexes negThree" (n-read (tail binarySearchZ-negThree-result)) "2")
    (test-list-element "binarySearchZ finds posTwenty" (b-read (head binarySearchZ-posTwenty-result)) "true")
    (test-list-element "binarySearchZ indexes posTwenty" (n-read (tail binarySearchZ-posTwenty-result)) "10")
    (test-list-element "binarySearchZ finds posTwo" (b-read (head binarySearchZ-posTwo-result)) "true")
    (test-list-element "binarySearchZ indexes posTwo" (n-read (tail binarySearchZ-posTwo-result)) "5")
    ; absent => {false,zero}
    (test-list-element "binarySearchZ rejects internal gap posFour" (b-read (head binarySearchZ-gap-result)) "false")
    (test-list-element "binarySearchZ gives gap canonical payload" (n-read (tail binarySearchZ-gap-result)) "0")
    (test-list-element "binarySearchZ terminates below first" (b-read (head binarySearchZ-below-first-result)) "false")
    (test-list-element "binarySearchZ gives below-first canonical payload" (n-read (tail binarySearchZ-below-first-result)) "0")
    (test-list-element "binarySearchZ terminates above last" (b-read (head binarySearchZ-above-last-result)) "false")
    (test-list-element "binarySearchZ gives above-last canonical payload" (n-read (tail binarySearchZ-above-last-result)) "0")
    (test-list-element "binarySearchZ terminates on empty list" (b-read (head binarySearchZ-empty-result)) "false")
    (test-list-element "binarySearchZ gives empty-list canonical payload" (n-read (tail binarySearchZ-empty-result)) "0")
))

(show-results "binarySearchZ" binarySearchZ-tests)
