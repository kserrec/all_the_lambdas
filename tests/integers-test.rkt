#lang s-exp "../macros/lazy-with-macros.rkt"
(require "../macros/macros.rkt")
(require "../integers.rkt"
         "../logic.rkt"
         "../church.rkt"
         "helpers/test-helpers.rkt")

; ====================================================================
; ~ INTEGERS TESTS ~
; ====================================================================

(define succZ-tests (list 
    (test-list-element "succZ(negThree)" (z-read (succZ negThree)) "-2")
    (test-list-element "succZ(negTwo)" (z-read (succZ negTwo)) "-1")
    (test-list-element "succZ(negOne)" (z-read (succZ negOne)) "0")
    (test-list-element "succZ(negZero)" (z-read (succZ negZero)) "1")
    (test-list-element "succZ(posZero)" (z-read (succZ posZero)) "1")
    (test-list-element "succZ(posOne)" (z-read (succZ posOne)) "2")
    (test-list-element "succZ(posTwo)" (z-read (succZ posTwo)) "3")
    (test-list-element "succZ(posThree)" (z-read (succZ posThree)) "4")
))

(show-results "succZ" succZ-tests)

; ====================================================================

(define addZ-tests (list 
    (test-list-element "addZ(negThree)(negTwo)" (z-read ((addZ negThree) negTwo)) "-5")
    (test-list-element "addZ(negThree)(posTwo)" (z-read ((addZ negThree) posTwo)) "-1")
    (test-list-element "addZ(negThree)(negZero)" (z-read ((addZ negThree) negZero)) "-3")
    (test-list-element "addZ(negThree)(posZero)" (z-read ((addZ negThree) posZero)) "-3")
    (test-list-element "addZ(negZero)(posZero)" (z-read ((addZ negZero) posZero)) "0")
    (test-list-element "addZ(posFour)(posTwo)" (z-read ((addZ posFour) posTwo)) "6")
    (test-list-element "addZ(negTwo)(posFive)" (z-read ((addZ negTwo) posFive)) "3")
))

(show-results "addZ" addZ-tests)

; ====================================================================

(define subZ-tests (list 
    (test-list-element "subZ(negThree)(negTwo)" (z-read ((subZ negThree) negTwo)) "-1")
    (test-list-element "subZ(negThree)(posTwo)" (z-read ((subZ negThree) posTwo)) "-5")
    (test-list-element "subZ(negThree)(negZero)" (z-read ((subZ negThree) negZero)) "-3")
    (test-list-element "subZ(negThree)(posZero)" (z-read ((subZ negThree) posZero)) "-3")
    (test-list-element "subZ(negZero)(posZero)" (z-read ((subZ negZero) posZero)) "0")
    (test-list-element "subZ(posFour)(posTwo)" (z-read ((subZ posFour) posTwo)) "2")
    (test-list-element "subZ(negTwo)(posFive)" (z-read ((subZ negTwo) posFive)) "-7")
))

(show-results "subZ" subZ-tests)

; ====================================================================

(define multZ-tests (list 
    (test-list-element "multZ(negThree)(negTwo)" (z-read ((multZ negThree) negTwo)) "6")
    (test-list-element "multZ(negThree)(posTwo)" (z-read ((multZ negThree) posTwo)) "-6")
    (test-list-element "multZ(negThree)(negZero)" (z-read ((multZ negThree) negZero)) "0")
    (test-list-element "multZ(negThree)(posZero)" (z-read ((multZ negThree) posZero)) "0")
    (test-list-element "multZ(negZero)(posZero)" (z-read ((multZ negZero) posZero)) "0")
    (test-list-element "multZ(posFour)(posTwo)" (z-read ((multZ posFour) posTwo)) "8")
    (test-list-element "multZ(negTwo)(posFive)" (z-read ((multZ negTwo) posFive)) "-10")
))

(show-results "multZ" multZ-tests)

; ====================================================================

(define divZ-tests (list 
    (test-list-element "divZ(negThree)(negTwo)" (z-read ((divZ negThree) negTwo)) "1")
    (test-list-element "divZ(negThree)(posTwo)" (z-read ((divZ negThree) posTwo)) "-1")
    (test-list-element "divZ(negZero)(posOne)" (z-read ((divZ negZero) posOne)) "0")
    (test-list-element "divZ(posFour)(posTwo)" (z-read ((divZ posFour) posTwo)) "2")
    (test-list-element "divZ(negTwo)(posFive)" (z-read ((divZ negTwo) posFive)) "0")
))

(show-results "divZ" divZ-tests)

; ====================================================================

(define expZ-tests (list
    (test-list-element "expZ(negThree)(negTwo)" (z-read ((expZ negThree) negTwo)) "0")
    (test-list-element "expZ(negThree)(posTwo)" (z-read ((expZ negThree) posTwo)) "9")
    (test-list-element "expZ(negZero)(posOne)" (z-read ((expZ negZero) posOne)) "0")
    (test-list-element "expZ(posFour)(posTwo)" (z-read ((expZ posFour) posTwo)) "16")
    (test-list-element "expZ(negTwo)(posFive)" (z-read ((expZ negTwo) posFive)) "-32")
))

