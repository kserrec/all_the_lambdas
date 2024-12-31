#lang lazy
(provide (all-defined-out))
(require "../church.rkt"
         "../integers.rkt"
         "../lists.rkt"
         "../logic.rkt"
         "../macros/macros.rkt"
         "../recursion.rkt")
(require "CHURCH.rkt"
         "INTEGERS.rkt"
         "LOGIC.rkt"
         "TYPES.rkt")

;===================================================

; TYPED NILs

(def NIL-list = ((pair _list) false))

;===================================================

(def LEN L = (((((fully-type len) "LEN") _list) L) nat))

;===================================================

(def IS-NIL L = (((((fully-type isNil) "IS-NIL") _list) L) bool))

;===================================================

; have to use untype-elements because fully-type-f adds types to elements so sub elements cannot go in already typed
(def IND L I = (((((((fully-type2 ind) "IND") _list) (untype-elements L)) nat) I) (type (head (val L)))))

;===================================================

(def APP L1 L2 = 
        (_let GOOD-SO-FAR = (((((((fully-type2 app) "APP") _list) L1) _list) L2) _list)
        (_let DIFFERENT-LIST-TYPES = ((make-error _list) (wrap "APP" "err:lists must be same type"))
        (_let L1-1st-Element-Type = (type (head (val L1)))
        (_let L2-1st-Element-Type = (type (head (val L2)))
                ; if either is nil or both have same type, good to go
                (_if (val ((OR (IS-NIL L1)) (IS-NIL L2)))
                    _then GOOD-SO-FAR
                    _else (_if ((eq L1-1st-Element-Type) L2-1st-Element-Type)
                            _then GOOD-SO-FAR
                            _else DIFFERENT-LIST-TYPES)))))))

;===================================================

(def REV L = (((((fully-type rev) "REV") _list) L) _list))

;===================================================

(def MAP G L = (((((((fully-type2 _map) "MAP") bool) ((make-obj bool) G)) _list) L) _list))

;===================================================

(def _filter-helper-typed g lst = ((((Y filter-helper-typed) g) lst) nil))

(def filter-helper-typed f g lst n = 
    ((lst (lambda (x)
                (lambda (y)
                    (lambda (z)
                        (_if (val (g x))
                            _then ((pair x) (((f g) y) n))
                            _else (((f g) y) n)
                        )
                    )
                )  
            ))  n))

(def FILTER G L = (((((((fully-type2 _filter-helper-typed) "FILTER") bool) ((make-obj bool) G)) _list) L) _list))

(def FOLD G X L = (((((((((keep-typed3 _fold) "FOLD") bool) ((make-obj bool) G)) (type X)) ((make-obj (type X)) X)) _list) L) (type X)))
;===================================================

(def TAKE N L = (((((((fully-type2 _take) "TAKE") nat) N) _list) L) _list))

(def TAKE-TAIL N L = (((((((fully-type2 takeTail) "TAKE-TAIL") nat) N) _list) L) _list))

(def INSERT X L I = 
    ((APP
        ((TAKE I) L))
        ((pair _list) ((pair X) (val ((TAKE-TAIL ((SUB (LEN L)) I)) L))))))

(def REPLACE X L I = 
    ((APP
        ((TAKE I) L))
        ((pair _list) ((pair X) (val ((TAKE-TAIL (PRED ((SUB (LEN L)) I))) L))))))


(def DROP N L = (((((((fully-type2 _drop) "DROP") nat) N) _list) L) _list))

;===================================================





