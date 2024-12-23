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

(def ZEROz = (makeInt zeroZ))

#|
    ~ SUCCESSOR ~
    - Contract: INT => INT
    - Idea: Z => Z+1
    - Logic: Returns successor of Z
|#
(def _SUCCz Z = (makeInt (succZ (val Z))))

(def SUCCz Z = ((((TYPE_CHECK _SUCCz) "SUCC_Z") intType) Z))

;===================================================

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
(def _ADDz Z1 Z2 = (makeInt ((addZ (val Z1)) (val Z2))))

(def ADDz Z1 Z2 = ((((((TYPE_CHECK2 _ADDz) "ADDz") intType) intType) Z1) Z2))

#|
    ~ SUBTRACTION ~
    - Contract: (INT,INT) => INT
    - Idea: Z1,Z2 => Z1-Z2
|#
(def _SUBz Z1 Z2 = (makeInt ((subZ (val Z1)) (val Z2))))

(def SUBz Z1 Z2 = ((((((TYPE_CHECK2 _SUBz) "SUBz") intType) intType) Z1) Z2))

#|
    ~ MULTIPLICATION ~
    - Contract: (INT,INT) => INT
    - Idea: Z1,Z2 => Z1*Z2
|#
(def _MULTz Z1 Z2 = (makeInt ((multZ (val Z1)) (val Z2))))

(def MULTz Z1 Z2 = ((((((TYPE_CHECK2 _MULTz) "MULTz") intType) intType) Z1) Z2))

#|
    ~ DIVISION ~
    - Contract: (INT,INT) => INT
    - Idea: Z1,Z2 => Z1/Z2
|#
(def _DIVz Z1 Z2 = (makeInt ((divZ (val Z1)) (val Z2))))

(def DIVz Z1 Z2 = ((((((TYPE_CHECK2 _DIVz) "DIVz") intType) intType) Z1) Z2))