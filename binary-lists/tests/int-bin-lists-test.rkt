#lang s-exp "../../macros/lazy-with-macros.rkt"
(require "../../macros/macros.rkt")
(require "../int-bin-lists.rkt"
         "../binary-lists.rkt"
         "../../core.rkt"
         "../../logic.rkt"
         "../../church.rkt"
         "../../tests/helpers/test-helpers.rkt")

; ====================================================================
; ~ INTEGER BINARY LISTS TESTS ~
; ====================================================================

(define bin-z-read-tests (list 
    (test-list-element "bin-z-read(bz.0)" (bin-z-read bz.0) "0")
    (test-list-element "bin-z-read(bz.-1)" (bin-z-read bz.-1) "-1")
    (test-list-element "bin-z-read(bz.-2)" (bin-z-read bz.-2) "-2")
    (test-list-element "bin-z-read(bz.-3)" (bin-z-read bz.-3) "-3")
    (test-list-element "bin-z-read(bz.-4)" (bin-z-read bz.-4) "-4")
    (test-list-element "bin-z-read(bz.-5)" (bin-z-read bz.-5) "-5")
    (test-list-element "bin-z-read(bz.0)" (bin-z-read bz.0) "0")
    (test-list-element "bin-z-read(bz.-1)" (bin-z-read bz.-1) "-1")
    (test-list-element "bin-z-read(bz.-2)" (bin-z-read bz.-2) "-2")
    (test-list-element "bin-z-read(bz.-3)" (bin-z-read bz.-3) "-3")
    (test-list-element "bin-z-read(bz.-4)" (bin-z-read bz.-4) "-4")
    (test-list-element "bin-z-read(bz.-5)" (bin-z-read bz.-5) "-5")
))

(show-results "bin-z-read" bin-z-read-tests)

; ====================================================================

(define addZ-bin-tests (list 
    (test-list-element "addZ-bin(bz.0)(bz.0)"
        (bin-z-read ((addZ-bin bz.0) bz.0)) "0")
    (test-list-element "addZ-bin(bz.1)(bz.0)"
        (bin-z-read ((addZ-bin bz.1) bz.0)) "1")
    (test-list-element "addZ-bin(bz.0)(bz.1)"
        (bin-z-read ((addZ-bin bz.0) bz.1)) "1")
    (test-list-element "addZ-bin(bz.1)(bz.1)"
        (bin-z-read ((addZ-bin bz.1) bz.1)) "2")
    (test-list-element "addZ-bin(bz.2)(bz.3)"
        (bin-z-read ((addZ-bin bz.2) bz.3)) "5")
    (test-list-element "addZ-bin(bz.4)(bz.1)"
        (bin-z-read ((addZ-bin bz.4) bz.1)) "5")
    (test-list-element "addZ-bin(bz.-1)(bz.-1)"
        (bin-z-read ((addZ-bin bz.-1) bz.-1)) "-2")
    (test-list-element "addZ-bin(bz.-2)(bz.-3)"
        (bin-z-read ((addZ-bin bz.-2) bz.-3)) "-5")
    (test-list-element "addZ-bin(bz.-4)(bz.-1)"
        (bin-z-read ((addZ-bin bz.-4) bz.-1)) "-5")
    (test-list-element "addZ-bin(bz.5)(bz.-5)"
        (bin-z-read ((addZ-bin bz.5) bz.-5)) "0")
    (test-list-element "addZ-bin(bz.-5)(bz.5)"
        (bin-z-read ((addZ-bin bz.-5) bz.5)) "0")
    (test-list-element "addZ-bin(bz.3)(bz.-2)"
        (bin-z-read ((addZ-bin bz.3) bz.-2)) "1")
    (test-list-element "addZ-bin(bz.-3)(bz.2)"
        (bin-z-read ((addZ-bin bz.-3) bz.2)) "-1")
    (test-list-element "addZ-bin(bz.5)(bz.5)"
        (bin-z-read ((addZ-bin bz.5) bz.5)) "10")
    (test-list-element "addZ-bin(bz.-5)(bz.-5)"
        (bin-z-read ((addZ-bin bz.-5) bz.-5)) "-10")
))

(show-results "addZ-bin" addZ-bin-tests)

; ====================================================================

(define multZ-bin-tests (list 
    (test-list-element "multZ-bin(bz.0)(bz.0)"
        (bin-z-read ((multZ-bin bz.0) bz.0)) "0")
    (test-list-element "multZ-bin(bz.1)(bz.0)"
        (bin-z-read ((multZ-bin bz.1) bz.0)) "0")
    (test-list-element "multZ-bin(bz.0)(bz.1)"
        (bin-z-read ((multZ-bin bz.0) bz.1)) "0")
    (test-list-element "multZ-bin(bz.1)(bz.1)"
        (bin-z-read ((multZ-bin bz.1) bz.1)) "1")
    (test-list-element "multZ-bin(bz.2)(bz.3)"
        (bin-z-read ((multZ-bin bz.2) bz.3)) "6")
    (test-list-element "multZ-bin(bz.4)(bz.1)"
        (bin-z-read ((multZ-bin bz.4) bz.1)) "4")
    (test-list-element "multZ-bin(bz.-1)(bz.-1)"
        (bin-z-read ((multZ-bin bz.-1) bz.-1)) "1")
    (test-list-element "multZ-bin(bz.-2)(bz.-3)"
        (bin-z-read ((multZ-bin bz.-2) bz.-3)) "6")
    (test-list-element "multZ-bin(bz.-4)(bz.-1)"
        (bin-z-read ((multZ-bin bz.-4) bz.-1)) "4")
    (test-list-element "multZ-bin(bz.5)(bz.-5)"
        (bin-z-read ((multZ-bin bz.5) bz.-5)) "-25")
    (test-list-element "multZ-bin(bz.-5)(bz.5)"
        (bin-z-read ((multZ-bin bz.-5) bz.5)) "-25")
    (test-list-element "multZ-bin(bz.3)(bz.-2)"
        (bin-z-read ((multZ-bin bz.3) bz.-2)) "-6")
    (test-list-element "multZ-bin(bz.-3)(bz.2)"
        (bin-z-read ((multZ-bin bz.-3) bz.2)) "-6")
    (test-list-element "multZ-bin(bz.5)(bz.5)"
        (bin-z-read ((multZ-bin bz.5) bz.5)) "25")
    (test-list-element "multZ-bin(bz.-5)(bz.-5)"
        (bin-z-read ((multZ-bin bz.-5) bz.-5)) "25")
))

