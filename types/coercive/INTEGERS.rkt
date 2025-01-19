#lang lazy
(provide (all-defined-out))
(require "../../church.rkt"
         "../../core.rkt"
         "../../integers.rkt"
         "../../lists.rkt"
         "../../logic.rkt"
         "../../macros/macros.rkt"
         "TYPES.rkt"
         "../TYPES.rkt")

(def IS_ZEROz Z = ((((COERCE-1 isZeroZ) convert-to-int) Z) bool))

(def SUCCz Z = ((((COERCE-1 succZ) convert-to-int) Z) int))

(def PREDz Z = ((((COERCE-1 predZ) convert-to-int) Z) int))

(def ADDz Z1 Z2 = (((((COERCE-2 addZ) convert-to-int) Z1) Z2) int))

(def SUBz Z1 Z2 = (((((COERCE-2 subZ) convert-to-int) Z1) Z2) int))

(def MULTz Z1 Z2 = (((((COERCE-2 multZ) convert-to-int) Z1) Z2) int))

(def EXPz Z1 Z2 = (((((COERCE-2 expZ) convert-to-int) Z1) Z2) int))

(def DIVz Z1 Z2 = 
    (_if (IS_ZEROz Z2)
        _then (make-int-err "err:div by 0")
        _else (((((COERCE-2 divZ) convert-to-int) Z1) Z2) int)))

(def IS_ODDz Z = ((((COERCE-1 isOddZ) convert-to-int) Z) bool))

(def IS_EVENz Z = ((((COERCE-1 isEvenZ) convert-to-int) Z) bool))

(def LTEz Z1 Z2 = (((((COERCE-2 lteZ) convert-to-int) Z1) Z2) bool))

(def GTEz Z1 Z2 = (((((COERCE-2 gteZ) convert-to-int) Z1) Z2) bool))

(def EQz Z1 Z2 = (((((COERCE-2 eqZ) convert-to-int) Z1) Z2) bool))

(def GTz Z1 Z2 = (((((COERCE-2 gtZ) convert-to-int) Z1) Z2) bool))

(def LTz Z1 Z2 = (((((COERCE-2 ltZ) convert-to-int) Z1) Z2) bool))