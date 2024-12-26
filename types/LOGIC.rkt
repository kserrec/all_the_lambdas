#lang lazy
(provide (all-defined-out))
(require "../logic.rkt"
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
    ~ t-not ~
    - Contract: BOOL => BOOL
    - Logic: not function with type checking
|#
(def t-not B = (((((type-n-check-f _not) "t-not") bool-type) bool-type) B))

#|
    ~ t-and ~
    - Contract: (BOOL,BOOL) => BOOL
    - Logic: and function with type checking
|#
(def t-and N1 N2 = (((((((type-n-check-f2 _and) "t-and") bool-type) bool-type) bool-type) N1) N2))

#|
    ~ t-or ~
    - Contract: (BOOL,BOOL) => BOOL
    - Logic: or function with type checking
|#
(def t-or N1 N2 = (((((((type-n-check-f2 _or) "t-or") bool-type) bool-type) bool-type) N1) N2))

;===================================================

#|
    ~ t-xor ~
    - Contract: (BOOL,BOOL) => BOOL
    - Logic: xor function with type checking
|#
(def t-xor N1 N2 = (((((((type-n-check-f2 xor) "t-xor") bool-type) bool-type) bool-type) N1) N2))

#|
    ~ t-nor ~
    - Contract: (BOOL,BOOL) => BOOL
    - Logic: nor function with type checking
|#
(def t-nor N1 N2 = (((((((type-n-check-f2 nor) "t-nor") bool-type) bool-type) bool-type) N1) N2))

#|
    ~ t-nand ~
    - Contract: (BOOL,BOOL) => BOOL
    - Logic: nand function with type checking
|#
(def t-nand N1 N2 = (((((((type-n-check-f2 nand) "t-nand") bool-type) bool-type) bool-type) N1) N2))