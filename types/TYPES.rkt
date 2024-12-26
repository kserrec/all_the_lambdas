#lang lazy
(provide (all-defined-out))
(require "../macros/macros.rkt")
(require "../church.rkt"
         "../division.rkt"
         "../integers.rkt"
         "../lists.rkt"
         "../logic.rkt")

(define s-a string-append)
(define (chain err1 err2) (s-a (s-a err1 "->") err2))
(define (wrap funcName err) (s-a (s-a (s-a funcName "(") err) ")"))
(define n-s number->string)

;===================================================
; TYPES
;===================================================

#|  
    Note: pairs will be written here in braces, {a,b}
    For typed objects, a pair of this format is used: typed_obj = {type, value}

    ~ TYPE ~
    The types of a typed object will just be defined by church numerals
    - zero is the ERROR type
    - one is the BOOL type
    - two is the NAT type
    - three is the INT type

    ~ VALUE ~
    The values of a typed object will be the actual values we want to store and will differ by type
    - ERROR - a pair of the error type and the error message
        - {ERROR-TYPE, "message"}, note the message is a plain string
    - BOOL - an untyped bool 
    - NAT - an untyped natural number
    - INT - an untyped integer
        - note: integers are pairs themselves, so they will be a pair of a sign and a natural number
        - {sign, nat}

    ~ TYPED OBJECT ~
    Examples
        - ERROR-OBJECTS:
            - {zero, {zero, "error error!"}}    - ERROR ERROR
            - {zero, {one, "bool error!"}}  - BOOL ERROR
        - BOOL-OBJECTS (exhaustive list):
            - {one, zero}   - FALSE
            - {one, one}    - TRUE
        - NAT-OBJECTS:
            - {two, zero}   - TYPED 0
            - {two, one}    - TYPED 1
        - INT-OBJECTS:
            - {three, {true, one}}   - TYPED +1
            - {three, {false, five}} - TYPED -5
|#

#|
    ~ MAKE TYPED OBJECT ~
    - Structure: (type,val) => {type,val}
    - Logic: just a pair function
|#
(def make-obj type val = ((pair type) val))

#|
    ~ SELECTION FUNCTIONS ~
    - Idea: select type or value from typed object {type, val}
    - Contract: obj => type/val
|#
; - Structure: {type,val} => type
; - Logic: get head of pair
(def type obj = (head obj))

; - Structure: {type,val} => val
; - Logic: get tail of pair
(def val obj = (tail obj))

;===================================================

#|
    ~ DEFINED TYPES ~
    - types will be indicated by church numerals
|#

;   ERROR
(def error-type = zero)
;   BOOLEAN
(def bool-type = one)
;   NATURAL NUMBER
(def nat-type = two)
;   INT NUMBER
(def int-type = three)

;===================================================

#|
    ~ SPECIFIC TYPED OBJECT MAKERS ~
    - Idea: 
        - each type will be defined by a church numeral
        - typed objects are pairs {type, val}
        - error-typed objects will store messages as nested pairs
            - e.g. {error-type, {type, msg}}
|#

;   MAKE ERROR OBJECT FUNCTIONS

;   Makes An Error Type Object
;   - Contract: error-val => ERROR
(def set-error val = ((make-obj error-type) val))

;   Makes Any Kind of Error Type Object
;   - Contract (type, err-msg) => {error, {type, err-msg}}
(def make-error type err-msg = (set-error ((pair type) err-msg)))


;   - Specific error makers
(def make-err-err err-msg = ((make-error error-type) err-msg))

(def make-bool-err err-msg = ((make-error bool-type) err-msg))

(def make-nat-err err-msg = ((make-error nat-type) err-msg))

(def make-int-err err-msg = ((make-error int-type) err-msg))

;===================================================

#|
    ~ ERROR OBJECT INSTANCES ~
    - Idea: Generic error instances to return when type checking
|#

;   Universal Error Type Object
;   - Idea: has type and val as pair(error-type,'ERROR')
(def ERROR = (make-err-err "err:err"))

;   Boolean Error Type Object
;   - Idea: has type error and val as bool-type
(def BOOL-ERROR = (make-bool-err "err:bool"))

;   Nat Error Type Object
;   - Idea: has type error and val as nat-type
(def NAT-ERROR = (make-nat-err "err:nat"))

;   Int Error Type Object
;   - Idea: has type error and val as nat-type
(def INT-ERROR = (make-int-err "err:int"))

;===================================================

;   Other Typed Objects Makers

;   - Contract: val => BOOL
(def make-bool val = ((make-obj bool-type) val))

;   Makes Natural Number Type Objects
;   - Contract: val => NAT
(def make-nat val = ((make-obj nat-type) val))

;   Makes Integer Number Type Objects
;   - Contract: val => INT
(def make-int val = ((make-obj int-type) val))

;===================================================

;  Makes New Integer Number Type Objects 
;  - Idea: 
;       - make-int above works to add the int type to a value,
;           new-int creates a new INT object entirely.
;       - This distinction is needed because ints are a pair 
;           themselves, not just a single value
;  - Contract: (sign, val) => int
(def new-int sign val = (make-int ((makeZ sign) val)))

