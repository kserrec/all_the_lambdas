#lang lazy
(provide (all-defined-out))
(require "church.rkt"
         "division.rkt"
         "lists.rkt"
         "logic.rkt")

;===================================================
; TYPES
;===================================================

#|  Types

    Note: pairs will be written here in braces, {a,b}
    For typed objects, a pair of this format is used: typed_obj = {type, value}

    Types will just be represented by church numerals
    - zero is the error type
    - one is the boolean type
    - two ...
|#

#|
    ~ MAKE TYPED OBJECT ~
    - Structure: (type,val) => {type,val}
    - Logic: just a pair function
|#
(define makeObj
    (lambda (type)
        (lambda (val)
            ((pair type) val)
        )
    )
)

#|
    ~ SELECTION FUNCTIONS ~
    - Idea: select type or value
    - Structure: (type,val) => {type,val}
    - Logic: just a pair function
|#
; - Structure: {type,val} => type
; - Logic: get head of pair
(define pair
    (lambda (obj)
        (head obj)
    )
)
; - Structure: {type,val} => val
; - Logic: get tail of pair
(define pair
    (lambda (obj)
        (tail obj)
    )
)

;===================================================

#|
    ~ DEFINED TYPES ~
    - Idea: each type will be a church numeral
|#

;   ERROR
(define errorType zero)
;   BOOLEAN
(define boolType one)

;===================================================

#|
    ~ TYPED OBJECT MAKERS ~
    - Idea: each type will be a church numeral
|#

;   Makes Error Type Objects
;   - Contract: (val) => ERROR
(define makeError
    (lambda (val)
        ((makeObj errorType) val)
    )
)

;   Makes Bool Type Objects
;   - Contract: (val) => BOOL
(define makeBool
    (lambda (val)
        ((makeObj boolType) val)
    )
)

;===================================================

#|
    ~ ERROR OBJECTS ~
    - Idea: Errors to return when type checking
|#

;   Universal Error Type Object
;   - Idea: has type and val as errorType
(define ERROR (makeError errorType))

;   Boolean Error Type Object
;   - Idea: has type error and val as boolType
(define BOOL_ERROR (makeError boolType))

;===================================================

#|
    ~ BOOLEAN OBJECTS ~
;   - Idea: Can list these exhaustively
|#

;   TRUE & FALSE
(define TRUE (makeBool true))
(define FALSE (makeBool false))

;===================================================

#|
    ~ TYPE CHECKING ~
|#


#|
    ~ CHECKS TYPE ~
    - Structure: (type,obj) => bool
|#
(define isType
    (lambda (pair)
        (lambda (obj)
            ((eq (head obj)) pair)
        )
    )
)

#|
    ~ IS ERROR ~
    - Idea: use isType
    - Structure: obj => bool
|#
(define isError
    (lambda (obj)
        ((isType errorType) obj)
    )
)

#|
    ~ IS BOOL ~
    - Idea: use isType
    - Structure: obj => bool
|#
(define isBool
    (lambda (obj)
        ((isType boolType) obj)
    )
)

;===================================================

#|
    ~ NOT (TYPED) ~
    - Contract: BOOL => BOOL/BOOL_ERROR
    - Logic: if (isBool x)
                    then makeBool (not (val x))
                    else BOOL_ERROR
|#
(define NOT
    (lambda (b)
        (((isBool b)
            (makeBool (_not (pair b))))
            BOOL_ERROR
        )
    )
)

#|
    ~ AND (TYPED) ~
    - Contract: (BOOL,BOOL) => BOOL/BOOL_ERROR
    - Logic: if (and (isBool x)(isBool y))
                    then makeBool (and (val x)(val y))
                    else BOOL_ERROR
|#
(define AND
    (lambda (b1)
        (lambda (b2)
            ((((_and (isBool b1)) (isBool b2))
                (makeBool ((_and (pair b1)) (pair b2))))
                BOOL_ERROR
            )
        )     
    )
)