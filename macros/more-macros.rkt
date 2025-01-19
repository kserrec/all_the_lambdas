#lang lazy
(require (for-syntax racket/base))
(provide (all-defined-out))
(require "macros.rkt")
(require "../lists.rkt")
(require "../types/coercive/TYPES.rkt")

; coercive conditional
(define-syntax (IF stx)
  (syntax-case stx (THEN)
    [(_ condition THEN _then ELSE _else)
     #'(((tail (COND condition)) _then) _else)]))