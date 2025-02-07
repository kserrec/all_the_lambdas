#lang s-exp "../../macros/lazy-with-macros.rkt"
(require "../../macros/macros.rkt")
(require "../binary-lists.rkt"
         "../../core.rkt"
         "../../logic.rkt"
         "../../church.rkt"
         "../../tests/helpers/test-helpers.rkt")

; ====================================================================
; ~ BINARY LISTS TESTS ~
; ====================================================================

(define bin-read-tests (list 
    (test-list-element "bin-read(bn.0)" (bin-read bn.0) "0")
    (test-list-element "bin-read(bn.1)" (bin-read bn.1) "1")
    (test-list-element "bin-read(bn.2)" (bin-read bn.2) "2")
    (test-list-element "bin-read(bn.3)" (bin-read bn.3) "3")
    (test-list-element "bin-read(bn.4)" (bin-read bn.4) "4")
    (test-list-element "bin-read(bn.5)" (bin-read bn.5) "5")
    (test-list-element "bin-read(bn.10)" (bin-read bn.10) "10")
    (test-list-element "bin-read(bn.20)" (bin-read bn.20) "20")
    (test-list-element "bin-read(bn.20-four)" 
        (bin-read bn.20-four) "24")
    (test-list-element "bin-read(bn.1_000_000_000)" 
        (bin-read bn.1_000_000_000) "1000000000")
    (test-list-element "bin-read(bn.1_000_000_000_000)" 
        (bin-read bn.1_000_000_000_000) "1000000000000")
    (test-list-element "bin-read(bn.1_000_000_000_000_000)" 
        (bin-read bn.1_000_000_000_000_000) "1000000000000000")
    (test-list-element "bin-read(bn.1_000_000_000_000_000_000)" 
        (bin-read bn.1_000_000_000_000_000_000) "1000000000000000000")
    (test-list-element "bin-read(bn.1_000_000_000_000_000_000_000)" 
        (bin-read bn.1_000_000_000_000_000_000_000) "1000000000000000000000")
))

(show-results "bin-read" bin-read-tests)

; ====================================================================

(define bin-add-tests (list 
    ; trivial cases
    (test-list-element "bin-add(bn.0)(bn.0)"
        (bin-read ((bin-add bn.0) bn.0)) "0")
    (test-list-element "bin-add(bn.1)(bn.0)"
        (bin-read ((bin-add bn.1) bn.0)) "1")
    (test-list-element "bin-add(bn.0)(bn.1)"
        (bin-read ((bin-add bn.1) bn.0)) "1")
    (test-list-element "bin-add(bn.1)(bn.1)"
        (bin-read ((bin-add bn.1) bn.1)) "2")

    ; small numbers
    (test-list-element "bin-add(bn.2)(bn.3)"
        (bin-read ((bin-add bn.2) bn.3)) "5")
    (test-list-element "bin-add(bn.4)(bn.1)"
        (bin-read ((bin-add bn.4) bn.1)) "5")
    (test-list-element "bin-add(bn.6)(bn.2)"
        (bin-read ((bin-add bn.6) bn.2)) "8")
    (test-list-element "bin-add(bn.7)(bn.5)"
        (bin-read ((bin-add bn.7) bn.5)) "12")

    ; large numbers
    (test-list-element "bin-add(bn.15)(bn.1)"
        (bin-read ((bin-add bn.15) bn.1)) "16")
    (test-list-element "bin-add(bn.31)(bn.32)"
        (bin-read ((bin-add bn.31) bn.32)) "63")
    (test-list-element "bin-add(bn.512)(bn.512)"
        (bin-read ((bin-add bn.512) bn.512)) "1024")

    ; uneven list lengths
    (test-list-element "bin-add(bn.8)(bn.1)"
        (bin-read ((bin-add bn.8) bn.1)) "9")
    (test-list-element "bin-add(bn.64)(bn.15)" 
        (bin-read ((bin-add bn.64) bn.15)) "79")
    (test-list-element "bin-add(bn.128)(bn.7)"
        (bin-read ((bin-add bn.128) bn.7)) "135")

    ; carry propagation
    (test-list-element "bin-add(bn.3)(bn.1)"
        (bin-read ((bin-add bn.3) bn.1)) "4")
    (test-list-element "bin-add(bn.7)(bn.1)" 
        (bin-read ((bin-add bn.7) bn.1)) "8")
    (test-list-element "bin-add(bn.15)(bn.1)"
        (bin-read ((bin-add bn.15) bn.1)) "16")
    (test-list-element "bin-add(bn.127)(bn.1)"
        (bin-read ((bin-add bn.127) bn.1)) "128")

    ; scalability
    (test-list-element "bin-add(bn.1_000_000_000)(bn.1_000_000_000)"
        (bin-read ((bin-add bn.1_000_000_000) bn.1_000_000_000)) "2000000000")
    (test-list-element "bin-add(bn.1_000_000_000_000_000_000_000)(bn.1_000_000_000_000_000)" 
        (bin-read ((bin-add bn.1_000_000_000_000_000_000_000) bn.1_000_000_000_000_000)) "1000001000000000000000")
))

