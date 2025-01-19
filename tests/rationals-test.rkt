#lang s-exp "../macros/lazy-with-macros.rkt"
(require "../macros/macros.rkt")
(require "../integers.rkt"
         "../logic.rkt"
         "../church.rkt"
         "../rationals.rkt"
         "helpers/test-helpers.rkt")

; ====================================================================
; ~ RATIONALS TESTS ~
; ====================================================================

(define euclidean-tests (list
    (test-list-element "euclidean(one)(one)" (n-read ((euclidean one) one)) "1")
    (test-list-element "euclidean(two)(one)" (n-read ((euclidean two) one)) "1")
    (test-list-element "euclidean(two)(two)" (n-read ((euclidean two) two)) "2")
    (test-list-element "euclidean(three)(two)" (n-read ((euclidean three) two)) "1")
    (test-list-element "euclidean(three)(three)" (n-read ((euclidean three) three)) "3")
    (test-list-element "euclidean(four)(two)" (n-read ((euclidean four) two)) "2")
    (test-list-element "euclidean(four)(three)" (n-read ((euclidean four) three)) "1")
    (test-list-element "euclidean(five)(four)" (n-read ((euclidean five) four)) "1")
    (test-list-element "euclidean(five)(five)" (n-read ((euclidean five) five)) "5")
))

(show-results "euclidean" euclidean-tests)

; ====================================================================

(define least-common-mult-tests (list
    (test-list-element "_lcm(one)(one)" (n-read ((_lcm one) one)) "1")
    (test-list-element "_lcm(two)(one)" (n-read ((_lcm two) one)) "2")
    (test-list-element "_lcm(two)(two)" (n-read ((_lcm two) two)) "2")
    (test-list-element "_lcm(three)(two)" (n-read ((_lcm three) two)) "6")
    (test-list-element "_lcm(three)(three)" (n-read ((_lcm three) three)) "3")
    (test-list-element "_lcm(four)(two)" (n-read ((_lcm four) two)) "4")
    (test-list-element "_lcm(four)(three)" (n-read ((_lcm four) three)) "12")
    (test-list-element "_lcm(five)(four)" (n-read ((_lcm five) four)) "20")
    (test-list-element "_lcm(five)(five)" (n-read ((_lcm five) five)) "5")
))

(show-results "_lcm" least-common-mult-tests)

; ====================================================================

(define invert-sign-R-tests (list
    (test-list-element "invert-sign-R(one)(one)" (r-read (invert-sign-R r-neg0-1)) "0")
    (test-list-element "invert-sign-R(two)(one)" (r-read (invert-sign-R r-neg1)) "1")
    (test-list-element "invert-sign-R(two)(two)" (r-read (invert-sign-R r-neg1-2)) "1/2")
    (test-list-element "invert-sign-R(three)(two)" (r-read (invert-sign-R r-pos1)) "-1")
    (test-list-element "invert-sign-R(three)(three)" (r-read (invert-sign-R r-pos1-2)) "-1/2")
    (test-list-element "invert-sign-R(four)(two)" (r-read (invert-sign-R r-pos1-3)) "-1/3")
    (test-list-element "invert-sign-R(four)(three)" (r-read (invert-sign-R r-pos2-1)) "-2")
    (test-list-element "invert-sign-R(five)(four)" (r-read (invert-sign-R r-pos2-3)) "-2/3")
))

(show-results "invert-sign-R" invert-sign-R-tests)

; ====================================================================

(define reciprocal-tests (list
    (test-list-element "reciprocal(one)(one)" (r-read (reciprocal r-neg0-1)) "0")
    (test-list-element "reciprocal(two)(one)" (r-read (reciprocal r-neg1)) "-1")
    (test-list-element "reciprocal(two)(two)" (r-read (reciprocal r-neg1-2)) "-2")
    (test-list-element "reciprocal(three)(two)" (r-read (reciprocal r-pos1)) "1")
    (test-list-element "reciprocal(three)(three)" (r-read (reciprocal r-pos1-2)) "2")
    (test-list-element "reciprocal(four)(two)" (r-read (reciprocal r-pos1-3)) "3")
    (test-list-element "reciprocal(four)(three)" (r-read (reciprocal r-pos2-1)) "1/2")
    (test-list-element "reciprocal(five)(four)" (r-read (reciprocal r-pos2-3)) "3/2")
))

