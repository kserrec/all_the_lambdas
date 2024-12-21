#lang lazy
(provide (all-defined-out))
(require "../church.rkt"
         "../logic.rkt"
         "../macros/macros.rkt")
(require "LOGIC.rkt"
         "TYPES.rkt")

#|
    ~ IS ZERO
    - Contract: NAT => BOOL/ERROR
    - Logic: isZero function with type checking
|#
(def _IS_ZERO N = 
    (_if (isNat N)
        _then (_if (isZero (val N))
                _then TRUE
                _else FALSE)
        _else NAT_ERROR))

(def IS_ZERO N = ((((ADD_ERR_PROP _IS_ZERO) "IS_ZERO") natType) N))

;===================================================