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
    - Contract: INT => READ(INT)
    - Idea: prepend "int:" to value
    - Note: extra logic needed because z-read prints strings or ints 
                depending on sign and zero can be signed either way
|#
(def _Z-READ Z = 
    (_if (isInt Z)
        _then (s-a "int:" (_if ((_or (head (val Z))) (isZero (tail (val Z))))
                            _then (n-s (z-read (val Z))) 
                            _else (z-read (val Z))))
        _else (E-READ INT_ERROR)))

(def Z-READ Z = ((T-READ _Z-READ) Z))

;===================================================

(def ZEROz = (makeInt posZero))

#|
    ~ SUCCESSOR ~
    - Contract: INT => INT
    - Idea: Z => Z+1
    - Logic: Returns successor of Z
|#
(def SUCCz Z = (((((TYPE-N-CHECK-F succZ) "SUCCz") intType) intType) Z))

;===================================================

(def negTHREEz = (makeInt negThree))
(def negTWOz = (makeInt negTwo))
(def negONEz = (makeInt negOne))
(def ONEz = (SUCCz ZEROz))
(def TWOz = (SUCCz ONEz))
(def THREEz = (SUCCz TWOz))
(def FOURz = (SUCCz THREEz))
(def FIVEz = (SUCCz FOURz))

;===================================================

; ARITHMETIC

#|
    ~ ADDITION ~
    - Contract: (INT,INT) => INT
    - Idea: Z1,Z2 => Z1+Z2
|#
(def ADDz Z1 Z2 = (((((((TYPE-N-CHECK-F2 addZ) "ADDz") intType) intType) intType) Z1) Z2))

#|
    ~ SUBTRACTION ~
    - Contract: (INT,INT) => INT
    - Idea: Z1,Z2 => Z1-Z2
|#
(def SUBz Z1 Z2 = (((((((TYPE-N-CHECK-F2 subZ) "SUBz") intType) intType) intType) Z1) Z2))

#|
    ~ MULTIPLICATION ~
    - Contract: (INT,INT) => INT
    - Idea: Z1,Z2 => Z1*Z2
|#
(def MULTz Z1 Z2 = (((((((TYPE-N-CHECK-F2 multZ) "MULTz") intType) intType) intType) Z1) Z2))

#|
    ~ DIVISION ~
    - Contract: (INT,INT) => INT
    - Idea: Z1,Z2 => Z1/Z2
|#
(def DIVz Z1 Z2 = (((((((TYPE-N-CHECK-F2 divZ) "DIVz") intType) intType) intType) Z1) Z2))

#|
    ~ EXPONENTIATION ~
    - Contract: (INT,INT) => INT
    - Idea: Z1,Z2 => Z1^Z2
|#
(def EXPz Z1 Z2 = (((((((TYPE-N-CHECK-F2 expZ) "EXPz") intType) intType) intType) Z1) Z2))


;===================================================

; EQUALITIES AND INEQUALITIES

#|
    ~ IS-ZERO ~
    - Contract: INT => BOOL
    - Logic: Check if (n part of z is zero)
                true, else false
|#
(def IS_ZEROz Z = (((((TYPE-N-CHECK-F isZeroZ) "IS_ZEROz") intType) boolType) Z))

#|
    ~ GREATER THAN OR EQUAL ~
    - Contract: (INT,INT) => BOOL
|#
(def GTEz Z1 Z2 = (((((((TYPE-N-CHECK-F2 gteZ) "GTEz") intType) intType) boolType) Z1) Z2))

#|
    ~ LESS THAN OR EQUAL ~
    - Contract: (INT,INT) => BOOL
|#
(def LTEz Z1 Z2 = (((((((TYPE-N-CHECK-F2 lteZ) "LTEz") intType) intType) boolType) Z1) Z2))

#|
    ~ EQUAL ~
    - Contract: (INT,INT) => BOOL
|#
(def EQz Z1 Z2 = (((((((TYPE-N-CHECK-F2 eqZ) "EQz") intType) intType) boolType) Z1) Z2))

#|
    ~ GREATER THAN ~
    - Contract: (INT,INT) => BOOL
|#
(def GTz Z1 Z2 = (((((((TYPE-N-CHECK-F2 gtZ) "GTz") intType) intType) boolType) Z1) Z2))

#|
    ~ LESS THAN ~
    - Contract: (INT,INT) => BOOL
|#
(def LTz Z1 Z2 = (((((((TYPE-N-CHECK-F2 ltZ) "LTz") intType) intType) boolType) Z1) Z2))
