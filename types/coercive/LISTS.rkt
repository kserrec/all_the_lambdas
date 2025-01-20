#lang lazy
(provide (all-defined-out))
(require "../../church.rkt"
         "../../core.rkt"
         "../../integers.rkt"
         "../../lists.rkt"
         "../../logic.rkt"
         "../../macros/macros.rkt"
         "TYPES.rkt"
         "../TYPES.rkt")

; (def TRUE = (make-bool true))
; (def FALSE = (make-bool false))

; (def NOT B = ((((COERCE-1 _not) convert-to-bool) B) bool))

; (def AND B1 B2 = (((((COERCE-2 _and) convert-to-bool) B1) B2) bool))

; (def OR B1 B2 = (((((COERCE-2 _or) convert-to-bool) B1) B2) bool))

; (def XOR B1 B2 = (((((COERCE-2 xor) convert-to-bool) B1) B2) bool))

; (def NOR B1 B2 = (((((COERCE-2 nor) convert-to-bool) B1) B2) bool))

; (def NAND B1 B2 = (((((COERCE-2 nand) convert-to-bool) B1) B2) bool))




; TYPED NILs

(def NIL-list = ((pair _list) nil))

(def LEN L = ((((COERCE-1 len) convert-to-list) L) nat))

(def IS-NIL L = ((((COERCE-1 isNil) convert-to-list) L) bool))

(def IND L I = (val (COERCE-2-diff ind convert-to-list L convert-to-nat I bool)))

(def APP L1 L2 = (((((COERCE-2 app) convert-to-list) L1) L2) _list))

(def REV L = (((((COERCE-1 rev) L) convert-to-list) L) _list))

(def MAP G L = ((((((COERCE-2-diff _map) _identity) (func G)) convert-to-list) L) _list))

(def FILTER G L = ((((((COERCE-2-diff _filter) _identity) (func G)) convert-to-list) L) _list))

; (def FOLD G )