#lang lazy
(provide (all-defined-out))
(require "../../church.rkt"
         "../../core.rkt"
         "../../integers.rkt"
         "../../lists.rkt"
         "../../logic.rkt"
         "../../macros/macros.rkt"
         "CHURCH.rkt"
         "INTEGERS.rkt"
         "LOGIC.rkt"
         "TYPES.rkt"
         "../TYPES.rkt")


; Some LISTS
(def NIL-list = ((pair _list) nil))
(def LIST-T = ((pair _list) (_cons TRUE)))
(def LIST-F = ((pair _list) (_cons FALSE)))
(def LIST-0 = ((pair _list) (_cons ZERO)))
(def LIST-4 = ((pair _list) (_cons FOUR)))
(def LIST-0-1 = ((pair _list) (_cons ZERO ONE)))
(def LIST-1-0 = ((pair _list) (_cons ONE ZERO)))
(def LIST-1-3-4-2 = ((pair _list) (_cons ONE THREE FOUR TWO)))
(def LIST-p2-n3-p0-p4 = ((pair _list) (_cons posTWO negTHREE posZERO posFOUR)))
(def LIST-n2-p1-p2-n4-n5 = ((pair _list) (_cons negTWO posONE posTWO negFOUR negFIVE)))

; ====================================================================

(def LEN L = ((((COERCE-1 len) convert-to-list) L) nat))

(def IS-NIL L = ((((COERCE-1 isNil) convert-to-list) L) bool))

(def IND L I = (val ((((((COERCE-2-diff ind) convert-to-list) L) convert-to-nat) I) bool)))

(def APP L1 L2 = (((((COERCE-2 app) convert-to-list) L1) L2) _list))

(def REV L = (((((COERCE-1 rev) L) convert-to-list) L) _list))

(def MAP G L = ((((((COERCE-2-diff _map) _identity) (func G)) convert-to-list) L) _list))

(def FILTER G L = ((((((COERCE-2-diff _filter) _identity) (func G)) convert-to-list) L) _list))

(def FOLD G X L = (val ((((((((COERCE-3-diff _fold) _identity) (func G)) _identity) X) convert-to-list) L) bool)))

(def TAKE N L = ((((((COERCE-2-diff _take) convert-to-nat) N) convert-to-list) L) _list))

(def TAKE-TAIL N L = ((((((COERCE-2-diff takeTail) convert-to-nat) N) convert-to-list) L) _list))

(def DROP N L = ((((((COERCE-2-diff _drop) convert-to-nat) N) convert-to-list) L) _list))

(def REMOVE L I = ((((((COERCE-2-diff _remove) convert-to-list) L) convert-to-nat) I) _list))

(def INSERT X L I = ((((((((COERCE-3-diff insert) _identity) X) convert-to-list) L) convert-to-nat) I) _list))

(def REPLACE X L I = ((((((((COERCE-3-diff replace) _identity) X) convert-to-list) L) convert-to-nat) I) _list))
