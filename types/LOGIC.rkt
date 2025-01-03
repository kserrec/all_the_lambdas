#lang lazy
(provide (all-defined-out))
(require "../core.rkt"
         "../logic.rkt"
         "../macros/macros.rkt"
         "TYPES.rkt")

;===================================================

#|
    ~ BOOLEAN OBJECTS ~
;   - Idea: Can list these exhaustively
|#

;   TRUE & FALSE
(def TRUE = (make-bool true))
(def FALSE = (make-bool false))

;===================================================

#|
    ~ READS BOOL TYPED VALUES ~
    - Contract: BOOL => READABLE(BOOL)
|#
(def _bool-read B = 
    (_if (is-bool B)
        _then (((val B) "bool:TRUE") "bool:FALSE")
        _else (err-read BOOL-ERROR)))
    
(def bool-read B = ((read-type _bool-read) B))

;===================================================

#|
    ~ NOT ~
    - Contract: BOOL => BOOL
    - Logic: not function with type checking
|#
(def NOT B = (((((fully-type _not) "NOT") bool) B) bool))

#|
    ~ AND ~
    - Contract: (BOOL,BOOL) => BOOL
    - Logic: and function with type checking
|#
(def AND N1 N2 = (((((((fully-type2 _and) "AND") bool) N1) bool) N2) bool))

#|
    ~ OR ~
    - Contract: (BOOL,BOOL) => BOOL
    - Logic: or function with type checking
|#
(def OR N1 N2 = (((((((fully-type2 _or) "OR") bool) N1) bool) N2) bool))

;===================================================

#|
    ~ XOR ~
    - Contract: (BOOL,BOOL) => BOOL
    - Logic: xor function with type checking
|#
(def XOR N1 N2 = (((((((fully-type2 xor) "XOR") bool) N1) bool) N2) bool))

#|
    ~ NOR ~
    - Contract: (BOOL,BOOL) => BOOL
    - Logic: nor function with type checking
|#
(def NOR N1 N2 = (((((((fully-type2 nor) "NOR") bool) N1) bool) N2) bool))

#|
    ~ NAND ~
    - Contract: (BOOL,BOOL) => BOOL
    - Logic: nand function with type checking
|#
(def NAND N1 N2 = (((((((fully-type2 nand) "NAND") bool) N1) bool) N2) bool))