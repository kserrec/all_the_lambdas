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
(def makeObj type val = ((pair type) val))

#|
    ~ SELECTION FUNCTIONS ~
    - Idea: select type or value
    - Structure: (type,val) => {type,val}
    - Logic: just a pair function
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
(define errorType zero)
;   BOOLEAN
(define boolType one)
;   NATURAL NUMBER
(define natType two)
;   INT NUMBER
(define intType three)

;===================================================

#|
    ~ SPECIFIC TYPED OBJECT MAKERS ~
    - Idea: 
        - each type will be a church numeral
        - typed objects are pairs {type, val}
        - error-typed objects will store messages as nested pairs
            - e.g. {errorType, {type, msg}}
|#

;   Makes Error Type Objects
;   - Contract: (val) => ERROR
(def setErr val = ((makeObj errorType) val))
(def setErrErr errMsg = (setErr (setErr errMsg)))

;   Makes Bool Type Objects
;   - Contract: (val) => bool
(def makeBool val = ((makeObj boolType) val))
(def makeBoolErr errMsg = (setErr (makeBool errMsg)))

;   Makes Natural Number Type Objects
;   - Contract: (val) => nat
(def makeNat val = ((makeObj natType) val))
(def makeNatErr errMsg = (setErr (makeNat errMsg)))

;   Makes Integer Number Type Objects
;   - Contract: (val) => int
(def makeInt val = ((makeObj intType) val))
(def makeIntErr errMsg = (setErr (makeInt errMsg)))

;   Makes Any Error Type Object
;   - Contract (type, errMsg) => {error, {type, errMsg}}
(def makeSomeErr type errMsg = (setErr (pair type errMsg)))

;===================================================

#|
    ~ ERROR OBJECTS ~
    - Idea: Errors to return when type checking
|#

;   Universal Error Type Object
;   - Idea: has type and val as pair(errorType,'ERROR')
(define ERROR (setErrErr "err:err"))

;   Boolean Error Type Object
;   - Idea: has type error and val as boolType
(define BOOL_ERROR (makeBoolErr "err:bool"))

;   Nat Error Type Object
;   - Idea: has type error and val as natType
(define NAT_ERROR (makeNatErr "err:nat"))

;   Int Error Type Object
;   - Idea: has type error and val as natType
(define INT_ERROR (makeIntErr "err:int"))

;===================================================

#|
    ~ TYPE CHECKING ~
|#

#|
    ~ CHECKS TYPE ~
    - Idea: checks if object passed is given type
    - Structure: (type,obj) => bool
|#
(def isType type obj = ((eq (head obj)) type))

#|
    ~ IS ERROR ~
    - Idea: use isType
    - Structure: obj => bool
|#
(def isError obj = ((isType errorType) obj))

#|
    ~ IS BOOL ~
    - Idea: use isType
    - Structure: obj => bool
|#
(def isBool obj = ((isType boolType) obj))

#|
    ~ IS NAT ~
    - Idea: use isType
    - Structure: obj => nat
|#
(def isNat obj = ((isType natType) obj))

#|
    ~ IS INT ~
    - Idea: use isType
    - Structure: obj => int
|#
(def isInt obj = ((isType intType) obj))

;===================================================

#|
    ~ ERROR PROPAGATORS ~
    - Idea: Takes function, its name, types of its arguments, and arguments
                to redefine function with ability to handle and propagate errors
|#

#|
    ~ SINGLE ARG ERROR PROPAGATION ~
    - Idea: Built for functions which take one argument
    - Contract: (func, funcName, type, arg) => func
|#
(def ADD_TYPE_CHECK FUNC FUNC-NAME ARG-TYPE X = 
    ; make/chain errors for arg if needed
    (_let errMsg = (wrap FUNC-NAME (E-READ (ERR-T-ARG ARG-TYPE)))
    (_let errType = (setErr ((makeObj ARG-TYPE) errMsg))
    (_let chainErrs = (setErr ((makeObj ARG-TYPE) (chain (E-READ X) errMsg)))
        ; check types
        (_if ((isType ARG-TYPE) X)
             _then (FUNC X)
            _else (_if (isError X)
                _then chainErrs
                _else errType))))))

#|
    ~ DOUBLE ARG ERROR PROPAGATION ~
    - Idea: Built for functions which take two arguments
    - Contract: (func, funcName, type, type, arg, arg) => func
|#
(def ADD_TYPE_CHECK2 FUNC FUNC-NAME ARG-T1 ARG-T2 X1 X2 = 
    ; make/chain errors for arg 1 if needed
    (_let errMsg1 = (wrap FUNC-NAME (wrap "arg1" (E-READ (ERR-T-ARG ARG-T1))))
    (_let errType1 = (setErr ((makeObj ARG-T1) errMsg1))
    (_let chainErrs1 = (setErr ((makeObj ARG-T1) (chain (E-READ X1) errMsg1)))
    ; make/chain errors for arg 2 if needed
    (_let errMsg2 = (wrap FUNC-NAME (wrap "arg2" (E-READ (ERR-T-ARG ARG-T2))))
    (_let errType2 = (setErr ((makeObj ARG-T2) errMsg2))
    (_let chainErrs2 = (setErr ((makeObj ARG-T2) (chain (E-READ X2) errMsg2)))
        ; check types
        (_if ((isType ARG-T1) X1)
            _then (_if ((isType ARG-T2) X2)
                    _then ((FUNC X1) X2)
                    _else (_if (isError X2)
                            _then chainErrs2
                            _else errType2))
            _else (_if (isError X1)
                    _then chainErrs1
                    _else errType1)))))))))

#|
    ~ GETS ERROR TYPE BY ARG TYPE ~
    - Idea: Takes an argument type and returns related error type
    - Contract: TYPE => ERROR
|#
(def ERR-T-ARG ARG-TYPE =
    (_if ((eq boolType) ARG-TYPE)
        _then BOOL_ERROR
        _else (_if ((eq natType) ARG-TYPE)
                _then NAT_ERROR
                _else (_if ((eq intType) ARG-TYPE)
                        _then INT_ERROR
                        _else ERROR))))


;===================================================

#|
    ~ READ TYPED VALUES ~
|#

#|
    ~ READ ERROR MESSAGES ~
|#
(def E-READ E = (tail (tail E)))

#|
    ~ TYPE CHECKING HELPER FOR READING TYPED VALUES ~
    - Idea: Protects typed reader if passed wrong type, reads as error
    - Contract: (FUNC, OBJ) => READ(TYPE)
|#
(def T-READ FUNC OBJ = 
    (_if (isError OBJ)
        _then (E-READ OBJ)
        _else (FUNC OBJ)))

#|
    ~ READS INT TYPED VALUES ~
    - Contract: INT => READ(INT)
|#
(def _Z-READ Z = 
    (_if (isInt Z)
        _then (s-a "int:" (n-s (z-read (val Z))))
        _else (E-READ INT_ERROR)))

(def Z-READ Z = ((T-READ _Z-READ) Z))

;===================================================

#|
    need to define 
        - the rest of the logical operators
        - numerical operators
|#