(show-results "bin-add" bin-add-tests)

; ====================================================================

(define bin-mult-tests (list 
    ; trivial cases
    (test-list-element "bin-mult(bn.0)(bn.0)" 
        (bin-read ((bin-mult bn.0) bn.0)) "0")
    (test-list-element "bin-mult(bn.1)(bn.0)" 
        (bin-read ((bin-mult bn.1) bn.0)) "0")
    (test-list-element "bin-mult(bn.0)(bn.1)" 
        (bin-read ((bin-mult bn.0) bn.1)) "0")
    (test-list-element "bin-mult(bn.1)(bn.1)" 
        (bin-read ((bin-mult bn.1) bn.1)) "1")

    ; small numbers
    (test-list-element "bin-mult(bn.2)(bn.1)" 
        (bin-read ((bin-mult bn.2) bn.1)) "2")
    (test-list-element "bin-mult(bn.3)(bn.2)" 
        (bin-read ((bin-mult bn.3) bn.2)) "6")
    (test-list-element "bin-mult(bn.4)(bn.3)" 
        (bin-read ((bin-mult bn.4) bn.3)) "12")
    (test-list-element "bin-mult(bn.5)(bn.2)" 
        (bin-read ((bin-mult bn.5) bn.2)) "10")
    (test-list-element "bin-mult(bn.5)(bn.3)" 
        (bin-read ((bin-mult bn.5) bn.3)) "15")

    ; large numbers
    (test-list-element "bin-mult(bn.7)(bn.5)" 
        (bin-read ((bin-mult bn.7) bn.5)) "35")
    (test-list-element "bin-mult(bn.15)(bn.15)" 
        (bin-read ((bin-mult bn.15) bn.15)) "225")
    (test-list-element "bin-mult(bn.4)(bn.3)" 
        (bin-read ((bin-mult bn.4) bn.3)) "12")
    (test-list-element "bin-mult(bn.31)(bn.16)" 
        (bin-read ((bin-mult bn.31) bn.16)) "496")

    ; uneven list lengths
    (test-list-element "bin-mult(bn.8)(bn.3)" 
        (bin-read ((bin-mult bn.8) bn.3)) "24")
    (test-list-element "bin-mult(bn.5)(bn.12)" 
        (bin-read ((bin-mult bn.5) bn.12)) "60")
    (test-list-element "bin-mult(bn.20)(bn.7)" 
        (bin-read ((bin-mult bn.20) bn.7)) "140")

    ; by powers of two
    (test-list-element "bin-mult(bn.2)(bn.2)" 
        (bin-read ((bin-mult bn.2) bn.2)) "4")
    (test-list-element "bin-mult(bn.4)(bn.4)" 
        (bin-read ((bin-mult bn.4) bn.4)) "16")
    (test-list-element "bin-mult(bn.8)(bn.8)" 
        (bin-read ((bin-mult bn.8) bn.8)) "64")
    (test-list-element "bin-mult(bn.32)(bn.4)" 
        (bin-read ((bin-mult bn.32) bn.4)) "128")

    ; even larger numbers
    (test-list-element "bin-mult(bn.1023)(bn.1023)" 
        (bin-read ((bin-mult bn.1023) bn.1023)) "1046529")
    (test-list-element "bin-mult(bn.1048)(bn.512)" 
        (bin-read ((bin-mult bn.1048) bn.512)) "1048576")
    (test-list-element "bin-mult(bn.131_072)(bn.65_536)" 
        (bin-read ((bin-mult bn.131_072) bn.65_536)) "8589934592")

    ; scalability
    (test-list-element "bin-mult(bn.1_000_000_000_000_000_000_000)(bn.1_000_000_000_000_000_000_000)" 
        (bin-read ((bin-mult bn.1_000_000_000_000_000_000_000) bn.1_000_000_000_000_000_000_000)) "1000000000000000000000000000000000000000000")
))

