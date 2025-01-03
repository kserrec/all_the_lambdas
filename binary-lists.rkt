#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
(provide (all-defined-out))
(require "church.rkt"
         "core.rkt"
         "lists.rkt"
         "logic.rkt"
         "recursion.rkt")

;===================================================
; BINARY LISTS - a new numerical encoding
;===================================================

#|
    MOTIVATION: Using Church Numerals defined in Racket has serious limits.
    Representing numbers beyond the tens of millions is not possible on my machine with this encoding.
    The goal here is to support greater values, hopefully far greater, by encoding numbers as lists of binary digits.

    NATURAL NUMBERS as BINARY DIGIT LISTS

    These will be lists like this [1] and [1,1,0]

        0: [0]
        1: [1]
        2: [1,0]
        3: [1,1]
        4: [1,0,0]
        5: [1,0,1]

|#
;===================================================

#|
    ~ FIRST FEW NUMBERS ~
|#
(def bin-zero = (_cons zero))
(def bin-one = (_cons one))
(def bin-two = (_cons one zero))
(def bin-three = (_cons one one))
(def bin-four = (_cons one zero zero))
(def bin-five = (_cons one zero one))
(def bin-ten = (_cons one zero one zero))
(def bin-twenty = (_cons one zero one zero zero))
(def bin-twenty-four = (_cons one one zero zero zero))

;===================================================

#|
    ~ BINARY LIST READER ~
    - Note: this is a helper function for viewing lambda calculus - not pure LC
    - Contract: b-dig => readable(b-dig)
    - Logic: Outputs n for user 
|#
(define (church-to-nat n)
  ((n (lambda (x) (+ x 1))) 0))

(define (bin-read bin-list)
  (let loop ([lst bin-list]
             [len-remaining (church-to-nat (len bin-list))]
             [total 0])
    (if (zero? len-remaining)
        total
        (loop (tail lst)
              (sub1 len-remaining)
              (if (equal? (head lst) one)
                  (+ total (expt 2 (sub1 len-remaining)))
                  total)))))

(def bin-one-billion =
  (_cons one one one zero one one one zero 
         zero one one zero one zero one one 
         zero zero one zero one zero zero zero 
         zero zero zero zero zero zero)
)

(def bin-one-trillion = 
    (_cons one one one zero one zero zero zero one one zero one zero one zero zero one zero one zero zero one zero one zero zero zero one zero zero zero zero zero zero zero zero zero zero zero zero)
)

(def bin-one-quadrillion = 
    (_cons one one one zero zero zero one one zero one zero one one one one one one zero one zero one zero zero one zero zero one one zero zero zero one one zero one zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero)
)

(def bin-one-quintillion = 
    (_cons one one zero one one one one zero zero zero zero zero one zero one one zero one one zero one zero one one zero zero one one one zero one zero zero one one one zero one one zero zero one zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero)
)

(def bin-one-sextillion = 
    (_cons one one zero one one zero zero zero one one zero one zero one one one zero zero one zero zero one one zero one zero one one zero one one one zero zero zero one zero one one one zero one one one one zero one zero one zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero)
)

(displayln "binary digit list - one billion:")
(displayln (bin-read bin-one-billion))

(displayln "binary digit list - one trillion:")
(displayln (bin-read bin-one-trillion))

(displayln "binary digit list - one quadrillion:")
(displayln (bin-read bin-one-quadrillion))

(displayln "binary digit list - one quintillion:")
(displayln (bin-read bin-one-quintillion))

(displayln "binary digit list - one sextillion:")
(displayln (bin-read bin-one-sextillion))

;===================================================

; assumes only zeroes and ones exist
(def isOne digit = (_not (isZero digit)))

#|
    The next two functions, 
    get-place and get-new-carry, 
    are based entirely off this truth table:
    (zeroes are turned to false, ones to true)
    current-carry | dig1 | dig2 | place-val | new-carry
          0          0      0        0           0
          0          1      0        1           0
          0          0      1        1           0
          0          1      1        0           1
          1          0      0        1           0
          1          1      0        0           1
          1          0      1        0           1
          1          1      1        1           1