(show-results "reciprocal" reciprocal-tests)

; ====================================================================

(define convert-s-numer-tests (list
    (test-list-element "convert-s-numer(one)(one)" (z-read ((convert-s-numer r-neg1-2) four)) "-2")
    (test-list-element "convert-s-numer(one)(one)" (z-read ((convert-s-numer r-pos1-2) ((mult two) four))) "4")
    (test-list-element "convert-s-numer(one)(one)" (z-read ((convert-s-numer r-pos2-3) ((mult two) three))) "4")
    (test-list-element "convert-s-numer(one)(one)" (z-read ((convert-s-numer r-pos2-1) four)) "8")
))

(show-results "convert-s-numer" convert-s-numer-tests)

; ====================================================================

(define reduce-tests (list
    (test-list-element "reduce(one)(one)" (r-read (reduce r-neg0-1)) "0")
    (test-list-element "reduce(two)(one)" (r-read (reduce r-neg1)) "-1")
    (test-list-element "reduce(two)(two)" (r-read (reduce r-neg1-2)) "-1/2")
    (test-list-element "reduce(three)(two)" (r-read (reduce r-pos1)) "1")
    (test-list-element "reduce(three)(three)" (r-read (reduce r-pos1-2)) "1/2")
    (test-list-element "reduce(four)(two)" (r-read (reduce r-pos1-3)) "1/3")
    (test-list-element "reduce(four)(three)" (r-read (reduce r-neg2-4)) "-1/2")
    (test-list-element "reduce(five)(four)" (r-read (reduce r-neg3-3)) "-1")
    (test-list-element "reduce(four)(three)" (r-read (reduce r-pos4-2)) "2")
    (test-list-element "reduce(five)(four)" (r-read (reduce r-pos8)) "8")
))

(show-results "reduce" reduce-tests)

; ====================================================================

(define addR-tests (list
    (test-list-element "addR(r-neg1-2)(r-neg1-2)" (r-read ((addR r-neg1-2) r-neg1-2)) "-1")
    (test-list-element "addR(r-neg1)(r-neg1)" (r-read ((addR r-neg1) r-neg1)) "-2")
    (test-list-element "addR(r-neg0-1)(r-neg0-1)" (r-read ((addR r-neg0-1) r-neg0-1)) "0")
    (test-list-element "addR(r-pos1)(r-pos1)" (r-read ((addR r-pos1) r-pos1)) "2")
    (test-list-element "addR(r-pos1-2)(r-pos1)" (r-read ((addR r-pos1-2) r-pos1)) "3/2")
    (test-list-element "addR(r-pos1-3)(r-pos1)" (r-read ((addR r-pos1-3) r-pos1)) "4/3")
    (test-list-element "addR(r-pos2-1)(r-pos1)" (r-read ((addR r-pos2-1) r-pos1)) "3")
    (test-list-element "addR(r-pos2-3)(r-pos1)" (r-read ((addR r-pos2-3) r-pos1)) "5/3")
    (test-list-element "addR(r-neg2-4)(r-pos1)" (r-read ((addR r-neg2-4) r-pos1)) "1/2")
    (test-list-element "addR(r-neg3-3)(r-pos1)" (r-read ((addR r-neg3-3) r-pos1)) "0")
    (test-list-element "addR(r-pos4-2)(r-pos1)" (r-read ((addR r-pos4-2) r-pos1)) "3")
    (test-list-element "addR(r-pos8)(r-pos1)" (r-read ((addR r-pos8) r-pos1)) "9")
))

(show-results "addR" addR-tests)

; ====================================================================

