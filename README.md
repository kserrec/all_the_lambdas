# all_the_lambdas
### ~ LAMBDA CALCULUS! ~

**Welcome!**

The idea here is to do just about everything in *Pure Untyped Lambda Calculus*.  
*(Exceptions will be things of necessity like printing out results or syntactic sugar. 
Even if types are added, they will be made out of untyped lambdas.)*

[Here](https://personal.utdallas.edu/~gupta/courses/apl/lambda.pdf) is a link to a short introduction to the Lambda Calculus.
Ideas have also been taken from this book, [Functional Programming Through Lambda Calculus](https://www.macs.hw.ac.uk/~greg/books/gjm.lambook88.pdf), and elsewhere. Other resources can easily be found online.

-------------------------------------------------------------------------

**Lambda Calculus is the simplest programming language in the world.**


To be able to build complex structures that work reliably out of a language with just a couple syntax and substitution rules is a fascination and joy.  
I chose to use **Racket** because it was the first language I could find that seemed to give me the tools I needed for doing this as simply as possible.

Note: this is a work in progress and I don't know when it will be complete if ever.

#### What's been done/made so far:
- **Boolean values** and logical operators
- **Church Numerals** and arithmetic operators
- **Equalities** and **Inequalities**
- **Recursion** using the Y-Combinator and some recursive functions
- **More Advanced Arithmetic** (like division and the creation of integers and operators for them)
- **Pairs** and **Lists** with operators for them
- **Algorithms** binary Search for church numerals and integers and a few sorting algorithms
- **Added Syntactic Sugar** to make things look good. Specifically, added def, let, and conditional sugar
- **Added Embedded Types and Type Checking** defined types out of untyped lambda calculus. This is an informal type system, a type-like system, probably best called an embedded type system. Most everything built so far now has embedded typed versions! Have strict typing system, but also defining coercive alternate (wip)
- **Integers** and basic operators for them
- **Rationals** and basic operators for them
- **Binary Digit List Encodings of Natural Numbers** and add and multiplication operators for them - these are hundreds of orders of magnitude more capable at representing numbers than Church Numerals in terms of size
- **Data Structures as Closures** using closures to represent key/value pairs in a few ways (translating Greg Michaelson's code into pure lambda calculus)

#### How to Run Tests:
1. Download [Racket](https://racket-lang.org/) and the *lazy* package
2. From root, run `./run-all-tests.sh`


#### How to Dissect:
- I recommend starting in the bitter folder with logic.rkt. Logic is where it all begins. And bitter is most pure.
- But if you want syntactic sugar, stay in the root and follow the same path I will outline here.
- Or if you want types and sugar, go to the types folder, but still the steps are the same -  start with logic wherever you go. It's only logical.
- Then go to church. Because after logic comes numbers. 
- Then recursion.rkt. We need this. 
- From there you can branch out to division or lists or integers.
- Then algorithms, binary-lists, wherever
