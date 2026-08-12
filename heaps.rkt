#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
(provide (all-defined-out))
(require "core.rkt"
         "church.rkt"
         "logic.rkt"
         "lists.rkt"
         "recursion.rkt")

;===================================================
; PERSISTENT LEFTIST HEAPS
;===================================================

#| LEFTIST HEAPS <rank value left right>

    A heap keeps its smallest element (by the lte comparator every
    operation takes as an argument) at the root of every subtree, so
    the minimum is always one glance away.

    This is a LEFTIST heap: alongside the value, every node carries
    its RANK — the length of its rightmost spine — and maintains
    rank(left) >= rank(right). That keeps the right spine short, and
    the right spine is the only path merging ever walks.

    Like the trees, a heap is its own case analysis: it is applied to
    an empty handler and a node handler.

        h-empty            = \e.\n. e
        h-node rank v l r  = \e.\n. n(rank)(v)(l)(r)

    Everything is persistent: merging, inserting, and deleting build
    new heaps that share structure with the old ones, which stay
    fully usable.
|#

;===================================================

#|
    ~ EMPTY HEAP ~
    - Contract: heap
    - Logic: Applied to two handlers, always picks the empty handler
|#
(def h-empty e n = e)

#|
    ~ HEAP NODE MAKER (raw) ~
    - Contract: (nat, func, heap, heap) => heap
    - Note: h-make below maintains the leftist rank invariant; this
                raw maker just assembles the four parts
    - Logic: Applied to two handlers, hands its parts to the node handler
|#
(def h-node rank v l r e n = ((((n rank) v) l) r))

#|
    ~ IS EMPTY HEAP ~
    - Contract: heap => bool
|#
(def isEmptyH h =
    ((h true) (lambda (rank) (lambda (v) (lambda (l) (lambda (r) false))))))

#|
    ~ RANK ~
    - Contract: heap => nat
    - Logic: The empty heap has rank zero; a node remembers its own
|#
(def h-rank h =
    ((h zero) (lambda (rank) (lambda (v) (lambda (l) (lambda (r) rank))))))

#|
    ~ HEAP ROOT VALUE / SUBHEAPS ~
    - Contract: heap => func / heap
    - Note: Contracts are for node heaps; on h-empty these answer
                false / h-empty (callers check isEmptyH first)
|#
(def h-val h =
    ((h false) (lambda (rank) (lambda (v) (lambda (l) (lambda (r) v))))))

(def h-left h =
    ((h h-empty) (lambda (rank) (lambda (v) (lambda (l) (lambda (r) l))))))

(def h-right h =
    ((h h-empty) (lambda (rank) (lambda (v) (lambda (l) (lambda (r) r))))))

#|
    ~ MAKE (rank-restoring node builder) ~
    - Contract: (func, heap, heap) => heap
    - Idea: Build a node over two subheaps, putting the higher-rank
                one on the left so the leftist invariant holds
    - Logic: The new node's rank is one more than the smaller of the
                two ranks — the shorter spine becomes the right spine
|#
(def h-make v a b =
    (_if ((gte (h-rank a)) (h-rank b))
        _then ((((h-node (succ (h-rank b))) v) a) b)
        _else ((((h-node (succ (h-rank a))) v) b) a)))

#|
    ~ MERGE ~
    - Contract: (func, heap, heap) => heap
    - Idea: The whole leftist idea in one function: the smaller root
                wins, keeps its left subheap, and merges its right
                subheap with the other heap — always walking right
                spines, which ranks keep short
    - Logic: Either heap empty gives the other back. Otherwise compare
                roots with lte and recurse into the winner's right side,
                rebuilding with h-make so ranks stay lawful
|#
(def h-merge lte h1 h2 = ((((Y h-merge-helper) lte) h1) h2))

(def h-merge-helper f lte h1 h2 =
    (_if (isEmptyH h1)
        _then h2
        _else (_if (isEmptyH h2)
                _then h1
                _else (_if ((lte (h-val h1)) (h-val h2))
                        _then (((h-make (h-val h1))
                                (h-left h1))
                                (((f lte) (h-right h1)) h2))
                        _else (((h-make (h-val h2))
                                (h-left h2))
                                (((f lte) h1) (h-right h2)))))))

#|
    ~ SINGLETON ~
    - Contract: func => heap
    - Logic: One value, rank one, two empty subheaps
|#
(def h-singleton x = ((((h-node one) x) h-empty) h-empty))

#|
    ~ INSERT ~
    - Contract: (func, func, heap) => heap
    - Logic: Inserting is just merging with a singleton
|#
(def h-insert lte x h = (((h-merge lte) (h-singleton x)) h))

#|
    ~ FIND MIN ~
    - Contract: heap => {bool, func}
    - Logic: The minimum sits at the root; the empty heap has none,
                so the answer carries a found flag
|#
(def h-find-min h =
    (_if (isEmptyH h)
        _then ((pair false) false)
        _else ((pair true) (h-val h))))

#|
    ~ DELETE MIN ~
    - Contract: (func, heap) => heap
    - Logic: Drop the root; what remains is exactly the merge of its
                two subheaps. Deleting from empty stays empty
|#
(def h-delete-min lte h =
    (_if (isEmptyH h)
        _then h-empty
        _else (((h-merge lte) (h-left h)) (h-right h))))

#|
    ~ HEAP FROM LIST ~
    - Contract: (func, list) => heap
    - Logic: Insert every element, one merge with a singleton at a time
|#
(def heap-from-list lte lst = (((Y heap-from-list-helper) lte) lst))

(def heap-from-list-helper f lte lst =
    (_if (isNil lst)
        _then h-empty
        _else (((h-insert lte) (head lst)) ((f lte) (tail lst)))))

#|
    ~ DRAIN ~
    - Contract: (func, heap) => list
    - Idea: Pop the minimum until the heap is dry — the values come
                out in sorted order, which is what heapsort exploits
    - Logic: Empty contributes nil; otherwise cons the root onto the
                drain of the heap without it
|#
(def h-drain lte h = (((Y h-drain-helper) lte) h))

(def h-drain-helper f lte h =
    (_if (isEmptyH h)
        _then nil
        _else ((pair (h-val h)) ((f lte) ((h-delete-min lte) h)))))