(show-results "bin-mult" bin-mult-tests)

; ====================================================================

(define bin-sub-tests (list
  ;; trivial cases
  (test-list-element "bin-sub(bn.0)(bn.0)"
    (bin-read ((bin-sub bn.0) bn.0)) "0")
  (test-list-element "bin-sub(bn.1)(bn.0)"
    (bin-read ((bin-sub bn.1) bn.0)) "1")
  (test-list-element "bin-sub(bn.2)(bn.0)"
    (bin-read ((bin-sub bn.2) bn.0)) "2")
  (test-list-element "bin-sub(bn.2)(bn.1)"
    (bin-read ((bin-sub bn.2) bn.1)) "1")

  ;; small numbers
  (test-list-element "bin-sub(bn.3)(bn.2)"
    (bin-read ((bin-sub bn.3) bn.2)) "1")
  (test-list-element "bin-sub(bn.4)(bn.1)"
    (bin-read ((bin-sub bn.4) bn.1)) "3")
  (test-list-element "bin-sub(bn.7)(bn.5)"
    (bin-read ((bin-sub bn.7) bn.5)) "2")
  (test-list-element "bin-sub(bn.6)(bn.3)"
    (bin-read ((bin-sub bn.6) bn.3)) "3")

  ;; large numbers
  (test-list-element "bin-sub(bn.32)(bn.1)"
    (bin-read ((bin-sub bn.32) bn.1)) "31")
  (test-list-element "bin-sub(bn.31)(bn.15)"
    (bin-read ((bin-sub bn.31) bn.15)) "16")
  (test-list-element "bin-sub(bn.512)(bn.512)"
    (bin-read ((bin-sub bn.512) bn.512)) "0")
  (test-list-element "bin-sub(bn.512)(bn.256)"
    (bin-read ((bin-sub bn.512) bn.256)) "256")

  ;; uneven list lengths
  (test-list-element "bin-sub(bn.9)(bn.1)"
    (bin-read ((bin-sub bn.9) bn.1)) "8")
  (test-list-element "bin-sub(bn.64)(bn.15)"
    (bin-read ((bin-sub bn.64) bn.15)) "49")
  (test-list-element "bin-sub(bn.128)(bn.7)"
    (bin-read ((bin-sub bn.128) bn.7)) "121")

  ;; borrow propagation
  (test-list-element "bin-sub(bn.5)(bn.1)"
    (bin-read ((bin-sub bn.5) bn.1)) "4")
  (test-list-element "bin-sub(bn.8)(bn.1)"
    (bin-read ((bin-sub bn.8) bn.1)) "7")
  (test-list-element "bin-sub(bn.15)(bn.1)"
    (bin-read ((bin-sub bn.15) bn.1)) "14")
  (test-list-element "bin-sub(bn.16)(bn.1)"
    (bin-read ((bin-sub bn.16) bn.1)) "15")

  ;; scalability
  (test-list-element "bin-sub(bn.2_000_000_000)(bn.1_000_000_000)"
    (bin-read ((bin-sub bn.2_000_000_000) bn.1_000_000_000)) "1000000000")
  (test-list-element "bin-sub(bn.1_000_000_000_000_000_000_003)(bn.1_000_000_000_000_000_000_000)"
    (bin-read ((bin-sub bn.1_000_000_000_000_000_000_003) bn.1_000_000_000_000_000_000_000)) "3")
))

