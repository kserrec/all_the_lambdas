#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
(provide (all-defined-out))
(require "church.rkt"
         "core.rkt"
         "division.rkt"
         "integers.rkt"
         "lists.rkt"
		 "logic.rkt"
         "recursion.rkt")

;===================================================
; ALGORITHMS
;===================================================

#|
    ~ BINARY SEARCH ~q

    -Algorithm:
    ; binarySearch (lst) (target) (low) (high-exclusive) =
        ; if (low < high-exclusive)
            ; then let mid = ((low+high-exclusive)/2)
                ; if (target == lst[mid])
                    ; then {true, mid}
                    ; else if (target < lst[mid])
                        ; then binarySearch (lst) (target) (low) (mid)
                        ; else binarySearch (lst) (target) (mid+1) (high-exclusive)
            ; else {false, zero}

   ===================
    ~ NATURALS ~
    - Idea: returns whether the target was found and, when found, its index
    - Contract: (list,nat) => {bool,nat}
        - note1: list must be sorted
        - note2: {false,zero} means the target is absent; ignore that index
        - note3: the half-open [low,high) bounds terminate without needing -1
|#
(def binarySearch lst target =
    (((((Y binarySearch-helper) lst) target) zero) (len lst)))

(def binarySearch-helper f lst target low high =
    (_if ((lt low) high)
        _then (_let mid = ((div ((add low) high)) two)
            (_if ((eq target) ((ind lst) mid))
                    _then ((pair true) mid)
                    _else (_if ((lt target) ((ind lst) mid))
                            _then ((((f lst) target) low) mid)
                            _else ((((f lst) target) (succ mid)) high))))
        _else ((pair false) zero)))

#|
    ~ BINARY SEARCH INTEGERS ~
    - Contract: (list,int) => {bool,nat}
        - note1: list must be sorted
        - note2: indexes are naturals even though the searched values are ints
        - note3: {false,zero} means the target is absent; ignore that index
|#

(def binarySearchZ lst target =
    (((((Y binarySearchZ-helper) lst) target) zero) (len lst)))

(def binarySearchZ-helper f lst target low high =
    (_if ((lt low) high)
        _then (_let mid = ((div ((add low) high)) two)
            (_if ((eqZ target) ((ind lst) mid))
                    _then ((pair true) mid)
                    _else (_if ((ltZ target) ((ind lst) mid))
                            _then ((((f lst) target) low) mid)
                            _else ((((f lst) target) (succ mid)) high))))
        _else ((pair false) zero)))

;===================================================
#|
    ~ BUBBLE SORT NATURALS ~
    - Contract: list => list
|#

; bubble sort
(def bubble-sort lst = ((((Y bubble-sort-helper) lst) (len lst)) zero))

; bubble passes up to each "resting-place" from final index on down
(def bubble-sort-helper f lst lst-len for-i = 
    (_if ((gte for-i) lst-len)
        _then lst
        _else (_let new-list = ((one-bubble-pass lst) ((for-i pred) lst-len))
            (((f new-list) lst-len) (succ for-i)))))

; bubble passes up to "resting-place"
(def one-bubble-pass lst resting-place = ((((Y one-bubble-pass-helper) lst) zero) (pred resting-place)))

; returns a list with two passed elements swapped where left starts at index i
(def swap-neighbors lst left i right = 
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
                _then (_let swapped-list = ((((swap-neighbors lst) left) for-i) right)
                    (((f swapped-list) (succ for-i)) resting-place))
                _else (((f lst) (succ for-i)) resting-place))))))

;===================================================

#|
    ~ INSERTION SORT NATURALS ~
    - Contract: list => list
|#

; insertion sort
(def insertion-sort lst = ((((Y insertion-helper) lst) (len lst)) one))

; inserts each element into sorted sublist to the left from index one to end
(def insertion-helper f lst lst-len for-i = 
    (_if ((gte for-i) lst-len)
        _then lst
        _else (_let new-list = ((insertion-pass lst) for-i)
            (((f new-list) lst-len) (succ for-i)))))

; runs each insertion pass
(def insertion-pass lst j = 
    (((((Y insertion-pass-helper) lst) zero) ((ind lst) j)) j))

; if less than any of sorted list to its left,
; inserts copy of element at index j,
; then removes original
(def insertion-pass-helper f lst for-i key j =
    (_let lst@i = ((ind lst) for-i)
    (_if ((gte for-i) j)
        _then lst
        _else (_if ((lte key) lst@i)
                _then (_let new-list = (((insert key) lst) for-i)
                      ((_remove new-list) (succ j)))
                _else ((((f lst) (succ for-i)) key) j)))))

;===================================================

#|
    ~ SELECTION SORT NATURALS ~
    - Contract: list => list
|#

; selection sort
(def selection-sort lst = 
    ((((Y selection-helper) lst) zero) (len lst)))

; select min value from sublist going up and swap if needed
(def selection-helper f lst for-i lst-len =
    (_if ((gte for-i) lst-len)
        _then lst
        _else (_let lst@i = ((ind lst) for-i)
              (_let min-pair = (((((select-min lst) (succ for-i)) lst-len) lst@i) for-i)
              (_let min-val = (tail min-pair)
              (_let min-i = (head min-pair)
              (_if ((gt min-val) lst@i)
                _then (((f lst) (succ for-i)) lst-len)
                _else (_let swapped-list = (((((swap lst) lst@i) for-i) min-val) min-i)
                    (((f swapped-list) (succ for-i)) lst-len)))))))))

; run each selection of min pass
(def select-min lst for-i lst-len working-min min-i = 
    ((((((Y select-min-helper) lst) for-i) lst-len) working-min) min-i))

; selects and returns minimum value and its index searching through list
(def select-min-helper f lst for-i lst-len working-min min-i =
    (_let lst@i = ((ind lst) for-i)
    (_if ((gte for-i) lst-len)
        _then ((pair min-i) working-min)
        _else (_if ((lte working-min) lst@i)
                _then (((((f lst) (succ for-i)) lst-len) working-min) min-i)
                _else (((((f lst) (succ for-i)) lst-len) lst@i) for-i)))))

; swaps any two values in a list with their values and indices
(def swap lst left i right j = 
    (_let new-lst = (((replace right) lst) i)
    (((replace left) new-lst) j)))
