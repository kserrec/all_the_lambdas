# Roadmap

Guiding principle: the *object language* (the lambda calculus terms themselves)
stays pure untyped lambda calculus, written the way a textbook would write it.
The sugar layer (macros) and tooling (test runner, CI) are ordinary
Racket/bash and may be improved freely — but readability-as-teaching-material
is valued there too, so explicit beats clever.

## Overnight run 2026-08-11 → 2026-08-12 (authorized by Kyle, this session)

Kyle authorized an unattended overnight run covering four work items: persistent
binary trees, better list sorting, graphs and traversals, and more binary-number
algorithms. Monads and gaussian rationals were explicitly CUT from scope — do
not start them. Branch: `overnight-trees-sorting-graphs-binary` (all commits go
here, pushed after each commit).

### Run protocol (every iteration follows this exactly)

1. Find the first unchecked `[ ]` step below. Execute exactly that step.
2. Purity rules are absolute (see The Master Rule in CLAUDE.md): object-language
   code uses only lambda/application/variables via the sugar in
   `macros/macros.rkt`; Church encodings for all data; all recursion via
   `(Y helper)` where the helper takes itself as first parameter `f` — a `def`
   never references its own name; host Racket only for readers (marked
   "not pure LC"), naming, and tests.
3. New root modules use `#lang s-exp "macros/lazy-with-macros.rkt"`. Test files
   go under `tests/` (auto-discovered by the runner), require
   `tests/helpers/test-helpers.rkt` plus every module whose bindings they use,
   and follow the `test-list-element` / `show-results` idiom. Keep test operand
   values small — Church/binary arithmetic under laziness is slow.
4. Run the FULL suite: `./run-all-tests.sh`. Commit only on a fully green run.
5. On green: commit (`Overnight <step-id>: <summary>`), push, check the step
   off here with the date, commit the roadmap tick with `--amend` or as part of
   the same commit, then continue to the next step.
6. On red that resists two diagnostic hypotheses: revert the working tree to
   the last commit (`git checkout -- . && git clean -fd` on the new files),
   mark the step `[BLOCKED: <one-line reason>]` here, commit that roadmap note,
   and continue with the next step that does not depend on the blocked one.
   Never stack unproven fixes; never commit a red suite.
7. When every step is checked or blocked, do Phase E (wrap-up), then stop the
   loop entirely so the session goes idle for Kyle to close in the morning.

### Shared conventions for the new code

- Comparators are arguments, never baked in: BST ops take a less-than predicate
  `lt` (equality is derived: `(_and (_not (lt a b)) (_not (lt b a)))`); merge
  sort and heaps take `lte`; graphs take an equality predicate `eq?v`. This is
  what lets one implementation serve Church naturals (`lt`/`lte`/`eq`),
  integers (`ltZ`/`lteZ`/`eqZ`), rationals (`ltR`/`lteR`/`eqR`), binary nats
  (`bin-lt`/`bin-lte`/`bin-eq`), and signed binary ints (`ltZ-bin`/…).
- "Maybe-a-value" results at this raw layer are plain lambda pairs
  `{found-bool, payload}` — `(pair true v)` / `(pair false false)`. (The typed
  Option lives in `types/`; do not depend on `types/` from root modules.)
- Every definition carries the house Contract/Idea/Logic block comment.
- Readers added for tests are host-level, commented "not pure LC", and live
  with their module.

### Phase A — persistent binary trees (`trees.rkt`, `queues.rkt`)

- [ ] **A1. Tree encoding + constructors + basic observers** (`trees.rkt`,
  `tests/trees-test.rkt`). Handler encoding, same discrimination-by-application
  style as the rest of the repo: `t-empty = λe.λn. e`,
  `t-node l v r = λe.λn. n l v r`; `t-leaf v = t-node t-empty v t-empty`;
  `isEmptyT t = t true (λl.λv.λr. false)`; selectors `t-val`/`t-left`/`t-right`
  via the node handler (contract: node trees only). Host reader
  `t-read tree read-fn`: empty → `"_"`, node → `"(<val> <left> <right>)"`
  recursively. Tests: build small trees by hand, check `isEmptyT`, selectors,
  and `t-read` shapes.
- [ ] **A2. Depth-first traversals** — `preorder`/`inorder`/`postorder`, each
  `(Y helper)` returning a lambda list (use `app` from `lists.rkt` to join, or
  an accumulator; either is fine, be consistent). Tests render with
  `(l-read (inorder t) n-read)` on hand-built trees.