(show-results "multZ-bin" multZ-bin-tests)

; ====================================================================

(define subZ-bin-tests (list 
    (test-list-element "subZ-bin(bz.0)(bz.0)"
        (bin-z-read ((subZ-bin bz.0) bz.0)) "0")
    (test-list-element "subZ-bin(bz.1)(bz.0)"
        (bin-z-read ((subZ-bin bz.1) bz.0)) "1")
    (test-list-element "subZ-bin(bz.0)(bz.1)"
        (bin-z-read ((subZ-bin bz.0) bz.1)) "-1")
    (test-list-element "subZ-bin(bz.1)(bz.1)"
        (bin-z-read ((subZ-bin bz.1) bz.1)) "0")
    (test-list-element "subZ-bin(bz.2)(bz.3)"
        (bin-z-read ((subZ-bin bz.2) bz.3)) "-1")
    (test-list-element "subZ-bin(bz.4)(bz.1)"
        (bin-z-read ((subZ-bin bz.4) bz.1)) "3")
    (test-list-element "subZ-bin(bz.-1)(bz.-1)"
        (bin-z-read ((subZ-bin bz.-1) bz.-1)) "0")
    (test-list-element "subZ-bin(bz.-2)(bz.-3)"
        (bin-z-read ((subZ-bin bz.-2) bz.-3)) "1")
    (test-list-element "subZ-bin(bz.-4)(bz.-1)"
        (bin-z-read ((subZ-bin bz.-4) bz.-1)) "-3")
    (test-list-element "subZ-bin(bz.5)(bz.-5)"
        (bin-z-read ((subZ-bin bz.5) bz.-5)) "10")
    (test-list-element "subZ-bin(bz.-5)(bz.5)"
        (bin-z-read ((subZ-bin bz.-5) bz.5)) "-10")
    (test-list-element "subZ-bin(bz.3)(bz.-2)"
        (bin-z-read ((subZ-bin bz.3) bz.-2)) "5")
    (test-list-element "subZ-bin(bz.-3)(bz.2)"
        (bin-z-read ((subZ-bin bz.-3) bz.2)) "-5")
    (test-list-element "subZ-bin(bz.5)(bz.5)"
        (bin-z-read ((subZ-bin bz.5) bz.5)) "0")
    (test-list-element "subZ-bin(bz.-5)(bz.-5)"
        (bin-z-read ((subZ-bin bz.-5) bz.-5)) "0")
))

(show-results "subZ-bin" subZ-bin-tests)

; ====================================================================

(define divZ-bin-tests (list 
    (test-list-element "divZ-bin(bz.0)(bz.1)"
        (bin-z-read ((divZ-bin bz.0) bz.1)) "0")
    (test-list-element "divZ-bin(bz.1)(bz.1)"
        (bin-z-read ((divZ-bin bz.1) bz.1)) "1")
    (test-list-element "divZ-bin(bz.0)(bz.1)"
        (bin-z-read ((divZ-bin bz.0) bz.1)) "0")
    (test-list-element "divZ-bin(bz.1)(bz.1)"
        (bin-z-read ((divZ-bin bz.1) bz.1)) "1")
    (test-list-element "divZ-bin(bz.2)(bz.3)"
        (bin-z-read ((divZ-bin bz.2) bz.3)) "0")
    (test-list-element "divZ-bin(bz.4)(bz.1)"
        (bin-z-read ((divZ-bin bz.4) bz.1)) "4")
    (test-list-element "divZ-bin(bz.-1)(bz.-1)"
        (bin-z-read ((divZ-bin bz.-1) bz.-1)) "1")
    (test-list-element "divZ-bin(bz.-2)(bz.-3)"
        (bin-z-read ((divZ-bin bz.-2) bz.-3)) "0")
    (test-list-element "divZ-bin(bz.-4)(bz.-1)"
        (bin-z-read ((divZ-bin bz.-4) bz.-1)) "4")
    (test-list-element "divZ-bin(bz.5)(bz.-5)"
        (bin-z-read ((divZ-bin bz.5) bz.-5)) "-1")
    (test-list-element "divZ-bin(bz.-5)(bz.5)"
        (bin-z-read ((divZ-bin bz.-5) bz.5)) "-1")
    (test-list-element "divZ-bin(bz.3)(bz.-2)"
        (bin-z-read ((divZ-bin bz.3) bz.-2)) "-1")
    (test-list-element "divZ-bin(bz.-3)(bz.2)"
        (bin-z-read ((divZ-bin bz.-3) bz.2)) "-1")
    (test-list-element "divZ-bin(bz.5)(bz.5)"
        (bin-z-read ((divZ-bin bz.5) bz.5)) "1")
    (test-list-element "divZ-bin(bz.-5)(bz.-5)"
        (bin-z-read ((divZ-bin bz.-5) bz.-5)) "1")
))

(show-results "divZ-bin" divZ-bin-tests)