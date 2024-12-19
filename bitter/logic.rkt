#lang lazy
(provide (all-defined-out))

;===================================================
; LOGIC
;===================================================

#|
    ~ TRUE ~
    - Contract: (func,func) => func
    - Logic: Returns first function passed
|#
(define true 
    (lambda (x) 
        (lambda (y) x)
    )
)

#|
    ~ FALSE ~
    - Contract: (func,func) => func
    - Logic: Returns second function passed
|#
(define false 
    (lambda (x) 
        (lambda (y) y)
    )
)

#|
    ~ IF-THEN-ELSE ~
    - Contract: (func,func,func) => func
    - Logic: By logic of true/false, condition func1 "picks" func2 or func3,
                the first or second function passed to it
|#
(define _if
    (lambda (check)
        (lambda (case1)
            (lambda (case2) 
                ((check case1) case2)
            )
        )
    )
)

#|
    ~ BOOLEAN READER ~
    - Note: this is a helper function for viewing lambda calculus - not pure LC
    - Contract: bool => readable(bool)
    - Logic: Outputs bool for user 
|#
(define b-read
    (lambda (b)
        ((b "true") "false")
    )
)

;===================================================

#|
    ~ NOT ~
    - Contract: bool => bool
    - Idea: Output opposite boolean value of input
    - Logic: If true, picks false, if false, picks true
|#
(define _not
    (lambda (b)
        ((b false) true)
    )
)

#|
    ~ AND ~
    - Contract: (bool,bool) => bool
    - Idea: Return true only if both true, else false
    - Logic: If b1 true, pick b2
                then return b2 (true or false)
                else pick false
|#
(define _and
    (lambda (b1) 
        (lambda (b2) 
            ((b1 b2) false)
        )
    )
)

#|
    ~ OR ~
    - Contract: (bool,bool) => bool
    - Idea: Return true if either are true, else false
    - Logic: If b1 true
                then true
                else b2 (true or false)
|#
(define _or
    (lambda (b1)
        (lambda (b2) 
            ((b1 true) b2)
        )
    )
)

;===================================================

#|
    ~ XOR ~
    - Contract: (bool,bool) => bool
    - Idea: Return true if either are true exclusively, else false
    - Logic: If b1 true
                then true if b2 false
                else b2 (true or false)
|#
(define xor
    (lambda (b1)
        (lambda (b2)
            ((b1 (_not b2)) b2)
        )
    )
)

#|
    ~ XOR ~
    - Contract: (bool,bool) => bool
    - Idea: Return true if neither are true, else false
    - Logic: Not the or of them
|#
(define nor
    (lambda (b1)
        (lambda (b2) 
            (_not ((_or b1) b2))
        )
    )
)

#|
    ~ NAND ~
    - Contract: (bool,bool) => bool
    - Idea: Return true if both are not true, else false
    - Logic: Not the and of them
|#
(define nand
    (lambda (b1)
        (lambda (b2) 
            (_not ((_and b1) b2))
        )
    )
)

;===================================================