|#

#|
    ~ gets current place value ~
        if ((carry) AND (not (xor dig1 dig2)))
            -> one
            else (if (not carry) AND (xor dig1 dig2)
                -> one
                else zero
|#
(def get-place-val carry dig1 dig2 = 
    (_let dig1-bool = (isOne dig1)
    (_let dig2-bool = (isOne dig2)
    (_let carry-bool = (isOne carry)
    (_if ((_and carry-bool) (_not ((xor dig1-bool) dig2-bool)))
        _then one
        _else (_if ((_and (_not carry-bool)) ((xor dig1-bool) dig2-bool))
                _then one
                _else zero))))))

#|
    ~ gets next carry value ~
        if ((carry) AND (or dig1 dig2))
            -> one
            else (if (not carry) AND (and dig1 dig2))
                -> one
                else zero
|#
(def get-new-carry carry dig1 dig2 = 
    (_let dig1-bool = (isOne dig1)
    (_let dig2-bool = (isOne dig2)
    (_let carry-bool = (isOne carry)
    (_if ((_and carry-bool) ((_or dig1-bool) dig2-bool))
        _then one
        _else (_if ((_and (_not carry-bool)) ((_and dig1-bool) dig2-bool))
                _then one
                _else zero))))))

#|
    ~ if one list is finished, this will add the carry to the other ~
    if carry is zero, just return list, nothing to add
    else if list is nil, write one for the carry and end it
    else if head is zero, write one for the carry and append the rest (the carry has no more effect)
    else if head is one, write zero - the carry did its work and must carry again so recurse
|#
(def handle-last-digits f l carry = 
    (_if (isZero carry)
        _then l
        _else (_if (isNil l)
                _then ((pair one) nil)
                _else (_if (isZero (head l))
                        _then ((pair one) (tail l))
                        _else ((pair zero) ((f (tail l)) carry))))))

#|
    ~ main helper function ~
    first check if either is nil...
        - then we can just handle the last digits of the other with the carry
    otherwise get the place value for that column and whether we need to carry,
    then put the place value in place and recurse down the list
|#
(def bin-add-helper f l1 l2 carry =
    (_if (isNil l1)
      _then (((Y handle-last-digits) l2) carry)
      _else 
        (_if (isNil l2)
          _then (((Y handle-last-digits) l1) carry)
          _else
            (_let place-val = (((get-place-val carry) (head l1)) (head l2))
            (_let new-carry = (((get-new-carry carry) (head l1)) (head l2))
            ((pair place-val) (((f (tail l1)) (tail l2)) new-carry)))))))

#|
    ~ BINARY DIGIT LIST ADDITION ~
    First reverse their lists since we add right to left but want to traverse these left to right
    Then pass to helper function along with a zero initial carry value for main work 
|#
(def bin-add l1 l2 = (rev ((((Y bin-add-helper) (rev l1)) (rev l2)) zero)))

;===================================================

(displayln "truth table for test get-place-val")
(displayln (n-read (((get-place-val zero) zero) zero)))
(displayln (n-read (((get-place-val zero) zero) one)))
(displayln (n-read (((get-place-val zero) one) zero)))
(displayln (n-read (((get-place-val zero) one) one)))
(displayln (n-read (((get-place-val one) zero) zero)))
(displayln (n-read (((get-place-val one) zero) one)))
(displayln (n-read (((get-place-val one) one) zero)))
(displayln (n-read (((get-place-val one) one) one)))

(displayln "truth table for test get-new-carry")
(displayln (n-read (((get-new-carry zero) zero) zero)))
(displayln (n-read (((get-new-carry zero) zero) one)))
(displayln (n-read (((get-new-carry zero) one) zero)))
(displayln (n-read (((get-new-carry zero) one) one)))
(displayln (n-read (((get-new-carry one) zero) zero)))
(displayln (n-read (((get-new-carry one) zero) one)))
(displayln (n-read (((get-new-carry one) one) zero)))
(displayln (n-read (((get-new-carry one) one) one)))

;===================================================














