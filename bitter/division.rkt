#lang lazy
(provide (all-defined-out))
(require "church.rkt"
         "recursion.rkt")

;===================================================
; DIVISION
;===================================================

#|
    ~ DIVISION ~
    - Contract: (nat,nat) => nat
    - Logic: def div(a)(b)(n) = 
                (let n = 0 to start)
                if(b > (n*b))
                    then n
                    else div(a)(b)(n+1)
|#
(define div
        (lambda (a)
            (lambda (b)
                    ((((Y div-helper) a) b) zero)
            )
        )
)

; DIV-HELPER
(define div-helper
    (lambda (f)
        (lambda (a)
            (lambda (b)
                (lambda (n)
                    ((((gt b) ((sub a) ((mult n) b)))
                        n)
                    (((f a) b) (succ n)))
                )
            )
        )
    )
)

;===================================================