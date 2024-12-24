#lang racket
(require rackunit
         rackunit/text-ui
         "../logic.rkt"
         "../church.rkt")

(define church-arithmetic-tests
 (test-suite
  "Church Numeral Arithmetic Operations Tests"

   ;    succ tests
   (test-case "succ zero => one"
    (check-equal? (force (n-read (succ zero))) "1"))

   (test-case "succ one => two"
    (check-equal? (force (n-read (succ one))) "2"))

   (test-case "succ two => three"
    (check-equal? (force (n-read (succ two))) "3"))

   (test-case "succ three => four"
    (check-equal? (force (n-read (succ three))) "4"))


   ;    pred tests
   (test-case "pred zero => zero"
    (check-equal? (force (n-read (pred zero))) "0"))

   (test-case "pred one => zero"
    (check-equal? (force (n-read (pred one))) "0"))

   (test-case "pred two => one"
    (check-equal? (force (n-read (pred two))) "1"))

   (test-case "pred three => two"
    (check-equal? (force (n-read (pred three))) "2"))

   (test-case "pred five => four"
    (check-equal? (force (n-read (pred five))) "4"))


   ;    add tests
   (test-case "add zero zero => zero"
    (check-equal? (force (n-read ((add zero) zero))) "0"))

   (test-case "add zero one => one"
    (check-equal? (force (n-read ((add zero) one))) "1"))

   (test-case "add one zero => one"
    (check-equal? (force (n-read ((add one) zero))) "1"))

   (test-case "add two zero => two"
    (check-equal? (force (n-read ((add two) zero))) "2"))

   (test-case "add two three => five"
    (check-equal? (force (n-read ((add two) three))) "5"))

   (test-case "add one four => five"
    (check-equal? (force (n-read ((add one) four))) "5"))

   (test-case "add five five => ten"
    (check-equal? (force (n-read ((add five) five))) "10"))


   ;    sub tests
   (test-case "sub zero zero => zero"
    (check-equal? (force (n-read ((sub zero) zero))) "0"))

   (test-case "sub zero one => zero"
    (check-equal? (force (n-read ((sub zero) one))) "0"))

   (test-case "sub one zero => one"
    (check-equal? (force (n-read ((sub one) zero))) "1"))

   (test-case "sub two zero => two"
    (check-equal? (force (n-read ((sub two) zero))) "2"))

   (test-case "sub two three => zero"
    (check-equal? (force (n-read ((sub two) three))) "0"))

   (test-case "sub four one => three"
    (check-equal? (force (n-read ((sub four) one))) "3"))

   (test-case "sub five one => four"
    (check-equal? (force (n-read ((sub five) one))) "4"))
    

   ;    mult tests
   (test-case "mult zero zero => zero"
    (check-equal? (force (n-read ((mult zero) zero))) "0"))

   (test-case "mult zero one => zero"
    (check-equal? (force (n-read ((mult zero) one))) "0"))

   (test-case "mult one zero => zero"
    (check-equal? (force (n-read ((mult one) zero))) "0"))

   (test-case "mult two zero => zero"
    (check-equal? (force (n-read ((mult two) zero))) "0"))

   (test-case "mult two three => six"
    (check-equal? (force (n-read ((mult two) three))) "6"))

   (test-case "mult one four => four"
    (check-equal? (force (n-read ((mult one) four))) "4"))

   (test-case "mult five four => twenty"
    (check-equal? (force (n-read ((mult five) four))) "20"))


   ;    _exp tests
   (test-case "_exp zero zero => zero"
    (check-equal? (force (n-read ((_exp zero) zero))) "1"))

   (test-case "_exp zero one => zero"
    (check-equal? (force (n-read ((_exp zero) one))) "0"))

   (test-case "_exp three one => zero"
    (check-equal? (force (n-read ((_exp three) one))) "3"))

   (test-case "_exp one zero => one"
    (check-equal? (force (n-read ((_exp one) zero))) "1"))

   (test-case "_exp two zero => one"
    (check-equal? (force (n-read ((_exp two) zero))) "1"))

   (test-case "_exp two three => eight"
    (check-equal? (force (n-read ((_exp two) three))) "8"))

   (test-case "_exp one four => four"
    (check-equal? (force (n-read ((_exp one) four))) "1"))

   (test-case "_exp five four => 625"
    (check-equal? (force (n-read ((_exp five) four))) "625"))

))

