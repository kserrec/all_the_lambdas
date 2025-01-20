#lang lazy
(provide (all-defined-out))
(require racket/string)
(require "../../macros/macros.rkt")
(require "../../church.rkt"
         "../../core.rkt"
         "../../division.rkt"
         "../../integers.rkt"
         "../../lists.rkt"
         "../../logic.rkt"
         "../../rationals.rkt"
         "../TYPES.rkt")


;===================================================
; TYPES - coercive
;===================================================

#|

    This is a different approach to typing in the untyped lambda calculus than seen in the main TYPES.rkt file.
    Instead of being strict, functions will coerce values to be the type required for sensible operation on them.
    This feels more natural in the lambda calculus and still permits most everything while nevertheless providing some guardrails (like no division by zero).
    
    Note: The basic structure of each typed object will remain the same and be inherited from the main TYPES file. 

    Approach to converting to...
        bool: truthy/false: if value is zero or nil => false, else true
        nat: 
            - bool? false => zero, true => one
            - int? drop sign
            - list? nil => zero, else length
            - rat? floor and make positive
        int: 
            - bool? false => zero, true => posOne
            - nat? add positive sign
            - list? nil => zero, else length with positive sign
            - rat? floor and take numerator
        list: 
            - bool? false => nil, true => [true]  
            - nat? zero => nil, else [nat]
            - int? zero => nil, else [int]
            - rat? zero => nil, else [rat]
        rat: 
            - bool? false => zero, true => posOne/one
            - nat? add positive sign and make it numerator over one
            - int? make it numerator over one
            - list? nil => zero, else length with positive sign over one

    Notice I am not bothering with any fancy list operations - no zipping or adding parts when adding lists, 
        simply converting to length. List information is thus lost if used wrong, but this keeps things easy.
|#

#|
    DIRECT VALUE CONVERSION HELPERS
    note: these work on the values of typed objects, not typed objects themselves
|# 

; CONVERT TO bool
(def bool-to-bool b = b)
(def nat-to-bool n = (_not (isZero n)))
(def int-to-bool z = (_not (isZeroZ z)))
(def list-to-bool lst = (_not (isNil lst)))
(def rat-to-bool r = (_not (isZeroR r)))

; CONVERT TO nat
(def bool-to-nat b = ((b one) zero))
(def nat-to-nat n = n)
(def int-to-nat z = (tail z))
(def list-to-nat lst = (len lst))
(def rat-to-nat r = (tail (head (floorR r))))

; CONVERT TO int
(def bool-to-int b = ((makeZ true) (bool-to-nat b)))
(def nat-to-int n = ((makeZ true) n))
(def int-to-int z = z)
(def list-to-int lst = ((makeZ true) (list-to-nat lst)))
(def rat-to-int r = ((makeZ (r-sign r)) (rat-to-nat r)))

; CONVERT TO list
(def bool-to-list b = ((b (_cons true)) nil))
(def nat-to-list n = (((isZero n) nil) (_cons n)))
(def int-to-list z = (((isZeroZ z) nil) (_cons z)))
(def list-to-list lst = lst)
(def rat-to-list r = (((isZeroR r) nil) (_cons r)))

; CONVERT TO rat
(def bool-to-rat b = ((makeR2 (bool-to-int b)) one))
(def nat-to-rat n = ((makeR2 (nat-to-int n)) one))
(def int-to-rat z = ((makeR2 z) one))
(def list-to-rat lst = (((makeR true) (len lst)) one))
(def rat-to-rat r = r)

; this gives an already typed function a generic type value so it can then be stripped off for use in coersion functions below - "fake" typing for convenience
(def func F = ((pair false) F))

#|
    TYPED OBJECT CONVERSION FUNCTIONS
|#
; TO BOOL
(def convert-to-bool OBJ = 
    (_let default-bool = false
    (_let value = (val OBJ)
    (make-bool (
        _if (is-bool OBJ) ; bool?
        _then (bool-to-bool value)
        _else (
            _if (is-nat OBJ) ; nat? 
            _then (nat-to-bool value)
            _else (
                _if (is-int OBJ) ; int?
                _then (int-to-bool value)
                _else (
                    _if (is-list OBJ) ; list?
                    _then (list-to-bool value)
                    _else (
                        _if (is-rat OBJ) ; rat?
                        _then (rat-to-bool value)
                        _else default-bool)))))))))

