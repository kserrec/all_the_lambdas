#lang lazy

(require "../algorithms.rkt"
         "../church.rkt"
         "../division.rkt"
         "../integers.rkt"
         "../lists.rkt"
         "../logic.rkt"
         "../recursion.rkt"
         "../../tests/helpers/test-helpers.rkt")

; ====================================================================
; ~ RAW NESTED-LAMBDA TEACHING ROUTE TESTS ~
; ====================================================================

(define (read-bitter-int z)
    (let ([value (z-read z)])
        (if (string? value)
            value
            (number->string value))))

(define (read-bitter-nat n)
    (let ([value (n-read n)])
        (if (string? value)
            value
            (number->string value))))

(define bitter-list-tests (list
    (test-list-element "pair(true)(false) selects true"
        (b-read (((pair true) false) true)) "true")
    (test-list-element "pair(true)(false) selects false"
        (b-read (((pair true) false) false)) "false")
    (test-list-element "nil"
        (l-read nil n-read) "[]")
    (test-list-element "onelist(five)"
        (l-read (onelist five) n-read) "[5]")
    (test-list-element "twolist(one)(two)"
        (l-read ((twolist one) two) n-read) "[1,2]")))

(show-results "bitter lists" bitter-list-tests)

; ====================================================================

(define bitter-search-list ((pair one) ((pair three) nil)))
(define bitter-search-int-list ((pair posOne) ((pair posThree) nil)))

(define bitter-search-found ((binarySearch bitter-search-list) three))
(define bitter-search-gap ((binarySearch bitter-search-list) two))
(define bitter-search-below ((binarySearch bitter-search-list) zero))
(define bitter-search-empty ((binarySearch nil) zero))
(define bitter-searchZ-found ((binarySearchZ bitter-search-int-list) posThree))
(define bitter-searchZ-gap ((binarySearchZ bitter-search-int-list) posTwo))
(define bitter-searchZ-below ((binarySearchZ bitter-search-int-list) posZero))
(define bitter-searchZ-empty ((binarySearchZ nil) posZero))

(define bitter-binarySearch-tests (list
    (test-list-element "bitter binarySearch found flag"
        (b-read (head bitter-search-found)) "true")
    (test-list-element "bitter binarySearch found index"
        (read-bitter-nat (tail bitter-search-found)) "1")
    (test-list-element "bitter binarySearch internal absence flag"
        (b-read (head bitter-search-gap)) "false")
    (test-list-element "bitter binarySearch internal absence payload"
        (read-bitter-nat (tail bitter-search-gap)) "0")
    (test-list-element "bitter binarySearch below-first flag"
        (b-read (head bitter-search-below)) "false")
    (test-list-element "bitter binarySearch below-first payload"
        (read-bitter-nat (tail bitter-search-below)) "0")
    (test-list-element "bitter binarySearch empty-list flag"
        (b-read (head bitter-search-empty)) "false")
    (test-list-element "bitter binarySearch empty-list payload"
        (read-bitter-nat (tail bitter-search-empty)) "0")
    (test-list-element "bitter binarySearchZ found flag"
        (b-read (head bitter-searchZ-found)) "true")
    (test-list-element "bitter binarySearchZ found natural index"
        (read-bitter-nat (tail bitter-searchZ-found)) "1")
    (test-list-element "bitter binarySearchZ internal absence flag"
        (b-read (head bitter-searchZ-gap)) "false")
    (test-list-element "bitter binarySearchZ internal absence payload"
        (read-bitter-nat (tail bitter-searchZ-gap)) "0")
    (test-list-element "bitter binarySearchZ below-first flag"
        (b-read (head bitter-searchZ-below)) "false")
    (test-list-element "bitter binarySearchZ below-first payload"
        (read-bitter-nat (tail bitter-searchZ-below)) "0")
    (test-list-element "bitter binarySearchZ empty-list flag"
        (b-read (head bitter-searchZ-empty)) "false")
    (test-list-element "bitter binarySearchZ empty-list payload"
        (read-bitter-nat (tail bitter-searchZ-empty)) "0")))

(show-results "bitter binary search" bitter-binarySearch-tests)

; ====================================================================

(define bitter-addZ-tests (list
    (test-list-element "addZ(posFive)(negTwo)"
        (read-bitter-int ((addZ posFive) negTwo)) "3")
    (test-list-element "addZ(negFive)(posTwo)"
        (read-bitter-int ((addZ negFive) posTwo)) "-3")
    (test-list-element "addZ(posTwo)(negFive)"
        (read-bitter-int ((addZ posTwo) negFive)) "-3")
    (test-list-element "addZ(negTwo)(posFive)"
        (read-bitter-int ((addZ negTwo) posFive)) "3")
    (test-list-element "eqZ(negZero)(posZero)"
        (b-read ((eqZ negZero) posZero)) "true")))

(show-results "bitter addZ" bitter-addZ-tests)
