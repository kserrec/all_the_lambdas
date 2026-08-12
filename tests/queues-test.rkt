#lang s-exp "../macros/lazy-with-macros.rkt"
(require "../macros/macros.rkt")
(require "../church.rkt"
         "../core.rkt"
         "../logic.rkt"
         "../lists.rkt"
         "../queues.rkt"
         "helpers/test-helpers.rkt")

; ====================================================================
; ~ QUEUES TESTS ~
; ====================================================================

; Fixtures: q-123 holds 1,2,3 in arrival order
(define q-1 ((q-push one) q-empty))
(define q-12 ((q-push two) q-1))
(define q-123 ((q-push three) q-12))

; ====================================================================

(define q-isEmpty-tests (list
    (test-list-element "q-isEmpty(q-empty)" (b-read (q-isEmpty q-empty)) "true")
    (test-list-element "q-isEmpty(push(1))" (b-read (q-isEmpty q-1)) "false")
    (test-list-element "q-isEmpty(push 1,2,3)" (b-read (q-isEmpty q-123)) "false")))

(show-results "q-isEmpty" q-isEmpty-tests)

; ====================================================================

(define pop-1 (q-pop q-1))
(define pop-empty (q-pop q-empty))

(define q-pop-tests (list
    (test-list-element "pop(q-empty) found" (b-read (head pop-empty)) "false")
    (test-list-element "pop(push(1)) found" (b-read (head pop-1)) "true")
    (test-list-element "pop(push(1)) value" (n-read (head (tail pop-1))) "1")
    (test-list-element "pop(push(1)) rest empty" (b-read (q-isEmpty (tail (tail pop-1)))) "true")))

(show-results "q-pop" q-pop-tests)

; ====================================================================

; FIFO order: elements leave in the order they arrived,
; including across the reverse-the-back boundary
(define pop-a (q-pop q-123))
(define q-after-a (tail (tail pop-a)))
(define pop-b (q-pop q-after-a))
(define q-after-b (tail (tail pop-b)))
(define pop-c (q-pop q-after-b))

(define fifo-tests (list
    (test-list-element "drain(push 1,2,3)" ((l-read (q-drain q-123)) n-read) "[1,2,3]")
    (test-list-element "1st pop value" (n-read (head (tail pop-a))) "1")
    (test-list-element "2nd pop value" (n-read (head (tail pop-b))) "2")
    (test-list-element "3rd pop value" (n-read (head (tail pop-c))) "3")
    (test-list-element "empty after 3 pops" (b-read (q-isEmpty (tail (tail pop-c)))) "true")
    (test-list-element "drain(interleaved)" ((l-read (q-drain ((q-push four) q-after-a))) n-read) "[2,3,4]")))

(show-results "queue FIFO order" fifo-tests)

; ====================================================================

(define push-all-tests (list
    (test-list-element "push-all([2,3,4]) after 1" ((l-read (q-drain ((q-push-all (_cons two three four)) q-1))) n-read) "[1,2,3,4]")
    (test-list-element "push-all([]) is no-op" ((l-read (q-drain ((q-push-all nil) q-123))) n-read) "[1,2,3]")))

(show-results "q-push-all" push-all-tests)

; ====================================================================

; Persistence: popping and pushing never disturb older queues
(define persistence-tests (list
    (test-list-element "q-123 unchanged after pops" ((l-read (q-drain q-123)) n-read) "[1,2,3]")
    (test-list-element "q-1 unchanged after building q-123" ((l-read (q-drain q-1)) n-read) "[1]")
    (test-list-element "q-empty still empty" (b-read (q-isEmpty q-empty)) "true")))

(show-results "queue persistence" persistence-tests)
