#lang lazy
(provide (all-defined-out))
(require "../macros/macros.rkt")
(require "helpers/custom-type-funcs.rkt")
(require "../church.rkt"
         "../core.rkt"
         "../integers.rkt"
         "../lists.rkt"
         "../logic.rkt"
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

(def FILTER G L = (((((((fully-type2 custom-filter-typed) "FILTER") bool) ((make-obj bool) G)) _list) L) _list))

; Runs the underlying fold and labels an error that arises from *inside* it
; (e.g. applying G to a bad list element) with "FOLD" exactly once. Errors from
; the outer argument-type checks never reach here - keep-typed3/type-check3
; produce and label those itself - so the two error origins are told apart by
; which control-flow branch we are in, never by inspecting message text.
(def FOLD-inner G X L =
    (_let r = (((_fold G) X) L)
        (_if (is-error r)
            _then ((make-error (head (val r))) (wrap "FOLD" (err-read r)))
            _else r)))

(def FOLD G X L = (((((((((keep-typed3 FOLD-inner) "FOLD") bool) ((make-obj bool) G)) (type X)) ((make-obj (type X)) X)) _list) L) (type X)))
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