- [ ] **A3. Persistent queue** (`queues.rkt`, `tests/queues-test.rkt`).
  Two-list queue `{front, back}`: `q-empty`, `q-isEmpty`, `q-push x q` (conses
  onto back), `q-pop q` → `{found-bool, {head, rest-queue}}` with the reversal
  of `back` into `front` when `front` runs dry (`rev` exists in `lists.rkt`).
  `q-pop q-empty` → `(pair false false)`. Tests: FIFO order over pushes/pops,
  persistence (popping a queue leaves the original usable).
- [ ] **A4. Breadth-first traversal** — `bfs-order t` in `trees.rkt` using the
  A3 queue: pop a tree, emit its value, push its children. Tests: level order
  of a 3-level tree.
- [ ] **A5. size / height / depth / map / fold / mirror** — `t-size`,
  `t-height` (empty → 0, node → succ of max of children; max via `gte`),
  `t-fold g z t` (empty → z, node → `g (fold l) v (fold r)`), `t-map g t`,
  `t-mirror t`, and `t-depth lt x t` → `{found-bool, church-depth}` of `x` in a
  BST (root depth zero), using the derived equality. Tests include: size and
  height agree with hand counts; `t-mirror (t-mirror t)` inorder-reads equal to
  `t`; `t-fold` reimplements `t-size`.
- [ ] **A6. BST insert / lookup / min / max** — comparator-parameterized:
  `bst-insert lt x t` (duplicates: keep tree unchanged on equal), `bst-lookup
  lt x t` → lambda bool, `bst-min t` / `bst-max t` → `{found-bool, value}`
  (empty → false pair). Tests across at least Church naturals AND binary nats
  AND integers to prove parameterization. Include the persistence test: insert
  into `t`, then show `t` itself still inorder-reads unchanged.
- [ ] **A7. BST deletion** — `bst-delete lt x t`: leaf → empty; one child →
  that child; two children → replace value with in-order successor (min of
  right subtree) and delete that successor from the right subtree. Absent value
  → tree unchanged. Tests: delete leaf/one-child/two-children/root/absent,
  inorder stays sorted throughout.

### Phase B — sorting (`sorting.rkt`, `heaps.rkt`)

- [ ] **B1. Merge sort** (`sorting.rkt`, `tests/sorting-test.rkt`).
  `merge lte l1 l2` via Y; split by halving with `len`, `_take`, `_drop` (all
  in `lists.rkt`); `merge-sort lte lst` via Y with singleton/empty base cases.
  Tests: empty, singleton, sorted, reverse-sorted, duplicates; run the same
  sort on Church naturals (`lte`), integers (`lteZ`), and binary nats
  (`bin-lte`).
- [ ] **B2. Quicksort via filter** — `quick-sort lt lst`: pivot = head; recurse
  on `(_filter (λx. lt x pivot) rest)` and the complement
  (`(_filter (λx. _not (lt x pivot)) rest)`). Same test matrix as B1.
- [ ] **B3. Leftist heap** (`heaps.rkt`, `tests/heaps-test.rkt`). Handler
  encoding parallel to trees but with rank: `h-empty`, `h-node rank v l r`;
  `h-rank` (empty → zero); core `h-merge lte h1 h2` (smaller root wins, merge
  into its right, swap children to restore leftist rank invariant);
  `h-insert lte x h = h-merge lte (h-node one x h-empty h-empty) h`;
  `h-find-min h` → `{found-bool, value}`; `h-delete-min lte h` → merge of
  children (empty → empty). Tests: min tracks insertions, delete-min drains in
  sorted order, persistence (old heap usable after insert).
- [ ] **B4. Heapsort** — `heap-sort lte lst` in `sorting.rkt` (requires
  `heaps.rkt`): fold the list into a heap, drain with `h-delete-min`. Tests:
  output matches `merge-sort` output on the same inputs, across two numeric
  representations.

### Phase C — graphs and traversals (`graphs.rkt`)

Representation: a graph is a lambda list of entries `{vertex, adjacency-list}`.
All operations take the vertex-equality predicate `eq?v` first. Internal
helpers in `graphs.rkt`: `member-by eq?v x lst` → bool, and
`g-neighbors eq?v v g` → adjacency list (absent vertex → `nil`). The visited
set is an explicit lambda list threaded through every recursion — no host
state anywhere. Test fixtures (`tests/graphs-test.rkt`): a line, a directed
cycle, a DAG (diamond), a disconnected pair, and a small symmetric graph, over
Church-natural vertices.

- [ ] **C1. Representation + helpers** — `member-by`, `g-neighbors`,
  `g-vertices g` (list of firsts), constructors for the test fixtures. Tests on
  membership and neighbor lookup.
