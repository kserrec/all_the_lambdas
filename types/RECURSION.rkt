#lang lazy
(provide (all-defined-out))
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

(def FACT N = (((((fully-type fact) "FACT") nat) N) nat))

(def FIB N = (((((fully-type fib) "FIB") nat) N) nat))

(def N-SUM N = (((((fully-type nSum) "N-SUM") nat) N) nat))
