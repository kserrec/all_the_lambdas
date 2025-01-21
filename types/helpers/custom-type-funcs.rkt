#lang s-exp "../../macros/lazy-with-macros.rkt"
(require "../../macros/macros.rkt"
         "../../macros/more-macros.rkt")
(provide (all-defined-out))
(require "../../core.rkt"
         "../../church.rkt"
         "../../logic.rkt"
         "../../recursion.rkt"
         "../TYPES.rkt")

(def custom-filter-typed g lst = ((((Y filter-helper-typed) g) lst) nil))

(def filter-helper-typed f g lst n = 
    ((lst (lambda (x)
                (lambda (y)
                    (lambda (z)
                        ; if an error occurs, put error into list - do NOT filter it, expose it
                        (_if (is-error (g x))
                            _then ((pair (g x)) (((f g) y) n))
                            ; else do regular filter check and keep if passes, else remove
                            _else (IF (g x)
                                    THEN ((pair x) (((f g) y) n))
                                    ELSE (((f g) y) n))
                        )
                    )
                )  
            ))  n))