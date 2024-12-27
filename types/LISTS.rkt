#lang lazy
(provide (all-defined-out))
(require "../church.rkt"
         "../integers.rkt"
         "../lists.rkt"
         "../logic.rkt"
         "../macros/macros.rkt")
(require "CHURCH.rkt"
         "INTEGERS.rkt"
         "LOGIC.rkt"
         "TYPES.rkt")

;===================================================

; helper functions

(def un-type obj = (val obj))

(def un-type-elements L = ((make-obj _list) ((_map un-type) (un-type L))))

;===================================================

; just testing things out here 

(def l-0 = ((pair zero) nil))
(def l-5 = ((pair five) nil))
(def l-2 = ((pair two) nil))
(def l-3 = ((pair three) nil))

(def l-0-5-2-3 = ((app ((app ((app l-0) l-5)) l-2)) l-3))

(def LIST-0 = ((_make-list nat) l-0))

(def LIST-0-5-2-3 = ((_make-list nat) l-0-5-2-3))

;===================================================

; TYPED NILs
(def make-NIL type ((_make-list type) nil))

(def NIL-error = (make-NIL _error))
(def NIL-bool = (make-NIL bool))
(def NIL-nat = (make-NIL nat))
(def NIL-int = (make-NIL int))
(def NIL-list = (make-NIL _list))

;===================================================

(def LEN L = (((((fully-type len) "LEN") _list) L) nat))

(def IS-NIL L = (((((fully-type isNil) "IS-NIL") _list) L) bool))

; have to use un-type-els because fully-type-f adds types to elements so sub elements cannot go in already typed
(def IND L I = (((((((fully-type2 ind) "IND") _list) (un-type-els L)) nat) I) nat))

(def APP L1 L2 = (((((((fully-type2 app) "APP") _list) L1) _list) L2) _list))

(def REV L = (((((fully-type rev) "REV") _list) L) _list))