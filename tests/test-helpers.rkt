#lang s-exp "../macros/lazy-with-macros.rkt"
(require "../macros/macros.rkt")
(provide (all-defined-out))

(define (filterForFails testList)
    (filter (λ (x) (eq? (last x) #f)) testList))