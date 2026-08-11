#lang lazy
(provide (all-defined-out))
(require "../algorithms.rkt"
         "../church.rkt"
         "../core.rkt"
         "../integers.rkt"
         "../lists.rkt"
         "../logic.rkt"
         "../macros/macros.rkt"
         "../recursion.rkt")
(require "CHURCH.rkt"
         "INTEGERS.rkt"
         "LOGIC.rkt"
         "TYPES.rkt")

;===================================================

#|
    ~ SAFE BINARY SEARCH OF NATURALS ~
    - Contract: (LIST, NAT) => OPTION(NAT) or a propagated argument error
    - Logic: type-check both inputs before unwrapping them. The raw search
        returns {found?,index}; convert a found natural index to some(nat:index)
        and expected absence to none.
|#
(def BINARY-SEARCH-option L T =
    (_let search-result = ((binarySearch (val (untype-elements L))) (val T))
        (_if (head search-result)
            _then (make-some (make-nat (tail search-result)))
            _else NONE)))

(def BINARY-SEARCH L T =
    ((((((type-check2 BINARY-SEARCH-option) "BINARY-SEARCH") _list) nat) L) T))


#|
    ~ SAFE BINARY SEARCH OF INTEGERS ~
    - Contract: (LIST, INT) => OPTION(NAT) or a propagated argument error
    - Logic: searched values are signed integers, but list indexes are always
        naturals. Convert the same raw {found?,index} shape to some(nat:index)
        or none after both argument checks succeed.
|#
(def BINARY-SEARCHz-option L T =
    (_let search-result = ((binarySearchZ (val (untype-elements L))) (val T))
        (_if (head search-result)
            _then (make-some (make-nat (tail search-result)))
            _else NONE)))

(def BINARY-SEARCHz L T =
    ((((((type-check2 BINARY-SEARCHz-option) "BINARY-SEARCH") _list) int) L) T))
