#lang s-exp "../macros/lazy-with-macros.rkt"
(require "../macros/macros.rkt")
(require "../church.rkt"
         "../core.rkt"
         "../logic.rkt"
         "../lists.rkt"
         "../binary-lists.rkt"
         "../int-binary-lists.rkt"
         "../binary-algorithms.rkt"
         "helpers/test-helpers.rkt")

; ====================================================================
; ~ BINARY ALGORITHMS TESTS ~
; ====================================================================

(define bin-shl-tests (list
    (test-list-element "5 << 1" (bin-read ((bin-shl one) bin-five)) "10")
    (test-list-element "5 << 2" (bin-read ((bin-shl two) bin-five)) "20")
    (test-list-element "1 << 3" (bin-read ((bin-shl three) bin-one)) "8")
    (test-list-element "0 << 3" (bin-read ((bin-shl three) bin-zero)) "0")
    (test-list-element "7 << 0" (bin-read ((bin-shl zero) bin-seven)) "7")))

(show-results "bin-shl" bin-shl-tests)

; ====================================================================

(define bin-shr-tests (list
    (test-list-element "5 >> 1" (bin-read ((bin-shr one) bin-five)) "2")
    (test-list-element "20 >> 2" (bin-read ((bin-shr two) bin-twenty)) "5")
    (test-list-element "5 >> 3" (bin-read ((bin-shr three) bin-five)) "0")
    (test-list-element "5 >> 5 (past length)" (bin-read ((bin-shr five) bin-five)) "0")
    (test-list-element "0 >> 1" (bin-read ((bin-shr one) bin-zero)) "0")
    (test-list-element "7 >> 0" (bin-read ((bin-shr zero) bin-seven)) "7")))

(show-results "bin-shr" bin-shr-tests)

; ====================================================================

; bin-not-w(w, x) = (2^w - 1) - x
(define bin-not-w-tests (list
    (test-list-element "not-w(4, 5): 0101->1010" (bin-read ((bin-not-w four) bin-five)) "10")
    (test-list-element "not-w(3, 5): 101->010" (bin-read ((bin-not-w three) bin-five)) "2")
    (test-list-element "not-w(2, 12): low bits 00->11" (bin-read ((bin-not-w two) bin-twelve)) "3")
    (test-list-element "not-w(3, 0): 000->111" (bin-read ((bin-not-w three) bin-zero)) "7")
    (test-list-element "not-w(4, 15): all ones out" (bin-read ((bin-not-w four) bin-fifteen)) "0")))

(show-results "bin-not-w" bin-not-w-tests)

; ====================================================================

(define bit-length-tests (list
    (test-list-element "bit-length(0)" (n-read (bin-bit-length bin-zero)) "1")
    (test-list-element "bit-length(1)" (n-read (bin-bit-length bin-one)) "1")
    (test-list-element "bit-length(5)" (n-read (bin-bit-length bin-five)) "3")
    (test-list-element "bit-length(16)" (n-read (bin-bit-length bin-sixteen)) "5")
    (test-list-element "bit-length(unnormalized 0...5)" (n-read (bin-bit-length ((prepend-zeroes two) bin-five))) "3")))

(show-results "bin-bit-length" bit-length-tests)

; ====================================================================

(define popcount-tests (list
    (test-list-element "popcount(0)" (n-read (bin-popcount bin-zero)) "0")
    (test-list-element "popcount(1)" (n-read (bin-popcount bin-one)) "1")
    (test-list-element "popcount(5)" (n-read (bin-popcount bin-five)) "2")
    (test-list-element "popcount(7)" (n-read (bin-popcount bin-seven)) "3")
    (test-list-element "popcount(16)" (n-read (bin-popcount bin-sixteen)) "1")))

(show-results "bin-popcount" popcount-tests)

; ====================================================================

(define bitwise-tests (list
    (test-list-element "5 AND 3" (bin-read ((bin-and bin-five) bin-three)) "1")
    (test-list-element "5 OR 3" (bin-read ((bin-or bin-five) bin-three)) "7")
    (test-list-element "5 XOR 3" (bin-read ((bin-xor bin-five) bin-three)) "6")
    (test-list-element "12 AND 10" (bin-read ((bin-and bin-twelve) bin-ten)) "8")
    (test-list-element "12 OR 10" (bin-read ((bin-or bin-twelve) bin-ten)) "14")
    (test-list-element "12 XOR 10" (bin-read ((bin-xor bin-twelve) bin-ten)) "6")
    (test-list-element "16 AND 0" (bin-read ((bin-and bin-sixteen) bin-zero)) "0")
    (test-list-element "16 OR 0" (bin-read ((bin-or bin-sixteen) bin-zero)) "16")
    (test-list-element "7 XOR 7" (bin-read ((bin-xor bin-seven) bin-seven)) "0")))

(show-results "bitwise and/or/xor" bitwise-tests)

; ====================================================================

