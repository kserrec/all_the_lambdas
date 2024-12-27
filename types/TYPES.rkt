#lang lazy
(provide (all-defined-out))
(require "../macros/macros.rkt")
(require "../church.rkt"
         "../division.rkt"
         "../integers.rkt"
         "../lists.rkt"
         "../logic.rkt")

(define (wrap funcName err) (string-append funcName "(" err ")"))

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
(def bool = one)
;   NATURAL NUMBER
(def nat = two)
;   INT NUMBER
(def int = three)
;   LIST 
(def _list = four)

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

(def make-bool-err err-msg = ((make-error bool) err-msg))

(def make-nat-err err-msg = ((make-error nat) err-msg))

(def make-int-err err-msg = ((make-error int) err-msg))

(def make-list-err err-msg = ((make-error _list) err-msg))

;===================================================

#|
    ~ ERROR OBJECT INSTANCES ~
    - Idea: Generic error instances to return when type checking
|#

;   Universal Error Type Object
;   - Idea: has type and val as pair(error-type,'ERROR')
(def ERROR = (make-err-err "err:err"))

;   Boolean Error Type Object
;   - Idea: has type error and val as bool
(def BOOL-ERROR = (make-bool-err "err:bool"))

;   Nat Error Type Object
;   - Idea: has type error and val as nat
(def NAT-ERROR = (make-nat-err "err:nat"))

;   Int Error Type Object
;   - Idea: has type error and val as nat
(def INT-ERROR = (make-int-err "err:int"))

;   List Error Type Object
;   - Idea: has type error and val as nat
(def LIST-ERROR = (make-list-err "err:list"))

;===================================================

;   Other Typed Objects Makers

;   - Contract: val => BOOL
(def make-bool val = ((make-obj bool) val))

;   Makes Natural Number Type Objects
;   - Contract: val => NAT
(def make-nat val = ((make-obj nat) val))

;   Makes Integer Number Type Objects
;   - Contract: val => INT
(def make-int val = ((make-obj int) val))

;   Makes List Type Objects
;   - Contract: val => INT
(def _make-list val = ((make-obj _list) val))

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
(def is-bool obj = ((is-type bool) obj))

#|
    ~ IS NAT ~
    - Idea: use is-type
    - Structure: obj => nat
|#
(def is-nat obj = ((is-type nat) obj))

#|
    ~ IS INT ~
    - Idea: use is-type
    - Structure: obj => int
|#
(def is-int obj = ((is-type int) obj))

#|
    ~ IS LIST ~
    - Idea: use is-type
    - Structure: obj => list
|#
(def is-list obj = ((is-type _list) obj))

;===================================================

#|
    ~ ERROR TRACING FUNCTION INPUT TYPE CHECKERS ~
    - Idea: Takes a function, its name, types of its arguments, and arguments
                to redefine function with ability to handle and propagate errors
|#

#|
    ~ SINGLE ARG FUNCTION TYPE CHECK ~
    - Contract: (func, funcName, type, arg) => func
    - Idea: Returns error if inputs is not right type, else runs function
    - Logic: If passed input is right type
                then run function
                else if error was passed
                        then chain passed error with new error
                        else pass new error
|#
(def type-check func func-name param-type param = 
    ; make/chain errors for arg if needed
    (_let err-msg = (wrap func-name (err-read (param-err-type param-type)))
    (_let err = ((make-error param-type) err-msg)
    (_let chain-errs = ((make-error param-type) (string-append (err-read param) "->" err-msg))
        ; check types
        (_if ((is-type param-type) param)
             _then (func param)
            _else (_if (is-error param)
                _then chain-errs
                _else err))))))

#|
    ~ DOUBLE ARG FUNCTION TYPE CHECK ~
    - Contract: (func, funcName, type, type, arg, arg) => func
    - Idea: Returns error if inputs are not right type, else runs function
    - Logic: If passed inputs are right type
                then run function
                else if error was passed
                        then chain passed error with new error
                        else pass new error
            note: fails early to chain errors from first failure on up
|#
(def type-check2 func func-name param-type1 param-type2 param1 param2 = 
    ; make/chain errors for arg 1 if needed
    (_let err-msg1 = (wrap func-name (wrap "arg1" (err-read (param-err-type param-type1))))
    (_let err1 = ((make-error param-type1) err-msg1)
    (_let chain-errs1 = ((make-error param-type1) (string-append (err-read param1) "->" err-msg1))
    ; make/chain errors for arg 2 if needed
    (_let err-msg2 = (wrap func-name (wrap "arg2" (err-read (param-err-type param-type2))))
    (_let err2 = ((make-error param-type2) err-msg2)
    (_let chain-errs2 = ((make-error param-type2) (string-append (err-read param2) "->" err-msg2))
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
    (_if ((eq bool) param-type)
        _then BOOL-ERROR
        _else (_if ((eq nat) param-type)
                _then NAT-ERROR
                _else (_if ((eq int) param-type)
                        _then INT-ERROR
                        _else ERROR))))

#|
    ~ MAKE F TYPED ~
    - Idea: Add type to the functions based on their return type
|#
; For One Argument Functions
(def make-typed-func func param func-type = ((make-obj func-type) (func (val param))))

; For Two Argument Functions
(def make-typed-func-2 func param1 param2 func-type = ((make-obj func-type) ((func (val param1)) (val param2))))


#|
    ~ MAKE F TYPED AND CHECKED ~
    - Idea: transform our untyped functions to fully typed
                let's do this!
|#
; For One Argument Functions
(def fully-type func func-name param-type param return-type = 
    ((((type-check 
        (lambda (param) (((make-typed-func func) param) return-type)))
        func-name) param-type) param))

; For Two Argument Functions
(def fully-type2 func func-name param-type1 param1 param-type2 param2 return-type = 
    ((((((type-check2
        (lambda (param1)
            (lambda (param2)
                ((((make-typed-func-2 func) param1) param2) return-type)))) 
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


(def read-error E = (tail (tail E)))
(def read-bool B = (((val B) "bool:TRUE") "bool:FALSE"))
(def read-nat N = (string-append "nat:" (n-read (val N))))
(def read-int Z = (string-append "int:" (z-read (val Z))))
(def read-list L = (string-append "list:" (l-read (val Z))))

(def read-any OBJ = 
    (_if (is-bool OBJ)
        _then (read-bool OBJ)
        _else (
            _if (is-nat OBJ)
            _then (read-nat OBJ)
            _else (
                _if (is-int OBJ)
                _then (read-int OBJ)
                _else (
                    _if (is-list OBJ)
                    _then (read-list OBJ)
                    _else (read-error OBJ)
                )
            )
        )
    )
)


;===================================================