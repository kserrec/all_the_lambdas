#lang s-exp "../macros/lazy-with-macros.rkt"
(require "../macros/macros.rkt")
(require "../church.rkt"
         "../core.rkt"
         "../logic.rkt"
         "../lists.rkt"
         "../trees.rkt"
         "../binary-lists.rkt"
         "../integers.rkt"
         "helpers/test-helpers.rkt")

; ====================================================================
; ~ TREES TESTS ~
; ====================================================================

; Fixtures — braces show shape as (value left right):
;   leaf-1              = (1 _ _)
;   t-213               = (2 (1 _ _) (3 _ _))
;   t-42135             = (4 (2 (1 _ _) (3 _ _)) (5 _ _))
(define leaf-1 (t-leaf one))
(define leaf-3 (t-leaf three))
(define leaf-5 (t-leaf five))
(define t-213 (((t-node leaf-1) two) leaf-3))
(define t-42135 (((t-node t-213) four) leaf-5))

; ====================================================================

(define isEmptyT-tests (list
    (test-list-element "isEmptyT(t-empty)" (b-read (isEmptyT t-empty)) "true")
    (test-list-element "isEmptyT(leaf(1))" (b-read (isEmptyT leaf-1)) "false")
    (test-list-element "isEmptyT(node(leaf(1))(2)(leaf(3)))" (b-read (isEmptyT t-213)) "false")
    (test-list-element "isEmptyT(left(leaf(1)))" (b-read (isEmptyT (t-left leaf-1))) "true")))

(show-results "isEmptyT" isEmptyT-tests)

; ====================================================================

(define selector-tests (list
    (test-list-element "val(leaf(1))" (n-read (t-val leaf-1)) "1")
    (test-list-element "val(t-213)" (n-read (t-val t-213)) "2")
    (test-list-element "val(left(t-213))" (n-read (t-val (t-left t-213))) "1")
    (test-list-element "val(right(t-213))" (n-read (t-val (t-right t-213))) "3")
    (test-list-element "val(left(left(t-42135)))" (n-read (t-val (t-left (t-left t-42135)))) "1")
    (test-list-element "val(right(t-42135))" (n-read (t-val (t-right t-42135))) "5")))

(show-results "tree selectors" selector-tests)

; ====================================================================

(define t-read-tests (list
    (test-list-element "t-read(t-empty)" ((t-read t-empty) n-read) "_")
    (test-list-element "t-read(leaf(1))" ((t-read leaf-1) n-read) "(1 _ _)")
    (test-list-element "t-read(t-213)" ((t-read t-213) n-read) "(2 (1 _ _) (3 _ _))")
    (test-list-element "t-read(t-42135)" ((t-read t-42135) n-read) "(4 (2 (1 _ _) (3 _ _)) (5 _ _))")))

(show-results "t-read" t-read-tests)

; ====================================================================

(define preorder-tests (list
    (test-list-element "preorder(t-empty)" ((l-read (preorder t-empty)) n-read) "[]")
    (test-list-element "preorder(leaf(1))" ((l-read (preorder leaf-1)) n-read) "[1]")
    (test-list-element "preorder(t-213)" ((l-read (preorder t-213)) n-read) "[2,1,3]")
    (test-list-element "preorder(t-42135)" ((l-read (preorder t-42135)) n-read) "[4,2,1,3,5]")))

(show-results "preorder" preorder-tests)

; ====================================================================

(define inorder-tests (list
    (test-list-element "inorder(t-empty)" ((l-read (inorder t-empty)) n-read) "[]")
    (test-list-element "inorder(leaf(1))" ((l-read (inorder leaf-1)) n-read) "[1]")
    (test-list-element "inorder(t-213)" ((l-read (inorder t-213)) n-read) "[1,2,3]")
    (test-list-element "inorder(t-42135)" ((l-read (inorder t-42135)) n-read) "[1,2,3,4,5]")))

(show-results "inorder" inorder-tests)

; ====================================================================

(define postorder-tests (list
    (test-list-element "postorder(t-empty)" ((l-read (postorder t-empty)) n-read) "[]")
    (test-list-element "postorder(leaf(1))" ((l-read (postorder leaf-1)) n-read) "[1]")
    (test-list-element "postorder(t-213)" ((l-read (postorder t-213)) n-read) "[1,3,2]")
    (test-list-element "postorder(t-42135)" ((l-read (postorder t-42135)) n-read) "[1,3,2,5,4]")))

(show-results "postorder" postorder-tests)

; ====================================================================

(define t-size-tests (list
    (test-list-element "size(t-empty)" (n-read (t-size t-empty)) "0")
    (test-list-element "size(leaf(1))" (n-read (t-size leaf-1)) "1")
    (test-list-element "size(t-213)" (n-read (t-size t-213)) "3")
    (test-list-element "size(t-42135)" (n-read (t-size t-42135)) "5")))

