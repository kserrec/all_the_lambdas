#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
(provide (all-defined-out))
(require "core.rkt"
         "church.rkt"
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

;===================================================
; BREADTH-FIRST SEARCH
;===================================================

#|
    ~ BREADTH-FIRST SEARCH ~
    - Contract: (func, graph, func) => list
    - Idea: Visit start, then everything one edge away, then two
                edges away, ring by ring
    - Logic: The same worklist walk as dfs with ONE change: the
                worklist is the persistent queue from queues.rkt
                instead of a stack. Neighbors join the BACK of the
                line, so every vertex at the current distance is
                served before any vertex one edge further out
|#
(def bfs veq g start =
    (((((Y bfs-helper) veq) g) ((q-push start) q-empty)) nil))

(def bfs-helper f veq g q visited =
    (_let popped = (q-pop q)
        (_if (head popped)
            _then (_let v = (head (tail popped))
                    (_let rest = (tail (tail popped))
                        (_if (((member-by veq) v) visited)
                            _then ((((f veq) g) rest) visited)
                            _else ((((f veq) g)
                                    ((q-push-all (((g-neighbors veq) v) g)) rest))
                                    ((pair v) visited)))))
            _else (rev visited))))

#|
    ~ UNWEIGHTED DISTANCES ~
    - Contract: (func, graph, func) => list of {vertex, nat}
    - Idea: How many edges is the shortest route from start to each
                reachable vertex? Breadth-first order guarantees the
                FIRST time a vertex is reached is via a shortest route
    - Logic: The bfs walk again, but the queue carries {vertex, dist}
                pairs: neighbors enter the line at distance succ(d).
                A vertex already recorded is dropped (its first,
                shorter record won). The answer lists {vertex,
                distance} pairs in visit order
|#
(def bfs-distances veq g start =
    (((((Y bfs-distances-helper) veq) g)
        ((q-push ((pair start) zero)) q-empty)) nil))

(def bfs-distances-helper f veq g q seen =
    (_let popped = (q-pop q)
        (_if (head popped)
            _then (_let entry = (head (tail popped))
                    (_let rest = (tail (tail popped))
                        (_if (((member-by veq) (head entry)) ((_map head) seen))
                            _then ((((f veq) g) rest) seen)
                            _else ((((f veq) g)
                                    ((q-push-all
                                        ((_map (lambda (w) ((pair w) (succ (tail entry)))))
                                         (((g-neighbors veq) (head entry)) g)))
                                     rest))
                                    ((pair entry) seen)))))
            _else (rev seen))))

;===================================================
; PATH FINDING
;===================================================

#|
    ~ FIND PATH ~
    - Contract: (func, graph, func, func) => {bool, list}
    - Idea: An actual route from one vertex to the other — the list
                of vertices walked, endpoints included — or
                {false, false} when no route exists
    - Logic: A backtracking depth-first search. The helper tries a
                list of alternatives vs from the same spot, with
                visited holding the ancestors of the current attempt
                (the path being extended, worn as a set): an
                alternative already among the ancestors is skipped;
                one equal to the target finishes the path; otherwise
                its own neighbors are tried one level deeper, and if
                they all fail, the remaining alternatives get their
                turn. Paths never repeat a vertex and the graph is
                finite, so the search terminates
|#
(def find-path veq g from to =
    ((((((Y find-path-helper) veq) g) to) (onelist from)) nil))

(def find-path-helper f veq g to vs visited =
    (_if (isNil vs)
        _then ((pair false) false)
        _else (_let v = (head vs)
            (_if (((member-by veq) v) visited)
                _then (((((f veq) g) to) (tail vs)) visited)
                _else (_if ((veq v) to)
                    _then ((pair true) (onelist v))
                    _else (_let sub = (((((f veq) g) to)
                                        (((g-neighbors veq) v) g))
                                        ((pair v) visited))
                        (_if (head sub)
                            _then ((pair true) ((pair v) (tail sub)))
                            _else (((((f veq) g) to) (tail vs)) visited))))))))

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
