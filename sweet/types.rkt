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

; ERROR PROPAGATING WITH MAIN AND PROPAGATOR
;   - generalized solution for single argument functions
;   - get to maintain original function without alteration

(def ERR-T-ARG ARG =
    (_if ((eq boolType) ARG)
        _then BOOL_ERROR
        _else (_if ((eq natType) ARG)
                _then NAT_ERROR
                _else (_if ((eq intType) ARG)
                        _then INT_ERROR
                        _else ERROR))))

; SINGLE ARG ERROR PROPAGATION
(def ADD_ERR_PROP FUNC FUNC-NAME ARG-TYPE X = 
    ; make/chain errors for arg if needed
    (_let errMsg = (wrap FUNC-NAME (E-READ (ERR-T-ARG ARG-TYPE)))
    (_let errType = (makeErr ((makeObj ARG-TYPE) errMsg))
    (_let chainErrs = (makeErr ((makeObj ARG-TYPE) (chain (E-READ X) errMsg)))
        ; check types
        (_if ((isType ARG-TYPE) X)
             _then (FUNC X)
            _else (_if (isError X)
                _then chainErrs
                _else errType))))))


; DOUBLE ARG ERROR PROPAGATION
(def ADD_ERR_PROP2 FUNC FUNC-NAME ARG-T1 ARG-T2 X1 X2 = 
    ; make/chain errors for arg 1 if needed
    (_let errMsg1 = (wrap FUNC-NAME (wrap "arg1" (E-READ (ERR-T-ARG ARG-T1))))
    (_let errType1 = (makeErr ((makeObj ARG-T1) errMsg1))
    (_let chainErrs1 = (makeErr ((makeObj ARG-T1) (chain (E-READ X1) errMsg1)))
    ; make/chain errors for arg 2 if needed
    (_let errMsg2 = (wrap FUNC-NAME (wrap "arg2" (E-READ (ERR-T-ARG ARG-T2))))
    (_let errType2 = (makeErr ((makeObj ARG-T2) errMsg2))
    (_let chainErrs2 = (makeErr ((makeObj ARG-T2) (chain (E-READ X2) errMsg2)))
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


;===================================================

#|
    ~ NOT (TYPED) ~
    - Contract: BOOL => BOOL/BOOL_ERROR
    - Logic: if (isBool x)
                    then makeBool (not (val x))
                    else BOOL_ERROR
|#
(def _NOT B = 
    (_if (isBool B)
        _then (makeBool (_not (val B)))
        _else BOOL_ERROR))

(def NOT B = ((((ADD_ERR_PROP _NOT) "NOT") boolType) B))
#|
    ~ AND (TYPED) ~
    - Contract: (BOOL,BOOL) => BOOL/BOOL_ERROR
    - Logic: if (and (isBool x)(isBool y))
                    then makeBool (and (val x)(val y))
                    else BOOL_ERROR
|#

;===================================================
(def _AND B1 B2 = 
    (_if ((_and (isBool B1)) (isBool B2))
        _then (makeBool ((_and (val B1)) (val B2)))
        _else BOOL_ERROR))

(def AND M N = ((((((ADD_ERR_PROP2 _AND) "AND") boolType) boolType) M) N))
;===================================================


#|
    ~ IS ZERO
|#

(def _IS_ZERO N = 
    (_if (isNat N)
        _then (_if (isZero (val N))
                _then TRUE
                _else FALSE)
        _else NAT_ERROR))

(def IS_ZERO N = ((((ADD_ERR_PROP _IS_ZERO) "IS_ZERO") natType) N))
;===================================================

#|
    need to define 
        - the rest of the logical operators
        - numerical operators
        - E-read, B-read, N-read
|#

(def E-READ E = (tail (tail E)))

(def T-READ FUNC OBJ = 
    (_if (isError OBJ)
        _then (E-READ OBJ)
        _else (FUNC OBJ)))

(def _B-READ B = 
    (_if (isBool B)
        _then (((val B) "bool:TRUE") "bool:FALSE")
        _else (E-READ BOOL_ERROR)))
    
(def B-READ B = ((T-READ _B-READ) B))

(def _N-READ N = 
    (_if (isNat N)
        _then (s-a "nat:" (n-s (n-read (val N))))
        _else (E-READ NAT_ERROR)))

(def N-READ N = ((T-READ _N-READ) N))

(def _Z-READ Z = 
    (_if (isInt Z)
        _then (s-a "int:" (n-s (z-read (val Z))))
        _else (E-READ INT_ERROR)))

(def Z-READ Z = ((T-READ _Z-READ) Z))