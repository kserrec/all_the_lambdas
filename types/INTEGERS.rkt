#lang lazy
(provide (all-defined-out))
(require "../church.rkt"
         "../integers.rkt"
         "../lists.rkt"
         "../logic.rkt"
         "../macros/macros.rkt")
(require "CHURCH.rkt"
         "LOGIC.rkt"
         "TYPES.rkt")

;===================================================

#|
    ~ READS INT TYPED VALUES ~
    - Contract: INT => READABLE(INT)
    - Idea: prepend "int:" to value
    - Note: extra logic needed because z-read prints strings or ints 
                depending on sign and zero can be signed either way
|#
(def _Z-READ Z = 
    (_if (is-int Z)
        _then (s-a "int:" (_if ((_or (head (val Z))) (isZero (tail (val Z))))
                            _then (n-s (z-read (val Z))) 
                            _else (z-read (val Z))))
        _else (err-read BOOL-ERROR)))

(def Z-READ Z = ((read-type _Z-READ) Z))

;===================================================

(def posZERO = (make-int posZero))

#|
    ~ SUCCESSOR ~
    - Contract: INT => INT
    - Idea: Z => Z+1
    - Logic: Returns successor of Z
|#
(def SUCCz Z = (((((type-n-check-f succZ) "SUCCz") int-type) int-type) Z))

;===================================================

(def negTHREE = (make-int negThree))
(def negTWO = (SUCCz negTHREE))
(def negONE = (SUCCz negTWO))
(def posONE = (SUCCz posZERO))
(def posTWO = (SUCCz posONE))
(def posTHREE = (SUCCz posTWO))
(def posFOUR = (SUCCz posTHREE))
(def posFIVE = (SUCCz posFOUR))

;===================================================

; ARITHMETIC

#|
    ~ ADDITION ~
    - Contract: (INT,INT) => INT
    - Idea: Z1,Z2 => Z1+Z2
|#
(def ADDz Z1 Z2 = (((((((type-n-check-f2 addZ) "ADDz") int-type) int-type) int-type) Z1) Z2))

#|
    ~ SUBTRACTION ~
    - Contract: (INT,INT) => INT
    - Idea: Z1,Z2 => Z1-Z2
|#
(def SUBz Z1 Z2 = (((((((type-n-check-f2 subZ) "SUBz") int-type) int-type) int-type) Z1) Z2))

#|
    ~ MULTIPLICATION ~
    - Contract: (INT,INT) => INT
    - Idea: Z1,Z2 => Z1*Z2
|#
(def MULTz Z1 Z2 = (((((((type-n-check-f2 multZ) "MULTz") int-type) int-type) int-type) Z1) Z2))

#|
    ~ DIVISION ~
    - Contract: (INT,INT) => INT
    - Idea: Z1,Z2 => Z1/Z2
|#
(def DIVz Z1 Z2 = (((((((type-n-check-f2 divZ) "DIVz") int-type) int-type) int-type) Z1) Z2))

#|
    ~ EXPONENTIATION ~
    - Contract: (INT,INT) => INT
    - Idea: Z1,Z2 => Z1^Z2
|#
(def EXPz Z1 Z2 = (((((((type-n-check-f2 expZ) "EXPz") int-type) int-type) int-type) Z1) Z2))


;===================================================

; EQUALITIES AND INEQUALITIES

#|
    ~ IS-ZERO ~
    - Contract: INT => BOOL
    - Logic: Check if (n part of z is zero)
                true, else false
|#
(def IS_ZEROz Z = (((((type-n-check-f isZeroZ) "IS_ZEROz") int-type) bool-type) Z))

#|
    ~ GREATER THAN OR EQUAL ~
    - Contract: (INT,INT) => BOOL
|#
(def GTEz Z1 Z2 = (((((((type-n-check-f2 gteZ) "GTEz") int-type) int-type) bool-type) Z1) Z2))

#|
    ~ LESS THAN OR EQUAL ~
    - Contract: (INT,INT) => BOOL
|#
(def LTEz Z1 Z2 = (((((((type-n-check-f2 lteZ) "LTEz") int-type) int-type) bool-type) Z1) Z2))

#|
    ~ EQUAL ~
    - Contract: (INT,INT) => BOOL
|#
(def EQz Z1 Z2 = (((((((type-n-check-f2 eqZ) "EQz") int-type) int-type) bool-type) Z1) Z2))

#|
    ~ GREATER THAN ~
    - Contract: (INT,INT) => BOOL
|#
(def GTz Z1 Z2 = (((((((type-n-check-f2 gtZ) "GTz") int-type) int-type) bool-type) Z1) Z2))

#|
    ~ LESS THAN ~
    - Contract: (INT,INT) => BOOL
|#
(def LTz Z1 Z2 = (((((((type-n-check-f2 ltZ) "LTz") int-type) int-type) bool-type) Z1) Z2))
