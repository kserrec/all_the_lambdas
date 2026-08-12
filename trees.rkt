#lang s-exp "macros/lazy-with-macros.rkt"
(require "macros/macros.rkt")
(provide (all-defined-out))
(require "core.rkt"
         "church.rkt"
         "logic.rkt"
         "lists.rkt"
         "recursion.rkt")

;===================================================
; PERSISTENT BINARY TREES
;===================================================

#| TREES <left value right>

    A tree is either empty, or a node holding a left subtree, a value,
    and a right subtree:

        tree ::= t-empty | t-node left value right

    Every case distinction is performed by applying the tree itself to
    two handlers — one for the empty case, one for the node case:

        t-empty      = \e.\n. e
        t-node l v r = \e.\n. n(l)(v)(r)

    This is the same discrimination-by-application idea the rest of the
    repository uses for booleans and pairs: the data IS the branch.

    These trees are automatically persistent: an operation that "changes"
    a tree really builds a new tree out of old pieces, and the old tree
    remains fully usable, because nothing is ever mutated — there is
    nothing here that COULD mutate.
|#

;===================================================

#|
    ~ EMPTY TREE ~
    - Contract: tree
    - Logic: Applied to two handlers, always picks the empty handler
|#
(def t-empty e n = e)

#|
    ~ NODE MAKER ~
    - Contract: (tree, func, tree) => tree
    - Idea: Build the tree with value v, left subtree l, right subtree r
    - Logic: Applied to two handlers, hands its three parts to the node handler
|#
(def t-node l v r e n = (((n l) v) r))

#|
    ~ LEAF MAKER ~
    - Contract: func => tree
    - Logic: A leaf is a node whose two subtrees are both empty
|#
(def t-leaf v = (((t-node t-empty) v) t-empty))

#|
    ~ IS EMPTY TREE ~
    - Contract: tree => bool
    - Logic: The empty handler answers true; the node handler ignores
                its three parts and answers false
|#
(def isEmptyT t = ((t true) (lambda (l) (lambda (v) (lambda (r) false)))))

#|
    ~ NODE VALUE ~
    - Contract: tree => func
    - Note: Contract is for node trees; on t-empty this returns false
                (the caller is expected to check isEmptyT first)
    - Logic: The node handler picks out the middle part
|#
(def t-val t = ((t false) (lambda (l) (lambda (v) (lambda (r) v)))))

#|
    ~ LEFT SUBTREE ~
    - Contract: tree => tree
    - Note: Contract is for node trees; on t-empty this returns t-empty
    - Logic: The node handler picks out the first part
|#
(def t-left t = ((t t-empty) (lambda (l) (lambda (v) (lambda (r) l)))))

#|
    ~ RIGHT SUBTREE ~
    - Contract: tree => tree
    - Note: Contract is for node trees; on t-empty this returns t-empty
    - Logic: The node handler picks out the third part
|#
(def t-right t = ((t t-empty) (lambda (l) (lambda (v) (lambda (r) r)))))

#|
    ~ TREE READER ~
    - Note: this is a helper function for viewing lambda calculus - not pure LC
    - Contract: (tree, read-fn) => readable(tree)
    - Logic: Empty trees print as _ ; a node prints as (value left right),
                so the shape on the page is the shape of the tree
|#
(def t-read tree read-fn =
    (letrec ([render
        (lambda (t)
            (((isEmptyT t)
                "_")
                (string-append "("
                    (let ([result (read-fn (t-val t))])
                        (if (string? result) result (number->string result)))
                    " "
                    (render (t-left t))
                    " "
                    (render (t-right t))
                    ")")))])
        (render tree)))

;===================================================
; DEPTH-FIRST TRAVERSALS
;===================================================

#|
    ~ PREORDER TRAVERSAL ~
    - Contract: tree => list
    - Idea: Value first, then everything on the left, then everything on the right
    - Logic: Empty tree contributes nil; a node conses its value onto
                the appended traversals of its two subtrees
|#
(def preorder t = ((Y preorder-helper) t))

(def preorder-helper f t =
    ((t nil)
     (lambda (l)
        (lambda (v)
            (lambda (r)
                ((pair v) ((app (f l)) (f r))))))))

#|
    ~ INORDER TRAVERSAL ~
    - Contract: tree => list
    - Idea: Everything on the left, then the value, then everything on the right;
                on a binary search tree this comes out sorted
    - Logic: Empty tree contributes nil; a node appends its left traversal
                to its value consed onto its right traversal
|#
(def inorder t = ((Y inorder-helper) t))

(def inorder-helper f t =
    ((t nil)
     (lambda (l)
        (lambda (v)
            (lambda (r)
                ((app (f l)) ((pair v) (f r))))))))

#|
    ~ POSTORDER TRAVERSAL ~
    - Contract: tree => list
    - Idea: Everything on the left, then everything on the right, then the value
    - Logic: Empty tree contributes nil; a node appends its left traversal,
                its right traversal, and the one-element list of its value
|#
(def postorder t = ((Y postorder-helper) t))

(def postorder-helper f t =
    ((t nil)
     (lambda (l)
        (lambda (v)
            (lambda (r)
                ((app (f l)) ((app (f r)) (onelist v))))))))
