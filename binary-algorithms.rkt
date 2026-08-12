#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
(provide (all-defined-out))
(require "core.rkt"
         "church.rkt"
         "logic.rkt"
         "lists.rkt"
         "binary-lists.rkt"
         "int-binary-lists.rkt"
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

;===================================================
; CONVERSIONS — BINARY <-> CHURCH, AS LAMBDA TERMS
;===================================================

#|
    ~ BINARY TO CHURCH ~
    - Contract: bin-list => nat
    - Idea: Read the digits left to right the way a person reads
                binary: double what you have, add the digit
    - Logic: Each digit IS already the Church numeral zero or one,
                so "add the digit" is literally add. The whole
                conversion is a fold — a lambda term through and
                through, no host arithmetic anywhere
|#
(def bin-to-church bin = (((Y bin-to-church-helper) bin) zero))

(def bin-to-church-helper f bin acc =
    (_if (isNil bin)
        _then acc
        _else ((f (tail bin)) ((add ((add acc) acc)) (head bin)))))

#|
    ~ CHURCH TO BINARY ~
    - Contract: nat => bin-list
    - Idea: A Church numeral n IS n-fold application — so apply the
                binary successor n times to binary zero and the
                numeral itself drives the whole computation
    - Logic: One application of n; no recursion of our own needed
|#
(def church-to-bin n = ((n bin-succ) bin-zero))

;===================================================
; INTEGER SQUARE ROOT
;===================================================

#|
    ~ INTEGER SQUARE ROOT ~
    - Contract: bin-list => bin-list
    - Idea: The largest r with r*r <= x, found by binary search on
                the answer — the same terminating search shape as
                binarySearch in algorithms.rkt
    - Logic: Keep lo <= answer <= hi, starting at 0..x. Each round
                tries the UPPER middle (lo+hi+1 halved): if its square
                still fits under x the answer is at least mid (lo
                rises to mid), otherwise it is below mid (hi drops to
                mid-1). The upper middle makes both moves strict, so
                the range shrinks every round until lo meets hi
|#
(def bin-isqrt x = ((((Y bin-isqrt-helper) x) bin-zero) x))

(def bin-isqrt-helper f x lo hi =
    (_if ((bin-eq lo) hi)
        _then lo
        _else (_let mid = ((bin-shr one) (bin-succ ((bin-add lo) hi)))
            (_if ((bin-lte ((bin-mult mid) mid)) x)
                _then (((f x) mid) hi)
                _else (((f x) lo) ((bin-sub mid) bin-one))))))

;===================================================
; MODULAR EXPONENTIATION
;===================================================

#|
    ~ MODULAR EXPONENTIATION ~
    - Contract: (bin-list, bin-list, bin-list) => bin-list
    - Idea: base^ex mod m by square-and-multiply: reading the
                exponent's digits most significant first, each digit
                squares the accumulator, and a one-digit multiplies
                in the base — every step reduced mod m so the numbers
                never grow past the modulus
    - Note: A zero modulus inherits bin-mod's documented totalization
                (x mod 0 = x), so bin-modexp(b, e, 0) = b^e
    - Logic: A fold over the exponent's digit list; the accumulator
                starts at one and is reduced from the first step on
|#
(def bin-modexp base ex m =
    (((((Y bin-modexp-helper) base) m) ex) bin-one))

(def bin-modexp-helper f base m digits acc =
    (_if (isNil digits)
        _then acc
        _else (_let squared = ((bin-mod ((bin-mult acc) acc)) m)
            (_let stepped = (_if (isOne (head digits))
                                _then ((bin-mod ((bin-mult squared) base)) m)
                                _else squared)
                ((((f base) m) (tail digits)) stepped)))))

;===================================================
; EXTENDED EUCLID AND MODULAR INVERSES
;===================================================

#|
    ~ SIGNED REMAINDER ~
    - Contract: (z-bin, z-bin) => z-bin
    - Idea: Helper for the extended Euclid: the remainder that pairs
                with truncated division, r = a - b*(a div b), so that
                a = b*q + r always holds and |r| < |b|
|#
(def bin-z-mod a b =
    ((subZ-bin a) ((multZ-bin b) ((divZ-bin a) b))))

#|
    ~ EXTENDED EUCLIDEAN ALGORITHM ~
    - Contract: (z-bin, z-bin) => {z-bin, {z-bin, z-bin}}
    - Idea: Not just the gcd g of a and b, but the certificate with
                it: coefficients x and y with a*x + b*y = g
    - Logic: euclid(a, 0) is {a, {1, 0}} — a*1 + 0*0 = a. Otherwise
                recurse on (b, a mod b), whose answer gives
                b*x1 + (a - b*q)*y1 = g; regrouping around a and b
                turns that into a*y1 + b*(x1 - q*y1) = g. Each
                remainder is strictly smaller in magnitude, so the
                recursion reaches zero
    - Note: For nonnegative a and b this is the textbook gcd; the
                tests exercise that range and check the certificate
                by evaluating a*x + b*y outright
|#
(def bin-ext-euclid a b = (((Y bin-ext-euclid-helper) a) b))

(def bin-ext-euclid-helper f a b =
    (_if (isZeroZ-bin b)
        _then ((pair a) ((pair bin-posOne) bin-posZero))
        _else (_let q = ((divZ-bin a) b)
            (_let sub = ((f b) ((subZ-bin a) ((multZ-bin b) q)))
                (_let x1 = (head (tail sub))
                    (_let y1 = (tail (tail sub))
                        ((pair (head sub))
                         ((pair y1)
                          ((subZ-bin x1) ((multZ-bin q) y1))))))))))

#|
    ~ MODULAR INVERSE ~
    - Contract: (z-bin, z-bin) => {bool, z-bin}
    - Idea: The x with a*x = 1 (mod m), which exists exactly when
                gcd(a, m) = 1 — the extended Euclid hands it to us as
                the coefficient on a
    - Logic: Run the extended Euclid; if g is one, reduce x into
                [0, m) (the truncated remainder can come out negative,
                in which case one addition of m lands it in range);
                otherwise {false, false}
|#
(def bin-mod-inverse a m =
    (_let res = ((bin-ext-euclid a) m)
        (_if ((eqZ-bin (head res)) bin-posOne)
            _then (_let r = ((bin-z-mod (head (tail res))) m)
                (_if ((ltZ-bin r) bin-posZero)
                    _then ((pair true) ((addZ-bin r) m))
                    _else ((pair true) r)))
            _else ((pair false) false))))
