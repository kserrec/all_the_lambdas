#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
(provide (all-defined-out))
(require "church.rkt"
         "logic.rkt"
         "recursion.rkt")

;===================================================
; LISTS
;===================================================

#| PAIRS {a,b}

    We will write pairs like this with braces: {a,b},
    but also, when they satisfy the definition below of a list, like this: [a,b].

    Lists will just be recursively defined pairs.
    The empty list will be false, zero, nil, or [] (these will all be the exact same function).
    Definition: list ::= [] | {a,list}, where a is any lambda function.

    Note: We can make lists of anything,
            but to make them easy to read,
            we will usually keep all elements the same loose "type"

    Note: The pair {a,b} is NOT the same as the pair, [a,b].
        In lambda, {a,b} is \f.f(a)(b).
        In lambda, [a,b] is \f.f(a)(\f.f(a)(nil)) (which is {a,{b,[]}} in braces).
|#

;===================================================

#|
    ~ PAIR ~
    - Contract: (func,func) => {func,func}
    - Logic: Takes two arguments and stores them together,
                with both ready to be applied to by any function the pair applies to
|#
(def pair a b f = ((f a) b))

#|
    ~ NIL ~
    - Contract: (func,func) => func
    - Logic: This is a simple placeholder for building lists off of.
|#
(define nil zero)

#|
    ~ HEAD ~
    - Contract: {func,func} => func
    - Logic: Returns "head" or "top" or "car" of pair
|#
(def head f = (f true))

#|
    ~ TAIL ~
    - Contract: {func,func} => func
    - Logic: Returns "tail" or "bottom" or "cdr" of pair
|#
(def tail f = (f false))

#|
    ~ ONE ELEMENT LIST MAKER ~
    - Contract: func => [func] or {func, []}
    - Logic: Takes one function and makes it head with tail as empty list
|#
(def onelist a = ((pair a) nil))

#|
    ~ TWO ELEMENT LIST MAKER ~
    - Contract: (func,func) => [func,func] or {func, {func,[]}]
    - Logic: Takes two functions, makes first head, and second head of tail
|#
(def twolist a b = ((pair a) ((pair b) nil)))



#|
    ~ LIST READER ~
    - Note: this is a helper function for viewing lambda calculus - not pure LC
    - Contract: list => readable(list)
    - Logic: Outputs list for user 
|#
(def l-read lst read-fn =
    (letrec ([helper
        (lambda (l acc)
            (cond
                [(equal? l nil) (string-append acc "]")]
                [(equal? (tail l) nil)
                    (let ([result (read-fn (head l))])
                    (string-append acc
                        (if (string? result)
                            result
                            (number->string result))
                        "]"))]
                [else
                    (helper (tail l)
                        (string-append acc 
                            (let ([result (read-fn (head l))])
                                (if (string? result)
                                    result
                                    (number->string result)))
                            ","))]))])
        (string-append "[" (helper lst ""))))

;===================================================

#|
    ~ LENGTH ~
    - Contract: list => nat
    - Idea: Get length of list (not including nil element)
    - Logic: The inner function (\xyz.f(y)(succ(n))) wipes out the head x of the list, 
                then it recurses taking the tail y as the new list for its first argument
                and successor of n (which starts at 0) as its second argument, 
                and it keeps going until there's nothing left,
                finally returning n as the length of the list
                i.e. the total number of heads it counted through.
|#
(def len _list = (((Y len-helper) _list) nil))

(def len-helper f _list n =
    ((_list (lambda (x)
                (lambda (y)
                    (lambda (z)
                        ((f y) (succ n))
                    )
                )
            ))  n))

#|
    ~ IS NIL ~
    - Contract: list => bool
    - Logic: If length of list is zero, it is nil
|#
(def isNil _list = ((eq (len _list)) zero))

#|
    ~ INDEX ~
    - Contract: (list, nat) => bool
    - Idea: Return value of list at index i
    - Logic: Take head at ith tail of list
|#
(def ind _list i = (head ((i tail) _list)))

;===================================================

#|
    ~ APPEND ~
    - Contract: (list, list) => list
    - Idea: Append two lists, e.g. app[a,b,c][d,e] => [a,b,c,d,e]
    - Logic: Builds a new list from bottom up from list2 and when done, 
                successively adds each element from bottom up of list1.
