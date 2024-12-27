#lang s-exp "../../macros/lazy-with-macros.rkt"
(require "../../macros/macros.rkt")
(provide (all-defined-out))

(define (test-list-element test-scene expression expectation)
    (list 
        (string-append test-scene " -EXPECTED: " expectation) 
        (string-append "-ACTUAL: " expression) 
        (string=? expression expectation)))

(define (filter-fails testList)
    (filter (λ (x) (eq? (last x) #f)) testList))

(define (show-results test-label test-list)
    (let* ([original-length (length test-list)]
           [failed-tests (filter-fails test-list)]
           [failed-length (length failed-tests)]
           [difference (- original-length failed-length)])
        (displayln "---------------------------------------------------")
        (displayln (string-append "-- " test-label " results:"))
        (displayln (string-append (number->string failed-length) " FAIL " (number->string difference) " PASS " (number->string original-length) " TEST(s) "))
        (newline)
        (when (> failed-length 0)
            (displayln "Failed Tests:")
            (for-each (λ (x) (begin (display " - ") (display x) (display "\n"))) failed-tests))))