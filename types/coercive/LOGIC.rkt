#lang lazy
(provide (all-defined-out))
(require "../../church.rkt"
         "../../core.rkt"
         "../../integers.rkt"
         "../../lists.rkt"
         "../../logic.rkt"
         "../../macros/macros.rkt"
         "../CHURCH.rkt"
         "../INTEGERS.rkt"
         "../LOGIC.rkt"
         "../TYPES.rkt")

(def NOT B = ((((DYNAMIC-1 _not) convert-to-bool) B) bool))

(def AND B1 B2 = (((((DYNAMIC-2 _and) convert-to-bool) B1) B2) bool))

(def OR B1 B2 = (((((DYNAMIC-2 _or) convert-to-bool) B1) B2) bool))

(def XOR B1 B2 = (((((DYNAMIC-2 xor) convert-to-bool) B1) B2) bool))

(def NOR B1 B2 = (((((DYNAMIC-2 nor) convert-to-bool) B1) B2) bool))

(def NAND B1 B2 = (((((DYNAMIC-2 nand) convert-to-bool) B1) B2) bool))