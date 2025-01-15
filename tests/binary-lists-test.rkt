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

(define bin-sub-tests (list
  ;; trivial cases
  (test-list-element "bin-sub(bin-zero)(bin-zero)"
    (bin-read ((bin-sub bin-zero) bin-zero)) "0")
  (test-list-element "bin-sub(bin-one)(bin-zero)"
    (bin-read ((bin-sub bin-one) bin-zero)) "1")
  (test-list-element "bin-sub(bin-two)(bin-zero)"
    (bin-read ((bin-sub bin-two) bin-zero)) "2")
  (test-list-element "bin-sub(bin-two)(bin-one)"
    (bin-read ((bin-sub bin-two) bin-one)) "1")

  ;; small numbers
  (test-list-element "bin-sub(bin-three)(bin-two)"
    (bin-read ((bin-sub bin-three) bin-two)) "1")
  (test-list-element "bin-sub(bin-four)(bin-one)"
    (bin-read ((bin-sub bin-four) bin-one)) "3")
  (test-list-element "bin-sub(bin-seven)(bin-five)"
    (bin-read ((bin-sub bin-seven) bin-five)) "2")
  (test-list-element "bin-sub(bin-six)(bin-three)"
    (bin-read ((bin-sub bin-six) bin-three)) "3")

  ;; large numbers
  (test-list-element "bin-sub(bin-thirty-two)(bin-one)"
    (bin-read ((bin-sub bin-thirty-two) bin-one)) "31")
  (test-list-element "bin-sub(bin-thirty-one)(bin-fifteen)"
    (bin-read ((bin-sub bin-thirty-one) bin-fifteen)) "16")
  (test-list-element "bin-sub(bin-five-hundred-twelve)(bin-five-hundred-twelve)"
    (bin-read ((bin-sub bin-five-hundred-twelve) bin-five-hundred-twelve)) "0")
  (test-list-element "bin-sub(bin-five-hundred-twelve)(bin-two-hundred-fifty-six)"
    (bin-read ((bin-sub bin-five-hundred-twelve) bin-two-hundred-fifty-six)) "256")

  ;; uneven list lengths
  (test-list-element "bin-sub(bin-nine)(bin-one)"
    (bin-read ((bin-sub bin-nine) bin-one)) "8")
  (test-list-element "bin-sub(bin-sixty-four)(bin-fifteen)"
    (bin-read ((bin-sub bin-sixty-four) bin-fifteen)) "49")
  (test-list-element "bin-sub(bin-one-hundred-twenty-eight)(bin-seven)"
    (bin-read ((bin-sub bin-one-hundred-twenty-eight) bin-seven)) "121")

  ;; borrow propagation
  (test-list-element "bin-sub(bin-five)(bin-one)"
    (bin-read ((bin-sub bin-five) bin-one)) "4")
  (test-list-element "bin-sub(bin-eight)(bin-one)"
    (bin-read ((bin-sub bin-eight) bin-one)) "7")
  (test-list-element "bin-sub(bin-fifteen)(bin-one)"
    (bin-read ((bin-sub bin-fifteen) bin-one)) "14")
  (test-list-element "bin-sub(bin-sixteen)(bin-one)"
    (bin-read ((bin-sub bin-sixteen) bin-one)) "15")

  ;; scalability
  (test-list-element "bin-sub(bin-two-billion)(bin-one-billion)"
    (bin-read ((bin-sub bin-two-billion) bin-one-billion)) "1000000000")
  (test-list-element "bin-sub(bin-one-sextillion-and-three)(bin-one-sextillion)"
    (bin-read ((bin-sub bin-one-sextillion-and-three) bin-one-sextillion)) "3")
))

(show-results "bin-sub" bin-sub-tests)

; ====================================================================

