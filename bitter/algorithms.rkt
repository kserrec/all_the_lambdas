#lang lazy
(provide (all-defined-out))
(require "church.rkt"
         "division.rkt"
         "integers.rkt"
         "lists.rkt"
		 "logic.rkt"
         "recursion.rkt")

;===================================================
; ALGORITHMS
;===================================================

#|
    ~ BINARY SEARCH NATURALS ~
    - Contract: (list,nat) => {bool,nat}
        - note: list must be sorted
    - Logic: search the half-open natural-number range [low,high)
        - found => {true,index}
        - absent => {false,zero}; the index payload is ignored
|#
(define binarySearch
    (lambda (list)
        (lambda (target)
            (((((Y binarySearch-helper) list) target) zero) (len list)))))

(define binarySearch-helper
    (lambda (f)
        (lambda (list)
            (lambda (target)
                (lambda (low)
                    (lambda (high)
                        ((((lt low) high)
                            ((lambda (mid)
                                ((((eq target) ((ind list) mid))
                                    ((pair true) mid))
                                    ((((lt target) ((ind list) mid))
                                        ((((f list) target) low) mid))
                                        ((((f list) target) (succ mid)) high))))
                             ((div ((add low) high)) two)))
                            ((pair false) zero))))))))

#|
    ~ BINARY SEARCH INTEGERS ~
    - Contract: (list,int) => {bool,nat}
        - note: list must be sorted
    - Logic: search the half-open natural-number range [low,high)
        - found => {true,index}; the index is a natural
        - absent => {false,zero}; the index payload is ignored
|#

(define binarySearchZ
    (lambda (list)
        (lambda (target)
            (((((Y binarySearchZ-helper) list) target) zero) (len list)))))

(define binarySearchZ-helper
    (lambda (f)
        (lambda (list)
            (lambda (target)
                (lambda (low)
                    (lambda (high)
                        ((((lt low) high)
                            ((lambda (mid)
                                ((((eqZ target) ((ind list) mid))
                                    ((pair true) mid))
                                    ((((ltZ target) ((ind list) mid))
                                        ((((f list) target) low) mid))
                                        ((((f list) target) (succ mid)) high))))
                             ((div ((add low) high)) two)))
                            ((pair false) zero))))))))
