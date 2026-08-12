#lang s-exp "../macros/lazy-with-macros.rkt"
(require "../macros/macros.rkt")
(require "../church.rkt"
         "../core.rkt"
         "../logic.rkt"
         "../lists.rkt"
         "../integers.rkt"
         "../binary-lists.rkt"
         "../sorting.rkt"
         "helpers/test-helpers.rkt")

; ====================================================================
; ~ SORTING TESTS ~
; ====================================================================

; Church-natural fixtures
(define nats-unsorted (_cons three one four one five))
(define nats-sorted (_cons one two three four five))
(define nats-reversed (_cons five four three two one))
(define nats-dups (_cons two two one one))

; ====================================================================

(define merge-tests (list
    (test-list-element "merge([],[2,4])" ((l-read (((merge lte) nil) (_cons two four))) n-read) "[2,4]")
    (test-list-element "merge([1,3],[])" ((l-read (((merge lte) (_cons one three)) nil)) n-read) "[1,3]")
    (test-list-element "merge([1,3],[2,4])" ((l-read (((merge lte) (_cons one three)) (_cons two four))) n-read) "[1,2,3,4]")
    (test-list-element "merge([1,1],[1])" ((l-read (((merge lte) (_cons one one)) (onelist one))) n-read) "[1,1,1]")))

(show-results "merge" merge-tests)

; ====================================================================

(define merge-sort-nat-tests (list
    (test-list-element "msort([])" ((l-read ((merge-sort lte) nil)) n-read) "[]")
    (test-list-element "msort([3])" ((l-read ((merge-sort lte) (onelist three))) n-read) "[3]")
    (test-list-element "msort(sorted)" ((l-read ((merge-sort lte) nats-sorted)) n-read) "[1,2,3,4,5]")
    (test-list-element "msort(reversed)" ((l-read ((merge-sort lte) nats-reversed)) n-read) "[1,2,3,4,5]")
    (test-list-element "msort([3,1,4,1,5])" ((l-read ((merge-sort lte) nats-unsorted)) n-read) "[1,1,3,4,5]")
    (test-list-element "msort(dups)" ((l-read ((merge-sort lte) nats-dups)) n-read) "[1,1,2,2]")))

(show-results "merge-sort naturals" merge-sort-nat-tests)

; ====================================================================

; The SAME merge-sort, handed lteZ, sorts integers…
(define z-mixed (_cons posTwo negThree posZero negOne posOne))

; …and handed bin-lte, binary naturals
(define bin-mixed (_cons bin-seven bin-two bin-ten bin-five))

(define merge-sort-rep-tests (list
    (test-list-element "msort integers" ((l-read ((merge-sort lteZ) z-mixed)) z-read) "[-3,-1,0,1,2]")
    (test-list-element "msort binary nats" ((l-read ((merge-sort bin-lte) bin-mixed)) bin-read) "[2,5,7,10]")))

(show-results "merge-sort across representations" merge-sort-rep-tests)

; ====================================================================

(define quick-sort-nat-tests (list
    (test-list-element "qsort([])" ((l-read ((quick-sort lt) nil)) n-read) "[]")
    (test-list-element "qsort([3])" ((l-read ((quick-sort lt) (onelist three))) n-read) "[3]")
    (test-list-element "qsort(sorted)" ((l-read ((quick-sort lt) nats-sorted)) n-read) "[1,2,3,4,5]")
    (test-list-element "qsort(reversed)" ((l-read ((quick-sort lt) nats-reversed)) n-read) "[1,2,3,4,5]")
    (test-list-element "qsort([3,1,4,1,5])" ((l-read ((quick-sort lt) nats-unsorted)) n-read) "[1,1,3,4,5]")
    (test-list-element "qsort(dups)" ((l-read ((quick-sort lt) nats-dups)) n-read) "[1,1,2,2]")))

(show-results "quick-sort naturals" quick-sort-nat-tests)

; ====================================================================

(define quick-sort-rep-tests (list
    (test-list-element "qsort integers" ((l-read ((quick-sort ltZ) z-mixed)) z-read) "[-3,-1,0,1,2]")
    (test-list-element "qsort binary nats" ((l-read ((quick-sort bin-lt) bin-mixed)) bin-read) "[2,5,7,10]")))

(show-results "quick-sort across representations" quick-sort-rep-tests)

; ====================================================================

(define heap-sort-tests (list
    (test-list-element "hsort([])" ((l-read ((heap-sort lte) nil)) n-read) "[]")
    (test-list-element "hsort([3])" ((l-read ((heap-sort lte) (onelist three))) n-read) "[3]")
    (test-list-element "hsort(reversed)" ((l-read ((heap-sort lte) nats-reversed)) n-read) "[1,2,3,4,5]")
    (test-list-element "hsort([3,1,4,1,5])" ((l-read ((heap-sort lte) nats-unsorted)) n-read) "[1,1,3,4,5]")
    (test-list-element "hsort integers" ((l-read ((heap-sort lteZ) z-mixed)) z-read) "[-3,-1,0,1,2]")
    (test-list-element "hsort binary nats" ((l-read ((heap-sort bin-lte) bin-mixed)) bin-read) "[2,5,7,10]")))

(show-results "heap-sort" heap-sort-tests)

; ====================================================================

; The three sorts agree with each other on the same input
(define agreement-tests (list
    (test-list-element "msort = qsort on [3,1,4,1,5]"
        ((l-read ((quick-sort lt) nats-unsorted)) n-read)
        ((l-read ((merge-sort lte) nats-unsorted)) n-read))
    (test-list-element "msort = hsort on [3,1,4,1,5]"
        ((l-read ((heap-sort lte) nats-unsorted)) n-read)
        ((l-read ((merge-sort lte) nats-unsorted)) n-read))))

(show-results "sort agreement" agreement-tests)
