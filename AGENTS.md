# Project Instructions for All Agents

## Absolute invariant: the object language is pure untyped lambda calculus

This is the defining, non-negotiable characteristic of this project. Every
computational part of the object language must be implemented **100% in pure
untyped lambda calculus**. Never break this boundary, weaken it for convenience,
or suggest breaking it as an alternative.

This instruction applies to the entire repository. A nested instruction file
may make the rule stricter but must never relax it.

### What must remain lambda-encoded

Every object-language value and operation must reduce entirely to lambda terms,
including:

- Booleans, natural numbers, signed integers, rationals, pairs, and lists;
- conditionals, recursion, arithmetic, comparison, search, and other algorithms;
- runtime type tags, type checks, coercions, and function wrappers;
- errors and their propagation;
- `Option`, `Result`, and any future data or control representation.

Syntactic sugar such as `def`, `_let`, `_if`, and `_cons` is permitted only
because it mechanically expands into pure lambda terms. A macro must never add
host-language computational semantics.

### The only host-language boundary

Racket may host and observe the lambda terms, but it must not help compute their
object-language results.

Permitted host responsibilities are limited to:

- loading and evaluating the lambda terms;
- mechanically expanding syntax into pure lambda terms;
- reading an already-computed lambda-encoded value and formatting it for human
  output;
- external test and CI orchestration, including process deadlines, provided
  the tooling only observes execution and never determines an object-language
  result.

The output boundary is one-way. A host value produced by a reader must never be
fed back into object-language computation or used to choose its result.

### Categorically forbidden inside object-language implementation

Never use any Racket facility to perform, validate, shortcut, or control an
object-language computation. This includes, but is not limited to:

- Racket's type system, contracts, or typed language variants;
- host exceptions or exception handling as object-language errors;
- structs, classes, pattern matching, reflection, or host type predicates;
- host Booleans, numbers, strings, lists, hashes, sets, or other data structures
  as substitutes for lambda encodings;
- host conditionals, arithmetic, comparison, equality, search, parsing, or
  recursion to obtain an object-language result;
- mutation, state, threads, continuations, or other host control mechanisms;
- inspecting rendered strings or other host output to steer lambda-calculus
  execution.

No performance concern, implementation difficulty, safety argument, package,
or convenience justifies crossing this boundary.

### Proposal and review rule

Do not recommend a Racket feature, host-language checker, external type system,
or other semantic escape hatch as an alternative design. If a requested feature
cannot be implemented within pure untyped lambda calculus, state that conflict
plainly and stop. Do not implement or propose a host-assisted substitute.

When reviewing a change, verify the actual computational path rather than only
its surface syntax. Every branch, validation decision, error path, and returned
value must come from lambda-encoded computation. Readers and test tooling may
observe that result; they may not manufacture it.
