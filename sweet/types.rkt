#lang lazy
(provide (all-defined-out))
(require "church.rkt"
         "division.rkt"
         "integers.rkt"
         "lists.rkt"
         "logic.rkt"
         "macros.rkt")

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
    ~ TYPED OBJECT MAKERS ~
    - Idea: each type will be a church numeral
|#

;   Makes Error Type Objects
;   - Contract: (val) => ERROR
(def makeErr val = ((makeObj errorType) val))
(def makeErrErr errMsg = (makeErr (makeErr errMsg)))

;   Makes Bool Type Objects
;   - Contract: (val) => bool
(def makeBool val = ((makeObj boolType) val))
(def makeBoolErr errMsg = (makeErr (makeBool errMsg)))

;   Makes Natural Number Type Objects
;   - Contract: (val) => nat
(def makeNat val = ((makeObj natType) val))
(def makeNatErr errMsg = (makeErr (makeNat errMsg)))

;   Makes Integer Number Type Objects
;   - Contract: (val) => int
(def makeInt val = ((makeObj intType) val))
(def makeIntErr errMsg = (makeErr (makeInt errMsg)))

;   Makes Any Error Type Object
;   - Contract (type, errMsg) => {error, {type, errMsg}}
(def makeSomeErr type errMsg = (makeErr (pair type errMsg)))

;===================================================

#|
    ~ ERROR OBJECTS ~
    - Idea: Errors to return when type checking
|#

;   Universal Error Type Object
;   - Idea: has type and val as pair(errorType,'ERROR')
(define ERROR (makeErrErr "err:err"))

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
    ~ NOT (TYPED) ~
    - Contract: BOOL => BOOL/BOOL_ERROR
    - Logic: if (isBool x)
                    then makeBool (not (val x))
                    else BOOL_ERROR
|#
(def NOT_MAIN B = 
    (_if (isBool B)
        _then (makeBool (_not (val B)))
        _else BOOL_ERROR))

#|
    ~ AND (TYPED) ~
    - Contract: (BOOL,BOOL) => BOOL/BOOL_ERROR
    - Logic: if (and (isBool x)(isBool y))
                    then makeBool (and (val x)(val y))
                    else BOOL_ERROR
|#
(def AND_MAIN B1 B2 = 
    (_if ((_and (isBool B1)) (isBool B2))
        _then (makeBool ((_and (val B1)) (val B2)))
        _else BOOL_ERROR))


(def AND B1 B2 = 
    (_let funcErr = (makeBoolErr (wrap "AND" (E-READ BOOL_ERROR)))
        (_if (isError B1)
            _then B1
            _else (_if (isError B2)
                    _then B2
                    _else (_if ((_and (isBool B1)) (isBool B2))
                            _then (makeBool ((_and (val B1)) (val B2)))
                            _else funcErr)))))

;===================================================

#|
    ~ IS ZERO
|#

; 1. ORIGINAL
; (def IS_ZERO N = 
;     (_if (isNat N)
;         _then (_if (isZero (val N))
;                 _then TRUE
;                 _else FALSE)
;         _else NAT_ERROR))

;===================================================

; 2. ERROR PROPAGATING
; (def IS_ZERO N = 
;     (_let funcErr = (makeNatErr (wrap " IS_ZERO(" (E-READ NAT_ERROR)))
;         (_if (isError N)
;             _then N
;             _else (_if (isNat N)
;                     _then (_if (isZero (val N))
;                             _then TRUE
;                             _else FALSE)
;                     _else funcErr))))

;===================================================

; 3. ERROR PROPAGATING WITH MAIN
; (def IS_ZERO N = 
;     (_let funcErr = (makeNatErr (wrap " IS_ZERO(" (E-READ NAT_ERROR)))
;         (_if (isError N)
;             _then N
;             _else ((IS_ZERO_MAIN funcErr) N))))

; (def IS_ZERO_MAIN ERR N = 
;     (_if (isNat N)
;         _then (_if (isZero (val N))
;                 _then TRUE
;                 _else FALSE)
;         _else ERR))


;===================================================

; 4. ERROR PROPAGATING WITH MAIN AND PROPAGATOR
;   - generalized solution for single argument functions
;   - get to maintain original function without alteration

(def ERR-TYPE-FROM-ARG ARG =
    (_if ((eq boolType) ARG)
        _then BOOL_ERROR
        _else (_if ((eq natType) ARG)
                _then NAT_ERROR
                _else (_if ((eq intType) ARG)
                        _then INT_ERROR
                        _else ERROR))))

; SINGLE ARG ERROR PROPAGATION
(def ADD_ERR_PROP FUNC FUNC-NAME ARG-TYPE X = 
    (_let errMsg = (wrap FUNC-NAME (E-READ (ERR-TYPE-FROM-ARG ARG-TYPE)))
        (_let errType = (makeErr ((makeObj ARG-TYPE) errMsg))
            (_let chainErrs = (makeErr ((makeObj ARG-TYPE) (chain (E-READ X) errMsg)))
                (_if ((isType ARG-TYPE) X)
                    _then (FUNC X)
                    _else (_if (isError X)
                            _then chainErrs
                            _else errType))))))

; MAIN LOGIC FUNCTION
(def IS_ZERO_MAIN N = 
    (_if (isNat N)
        _then (_if (isZero (val N))
                _then TRUE
                _else FALSE)
        _else NAT_ERROR))


(def IS_ZERO N = ((((ADD_ERR_PROP IS_ZERO_MAIN) "IS_ZERO") natType) N))

; try generic single arg error prop with NOT function
(def NOT B = ((((ADD_ERR_PROP NOT_MAIN) "NOT") boolType) B))


;===================================================

#|
    need to define 
        - the rest of the logical operators
        - numerical operators
        - E-read, B-read, N-read
|#

(def E-READ E = (tail (tail E)))

(def B-READ B = 
    (_if (isError B)
        _then (E-READ B)
        _else 
            (_if (isBool B)
                _then (((val B) "bool:TRUE") "bool:FALSE")
                _else (E-READ BOOL_ERROR))))

(def N-READ N = 
    (_if (isNat N)
        _then (s-a "nat:" (n-s (n-read (val N))))
        _else (E-READ NAT_ERROR)))

(def Z-READ Z = 
    (_if (isError Z)
        _then Z
        _else 
            (_if (isInt Z)
                _then (s-a "int:" (n-s (z-read (val Z))))
                _else (E-READ INT_ERROR))))