#lang lazy
(provide (all-defined-out))
(require "../church.rkt"
         "../logic.rkt"
         "../macros/macros.rkt")
(require "CHURCH.rkt"
         "LOGIC.rkt"
         "TYPES.rkt")

;===================================================

#|
    ~ READS INT TYPED VALUES ~
    - Contract: INT => READ(INT)
|#
(def _Z-READ Z = 
    (_if (isInt Z)
        _then (s-a "int:" (n-s (z-read (val Z))))
        _else (E-READ INT_ERROR)))

(def Z-READ Z = ((T-READ _Z-READ) Z))