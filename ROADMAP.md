# Roadmap

Guiding principle: the *object language* (the lambda calculus terms themselves)
stays pure untyped lambda calculus, written the way a textbook would write it.
The sugar layer (macros) and tooling (test runner, CI) are ordinary
Racket/bash and may be improved freely — but readability-as-teaching-material
is valued there too, so explicit beats clever.

## Session status (as of 2026-08-11)

The integrity queue, targeted rational-division and binary-search work, and the
documentation-only pedagogical spine are complete. The latest recorded
dotenv-excluding 26-file repository run passes 1,893/1,893 tests. The
self-contained `LEARNING_PATH.html` is the canonical learner guide;
`ARCHITECTURE.md` is the maintainer map.

Phase 2 is complete except for the optional follow-ons below and the deferred
reals arc. No Phase 3 direction is defined or authorized.
There is no pre-authorized implementation phase for a new `$next` invocation;
unless Kyle explicitly names one of the optional follow-ons, the next action is
discussion about what bounded work—if any—to select.

## Phase 2 follow-ons — optional, not currently selected

The strict `Option`/`Result` base was completed 2026-07-08 with Church tags 6
and 7; lambda-encoded discriminating pairs; constructors, predicates,
selectors, safe eliminators, and `read-any` integration; and 29 tests.
`IND-OPT` and Option-returning searches were completed through 2026-08-11 →
archived in `ROADMAP-ARCHIVE.md`.

- [ ] **Step 1. Add `HEAD-OPT`** — no typed `HEAD` currently exists. This
  would be a new strict-layer API, not a correction to an existing wrapper.
- [~] **Step 2. Continue Result-returning safe division families** — strict
  rational `DIVr` returns `result:ok(rat)` or
  `result:err(error)` (2026-08-10). Strict natural and integer division still
  inherit approved raw partiality; any safe forms must be new APIs rather than
  silent changes to those operations.

## Phase 2 item 8c — reals arc (deferred)

Binary rationals were chosen 2026-07-08 over typed-list/function-signature work.
They reached parity with `rationals.rkt`; their base operations, `floorR-bin`,
and `expR-bin` are complete → archived in `ROADMAP-ARCHIVE.md`.

- [ ] **Step 1. Build the numeric-tower continuation** — dyadic rationals, then
  intervals, then computable reals as approximation functions.

This arc was deliberately set aside by Kyle. Do not select or begin it without
asking.

## Phase 3 — not defined or authorized

The direction is a pending user decision. Candidate tracks discussed, with the
reals arc excluded:

- strings → parser combinators, reusing `Result` (recommended);
- deepen the strict type layer with richer errors, precondition checks,
  typed-list element discipline, and function signatures;
- data structures: trees → binary search trees → sets → maps → graphs;
- lambda terms as data: `Var`/`Abs`/`App`, substitution, beta reduction,
  De Bruijn indices, and SKI.

See `~/all-the-lambdas-notes.md` for the full menu.

## Standing constraints and deferred findings

- **The object language remains pure untyped lambda calculus.** Host code may
  load, expand, observe, test, and impose external deadlines; it may not
  determine an object-language result.
- **Division policy is intentionally layer-specific (accepted 2026-08-11).**
  Raw Church-natural/integer and strict natural/integer division are partial;
  coercive natural/integer division returns `err:div by 0`; binary division
  returns quotient zero and the dividend as remainder; raw rationals treat a
  zero numerator or denominator as rational zero; strict rational division
  returns a `Result` error and coercive rational division returns a typed
  error. The rational decision dated 2026-08-10 preserves both raw
  representations exactly and adds guards only in runtime-tagged layers.
- **`transform-string` remains dead code tied to an open presentation
  decision.** It is referenced only from commented-out `read-list` variants
  in `types/TYPES.rkt`. Delete it or revive a reader that uses it only when the
  list-reading format is decided.
- Finishing the coercive type system's remaining pieces remains out of scope
  for the completed quality effort.

## Completed work index

- Interactive learning path HTML remake — complete 2026-08-11 → archived in `ROADMAP-ARCHIVE.md`.
- Pedagogical spine and learner explanations — complete 2026-08-11 → archived in `ROADMAP-ARCHIVE.md`.
- Targeted remaining verified findings — complete 2026-08-11 → archived in `ROADMAP-ARCHIVE.md`.
- Terminating Option-returning binary search — complete 2026-08-11 → archived in `ROADMAP-ARCHIVE.md`.
- Rational division semantics — complete 2026-08-10 → archived in `ROADMAP-ARCHIVE.md`.
- Integrity Phase 1 (truthful green-test claims) — complete 2026-08-11 → archived in `ROADMAP-ARCHIVE.md`.
- Integrity Phase 2 (restored `bitter/` route) — complete 2026-08-11 → archived in `ROADMAP-ARCHIVE.md`.
- Integrity Phase 3 (bounded nontermination evidence) — complete 2026-08-11 → archived in `ROADMAP-ARCHIVE.md`.
- Integrity Phase 4 (canonical binary structure) — complete 2026-08-11 → archived in `ROADMAP-ARCHIVE.md`.
- Integrity Phase 5 (declared division policies) — complete 2026-08-11 → archived in `ROADMAP-ARCHIVE.md`.
- Later authorized integrity findings — complete 2026-08-11 → archived in `ROADMAP-ARCHIVE.md`.
- Phase 2 foundation items 1–6.5 — complete 2026-07-08 → archived in `ROADMAP-ARCHIVE.md`.
- Phase 2 `IND-OPT` and Option-search follow-ons — complete 2026-07-08 through 2026-08-11 → archived in `ROADMAP-ARCHIVE.md`.
- Phase 2 binary-rational implementation through exponentiation — complete 2026-07-08 → archived in `ROADMAP-ARCHIVE.md`.
- Phase 1 quality improvements — complete 2026-07-08 → archived in `ROADMAP-ARCHIVE.md`.
- Rational exponentiation and its negative-whole floor correction — complete 2026-07-07 → archived in `ROADMAP-ARCHIVE.md`.

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
- **Test helpers are already shared** — all four suites (`bitter/tests/`,
  `tests/`, `types/tests/`, `types/coercive/tests/`) require the single
  `tests/helpers/test-helpers.rkt`. No deduplication needed.
