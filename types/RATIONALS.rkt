#lang lazy
(provide (all-defined-out))
(require "../logic.rkt"
         "../macros/macros.rkt"
         "../rationals.rkt"
         "TYPES.rkt")

;===================================================
; STRICT RUNTIME-TAGGED RATIONAL DIVISION
;===================================================

#|
    This is the strict rational division boundary. The raw Church-backed
    operation deliberately totalizes division by rational zero to rational
    zero. This runtime-tagged layer preserves that raw operation unchanged but
    intercepts a zero divisor and returns a Result value:

        success          => result:ok(rat:value)
        zero divisor     => result:err(err:div by 0)
        wrong type       => result:err(DIVr(argN(err:rat)))

    The raw isZeroR predicate defines rational zero as either a zero numerator
    or a zero denominator. DIVr uses that same definition for its guard.
|#

(def DIV-BY-ZERO-RAT-ERROR = (make-rat-err "err:div by 0"))

; Inputs have already passed type-check2 and are therefore typed rat objects.
(def DIVr-result R1 R2 =
    (_if (isZeroR (val R2))
        _then (make-err-result DIV-BY-ZERO-RAT-ERROR)
        _else (make-ok (make-rat ((divR (val R1)) (val R2))))))

#|
    ~ SAFE RATIONAL DIVISION ~
    - Contract: (RAT, RAT) => RESULT(RAT, ERROR)
    - Logic: Strictly check both runtime tags, then reject a rational-zero
        divisor before calling the unchanged raw divR.
|#
(def DIVr R1 R2 =
    (_let checked = ((((((type-check2 DIVr-result) "DIVr") rat) rat) R1) R2)
    (_if (is-error checked)
        _then (make-err-result checked)
        _else checked)))
