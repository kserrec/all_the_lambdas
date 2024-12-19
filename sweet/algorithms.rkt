#lang s-exp "lazy-with-macros.rkt"
(require "macros.rkt")
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
|#
(def binarySearch list target =
    (((((Y binarySearch-helper) list) target) zero) (pred (len list))))
        ;Y (binarySearch) (list) (target) (0) (len(list)-1)

; binarySearch (list) (target) (low) (high) = 
(def binarySearch-helper f list target low high = 
    ; let mid = ((low+high)/2)
    (_let mid = ((div ((add low) high)) two)
        ; if (low <= high)
        ((((lte low) high)
            ; then if (target == list[mid])
            ((((eq target) ((ind list) mid))
                ; return mid
                mid)
                    ; else if (target < list[mid])
                    ((((lt target) ((ind list) mid))
                        ; then binarySearch (list) (target) (low) (mid-1)
                        ((((f list) target) low) (pred mid)))
                        ; else binarySearch (list) (target) (mid+1) (high)
                        ((((f list) target) (succ mid)) high)))) 
            ; true (causes error)
            true)))

#|
    ~ BINARY SEARCH INTEGERS ~
    - Contract: (list,int) => int
        - note: list must be sorted
|#

(def binarySearchZ list target =
    (((((Y binarySearchZ-helper) list) target) zero) (pred (len list))))
        ;Y (binarySearch) (list) (target) (0) (len(list)-1)

(def binarySearchZ-helper f list target low high =
    ; let mid = ((low+high)/2) ; need to write
    ((((lte low) high)
    ; if (low <= high)
        ((((eqZ target) ((ind list) ((div ((add low) high)) two)))
        ; then if (target == list[mid])
            ((makeZ true) ((div ((add low) high)) two)))
            ; return mid
            ((((ltZ target) ((ind list) ((div ((add low) high)) two)))
            ; else if (target < list[mid])
                ((((f list) target) low) (pred ((div ((add low) high)) two))))
                ; then binarySearch (list) (target) (low) (mid-1)
                ((((f list) target) (succ ((div ((add low) high)) two))) high))))
                ; else binarySearch (list) (target) (mid+1) (high)
        negOne))
        ; else (-1)