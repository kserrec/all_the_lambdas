#lang s-exp "../macros/lazy-with-macros.rkt"
(require "../macros/macros.rkt")
(require "../int-binary-lists.rkt"
         "../binary-lists.rkt"
         "../core.rkt"
         "../logic.rkt"
         "../church.rkt"
         "helpers/test-helpers.rkt")

; ====================================================================
; ~ INTEGER BINARY LISTS TESTS ~
; ====================================================================

(define bin-z-read-tests (list
    (test-list-element "bin-z-read(bin-posZero)" (bin-z-read bin-posZero) "0")
    (test-list-element "bin-z-read(bin-negZero)" (bin-z-read bin-negZero) "0")
    (test-list-element "bin-z-read(bin-posOne)" (bin-z-read bin-posOne) "1")
    (test-list-element "bin-z-read(bin-posThree)" (bin-z-read bin-posThree) "3")
    (test-list-element "bin-z-read(bin-posFive)" (bin-z-read bin-posFive) "5")
    (test-list-element "bin-z-read(bin-negOne)" (bin-z-read bin-negOne) "-1")
    (test-list-element "bin-z-read(bin-negTwo)" (bin-z-read bin-negTwo) "-2")
    (test-list-element "bin-z-read(bin-negThree)" (bin-z-read bin-negThree) "-3")
    (test-list-element "bin-z-read(bin-negFour)" (bin-z-read bin-negFour) "-4")
    (test-list-element "bin-z-read(bin-negFive)" (bin-z-read bin-negFive) "-5")
))

(show-results "bin-z-read" bin-z-read-tests)

; ====================================================================

(define succZ-bin-tests (list
    (test-list-element "succZ-bin(bin-posZero)"
        (bin-z-read (succZ-bin bin-posZero)) "1")
    (test-list-element "succZ-bin(bin-negZero)"
        (bin-z-read (succZ-bin bin-negZero)) "1")
    (test-list-element "succZ-bin(bin-posOne)"
        (bin-z-read (succZ-bin bin-posOne)) "2")
    (test-list-element "succZ-bin(bin-negOne)"
        (bin-z-read (succZ-bin bin-negOne)) "0")
    (test-list-element "succZ-bin(bin-negThree)"
        (bin-z-read (succZ-bin bin-negThree)) "-2")
))

(show-results "succZ-bin" succZ-bin-tests)

; ====================================================================

(define predZ-bin-tests (list
    (test-list-element "predZ-bin(bin-posZero)"
        (bin-z-read (predZ-bin bin-posZero)) "-1")
    (test-list-element "predZ-bin(bin-posOne)"
        (bin-z-read (predZ-bin bin-posOne)) "0")
    (test-list-element "predZ-bin(bin-negOne)"
        (bin-z-read (predZ-bin bin-negOne)) "-2")
    (test-list-element "predZ-bin(bin-posFive)"
        (bin-z-read (predZ-bin bin-posFive)) "4")
))

(show-results "predZ-bin" predZ-bin-tests)

; ====================================================================

(define invertZ-bin-tests (list
    (test-list-element "invertZ-bin(bin-posOne)"
        (bin-z-read (invertZ-bin bin-posOne)) "-1")
    (test-list-element "invertZ-bin(bin-negThree)"
        (bin-z-read (invertZ-bin bin-negThree)) "3")
    (test-list-element "invertZ-bin(bin-posZero)"
        (bin-z-read (invertZ-bin bin-posZero)) "0")
))

(show-results "invertZ-bin" invertZ-bin-tests)

; ====================================================================

