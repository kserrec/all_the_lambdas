#lang racket
(require rackunit
         rackunit/text-ui
         "../church.rkt")

(define church-tests
 (test-suite
  "Church Numeral Operations Tests"

   ;    succ tests
   (test-case "succ zero => one"
    (check-equal? (force (n-read (succ zero))) 1))

   (test-case "succ one => two"
    (check-equal? (force (n-read (succ one))) 2))

   (test-case "succ two => three"
    (check-equal? (force (n-read (succ two))) 3))

   (test-case "succ three => four"
    (check-equal? (force (n-read (succ three))) 4))


   ;    pred tests
   (test-case "pred zero => zero"
    (check-equal? (force (n-read (pred zero))) 0))

   (test-case "pred one => zero"
    (check-equal? (force (n-read (pred one))) 0))

   (test-case "pred two => one"
    (check-equal? (force (n-read (pred two))) 1))

   (test-case "pred three => two"
    (check-equal? (force (n-read (pred three))) 2))

   (test-case "pred five => four"
    (check-equal? (force (n-read (pred five))) 4))


   ;    add tests
   (test-case "add zero zero => zero"
    (check-equal? (force (n-read ((add zero) zero))) 0))

   (test-case "add zero one => one"
    (check-equal? (force (n-read ((add zero) one))) 1))

   (test-case "add one zero => one"
    (check-equal? (force (n-read ((add one) zero))) 1))

   (test-case "add two zero => two"
    (check-equal? (force (n-read ((add two) zero))) 2))

   (test-case "add two three => five"
    (check-equal? (force (n-read ((add two) three))) 5))

   (test-case "add one four => five"
    (check-equal? (force (n-read ((add one) four))) 5))

   (test-case "add five five => ten"
    (check-equal? (force (n-read ((add five) five))) 10))


   ;    sub tests
   (test-case "sub zero zero => zero"
    (check-equal? (force (n-read ((sub zero) zero))) 0))

   (test-case "sub zero one => zero"
    (check-equal? (force (n-read ((sub zero) one))) 0))

   (test-case "sub one zero => one"
    (check-equal? (force (n-read ((sub one) zero))) 1))

   (test-case "sub two zero => two"
    (check-equal? (force (n-read ((sub two) zero))) 2))

   (test-case "sub two three => zero"
    (check-equal? (force (n-read ((sub two) three))) 0))

   (test-case "sub four one => three"
    (check-equal? (force (n-read ((sub four) one))) 3))

   (test-case "sub five one => four"
    (check-equal? (force (n-read ((sub five) one))) 4))
    

   ;    mult tests
   (test-case "mult zero zero => zero"
    (check-equal? (force (n-read ((mult zero) zero))) 0))

   (test-case "mult zero one => zero"
    (check-equal? (force (n-read ((mult zero) one))) 0))

   (test-case "mult one zero => zero"
    (check-equal? (force (n-read ((mult one) zero))) 0))

   (test-case "mult two zero => zero"
    (check-equal? (force (n-read ((mult two) zero))) 0))

   (test-case "mult two three => six"
    (check-equal? (force (n-read ((mult two) three))) 6))

   (test-case "mult one four => four"
    (check-equal? (force (n-read ((mult one) four))) 4))

   (test-case "mult five four => twenty"
    (check-equal? (force (n-read ((mult five) four))) 20))


   ;    _exp tests
   (test-case "_exp zero zero => zero"
    (check-equal? (force (n-read ((_exp zero) zero))) 1))

   (test-case "_exp zero one => zero"
    (check-equal? (force (n-read ((_exp zero) one))) 0))

   (test-case "_exp three one => zero"
    (check-equal? (force (n-read ((_exp three) one))) 3))

   (test-case "_exp one zero => one"
    (check-equal? (force (n-read ((_exp one) zero))) 1))

   (test-case "_exp two zero => one"
    (check-equal? (force (n-read ((_exp two) zero))) 1))

   (test-case "_exp two three => eight"
    (check-equal? (force (n-read ((_exp two) three))) 8))

   (test-case "_exp one four => four"
    (check-equal? (force (n-read ((_exp one) four))) 1))

   (test-case "_exp five four => 625"
    (check-equal? (force (n-read ((_exp five) four))) 625))

))


(run-tests church-tests 'verbose)