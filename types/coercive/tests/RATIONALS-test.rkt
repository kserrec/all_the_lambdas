#lang s-exp "../../../macros/lazy-with-macros.rkt"
(require "../../../macros/macros.rkt")
(require "../../../church.rkt"
         "../../../integers.rkt"
         "../../../logic.rkt"
         "../../../rationals.rkt"
         "../../../tests/helpers/test-helpers.rkt"
         "../../TYPES.rkt"
         "../LOGIC.rkt"
         "../RATIONALS.rkt")

; ====================================================================
; ~ COERCIVE RUNTIME-TAGGED RATIONAL DIVISION TESTS ~
; ====================================================================

(define coercive-denominator-zero (make-rat ((makeR2 posOne) zero)))

(define coercive-rational-division-tests (list
    (test-list-element "DIVr(1/2)(1/2) succeeds"
        (read-any ((DIVr pos1-2-R) pos1-2-R)) "rat:1")
    (test-list-element "DIVr(-1/2)(1/2) succeeds"
        (read-any ((DIVr neg1-2-R) pos1-2-R)) "rat:-1")
    (test-list-element "DIVr(0)(1/2) succeeds"
        (read-any ((DIVr pos0-R) pos1-2-R)) "rat:0")
    (test-list-element "DIVr(1/2)(0) returns a division error"
        (read-any ((DIVr pos1-2-R) pos0-R)) "err:div by 0")
    (test-list-element "DIVr coerces FALSE before checking for zero"
        (read-any ((DIVr pos1-2-R) FALSE)) "err:div by 0")
    (test-list-element "DIVr treats a zero-denominator divisor as rational zero"
        (read-any ((DIVr pos1-2-R) coercive-denominator-zero)) "err:div by 0")
    (test-list-element "DIVr preserves raw zero-denominator dividend behavior"
        (read-any ((DIVr coercive-denominator-zero) pos1-2-R)) "rat:0")
))

(show-results "coercive rational DIVr" coercive-rational-division-tests)
