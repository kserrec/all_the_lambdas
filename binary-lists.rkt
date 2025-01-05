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

    These will be lists like this [1] and [1,1,0], etc.

    Some examples...
        0: [0] = (zero, nil)
        1: [1] = (one, nil)
        2: [1,0] = (one, (zero, nil))
        3: [1,1] = (one, (one, nil))
        4: [1,0,0] = (one, (zero, (zero, nil)))
        5: [1,0,1] = (one, (zero, (one, nil)))
|#
;===================================================

#|
    ~ A FEW NUMBERS ~
|#
(def bin-zero = (_cons zero))
(def bin-one = (_cons one))
(def bin-two = (_cons one zero))
(def bin-three = (_cons one one))
(def bin-four = (_cons one zero zero))
(def bin-five = (_cons one zero one))
(def bin-six = (_cons one one zero))
(def bin-seven = (_cons one one one))
(def bin-eight = (_cons one zero zero zero))
(def bin-nine = (_cons one zero zero one))
(def bin-ten = (_cons one zero one zero))
(def bin-twelve = (_cons one one zero zero))
(def bin-fifteen = (_cons one one one one))
(def bin-sixteen = (_cons one zero zero zero zero))
(def bin-twenty = (_cons one zero one zero zero))
(def bin-twenty-four = (_cons one one zero zero zero))
(def bin-thirty-one = (_cons one one one one one))
(def bin-thirty-two = (_cons one zero zero zero zero zero))
(def bin-sixty-four = (_cons one zero zero zero zero zero zero))
(def bin-one-hundred-twenty-seven = (_cons one one one one one one one))
(def bin-one-hundred-twenty-eight = (_cons one zero zero zero zero zero zero zero))
(def bin-two-hundred-fifty-five = (_cons one one one one one one one one))
(def bin-two-hundred-fifty-six = (_cons one zero zero zero zero zero zero zero zero))
(def bin-five-hundred-twelve = (_cons one zero zero zero zero zero zero zero zero zero))
(def bin-one-k-twenty-three = (_cons one one one one one one one one one one))
(def bin-two-k-forty-eight = (_cons one zero zero zero zero zero zero zero zero zero zero zero))
(def bin-sixty-five-k-five-hundred-thirty-six = (_cons one zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero))
(def bin-one-hundred-thirty-one-k-seventy-two = (_cons one zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero))
(def bin-one-billion =
  (_cons one one one zero one one one zero 
         zero one one zero one zero one one 
         zero zero one zero one zero zero zero 
         zero zero zero zero zero zero)
)
(def bin-two-billion =
  (_cons one one one zero one one one zero 
         zero one one zero one zero one one 
         zero zero one zero one zero zero zero 
         zero zero zero zero zero zero zero)
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
(def bin-one-sextillion-and-three = 
    (_cons one one zero one one zero zero zero one one zero one zero one one one zero zero one zero zero one one zero one zero one one zero one one one zero zero zero one zero one one one zero one one one one zero one zero one zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero zero one one)
)

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
        (number->string total)
        (loop (tail lst)
              (sub1 len-remaining)
              (if (equal? (head lst) one)
                  (+ total (expt 2 (sub1 len-remaining)))
                  total)))))

;===================================================

; assumes only zeroes and ones exist
(def isOne digit = (_not (isZero digit)))

#|
    The next two functions, 
    get-place-val and get-new-carry, 
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
    Contract: (bin-list, bin-list) => bin-list
    Idea: The goal here is to make this algorithm as similar to the actual algorithm we use when we add numbers as possible.
    Logic:
        - First reverse their lists since we add right to left but want to traverse these left to right
        - Then pass to helper function along with a zero initial carry value for main work 
        - Reverse back on the way out
|#
(def bin-add l1 l2 = (rev ((((Y bin-add-helper) (rev l1)) (rev l2)) zero)))

;===================================================

#|
    ~ BINARY DIGIT LIST MULTIPLICATION BY 2 ~
    Easy as can be - just append a zero
|#
(def bin-mult-2 bin-num = ((app bin-num) bin-zero))

; Repeat multiplication by 2 for this - also easy as can be
(def bin-mult-pow-2 bin-num n = ((n bin-mult-2) bin-num))