(define conversion-tests (list
    (test-list-element "bin-to-church(0)" (n-read (bin-to-church bin-zero)) "0")
    (test-list-element "bin-to-church(1)" (n-read (bin-to-church bin-one)) "1")
    (test-list-element "bin-to-church(5)" (n-read (bin-to-church bin-five)) "5")
    (test-list-element "bin-to-church(16)" (n-read (bin-to-church bin-sixteen)) "16")
    (test-list-element "church-to-bin(0)" (bin-read (church-to-bin zero)) "0")
    (test-list-element "church-to-bin(1)" (bin-read (church-to-bin one)) "1")
    (test-list-element "church-to-bin(5)" (bin-read (church-to-bin five)) "5")
    (test-list-element "round-trip bin(7)" (bin-read (church-to-bin (bin-to-church bin-seven))) "7")
    (test-list-element "round-trip bin(10)" (bin-read (church-to-bin (bin-to-church bin-ten))) "10")
    (test-list-element "round-trip church(4)" (n-read (bin-to-church (church-to-bin four))) "4")))

(show-results "binary <-> church conversions" conversion-tests)

; ====================================================================

(define isqrt-tests (list
    (test-list-element "isqrt(0)" (bin-read (bin-isqrt bin-zero)) "0")
    (test-list-element "isqrt(1)" (bin-read (bin-isqrt bin-one)) "1")
    (test-list-element "isqrt(2)" (bin-read (bin-isqrt bin-two)) "1")
    (test-list-element "isqrt(3)" (bin-read (bin-isqrt bin-three)) "1")
    (test-list-element "isqrt(4)" (bin-read (bin-isqrt bin-four)) "2")
    (test-list-element "isqrt(8)" (bin-read (bin-isqrt bin-eight)) "2")
    (test-list-element "isqrt(9)" (bin-read (bin-isqrt bin-nine)) "3")
    (test-list-element "isqrt(15)" (bin-read (bin-isqrt bin-fifteen)) "3")
    (test-list-element "isqrt(16)" (bin-read (bin-isqrt bin-sixteen)) "4")
    (test-list-element "isqrt(31)" (bin-read (bin-isqrt bin-thirty-one)) "5")
    (test-list-element "isqrt(64)" (bin-read (bin-isqrt bin-sixty-four)) "8")
    (test-list-element "isqrt(127)" (bin-read (bin-isqrt bin-one-hundred-twenty-seven)) "11")))

(show-results "bin-isqrt" isqrt-tests)

; ====================================================================

(define modexp-tests (list
    (test-list-element "2^3 mod 5" (bin-read (((bin-modexp bin-two) bin-three) bin-five)) "3")
    (test-list-element "3^4 mod 7" (bin-read (((bin-modexp bin-three) bin-four) bin-seven)) "4")
    (test-list-element "5^0 mod 3" (bin-read (((bin-modexp bin-five) bin-zero) bin-three)) "1")
    (test-list-element "2^10 mod 10" (bin-read (((bin-modexp bin-two) bin-ten) bin-ten)) "4")
    (test-list-element "7^2 mod 4" (bin-read (((bin-modexp bin-seven) bin-two) bin-four)) "1")
    (test-list-element "agrees with exp-then-mod" (bin-read (((bin-modexp bin-three) bin-four) bin-five))
        (bin-read ((bin-mod ((bin-exp bin-three) bin-four)) bin-five)))))

(show-results "bin-modexp" modexp-tests)

; ====================================================================

; Signed fixtures for the extended Euclid
(define zb-six ((makeZ-bin true) bin-six))
(define zb-four ((makeZ-bin true) bin-four))
(define zb-seven ((makeZ-bin true) bin-seven))
(define zb-five-p ((makeZ-bin true) bin-five))
(define zb-three-p ((makeZ-bin true) bin-three))

; Evaluate the Bezout certificate a*x + b*y for a result {g, {x, y}}
(define (bezout a b res)
    (bin-z-read
        ((addZ-bin ((multZ-bin a) (head (tail res))))
         ((multZ-bin b) (tail (tail res))))))

(define ee-64 ((bin-ext-euclid zb-six) zb-four))
(define ee-75 ((bin-ext-euclid zb-seven) zb-five-p))
(define ee-50 ((bin-ext-euclid zb-five-p) bin-posZero))

(define ext-euclid-tests (list
    (test-list-element "gcd(6,4)" (bin-z-read (head ee-64)) "2")
    (test-list-element "bezout(6,4) = gcd" (bezout zb-six zb-four ee-64) "2")
    (test-list-element "gcd(7,5)" (bin-z-read (head ee-75)) "1")
    (test-list-element "bezout(7,5) = gcd" (bezout zb-seven zb-five-p ee-75) "1")
    (test-list-element "gcd(5,0)" (bin-z-read (head ee-50)) "5")
    (test-list-element "x for (5,0)" (bin-z-read (head (tail ee-50))) "1")
    (test-list-element "y for (5,0)" (bin-z-read (tail (tail ee-50))) "0")))