;===================================================

#|
    ~ TYPE CHECKING ~
|#

#|
    ~ CHECKS TYPE ~
    - Idea: checks if object passed is given type
    - Structure: (type,obj) => bool
|#
(def is-type type obj = ((eq (head obj)) type))

#|
    ~ IS ERROR ~
    - Idea: use is-type
    - Structure: obj => bool
|#
(def is-error obj = ((is-type error-type) obj))

#|
    ~ IS BOOL ~
    - Idea: use is-type
    - Structure: obj => bool
|#
(def is-bool obj = ((is-type bool-type) obj))

#|
    ~ IS NAT ~
    - Idea: use is-type
    - Structure: obj => nat
|#
(def is-nat obj = ((is-type nat-type) obj))

#|
    ~ IS INT ~
    - Idea: use is-type
    - Structure: obj => int
|#
(def is-int obj = ((is-type int-type) obj))

;===================================================

#|
    ~ ERROR TRACING FUNCTION INPUT TYPE CHECKERS ~
    - Idea: Takes a function, its name, types of its arguments, and arguments
                to redefine function with ability to handle and propagate errors
|#

#|
    ~ SINGLE ARG FUNCTION TYPE CHECK ~
    - Idea: Built for functions which take one argument
    - Contract: (func, funcName, type, arg) => func
|#
(def type-check func func-name param-type param = 
    ; make/chain errors for arg if needed
    (_let err-msg = (wrap func-name (err-read (param-err-type param-type)))
    (_let err = ((make-error param-type) err-msg)
    (_let chain-errs = ((make-error param-type) (chain (err-read param) err-msg))
        ; check types
        (_if ((is-type param-type) param)
             _then (func param)
            _else (_if (is-error param)
                _then chain-errs
                _else err))))))

#|
    ~ DOUBLE ARG FUNCTION TYPE CHECK ~
    - Idea: Built for functions which take two arguments
    - Contract: (func, funcName, type, type, arg, arg) => func
|#
(def type-check2 func func-name param-type1 param-type2 param1 param2 = 
    ; make/chain errors for arg 1 if needed
    (_let err-msg1 = (wrap func-name (wrap "arg1" (err-read (param-err-type param-type1))))
    (_let err1 = ((make-error param-type1) err-msg1)
    (_let chain-errs1 = ((make-error param-type1) (chain (err-read param1) err-msg1))
    ; make/chain errors for arg 2 if needed
    (_let err-msg2 = (wrap func-name (wrap "arg2" (err-read (param-err-type param-type2))))
    (_let err2 = ((make-error param-type2) err-msg2)
    (_let chain-errs2 = ((make-error param-type2) (chain (err-read param2) err-msg2))
        ; check types
        (_if ((is-type param-type1) param1)
            _then (_if ((is-type param-type2) param2)
                    _then ((func param1) param2)
                    _else (_if (is-error param2)
                            _then chain-errs2
                            _else err2))
            _else (_if (is-error param1)
                    _then chain-errs1
                    _else err1)))))))))

#|
    ~ GETS ERROR TYPE BY PARAM TYPE ~
    - Idea: Takes a parameter type and returns related error type
    - Contract: TYPE => ERROR
|#
(def param-err-type param-type =
    (_if ((eq bool-type) param-type)
        _then BOOL-ERROR
        _else (_if ((eq nat-type) param-type)
                _then BOOL-ERROR
                _else (_if ((eq int-type) param-type)
                        _then BOOL-ERROR
                        _else ERROR))))

#|
    ~ MAKE F TYPED ~
    - Idea: no reason to specifically remake these functions,  
                just need to operate on their values
|#
; For One Argument Functions
(def make-typed-func-1 func func-type param = ((make-obj func-type) (func (val param))))

; For TWo Argument Functions
(def make-typed-func-2 func func-type param1 param2 = ((make-obj func-type) ((func (val param1)) (val param2))))


#|
    ~ MAKE F TYPED AND CHECKED ~
    - Idea: transform our untyped functions to fully typed
                let's do this!
|#
; For One Argument Functions
(def type-n-check-f func func-name param-type return-type param = 
    ((((type-check 
        (lambda (param) (((make-typed-func-1 func) return-type) param))) 
        func-name) param-type) param))

; For Two Argument Functions
(def type-n-check-f2 func func-name param-type1 param-type2 return-type param1 param2 = 
    ((((((type-check2
        (lambda (param1)
            (lambda (param2)
                ((((make-typed-func-2 func) return-type) param1) param2)))) 
        func-name) param-type1) param-type2) param1) param2))

;===================================================

#|
    ~ READ TYPED VALUES ~
|#

#|
    ~ READ ERROR MESSAGES ~
|#
(def err-read E = (tail (tail E)))

#|
    ~ ERROR HELPER FUNCTION FOR READERS ~
    - Idea: Reads error msg if passed error object instead of intended type
    - Contract: (FUNC, OBJ) => READ(TYPE)
|#
(def read-type func obj = 
    (_if (is-error obj)
        _then (err-read obj)
        _else (func obj)))


;===================================================

#|
    need to define 
        - the rest of the logical operators
        - numerical operators
|#