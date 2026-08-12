#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
(provide (all-defined-out))
(require "core.rkt"
         "church.rkt"
         "logic.rkt"
         "lists.rkt"
         "binary-lists.rkt"
         "recursion.rkt")

;===================================================
; BINARY ALGORITHMS
;===================================================

#| MORE BINARY-NUMBER ALGORITHMS

    binary-lists.rkt provides the arithmetic core: add, subtract,
    multiply, divide, remainder, gcd, lcm, exponentiation. This module
    builds the classic bit-level and number-theoretic algorithms on
    top of it, without modifying the base library.

    Recall the representation: a binary natural is a lambda list of
    digits, most significant first, each digit the Church numeral
    zero or one; canonical zero is [0] and nonzero values carry no
    leading zeroes. Results here are normalized with rem-head-zeroes
    wherever leading zeroes could arise.
|#

;===================================================
; SHIFTS, WIDTH, POPULATION
;===================================================

#|
    ~ SHIFT LEFT ~
    - Contract: (nat, bin-list) => bin-list
    - Idea: n places left is multiplication by 2^n
    - Logic: bin-mult-pow-2 appends n zero digits; normalizing keeps
                zero canonical ([0] would otherwise grow to [0,0,...])
|#
(def bin-shl n bin = (rem-head-zeroes ((bin-mult-pow-2 bin) n)))

#|
    ~ SHIFT RIGHT ~
    - Contract: (nat, bin-list) => bin-list
    - Idea: n places right is division by 2^n, dropping the remainder
    - Logic: Digits sit most significant first, so shifting right
                keeps only the first (len - n) digits. Shifting past
                the whole number leaves nothing, which normalizes to
                canonical zero (sub is monus: len - n bottoms at zero)
|#
(def bin-shr n bin =
    (rem-head-zeroes ((_take ((sub (len bin)) n)) bin)))

#|
    ~ FIT WIDTH ~
    - Contract: (nat, bin-list) => bin-list of exactly width digits
    - Idea: Helper for bin-not-w: view the number in a fixed-width
                register — pad with leading zeroes to grow, keep only
                the low digits to shrink
|#
(def bin-fit-width width bin =
    (_if ((gte (len bin)) width)
        _then ((takeTail width) bin)
        _else ((prepend-zeroes ((sub width) (len bin))) bin)))

#|
    ~ FLIP DIGIT ~
    - Contract: b-dig => b-dig
    - Logic: one becomes zero, zero becomes one
|#
(def bin-flip-digit d =
    (_if (isOne d)
        _then zero
        _else one))

#|
    ~ BITWISE NOT AT A WIDTH ~
    - Contract: (nat, bin-list) => bin-list
    - Idea: Flip every bit of the number seen as a width-digit
                register. NOT has no meaning on bare binary naturals —
                leading zeroes would flip into infinitely many leading
                ones — so the width is part of the question:
                bin-not-w(width, x) = (2^width - 1) - x
    - Logic: Fit to width, flip each digit, normalize the result
|#
(def bin-not-w width bin =
    (rem-head-zeroes ((_map bin-flip-digit) ((bin-fit-width width) bin))))

#|
    ~ BIT LENGTH ~
    - Contract: bin-list => nat
    - Idea: How many digits the canonical form carries; note zero has
                bit length one, because canonical zero IS the one-digit
                list [0]
    - Logic: Normalize, then count
|#
(def bin-bit-length bin = (len (rem-head-zeroes bin)))

#|
    ~ POPULATION COUNT ~
    - Contract: bin-list => nat
    - Idea: How many one-digits the number carries
    - Logic: Keep the ones, count what is left
|#
(def bin-popcount bin = (len ((_filter isOne) bin)))

;===================================================
; BITWISE AND / OR / XOR
;===================================================

#|
    ~ ZIP WITH ~
    - Contract: (func, bin-list, bin-list) => bin-list
    - Idea: Combine two EQUAL-LENGTH digit lists position by position
    - Logic: March both lists together, applying op to the digit pair
|#
(def bin-zip-with op l1 l2 = ((((Y bin-zip-with-helper) op) l1) l2))

(def bin-zip-with-helper f op l1 l2 =
    (_if (isNil l1)
        _then nil
        _else ((pair ((op (head l1)) (head l2)))
               (((f op) (tail l1)) (tail l2)))))

#|
    ~ BITWISE COMBINE ~
    - Contract: (func, bin-list, bin-list) => bin-list
    - Idea: The shared shape of AND, OR, and XOR: pad the shorter
                operand with leading zeroes to a common width, zip
                with the digit operation, normalize
    - Logic: The common width is the longer length (picked with gte);
                sub is monus, so the longer operand gets zero padding
|#
(def bin-bitwise op l1 l2 =
    (_let n1 = (len l1)
        (_let n2 = (len l2)
            (_let w = (_if ((gte n1) n2) _then n1 _else n2)
                (rem-head-zeroes
                    (((bin-zip-with op)
                        ((prepend-zeroes ((sub w) n1)) l1))
                        ((prepend-zeroes ((sub w) n2)) l2)))))))

#|
    ~ DIGIT AND / OR / XOR ~
    - Contract: (b-dig, b-dig) => b-dig
    - Logic: The digit is one exactly when the boolean combination
                of "is one" answers holds
|#
(def dig-and d1 d2 =
    (_if ((_and (isOne d1)) (isOne d2)) _then one _else zero))

(def dig-or d1 d2 =
    (_if ((_or (isOne d1)) (isOne d2)) _then one _else zero))

(def dig-xor d1 d2 =
    (_if ((xor (isOne d1)) (isOne d2)) _then one _else zero))

#|
    ~ BITWISE AND / OR / XOR ~
    - Contract: (bin-list, bin-list) => bin-list
    - Logic: The bitwise combine with the matching digit operation
|#
(def bin-and l1 l2 = (((bin-bitwise dig-and) l1) l2))

(def bin-or l1 l2 = (((bin-bitwise dig-or) l1) l2))

(def bin-xor l1 l2 = (((bin-bitwise dig-xor) l1) l2))
