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
