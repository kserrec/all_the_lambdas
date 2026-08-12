#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
(provide (all-defined-out))
(require "core.rkt"
         "logic.rkt"
         "lists.rkt"
         "queues.rkt"
         "recursion.rkt")

;===================================================
; GRAPHS
;===================================================

#| GRAPHS [{vertex, [neighbor, ...]}, ...]

    A graph is a lambda list of entries; each entry pairs a vertex
    with its adjacency list (the vertices its edges point at). The
    edges are directed — an undirected graph is simply one whose
    adjacency lists happen to be symmetric.

    Vertices can be ANY values the caller can compare: every
    operation takes a vertex-equality predicate veq first, the same
    way the search trees and sorts take their comparator. Church
    naturals with eq, integers with eqZ, binary naturals with bin-eq —
    one graph library for all of them.

    There is no mutation and no host-language set anywhere: every
    traversal threads its "already seen" list through the recursion
    explicitly, as a value.
|#

;===================================================

#|
    ~ MEMBER BY ~
    - Contract: (func, func, list) => bool
    - Idea: Is x in the list, judged by the given equality?
    - Logic: Walk the list; answer true at the first element equal to
                x, false at nil
|#
(def member-by veq x lst = ((((Y member-by-helper) veq) x) lst))

(def member-by-helper f veq x lst =
    (_if (isNil lst)
        _then false
        _else (_if ((veq x) (head lst))
                _then true
                _else (((f veq) x) (tail lst)))))

#|
    ~ VERTICES ~
    - Contract: graph => list
    - Logic: The first component of every entry
|#
(def g-vertices g = ((_map head) g))

#|
    ~ NEIGHBORS ~
    - Contract: (func, func, graph) => list
    - Idea: The adjacency list recorded for vertex v
    - Logic: Walk the entries to the one whose vertex equals v and
                hand back its list; a vertex with no entry has no
                neighbors — nil
|#
(def g-neighbors veq v g = ((((Y g-neighbors-helper) veq) v) g))

(def g-neighbors-helper f veq v g =
    (_if (isNil g)
        _then nil
        _else (_if ((veq v) (head (head g)))
                _then (tail (head g))
                _else (((f veq) v) (tail g)))))

;===================================================
; DEPTH-FIRST SEARCH
;===================================================

#|
    ~ DEPTH-FIRST SEARCH ~
    - Contract: (func, graph, func) => list
    - Idea: Visit start, then plunge down its first unvisited
                neighbor before looking at the second, and so on —
                the visit order of a preorder walk
    - Logic: One worklist recursion instead of two mutually recursive
                functions: the stack starts as [start]. Each round
                pops the top vertex; if it is already in the visited
                list it is dropped, otherwise it is recorded and its
                whole adjacency list is laid on TOP of the stack (that
                is what makes the search go deep first). The visited
                list collects newest-first and is reversed at the end
                into visit order. Every round either shrinks the stack
                or marks a vertex no round can mark again, so the walk
                terminates — cycles and all — with no mutation and no
                host set: the visited list is threaded as a value
|#
(def dfs veq g start = (((((Y dfs-helper) veq) g) (onelist start)) nil))

(def dfs-helper f veq g stack visited =
    (_if (isNil stack)
        _then (rev visited)
        _else (_let v = (head stack)
                (_if (((member-by veq) v) visited)
                    _then ((((f veq) g) (tail stack)) visited)
                    _else ((((f veq) g)
                            ((app (((g-neighbors veq) v) g)) (tail stack)))
                            ((pair v) visited))))))

#|
    ~ REACHABLE ~
    - Contract: (func, graph, func, func) => bool
    - Idea: Does some directed path lead from one vertex to the other?
    - Logic: to is reachable from from exactly when it appears in the
                depth-first visit list rooted at from (a vertex always
                reaches itself)
|#
(def reachable veq g from to =
    (((member-by veq) to) (((dfs veq) g) from)))
