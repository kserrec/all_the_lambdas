#lang s-exp "../macros/lazy-with-macros.rkt"
(require "../macros/macros.rkt")
(require "../church.rkt"
         "../core.rkt"
         "../logic.rkt"
         "../lists.rkt"
         "../binary-lists.rkt"
         "../heaps.rkt"
         "helpers/test-helpers.rkt")

; ====================================================================
; ~ LEFTIST HEAP TESTS ~
; ====================================================================

(define heap-314 ((heap-from-list lte) (_cons three one four)))
(define heap-31415 ((heap-from-list lte) (_cons three one four one five)))

(define find-min-tests (list
    (test-list-element "find-min(empty) found" (b-read (head (h-find-min h-empty))) "false")
    (test-list-element "find-min(singleton 2)" (n-read (tail (h-find-min (h-singleton two)))) "2")
    (test-list-element "find-min(3,1,4)" (n-read (tail (h-find-min heap-314))) "1")
    (test-list-element "find-min(3,1,4,1,5)" (n-read (tail (h-find-min heap-31415))) "1")
    (test-list-element "isEmptyH(empty)" (b-read (isEmptyH h-empty)) "true")
    (test-list-element "isEmptyH(singleton)" (b-read (isEmptyH (h-singleton one))) "false")))

(show-results "h-find-min" find-min-tests)

; ====================================================================

(define delete-min-tests (list
    (test-list-element "min after one delete" (n-read (tail (h-find-min ((h-delete-min lte) heap-31415)))) "1")
    (test-list-element "min after two deletes" (n-read (tail (h-find-min ((h-delete-min lte) ((h-delete-min lte) heap-31415))))) "3")
    (test-list-element "delete-min(empty) stays empty" (b-read (isEmptyH ((h-delete-min lte) h-empty))) "true")
    (test-list-element "delete-min(singleton) empties" (b-read (isEmptyH ((h-delete-min lte) (h-singleton one)))) "true")))

(show-results "h-delete-min" delete-min-tests)

; ====================================================================

(define drain-tests (list
    (test-list-element "drain(empty)" ((l-read ((h-drain lte) h-empty)) n-read) "[]")
    (test-list-element "drain(3,1,4)" ((l-read ((h-drain lte) heap-314)) n-read) "[1,3,4]")
    (test-list-element "drain(3,1,4,1,5)" ((l-read ((h-drain lte) heap-31415)) n-read) "[1,1,3,4,5]")
    (test-list-element "drain over bin-lte" ((l-read ((h-drain bin-lte) ((heap-from-list bin-lte) (_cons bin-seven bin-two bin-ten bin-five)))) bin-read) "[2,5,7,10]")))

(show-results "h-drain" drain-tests)

; ====================================================================

; Persistence: inserting zero gives a NEW heap whose minimum is 0,
; while the old heap still reports minimum 1
(define heap-with-0 (((h-insert lte) zero) heap-31415))

(define heap-persistence-tests (list
    (test-list-element "new heap min" (n-read (tail (h-find-min heap-with-0))) "0")
    (test-list-element "old heap min unchanged" (n-read (tail (h-find-min heap-31415))) "1")
    (test-list-element "old heap drain unchanged" ((l-read ((h-drain lte) heap-31415)) n-read) "[1,1,3,4,5]")))

(show-results "heap persistence" heap-persistence-tests)