(show-results "bin-ext-euclid" ext-euclid-tests)

; ====================================================================

(define inv-3-mod-7 ((bin-mod-inverse zb-three-p) zb-seven))
(define inv-5-mod-7 ((bin-mod-inverse zb-five-p) zb-seven))
(define inv-2-mod-4 ((bin-mod-inverse ((makeZ-bin true) bin-two)) zb-four))
(define inv-1-mod-5 ((bin-mod-inverse bin-posOne) zb-five-p))

(define mod-inverse-tests (list
    (test-list-element "inverse(3 mod 7) found" (b-read (head inv-3-mod-7)) "true")
    (test-list-element "inverse(3 mod 7)" (bin-z-read (tail inv-3-mod-7)) "5")
    (test-list-element "inverse(5 mod 7)" (bin-z-read (tail inv-5-mod-7)) "3")
    (test-list-element "inverse(1 mod 5)" (bin-z-read (tail inv-1-mod-5)) "1")
    (test-list-element "inverse(2 mod 4) found" (b-read (head inv-2-mod-4)) "false")))

(show-results "bin-mod-inverse" mod-inverse-tests)

; ====================================================================

(define trial-division-tests (list
    (test-list-element "prime(0)" (b-read (bin-is-prime bin-zero)) "false")
    (test-list-element "prime(1)" (b-read (bin-is-prime bin-one)) "false")
    (test-list-element "prime(2)" (b-read (bin-is-prime bin-two)) "true")
    (test-list-element "prime(3)" (b-read (bin-is-prime bin-three)) "true")
    (test-list-element "prime(4)" (b-read (bin-is-prime bin-four)) "false")
    (test-list-element "prime(5)" (b-read (bin-is-prime bin-five)) "true")
    (test-list-element "prime(7)" (b-read (bin-is-prime bin-seven)) "true")
    (test-list-element "prime(9)" (b-read (bin-is-prime bin-nine)) "false")
    (test-list-element "prime(15)" (b-read (bin-is-prime bin-fifteen)) "false")
    (test-list-element "prime(31)" (b-read (bin-is-prime bin-thirty-one)) "true")))

(show-results "bin-is-prime (trial division)" trial-division-tests)

; ====================================================================

; Miller-Rabin with witness bases [2, 3] — deterministic far past
; every value tested here
(define mr-bases (_cons bin-two bin-three))

(define miller-rabin-tests (list
    (test-list-element "mr(2)" (b-read ((bin-is-prime-mr bin-two) mr-bases)) "true")
    (test-list-element "mr(3)" (b-read ((bin-is-prime-mr bin-three) mr-bases)) "true")
    (test-list-element "mr(5)" (b-read ((bin-is-prime-mr bin-five) mr-bases)) "true")
    (test-list-element "mr(7)" (b-read ((bin-is-prime-mr bin-seven) mr-bases)) "true")
    (test-list-element "mr(31)" (b-read ((bin-is-prime-mr bin-thirty-one) mr-bases)) "true")
    (test-list-element "mr(1)" (b-read ((bin-is-prime-mr bin-one) mr-bases)) "false")
    (test-list-element "mr(9)" (b-read ((bin-is-prime-mr bin-nine) mr-bases)) "false")
    (test-list-element "mr(15)" (b-read ((bin-is-prime-mr bin-fifteen) mr-bases)) "false")
    (test-list-element "mr(16)" (b-read ((bin-is-prime-mr bin-sixteen) mr-bases)) "false")
    (test-list-element "mr agrees with trial on 25"
        (b-read ((bin-is-prime-mr ((bin-add bin-twenty) bin-five)) mr-bases))
        (b-read (bin-is-prime ((bin-add bin-twenty) bin-five))))))

(show-results "bin-is-prime-mr" miller-rabin-tests)

; ====================================================================

(define fib-tests (list
    (test-list-element "fib(0)" (bin-read (bin-fib bin-zero)) "0")
    (test-list-element "fib(1)" (bin-read (bin-fib bin-one)) "1")
    (test-list-element "fib(2)" (bin-read (bin-fib bin-two)) "1")
    (test-list-element "fib(3)" (bin-read (bin-fib bin-three)) "2")
    (test-list-element "fib(4)" (bin-read (bin-fib bin-four)) "3")
    (test-list-element "fib(5)" (bin-read (bin-fib bin-five)) "5")
    (test-list-element "fib(6)" (bin-read (bin-fib bin-six)) "8")
    (test-list-element "fib(7)" (bin-read (bin-fib bin-seven)) "13")
    (test-list-element "fib(8)" (bin-read (bin-fib bin-eight)) "21")
    (test-list-element "fib(9)" (bin-read (bin-fib bin-nine)) "34")
    (test-list-element "fib(10)" (bin-read (bin-fib bin-ten)) "55")
    (test-list-element "fib(12)" (bin-read (bin-fib bin-twelve)) "144")))

(show-results "bin-fib (fast doubling)" fib-tests)