(define subR-tests (list
    (test-list-element "subR(r-neg1-2)(r-neg1-2)" (r-read ((subR r-neg1-2) r-neg1-2)) "0")
    (test-list-element "subR(r-neg1)(r-neg1)" (r-read ((subR r-neg1) r-neg1)) "0")
    (test-list-element "subR(r-neg0-1)(r-neg0-1)" (r-read ((subR r-neg0-1) r-neg0-1)) "0")
    (test-list-element "subR(r-pos1)(r-pos1)" (r-read ((subR r-pos1) r-pos1)) "0")
    (test-list-element "subR(r-pos1-2)(r-pos1)" (r-read ((subR r-pos1-2) r-pos1)) "-1/2")
    (test-list-element "subR(r-pos1-3)(r-pos1)" (r-read ((subR r-pos1-3) r-pos1)) "-2/3")
    (test-list-element "subR(r-pos2-1)(r-pos1)" (r-read ((subR r-pos2-1) r-pos1)) "1")
    (test-list-element "subR(r-pos2-3)(r-pos1)" (r-read ((subR r-pos2-3) r-pos1)) "-1/3")
    (test-list-element "subR(r-neg2-4)(r-pos1)" (r-read ((subR r-neg2-4) r-pos1)) "-3/2")
    (test-list-element "subR(r-neg3-3)(r-pos1)" (r-read ((subR r-neg3-3) r-pos1)) "-2")
    (test-list-element "subR(r-pos4-2)(r-pos1)" (r-read ((subR r-pos4-2) r-pos1)) "1")
    (test-list-element "subR(r-pos8)(r-pos1)" (r-read ((subR r-pos8) r-pos1)) "7")
))

(show-results "subR" subR-tests)

; ====================================================================

(define multR-tests (list
    (test-list-element "multR(r-neg1-2)(r-neg1-2)" (r-read ((multR r-neg1-2) r-neg1-2)) "1/4")
    (test-list-element "multR(r-neg1)(r-neg1)" (r-read ((multR r-neg1) r-neg1)) "1")
    (test-list-element "multR(r-neg0-1)(r-neg0-1)" (r-read ((multR r-neg0-1) r-neg0-1)) "0")
    (test-list-element "multR(r-pos1)(r-pos1)" (r-read ((multR r-pos1) r-pos1)) "1")
    (test-list-element "multR(r-pos1-2)(r-pos1)" (r-read ((multR r-pos1-2) r-pos1)) "1/2")
    (test-list-element "multR(r-pos1-3)(r-pos1)" (r-read ((multR r-pos1-3) r-pos1)) "1/3")
    (test-list-element "multR(r-pos2-1)(r-pos1)" (r-read ((multR r-pos2-1) r-pos1)) "2")
    (test-list-element "multR(r-pos2-3)(r-pos1)" (r-read ((multR r-pos2-3) r-pos1)) "2/3")
    (test-list-element "multR(r-neg2-4)(r-pos1)" (r-read ((multR r-neg2-4) r-pos1)) "-1/2")
    (test-list-element "multR(r-neg3-3)(r-pos1)" (r-read ((multR r-neg3-3) r-pos1)) "-1")
    (test-list-element "multR(r-pos4-2)(r-pos1)" (r-read ((multR r-pos4-2) r-pos1)) "2")
    (test-list-element "multR(r-pos8)(r-pos1)" (r-read ((multR r-pos8) r-pos1)) "8")
))

(show-results "multR" multR-tests)

; ====================================================================

(define divR-tests (list
    (test-list-element "divR(r-pos-0)(r-neg1-2)" (r-read ((divR r-pos-0) r-neg1-2)) "0")
    (test-list-element "divR(r-neg1-2)(r-neg1-2)" (r-read ((divR r-neg1-2) r-neg1-2)) "1")
    (test-list-element "divR(r-neg1)(r-neg1)" (r-read ((divR r-neg1) r-neg1)) "1")
    (test-list-element "divR(r-neg0-1)(r-neg0-1)" (r-read ((divR r-neg0-1) r-neg0-1)) "0")
    (test-list-element "divR(r-pos1)(r-pos1)" (r-read ((divR r-pos1) r-pos1)) "1")
    (test-list-element "divR(r-pos1-2)(r-pos1)" (r-read ((divR r-pos1-2) r-pos1)) "1/2")
    (test-list-element "divR(r-pos1-3)(r-pos1)" (r-read ((divR r-pos1-3) r-pos1)) "1/3")
    (test-list-element "divR(r-pos2-1)(r-pos1)" (r-read ((divR r-pos2-1) r-pos1)) "2")
    (test-list-element "divR(r-pos2-3)(r-pos1)" (r-read ((divR r-pos2-3) r-pos1)) "2/3")
    (test-list-element "divR(r-neg2-4)(r-pos1)" (r-read ((divR r-neg2-4) r-pos1)) "-1/2")
    (test-list-element "divR(r-neg3-3)(r-pos1)" (r-read ((divR r-neg3-3) r-pos1)) "-1")
    (test-list-element "divR(r-pos4-2)(r-pos1)" (r-read ((divR r-pos4-2) r-pos1)) "2")
    (test-list-element "divR(r-pos8)(r-pos1)" (r-read ((divR r-pos8) r-pos1)) "8")
))

