#lang s-exp "../macros/lazy-with-macros.rkt"
(require "../macros/macros.rkt")
(require "../church.rkt"
         "../core.rkt"
         "../logic.rkt"
         "../lists.rkt"
         "../graphs.rkt"
         "helpers/test-helpers.rkt")

; ====================================================================
; ~ GRAPHS TESTS ~
; ====================================================================

; Fixtures over Church-natural vertices.
;   g-line:     1 -> 2 -> 3
;   g-cycle:    1 -> 2 -> 3 -> 1
;   g-diamond:  1 -> 2, 1 -> 3, 2 -> 4, 3 -> 4        (a DAG)
;   g-split:    1 <-> 2, 3 alone                       (symmetric)
(define g-line (_cons
    ((pair one) (onelist two))
    ((pair two) (onelist three))
    ((pair three) nil)))

(define g-cycle (_cons
    ((pair one) (onelist two))
    ((pair two) (onelist three))
    ((pair three) (onelist one))))

(define g-diamond (_cons
    ((pair one) (_cons two three))
    ((pair two) (onelist four))
    ((pair three) (onelist four))
    ((pair four) nil)))

(define g-split (_cons
    ((pair one) (onelist two))
    ((pair two) (onelist one))
    ((pair three) nil)))

; ====================================================================

(define member-by-tests (list
    (test-list-element "member-by(2,[1,2,3])" (b-read (((member-by eq) two) (_cons one two three))) "true")
    (test-list-element "member-by(4,[1,2,3])" (b-read (((member-by eq) four) (_cons one two three))) "false")
    (test-list-element "member-by(1,[])" (b-read (((member-by eq) one) nil)) "false")))

(show-results "member-by" member-by-tests)

; ====================================================================

(define representation-tests (list
    (test-list-element "vertices(g-diamond)" ((l-read (g-vertices g-diamond)) n-read) "[1,2,3,4]")
    (test-list-element "neighbors(1,g-diamond)" ((l-read (((g-neighbors eq) one) g-diamond)) n-read) "[2,3]")
    (test-list-element "neighbors(4,g-diamond)" ((l-read (((g-neighbors eq) four) g-diamond)) n-read) "[]")
    (test-list-element "neighbors(absent 5)" ((l-read (((g-neighbors eq) five) g-diamond)) n-read) "[]")))

(show-results "graph representation" representation-tests)

; ====================================================================

(define dfs-tests (list
    (test-list-element "dfs(g-line,1)" ((l-read (((dfs eq) g-line) one)) n-read) "[1,2,3]")
    (test-list-element "dfs(g-line,2)" ((l-read (((dfs eq) g-line) two)) n-read) "[2,3]")
    (test-list-element "dfs(g-cycle,1) terminates" ((l-read (((dfs eq) g-cycle) one)) n-read) "[1,2,3]")
    (test-list-element "dfs(g-diamond,1) preorder" ((l-read (((dfs eq) g-diamond) one)) n-read) "[1,2,4,3]")
    (test-list-element "dfs(g-split,3)" ((l-read (((dfs eq) g-split) three)) n-read) "[3]")))

(show-results "dfs" dfs-tests)

; ====================================================================

(define reachable-tests (list
    (test-list-element "reachable(1~>3, line)" (b-read ((((reachable eq) g-line) one) three)) "true")
    (test-list-element "reachable(3~>1, line)" (b-read ((((reachable eq) g-line) three) one)) "false")
    (test-list-element "reachable(3~>2, cycle)" (b-read ((((reachable eq) g-cycle) three) two)) "true")
    (test-list-element "reachable(1~>4, diamond)" (b-read ((((reachable eq) g-diamond) one) four)) "true")
    (test-list-element "reachable(4~>1, diamond)" (b-read ((((reachable eq) g-diamond) four) one)) "false")
    (test-list-element "reachable(1~>3, split)" (b-read ((((reachable eq) g-split) one) three)) "false")
    (test-list-element "reachable(self)" (b-read ((((reachable eq) g-split) three) three)) "true")))

(show-results "reachable" reachable-tests)
