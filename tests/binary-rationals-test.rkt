#lang s-exp "../macros/lazy-with-macros.rkt"
(require "../macros/macros.rkt")
(require "../binary-rationals.rkt"
         "../binary-lists.rkt"
         "../int-binary-lists.rkt"
         "../core.rkt"
         "../logic.rkt"
         "helpers/test-helpers.rkt")

; ====================================================================
; ~ BINARY RATIONALS TESTS ~
; ====================================================================

(define r-read-bin-tests (list
    (test-list-element "r-read-bin(0)" (r-read-bin binR-0) "0")
    (test-list-element "r-read-bin(1)" (r-read-bin binR-pos1) "1")
    (test-list-element "r-read-bin(-1)" (r-read-bin binR-neg1) "-1")
    (test-list-element "r-read-bin(1/2)" (r-read-bin binR-pos1-2) "1/2")
    (test-list-element "r-read-bin(-1/2)" (r-read-bin binR-neg1-2) "-1/2")
    (test-list-element "r-read-bin(2/3)" (r-read-bin binR-pos2-3) "2/3")
    (test-list-element "r-read-bin(2/1 shows as 2)" (r-read-bin binR-pos2-1) "2")
    ; raw (unreduced) constants render as written
    (test-list-element "r-read-bin(4/2 unreduced)" (r-read-bin binR-pos4-2) "4/2")
))

(show-results "r-read-bin" r-read-bin-tests)

; ====================================================================

(define reduce-bin-tests (list
    (test-list-element "reduce-bin(4/2) => 2" (r-read-bin (reduce-bin binR-pos4-2)) "2")
    (test-list-element "reduce-bin(2/4) => 1/2" (r-read-bin (reduce-bin binR-pos2-4)) "1/2")
    (test-list-element "reduce-bin(-2/4) => -1/2" (r-read-bin (reduce-bin binR-neg2-4)) "-1/2")
    ; already lowest terms
    (test-list-element "reduce-bin(2/3) unchanged" (r-read-bin (reduce-bin binR-pos2-3)) "2/3")
))

(show-results "reduce-bin" reduce-bin-tests)

; ====================================================================

(define reciprocal-bin-tests (list
    (test-list-element "reciprocal-bin(1/2) => 2" (r-read-bin (reduce-bin (reciprocal-bin binR-pos1-2))) "2")
    (test-list-element "reciprocal-bin(2/3) => 3/2" (r-read-bin (reciprocal-bin binR-pos2-3)) "3/2")
    (test-list-element "invert-sign-R-bin(1/2) => -1/2" (r-read-bin (invert-sign-R-bin binR-pos1-2)) "-1/2")
))

(show-results "reciprocal-bin/invert-sign" reciprocal-bin-tests)

; ====================================================================

(define addR-bin-tests (list
    ; same denominator
    (test-list-element "addR-bin(1/2)(1/2) => 1" (r-read-bin ((addR-bin binR-pos1-2) binR-pos1-2)) "1")
    ; different denominators
    (test-list-element "addR-bin(1/2)(1/3) => 5/6" (r-read-bin ((addR-bin binR-pos1-2) binR-pos1-3)) "5/6")
    (test-list-element "addR-bin(2/3)(1/3) => 1" (r-read-bin ((addR-bin binR-pos2-3) binR-pos1-3)) "1")
    ; opposite signs cancel
    (test-list-element "addR-bin(-1/2)(1/2) => 0" (r-read-bin ((addR-bin binR-neg1-2) binR-pos1-2)) "0")
    ; mixed sign, different denom
    (test-list-element "addR-bin(-1/2)(1/3) => -1/6" (r-read-bin ((addR-bin binR-neg1-2) binR-pos1-3)) "-1/6")
))

(show-results "addR-bin" addR-bin-tests)

; ====================================================================

(define subR-bin-tests (list
    (test-list-element "subR-bin(1/2)(1/3) => 1/6" (r-read-bin ((subR-bin binR-pos1-2) binR-pos1-3)) "1/6")
    (test-list-element "subR-bin(1/2)(1/2) => 0" (r-read-bin ((subR-bin binR-pos1-2) binR-pos1-2)) "0")
    (test-list-element "subR-bin(1/3)(2/3) => -1/3" (r-read-bin ((subR-bin binR-pos1-3) binR-pos2-3)) "-1/3")
))