(define addZ-bin-tests (list
    (test-list-element "addZ-bin(bin-posZero)(bin-posZero)"
        (bin-z-read ((addZ-bin bin-posZero) bin-posZero)) "0")
    (test-list-element "addZ-bin(bin-posOne)(bin-posZero)"
        (bin-z-read ((addZ-bin bin-posOne) bin-posZero)) "1")
    (test-list-element "addZ-bin(bin-posZero)(bin-posOne)"
        (bin-z-read ((addZ-bin bin-posZero) bin-posOne)) "1")
    (test-list-element "addZ-bin(bin-posOne)(bin-posOne)"
        (bin-z-read ((addZ-bin bin-posOne) bin-posOne)) "2")
    (test-list-element "addZ-bin(bin-posTwo)(bin-posThree)"
        (bin-z-read ((addZ-bin bin-posTwo) bin-posThree)) "5")
    (test-list-element "addZ-bin(bin-posFour)(bin-posOne)"
        (bin-z-read ((addZ-bin bin-posFour) bin-posOne)) "5")
    (test-list-element "addZ-bin(bin-negOne)(bin-negOne)"
        (bin-z-read ((addZ-bin bin-negOne) bin-negOne)) "-2")
    (test-list-element "addZ-bin(bin-negTwo)(bin-negThree)"
        (bin-z-read ((addZ-bin bin-negTwo) bin-negThree)) "-5")
    (test-list-element "addZ-bin(bin-negFour)(bin-negOne)"
        (bin-z-read ((addZ-bin bin-negFour) bin-negOne)) "-5")
    (test-list-element "addZ-bin(bin-posFive)(bin-negFive)"
        (bin-z-read ((addZ-bin bin-posFive) bin-negFive)) "0")
    (test-list-element "addZ-bin(bin-negFive)(bin-posFive)"
        (bin-z-read ((addZ-bin bin-negFive) bin-posFive)) "0")
    (test-list-element "addZ-bin(bin-posThree)(bin-negTwo)"
        (bin-z-read ((addZ-bin bin-posThree) bin-negTwo)) "1")
    (test-list-element "addZ-bin(bin-negThree)(bin-posTwo)"
        (bin-z-read ((addZ-bin bin-negThree) bin-posTwo)) "-1")
    (test-list-element "addZ-bin(bin-posFive)(bin-posFive)"
        (bin-z-read ((addZ-bin bin-posFive) bin-posFive)) "10")
    (test-list-element "addZ-bin(bin-negFive)(bin-negFive)"
        (bin-z-read ((addZ-bin bin-negFive) bin-negFive)) "-10")

    ; scalability
    (test-list-element "addZ-bin(+bin-one-billion)(bin-negOne)"
        (bin-z-read ((addZ-bin ((makeZ-bin true) bin-one-billion)) bin-negOne)) "999999999")
    (test-list-element "addZ-bin(-bin-one-billion)(-bin-one-billion)"
        (bin-z-read ((addZ-bin ((makeZ-bin false) bin-one-billion)) ((makeZ-bin false) bin-one-billion))) "-2000000000")
))

(show-results "addZ-bin" addZ-bin-tests)

; ====================================================================

(define subZ-bin-tests (list
    (test-list-element "subZ-bin(bin-posZero)(bin-posZero)"
        (bin-z-read ((subZ-bin bin-posZero) bin-posZero)) "0")
    (test-list-element "subZ-bin(bin-posOne)(bin-posZero)"
        (bin-z-read ((subZ-bin bin-posOne) bin-posZero)) "1")
    (test-list-element "subZ-bin(bin-posZero)(bin-posOne)"
        (bin-z-read ((subZ-bin bin-posZero) bin-posOne)) "-1")
    (test-list-element "subZ-bin(bin-posOne)(bin-posOne)"
        (bin-z-read ((subZ-bin bin-posOne) bin-posOne)) "0")
    (test-list-element "subZ-bin(bin-posTwo)(bin-posThree)"
        (bin-z-read ((subZ-bin bin-posTwo) bin-posThree)) "-1")
    (test-list-element "subZ-bin(bin-posFour)(bin-posOne)"
        (bin-z-read ((subZ-bin bin-posFour) bin-posOne)) "3")
    (test-list-element "subZ-bin(bin-negOne)(bin-negOne)"
        (bin-z-read ((subZ-bin bin-negOne) bin-negOne)) "0")
    (test-list-element "subZ-bin(bin-negTwo)(bin-negThree)"
        (bin-z-read ((subZ-bin bin-negTwo) bin-negThree)) "1")
    (test-list-element "subZ-bin(bin-negFour)(bin-negOne)"
        (bin-z-read ((subZ-bin bin-negFour) bin-negOne)) "-3")
    (test-list-element "subZ-bin(bin-posFive)(bin-negFive)"
        (bin-z-read ((subZ-bin bin-posFive) bin-negFive)) "10")
    (test-list-element "subZ-bin(bin-negFive)(bin-posFive)"
        (bin-z-read ((subZ-bin bin-negFive) bin-posFive)) "-10")
    (test-list-element "subZ-bin(bin-posThree)(bin-negTwo)"
        (bin-z-read ((subZ-bin bin-posThree) bin-negTwo)) "5")
    (test-list-element "subZ-bin(bin-negThree)(bin-posTwo)"
        (bin-z-read ((subZ-bin bin-negThree) bin-posTwo)) "-5")
    (test-list-element "subZ-bin(bin-posFive)(bin-posFive)"
        (bin-z-read ((subZ-bin bin-posFive) bin-posFive)) "0")
    (test-list-element "subZ-bin(bin-negFive)(bin-negFive)"
        (bin-z-read ((subZ-bin bin-negFive) bin-negFive)) "0")
))

