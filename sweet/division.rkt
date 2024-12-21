#lang s-exp "lazy-with-macros.rkt"
(require "macros.rkt")
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
                if(b > (a-(n*b)))
                    then n
                    else div(a)(b)(n+1)
|#
(def div a b = ((((Y div-helper) a) b) zero))

; DIV-HELPER
(def div-helper f a b n =
    (_if ((gt b) ((sub a) ((mult n) b))) 
        _then n
        _else (((f a) b) (succ n))))

;===================================================