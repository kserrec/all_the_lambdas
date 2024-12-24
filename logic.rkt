#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
(provide (all-defined-out))

;===================================================
; LOGIC
;===================================================

#|
    ~ IDENTITY FUNCTION ~
    - Contract: func => func
    - Logic: Returns same function passed
|#

(def identity x = x)

#|
    ~ TRUE ~
    - Contract: (func,func) => func
    - Logic: Returns first function passed
|#
(def true x y = x)

#|
    ~ FALSE ~
    - Contract: (func,func) => func
    - Logic: Returns second function passed
|#
(def false x y = y)

#|
    ~ IF-THEN-ELSE ~
    - Contract: (func,func,func) => func
    - Logic: By logic of true/false, condition func1 "picks" func2 or func3,
                the first or second function passed to it
|#
; (def _if check case1 case2 = ((check case1) case2))

#|
    ~ BOOLEAN READER ~
    - Note: this is a helper function for viewing lambda calculus - not pure LC
    - Contract: bool => readable(bool)
    - Logic: Outputs bool for user 
|#
(def b-read b = ((b "true") "false"))

;===================================================

#|
    ~ NOT ~
    - Contract: bool => bool
    - Idea: Output opposite boolean value of input
    - Logic: If true, picks false, if false, picks true
|#
(def _not b = ((b false) true))

#|
    ~ AND ~
    - Contract: (bool,bool) => bool
    - Idea: Return true only if both true, else false
    - Logic: If b1 true, pick b2
                then return b2 (true or false)
                else pick false
|#
(def _and b1 b2 = ((b1 b2) false))

#|
    ~ OR ~
    - Contract: (bool,bool) => bool
    - Idea: Return true if either are true, else false
    - Logic: If b1 true
                then true
                else b2 (true or false)
|#
(def _or b1 b2 = ((b1 true) b2))

;===================================================

#|
    ~ XOR ~
    - Contract: (bool,bool) => bool
    - Idea: Return true if either are true exclusively, else false
    - Logic: If b1 true
                then true if b2 false
                else b2 (true or false)
|#
(def xor b1 b2 = ((b1 (_not b2)) b2))

#|
    ~ NOR ~
    - Contract: (bool,bool) => bool
    - Idea: Return true if neither are true, else false
    - Logic: Not the or of them
|#
(def nor b1 b2 = (_not ((_or b1) b2)))

#|
    ~ NAND ~
    - Contract: (bool,bool) => bool
    - Idea: Return true if both are not true, else false
    - Logic: Not the and of them
|#
(def nand b1 b2 = (_not ((_and b1) b2)))

;===================================================