(show-results "subZ-bin" subZ-bin-tests)

; ====================================================================

(define multZ-bin-tests (list
    (test-list-element "multZ-bin(bin-posZero)(bin-posZero)"
        (bin-z-read ((multZ-bin bin-posZero) bin-posZero)) "0")
    (test-list-element "multZ-bin(bin-posOne)(bin-posZero)"
        (bin-z-read ((multZ-bin bin-posOne) bin-posZero)) "0")
    (test-list-element "multZ-bin(bin-negOne)(bin-posZero)"
        (bin-z-read ((multZ-bin bin-negOne) bin-posZero)) "0")
    (test-list-element "multZ-bin(bin-posOne)(bin-posOne)"
        (bin-z-read ((multZ-bin bin-posOne) bin-posOne)) "1")
    (test-list-element "multZ-bin(bin-posTwo)(bin-posThree)"
        (bin-z-read ((multZ-bin bin-posTwo) bin-posThree)) "6")
    (test-list-element "multZ-bin(bin-posFour)(bin-posOne)"
        (bin-z-read ((multZ-bin bin-posFour) bin-posOne)) "4")
    (test-list-element "multZ-bin(bin-negOne)(bin-negOne)"
        (bin-z-read ((multZ-bin bin-negOne) bin-negOne)) "1")
    (test-list-element "multZ-bin(bin-negTwo)(bin-negThree)"
        (bin-z-read ((multZ-bin bin-negTwo) bin-negThree)) "6")
    (test-list-element "multZ-bin(bin-negFour)(bin-negOne)"
        (bin-z-read ((multZ-bin bin-negFour) bin-negOne)) "4")
    (test-list-element "multZ-bin(bin-posFive)(bin-negFive)"
        (bin-z-read ((multZ-bin bin-posFive) bin-negFive)) "-25")
    (test-list-element "multZ-bin(bin-negFive)(bin-posFive)"
        (bin-z-read ((multZ-bin bin-negFive) bin-posFive)) "-25")
    (test-list-element "multZ-bin(bin-posThree)(bin-negTwo)"
        (bin-z-read ((multZ-bin bin-posThree) bin-negTwo)) "-6")
    (test-list-element "multZ-bin(bin-negThree)(bin-posTwo)"
        (bin-z-read ((multZ-bin bin-negThree) bin-posTwo)) "-6")
    (test-list-element "multZ-bin(bin-posFive)(bin-posFive)"
        (bin-z-read ((multZ-bin bin-posFive) bin-posFive)) "25")
    (test-list-element "multZ-bin(bin-negFive)(bin-negFive)"
        (bin-z-read ((multZ-bin bin-negFive) bin-negFive)) "25")

    ; scalability
    (test-list-element "multZ-bin(-bin-one-billion)(+bin-two)"
        (bin-z-read ((multZ-bin ((makeZ-bin false) bin-one-billion)) bin-posTwo)) "-2000000000")
))

(show-results "multZ-bin" multZ-bin-tests)

; ====================================================================

