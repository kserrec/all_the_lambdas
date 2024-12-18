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
    (lambda (_list)
        (lambda (target)
            (((((Y binarySearch-helper) _list) target) zero) (pred (len _list)))
        )
    )
)

(define binarySearch-helper
    (lambda (f)
        (lambda (_list)
            (lambda (target)
                (lambda (low)
                    (lambda (high)
                        ((((lte low) high)
                            ((((eq target) ((_ind _list) ((div ((add low) high)) two)))
                                ((div ((add low) high)) two))
                                ((((lt target) ((_ind _list) ((div ((add low) high)) two)))
                                    ((((f _list) target) low) (pred ((div ((add low) high)) two))))
                                    ((((f _list) target) (succ ((div ((add low) high)) two))) high)
                                )
                            )
                         ) true
                        )
                    )
                )
            )
        )
    )        
)

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
    (lambda (_list)
        (lambda (target)
            (((((Y binarySearchZ-helper) _list) target) zero) (pred (len _list)))
        )
    )
)

(define binarySearchZ-helper
    (lambda (f)
        (lambda (_list)
            (lambda (target)
                (lambda (low)
                    (lambda (high)
                        ((((lte low) high)
                            ((((eqZ target) ((_ind _list) ((div ((add low) high)) two)))
                                ((makeZ true) ((div ((add low) high)) two)))
                                ((((ltZ target) ((_ind _list) ((div ((add low) high)) two)))
                                    ((((f _list) target) low) (pred ((div ((add low) high)) two))))
                                    ((((f _list) target) (succ ((div ((add low) high)) two))) high)
                                )
                            )
                         ) negOne
                        )
                    )
                )
            )
        )
    )        
)