(define church-relations-tests
 (test-suite
  "Church Numeral Relations Operations Tests"

   ;    isZero tests
   (test-case "isZero zero => true"
    (check-equal? (force (b-read (isZero zero))) "true"))

   (test-case "isZero one => false"
    (check-equal? (force (b-read (isZero one))) "false"))

   (test-case "isZero two => false"
    (check-equal? (force (b-read (isZero two))) "false"))

   (test-case "isZero three => false"
    (check-equal? (force (b-read (isZero three))) "false"))

   (test-case "isZero four => false"
    (check-equal? (force (b-read (isZero four))) "false"))

   (test-case "isZero five => false"
    (check-equal? (force (b-read (isZero five))) "false"))


   ;    gte tests
   (test-case "gte two zero => true"
    (check-equal? (force (b-read ((gte two) zero))) "true"))

   (test-case "gte zero one => false"
    (check-equal? (force (b-read ((gte zero) one))) "false"))

   (test-case "gte two two => false"
    (check-equal? (force (b-read ((gte two) two))) "true"))

   (test-case "gte three three => false"
    (check-equal? (force (b-read ((gte three) three))) "true"))

   (test-case "gte five four => false"
    (check-equal? (force (b-read ((gte five) four))) "true"))

   (test-case "gte two five => false"
    (check-equal? (force (b-read ((gte two) five))) "false"))


   ;    lte tests
   (test-case "lte two zero => true"
    (check-equal? (force (b-read ((lte two) zero))) "false"))

   (test-case "lte zero one => false"
    (check-equal? (force (b-read ((lte zero) one))) "true"))

   (test-case "lte two two => false"
    (check-equal? (force (b-read ((lte two) two))) "true"))

   (test-case "lte three three => false"
    (check-equal? (force (b-read ((lte three) three))) "true"))

   (test-case "lte five four => false"
    (check-equal? (force (b-read ((lte five) four))) "false"))

   (test-case "lte two five => false"
    (check-equal? (force (b-read ((lte two) five))) "true"))


   ;    eq tests
   (test-case "eq two zero => true"
    (check-equal? (force (b-read ((eq two) zero))) "false"))

   (test-case "eq zero one => false"
    (check-equal? (force (b-read ((eq zero) one))) "false"))

   (test-case "eq two two => false"
    (check-equal? (force (b-read ((eq two) two))) "true"))

   (test-case "eq three three => false"
    (check-equal? (force (b-read ((eq three) three))) "true"))

   (test-case "eq five four => false"
    (check-equal? (force (b-read ((eq five) four))) "false"))

   (test-case "eq two five => false"
    (check-equal? (force (b-read ((eq two) five))) "false"))


   ;    gt tests
   (test-case "gt two zero => true"
    (check-equal? (force (b-read ((gt two) zero))) "true"))

   (test-case "gt zero one => false"
    (check-equal? (force (b-read ((gt zero) one))) "false"))

   (test-case "gt two two => false"
    (check-equal? (force (b-read ((gt two) two))) "false"))

   (test-case "gt three three => false"
    (check-equal? (force (b-read ((gt three) three))) "false"))

   (test-case "gt five four => false"
    (check-equal? (force (b-read ((gt five) four))) "true"))

   (test-case "gt two five => false"
    (check-equal? (force (b-read ((gt two) five))) "false"))


   ;    lt tests
   (test-case "lt two zero => true"
    (check-equal? (force (b-read ((lt two) zero))) "false"))

   (test-case "lt zero one => false"
    (check-equal? (force (b-read ((lt zero) one))) "true"))

   (test-case "lt two two => false"
    (check-equal? (force (b-read ((lt two) two))) "false"))

   (test-case "lt three three => false"
    (check-equal? (force (b-read ((lt three) three))) "false"))

   (test-case "lt five four => false"
    (check-equal? (force (b-read ((lt five) four))) "false"))

   (test-case "lt two five => false"
    (check-equal? (force (b-read ((lt two) five))) "true"))
))


(displayln "***************************************")
(displayln "Running church arithmetic tests")
(run-tests church-arithmetic-tests 'verbose)
(newline)
(displayln "***************************************")
(displayln "Running church relations tests")
(run-tests church-relations-tests 'verbose)