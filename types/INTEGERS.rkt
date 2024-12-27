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
        _then (string-append "int:" (z-read (val Z)))
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
(def SUCCz Z = (((((fully-type succZ) "SUCCz") int) Z) int))

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
(def ADDz Z1 Z2 = (((((((fully-type2 addZ) "ADDz") int) Z1) int) Z2) int))

#|
    ~ SUBTRACTION ~
    - Contract: (INT,INT) => INT
    - Idea: Z1,Z2 => Z1-Z2
|#
(def SUBz Z1 Z2 = (((((((fully-type2 subZ) "SUBz") int) Z1) int) Z2) int))

#|
    ~ MULTIPLICATION ~
    - Contract: (INT,INT) => INT
    - Idea: Z1,Z2 => Z1*Z2
|#
(def MULTz Z1 Z2 = (((((((fully-type2 multZ) "MULTz") int) Z1) int) Z2) int))

#|
    ~ DIVISION ~
    - Contract: (INT,INT) => INT
    - Idea: Z1,Z2 => Z1/Z2
|#
(def DIVz Z1 Z2 = (((((((fully-type2 divZ) "DIVz") int) Z1) int) Z2) int))

#|
    ~ EXPONENTIATION ~
    - Contract: (INT,INT) => INT
    - Idea: Z1,Z2 => Z1^Z2
|#
(def EXPz Z1 Z2 = (((((((fully-type2 expZ) "EXPz") int) Z1) int) Z2) int))


;===================================================

; EQUALITIES AND INEQUALITIES

#|
    ~ IS-ZERO ~
    - Contract: INT => BOOL
    - Logic: Check if (n part of z is zero)
                true, else false
|#
(def IS_ZEROz Z = (((((fully-type isZeroZ) "IS_ZEROz") int) Z) bool))

#|
    ~ GREATER THAN OR EQUAL ~
    - Contract: (INT,INT) => BOOL
|#
(def GTEz Z1 Z2 = (((((((fully-type2 gteZ) "GTEz") int) Z1) int) Z2) bool))

#|
    ~ LESS THAN OR EQUAL ~
    - Contract: (INT,INT) => BOOL
|#
(def LTEz Z1 Z2 = (((((((fully-type2 lteZ) "LTEz") int) Z1) int) Z2) bool))

#|
    ~ EQUAL ~
    - Contract: (INT,INT) => BOOL
|#
(def EQz Z1 Z2 = (((((((fully-type2 eqZ) "EQz") int) Z1) int) Z2) bool))

#|
    ~ GREATER THAN ~
    - Contract: (INT,INT) => BOOL
|#
(def GTz Z1 Z2 = (((((((fully-type2 gtZ) "GTz") int) Z1) int) Z2) bool))

#|
    ~ LESS THAN ~
    - Contract: (INT,INT) => BOOL
|#
(def LTz Z1 Z2 = (((((((fully-type2 ltZ) "LTz") int) Z1) int) Z2) bool))
