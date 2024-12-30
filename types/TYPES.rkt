#lang lazy
(provide (all-defined-out))
(require racket/string)
(require "../macros/macros.rkt")
(require "../church.rkt"
         "../division.rkt"
         "../integers.rkt"
         "../lists.rkt"
         "../logic.rkt")

;===================================================

; ~ HELPER FUNCTIONS ~

; wraps function names around errors for error tracing
(define (wrap funcName err) (string-append funcName "(" err ")"))

; rewrites typed lists more nicely
(define (transform-string s)
  ; Find positions using substring search
  (define bracket-pos 
    (let loop ([i 0])
      (if (char=? (string-ref s i) #\[)
          i
          (loop (add1 i)))))
          
  (define colon-pos
    (let loop ([i (add1 bracket-pos)])
      (if (char=? (string-ref s i) #\:)
          i
          (loop (add1 i)))))
          
  (define key (substring s (add1 bracket-pos) colon-pos))
  (define key+colon (string-append ":" key))
  
  ; Remove all instances of "type:"
  (define removed
    (regexp-replace* (regexp (regexp-quote (string-append key ":"))) s ""))
    
  ; Insert type after "list"
  (define list-end 4) ; "list" is 4 chars
  (string-append 
    (substring removed 0 list-end)
    key+colon
    (substring removed list-end)))

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
(def _error = zero)
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
        - _error objects will store messages as nested pairs
            - e.g. {_error, {type, msg}}
|#

;   MAKE ERROR OBJECT FUNCTIONS

;   Makes An Error Type Object
;   - Contract: error-val => ERROR
(def set-error val = ((make-obj _error) val))

;   Makes Any Kind of Error Type Object
;   - Contract (type, err-msg) => {error, {type, err-msg}}
(def make-error type err-msg = (set-error ((pair type) err-msg)))


;   - Specific error makers
(def make-err-err err-msg = ((make-error _error) err-msg))

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
;   - Idea: has type and val as pair(_error,'ERROR')
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
;   - Contract: (type, val) => LIST
;   - Logic: maps over untyped list to make it typed
(def _make-list type val = ((make-obj _list) ((_map (make-obj type)) val)))


(def untype-elements L = ((make-obj _list) ((_map val) (val L))))

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
(def is-error obj = ((is-type _error) obj))

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
    - Contract: (func, funcName, type, param) => func
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
    - Contract: (func, funcName, type, type, param, param) => func
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
    ~ TRIPLE ARG FUNCTION TYPE CHECK ~
    - Contract: (func, funcName, type, type, type, param, param, param) => func
    - Idea: Returns error if inputs are not right type, else runs function
    - Logic: If passed inputs are right type
                then run function
                else if error was passed
                        then chain passed error with new error
                        else pass new error
            note: fails early to chain errors from first failure on up
|#
(def type-check3 func func-name param-type1 param-type2 param-type3 param1 param2 param3 = 
    ; make/chain errors for param 1 if needed
    (_let err-msg1 = (wrap func-name (wrap "arg1" (err-read (param-err-type param-type1))))
    (_let err1 = ((make-error param-type1) err-msg1)
    (_let chain-errs1 = ((make-error param-type1) (string-append (err-read param1) "->" err-msg1))
    ; make/chain errors for param 2 if needed
    (_let err-msg2 = (wrap func-name (wrap "arg2" (err-read (param-err-type param-type2))))
    (_let err2 = ((make-error param-type2) err-msg2)
    (_let chain-errs2 = ((make-error param-type2) (string-append (err-read param2) "->" err-msg2))
    ; make/chain errors for param 3 if needed
    (_let err-msg3 = (wrap func-name (wrap "arg3" (err-read (param-err-type param-type3))))
    (_let err3 = ((make-error param-type2) err-msg3)
    (_let chain-errs3 = ((make-error param-type3) (string-append (err-read param3) "->" err-msg3))
        ; check types
        (_if ((is-type param-type1) param1)
            _then (_if ((is-type param-type2) param2)
                    _then (_if ((is-type param-type3) param3)
                            _then (((func param1) param2) param3)
                            _else (_if (is-error param3)
                                    _then chain-errs3
                                    _else err3))
                    _else (_if (is-error param2)
                            _then chain-errs2
                            _else err2))
            _else (_if (is-error param1)
                    _then chain-errs1
                    _else err1))))))))))))


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
                        _else (_if ((eq _list) param-type)
                                _then LIST-ERROR
                                _else ERROR)))))

#|
    ~ MAKE F TYPED ~
    - Idea: Add type to the functions based on their return type
|#
; For One Argument Functions
(def make-typed-func func param return-type = ((make-obj return-type) (func (val param))))

; For Two Argument Functions
(def make-typed-func-2 func param1 param2 return-type = ((make-obj return-type) ((func (val param1)) (val param2))))

; For Three Argument Functions
(def make-typed-func-3 func param1 param2 param3 return-type = ((make-obj return-type) (((func (val param1)) (val param2)) (val param3))))

(def keep-typed-func-3 func param1 param2 param3 = (((func (val param1)) (val param2)) (val param3)))

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

; For Three Argument Functions
(def fully-type3 func func-name param-type1 param1 param-type2 param2 param-type3 param3 return-type = 
    ((((((((type-check3
        (lambda (param1)
            (lambda (param2)
                (lambda (param3)
                    (((((make-typed-func-3 func) param1) param2) param3) return-type)))))
        func-name) param-type1) param-type2) param-type3) param1) param2) param3))

; don't package up object with type value, because it already is a typed value like fully-type3
(def keep-typed3 func func-name param-type1 param1 param-type2 param2 param-type3 param3 return-type = 
    ((((((((type-check3
        (lambda (param1)
            (lambda (param2)
                (lambda (param3)
                    ((((keep-typed-func-3 func) param1) param2) param3)))))
        func-name) param-type1) param-type2) param-type3) param1) param2) param3))

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
(def read-list L = (transform-string (string-append "list" ((l-read (val L)) read-any))))
; (def read-list L = (string-append "list" ((l-read (val L)) read-any)))

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