; TO NAT
(def convert-to-nat OBJ = 
    (_let default-nat = zero 
    (_let value = (val OBJ)
    (make-nat (
        _if (is-bool OBJ) ; bool?
        _then (bool-to-nat value)
        _else (
            _if (is-nat OBJ) ; nat?
            _then (nat-to-nat value)
            _else (
                _if (is-int OBJ) ; int?
                _then (int-to-nat value)
                _else (
                    _if (is-list OBJ) ; list?
                    _then (list-to-nat value)
                    _else (
                        _if (is-rat OBJ) ; rat?
                        _then (rat-to-nat value)
                        _else default-nat)))))))))

; TO INT
(def convert-to-int OBJ = 
    (_let default-int = (nat-to-int zero)
    (_let value = (val OBJ)
    (make-int (
        _if (is-bool OBJ) ; bool?
        _then (bool-to-int value)
        _else (
            _if (is-nat OBJ) ; nat?
            _then (nat-to-int value)
            _else (
                _if (is-int OBJ) ; int?
                _then (int-to-int value)
                _else (
                    _if (is-list OBJ) ; list?
                    _then (list-to-int value)
                    _else (
                        _if (is-rat OBJ) ; rat?
                        _then (rat-to-int value)
                        _else default-int)))))))))

; TO LIST
(def convert-to-list OBJ = 
    (_let default-list = nil
    (_let value = (val OBJ)
    (make-int (
        _if (is-bool OBJ) ; bool?
        _then (bool-to-list value)
        _else (
            _if (is-nat OBJ) ; nat?
            _then (nat-to-list value)
            _else (
                _if (is-int OBJ) ; int?
                _then (int-to-list value)
                _else (
                    _if (is-list OBJ) ; list?
                    _then (list-to-list value)
                    _else (
                        _if (is-rat OBJ) ; rat?
                        _then (rat-to-list value)
                        _else default-list)))))))))

; TO RAT
(def convert-to-rat OBJ = 
    (_let default-rat = (nat-to-rat zero)
    (_let value = (val OBJ)
    (make-rat (
        _if (is-bool OBJ) ; bool?
        _then (bool-to-rat value)
        _else (
            _if (is-nat OBJ) ; nat?
            _then (nat-to-rat value)
            _else (
                _if (is-int OBJ) ; int?
                _then (int-to-rat value)
                _else (
                    _if (is-list OBJ) ; list?
                    _then (list-to-rat value)
                    _else (
                        _if (is-rat OBJ) ; rat?
                        _then (rat-to-rat value)
                        _else default-rat)))))))))


#|
    COERCIVE FUNCTION BUILDERS
|#
(def COERCE-1 func convert-func OBJ out-type =
    (_let coerced-OBJ = (convert-func OBJ)
    (_let res = (func (val coerced-OBJ))
    ((pair out-type) res))))

; function of two arguments of same type
(def COERCE-2 func convert-func OBJ1 OBJ2 out-type =
    (_let coerced-OBJ1 = (convert-func OBJ1)
    (_let coerced-OBJ2 = (convert-func OBJ2)
    (_let res = ((func (val coerced-OBJ1)) (val coerced-OBJ2))
    ((pair out-type) res)))))

; function of two arguments of different type
(def COERCE-2-diff func convert-func1 OBJ1 convert-func2 OBJ2 out-type =
    (_let coerced-OBJ1 = (convert-func1 OBJ1)
    (_let coerced-OBJ2 = (convert-func2 OBJ2)
    (_let res = ((func (val coerced-OBJ1)) (val coerced-OBJ2))
    ((pair out-type) res)))))

(def COERCE-3 func convert-func OBJ1 OBJ2 OBJ3 out-type =
    (_let coerced-OBJ1 = (convert-func OBJ1)
    (_let coerced-OBJ2 = (convert-func OBJ2)
    (_let coerced-OBJ3 = (convert-func OBJ3)
    (_let res = (((func (val coerced-OBJ1)) (val coerced-OBJ2)) (val coerced-OBJ3))
    ((pair out-type) res))))))

(def COERCE-4 func convert-func OBJ1 OBJ2 OBJ3 OBJ4 out-type =
    (_let coerced-OBJ1 = (convert-func OBJ1)
    (_let coerced-OBJ2 = (convert-func OBJ2)
    (_let coerced-OBJ3 = (convert-func OBJ3)
    (_let coerced-OBJ4 = (convert-func OBJ4)
    (_let res = ((((func (val coerced-OBJ1)) (val coerced-OBJ2)) (val coerced-OBJ3)) (val coerced-OBJ4))
    ((pair out-type) res)))))))


(def COND B = ((((COERCE-1 _identity) convert-to-bool) B) bool))


