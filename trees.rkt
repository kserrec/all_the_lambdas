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

;===================================================
; MEASURES AND STRUCTURAL OPERATIONS
;===================================================

#|
    ~ SIZE ~
    - Contract: tree => nat
    - Idea: How many nodes the tree holds
    - Logic: Empty counts zero; a node counts one more than its
                two subtree counts added together
|#
(def t-size t = ((Y t-size-helper) t))

(def t-size-helper f t =
    ((t zero)
     (lambda (l)
        (lambda (v)
            (lambda (r)
                (succ ((add (f l)) (f r))))))))

#|
    ~ HEIGHT ~
    - Contract: tree => nat
    - Idea: The number of nodes on the longest root-to-leaf walk;
                the empty tree has height zero, a leaf has height one
    - Logic: Empty is zero; a node is one more than the taller of
                its two subtree heights (picked with gte)
|#
(def t-height t = ((Y t-height-helper) t))

(def t-height-helper f t =
    ((t zero)
     (lambda (l)
        (lambda (v)
            (lambda (r)
                (_let hl = (f l)
                    (_let hr = (f r)
                        (succ
                            (_if ((gte hl) hr)
                                _then hl
                                _else hr)))))))))

#|
    ~ FOLD ~
    - Contract: (func, func, tree) => func
    - Idea: Collapse a whole tree into one value: g decides how a
                node combines (folded-left, value, folded-right),
                and z stands in for every empty subtree
    - Logic: Empty answers z; a node hands g its folded left subtree,
                its value, and its folded right subtree. Both t-size
                and the traversals could be written as folds — the
                tests demonstrate the size one
|#
(def t-fold g z t = ((((Y t-fold-helper) g) z) t))

(def t-fold-helper f g z t =
    ((t z)
     (lambda (l)
        (lambda (v)
            (lambda (r)
                (((g (((f g) z) l)) v) (((f g) z) r)))))))

#|
    ~ MAP ~
    - Contract: (func, tree) => tree
    - Idea: Apply g to every value while keeping the shape identical
    - Logic: Empty stays empty; a node rebuilds with g of its value
                and the mapped subtrees
|#
(def t-map g t = (((Y t-map-helper) g) t))

(def t-map-helper f g t =
    ((t t-empty)
     (lambda (l)
        (lambda (v)
            (lambda (r)
                (((t-node ((f g) l)) (g v)) ((f g) r)))))))

#|
    ~ MIRROR ~
    - Contract: tree => tree
    - Idea: The left-right reflection of the tree
    - Logic: Empty stays empty; a node rebuilds with its subtrees
                mirrored AND swapped. Mirroring twice gives back the
                original shape
|#
(def t-mirror t = ((Y t-mirror-helper) t))

(def t-mirror-helper f t =
    ((t t-empty)
     (lambda (l)
        (lambda (v)
            (lambda (r)
                (((t-node (f r)) v) (f l)))))))

#|
    ~ DEEPEN ~
    - Contract: {bool, nat} => {bool, nat}
    - Idea: Helper for t-depth: a found answer from one level down
                is one step deeper from here
    - Logic: {true, d} becomes {true, succ d}; not-found passes through
|#
(def t-deepen res =
    (_if (head res)
        _then ((pair true) (succ (tail res)))
        _else ((pair false) false)))

#|
    ~ DEPTH OF A VALUE (in a binary search tree) ~
    - Contract: (func, func, tree) => {bool, nat}
    - Idea: How far below the root x sits in a search tree ordered by
                the less-than comparator lt: the root itself is depth
                zero. Answers {false, false} when x is not in the tree
    - Logic: Walk the search path: if x is less than this value, the
                answer lies left; if this value is less than x, right;
                otherwise (neither is less) x IS this value, at depth
                zero. Each step back up adds one via t-deepen
|#
(def t-depth lt x t = ((((Y t-depth-helper) lt) x) t))

(def t-depth-helper f lt x t =
    ((t ((pair false) false))
     (lambda (l)
        (lambda (v)
            (lambda (r)
                (_if ((lt x) v)
                    _then (t-deepen (((f lt) x) l))
                    _else (_if ((lt v) x)
                            _then (t-deepen (((f lt) x) r))
                            _else ((pair true) zero))))))))

;===================================================
; BINARY SEARCH TREES
;===================================================

#| BINARY SEARCH TREES

    A binary search tree keeps everything less than a node's value in
    its left subtree and everything greater in its right subtree.

    Every operation takes the ordering itself as an argument: a
    less-than comparator lt. Equality never needs its own argument —
    two values are equal exactly when neither is less than the other.
    This is what lets ONE implementation serve Church naturals (lt),
    integers (ltZ), rationals (ltR), binary naturals (bin-lt), and
    signed binary integers (ltZ-bin).

    Insertion is persistent: it rebuilds only the search path and
    shares every untouched subtree with the old tree, which remains
    fully usable.