(show-results "divR" divR-tests)

; ====================================================================

(define gteR-tests (list
    (test-list-element "gteR(r-pos-0)(r-neg1-2)" (b-read ((gteR r-pos-0) r-neg1-2)) "true")
    (test-list-element "gteR(r-neg1-2)(r-neg1-2)" (b-read ((gteR r-neg1-2) r-neg1-2)) "true")
    (test-list-element "gteR(r-neg1)(r-neg1)" (b-read ((gteR r-neg1) r-neg1)) "true")
    (test-list-element "gteR(r-neg0-1)(r-neg0-1)" (b-read ((gteR r-neg0-1) r-neg0-1)) "true")
    (test-list-element "gteR(r-pos1)(r-pos1)" (b-read ((gteR r-pos1) r-pos1)) "true")
    (test-list-element "gteR(r-pos1-2)(r-pos1)" (b-read ((gteR r-pos1-2) r-pos1)) "false")
    (test-list-element "gteR(r-pos1-3)(r-pos1)" (b-read ((gteR r-pos1-3) r-pos1)) "false")
    (test-list-element "gteR(r-pos2-1)(r-pos1)" (b-read ((gteR r-pos2-1) r-pos1)) "true")
    (test-list-element "gteR(r-pos2-3)(r-pos1)" (b-read ((gteR r-pos2-3) r-pos1)) "false")
    (test-list-element "gteR(r-neg2-4)(r-pos1)" (b-read ((gteR r-neg2-4) r-pos1)) "false")
    (test-list-element "gteR(r-neg3-3)(r-pos1)" (b-read ((gteR r-neg3-3) r-pos1)) "false")
    (test-list-element "gteR(r-pos4-2)(r-pos1)" (b-read ((gteR r-pos4-2) r-pos1)) "true")
    (test-list-element "gteR(r-pos8)(r-pos1)" (b-read ((gteR r-pos8) r-pos1)) "true")
))

(show-results "gteR" gteR-tests)

; ====================================================================

(define gtR-tests (list
    (test-list-element "gtR(r-pos-0)(r-neg1-2)" (b-read ((gtR r-pos-0) r-neg1-2)) "true")
    (test-list-element "gtR(r-neg1-2)(r-neg1-2)" (b-read ((gtR r-neg1-2) r-neg1-2)) "false")
    (test-list-element "gtR(r-neg1)(r-neg1)" (b-read ((gtR r-neg1) r-neg1)) "false")
    (test-list-element "gtR(r-neg0-1)(r-neg0-1)" (b-read ((gtR r-neg0-1) r-neg0-1)) "false")
    (test-list-element "gtR(r-pos1)(r-pos1)" (b-read ((gtR r-pos1) r-pos1)) "false")
    (test-list-element "gtR(r-pos1-2)(r-pos1)" (b-read ((gtR r-pos1-2) r-pos1)) "false")
    (test-list-element "gtR(r-pos1-3)(r-pos1)" (b-read ((gtR r-pos1-3) r-pos1)) "false")
    (test-list-element "gtR(r-pos2-1)(r-pos1)" (b-read ((gtR r-pos2-1) r-pos1)) "true")
    (test-list-element "gtR(r-pos2-3)(r-pos1)" (b-read ((gtR r-pos2-3) r-pos1)) "false")
    (test-list-element "gtR(r-neg2-4)(r-pos1)" (b-read ((gtR r-neg2-4) r-pos1)) "false")
    (test-list-element "gtR(r-neg3-3)(r-pos1)" (b-read ((gtR r-neg3-3) r-pos1)) "false")
    (test-list-element "gtR(r-pos4-2)(r-pos1)" (b-read ((gtR r-pos4-2) r-pos1)) "true")
    (test-list-element "gtR(r-pos8)(r-pos1)" (b-read ((gtR r-pos8) r-pos1)) "true")
))