- [ ] **C2. Depth-first search + reachability** — `dfs eq?v g start` → visit
  order list (recursive: visit vertex, fold over neighbors threading visited);
  `reachable eq?v g from to` → bool via `member-by` on the DFS result.
- [ ] **C3. Breadth-first search + unweighted distances** — `bfs eq?v g start`
  → visit order using the A3 queue; `bfs-distances eq?v g start` → list of
  `{vertex, church-distance}` pairs, by enqueueing `{vertex, depth}` pairs.
- [ ] **C4. Path finding** — `find-path eq?v g from to` →
  `{found-bool, path-list from..to}` via DFS carrying the path-so-far;
  `from = to` → `{true, [from]}`; unreachable → false pair.
- [ ] **C5. Cycle detection** — `has-cycle eq?v g` for directed graphs: DFS
  from every vertex with an explicit on-current-path list (gray set) alongside
  the finished list; edge into the gray set → cycle. Tests: directed cycle →
  true; DAG and line → false.
- [ ] **C6. Connected components** — `components eq?v g` → list of vertex
  lists. Documented contract: expects a symmetric (undirected-style) adjacency
  representation; fold over `g-vertices`, running a traversal from each
  not-yet-assigned vertex. Tests on the disconnected fixture.
- [ ] **C7. Topological sort** — `topo-sort eq?v g` → vertex list via DFS
  finish-order, reversed (`rev`). Documented contract: meaningful on DAGs
  (cyclic input still terminates via the visited set but the order is not a
  topological order — say so in the comment). Test: diamond DAG order respects
  all edges (check with a helper that verifies every edge points forward).

### Phase D — more binary-number algorithms (`binary-algorithms.rkt`)

New module requiring `binary-lists.rkt` (and `int-binary-lists.rkt` from D6 on);
the base libraries are NOT modified. All results normalized via
`rem-head-zeroes` where leading zeroes can arise. Tests in
`tests/binary-algorithms-test.rkt`, values small.

- [ ] **D1. Shifts, width-NOT, bit length, popcount** —
  `bin-shl n bin` (delegate to existing `bin-mult-pow-2`; zero stays `[0]`),
  `bin-shr n bin` (drop `n` low digits via repeated "all but last" or
  `_take (sub (len bin) n)`; shift past length → `[0]`),
  `bin-not-w width bin` (pad/truncate to `width` digits, flip each with `isOne`
  selection, normalize — document that NOT is width-relative by definition),
  `bin-len bin` (= `len`, as a named alias with its own contract),
  `bin-popcount bin` → Church nat (fold digits, add one per one-digit; `[0]` →
  zero). Round-trip and edge tests.
- [ ] **D2. Bitwise AND / OR / XOR** — pad the shorter operand with
  `prepend-zeroes` to equal length, zip digit-wise via a shared Y helper
  parameterized by the digit operation (`_and`/`_or`/`xor` on the zero/one
  digit booleans — digits ARE Church booleans here, `zero` is `false`),
  normalize with `rem-head-zeroes`. Tests against hand-computed small cases,
  including unequal lengths.
- [ ] **D3. Conversions, entirely as lambda terms** — `bin-to-church bin`:
  fold over digits, `acc' = add (add acc acc) digit-as-nat` (digit `one` is
  Church one via `_cond`); `church-to-bin n`: apply the numeral `n` to
  `bin-succ` starting from `bin-zero` — the numeral itself drives the
  iteration. Tests: round-trip both directions for 0..10 and a couple of
  two-digit values, rendered with `n-read`/`bin-read`.
- [ ] **D4. Integer square root** — `bin-isqrt x`: binary search on
  `lo..hi = [0]..x` via Y, invariant `lo² ≤ x < (hi+1)²`, terminating when the
  range collapses (mirror the terminating-search style already used in
  `algorithms.rkt` binarySearch). `bin-isqrt [0]` → `[0]`. Tests: perfect
  squares and non-squares (0,1,2,3,4,8,9,15,16,100).
- [ ] **D5. Modular exponentiation** — `bin-modexp base ex m`: square-and-
  multiply folding over the digits of `ex` most-significant-first (`acc' =
  mod (acc² · base^digit) m` per digit, via `bin-mult`/`bin-mod`). Contract:
  modulus zero inherits `bin-mod`'s documented totalization. Tests against
  hand-computed values, plus agreement with `bin-mod (bin-exp b e) m` on tiny
  inputs.
