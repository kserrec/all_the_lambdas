#lang s-exp "../../macros/lazy-with-macros.rkt"
(require "../../macros/macros.rkt")
(require "../../church.rkt"
         "../../integers.rkt"
         "../../rationals.rkt"
         "../../tests/helpers/test-helpers.rkt"
         "../RATIONALS.rkt"
         "../TYPES.rkt")

; ====================================================================
; ~ STRICT RUNTIME-TAGGED RATIONAL DIVISION TESTS ~
; ====================================================================

(define typed-r-zero (make-rat r-0))
(define typed-r-half (make-rat r-pos1-2))
(define typed-r-neg-half (make-rat r-neg1-2))
(define typed-denominator-zero (make-rat ((makeR2 posOne) zero)))

(define strict-rational-division-tests (list
    (test-list-element "DIVr(1/2)(1/2) succeeds"
        (read-any ((DIVr typed-r-half) typed-r-half)) "result:ok(rat:1)")
    (test-list-element "DIVr(-1/2)(1/2) succeeds"
        (read-any ((DIVr typed-r-neg-half) typed-r-half)) "result:ok(rat:-1)")
    (test-list-element "DIVr(0)(1/2) succeeds"
        (read-any ((DIVr typed-r-zero) typed-r-half)) "result:ok(rat:0)")
    (test-list-element "DIVr(1/2)(0) returns a division error"
        (read-any ((DIVr typed-r-half) typed-r-zero)) "result:err(err:div by 0)")
    (test-list-element "DIVr treats a zero-denominator divisor as rational zero"
        (read-any ((DIVr typed-r-half) typed-denominator-zero)) "result:err(err:div by 0)")
    (test-list-element "DIVr preserves raw zero-denominator dividend behavior"
        (read-any ((DIVr typed-denominator-zero) typed-r-half)) "result:ok(rat:0)")
    (test-list-element "DIVr wraps an arg1 type failure in Result"
        (read-any ((DIVr (make-nat one)) typed-r-half)) "result:err(DIVr(arg1(err:rat)))")
    (test-list-element "DIVr wraps an arg2 type failure in Result"
        (read-any ((DIVr typed-r-half) (make-nat one))) "result:err(DIVr(arg2(err:rat)))")
))

(show-results "strict rational DIVr" strict-rational-division-tests)