(show-results "subR-bin" subR-bin-tests)

; ====================================================================

(define multR-bin-tests (list
    (test-list-element "multR-bin(1/2)(2/3) => 1/3" (r-read-bin ((multR-bin binR-pos1-2) binR-pos2-3)) "1/3")
    (test-list-element "multR-bin(-1/2)(2/3) => -1/3" (r-read-bin ((multR-bin binR-neg1-2) binR-pos2-3)) "-1/3")
    (test-list-element "multR-bin(-1/2)(-1/2) => 1/4" (r-read-bin ((multR-bin binR-neg1-2) binR-neg1-2)) "1/4")
    (test-list-element "multR-bin(2/3)(0) => 0" (r-read-bin ((multR-bin binR-pos2-3) binR-0)) "0")
))

(show-results "multR-bin" multR-bin-tests)

; ====================================================================

(define divR-bin-tests (list
    (test-list-element "divR-bin(1/2)(2/3) => 3/4" (r-read-bin ((divR-bin binR-pos1-2) binR-pos2-3)) "3/4")
    (test-list-element "divR-bin(1/2)(1/2) => 1" (r-read-bin ((divR-bin binR-pos1-2) binR-pos1-2)) "1")
    (test-list-element "divR-bin(-1/2)(1/3) => -3/2" (r-read-bin ((divR-bin binR-neg1-2) binR-pos1-3)) "-3/2")
))

(show-results "divR-bin" divR-bin-tests)

; ====================================================================

(define eqR-bin-tests (list
    (test-list-element "eqR-bin(1/2)(1/2)" (b-read ((eqR-bin binR-pos1-2) binR-pos1-2)) "true")
    ; equal after reduction
    (test-list-element "eqR-bin(1/2)(2/4)" (b-read ((eqR-bin binR-pos1-2) binR-pos2-4)) "true")
    (test-list-element "eqR-bin(-1/2)(-2/4)" (b-read ((eqR-bin binR-neg1-2) binR-neg2-4)) "true")
    (test-list-element "eqR-bin(1/2)(1/3)" (b-read ((eqR-bin binR-pos1-2) binR-pos1-3)) "false")
    (test-list-element "eqR-bin(0)(0)" (b-read ((eqR-bin binR-0) binR-0)) "true")
))

(show-results "eqR-bin" eqR-bin-tests)

; ====================================================================

(define ordering-bin-tests (list
    (test-list-element "gteR-bin(2/3)(1/2)" (b-read ((gteR-bin binR-pos2-3) binR-pos1-2)) "true")
    (test-list-element "gteR-bin(1/3)(1/2)" (b-read ((gteR-bin binR-pos1-3) binR-pos1-2)) "false")
    (test-list-element "gteR-bin(1/2)(1/2)" (b-read ((gteR-bin binR-pos1-2) binR-pos1-2)) "true")
    (test-list-element "gtR-bin(1/2)(1/2)" (b-read ((gtR-bin binR-pos1-2) binR-pos1-2)) "false")
    (test-list-element "gtR-bin(2/3)(1/2)" (b-read ((gtR-bin binR-pos2-3) binR-pos1-2)) "true")
    (test-list-element "ltR-bin(-1/2)(1/2)" (b-read ((ltR-bin binR-neg1-2) binR-pos1-2)) "true")
    (test-list-element "ltR-bin(1/2)(1/2)" (b-read ((ltR-bin binR-pos1-2) binR-pos1-2)) "false")
    (test-list-element "lteR-bin(1/2)(1/2)" (b-read ((lteR-bin binR-pos1-2) binR-pos1-2)) "true")
    (test-list-element "lteR-bin(2/3)(1/2)" (b-read ((lteR-bin binR-pos2-3) binR-pos1-2)) "false")
))

(show-results "ordering-bin" ordering-bin-tests)