(define divZ-bin-tests (list
    (test-list-element "divZ-bin(bin-posZero)(bin-posOne)"
        (bin-z-read ((divZ-bin bin-posZero) bin-posOne)) "0")
    (test-list-element "divZ-bin(bin-posOne)(bin-posOne)"
        (bin-z-read ((divZ-bin bin-posOne) bin-posOne)) "1")
    (test-list-element "divZ-bin(bin-posTwo)(bin-posThree)"
        (bin-z-read ((divZ-bin bin-posTwo) bin-posThree)) "0")
    (test-list-element "divZ-bin(bin-posFour)(bin-posOne)"
        (bin-z-read ((divZ-bin bin-posFour) bin-posOne)) "4")
    (test-list-element "divZ-bin(bin-negOne)(bin-negOne)"
        (bin-z-read ((divZ-bin bin-negOne) bin-negOne)) "1")
    (test-list-element "divZ-bin(bin-negTwo)(bin-negThree)"
        (bin-z-read ((divZ-bin bin-negTwo) bin-negThree)) "0")
    (test-list-element "divZ-bin(bin-negFour)(bin-negOne)"
        (bin-z-read ((divZ-bin bin-negFour) bin-negOne)) "4")
    (test-list-element "divZ-bin(bin-posFive)(bin-negFive)"
        (bin-z-read ((divZ-bin bin-posFive) bin-negFive)) "-1")
    (test-list-element "divZ-bin(bin-negFive)(bin-posFive)"
        (bin-z-read ((divZ-bin bin-negFive) bin-posFive)) "-1")
    ; truncation is toward zero: -3/2 => -1
    (test-list-element "divZ-bin(bin-posThree)(bin-negTwo)"
        (bin-z-read ((divZ-bin bin-posThree) bin-negTwo)) "-1")
    (test-list-element "divZ-bin(bin-negThree)(bin-posTwo)"
        (bin-z-read ((divZ-bin bin-negThree) bin-posTwo)) "-1")
    (test-list-element "divZ-bin(bin-posFive)(bin-posFive)"
        (bin-z-read ((divZ-bin bin-posFive) bin-posFive)) "1")
    (test-list-element "divZ-bin(bin-negFive)(bin-negFive)"
        (bin-z-read ((divZ-bin bin-negFive) bin-negFive)) "1")
))

(show-results "divZ-bin" divZ-bin-tests)

; ====================================================================

(define expZ-bin-tests (list
    ; anything to the zero is one
    (test-list-element "expZ-bin(bin-posTwo)(bin-posZero)"
        (bin-z-read ((expZ-bin bin-posTwo) bin-posZero)) "1")
    (test-list-element "expZ-bin(bin-negTwo)(bin-posZero)"
        (bin-z-read ((expZ-bin bin-negTwo) bin-posZero)) "1")
    ; negative exponents default to zero
    (test-list-element "expZ-bin(bin-posTwo)(bin-negTwo)"
        (bin-z-read ((expZ-bin bin-posTwo) bin-negTwo)) "0")
    ; positive base
    (test-list-element "expZ-bin(bin-posTwo)(bin-posThree)"
        (bin-z-read ((expZ-bin bin-posTwo) bin-posThree)) "8")
    (test-list-element "expZ-bin(bin-posThree)(bin-posFour)"
        (bin-z-read ((expZ-bin bin-posThree) bin-posFour)) "81")
    ; negative base: sign follows parity of exponent
    (test-list-element "expZ-bin(bin-negTwo)(bin-posTwo)"
        (bin-z-read ((expZ-bin bin-negTwo) bin-posTwo)) "4")
    (test-list-element "expZ-bin(bin-negTwo)(bin-posThree)"
        (bin-z-read ((expZ-bin bin-negTwo) bin-posThree)) "-8")
    (test-list-element "expZ-bin(bin-negThree)(bin-posTwo)"
        (bin-z-read ((expZ-bin bin-negThree) bin-posTwo)) "9")
))

(show-results "expZ-bin" expZ-bin-tests)

; ====================================================================

