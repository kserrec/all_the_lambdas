#lang s-exp "../macros/lazy-with-macros.rkt"
(require "../macros/macros.rkt")
(require "../church.rkt"
         "../core.rkt"
         "../logic.rkt"
         "../lists.rkt"
         "../binary-lists.rkt"
         "../binary-algorithms.rkt"
         "helpers/test-helpers.rkt")

; ====================================================================
; ~ BINARY ALGORITHMS TESTS ~
; ====================================================================

(define bin-shl-tests (list
    (test-list-element "5 << 1" (bin-read ((bin-shl one) bin-five)) "10")
    (test-list-element "5 << 2" (bin-read ((bin-shl two) bin-five)) "20")
    (test-list-element "1 << 3" (bin-read ((bin-shl three) bin-one)) "8")
    (test-list-element "0 << 3" (bin-read ((bin-shl three) bin-zero)) "0")
    (test-list-element "7 << 0" (bin-read ((bin-shl zero) bin-seven)) "7")))

(show-results "bin-shl" bin-shl-tests)

; ====================================================================

(define bin-shr-tests (list
    (test-list-element "5 >> 1" (bin-read ((bin-shr one) bin-five)) "2")
    (test-list-element "20 >> 2" (bin-read ((bin-shr two) bin-twenty)) "5")
    (test-list-element "5 >> 3" (bin-read ((bin-shr three) bin-five)) "0")
    (test-list-element "5 >> 5 (past length)" (bin-read ((bin-shr five) bin-five)) "0")
    (test-list-element "0 >> 1" (bin-read ((bin-shr one) bin-zero)) "0")
    (test-list-element "7 >> 0" (bin-read ((bin-shr zero) bin-seven)) "7")))

(show-results "bin-shr" bin-shr-tests)

; ====================================================================

; bin-not-w(w, x) = (2^w - 1) - x
(define bin-not-w-tests (list
    (test-list-element "not-w(4, 5): 0101->1010" (bin-read ((bin-not-w four) bin-five)) "10")
    (test-list-element "not-w(3, 5): 101->010" (bin-read ((bin-not-w three) bin-five)) "2")
    (test-list-element "not-w(2, 12): low bits 00->11" (bin-read ((bin-not-w two) bin-twelve)) "3")
    (test-list-element "not-w(3, 0): 000->111" (bin-read ((bin-not-w three) bin-zero)) "7")
    (test-list-element "not-w(4, 15): all ones out" (bin-read ((bin-not-w four) bin-fifteen)) "0")))

(show-results "bin-not-w" bin-not-w-tests)

; ====================================================================

(define bit-length-tests (list
    (test-list-element "bit-length(0)" (n-read (bin-bit-length bin-zero)) "1")
    (test-list-element "bit-length(1)" (n-read (bin-bit-length bin-one)) "1")
    (test-list-element "bit-length(5)" (n-read (bin-bit-length bin-five)) "3")
    (test-list-element "bit-length(16)" (n-read (bin-bit-length bin-sixteen)) "5")
    (test-list-element "bit-length(unnormalized 0...5)" (n-read (bin-bit-length ((prepend-zeroes two) bin-five))) "3")))

(show-results "bin-bit-length" bit-length-tests)

; ====================================================================

(define popcount-tests (list
    (test-list-element "popcount(0)" (n-read (bin-popcount bin-zero)) "0")
    (test-list-element "popcount(1)" (n-read (bin-popcount bin-one)) "1")
    (test-list-element "popcount(5)" (n-read (bin-popcount bin-five)) "2")
    (test-list-element "popcount(7)" (n-read (bin-popcount bin-seven)) "3")
    (test-list-element "popcount(16)" (n-read (bin-popcount bin-sixteen)) "1")))

(show-results "bin-popcount" popcount-tests)

; ====================================================================

(define bitwise-tests (list
    (test-list-element "5 AND 3" (bin-read ((bin-and bin-five) bin-three)) "1")
    (test-list-element "5 OR 3" (bin-read ((bin-or bin-five) bin-three)) "7")
    (test-list-element "5 XOR 3" (bin-read ((bin-xor bin-five) bin-three)) "6")
    (test-list-element "12 AND 10" (bin-read ((bin-and bin-twelve) bin-ten)) "8")
    (test-list-element "12 OR 10" (bin-read ((bin-or bin-twelve) bin-ten)) "14")
    (test-list-element "12 XOR 10" (bin-read ((bin-xor bin-twelve) bin-ten)) "6")
    (test-list-element "16 AND 0" (bin-read ((bin-and bin-sixteen) bin-zero)) "0")
    (test-list-element "16 OR 0" (bin-read ((bin-or bin-sixteen) bin-zero)) "16")
    (test-list-element "7 XOR 7" (bin-read ((bin-xor bin-seven) bin-seven)) "0")))

(show-results "bitwise and/or/xor" bitwise-tests)
