# Roadmap

Guiding principle: the *object language* (the lambda calculus terms themselves)
stays pure untyped lambda calculus, written the way a textbook would write it.
The sugar layer (macros) and tooling (test runner, CI) are ordinary
Racket/bash and may be improved freely — but readability-as-teaching-material
is valued there too, so explicit beats clever.

## Phase 2 — continuing the build (from ~/all-the-lambdas-notes.md priorities)

- [x] **1. README framing** — "what happens after the tutorial ends" opening,
  Lazy Racket rationale, softened uniqueness claim (2026-07-08)
- [x] **2. "Typed Untyped Lambda Calculus" explanation** — README section plus
  matching doc headers in `types/TYPES.rkt` (strict) and
  `types/coercive/TYPES.rkt` (strict-vs-coercive contrast) (2026-07-08)
- [x] **3. Binary-list explanation** — README section and `binary-lists.rkt`
  motivation reframed as the project's first representation upgrade (2026-07-08)
- [x] **3.5. Fix `type-check3` arg3 bug** — errors for a wrong-typed third
  argument were tagged with `param-type2`; fixed with regression tests
  (2026-07-08)
- [ ] **4. Restore historical binary integer work** (from the old
  `binary-lists/` folder, commits `664ced3`..`705a26b`)
  - [x] 4a. Nat-level operators restored into `binary-lists.rkt` with tests:
    `bin-succ`, `bin-pred`, `bin-lte`, `bin-gt`, `bin-is-even`, `bin-is-odd`,
    `bin-exp`. Note: historical `bin-is-even`/`bin-is-odd` were untested and
    buggy (`isZero` applied to a one-element list instead of its digit; `_not`
    applied to the function instead of the result) — fixed in restoration
    (2026-07-08)
  - [x] 4b. Signed binary integers restored as root `int-binary-lists.rkt`
    (makeZ-bin, succZ-bin, predZ-bin, invertZ-bin, addZ-bin, subZ-bin,
    multZ-bin, divZ-bin, expZ-bin, comparisons, absValZ-bin, parity), constants
    renamed bz.N -> bin-posN/bin-negN to match integers.rkt style. Historical
    tests restored and extended to the operators that never had any (succ,
    pred, invert, exp, comparisons, absVal, parity) — 121 tests (2026-07-08)
- [x] **5. Add `bin-div-n-mod` and `bin-mod`** — remainder via the long-division
  identity (remainder = dividend − quotient·divisor), leaving the tested
  `bin-div` untouched (2026-07-08)
- [x] **6. Add `bin-gcd` and `bin-lcm`** — Euclid via `bin-mod`;
  lcm = product / gcd (2026-07-08)
- [ ] **6.5. Purify `wrap-FOLD-only-once`** (`types/LISTS.rkt`) — the only spot
  where object-level control flow branches on host data: a Racket `if` +
  `string-contains?` checks whether an error message already says "FOLD" to
  avoid double-wrapping the trace. Replace the string sniffing with pure
  structure (e.g. a church-bool "already-labeled" flag carried in the error
  object). Found during the 2026-07-08 purity audit; everything else in the
  object language verified pure (no host branching, no host data, all
  recursion via Y)
- [ ] **7. Add `Option`/`Result` to the strict typing branch**
- [ ] **8. Decide the next major tentacle** — binary rationals vs typed-list /
  function signatures (user decision)

## Phase 1 — quality improvements (complete)

- [x] **1. Test runner overhaul** (`run-all-tests.sh`)
  - Run each test file **once**, not twice (currently the whole suite runs a
    second time just to build the summary — doubles an already slow lazy run)
  - Exit nonzero when any test fails (currently always exits 0, so nothing
    automated can detect a red suite)
  - Clean up the `mktemp` file on exit
  - Make file discovery safe for paths with spaces
  - Skip `tests/helpers/` (helper module, not a test)

- [x] **2. Harness quality-of-life** (beef up the custom harness — see
  Decisions: rackunit is rejected)
  - Optional argument to run a single test file or directory:
    `./run-all-tests.sh tests/logic-test.rkt`
  - Per-file colored PASS/FAIL line with timing
  - Files that crash (produce no results) count as failed
  - Red "Failing files" list at the end of the summary

- [x] **3. Continuous integration**
  - GitHub Actions workflow (`.github/workflows/tests.yml`): installs Racket +
    `lazy`, runs `./run-all-tests.sh` on every push and pull request
  - Verified passing on GitHub (first green run 2026-07-08, 1405/1405 tests)

- [x] **4. Small cleanups**
  - README: added a repository map table and single-file test instructions
  - `transform-string` in `types/TYPES.rkt`: turned out to be **dead code** —
    only referenced from the commented-out `read-list` variants next to the
    "can't decide on how to read lists" note. Left untouched since it's tied
    to that open design decision. Delete it (or revive a `read-list` that
    uses it) whenever the list-reading format gets decided.

## Out of scope (features — not this effort)

- ~~Finishing rational exponentiation~~ — **done 2026-07-07**: `expR` in
  `rationals.rkt` floors the exponent first (rationals stay closed under
  exponentiation), and a `floorR` bug (negative whole values floored one
  too far down, e.g. floor(−4/2) gave −3) was fixed along the way
- Finishing the coercive type system's remaining pieces

## Decisions

- **`def` macro stays as nine explicit arity cases.** A recursive ellipsis
  macro would be equivalent and shorter, but the explicit cases read like a
  desugaring table and that teaching value is worth the length. Purity is not
  at stake either way — the macro layer is outside the object language.
- **rackunit rejected; the custom harness is deliberate.** The project runs
  under `#lang lazy`, where every expression is a promise; rackunit's checks
  compare unforced promises and fail even when the underlying values match.
  The custom harness forces values naturally inside the lazy world. Improve
  it in place (items 1–2) rather than replacing it.
- **Test helpers are already shared** — all three suites (`tests/`,
  `types/tests/`, `types/coercive/tests/`) require the single
  `tests/helpers/test-helpers.rkt`. No deduplication needed.