(show-results "gtR" gtR-tests)

; ====================================================================

(define lteR-tests (list
    (test-list-element "lteR(r-pos-0)(r-neg1-2)" (b-read ((lteR r-pos-0) r-neg1-2)) "false")
    (test-list-element "lteR(r-neg1-2)(r-neg1-2)" (b-read ((lteR r-neg1-2) r-neg1-2)) "true")
    (test-list-element "lteR(r-neg1)(r-neg1)" (b-read ((lteR r-neg1) r-neg1)) "true")
    (test-list-element "lteR(r-neg0-1)(r-neg0-1)" (b-read ((lteR r-neg0-1) r-neg0-1)) "true")
    (test-list-element "lteR(r-pos1)(r-pos1)" (b-read ((lteR r-pos1) r-pos1)) "true")
    (test-list-element "lteR(r-pos1-2)(r-pos1)" (b-read ((lteR r-pos1-2) r-pos1)) "true")
    (test-list-element "lteR(r-pos1-3)(r-pos1)" (b-read ((lteR r-pos1-3) r-pos1)) "true")
    (test-list-element "lteR(r-pos2-1)(r-pos1)" (b-read ((lteR r-pos2-1) r-pos1)) "false")
    (test-list-element "lteR(r-pos2-3)(r-pos1)" (b-read ((lteR r-pos2-3) r-pos1)) "true")
    (test-list-element "lteR(r-neg2-4)(r-pos1)" (b-read ((lteR r-neg2-4) r-pos1)) "true")
    (test-list-element "lteR(r-neg3-3)(r-pos1)" (b-read ((lteR r-neg3-3) r-pos1)) "true")
    (test-list-element "lteR(r-pos4-2)(r-pos1)" (b-read ((lteR r-pos4-2) r-pos1)) "false")
    (test-list-element "lteR(r-pos8)(r-pos1)" (b-read ((lteR r-pos8) r-pos1)) "false")
))

(show-results "lteR" lteR-tests)

; ====================================================================

(define ltR-tests (list
    (test-list-element "ltR(r-pos-0)(r-neg1-2)" (b-read ((ltR r-pos-0) r-neg1-2)) "false")
    (test-list-element "ltR(r-neg1-2)(r-neg1-2)" (b-read ((ltR r-neg1-2) r-neg1-2)) "false")
    (test-list-element "ltR(r-neg1)(r-neg1)" (b-read ((ltR r-neg1) r-neg1)) "false")
    (test-list-element "ltR(r-neg0-1)(r-neg0-1)" (b-read ((ltR r-neg0-1) r-neg0-1)) "false")
    (test-list-element "ltR(r-pos1)(r-pos1)" (b-read ((ltR r-pos1) r-pos1)) "false")
    (test-list-element "ltR(r-pos1-2)(r-pos1)" (b-read ((ltR r-pos1-2) r-pos1)) "true")
    (test-list-element "ltR(r-pos1-3)(r-pos1)" (b-read ((ltR r-pos1-3) r-pos1)) "true")
    (test-list-element "ltR(r-pos2-1)(r-pos1)" (b-read ((ltR r-pos2-1) r-pos1)) "false")
    (test-list-element "ltR(r-pos2-3)(r-pos1)" (b-read ((ltR r-pos2-3) r-pos1)) "true")
    (test-list-element "ltR(r-neg2-4)(r-pos1)" (b-read ((ltR r-neg2-4) r-pos1)) "true")
    (test-list-element "ltR(r-neg3-3)(r-pos1)" (b-read ((ltR r-neg3-3) r-pos1)) "true")
    (test-list-element "ltR(r-pos4-2)(r-pos1)" (b-read ((ltR r-pos4-2) r-pos1)) "false")
    (test-list-element "ltR(r-pos8)(r-pos1)" (b-read ((ltR r-pos8) r-pos1)) "false")
))

(show-results "ltR" ltR-tests)