(show-results "t-size" t-size-tests)

; ====================================================================

(define t-height-tests (list
    (test-list-element "height(t-empty)" (n-read (t-height t-empty)) "0")
    (test-list-element "height(leaf(1))" (n-read (t-height leaf-1)) "1")
    (test-list-element "height(t-213)" (n-read (t-height t-213)) "2")
    (test-list-element "height(t-42135)" (n-read (t-height t-42135)) "3")))

(show-results "t-height" t-height-tests)

; ====================================================================

; g for a size fold: one plus the two folded sides, ignoring the value
(define size-as-fold
    (lambda (a) (lambda (v) (lambda (b) (succ ((add a) b))))))
; g for a sum fold: folded-left + value + folded-right
(define sum-as-fold
    (lambda (a) (lambda (v) (lambda (b) ((add a) ((add v) b))))))

(define t-fold-tests (list
    (test-list-element "fold size(t-empty)" (n-read (((t-fold size-as-fold) zero) t-empty)) "0")
    (test-list-element "fold size(t-42135)" (n-read (((t-fold size-as-fold) zero) t-42135)) "5")
    (test-list-element "fold sum(t-213)" (n-read (((t-fold sum-as-fold) zero) t-213)) "6")
    (test-list-element "fold sum(t-42135)" (n-read (((t-fold sum-as-fold) zero) t-42135)) "15")))

(show-results "t-fold" t-fold-tests)

; ====================================================================

(define t-map-tests (list
    (test-list-element "map succ (t-empty)" ((t-read ((t-map succ) t-empty)) n-read) "_")
    (test-list-element "map succ (t-213) shape" ((t-read ((t-map succ) t-213)) n-read) "(3 (2 _ _) (4 _ _))")
    (test-list-element "map succ (t-42135) inorder" ((l-read (inorder ((t-map succ) t-42135))) n-read) "[2,3,4,5,6]")))

(show-results "t-map" t-map-tests)

; ====================================================================

(define t-mirror-tests (list
    (test-list-element "mirror(t-empty)" ((t-read (t-mirror t-empty)) n-read) "_")
    (test-list-element "mirror(t-213)" ((t-read (t-mirror t-213)) n-read) "(2 (3 _ _) (1 _ _))")
    (test-list-element "mirror(t-42135) inorder" ((l-read (inorder (t-mirror t-42135))) n-read) "[5,4,3,2,1]")
    (test-list-element "mirror(mirror(t-42135))" ((l-read (inorder (t-mirror (t-mirror t-42135)))) n-read) "[1,2,3,4,5]")))

(show-results "t-mirror" t-mirror-tests)

; ====================================================================

; t-42135 is a valid BST (inorder [1,2,3,4,5]), so depth follows the search path
(define depth-4 (((t-depth lt) four) t-42135))
(define depth-2 (((t-depth lt) two) t-42135))
(define depth-5 (((t-depth lt) five) t-42135))
(define depth-1 (((t-depth lt) one) t-42135))
(define depth-3 (((t-depth lt) three) t-42135))
(define depth-0 (((t-depth lt) zero) t-42135))

(define t-depth-tests (list
    (test-list-element "depth(4) found" (b-read (head depth-4)) "true")
    (test-list-element "depth(4) = root" (n-read (tail depth-4)) "0")
    (test-list-element "depth(2)" (n-read (tail depth-2)) "1")
    (test-list-element "depth(5)" (n-read (tail depth-5)) "1")
    (test-list-element "depth(1)" (n-read (tail depth-1)) "2")
    (test-list-element "depth(3)" (n-read (tail depth-3)) "2")
    (test-list-element "depth(0) found" (b-read (head depth-0)) "false")
    (test-list-element "depth in empty found" (b-read (head (((t-depth lt) one) t-empty))) "false")))

(show-results "t-depth" t-depth-tests)

; ====================================================================

(define bfs-order-tests (list
    (test-list-element "bfs-order(t-empty)" ((l-read (bfs-order t-empty)) n-read) "[]")
    (test-list-element "bfs-order(leaf(1))" ((l-read (bfs-order leaf-1)) n-read) "[1]")
    (test-list-element "bfs-order(t-213)" ((l-read (bfs-order t-213)) n-read) "[2,1,3]")
    (test-list-element "bfs-order(t-42135)" ((l-read (bfs-order t-42135)) n-read) "[4,2,5,1,3]")))

(show-results "bfs-order" bfs-order-tests)

; ====================================================================

; Persistence: t-42135 was built FROM t-213; the old tree is untouched
; and still reads exactly as it did before it was used as a subtree.
(define persistence-tests (list
    (test-list-element "t-213 unchanged after reuse" ((t-read t-213) n-read) "(2 (1 _ _) (3 _ _))")
    (test-list-element "inorder(t-213) unchanged after reuse" ((l-read (inorder t-213)) n-read) "[1,2,3]")))

