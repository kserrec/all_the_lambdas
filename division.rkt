#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
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


#|
    ~ MODULO ~
    - Contract: (nat,nat) => nat
    - Idea: Same as remainder for natural numbers
    - Logic: m - (n * quotient)
|#
(def mod m n = 
    (_let q = ((div m) n)
        ((sub m) ((mult n) q))))


; #|
;     ~ IS-EVEN ~
;     - Contract: nat => bool
;     - Idea: if (
;     - Logic: Check if (m <= n) AND not(m == n)
; |#
; (def lt m n = 
;     ((_and 
;         ((lte m) n)) 
;         (_not ((eq m) n)))
; )