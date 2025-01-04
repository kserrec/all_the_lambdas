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
    ; trivial cases
    (test-list-element "bin-add(bin-zero)(bin-zero)"
        (bin-read ((bin-add bin-zero) bin-zero)) "0")
    (test-list-element "bin-add(bin-one)(bin-zero)"
        (bin-read ((bin-add bin-one) bin-zero)) "1")
    (test-list-element "bin-add(bin-zero)(bin-one)"
        (bin-read ((bin-add bin-one) bin-zero)) "1")
    (test-list-element "bin-add(bin-one)(bin-one)"
        (bin-read ((bin-add bin-one) bin-one)) "2")

    ; small numbers
    (test-list-element "bin-add(bin-two)(bin-three)"
        (bin-read ((bin-add bin-two) bin-three)) "5")
    (test-list-element "bin-add(bin-four)(bin-one)"
        (bin-read ((bin-add bin-four) bin-one)) "5")
    (test-list-element "bin-add(bin-six)(bin-two)"
        (bin-read ((bin-add bin-six) bin-two)) "8")
    (test-list-element "bin-add(bin-seven)(bin-five)"
        (bin-read ((bin-add bin-seven) bin-five)) "12")

    ; large numbers
    (test-list-element "bin-add(bin-fifteen)(bin-one)"
        (bin-read ((bin-add bin-fifteen) bin-one)) "16")
    (test-list-element "bin-add(bin-thirty-one)(bin-thirty-two)"
        (bin-read ((bin-add bin-thirty-one) bin-thirty-two)) "63")
    (test-list-element "bin-add(bin-five-hundred-twelve)(bin-five-hundred-twelve)"
        (bin-read ((bin-add bin-five-hundred-twelve) bin-five-hundred-twelve)) "1024")

    ; uneven list lengths
    (test-list-element "bin-add(bin-eight)(bin-one)"
        (bin-read ((bin-add bin-eight) bin-one)) "9")
    (test-list-element "bin-add(bin-sixty-four)(bin-fifteen)" 
        (bin-read ((bin-add bin-sixty-four) bin-fifteen)) "79")
    (test-list-element "bin-add(bin-one-hundred-twenty-eight)(bin-seven)"
        (bin-read ((bin-add bin-one-hundred-twenty-eight) bin-seven)) "135")

    ; carry propagation
    (test-list-element "bin-add(bin-three)(bin-one)"
        (bin-read ((bin-add bin-three) bin-one)) "4")
    (test-list-element "bin-add(bin-seven)(bin-one)" 
        (bin-read ((bin-add bin-seven) bin-one)) "8")
    (test-list-element "bin-add(bin-fifteen)(bin-one)"
        (bin-read ((bin-add bin-fifteen) bin-one)) "16")
    (test-list-element "bin-add(bin-one-hundred-twenty-seven)(bin-one)"
        (bin-read ((bin-add bin-one-hundred-twenty-seven) bin-one)) "128")

    ; scalability
    (test-list-element "bin-add(bin-one-billion)(bin-one-billion)"
        (bin-read ((bin-add bin-one-billion) bin-one-billion)) "2000000000")
    (test-list-element "bin-add(bin-one-sextillion)(bin-one-quadrillion)" 
        (bin-read ((bin-add bin-one-sextillion) bin-one-quadrillion)) "1000001000000000000000")
))

(show-results "bin-add" bin-add-tests)

; ====================================================================

(define bin-mult-tests (list 
    ; trivial cases
    (test-list-element "bin-mult(bin-zero)(bin-zero)" 
        (bin-read ((bin-mult bin-zero) bin-zero)) "0")
    (test-list-element "bin-mult(bin-one)(bin-zero)" 
        (bin-read ((bin-mult bin-one) bin-zero)) "0")
    (test-list-element "bin-mult(bin-zero)(bin-one)" 
        (bin-read ((bin-mult bin-zero) bin-one)) "0")
    (test-list-element "bin-mult(bin-one)(bin-one)" 
        (bin-read ((bin-mult bin-one) bin-one)) "1")

    ; small numbers
    (test-list-element "bin-mult(bin-two)(bin-one)" 
        (bin-read ((bin-mult bin-two) bin-one)) "2")
    (test-list-element "bin-mult(bin-three)(bin-two)" 
        (bin-read ((bin-mult bin-three) bin-two)) "6")
    (test-list-element "bin-mult(bin-four)(bin-three)" 
        (bin-read ((bin-mult bin-four) bin-three)) "12")
    (test-list-element "bin-mult(bin-five)(bin-two)" 
        (bin-read ((bin-mult bin-five) bin-two)) "10")
    (test-list-element "bin-mult(bin-five)(bin-three)" 
        (bin-read ((bin-mult bin-five) bin-three)) "15")

    ; large numbers
    (test-list-element "bin-mult(bin-seven)(bin-five)" 
        (bin-read ((bin-mult bin-seven) bin-five)) "35")
    (test-list-element "bin-mult(bin-fifteen)(bin-fifteen)" 
        (bin-read ((bin-mult bin-fifteen) bin-fifteen)) "225")
    (test-list-element "bin-mult(bin-four)(bin-three)" 
        (bin-read ((bin-mult bin-four) bin-three)) "12")
    (test-list-element "bin-mult(bin-thirty-one)(bin-sixteen)" 
        (bin-read ((bin-mult bin-thirty-one) bin-sixteen)) "496")

    ; uneven list lengths
    (test-list-element "bin-mult(bin-eight)(bin-three)" 
        (bin-read ((bin-mult bin-eight) bin-three)) "24")
    (test-list-element "bin-mult(bin-five)(bin-twelve)" 
        (bin-read ((bin-mult bin-five) bin-twelve)) "60")
    (test-list-element "bin-mult(bin-twenty)(bin-seven)" 
        (bin-read ((bin-mult bin-twenty) bin-seven)) "140")

    ; by powers of two
    (test-list-element "bin-mult(bin-two)(bin-two)" 
        (bin-read ((bin-mult bin-two) bin-two)) "4")
    (test-list-element "bin-mult(bin-four)(bin-four)" 
        (bin-read ((bin-mult bin-four) bin-four)) "16")
    (test-list-element "bin-mult(bin-eight)(bin-eight)" 
        (bin-read ((bin-mult bin-eight) bin-eight)) "64")
    (test-list-element "bin-mult(bin-thirty-two)(bin-four)" 
        (bin-read ((bin-mult bin-thirty-two) bin-four)) "128")

    ; even larger numbers
    (test-list-element "bin-mult(bin-one-k-twenty-three)(bin-one-k-twenty-three)" 
        (bin-read ((bin-mult bin-one-k-twenty-three) bin-one-k-twenty-three)) "1046529")
    (test-list-element "bin-mult(bin-two-k-forty-eight)(bin-five-hundred-twelve)" 
        (bin-read ((bin-mult bin-two-k-forty-eight) bin-five-hundred-twelve)) "1048576")
    (test-list-element "bin-mult(bin-one-hundred-thirty-one-k-seventy-two)(bin-sixty-five-k-five-hundred-thirty-six)" 
        (bin-read ((bin-mult bin-one-hundred-thirty-one-k-seventy-two) bin-sixty-five-k-five-hundred-thirty-six)) "8589934592")

    ; scalability
    (test-list-element "bin-mult(bin-one-sextillion)(bin-one-sextillion)" 
        (bin-read ((bin-mult bin-one-sextillion) bin-one-sextillion)) "1000000000000000000000000000000000000000000")
))

(show-results "bin-mult" bin-mult-tests)

; ====================================================================
