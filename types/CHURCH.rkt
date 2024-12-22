#lang lazy
(provide (all-defined-out))
(require "../church.rkt"
         "../logic.rkt"
         "../macros/macros.rkt")
(require "LOGIC.rkt"
         "TYPES.rkt")

;===================================================

#|
    ~ NAT OBJECTS ~
;   - Idea: Typed Church Numerals
|#

(def ZERO = (makeNat zero))
(def ONE = (makeNat one))
(def TWO = (makeNat two))
(def THREE = (makeNat three))
(def FOUR = (makeNat four))
(def FIVE = (makeNat five))

#|
    ~ SUCCESSOR ~
    - Contract: NAT => NAT
    - Idea: N => N+1
    - Logic: Returns successor of N
|#
(def _SUCC N = (makeNat (succ (val N))))

(def SUCC N = ((((ADD_TYPE_CHECK _SUCC) "SUCC") natType) N))

#|
    ~ READS NAT TYPED VALUES ~
    - Contract: NAT => READ(NAT)
|#
(def _N-READ N = 
    (_if (isNat N)
        _then (s-a "nat:" (n-s (n-read (val N))))
        _else (E-READ NAT_ERROR)))

(def N-READ N = ((T-READ _N-READ) N))

;===================================================

#|
    ~ IS ZERO
    - Contract: NAT => BOOL/ERROR
    - Logic: isZero function with type checking
|#
; (def _IS_ZERO N = 
;     (_if (isNat N)
;         _then (_if (isZero (val N))
;                 _then TRUE
;                 _else FALSE)
;         _else NAT_ERROR))

(def _IS_ZERO N = 
    (_if (isZero (val N))
        _then TRUE
        _else FALSE))

(def IS_ZERO N = ((((ADD_TYPE_CHECK _IS_ZERO) "IS_ZERO") natType) N))

;===================================================
; ARITHMETIC 

#|
    ~ ADDITION ~
    - Contract: (NAT,NAT) => NAT
    - Idea: M,N => M+N
|#
(def _ADD M N = (makeNat (((val M) succ) (val N))))

(def ADD M N = ((((((ADD_TYPE_CHECK2 _ADD) "ADD") natType) natType) M) N))

#|
    ~ MULTIPLICATION ~
    - Contract: (NAT,NAT) => NAT
    - Idea: M,N => M*N
|#
(def _MULT M N = (makeNat (((val N) (add (val M))) zero)))

(def MULT M N = ((((((ADD_TYPE_CHECK2 _MULT) "MULT") natType) natType) M) N))

#|
    ~ EXPONENTIATION ~
    - Contract: (NAT,NAT) => NAT
    - Idea: M,N => M^N
|#
(def _EXP M N = (makeNat (((val N) (mult (val M))) one)))

(def EXP M N = ((((((ADD_TYPE_CHECK2 _EXP) "EXP") natType) natType) M) N))

#|
    ~ PREDECESSOR ~
    - Contract: NAT => NAT
    - Idea:
        - if n is 0
            then => 0
            else => n-1
|#
(def _PRED N = (makeNat (pred (val N))))

(def PRED N = ((((ADD_TYPE_CHECK _PRED) "PRED") natType) N))


#|
    ~ SUBTRACTION ~
    - Contract: (NAT,NAT) => NAT
    - Idea: M,N => M-N
|#
(def _SUB M N = (makeNat (((val N) pred) (val M))))

(def SUB M N = ((((((ADD_TYPE_CHECK2 _SUB) "SUB") natType) natType) M) N))

;===================================================