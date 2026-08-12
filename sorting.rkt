#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
(provide (all-defined-out))
(require "core.rkt"
         "church.rkt"
         "logic.rkt"
         "lists.rkt"
         "division.rkt"
         "recursion.rkt")

;===================================================
; SORTING
;===================================================

#| COMPARATOR-PARAMETERIZED SORTS

    algorithms.rkt already sorts lists of Church naturals with bubble,
    insertion, and selection sort. The sorts here differ in two ways:

    1. They are the recursive divide-and-conquer sorts — merge sort
       and quicksort — which decompose lists the way lambda calculus
       likes best: no indexing, no swapping, just heads, tails,
       appends, and filters.

    2. The ordering is an ARGUMENT. Hand merge-sort lte and it sorts
       Church naturals; hand it lteZ and the same term sorts integers;
       bin-lte, binary naturals. One implementation, every numeric
       representation in the repository.
|#

;===================================================

#|
    ~ MERGE ~
    - Contract: (func, list, list) => list
    - Idea: Weave two already-sorted lists into one sorted list
    - Logic: If either list is dry the other is the answer. Otherwise
                the smaller of the two heads (decided by lte) goes
                first, and the merge continues with the rest of that
                list and all of the other
|#
(def merge lte l1 l2 = ((((Y merge-helper) lte) l1) l2))

(def merge-helper f lte l1 l2 =
    (_if (isNil l1)
        _then l2
        _else (_if (isNil l2)
                _then l1
                _else (_if ((lte (head l1)) (head l2))
                        _then ((pair (head l1)) (((f lte) (tail l1)) l2))
                        _else ((pair (head l2)) (((f lte) l1) (tail l2)))))))

#|
    ~ MERGE SORT ~
    - Contract: (func, list) => list
    - Idea: Split the list in half, sort each half, merge the halves
    - Logic: Lists of length zero or one are already sorted. Otherwise
                take the front half (half the length, rounded down) and
                drop it to get the back half — both strictly shorter,
                so the recursion bottoms out — sort each, and merge
|#
(def merge-sort lte lst = (((Y merge-sort-helper) lte) lst))

(def merge-sort-helper f lte lst =
    (_if (isNil lst)
        _then nil
        _else (_if (isNil (tail lst))
                _then lst
                _else (_let half = ((div (len lst)) two)
                        (((merge lte)
                            ((f lte) ((_take half) lst)))
                            ((f lte) ((_drop half) lst)))))))

#|
    ~ QUICKSORT ~
    - Contract: (func, list) => list
    - Idea: Pick the head as the pivot; everything less than the pivot
                (by lt), sorted, goes in front; the pivot next; then
                everything not less than it, sorted
    - Logic: The two sides are built with _filter over the tail, so
                each recursive call works on a strictly shorter list.
                Elements equal to the pivot fail (lt x pivot) and land
                on the right side, keeping duplicates together
|#
(def quick-sort lt lst = (((Y quick-sort-helper) lt) lst))

(def quick-sort-helper f lt lst =
    (_if (isNil lst)
        _then nil
        _else (_let pivot = (head lst)
                (_let rest = (tail lst)
                    ((app
                        ((f lt) ((_filter (lambda (x) ((lt x) pivot))) rest)))
                        ((pair pivot)
                         ((f lt) ((_filter (lambda (x) (_not ((lt x) pivot)))) rest))))))))