(define bin-gte-tests (list
    ;; trivial
    (test-list-element "bin-gte(bin-zero)(bin-zero)"
        (b-read ((bin-gte bin-zero) bin-zero))
        "true")
    (test-list-element "bin-gte(bin-zero)(bin-one)"
        (b-read ((bin-gte bin-zero) bin-one))
        "false")
    (test-list-element "bin-gte(bin-one)(bin-zero)"
        (b-read ((bin-gte bin-one) bin-zero))
        "true")

    ;; small
    (test-list-element "bin-gte(bin-two)(bin-three)"
        (b-read ((bin-gte bin-two) bin-three))
        "false")
    (test-list-element "bin-gte(bin-four)(bin-two)"
        (b-read ((bin-gte bin-four) bin-two))
        "true")
    (test-list-element "bin-gte(bin-four)(bin-seven)"
        (b-read ((bin-gte bin-four) bin-seven))
        "false")
    (test-list-element "bin-gte(bin-nine)(bin-seven)"
        (b-read ((bin-gte bin-nine) bin-seven))
        "true")
    (test-list-element "bin-gte(bin-ten)(bin-twelve)"
        (b-read ((bin-gte bin-ten) bin-twelve))
        "false")

    ;; large
    (test-list-element "bin-gte(bin-thirty-two)(bin-sixteen)"
        (b-read ((bin-gte bin-thirty-two) bin-sixteen))
        "true")
    (test-list-element "bin-gte(bin-thirty-two)(bin-sixty-four)"
        (b-read ((bin-gte bin-thirty-two) bin-sixty-four))
        "false")
    (test-list-element "bin-gte(bin-five-hundred-twelve)(bin-four)"
        (b-read ((bin-gte bin-five-hundred-twelve) bin-four))
        "true")

    ;; uneven
    (test-list-element "bin-gte(bin-twelve)(bin-nine)"
        (b-read ((bin-gte bin-twelve) bin-nine))
        "true")
    (test-list-element "bin-gte(bin-seven)(bin-nine)"
        (b-read ((bin-gte bin-seven) bin-nine))
        "false")

    ;; scalability
    (test-list-element "bin-gte(bin-one-billion)(bin-one-hundred-thousand)"
        (b-read ((bin-gte bin-one-billion) bin-one-hundred-thousand))
        "true")
    (test-list-element "bin-gte(bin-one-sextillion)(bin-one-trillion)"
        (b-read ((bin-gte bin-one-sextillion) bin-one-trillion))
        "true")
    (test-list-element "bin-gte(bin-one-billion)(bin-one-sextillion)"
        (b-read ((bin-gte bin-one-billion) bin-one-sextillion))
        "false")
))

(show-results "bin-gte" bin-gte-tests)


; ====================================================================

(define bin-div-tests (list
    ; trivial zero cases
    (test-list-element "bin-div(bin-zero)(bin-one)"
        (bin-read ((bin-div bin-zero) bin-one)) "0")
    (test-list-element "bin-div(bin-one)(bin-zero)"
        (bin-read ((bin-div bin-one) bin-zero)) "0")
    (test-list-element "bin-div(bin-zero)(bin-zero)"
        (bin-read ((bin-div bin-zero) bin-zero)) "0")
    (test-list-element "bin-div(bin-one)(bin-two)"
        (bin-read ((bin-div bin-one) bin-two)) "0")
    (test-list-element "bin-div(bin-two)(bin-three)"
        (bin-read ((bin-div bin-two) bin-three)) "0")

    ; trivial cases
    (test-list-element "bin-div(bin-one)(bin-one)"
        (bin-read ((bin-div bin-one) bin-one)) "1")
    (test-list-element "bin-div(bin-two)(bin-one)"
        (bin-read ((bin-div bin-two) bin-one)) "2")

    ; small numbers
    (test-list-element "bin-div(bin-three)(bin-two)"
        (bin-read ((bin-div bin-three) bin-two)) "1")
    (test-list-element "bin-div(bin-four)(bin-two)"
        (bin-read ((bin-div bin-four) bin-two)) "2")
    (test-list-element "bin-div(bin-seven)(bin-three)"
        (bin-read ((bin-div bin-seven) bin-three)) "2")
    (test-list-element "bin-div(bin-nine)(bin-three)"
        (bin-read ((bin-div bin-nine) bin-three)) "3")

    ; large numbers
    (test-list-element "bin-div(bin-thirty-two)(bin-four)"
        (bin-read ((bin-div bin-thirty-two) bin-four)) "8")
    (test-list-element "bin-div(bin-thirty-two)(bin-eight)"
        (bin-read ((bin-div bin-thirty-two) bin-eight)) "4")
    (test-list-element "bin-div(bin-sixty-four)(bin-four)"
        (bin-read ((bin-div bin-sixty-four) bin-four)) "16")
    (test-list-element "bin-div(bin-five-hundred-twelve)(bin-four)"
        (bin-read ((bin-div bin-five-hundred-twelve) bin-four)) "128")

    ;; uneven list lengths
    (test-list-element "bin-div(bin-ten)(bin-two)"
        (bin-read ((bin-div bin-ten) bin-two)) "5")
    (test-list-element "bin-div(bin-twelve)(bin-three)"
        (bin-read ((bin-div bin-twelve) bin-three)) "4")
    (test-list-element "bin-div(bin-sixteen)(bin-two)"
        (bin-read ((bin-div bin-sixteen) bin-two)) "8")

    ; scalability
    (test-list-element "bin-div(bin-one-billion)(bin-one-hundred-thousand)"
        (bin-read ((bin-div bin-one-billion) bin-one-hundred-thousand)) "10000")
    (test-list-element "bin-div(bin-one-sextillion)(bin-one-trillion)"
        (bin-read ((bin-div bin-one-sextillion) bin-one-trillion)) "1000000000")
))

(show-results "bin-div" bin-div-tests)
