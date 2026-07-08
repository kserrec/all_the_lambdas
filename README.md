# all_the_lambdas
### ~ LAMBDA CALCULUS! ~

**Welcome!**

## What Happens After the Lambda Calculus Tutorial Ends?

Most lambda calculus introductions build booleans, Church numerals, a little
arithmetic, recursion, and maybe lists. Then they stop.

This project keeps going.

The goal is to build as much as possible inside *pure untyped lambda calculus*:
numbers, integers, rationals, lists, algorithms, binary numeric encodings,
runtime typing disciplines, and data structures. Racket is the host language,
Lazy Racket supplies the evaluation strategy, but the object language — the
thing actually being programmed in — remains lambda-calculus encodings.
*(Exceptions are things of necessity, like printing out results or syntactic
sugar. Even the types are made out of untyped lambdas.)*

None of the individual ingredients are new — Church encodings, runtime tags,
binary arithmetic, and contract-style checking are all known ideas. The
distinctive part is the continuity: the same lambda-built world keeps getting
extended, piece by piece, into a substantial executable, tested library.

[Here](https://personal.utdallas.edu/~gupta/courses/apl/lambda.pdf) is a link to a short introduction to the Lambda Calculus.
Ideas have also been taken from this book, [Functional Programming Through Lambda Calculus](https://www.macs.hw.ac.uk/~greg/books/gjm.lambook88.pdf), and elsewhere. Other resources can easily be found online.

-------------------------------------------------------------------------

**Lambda Calculus is the simplest programming language in the world.**

To be able to build complex structures that work reliably out of a language with just a couple syntax and substitution rules is a fascination and joy.

#### Why Racket (and specifically Lazy Racket)?

Racket is used as a host language, not as the object language. The requirement
was never just "has lambdas" — most languages do. The requirement was: can I
write lambda-calculus-shaped programs directly, use self-application and
Y-combinator-style recursion, avoid premature evaluation, and still have enough
real tooling (modules, tests, macros) to build an actual repository?

Lazy Racket fits that unusually well:

- first-class functions and closures
- Lisp syntax that maps almost one-to-one onto lambda application
- macros for readable sugar that expands back to pure nested lambdas
- `#lang lazy`, whose evaluation order lets direct Y-combinator-style recursion
  work without first building a custom interpreter
- normal project tooling: modules, tests, scripts, CI

Eager hosts like Python or JavaScript can express the functions, but direct
self-application quickly drowns in manual thunking or interpreter machinery.
Lazy Racket is the execution substrate that makes the project survivable
without turning it into an interpreter project.

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
- **Added Embedded Types and Type Checking** — see [Typed Untyped Lambda Calculus](#typed-untyped-lambda-calculus) below
- **Integers** and basic operators for them
- **Rationals** and basic operators for them
- **Binary Digit List Encodings of Natural Numbers** — see [Binary Digit Lists](#binary-digit-lists) below
- **Signed Binary Integers** — integers as {sign, binary digit list} pairs with arithmetic, comparisons, absolute value, and parity (`int-binary-lists.rkt`)
- **Binary Rationals** — the scalable counterpart to the Church rationals: `{signed binary integer numerator, binary nat denominator}` with reduction, arithmetic, and comparisons (`binary-rationals.rkt`)
- **Option and Result** — typed containers in the strict type layer for computations that may not return a value: `option = some(value) | none` and `result = ok(value) | err(error)`, so expected absence and failure become values you handle instead of raw error objects (`types/TYPES.rkt`)
- **Data Structures as Closures** using closures to represent key/value pairs in a few ways (translating Greg Michaelson's code into pure lambda calculus)

#### Typed Untyped Lambda Calculus

This is not typed lambda calculus in the formal static sense — no simply typed
lambda calculus, no System F, no type checker that rejects terms before they
run. The underlying object language stays pure untyped lambda calculus.

The goal is more mischievous: build something that *behaves* like strict typing
from inside the untyped world itself. Types are Church-numeral tags. Typed
objects are lambda-encoded pairs whose first element is a lambda-encoded type
tag. Typed functions check those tags, unwrap valid inputs, rewrap outputs, and
propagate lambda-encoded error values when checks fail.

The error values are the most interesting part. They are not host-language
exceptions — they are lambda-encoded values like everything else. That means a
type failure doesn't halt anything: it can be returned, nested inside lists,
passed through higher-order functions like `MAP` and `FOLD`, chained into a
readable trace, and rendered later. In spirit this is closer to a
lambda-encoded dynamic contract layer (with blame-like error bubbling) than to
a formal static type system.

There are two takes on this, and having both is the point:

- **Strict** (`types/`) draws hard boundaries: this operation expects a nat;
  pass anything else and you get an error value.
- **Coercive** (`types/coercive/`, wip) asks what happens if values are
  converted instead of rejected: this operation needs a nat-shaped value, and
  here is how a bool, int, list, or rat collapses into one.

Two different answers to the same question: how much type-like behavior can be
built from inside untyped lambda calculus?

#### Binary Digit Lists

Church numerals are beautiful, but they are unary — a number is a function
applied n times, so the representation grows with the *value* of the number.
Beyond the tens of millions they stop being practical.

Binary digit lists are the project's first major representation upgrade. A
number becomes a lambda-encoded list of zero/one digits, so the cost grows
with the number of *bits* instead of the value. Arithmetic becomes the same
carry, borrow, shift, and long-division algorithms we learn by hand — and the
tests run through sextillion-scale values.

The point is not just that lambda calculus *can* encode arithmetic (that's the
tutorial part). It's that once enough structure exists, ordinary algorithm
design reappears inside the lambda universe.

#### Repository Map:
| Where | What | Flavor |
|---|---|---|
| `bitter/` | Logic, numerals, recursion, lists, algorithms | Purest: raw nested lambdas, zero sugar |
| root `*.rkt` | The same material, plus integers, rationals, binary lists (natural and signed) | Sugared: `def`, `_if`, `_let`, `_cons` |
| `types/` | Strict embedded type system and typed versions of everything | Sugared + typed |
| `types/coercive/` | Alternate type system that coerces instead of rejecting (wip) | Sugared + typed |
| `macros/` | The sugar itself — Racket macros that expand to pure nested lambdas | Not lambda calculus; the translator |
| `data-structures-as-closures/` | Key/value structures as closures (after Michaelson) | Sugared |
| `tests/`, `types/tests/`, `types/coercive/tests/` | Test suites (shared helpers in `tests/helpers/`) | — |

The three flavors are deliberate: same ideas, increasing comfort. Purity lives in what the code expands to, and everything expands to pure untyped lambda calculus.

#### How to Run Tests:
1. Download [Racket](https://racket-lang.org/) and the *lazy* package (`raco pkg install --auto lazy`)
2. From root, run `./run-all-tests.sh`
3. Or run one file or folder: `./run-all-tests.sh tests/logic-test.rkt`, `./run-all-tests.sh types`

Tests also run automatically on every push via GitHub Actions (`.github/workflows/tests.yml`).


#### How to Dissect:
- I recommend starting in the bitter folder with logic.rkt. Logic is where it all begins. And bitter is most pure.
- But if you want syntactic sugar, stay in the root and follow the same path I will outline here.
- Or if you want types and sugar, go to the types folder, but still the steps are the same -  start with logic wherever you go. It's only logical.
- Then go to church. Because after logic comes numbers. 
- Then recursion.rkt. We need this. 
- From there you can branch out to division or lists or integers.
- Then algorithms, binary-lists, wherever
