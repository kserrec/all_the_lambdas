#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
(provide (all-defined-out))
(require "core.rkt"
         "church.rkt"
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
    ; binarySearch (lst) (target) (low) (high) = 
    ;   let mid = ((low+high)/2)
        ; if (low <= high)
            ; then if (target == lst[mid])
                    ; then mid
                    ; else if (target < lst[mid])
                        ; then binarySearch (lst) (target) (low) (mid-1)
                        ; else binarySearch (lst) (target) (mid+1) (high)
            ; else badVal

   ===================
    ~ NATURALS ~
    - Idea: returns index of target in list
    - Contract: (list,nat) => nat
        - note1: list must be sorted
        - note2: returns true if element is not in list
|#
(def binarySearch lst target =
    (((((Y binarySearch-helper) lst) target) zero) (pred (len lst))))

(def binarySearch-helper f lst target low high = 
    (_let mid = ((div ((add low) high)) two)
        (_if ((lte low) high)
            _then (_if ((eq target) ((ind lst) mid))
                    _then mid
                    _else (_if ((lt target) ((ind lst) mid))
                            _then ((((f lst) target) low) (pred mid))
                            _else ((((f lst) target) (succ mid)) high)))
            _else true)))

#|
    ~ BINARY SEARCH INTEGERS ~
    - Contract: (list,int) => int
        - note1: list must be sorted
        - note2: returns -1 if element is not in list
|#

(def binarySearchZ lst target =
    (((((Y binarySearchZ-helper) lst) target) zero) (pred (len lst))))

(def binarySearchZ-helper f lst target low high =
    (_let mid = ((div ((add low) high)) two)
        (_if ((lte low) high)
            _then (_if ((eqZ target) ((ind lst) mid))
                    _then ((makeZ true) mid)
                    _else (_if ((ltZ target) ((ind lst) mid))
                            _then ((((f lst) target) low) (pred mid))
                            _else ((((f lst) target) (succ mid)) high)))   
            _else negOne)))


;===================================================

; returns a list with two passed elements swapped where left starts at index i
(def swap lst left i right = 
    (_let new-lst = (((replace right) lst) i)
    (((replace left) new-lst) (succ i))))

; bubble pass helper - swaps left and right if need be and then recurses
(def one-bubble-pass-helper f lst for-i resting-place = 
    (_if ((gt (succ for-i)) resting-place)
        _then lst
        _else 
            (_let left = ((ind lst) for-i)
            (_let right = ((ind lst) (succ for-i))
            (_if ((gt left) right)
                _then (_let swapped-list = ((((swap lst) left) for-i) right)
                    (((f swapped-list) (succ for-i)) resting-place))
                _else (((f lst) (succ for-i)) resting-place))))))

; bubble passes up to "resting-place"
(def one-bubble-pass lst resting-place = ((((Y one-bubble-pass-helper) lst) zero) (pred resting-place)))

; bubble passes up to each "resting-place" from final index on down
(def bubble-sort-helper f lst for-i = 
    (_let lst-len = (len lst)
    (_if ((gte for-i) lst-len)
        _then lst
        _else (_let new-list = ((one-bubble-pass lst) ((for-i pred) lst-len))
            ((f new-list) (succ for-i))))))

; bubble sort
(def bubble-sort lst = (((Y bubble-sort-helper) lst) zero))



