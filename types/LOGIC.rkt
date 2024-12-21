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
    ~ NOT ~
    - Contract: BOOL => BOOL/ERROR
    - Logic: not function with type checking
|#
(def _NOT B = 
    (_if (isBool B)
        _then (makeBool (_not (val B)))
        _else BOOL_ERROR))

(def NOT B = ((((ADD_ERR_PROP _NOT) "NOT") boolType) B))

;===================================================

#|
    ~ AND ~
    - Contract: (BOOL,BOOL) => BOOL/ERROR
    - Logic: and function with type checking
|#
(def _AND B1 B2 = 
    (_if ((_and (isBool B1)) (isBool B2))
        _then (makeBool ((_and (val B1)) (val B2)))
        _else BOOL_ERROR))

(def AND M N = ((((((ADD_ERR_PROP2 _AND) "AND") boolType) boolType) M) N))

;===================================================