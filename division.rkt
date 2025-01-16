#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
(provide (all-defined-out))
(require "church.rkt"
         "core.rkt"
         "logic.rkt"
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

        
        
(def div-n-mod dividend divisor = ((((Y div-n-mod-helper) dividend) divisor) zero))

(def div-n-mod-helper f dividend divisor _quotient =
    (_let _remainder = ((sub dividend) ((mult _quotient) divisor))
    (_if ((gt divisor) _remainder) 
        _then ((pair _quotient) _remainder) 
        _else (((f dividend) divisor) (succ _quotient)))))


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
;     - Logic: check if n modulo of 2 is zero
; |#
(def isEven n = (isZero ((mod n) two)))

; #|
;     ~ IS-ODD ~
;     - Contract: nat => bool
;     - Logic: check if not even
; |#
(def isOdd n = (_not (isEven n)))