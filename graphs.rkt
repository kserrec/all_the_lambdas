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

;===================================================
; CYCLES, COMPONENTS, TOPOLOGICAL ORDER
;===================================================

#|
    ~ EDGE CLOSES A LOOP ~
    - Contract: (func, graph, func, list) => bool
    - Idea: Helper for has-cycle: does some edge v -> w (w drawn from
                the list ws) come back around, i.e. is v reachable
                from w?
    - Logic: Try each w; reachable does the walking
|#
(def edge-closes-loop veq g v ws =
    (((((Y edge-closes-loop-helper) veq) g) v) ws))

(def edge-closes-loop-helper f veq g v ws =
    (_if (isNil ws)
        _then false
        _else (_if ((((reachable veq) g) (head ws)) v)
                _then true
                _else ((((f veq) g) v) (tail ws)))))

#|
    ~ HAS CYCLE (directed) ~
    - Contract: (func, graph) => bool
    - Idea: A directed graph has a cycle exactly when some edge
                v -> w closes a loop: w can walk back to v. That is
                the definition itself, checked edge by edge
    - Note: This reads the graph as DIRECTED. A symmetric (undirected-
                style) graph always answers true, since v <-> w is
                already a round trip
    - Logic: For every entry {v, ws}, ask edge-closes-loop; any hit
                is a cycle, no hits anywhere means none
|#
(def has-cycle veq g = ((((Y has-cycle-helper) veq) g) g))

(def has-cycle-helper f veq g entries =
    (_if (isNil entries)
        _then false
        _else (_if ((((edge-closes-loop veq) g) (head (head entries))) (tail (head entries)))
                _then true
                _else (((f veq) g) (tail entries)))))

#|
    ~ CONNECTED COMPONENTS ~
    - Contract: (func, graph) => list of lists
    - Idea: Split the graph into its islands: groups of vertices
                that can reach each other
    - Note: Written for SYMMETRIC (undirected-style) adjacency — when
                every edge runs both ways, "reaches" and "is connected
                to" coincide, and one dfs from any vertex collects its
                whole island
    - Logic: Walk the vertex list carrying two accumulators: the
                components found so far, and a flat list of every
                vertex already assigned to one. An unassigned vertex
                starts a new component — its dfs — and that whole
                component joins the assigned list
|#
(def components veq g =
    (((((( Y components-helper) veq) g) (g-vertices g)) nil) nil))

(def components-helper f veq g vs comps assigned =
    (_if (isNil vs)
        _then (rev comps)
        _else (_let v = (head vs)
            (_if (((member-by veq) v) assigned)
                _then (((((f veq) g) (tail vs)) comps) assigned)
                _else (_let comp = (((dfs veq) g) v)
                        (((((f veq) g) (tail vs))
                            ((pair comp) comps))
                            ((app comp) assigned)))))))

#|
    ~ HAS INCOMING ~
    - Contract: (func, graph, func, list) => bool
    - Idea: Helper for topo-sort: does any vertex still in the
                remaining list point an edge at v?
    - Logic: Check v's membership in each remaining vertex's
                adjacency list
|#
(def has-incoming veq g v us =
    (((((Y has-incoming-helper) veq) g) v) us))

(def has-incoming-helper f veq g v us =
    (_if (isNil us)
        _then false
        _else (_if (((member-by veq) v) (((g-neighbors veq) (head us)) g))
                _then true
                _else ((((f veq) g) v) (tail us)))))

#|
    ~ FIND SOURCE ~
    - Contract: (func, graph, list, list) => {bool, func}
    - Idea: Helper for topo-sort: the first candidate with no
                incoming edge from the remaining vertices
    - Logic: Walk the candidates; {false, false} when every one has
                something pointing at it (which on a DAG cannot happen
                while any remain)
|#
(def find-source veq g vs remaining =
    (((((Y find-source-helper) veq) g) vs) remaining))

(def find-source-helper f veq g vs remaining =
    (_if (isNil vs)
        _then ((pair false) false)
        _else (_if ((((has-incoming veq) g) (head vs)) remaining)
                _then ((((f veq) g) (tail vs)) remaining)
                _else ((pair true) (head vs)))))

#|
    ~ REMOVE BY ~
    - Contract: (func, func, list) => list
    - Logic: The list without every element equal to x
|#
(def remove-by veq x lst =
    ((_filter (lambda (y) (_not ((veq x) y)))) lst))

#|
    ~ TOPOLOGICAL SORT ~
    - Contract: (func, graph) => list
    - Idea: An order for a DAG's vertices in which every edge points
                forward: repeatedly take a vertex nothing remaining
                points at (a source), list it, and remove it
    - Note: Meaningful on DAGs. Cyclic input still terminates — once
                only cycle members remain, no source exists and the
                walk stops early, so the answer simply omits them —
                but it is NOT a topological order of such a graph
    - Logic: Each round either removes one vertex from remaining or
                finds no source and stops, so the recursion is finite
|#
(def topo-sort veq g = ((((Y topo-sort-helper) veq) g) (g-vertices g)))

(def topo-sort-helper f veq g remaining =
    (_if (isNil remaining)
        _then nil
        _else (_let src = ((((find-source veq) g) remaining) remaining)
            (_if (head src)
                _then ((pair (tail src))
                        (((f veq) g) (((remove-by veq) (tail src)) remaining)))
                _else nil))))
