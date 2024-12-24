#lang racket
(require rackunit
         rackunit/text-ui
         "../logic.rkt")

(define logic-tests
 (test-suite
  "Logic Operations Tests"

   ;    _not tests
   (test-case "_not true => false"
    (check-equal? (force (b-read (_not true))) "false"))

   (test-case "_not false => true"
    (check-equal? (force (b-read (_not false))) "true"))


    ;   _and tests
   (test-case "_and true true => true"
    (check-equal? (force (b-read ((_and true) true))) "true"))

   (test-case "_and true false => false"
    (check-equal? (force (b-read ((_and true) false))) "false"))

   (test-case "_and false true => false"
    (check-equal? (force (b-read ((_and false) true))) "false"))

   (test-case "_and false false => false"
    (check-equal? (force (b-read ((_and false) false))) "false"))


    ;   _or tests
   (test-case "_or true true => true"
    (check-equal? (force (b-read ((_or true) true))) "true"))

   (test-case "_or true false => false"
    (check-equal? (force (b-read ((_or true) false))) "true"))

   (test-case "_or false true => false"
    (check-equal? (force (b-read ((_or false) true))) "true"))

   (test-case "_or false false => false"
    (check-equal? (force (b-read ((_or false) false))) "false"))


    ;   xor tests
   (test-case "xor true true => true"
    (check-equal? (force (b-read ((xor true) true))) "false"))

   (test-case "xor true false => false"
    (check-equal? (force (b-read ((xor true) false))) "true"))

   (test-case "xor false true => false"
    (check-equal? (force (b-read ((xor false) true))) "true"))

   (test-case "xor false false => false"
    (check-equal? (force (b-read ((xor false) false))) "false"))


    ;   xor tests
   (test-case "xor true true => true"
    (check-equal? (force (b-read ((xor true) true))) "false"))

   (test-case "xor true false => false"
    (check-equal? (force (b-read ((xor true) false))) "true"))

   (test-case "xor false true => false"
    (check-equal? (force (b-read ((xor false) true))) "true"))

   (test-case "xor false false => false"
    (check-equal? (force (b-read ((xor false) false))) "false"))


    ;   nor tests
   (test-case "nor true true => true"
    (check-equal? (force (b-read ((nor true) true))) "false"))

   (test-case "nor true false => false"
    (check-equal? (force (b-read ((nor true) false))) "false"))

   (test-case "nor false true => false"
    (check-equal? (force (b-read ((nor false) true))) "false"))

   (test-case "nor false false => false"
    (check-equal? (force (b-read ((nor false) false))) "true"))


    ;   nand tests
   (test-case "nand true true => true"
    (check-equal? (force (b-read ((nand true) true))) "false"))

   (test-case "nand true false => false"
    (check-equal? (force (b-read ((nand true) false))) "true"))

   (test-case "nand false true => false"
    (check-equal? (force (b-read ((nand false) true))) "true"))

   (test-case "nand false false => false"
    (check-equal? (force (b-read ((nand false) false))) "true"))
))


(run-tests logic-tests 'verbose)