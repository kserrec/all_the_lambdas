# Architecture

This document is the maintainer map for `all_the_lambdas`: where computation
lives, how the module families relate, how values travel through the system,
and how to verify a change. For a teaching sequence through the ideas, use the
[Interactive Learning Path](LEARNING_PATH.html). For project framing and the
division-policy matrix, use the [README](README.md).

## The boundary that defines the project

The object language is pure untyped lambda calculus. Every value, branch, and
returned computational result inside that language must reduce to lambda
terms. Booleans, naturals, integers, rationals, pairs, lists, recursion,
algorithms, runtime tags, errors, `Option`, and `Result` all stay on that side
of the boundary.

Racket is the host. Its allowed jobs are deliberately narrower:

| Object language | Host and tooling |
|---|---|
| Lambda-encoded values and operations | Load modules and evaluate terms lazily |
| Lambda-encoded selection and recursion | Mechanically expand notation such as `def`, `_let`, `_if`, and `_cons` |
| Lambda-encoded tags, validation, errors, `Option`, and `Result` | Read an already-computed encoding into human-facing output |
| Every decision that determines an object-language result | Discover and run tests, impose external deadlines, and report results |

Readers such as `b-read`, `n-read`, `l-read`, `bin-read`, and `read-any` are
one-way observation points. Their Racket strings and numbers must never be fed
back into a term to choose an object-language result. Typed errors may carry
host strings as opaque diagnostic payloads, but lambda-encoded tags and
predicates—not inspection of those strings—control propagation.

When reviewing a change, follow the actual computational path. Surface syntax
is not enough: every branch, validation decision, error path, and return value
must remain lambda-encoded.

## Execution substrate and notation

Most root modules begin with:

```racket
#lang s-exp "macros/lazy-with-macros.rkt"
```

[`macros/lazy-with-macros.rkt`](macros/lazy-with-macros.rkt) re-exports Lazy
Racket as the module language. Lazy evaluation is what permits the direct
self-application used by the `Y` combinator without turning the repository into
a separate interpreter.

[`macros/macros.rkt`](macros/macros.rkt) provides the readable notation:

| Form | Mechanical expansion |
|---|---|
| `def` | A module binding whose arguments become nested one-argument lambdas |
| `_let` | Immediate application of a one-argument lambda |
| `_if` | Application of the encoded Boolean selector to two branches |
| `_cons` | Nested applications of the lambda-encoded `pair`, ending in `nil` |

The macro layer is ordinary Racket tooling, outside the object language. Its
expansions are intentionally explicit because they double as a desugaring
table. [`core.rkt`](core.rkt) defines `pair` and `nil` directly under
`#lang lazy`; [`bitter/`](bitter/) provides a partial parallel route written as
raw nested lambdas without the macros.

## Module families

The root modules form the main implementation spine. The dependency order is
conceptually:

```text
pair/nil + Boolean selection
    → Church naturals + fixed-point recursion
    → lists + division
    → signed integers + rationals + algorithms
    → binary naturals → signed binary integers → binary rationals
```

Individual modules import foundational files explicitly, so this is the
conceptual flow rather than an exhaustive `require` graph.

| Area | Primary files | Responsibility |
|---|---|---|
| Representation base | `core.rkt`, `logic.rkt` | Pairs, `nil`, Boolean selectors, and Boolean operations |
| Unary naturals and recursion | `church.rkt`, `recursion.rkt` | Church numerals, arithmetic/comparison, `Y`, and sample recursive functions |
| Collections and division | `lists.rkt`, `division.rkt` | Lambda lists, traversal/composition, Church-natural quotient and remainder |
| Composed numeric values | `integers.rkt`, `rationals.rkt` | Sign/magnitude integers and integer-over-natural rationals |
| Algorithms | `algorithms.rkt` | Binary search and sorting over the existing encodings |
| Persistent data structures | `trees.rkt`, `queues.rkt`, `heaps.rkt` | Handler-encoded binary trees (traversals, folds, comparator-parameterized BSTs), two-list FIFO queues, and rank-carrying leftist min-heaps — all persistent by construction |
| Comparator-parameterized algorithms | `sorting.rkt`, `graphs.rkt` | Merge/quick/heap sorts taking their ordering as an argument; adjacency-list graphs (equality-parameterized) with DFS, BFS, reachability, paths, distances, cycles, components, and topological sort |
| Scalable numeric values | `binary-lists.rkt`, `int-binary-lists.rkt`, `binary-rationals.rkt` | Binary digit-list naturals, signed binary integers, and binary rationals |
| Bit-level and number theory | `binary-algorithms.rkt` | Shifts, width-relative NOT, bit stats, bitwise AND/OR/XOR, binary↔Church conversions, isqrt, modexp, extended Euclid, modular inverses, primality, fast-doubling Fibonacci — built atop the binary libraries without modifying them |
| Strict runtime discipline | `types/TYPES.rkt`, other `types/*.rkt` | Tags, checked wrappers, error propagation, `Option`, `Result`, and strict operation families |
| Coercive experiment | `types/coercive/TYPES.rkt`, other `types/coercive/*.rkt` | Conversion policies and wrappers that coerce before invoking raw operations |
| Unsugared teaching route | `bitter/*.rkt` | Selected logic-through-algorithm modules as direct nested lambdas |
| Closure demonstrations | `data-structures-as-closures/update.rkt` | Key/value lookup and update structures represented as closures |

