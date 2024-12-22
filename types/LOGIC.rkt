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
(define TRUE (makeBool true))
(define FALSE (makeBool false))

;===================================================

#|
    ~ READS BOOL TYPED VALUES ~
    - Contract: BOOL => READ(BOOL)
|#
(def _B-READ B = 
    (_if (isBool B)
        _then (((val B) "bool:TRUE") "bool:FALSE")
        _else (E-READ BOOL_ERROR)))
    
(def B-READ B = ((T-READ _B-READ) B))

;===================================================

#|
    ~ NOT ~
    - Contract: BOOL => BOOL
    - Logic: not function with type checking
|#
(def _NOT B = (makeBool (_not (val B))))

(def NOT B = ((((ADD_TYPE_CHECK _NOT) "NOT") boolType) B))

#|
    ~ AND ~
    - Contract: (BOOL,BOOL) => BOOL
    - Logic: and function with type checking
|#
(def _AND B1 B2 = (makeBool ((_and (val B1)) (val B2))))

(def AND B1 B2 = ((((((ADD_TYPE_CHECK2 _AND) "AND") boolType) boolType) B1) B2))

#|
    ~ OR ~
    - Contract: (BOOL,BOOL) => BOOL
    - Logic: or function with type checking
|#
(def _OR B1 B2 = (makeBool ((_or (val B1)) (val B2))))

(def OR B1 B2 = ((((((ADD_TYPE_CHECK2 _OR) "OR") boolType) boolType) B1) B2))

;===================================================

#|
    ~ XOR ~
    - Contract: (BOOL,BOOL) => BOOL
    - Logic: xor function with type checking
|#
(def _XOR B1 B2 = (makeBool ((xor (val B1)) (val B2))))

(def XOR B1 B2 = ((((((ADD_TYPE_CHECK2 _XOR) "XOR") boolType) boolType) B1) B2))

#|
    ~ NOR ~
    - Contract: (BOOL,BOOL) => BOOL
    - Logic: xor function with type checking
|#
(def _NOR B1 B2 = (makeBool ((nor (val B1)) (val B2))))

(def NOR B1 B2 = ((((((ADD_TYPE_CHECK2 _NOR) "NOR") boolType) boolType) B1) B2))

#|
    ~ NAND ~
    - Contract: (BOOL,BOOL) => BOOL
    - Logic: xor function with type checking
|#
(def _NAND B1 B2 = (makeBool ((nand (val B1)) (val B2))))

(def NAND B1 B2 = ((((((ADD_TYPE_CHECK2 _NAND) "NAND") boolType) boolType) B1) B2))