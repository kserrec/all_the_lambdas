#lang lazy
(provide (all-defined-out))
(require "../algorithms.rkt"
         "../church.rkt"
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

(def BINARY-SEARCH L T = (((((((fully-type2 binarySearch) "BINARY-SEARCH") _list) (untype-elements L)) nat) T) nat))


(def BINARY-SEARCHz L T = (((((((fully-type2 binarySearchZ) "BINARY-SEARCH") _list) (untype-elements L)) int) T) int))

