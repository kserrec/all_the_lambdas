#lang s-exp "../../macros/lazy-with-macros.rkt"
(require "../../macros/macros.rkt")
(require "../../logic.rkt"
         "../../church.rkt"
        "../../core.rkt"
         "../../tests/helpers/test-helpers.rkt")
(require "../CHURCH.rkt"
         "../INTEGERS.rkt"
         "../LOGIC.rkt"
         "../TYPES.rkt")

; ====================================================================
; ~ TYPED LOGIC TESTS ~
; ====================================================================

(define make-error-tests (list
    (test-list-element "make-error(_error)('err:err')" 
        (read-any ((make-error _error) "err:err")) "err:err")
    (test-list-element "make-error(bool)('err:bool')" 
        (read-any ((make-error bool) "err:bool")) "err:bool")
    (test-list-element "make-error(nat)('err:nat')" 
        (read-any ((make-error nat) "err:nat")) "err:nat")
    (test-list-element "make-error(int)('err:int')" 
        (read-any ((make-error int) "err:int")) "err:int")
))

(show-results "make-error" make-error-tests)

; ====================================================================


(define is-type-tests (list
    (test-list-element "is-type(_error)(TRUE)" (b-read ((is-type _error) TRUE)) "false")
    (test-list-element "is-type(_error)(FALSE)" (b-read ((is-type _error) FALSE)) "false")
    (test-list-element "is-type(_error)(THREE)" (b-read ((is-type _error) THREE)) "false")
    (test-list-element "is-type(_error)(ERROR)" (b-read ((is-type _error) ERROR)) "true")
    (test-list-element "is-type(_error)(posONE)" (b-read ((is-type _error) posONE)) "false")

    (test-list-element "is-type(bool)(TRUE)" (b-read ((is-type bool) TRUE)) "true")
    (test-list-element "is-type(bool)(FALSE)" (b-read ((is-type bool) FALSE)) "true")
    (test-list-element "is-type(bool)(ONE)" (b-read ((is-type bool) ONE)) "false")
    (test-list-element "is-type(bool)(negONE)" (b-read ((is-type bool) negONE)) "false")

    (test-list-element "is-type(nat)(ZERO)" (b-read ((is-type nat) ZERO)) "true")
    (test-list-element "is-type(nat)(ONE)" (b-read ((is-type nat) ONE)) "true")
    (test-list-element "is-type(nat)(TWO)" (b-read ((is-type nat) TWO)) "true")
    (test-list-element "is-type(nat)(THREE)" (b-read ((is-type nat) THREE)) "true")
    (test-list-element "is-type(nat)(TRUE)" (b-read ((is-type nat) TRUE)) "false")
    (test-list-element "is-type(nat)(TRUE)" (b-read ((is-type nat) negTHREE)) "false")

    (test-list-element "is-type(int)(negONE)" (b-read ((is-type int) negONE)) "true")
    (test-list-element "is-type(int)(posONE)" (b-read ((is-type int) posONE)) "true")
    (test-list-element "is-type(int)(negTWO)" (b-read ((is-type int) negTWO)) "true")
    (test-list-element "is-type(int)(posTHREE)" (b-read ((is-type int) posTHREE)) "true")
    (test-list-element "is-type(int)(TRUE)" (b-read ((is-type int) TRUE)) "false")
    (test-list-element "is-type(int)(ERROR)" (b-read ((is-type int) ERROR)) "false")
))

(show-results "is-type" is-type-tests)

; ====================================================================

; a dummy curried 3-arg function for exercising type-check3 directly
(define dummy3 (lambda (a) (lambda (b) (lambda (c) a))))

(define type-check3-tests (list
    (test-list-element "type-check3 valid args runs func"
        (read-any ((((((((type-check3 dummy3) "dummy") bool) nat) int) TRUE) ONE) posONE)) "bool:TRUE")
    (test-list-element "type-check3 arg3 wrong type names arg3"
        (read-any ((((((((type-check3 dummy3) "dummy") bool) nat) int) TRUE) ONE) TRUE)) "dummy(arg3(err:int))")
    ; regression: the error object must carry arg3's expected type (int), not arg2's (nat)
    (test-list-element "type-check3 arg3 error carries param-type3"
        (b-read ((eq int) (type (val ((((((((type-check3 dummy3) "dummy") bool) nat) int) TRUE) ONE) TRUE))))) "true")
))

