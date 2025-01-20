#lang s-exp "../../../macros/lazy-with-macros.rkt"
(require "../../../macros/macros.rkt")
(require "../CHURCH.rkt"
         "../INTEGERS.rkt"

         "../LOGIC.rkt"
         "../TYPES.rkt"
         "../../TYPES.rkt"
         "../../../tests/helpers/test-helpers.rkt")

; ====================================================================
; ~ COERCED TYPE LISTS TESTS ~
; ====================================================================

; (define NOT-tests (list 
;     ; normal
;     (test-list-element "NOT(FALSE)" (read-any (NOT FALSE)) "bool:TRUE")
;     (test-list-element "NOT(TRUE)" (read-any (NOT TRUE)) "bool:FALSE")
;     ; coercing
;     (test-list-element "NOT(TWO)" (read-any (NOT TWO)) "bool:FALSE")
;     (test-list-element "NOT(ZERO)" (read-any (NOT ZERO)) "bool:TRUE")
;     (test-list-element "NOT(negTHREE)" (read-any (NOT negTHREE)) "bool:FALSE")
; ))

; (show-results "NOT" NOT-tests)