(show-results "bin-sub" bin-sub-tests)

; ====================================================================

(define bin-gte-tests (list
    ;; trivial
    (test-list-element "bin-gte(bn.0)(bn.0)"
        (b-read ((bin-gte bn.0) bn.0))
        "true")
    (test-list-element "bin-gte(bn.0)(bn.1)"
        (b-read ((bin-gte bn.0) bn.1))
        "false")
    (test-list-element "bin-gte(bn.1)(bn.0)"
        (b-read ((bin-gte bn.1) bn.0))
        "true")

    ;; small
    (test-list-element "bin-gte(bn.2)(bn.3)"
        (b-read ((bin-gte bn.2) bn.3))
        "false")
    (test-list-element "bin-gte(bn.4)(bn.2)"
        (b-read ((bin-gte bn.4) bn.2))
        "true")
    (test-list-element "bin-gte(bn.4)(bn.7)"
        (b-read ((bin-gte bn.4) bn.7))
        "false")
    (test-list-element "bin-gte(bn.9)(bn.7)"
        (b-read ((bin-gte bn.9) bn.7))
        "true")
    (test-list-element "bin-gte(bn.10)(bn.12)"
        (b-read ((bin-gte bn.10) bn.12))
        "false")

    ;; large
    (test-list-element "bin-gte(bn.32)(bn.16)"
        (b-read ((bin-gte bn.32) bn.16))
        "true")
    (test-list-element "bin-gte(bn.32)(bn.64)"
        (b-read ((bin-gte bn.32) bn.64))
        "false")
    (test-list-element "bin-gte(bn.512)(bn.4)"
        (b-read ((bin-gte bn.512) bn.4))
        "true")

    ;; uneven
    (test-list-element "bin-gte(bn.12)(bn.9)"
        (b-read ((bin-gte bn.12) bn.9))
        "true")
    (test-list-element "bin-gte(bn.7)(bn.9)"
        (b-read ((bin-gte bn.7) bn.9))
        "false")

    ;; scalability
    (test-list-element "bin-gte(bn.1_000_000_000)(bn.2)"
        (b-read ((bin-gte bn.1_000_000_000) bn.2))
        "true")
    (test-list-element "bin-gte(bn.1_000_000_000)(bn.100_000)"
        (b-read ((bin-gte bn.1_000_000_000) bn.100_000))
        "true")
    (test-list-element "bin-gte(bn.1_000_000_000_000_000_000_000)(bn.1_000_000_000_000)"
        (b-read ((bin-gte bn.1_000_000_000_000_000_000_000) bn.1_000_000_000_000))
        "true")
    (test-list-element "bin-gte(bn.1_000_000_000)(bn.1_000_000_000_000_000_000_000)"
        (b-read ((bin-gte bn.1_000_000_000) bn.1_000_000_000_000_000_000_000))
        "false")
))

(show-results "bin-gte" bin-gte-tests)


; ====================================================================