(show-results "type-check3" type-check3-tests)

; ====================================================================

(define option-tests (list
    ; rendering
    (test-list-element "read-any(some(THREE))"
        (read-any (make-some THREE)) "option:some(nat:3)")
    (test-list-element "read-any(NONE)"
        (read-any NONE) "option:none")
    (test-list-element "read-option(some(posONE))"
        (read-option (make-some posONE)) "option:some(int:1)")
    ; case predicates
    (test-list-element "is-some(some(THREE))"
        (b-read (is-some (make-some THREE))) "true")
    (test-list-element "is-some(NONE)"
        (b-read (is-some NONE)) "false")
    (test-list-element "is-none(NONE)"
        (b-read (is-none NONE)) "true")
    (test-list-element "is-none(some(THREE))"
        (b-read (is-none (make-some THREE))) "false")
    ; type predicate keeps option distinct from other types
    (test-list-element "is-option(some(THREE))"
        (b-read (is-option (make-some THREE))) "true")
    (test-list-element "is-option(THREE)"
        (b-read (is-option THREE)) "false")
    (test-list-element "is-option(ok(THREE))"
        (b-read (is-option (make-ok THREE))) "false")
    ; selection and safe elimination
    (test-list-element "unwrap-some(some(THREE))"
        (read-any (unwrap-some (make-some THREE))) "nat:3")
    (test-list-element "option-or-else(some(THREE), ONE)"
        (read-any ((option-or-else (make-some THREE)) ONE)) "nat:3")
    (test-list-element "option-or-else(NONE, ONE)"
        (read-any ((option-or-else NONE) ONE)) "nat:1")
    ; nesting: the payload is itself a typed object, read recursively
    (test-list-element "read-any(some(some(THREE)))"
        (read-any (make-some (make-some THREE))) "option:some(option:some(nat:3))")
))

(show-results "option" option-tests)

; ====================================================================

(define result-tests (list
    ; rendering
    (test-list-element "read-any(ok(THREE))"
        (read-any (make-ok THREE)) "result:ok(nat:3)")
    (test-list-element "read-any(err(NAT-ERROR))"
        (read-any (make-err-result NAT-ERROR)) "result:err(err:nat)")
    (test-list-element "read-result(ok(THREE))"
        (read-result (make-ok THREE)) "result:ok(nat:3)")
    ; case predicates
    (test-list-element "is-ok(ok(THREE))"
        (b-read (is-ok (make-ok THREE))) "true")
    (test-list-element "is-err(err(NAT-ERROR))"
        (b-read (is-err (make-err-result NAT-ERROR))) "true")
    (test-list-element "is-ok(err(NAT-ERROR))"
        (b-read (is-ok (make-err-result NAT-ERROR))) "false")
    (test-list-element "is-err(ok(THREE))"
        (b-read (is-err (make-ok THREE))) "false")
    ; type predicate keeps result distinct from other types
    (test-list-element "is-result(ok(THREE))"
        (b-read (is-result (make-ok THREE))) "true")
    (test-list-element "is-result(THREE)"
        (b-read (is-result THREE)) "false")
    (test-list-element "is-result(some(THREE))"
        (b-read (is-result (make-some THREE))) "false")
    ; selection and safe elimination
    (test-list-element "unwrap-ok(ok(THREE))"
        (read-any (unwrap-ok (make-ok THREE))) "nat:3")
    (test-list-element "unwrap-err(err(NAT-ERROR))"
        (read-any (unwrap-err (make-err-result NAT-ERROR))) "err:nat")
    (test-list-element "result-or-else(ok(THREE), ONE)"
        (read-any ((result-or-else (make-ok THREE)) ONE)) "nat:3")
    (test-list-element "result-or-else(err(NAT-ERROR), ONE)"
        (read-any ((result-or-else (make-err-result NAT-ERROR)) ONE)) "nat:1")
    ; nesting: ok wrapping an option renders recursively
    (test-list-element "read-any(ok(some(THREE)))"
        (read-any (make-ok (make-some THREE))) "result:ok(option:some(nat:3))")
))

(show-results "result" result-tests)