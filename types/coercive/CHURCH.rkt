#lang lazy
(provide (all-defined-out))
(require "../../church.rkt"
         "../../core.rkt"
         "../../integers.rkt"
         "../../lists.rkt"
         "../../logic.rkt"
         "../../macros/macros.rkt"
         "../TYPES.rkt"
         "/TYPES.rkt")


(def IS_ZERO N = ((((COERCE-1 isZero) convert-to-nat) N) bool))

(def SUCC N = ((((COERCE-1 succ) convert-to-nat) N) nat))

(def PRED N = ((((COERCE-1 pred) convert-to-nat) N) nat))

(def ADD N1 N2 = (((((COERCE-2 add) convert-to-nat) N1) N2) nat))

(def SUB N1 N2 = (((((COERCE-2 sub) convert-to-nat) N1) N2) nat))

(def MULT N1 N2 = (((((COERCE-2 mult) convert-to-nat) N1) N2) nat))

(def EXP N1 N2 = (((((COERCE-2 _exp) convert-to-nat) N1) N2) nat))

(def DIV N1 N2 = 
    (_if (IS_ZERO N2)
        _then (make-nat-err "err:div by 0")
        _else (((((COERCE-2 div) convert-to-nat) N1) N2) nat)))

(def IS_ODD N = ((((COERCE-1 isOdd) convert-to-nat) N) bool))

(def IS_EVEN N = ((((COERCE-1 isEven) convert-to-nat) N) bool))

(def LTE N1 N2 = (((((COERCE-2 lte) convert-to-nat) N1) N2) bool))

(def GTE N1 N2 = (((((COERCE-2 gte) convert-to-nat) N1) N2) bool))

(def EQ N1 N2 = (((((COERCE-2 eq) convert-to-nat) N1) N2) bool))

(def GT N1 N2 = (((((COERCE-2 gt) convert-to-nat) N1) N2) bool))

(def LT N1 N2 = (((((COERCE-2 lt) convert-to-nat) N1) N2) bool))