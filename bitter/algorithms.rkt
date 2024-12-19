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
    - Contract: (list,nat) => nat
        - note: list must be sorted
    - Logic: def binarySearch list target low high = if (low <= high)
                then (target == list[(s+b)/2])
                    then (s+b)/2
                    else if (target < list[s+b)/2])
                        then binarySearch list low ((s+b)/2)-1)
                        else binarySearch list ((s+b)/2)+1) high
                else true (causes error)
|#
(define binarySearch
    (lambda (list)
        (lambda (target)
            (((((Y binarySearch-helper) list) target) zero) (pred (len list)))
        )
    )
)

(define binarySearch-helper
    (lambda (f)
        (lambda (list)
            (lambda (target)
                (lambda (low)
                    (lambda (high)
                        ((lambda (mid)
                            ((((lte low) high)
                                ((((eq target) ((ind list) mid))
                                    mid)
                                    ((((lt target) ((ind list) mid))
                                        ((((f list) target) low) (pred mid)))
                                        ((((f list) target) (succ mid)) high)))) 
                                true)
                        ) ((div ((add low) high)) two))))))))

#|
    ~ BINARY SEARCH INTEGERS ~
    - Contract: (list,int) => int
        - note: list must be sorted
    - Logic: rec binarySearch list target low high = if (low <= high)
                then if (target == list[(s+b)/2])
                    then (s+b)/2
                    else if (target < list[s+b)/2])
                        then binarySearch list low ((s+b)/2)-1)
                        else binarySearch list ((s+b)/2)+1) high
                else -1
|#

(define binarySearchZ
    (lambda (list)
        (lambda (target)
            (((((Y binarySearchZ-helper) list) target) zero) (pred (len list)))
        )
    )
)

(define binarySearchZ-helper
    (lambda (f)
        (lambda (list)
            (lambda (target)
                (lambda (low)
                    (lambda (high)
                        ((lambda (mid)
                            ((((lte low) high)
                                ((((eqZ target) ((ind list) mid))
                                    ((makeZ true) mid))
                                    ((((ltZ target) ((ind list) mid))
                                        ((((f list) target) low) (pred mid)))
                                        ((((f list) target) (succ mid)) high)
                                    )
                                )
                            ) negOne
                            )
                        ) ((div ((add low) high)) two))
                    )
                )
            )
        )
    )        
)
