#lang s-exp "../macros/lazy-with-macros.rkt"
(require "../macros/macros.rkt")
(require "../church.rkt"
         "../core.rkt"
         "../logic.rkt"
         "../lists.rkt"
         "../trees.rkt"
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

; Persistence: t-42135 was built FROM t-213; the old tree is untouched
; and still reads exactly as it did before it was used as a subtree.
(define persistence-tests (list
    (test-list-element "t-213 unchanged after reuse" ((t-read t-213) n-read) "(2 (1 _ _) (3 _ _))")
    (test-list-element "inorder(t-213) unchanged after reuse" ((l-read (inorder t-213)) n-read) "[1,2,3]")))

(show-results "tree persistence" persistence-tests)
