#lang lazy
(provide (all-defined-out))
(require "../church.rkt"
         "../division.rkt"
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

(def SUCC N = ((((TYPE_CHECK _SUCC) "SUCC") natType) N))

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
(def IS_ZERO N = (((((TYPE-N-CHECK-F isZero) "IS_ZERO") natType) boolType) N))

;===================================================

; ARITHMETIC 

#|
    ~ ADDITION ~
    - Contract: (NAT,NAT) => NAT
    - Idea: M,N => M+N
|#
(def ADD M N = (((((((TYPE-N-CHECK-F2 add) "ADD") natType) natType) natType) M) N))

#|
    ~ MULTIPLICATION ~
    - Contract: (NAT,NAT) => NAT
    - Idea: M,N => M*N
|#
(def MULT M N = (((((((TYPE-N-CHECK-F2 mult) "MULT") natType) natType) natType) M) N))

#|
    ~ EXPONENTIATION ~
    - Contract: (NAT,NAT) => NAT
    - Idea: M,N => M^N
|#
(def EXP M N = (((((((TYPE-N-CHECK-F2 _exp) "EXP") natType) natType) natType) M) N))

#|
    ~ PREDECESSOR ~
    - Contract: NAT => NAT
    - Idea:
        - if n is 0
            then => 0
            else => n-1
|#
(def PRED N = (((((TYPE-N-CHECK-F pred) "PRED") natType) natType) N))

#|
    ~ SUBTRACTION ~
    - Contract: (NAT,NAT) => NAT
    - Idea: M,N => M-N
|#
(def SUB M N = (((((((TYPE-N-CHECK-F2 sub) "SUB") natType) natType) natType) M) N))

;===================================================

#|
    ~ MODULO ~
    - Contract: (NAT,NAT) => NAT
    - Idea: Same as remainder for natural numbers
|#
(def MOD M N = (((((((TYPE-N-CHECK-F2 mod) "MOD") natType) natType) natType) M) N))

#|
    ~ IS-EVEN ~
    - Contract: NAT => BOOL
|#
(def IS_EVEN N = (((((TYPE-N-CHECK-F isEven) "IS_EVEN") natType) boolType) N))

; #|
;     ~ IS-ODD ~
;     - Contract: NAT => BOOL
; |#
(def IS_ODD N = (((((TYPE-N-CHECK-F isOdd) "IS_ODD") natType) boolType) N))

;===================================================

#|
    ~ GREATER-THAN-OR-EQUAL ~
    - Contract: (NAT,NAT) => BOOL
|#
(def GTE M N = (((((((TYPE-N-CHECK-F2 gte) "GTE") natType) natType) boolType) M) N))

#|
    ~ LESS-THAN-OR-EQUAL ~
    - Contract: (NAT,NAT) => BOOL
|#
(def LTE M N = (((((((TYPE-N-CHECK-F2 lte) "LTE") natType) natType) boolType) M) N))

; #|
;     ~ EQUAL ~
;     - Contract: (NAT,NAT) => BOOL
; |#
(def EQ M N = (((((((TYPE-N-CHECK-F2 eq) "EQ") natType) natType) boolType) M) N))

; #|
;     ~ GREATER-THAN ~
;     - Contract: (NAT,NAT) => BOOL
; |#
(def GT M N = (((((((TYPE-N-CHECK-F2 gt) "GT") natType) natType) boolType) M) N))

; #|
;     ~ LESS-THAN ~
;     - Contract: (NAT,NAT) => BOOL
; |#
(def LT M N = (((((((TYPE-N-CHECK-F2 lt) "LT") natType) natType) boolType) M) N))
