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



(def NOT B = (((DYNAMIC-1 _not) convert-to-bool) B))

(def AND B1 B2 = ((((DYNAMIC-2 _and) convert-to-bool) B1) B2))

(def OR B1 B2 = ((((DYNAMIC-2 _or) convert-to-bool) B1) B2))


(displayln (read-any ((AND TRUE) posONE)))
(displayln (read-any ((AND TRUE) posZERO)))
(displayln (read-any ((AND negTHREE) posZERO)))