(show-results "expZ" expZ-tests)

; ====================================================================

(define isZeroZ-tests (list
    (test-list-element "isZeroZ(negThree)" (b-read (isZeroZ negThree)) "false")
    (test-list-element "isZeroZ(posThree)" (b-read (isZeroZ posThree)) "false")
    (test-list-element "isZeroZ(negZero)" (b-read (isZeroZ negZero)) "true")
    (test-list-element "isZeroZ(posZero)" (b-read (isZeroZ posZero)) "true")
    (test-list-element "isZeroZ(posFour)" (b-read (isZeroZ posFour)) "false")
    (test-list-element "isZeroZ(negTwo)" (b-read (isZeroZ negTwo)) "false")
))

(show-results "isZeroZ" isZeroZ-tests)

; ====================================================================

(define gteZ-tests (list
    (test-list-element "gteZ(negThree)(negFour)" (b-read ((gteZ negThree) negFour)) "true")
    (test-list-element "gteZ(posThree)(negOne)" (b-read ((gteZ posThree) negOne)) "true")
    (test-list-element "gteZ(negZero)(posZero)" (b-read ((gteZ negZero) posZero)) "true")
    (test-list-element "gteZ(posZero)(posTwo)" (b-read ((gteZ posZero) posTwo)) "false")
    (test-list-element "gteZ(posZero)(negTwo)" (b-read ((gteZ posZero) negTwo)) "true")
    (test-list-element "gteZ(posFour)(posFive)" (b-read ((gteZ posFour) posFive)) "false")
))

(show-results "gteZ" gteZ-tests)

; ====================================================================

(define lteZ-tests (list
    (test-list-element "lteZ(negThree)(negFour)" (b-read ((lteZ negThree) negFour)) "false")
    (test-list-element "lteZ(posThree)(negOne)" (b-read ((lteZ posThree) negOne)) "false")
    (test-list-element "lteZ(negZero)(posZero)" (b-read ((lteZ negZero) posZero)) "true")
    (test-list-element "lteZ(posZero)(posTwo)" (b-read ((lteZ posZero) posTwo)) "true")
    (test-list-element "lteZ(posZero)(negTwo)" (b-read ((lteZ posZero) negTwo)) "false")
    (test-list-element "lteZ(posFour)(posFive)" (b-read ((lteZ posFour) posFive)) "true")
))

(show-results "lteZ" lteZ-tests)

; ====================================================================

(define eqZ-tests (list
    (test-list-element "eqZ(negThree)(negFour)" (b-read ((eqZ negThree) negFour)) "false")
    (test-list-element "eqZ(posThree)(negOne)" (b-read ((eqZ posThree) negOne)) "false")
    (test-list-element "eqZ(negZero)(posZero)" (b-read ((eqZ negZero) posZero)) "true")
    (test-list-element "eqZ(posZero)(posTwo)" (b-read ((eqZ posZero) posTwo)) "false")
    (test-list-element "eqZ(posTwo)(posTwo)" (b-read ((eqZ posTwo) posTwo)) "true")
    (test-list-element "eqZ(posZero)(negTwo)" (b-read ((eqZ posZero) negTwo)) "false")
    (test-list-element "eqZ(posFour)(posFive)" (b-read ((eqZ posFour) posFive)) "false")
))

(show-results "eqZ" eqZ-tests)

; ====================================================================

(define gtZ-tests (list
    (test-list-element "gtZ(negThree)(negFour)" (b-read ((gtZ negThree) negFour)) "true")
    (test-list-element "gtZ(posThree)(negOne)" (b-read ((gtZ posThree) negOne)) "true")
    (test-list-element "gtZ(negZero)(posZero)" (b-read ((gtZ negZero) posZero)) "false")
    (test-list-element "gtZ(posZero)(posTwo)" (b-read ((gtZ posZero) posTwo)) "false")
    (test-list-element "gtZ(posZero)(negTwo)" (b-read ((gtZ posZero) negTwo)) "true")
    (test-list-element "gtZ(posTwo)(posTwo)" (b-read ((gtZ posTwo) posTwo)) "false")
    (test-list-element "gtZ(posFour)(posFive)" (b-read ((gtZ posFour) posFive)) "false")
))

(show-results "gtZ" gtZ-tests)

; ====================================================================

(define ltZ-tests (list
    (test-list-element "ltZ(negThree)(negFour)" (b-read ((ltZ negThree) negFour)) "false")
    (test-list-element "ltZ(posThree)(negOne)" (b-read ((ltZ posThree) negOne)) "false")
    (test-list-element "ltZ(negZero)(posZero)" (b-read ((ltZ negZero) posZero)) "false")
    (test-list-element "ltZ(posZero)(posTwo)" (b-read ((ltZ posZero) posTwo)) "true")
    (test-list-element "ltZ(posZero)(negTwo)" (b-read ((ltZ posZero) negTwo)) "false")
    (test-list-element "ltZ(posTwo)(posTwo)" (b-read ((ltZ posTwo) posTwo)) "false")
    (test-list-element "ltZ(posFour)(posFive)" (b-read ((ltZ posFour) posFive)) "true")
))

(show-results "ltZ" ltZ-tests)