(define z-bin-compare-tests (list
    ; isZeroZ-bin
    (test-list-element "isZeroZ-bin(bin-posZero)"
        (b-read (isZeroZ-bin bin-posZero)) "true")
    (test-list-element "isZeroZ-bin(bin-negZero)"
        (b-read (isZeroZ-bin bin-negZero)) "true")
    (test-list-element "isZeroZ-bin(bin-posOne)"
        (b-read (isZeroZ-bin bin-posOne)) "false")
    (test-list-element "isZeroZ-bin(bin-negOne)"
        (b-read (isZeroZ-bin bin-negOne)) "false")

    ; gteZ-bin
    (test-list-element "gteZ-bin(bin-posTwo)(bin-posOne)"
        (b-read ((gteZ-bin bin-posTwo) bin-posOne)) "true")
    (test-list-element "gteZ-bin(bin-negOne)(bin-negTwo)"
        (b-read ((gteZ-bin bin-negOne) bin-negTwo)) "true")
    (test-list-element "gteZ-bin(bin-negTwo)(bin-negOne)"
        (b-read ((gteZ-bin bin-negTwo) bin-negOne)) "false")
    (test-list-element "gteZ-bin(bin-posOne)(bin-negFive)"
        (b-read ((gteZ-bin bin-posOne) bin-negFive)) "true")
    (test-list-element "gteZ-bin(bin-negFive)(bin-posOne)"
        (b-read ((gteZ-bin bin-negFive) bin-posOne)) "false")
    (test-list-element "gteZ-bin(bin-posZero)(bin-negZero)"
        (b-read ((gteZ-bin bin-posZero) bin-negZero)) "true")
    (test-list-element "gteZ-bin(bin-negZero)(bin-posZero)"
        (b-read ((gteZ-bin bin-negZero) bin-posZero)) "true")

    ; lteZ-bin
    (test-list-element "lteZ-bin(bin-posOne)(bin-posTwo)"
        (b-read ((lteZ-bin bin-posOne) bin-posTwo)) "true")
    (test-list-element "lteZ-bin(bin-negTwo)(bin-negOne)"
        (b-read ((lteZ-bin bin-negTwo) bin-negOne)) "true")
    (test-list-element "lteZ-bin(bin-negOne)(bin-negTwo)"
        (b-read ((lteZ-bin bin-negOne) bin-negTwo)) "false")
    (test-list-element "lteZ-bin(bin-negFive)(bin-posOne)"
        (b-read ((lteZ-bin bin-negFive) bin-posOne)) "true")

    ; eqZ-bin
    (test-list-element "eqZ-bin(bin-posThree)(bin-posThree)"
        (b-read ((eqZ-bin bin-posThree) bin-posThree)) "true")
    (test-list-element "eqZ-bin(bin-negThree)(bin-negThree)"
        (b-read ((eqZ-bin bin-negThree) bin-negThree)) "true")
    (test-list-element "eqZ-bin(bin-posThree)(bin-negThree)"
        (b-read ((eqZ-bin bin-posThree) bin-negThree)) "false")
    (test-list-element "eqZ-bin(bin-posZero)(bin-negZero)"
        (b-read ((eqZ-bin bin-posZero) bin-negZero)) "true")

    ; gtZ-bin / ltZ-bin
    (test-list-element "gtZ-bin(bin-posTwo)(bin-posOne)"
        (b-read ((gtZ-bin bin-posTwo) bin-posOne)) "true")
    (test-list-element "gtZ-bin(bin-posTwo)(bin-posTwo)"
        (b-read ((gtZ-bin bin-posTwo) bin-posTwo)) "false")
    (test-list-element "ltZ-bin(bin-negTwo)(bin-negOne)"
        (b-read ((ltZ-bin bin-negTwo) bin-negOne)) "true")
    (test-list-element "ltZ-bin(bin-negOne)(bin-negOne)"
        (b-read ((ltZ-bin bin-negOne) bin-negOne)) "false")
))

(show-results "z-bin comparisons" z-bin-compare-tests)

; ====================================================================

(define z-bin-misc-tests (list
    ; absValZ-bin
    (test-list-element "absValZ-bin(bin-negFive)"
        (bin-z-read (absValZ-bin bin-negFive)) "5")
    (test-list-element "absValZ-bin(bin-posFive)"
        (bin-z-read (absValZ-bin bin-posFive)) "5")
    (test-list-element "absValZ-bin(bin-negZero)"
        (bin-z-read (absValZ-bin bin-negZero)) "0")

    ; parity ignores sign
    (test-list-element "isEvenZ-bin(bin-negFour)"
        (b-read (isEvenZ-bin bin-negFour)) "true")
    (test-list-element "isEvenZ-bin(bin-posThree)"
        (b-read (isEvenZ-bin bin-posThree)) "false")
    (test-list-element "isOddZ-bin(bin-negThree)"
        (b-read (isOddZ-bin bin-negThree)) "true")
    (test-list-element "isOddZ-bin(bin-posZero)"
        (b-read (isOddZ-bin bin-posZero)) "false")
))

(show-results "z-bin absVal/parity" z-bin-misc-tests)
