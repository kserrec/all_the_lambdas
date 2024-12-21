#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
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
    ~ BINARY SEARCH ~

    -Algorithm:
    ; binarySearch (list) (target) (low) (high) = 
    ;   let mid = ((low+high)/2)
        ; if (low <= high)
            ; then if (target == list[mid])
                    ; then mid
                    ; else if (target < list[mid])
                        ; then binarySearch (list) (target) (low) (mid-1)
                        ; else binarySearch (list) (target) (mid+1) (high)
            ; else badVal

   ===================
    ~ NATURALS ~
    - Contract: (list,nat) => nat
        - note: list must be sorted
|#
(def binarySearch list target =
    (((((Y binarySearch-helper) list) target) zero) (pred (len list))))

(def binarySearch-helper f list target low high = 
    (_let mid = ((div ((add low) high)) two)
        (_if ((lte low) high)
            _then (_if ((eq target) ((ind list) mid))
                    _then mid
                    _else (_if ((lt target) ((ind list) mid))
                            _then ((((f list) target) low) (pred mid))
                            _else ((((f list) target) (succ mid)) high)))
            _else true)))

#|
    ~ BINARY SEARCH INTEGERS ~
    - Contract: (list,int) => int
        - note: list must be sorted
|#

(def binarySearchZ list target =
    (((((Y binarySearchZ-helper) list) target) zero) (pred (len list))))

(def binarySearchZ-helper f list target low high =
    (_let mid = ((div ((add low) high)) two)
        (_if ((lte low) high)
            _then (_if ((eqZ target) ((ind list) mid))
                    _then ((makeZ true) mid)
                    _else (_if ((ltZ target) ((ind list) mid))
                            _then ((((f list) target) low) (pred mid))
                            _else ((((f list) target) (succ mid)) high)))   
            _else negOne)))