|#

#|
    ~ BST INSERT ~
    - Contract: (func, func, tree) => tree
    - Idea: A new tree that also holds x, sharing all untouched subtrees
    - Logic: Inserting into empty makes a leaf. Otherwise compare:
                x less goes left, v less goes right (rebuilding just
                that side), and when neither is less, x is already
                here — the tree is returned unchanged
|#
(def bst-insert lt x t = ((((Y bst-insert-helper) lt) x) t))

(def bst-insert-helper f lt x t =
    ((t (t-leaf x))
     (lambda (l)
        (lambda (v)
            (lambda (r)
                (_if ((lt x) v)
                    _then (((t-node (((f lt) x) l)) v) r)
                    _else (_if ((lt v) x)
                            _then (((t-node l) v) (((f lt) x) r))
                            _else t)))))))

#|
    ~ BST LOOKUP ~
    - Contract: (func, func, tree) => bool
    - Idea: Is x in the search tree?
    - Logic: Follow the one search path: left when x is less, right
                when v is less, found when neither is less; running
                off the bottom answers false
|#
(def bst-lookup lt x t = ((((Y bst-lookup-helper) lt) x) t))

(def bst-lookup-helper f lt x t =
    ((t false)
     (lambda (l)
        (lambda (v)
            (lambda (r)
                (_if ((lt x) v)
                    _then (((f lt) x) l)
                    _else (_if ((lt v) x)
                            _then (((f lt) x) r)
                            _else true)))))))

#|
    ~ BST MINIMUM ~
    - Contract: tree => {bool, func}
    - Idea: The smallest value is as far left as the tree goes
    - Logic: Walk left until the left subtree is empty; that node's
                value is the minimum. The empty tree has no minimum,
                so the answer carries a found flag: {false, false}
|#
(def bst-min t = ((Y bst-min-helper) t))

(def bst-min-helper f t =
    ((t ((pair false) false))
     (lambda (l)
        (lambda (v)
            (lambda (r)
                (_if (isEmptyT l)
                    _then ((pair true) v)
                    _else (f l)))))))

#|
    ~ BST MAXIMUM ~
    - Contract: tree => {bool, func}
    - Idea: The largest value is as far right as the tree goes
    - Logic: Mirror image of bst-min
|#
(def bst-max t = ((Y bst-max-helper) t))

(def bst-max-helper f t =
    ((t ((pair false) false))
     (lambda (l)
        (lambda (v)
            (lambda (r)
                (_if (isEmptyT r)
                    _then ((pair true) v)
                    _else (f r)))))))

#|
    ~ BST DELETE ~
    - Contract: (func, func, tree) => tree
    - Idea: A new tree without x, sharing everything off the search
                path; deleting an absent value gives the tree back
                unchanged in content
    - Logic: Search as usual. On finding the node: with an empty side,
                the other side simply takes its place. With two
                children, the node's value is replaced by its in-order
                successor — the minimum of the right subtree (which
                bst-min is guaranteed to find, since that subtree is
                not empty) — and that successor is deleted from the
                right subtree, where, as a minimum, it has at most
                one child of its own
|#
(def bst-delete lt x t = ((((Y bst-delete-helper) lt) x) t))

(def bst-delete-helper f lt x t =
    ((t t-empty)
     (lambda (l)
        (lambda (v)
            (lambda (r)
                (_if ((lt x) v)
                    _then (((t-node (((f lt) x) l)) v) r)
                    _else (_if ((lt v) x)
                            _then (((t-node l) v) (((f lt) x) r))
                            _else (_if (isEmptyT l)
                                    _then r
                                    _else (_if (isEmptyT r)
                                            _then l
                                            _else (_let sv = (tail (bst-min r))
                                                    (((t-node l) sv)
                                                     (((f lt) sv) r))))))))))))

;===================================================
; BREADTH-FIRST TRAVERSAL
;===================================================

#|
    ~ BREADTH-FIRST (LEVEL) ORDER ~
    - Contract: tree => list
    - Idea: The root, then its children left to right, then THEIR
                children left to right, level by level
    - Logic: Work through a queue of trees that starts holding just
                the whole tree. Each round pops one tree: an empty
                tree contributes nothing; a node contributes its value
                and lines its two subtrees up at the end of the queue
                (left first, so left stays ahead of right). When the
                queue runs dry the traversal is the collected values
|#
(def bfs-order t = ((Y bfs-order-helper) ((q-push t) q-empty)))

(def bfs-order-helper f q =
    (_let popped = (q-pop q)
        (_if (head popped)
            _then (_let curr = (head (tail popped))
                    (_let rest = (tail (tail popped))
                        (_if (isEmptyT curr)
                            _then (f rest)
                            _else ((pair (t-val curr))
                                   (f ((q-push (t-right curr))
                                       ((q-push (t-left curr)) rest)))))))
            _else nil)))
