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
    - Contract: BOOL => BOOL/ERROR
    - Logic: not function with type checking
|#
(def _NOT B = (makeBool (_not (val B))))

(def NOT B = ((((ADD_TYPE_CHECK _NOT) "NOT") boolType) B))

#|
    ~ AND ~
    - Contract: (BOOL,BOOL) => BOOL/ERROR
    - Logic: and function with type checking
|#
(def _AND B1 B2 = (makeBool ((_and (val B1)) (val B2))))

(def AND M N = ((((((ADD_TYPE_CHECK2 _AND) "AND") boolType) boolType) M) N))

;===================================================