(define bin-div-tests (list
    ; trivial zero cases
    (test-list-element "bin-div(bn.0)(bn.1)"
        (bin-read ((bin-div bn.0) bn.1)) "0")
    (test-list-element "bin-div(bn.1)(bn.0)"
        (bin-read ((bin-div bn.1) bn.0)) "0")
    (test-list-element "bin-div(bn.0)(bn.0)"
        (bin-read ((bin-div bn.0) bn.0)) "0")
    (test-list-element "bin-div(bn.1)(bn.2)"
        (bin-read ((bin-div bn.1) bn.2)) "0")
    (test-list-element "bin-div(bn.2)(bn.3)"
        (bin-read ((bin-div bn.2) bn.3)) "0")

    ; trivial cases
    (test-list-element "bin-div(bn.1)(bn.1)"
        (bin-read ((bin-div bn.1) bn.1)) "1")
    (test-list-element "bin-div(bn.2)(bn.1)"
        (bin-read ((bin-div bn.2) bn.1)) "2")

    ; small numbers
    (test-list-element "bin-div(bn.3)(bn.2)"
        (bin-read ((bin-div bn.3) bn.2)) "1")
    (test-list-element "bin-div(bn.4)(bn.2)"
        (bin-read ((bin-div bn.4) bn.2)) "2")
    (test-list-element "bin-div(bn.7)(bn.3)"
        (bin-read ((bin-div bn.7) bn.3)) "2")
    (test-list-element "bin-div(bn.9)(bn.3)"
        (bin-read ((bin-div bn.9) bn.3)) "3")

    ; large numbers
    (test-list-element "bin-div(bn.32)(bn.4)"
        (bin-read ((bin-div bn.32) bn.4)) "8")
    (test-list-element "bin-div(bn.32)(bn.8)"
        (bin-read ((bin-div bn.32) bn.8)) "4")
    (test-list-element "bin-div(bn.64)(bn.4)"
        (bin-read ((bin-div bn.64) bn.4)) "16")
    (test-list-element "bin-div(bn.512)(bn.4)"
        (bin-read ((bin-div bn.512) bn.4)) "128")

    ;; uneven list lengths
    (test-list-element "bin-div(bn.10)(bn.2)"
        (bin-read ((bin-div bn.10) bn.2)) "5")
    (test-list-element "bin-div(bn.12)(bn.3)"
        (bin-read ((bin-div bn.12) bn.3)) "4")
    (test-list-element "bin-div(bn.16)(bn.2)"
        (bin-read ((bin-div bn.16) bn.2)) "8")

    ; scalability
    (test-list-element "bin-div(bn.1_000_000_000)(bn.100_000)"
        (bin-read ((bin-div bn.1_000_000_000) bn.100_000)) "10000")
    (test-list-element "bin-div(bn.1_000_000_000_000_000_000_000)(bn.1_000_000_000_000)"
        (bin-read ((bin-div bn.1_000_000_000_000_000_000_000) bn.1_000_000_000_000)) "1000000000")
    (test-list-element "bin-div(bn.1000)(bn.1-two)"
        (bin-read ((bin-div bn.1000) bn.2)) "500")
    (test-list-element "bin-div(bn.1048)(bn.1-two)"
        (bin-read ((bin-div bn.1048) bn.2)) "1024")
    (test-list-element "bin-div(bn.1048)(bn.1-three)"
        (bin-read ((bin-div bn.1048) bn.3)) "682")

    (test-list-element "bin-div(bn.10_000)(bn.1-two)"
        (bin-read ((bin-div bn.10_000) bn.2)) "5000")
    (test-list-element "bin-div(bn.100_000)(bn.1-two)"
        (bin-read ((bin-div bn.100_000) bn.2)) "50000")
    (test-list-element "bin-div(bn.1_000_000_000_000)(bn.1-two)"
        (bin-read ((bin-div bn.1_000_000_000_000) bn.2)) "500000000000")
    (test-list-element "bin-div(bn.1_000_000_000_000_000_000_000)(bn.1-two)"
        (bin-read ((bin-div bn.1_000_000_000_000_000_000_000) bn.2)) "500000000000000000000")
))

(show-results "bin-div" bin-div-tests)
