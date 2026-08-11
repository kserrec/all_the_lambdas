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
Racket's boundary roles are limited to hosting and evaluating the terms,
mechanically expanding readable sugar, and observing completed encodings for
human output and tests. Even the types are made out of untyped lambdas.

None of the individual ingredients are new — Church encodings, runtime tags,
binary arithmetic, and contract-style checking are all known ideas. The
distinctive part is the continuity: the same lambda-built world keeps getting
extended, piece by piece, into a substantial executable, tested library.

If you want to learn from that progression rather than browse it at random,
clone the repository and open the self-contained **[Interactive Learning
Path](LEARNING_PATH.html)** in a browser. It gives the repository a
dependency-aware spine from Boolean selection through Church numerals,
recursion, lists, composed number systems, algorithms, binary representations,
and lambda-encoded runtime typing. Each stop names the source definitions to
study, the idea they contribute, the focused test coverage that exists, and a
checkpoint for knowing when to move on.

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
- **Rationals** and basic operators for them. In the raw Church-backed
  representation, a zero numerator or a zero denominator counts as rational
  zero. Raw reciprocal and division by rational zero therefore return rational
  zero (`rationals.rkt`)
- **Binary Digit List Encodings of Natural Numbers** — see [Binary Digit Lists](#binary-digit-lists) below
- **Signed Binary Integers** — integers as {sign, binary digit list} pairs with arithmetic, comparisons, absolute value, and parity (`int-binary-lists.rkt`)
- **Binary Rationals** — the scalable counterpart to the Church rationals: `{signed binary integer numerator, binary nat denominator}` with reduction, arithmetic, comparisons, floor, and exponentiation. It deliberately uses the same raw rational-zero rule: a zero numerator or denominator counts as rational zero, and division by rational zero returns rational zero (`binary-rationals.rkt`)
- **Option and Result** — typed containers in the strict type layer for computations that may not return a value: `option = some(value) | none` and `result = ok(value) | err(error)`, so expected absence and failure become values you handle instead of raw error objects. Strict runtime-tagged rational division overrides the raw zero-divisor behavior by returning `result:err(err:div by 0)`; coercive runtime-tagged rational division returns `err:div by 0` after coercing the divisor (`types/TYPES.rkt`, `types/RATIONALS.rkt`, `types/coercive/RATIONALS.rkt`)
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

#### Division by Zero Is Layer-Specific

The project deliberately keeps several division policies because the layers
are exploring different ideas. Here, *partial* means that demanding the result
does not produce either a value or an error; evaluation continues indefinitely.

| Number family and layer | Zero-divisor policy |
|---|---|
| Raw Church naturals and integers; strict runtime-tagged wrappers | `div`/`divZ` and correctly tagged `DIV`/`DIVz` are partial and do not terminate. Raw/strict natural modulo inherits the same boundary. |
| Coercive runtime-tagged naturals and integers | Coerce the divisor, then return `err:div by 0` when the coerced value is zero. |
| Binary naturals and signed binary integers | `bin-div x 0 = 0`, `bin-mod x 0 = x`, and signed division inherits the zero quotient magnitude. This preserves `x = quotient × divisor + remainder`. |
| Raw Church-backed and binary-backed rationals | A zero numerator or denominator represents rational zero, so division by rational zero returns rational zero. |
| Runtime-tagged rationals | Strict division returns `result:err(err:div by 0)`; coercive division checks after coercion and returns `err:div by 0`. |

#### Repository Map:
| Where | What | Flavor |
|---|---|---|
| `bitter/` | A partial parallel route through logic, numerals, recursion, division, lists, integers, and binary search | Purest: raw nested lambdas, zero sugar |
| root `*.rkt` | The continuous raw library: logic, numerals, recursion, collections, composed number families, algorithms, and binary-backed numbers | Sugared: `def`, `_if`, `_let`, `_cons` |
| `types/` | Strict embedded type system, typed wrappers, and `Result`-returning safe rational division | Sugared + typed |
| `types/coercive/` | Alternate type system that coerces instead of rejecting; rational division returns explicit errors after coercion (wip) | Sugared + typed |
| `macros/` | The sugar itself — Racket macros that expand to pure nested lambdas | Not lambda calculus; the translator |
| `data-structures-as-closures/` | Key/value structures as closures (after Michaelson) | Sugared |
| `bitter/tests/`, `tests/`, `types/tests/`, `types/coercive/tests/` | Test suites (shared helpers in `tests/helpers/`) | — |

The overlap is deliberate, but the branches do not all have identical
coverage. Use the root modules as the main learning spine, `bitter/` as a
microscope for selected unsugared definitions, `types/` for strict runtime
boundaries, and `types/coercive/` for the alternate conversion experiment.
Purity lives in the computational terms: every object-language operation is
already, or mechanically expands to, pure untyped lambda calculus.

For the maintainer-oriented module dependencies, execution boundary, and
end-to-end implementation flows, read [ARCHITECTURE.md](ARCHITECTURE.md).

#### Setup and tests

This is a library and teaching repository, not an application with a server or
single runtime entry point. After cloning it, install
[Racket](https://racket-lang.org/) and the `lazy` package:

```bash
raco pkg install --auto lazy
```

From the repository root, run every test:

```bash
./run-all-tests.sh
```

Or shrink the loop to one file or one test directory:

```bash
./run-all-tests.sh tests/logic-test.rkt
./run-all-tests.sh types
```

The full suite deliberately spends about one minute checking partial division:
`tests/nontermination-test.rkt` starts a fresh Lazy Racket process for each of
four approved zero-divisor expressions and requires each one to remain active
until a 10-second deadline. Matching terminating controls ensure the deadline
is evidence of nontermination rather than slow module startup or a broken
harness.

Tests also run automatically on every push via GitHub Actions (`.github/workflows/tests.yml`).


#### How to Learn from the Repository

Use the root modules as the main route because they carry the ideas all the way
through the current library. At the beginning, compare a few definitions in
`logic.rkt` with `bitter/logic.rkt` and inspect `macros/macros.rkt`; that proves
the root notation mechanically expands to nested lambdas. Return to `bitter/`
whenever you want the unsugared form, rather than maintaining two separate
walkthroughs in your head.

The full order is:

1. logic and selection;
2. Church numerals and iteration;
3. fixed-point recursion;
4. pairs, lists, and higher-order traversal;
5. division, signed integers, and rationals;
6. search and sorting;
7. binary naturals, signed binary integers, and binary rationals;
8. strict runtime tags, errors, `Option`, and `Result`; and
9. the coercive runtime-tagged experiment.

The self-contained **[Interactive Learning Path](LEARNING_PATH.html)** explains
why this order matters, identifies the exact definitions and tests at every
stop, and adds collapsible lessons, search, route filters, progress tracking,
and copyable test commands. Open it locally after cloning the repository.

#### Documentation map

- [Interactive Learning Path](LEARNING_PATH.html) — the guided teaching route
  through source, concepts, and focused evidence.
- [Architecture](ARCHITECTURE.md) — module ownership, object/host boundaries,
  end-to-end flows, and contribution mechanics.
- [Roadmap](ROADMAP.md) — live decisions, deferred work, and possible future
  directions. [Roadmap Archive](ROADMAP-ARCHIVE.md) holds the verbatim
  completed implementation history.
