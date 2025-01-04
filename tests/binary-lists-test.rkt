#lang s-exp "../macros/lazy-with-macros.rkt"
(require "../macros/macros.rkt")
(require "../binary-lists.rkt"
         "../core.rkt"
         "../logic.rkt"
         "../church.rkt"
         "helpers/test-helpers.rkt")

; ====================================================================
; ~ BINARY LISTS TESTS ~
; ====================================================================

; define some big numbers for testing
(def bin-one-billion =
  (_cons one one one zero one one one zero 
         zero one one zero one zero one one 
         zero zero one zero one zero zero zero 
         zero zero zero zero zero zero)
)

(def bin-one-trillion = 
    (_cons one one one zero one zero zero zero one one zero one zero one zero zero one zero one zero zero one zero one zero zero zero one zero zero zero zero zero zero zero zero zero zero zero zero)
)

(def bin-one-quadrillion = 
    (_cons one one one zero zero zero one one zero one zero one one one one one one zero one zero one zero zero one zero zero one one zero zero zero one one zero one zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero)
)

(def bin-one-quintillion = 
    (_cons one one zero one one one one zero zero zero zero zero one zero one one zero one one zero one zero one one zero zero one one one zero one zero zero one one one zero one one zero zero one zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero)
)

(def bin-one-sextillion = 
    (_cons one one zero one one zero zero zero one one zero one zero one one one zero zero one zero zero one one zero one zero one one zero one one one zero zero zero one zero one one one zero one one one one zero one zero one zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero)
)

(define bin-read-tests (list 
    (test-list-element "bin-read(bin-zero)" (bin-read bin-zero) "0")
    (test-list-element "bin-read(bin-one)" (bin-read bin-one) "1")
    (test-list-element "bin-read(bin-two)" (bin-read bin-two) "2")
    (test-list-element "bin-read(bin-three)" (bin-read bin-three) "3")
    (test-list-element "bin-read(bin-four)" (bin-read bin-four) "4")
    (test-list-element "bin-read(bin-five)" (bin-read bin-five) "5")
    (test-list-element "bin-read(bin-ten)" (bin-read bin-ten) "10")
    (test-list-element "bin-read(bin-twenty)" (bin-read bin-twenty) "20")
    (test-list-element "bin-read(bin-twenty-four)" 
        (bin-read bin-twenty-four) "24")
    (test-list-element "bin-read(bin-one-billion)" 
        (bin-read bin-one-billion) "1000000000")
    (test-list-element "bin-read(bin-one-trillion)" 
        (bin-read bin-one-trillion) "1000000000000")
    (test-list-element "bin-read(bin-one-quadrillion)" 
        (bin-read bin-one-quadrillion) "1000000000000000")
    (test-list-element "bin-read(bin-one-quintillion)" 
        (bin-read bin-one-quintillion) "1000000000000000000")
    (test-list-element "bin-read(bin-one-sextillion)" 
        (bin-read bin-one-sextillion) "1000000000000000000000")
))

(show-results "bin-read" bin-read-tests)

; ====================================================================

(define bin-add-tests (list 
    (test-list-element "bin-read(bin-add(bin-zero)(bin-zero)" 
        (bin-read ((bin-add bin-zero) bin-zero)) "0")
    (test-list-element "bin-read(bin-add(bin-one)(bin-zero)" 
        (bin-read ((bin-add bin-one) bin-zero)) "1")
    (test-list-element "bin-read(bin-add(bin-zero)(bin-one)" 
        (bin-read ((bin-add bin-zero) bin-one)) "1")
    (test-list-element "bin-read(bin-add(bin-one)(bin-two)" 
        (bin-read ((bin-add bin-one) bin-two)) "3")
    (test-list-element "bin-read(bin-add(bin-two)(bin-three)" 
        (bin-read ((bin-add bin-two) bin-three)) "5")
    (test-list-element "bin-read(bin-add(bin-three)(bin-two)" 
        (bin-read ((bin-add bin-three) bin-two)) "5")
    (test-list-element "bin-read(bin-add(bin-ten)(bin-five)" 
        (bin-read ((bin-add bin-ten) bin-five)) "15")
    (test-list-element "bin-read(bin-add(bin-five)(bin-two)" 
        (bin-read ((bin-add bin-five) bin-two)) "7")
    (test-list-element "bin-read(bin-add(bin-twenty-four)(bin-one)" 
        (bin-read ((bin-add bin-twenty-four) bin-one)) "25")
    (test-list-element "bin-read(bin-add(bin-one-billion)(bin-ten)" 
        (bin-read ((bin-add bin-one-billion) bin-ten)) "1000000010")
))

(show-results "bin-add" bin-add-tests)

; ====================================================================

(define bin-mult-tests (list 
    (test-list-element "bin-read(bin-mult(bin-zero)(bin-zero)" 
        (bin-read ((bin-mult bin-zero) bin-zero)) "0")
    (test-list-element "bin-read(bin-mult(bin-one)(bin-zero)" 
        (bin-read ((bin-mult bin-one) bin-zero)) "0")
    (test-list-element "bin-read(bin-mult(bin-zero)(bin-one)" 
        (bin-read ((bin-mult bin-zero) bin-one)) "0")
    (test-list-element "bin-read(bin-mult(bin-one)(bin-two)" 
        (bin-read ((bin-mult bin-one) bin-two)) "2")
    (test-list-element "bin-read(bin-mult(bin-two)(bin-three)" 
        (bin-read ((bin-mult bin-two) bin-three)) "6")
    (test-list-element "bin-read(bin-mult(bin-three)(bin-two)" 
        (bin-read ((bin-mult bin-three) bin-two)) "6")
    (test-list-element "bin-read(bin-mult(bin-ten)(bin-five)" 
        (bin-read ((bin-mult bin-ten) bin-five)) "50")
    (test-list-element "bin-read(bin-mult(bin-five)(bin-two)" 
        (bin-read ((bin-mult bin-five) bin-two)) "10")
    (test-list-element "bin-read(bin-mult(bin-twenty-four)(bin-one)" 
        (bin-read ((bin-mult bin-twenty-four) bin-one)) "24")
    (test-list-element "bin-read(bin-mult(bin-one-billion)(bin-ten)" 
        (bin-read ((bin-mult bin-one-billion) bin-ten)) "10000000000")
))

(show-results "bin-mult" bin-mult-tests)

; ====================================================================