(show-results "tree persistence" persistence-tests)

; ====================================================================
; ~ BINARY SEARCH TREE TESTS ~
; ====================================================================

; Church naturals: insert 4,2,5,1,3 — inorder must come out sorted
(define nat-bst
    (((bst-insert lt) three)
     (((bst-insert lt) one)
      (((bst-insert lt) five)
       (((bst-insert lt) two)
        (((bst-insert lt) four) t-empty))))))

(define nat-bst-tests (list
    (test-list-element "inorder(nat-bst)" ((l-read (inorder nat-bst)) n-read) "[1,2,3,4,5]")
    (test-list-element "shape(nat-bst)" ((t-read nat-bst) n-read) "(4 (2 (1 _ _) (3 _ _)) (5 _ _))")
    (test-list-element "lookup(3)" (b-read (((bst-lookup lt) three) nat-bst)) "true")
    (test-list-element "lookup(5)" (b-read (((bst-lookup lt) five) nat-bst)) "true")
    (test-list-element "lookup(0)" (b-read (((bst-lookup lt) zero) nat-bst)) "false")
    (test-list-element "lookup in empty" (b-read (((bst-lookup lt) one) t-empty)) "false")
    (test-list-element "min(nat-bst) found" (b-read (head (bst-min nat-bst))) "true")
    (test-list-element "min(nat-bst)" (n-read (tail (bst-min nat-bst))) "1")
    (test-list-element "max(nat-bst)" (n-read (tail (bst-max nat-bst))) "5")
    (test-list-element "min(empty) found" (b-read (head (bst-min t-empty))) "false")
    (test-list-element "max(empty) found" (b-read (head (bst-max t-empty))) "false")))

(show-results "BST over Church naturals" nat-bst-tests)

; ====================================================================

; Duplicate insertion leaves the tree as it was
(define nat-bst-dup (((bst-insert lt) two) nat-bst))

(define dup-tests (list
    (test-list-element "size after dup insert" (n-read (t-size nat-bst-dup)) "5")
    (test-list-element "inorder after dup insert" ((l-read (inorder nat-bst-dup)) n-read) "[1,2,3,4,5]")))

(show-results "BST duplicate insert" dup-tests)

; ====================================================================

; Persistence: inserting into nat-bst gives a NEW tree; the old one
; still holds exactly its old five values
(define nat-bst-plus0 (((bst-insert lt) zero) nat-bst))

(define bst-persistence-tests (list
    (test-list-element "new tree has 0" ((l-read (inorder nat-bst-plus0)) n-read) "[0,1,2,3,4,5]")
    (test-list-element "old tree unchanged" ((l-read (inorder nat-bst)) n-read) "[1,2,3,4,5]")
    (test-list-element "old tree lookup(0) still false" (b-read (((bst-lookup lt) zero) nat-bst)) "false")))

(show-results "BST persistence" bst-persistence-tests)

; ====================================================================

; Binary naturals: the SAME bst-insert/lookup, handed bin-lt instead
(define bin-bst
    (((bst-insert bin-lt) bin-two)
     (((bst-insert bin-lt) bin-ten)
      (((bst-insert bin-lt) bin-seven)
       (((bst-insert bin-lt) bin-five) t-empty)))))

(define bin-bst-tests (list
    (test-list-element "inorder(bin-bst)" ((l-read (inorder bin-bst)) bin-read) "[2,5,7,10]")
    (test-list-element "lookup(7)" (b-read (((bst-lookup bin-lt) bin-seven) bin-bst)) "true")
    (test-list-element "lookup(3)" (b-read (((bst-lookup bin-lt) bin-three) bin-bst)) "false")
    (test-list-element "min(bin-bst)" (bin-read (tail (bst-min bin-bst))) "2")
    (test-list-element "max(bin-bst)" (bin-read (tail (bst-max bin-bst))) "10")))

(show-results "BST over binary naturals" bin-bst-tests)

; ====================================================================

; Integers: the SAME operations again, handed ltZ — negatives sort first
(define z-bst
    (((bst-insert ltZ) posThree)
     (((bst-insert ltZ) negOne)
      (((bst-insert ltZ) posOne)
       (((bst-insert ltZ) negThree)
        (((bst-insert ltZ) posZero) t-empty))))))

(define z-bst-tests (list
    (test-list-element "inorder(z-bst)" ((l-read (inorder z-bst)) z-read) "[-3,-1,0,1,3]")
    (test-list-element "lookup(-3)" (b-read (((bst-lookup ltZ) negThree) z-bst)) "true")
    (test-list-element "lookup(2)" (b-read (((bst-lookup ltZ) posTwo) z-bst)) "false")
    (test-list-element "min(z-bst)" (z-read (tail (bst-min z-bst))) "-3")
    (test-list-element "max(z-bst)" (z-read (tail (bst-max z-bst))) "3")))

(show-results "BST over integers" z-bst-tests)