Root operations are generally lowercase (`add`, `binarySearch`, `divR`), while
runtime-tagged wrappers are generally uppercase (`ADD`, `BINARY-SEARCH`,
`DIVr`). Calls are curried: `((add two) three)` applies one argument at a time.

## Three end-to-end flows

### 1. A sugared Boolean operation

1. [`logic.rkt`](logic.rkt) defines `true`, `false`, and `_and` with `def`.
2. `def` expands every argument into a nested one-argument lambda.
3. `_and` computes by applying its first Boolean selector to the second value
   and `false`; no Racket conditional chooses the result.
4. `b-read` observes the resulting selector as the string `"true"` or
   `"false"` for tests and people.

Compare the same definitions in [`bitter/logic.rkt`](bitter/logic.rkt) to see
the nested lambdas directly.

### 2. Raw search becomes typed `Option`

1. [`algorithms.rkt`](algorithms.rkt) implements `binarySearch` with `Y`,
   half-open Church-natural bounds, `len`, `ind`, comparison, and division.
2. The raw result is the encoded pair `{found Boolean, Church-natural index}`;
   absence is `{false, zero}`.
3. [`types/ALGORITHMS.rkt`](types/ALGORITHMS.rkt) validates the typed list and
   target with `type-check2`, unwraps their encoded values, and calls the raw
   search.
4. A found index becomes `make-some(make-nat(index))`; an expected miss becomes
   `NONE`. Wrong input tags remain typed errors rather than expected absence.
5. `read-any` in [`types/TYPES.rkt`](types/TYPES.rkt) renders the completed value
   as `option:some(nat:index)` or `option:none`.

### 3. Strict rational division returns `Result`

1. [`types/RATIONALS.rkt`](types/RATIONALS.rkt) sends both arguments through
   `type-check2` before their values are used.
2. `DIVr-result` checks the raw divisor with the lambda-encoded `isZeroR`.
3. A zero divisor returns `make-err-result(make-rat-err(...))`; otherwise the
   unchanged raw `divR` result is wrapped with `make-rat` and `make-ok`.
4. The coercive counterpart in
   [`types/coercive/RATIONALS.rkt`](types/coercive/RATIONALS.rkt) first converts
   the divisor according to the coercive policy, then returns its typed error
   or invokes the raw operation.

The raw, strict, coercive, binary, and rational zero-divisor policies are
deliberately different. The authoritative comparison is the README's
[division-policy table](README.md#division-by-zero-is-layer-specific).

## Testing and continuous integration

The project uses a small custom harness in
[`tests/helpers/test-helpers.rkt`](tests/helpers/test-helpers.rkt). `rackunit`
is intentionally not used: under `#lang lazy`, its checks compare unforced
promises rather than the underlying values. Tests instead render completed
encodings and compare their human-readable results.

[`run-all-tests.sh`](run-all-tests.sh) finds every `.rkt` file beneath a
`tests/` directory, excludes `tests/helpers/`, runs each selected file once,
streams its output, and treats crashes, missing result lines, or reported
failures as a failing command. It accepts any mixture of test files and test
directories.

Install the one non-base requirement after cloning:

```bash
raco pkg install --auto lazy
```

Run the complete suite from the repository root:

```bash
./run-all-tests.sh
```

Shrink the feedback loop while working:

```bash
./run-all-tests.sh tests/algorithms-test.rkt types/tests/ALGORITHMS-test.rkt
```

The full run includes [`tests/nontermination-test.rkt`](tests/nontermination-test.rkt),
which uses fresh host-level Racket subprocesses and 10-second deadlines to
observe four deliberately partial division calls without hanging the runner.
That file is test infrastructure; it never determines an object-language
result. [`.github/workflows/tests.yml`](.github/workflows/tests.yml) installs
Racket and `lazy`, then runs the same complete command on pushes and pull
requests.

## Making a change

1. Choose the representation and policy layer first: raw root, binary-backed,
   strict runtime-tagged, coercive runtime-tagged, or the partial `bitter/`
   teaching route.
2. Trace all required values, predicates, branches, errors, and recursion back
   to lambda encodings. Readers and test helpers may observe the result but may
   not manufacture it.
3. Add focused evidence under the matching test family: `tests/`,
   `bitter/tests/`, `types/tests/`, or `types/coercive/tests/`.
4. Run the smallest affected test file first, then `./run-all-tests.sh` before
   handing off an executable change.
5. Update the README when a public policy or capability changes, this document
   when module ownership or flow changes, and the roadmap when implementation
   status changes.

Do not silently make parallel layers agree. A policy difference can be the
point of the experiment. Verify the existing behavior and its documentation
before changing it.

## Documentation and current status

- [README.md](README.md) — project purpose, major capabilities, vocabulary,
  representation policies, and quick setup.
- [LEARNING_PATH.html](LEARNING_PATH.html) — the interactive, dependency-aware
  teaching route through source and focused tests.
- [ARCHITECTURE.md](ARCHITECTURE.md) — maintainer ownership, module boundaries,
  flows, and contribution mechanics.
- [ROADMAP.md](ROADMAP.md) — live decisions, deferred work, and future direction.
- [ROADMAP-ARCHIVE.md](ROADMAP-ARCHIVE.md) — verbatim completed planning
  history removed from the live roadmap.

The repository is a work in progress, and the coercive type family is
intentionally incomplete. Consult `ROADMAP.md` for the live queue and deferred
directions rather than copying status into another document.