- [ ] **D6. Extended Euclid + modular inverse** — over signed binary integers:
  `bin-ext-euclid a b` → `{g, {x, y}}` with `g = ax + by` (recursive:
  `b = 0 → {a, {1, 0}}`, else recurse on `(b, a mod b)` — needs signed
  mult/sub `multZ-bin`/`subZ-bin` and a nonneg `mod` built from
  `bin-div-n-mod` on magnitudes); `bin-mod-inverse a m` → `{found-bool, value}`
  (`{true, x mod m}` when `g = 1`, else false pair). Tests: Bézout identity
  checked by evaluating `ax + by` and comparing to `g`; inverse of 3 mod 7 = 5;
  no inverse of 2 mod 4.
- [ ] **D7. Primality** — `bin-prime? n`: trial division by 2 then odd
  divisors up to `bin-isqrt n` (Y over the candidate divisor); values below 2
  → false. Then `bin-prime-mr? n bases`: Miller–Rabin using D5's `bin-modexp`,
  taking the witness list explicitly (document: bases `[2, 3]` are
  deterministic for the test-sized inputs used). Tests: primes and composites
  through a few dozen, both predicates agreeing.
- [ ] **D8. Fibonacci by fast doubling** — `bin-fib n` (binary-nat in and
  out): recurse on `bin-shr 1 n` returning the pair `{F(k), F(k+1)}`, combine
  with `F(2k) = F(k)·(2F(k+1) − F(k))` and `F(2k+1) = F(k)² + F(k+1)²`
  (subtraction is safe: nonnegative by construction), select by `bin-is-odd`.
  Tests: F(0)..F(12) against known values, one larger spot check.

### Phase E — wrap-up (final iteration)

- [ ] **E1. Docs + handoff + shutdown** — add the new modules to the README
  map and `ARCHITECTURE.md` (one paragraph each, matching existing tone);
  update this file's status section; write
  `HANDOFF-overnight-2026-08-12.md`: what completed, what (if anything) is
  BLOCKED and why, final test count, branch state. Run the full suite one last
  time, commit, push, verify `git status` clean and branch pushed, then STOP
  the loop (no further wakeups) so the session sits idle for Kyle to close.

## Deferred / not selected (do not start without Kyle)

- **Monads** (Option/Result bind, List/Reader/State/Writer) — cut from the
  overnight scope by Kyle 2026-08-11 to conserve tokens.
- **Gaussian rationals** — cut from the overnight scope by Kyle 2026-08-11.
- **Reals arc** (dyadic rationals → intervals → computable reals) — deliberately
  set aside by Kyle earlier; still do not begin without asking.
- **Strict-layer follow-ons**: `HEAD-OPT`; further Result-returning safe
  division families (strict natural/integer division keep their approved raw
  partiality; safe forms would be new APIs).
- **Former Phase 3 menu** (strings → parser combinators; deeper strict type
  layer; lambda terms as data) — superseded by the overnight plan; the menu
  lives in `~/all-the-lambdas-notes.md` and in git history of this file.
- `transform-string` remains dead code tied to the open list-presentation
  decision; delete or revive only when that format is decided.
- Finishing the coercive type system remains out of scope.

## Standing constraints

- **The object language remains pure untyped lambda calculus.** Host code may
  load, expand, observe, test, and impose external deadlines; it may not
  determine an object-language result.
- **Division policy is intentionally layer-specific (accepted 2026-08-11).**
  Raw Church-natural/integer and strict natural/integer division are partial;
  coercive natural/integer division returns `err:div by 0`; binary division
  returns quotient zero and the dividend as remainder; raw rationals treat a
  zero numerator or denominator as rational zero; strict rational division
  returns a `Result` error and coercive rational division returns a typed
  error. New binary algorithms (Phase D) inherit the binary layer's documented
  totalizations rather than inventing new policies.

## Completed work index

- Interactive learning path HTML remake — complete 2026-08-11 → archived in `ROADMAP-ARCHIVE.md`.
- Pedagogical spine and learner explanations — complete 2026-08-11 → archived in `ROADMAP-ARCHIVE.md`.
- Targeted remaining verified findings — complete 2026-08-11 → archived in `ROADMAP-ARCHIVE.md`.
- Terminating Option-returning binary search — complete 2026-08-11 → archived in `ROADMAP-ARCHIVE.md`.
- Rational division semantics — complete 2026-08-10 → archived in `ROADMAP-ARCHIVE.md`.
- Integrity Phases 1–5 and later authorized findings — complete 2026-08-11 → archived in `ROADMAP-ARCHIVE.md`.
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
  it in place rather than replacing it.
- **Test helpers are already shared** — all four suites require the single
  `tests/helpers/test-helpers.rkt`. No deduplication needed.
- **Comparators/equality as arguments (2026-08-11).** Trees, heaps, sorts, and
  graphs are parameterized by their ordering/equality functions so one pure
  implementation serves every numeric representation. This is the overnight
  plan's central design rule.