#|
    ~ BINARY DIGIT LIST MULTIPLICATION HELPER ~
    - Assume l1 is greater or equal length (it goes on top for multiplication)
    - If counter plus one is greater than len l1, break, we're at the end and have no more to multiply by
    - Check l2 first digit - if its one, mult l1 by pow 2 for place value alignment 
        (like adding zeroes when we multiply down each line)
        and add to the running total (like adding up all the rows)
    - Then increase counter and repeat
|#
(def bin-mult-helper f l1 l2 l1-len counter running-total = 
    (_if (isNil l2)
        _then running-total
        _else
            (_let new-running-total = ((bin-add ((bin-mult-pow-2 (rev l1)) counter)) running-total)
            (_let new-counter = (succ counter)
            (_if ((gt (succ counter)) l1-len)
                _then running-total
                _else (_if (isOne (head l2))
                        _then (((((f l1) (tail l2)) l1-len) new-counter) new-running-total)
                        _else (((((f l1) (tail l2)) l1-len) new-counter) running-total)))))))

#|
    ~ BINARY DIGIT LIST MULTIPLICATION ~
    Contract: (bin-list, bin-list) => bin-list
    Idea: The goal here is to make this algorithm as similar to the actual algorithm we use when we multiply numbers as possible.
    Logic:
        - First find which is greater, then pass that as first list to helper for main work (bigger number on top)
        - Also reverse lists since we multiply right to left but want to traverse left to right
|#
(def bin-mult l1 l2 = 
    (_if ((gte (len l1)) (len l2))
        _then ((((((Y bin-mult-helper) (rev l1)) (rev l2)) (len l1)) zero) bin-zero)
        _else ((((((Y bin-mult-helper) (rev l2)) (rev l1)) (len l2)) zero) bin-zero)))


;===================================================

#|
    The function get-new-borrow, 
    is based entirely off this truth table:
    (zeroes are turned to false, ones to true)
    current-borrow | dig1 | dig2 | new-borrow
          0           0      0        0
          0           1      0        0
          0           0      1        1
          0           1      1        0
          1           0      0        1
          1           1      0        0
          1           0      1        1
          1           1      1        1
|#
(def get-new-borrow-sub carry dig1 dig2 = 
    (_let dig1-bool = (isOne dig1)
    (_let dig2-bool = (isOne dig2)
    (_let carry-bool = (isOne carry)
    (_if ((_and carry-bool) ((_or (_not dig1-bool)) dig2-bool))
        _then one
        _else (_if ((_and (_not carry-bool)) ((_and (_not dig1-bool)) dig2-bool))
                _then one
                _else zero))))))

#|
    ~ if one list is finished, this will subtract the borrow from the other ~
    if borrow is zero, just return list, nothing to sub
    else if list is nil, write one for the borrow and end it
    else if head is zero, write one for the borrow and must borrow again so recurse
    else if head is one, write zero for the borrow and append the rest (the borrow has no more effect)
|#
(def handle-last-digits-sub f l borrow =
  (_if (isZero borrow)
      _then l
      _else
        (_if (isNil l)
            _then ((pair one) nil)
            _else (_if (isZero (head l))
                _then ((pair one) ((f (tail l)) one))
                _else ((pair zero) (tail l))))))

#|
    ~ main helper function ~
    first check if either is nil...
        - then we can just handle the last digits of the other with the borrow
    otherwise get the place value for that column and whether we need to borrow,
    then put the place value in place and recurse down the list
    note: get-place-val is same as for addition but with digits flipped
    note: this function does not work if l1 < l2 - gets unpredictable results
|#
(def bin-sub-helper f l1 l2 borrow =
  (_if (isNil l1)
    _then (((Y handle-last-digits-sub) l2) borrow)
    _else
      (_if (isNil l2)
        _then (((Y handle-last-digits-sub) l1) borrow)
        _else
          (_let place-val = (((get-place-val borrow) (head l2)) (head l1))
          (_let new-borrow = (((get-new-borrow-sub borrow) (head l1)) (head l2))
          ((pair place-val) (((f (tail l1)) (tail l2)) new-borrow)))))))

#|
    ~ BINARY DIGIT LIST SUBTRACTION ~
    Contract: (bin-list, bin-list) => bin-list
    Idea: The goal here is to make this algorithm as similar to the actual algorithm we use when we subtract numbers as possible.
    Logic:
        - First reverse their lists since we sub right to left but want to traverse these left to right
        - Then pass to helper function along with a zero initial carry value for main work 
        - Reverse back on the way out
|#
(def bin-sub l1 l2 =
  (rev ((((Y bin-sub-helper) (rev l1)) (rev l2)) zero)))