|#
(define app (Y app-helper))

(def app-helper f l1 l2 = 
    ((l1 (lambda (h)
            (lambda (t)
                (lambda (x)
                    ((pair h) ((f t) l2))
                )
            )
          )) l2))

#|
    ~ REVERSE ~
    - Contract: list => list
    - Idea: Trivial - reverses list
    - Logic: Builds new list up from nil,
                from head of old list on up recursively
|#
(def rev _list = (((Y rev-helper) _list) nil))

(def rev-helper f oldList newList = 
    (((isNil oldList)
        newList)
        ((f (tail oldList)) ((pair (head oldList)) newList))))

;===================================================

#|
    ~ MAP ~
    - Contract: (func, list) => list
    - Idea: Applies function g to each element of list and returns new list with results
    - Logic: Rebuilds list from bottom up applying g to each head x as it goes.
|#
(def _map g _list = ((((Y map-helper) g) _list) nil))

(def map-helper f g _list n = 
    ((_list (lambda (x)
                (lambda (y)
                    (lambda (z)
                        ((pair (g x)) (((f g) y) n))
                    )
                )
            ))  n))

#|
    ~ FILTER ~
    - Contract: (func, list) => list
    - Idea: Applies function g  to each element which returns boolean values and returns filtered list
    - Logic: Rebuilds list from bottom up with each element, 
                but only if they return true when g is applied to them
|#
(def _filter g _list = ((((Y filter-helper) g) _list) nil))

(def filter-helper f g _list n = 
    ((_list (lambda (x)
                (lambda (y)
                    (lambda (z)
                        (_if (g x)
                            _then ((pair x) (((f g) y) n))
                            _else(((f g) y) n)
                        )
                    )
                )
            ))  n))

#|
    ~ FOLD ~
    - Contract: (func, value, list) => new value (of same "type" as original value) 
        - note: value can be any "type" of value
    - Idea: Takes a function g, initial value i, and a list
                and applies g recursively to each element on each other after 
                starting with the initial value to return a final single value
    - Logic: Applies g to both head x and the value return from recursive call until it hits base
|#
(define _fold (Y fold-helper))

(def fold-helper f g i lst = 
    ((lst (lambda (x)
                (lambda (y)
                    (lambda (z)
                        ((g x) (((f g) i) y))
                    )
                )
            ))  i))

;===================================================

#|
    ~ TAKE ~
    - Contract: (nat, list) => list
        - note: if n > len(list) => entire list
    - Idea: Makes new list out of the first n values of the list
    - Logic: If n is zero or list is nil, return nil (recursive base and easy cases)
                else build list with head and count down n recursively, 
                building new list until n runs out and n elements have been "taken"
|#
(define _take (Y take-helper))

(def take-helper f n _list =
    ((((_or (isZero n)) (isNil _list))
            nil)
            ((pair 
                (head _list)) 
                ((f (pred n)) (tail _list)))))

#|
    ~ TAKE TAIL ~
    - Contract: (nat, list) => list
        - note: if nat > len(list) => entire list
    - Idea: Makes new list out of the last n values of the list
    - Logic: Reverses the take of n elements of the reverse of the list
|#
(def takeTail n _list = (rev ((_take  n) (rev _list))))

#|
    ~ INSERT ~
    - Contract: (value, list, nat) => list
    - Idea: Insert value into list at index i
    - Logic: Append take of first i elements,
                insert value at index i,
                then add tail behind it
|#
(def insert val _list i = 
    ((app
        ((_take i) _list))
        ((pair val) ((takeTail ((sub (len _list)) i)) _list))))

#|
    ~ REPLACE ~
    - Contract: (value, list, nat) => list
    - Idea: Replace value in list at index i
    - Logic: Append take of first i elements,
                insert value at index i,
                then add one less than tail behind it
|#
(def replace val _list i =
    ((app
        ((_take i) _list))
        ((pair val) ((takeTail (pred ((sub (len _list)) i))) _list))))

#|
    ~ DROP ~
    - Contract: (nat, list) => list
    - Idea: Remove first n elements from list
    - Logic: Just like takeTail but amount to take is length of list minus n
|#
(def _drop n _list = 
    (rev ((_take 
            ((sub (len _list)) n))
            (rev _list))))

;===================================================