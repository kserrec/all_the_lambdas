#lang lazy
(provide (all-defined-out))
(require racket/string)
(require "../church.rkt"
         "../core.rkt"
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

(def NIL-list = ((pair _list) nil))

;===================================================

(def LEN L = (((((fully-type len) "LEN") _list) L) nat))

;===================================================

(def IS-NIL L = (((((fully-type isNil) "IS-NIL") _list) L) bool))

;===================================================

; have to use untype-elements because fully-type-f adds types to elements so sub elements cannot go in already typed
(def IND L I = (((((((fully-type2 ind) "IND") _list) (untype-elements L)) nat) I) (type (head (val L)))))

;===================================================

(def APP L1 L2 = (((((((fully-type2 app) "APP") _list) L1) _list) L2) _list))

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
                        ; if an error occurs, put error into list - do NOT filter it, expose it
                        (_if (is-error (g x))
                            _then ((pair (g x)) (((f g) y) n))
                            ; else do regular filter check and keep if passes, else remove
                            _else (_if (val (g x))
                                    _then ((pair x) (((f g) y) n))
                                    _else (((f g) y) n))
                        )
                    )
                )  
            ))  n))

(def FILTER G L = (((((((fully-type2 _filter-helper-typed) "FILTER") bool) ((make-obj bool) G)) _list) L) _list))

(def FOLD-HELPER G X L = (((((((((keep-typed3 _fold) "FOLD") bool) ((make-obj bool) G)) (type X)) ((make-obj (type X)) X)) _list) L) (type X)))

(def wrap-FOLD-only-once res = 
    ((lambda (msg)
        ((lambda (x) (if x msg (wrap "FOLD" msg)))
         (string-contains? msg "FOLD")))
     (err-read res)))

(def FOLD G X L = 
    (_let result = (((FOLD-HELPER G) X) L)
        (_if (is-error result)
            _then ((make-error (head (val result))) (wrap-FOLD-only-once result))
            _else result
        )
    )
)
;===================================================

(def TAKE N L = (((((((fully-type2 _take) "TAKE") nat) N) _list) L) _list))

(def TAKE-TAIL N L = (((((((fully-type2 takeTail) "TAKE-TAIL") nat) N) _list) L) _list))

;===================================================

(def INSERT-HELPER X L I = 
    ((APP
        ((TAKE I) L))
        ((pair _list) ((pair X) (val ((TAKE-TAIL ((SUB (LEN L)) I)) L))))))

(def INSERT X L I = ((((((((type-check3 INSERT-HELPER) "INSERT") (type X)) _list) nat) X) L) I))

;===================================================

(def REPLACE-HELPER X L I = 
    ((APP
        ((TAKE I) L))
        ((pair _list) ((pair X) (val ((TAKE-TAIL (PRED ((SUB (LEN L)) I))) L))))))

(def REPLACE X L I = ((((((((type-check3 REPLACE-HELPER) "REPLACE") (type X)) _list) nat) X) L) I))

;===================================================

(def DROP N L = (((((((fully-type2 _drop) "DROP") nat) N) _list) L) _list))

;===================================================





