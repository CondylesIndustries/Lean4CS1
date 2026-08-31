<div style="text-align: center; margin: 0.6rem 0 1.8rem;">
  <div style="font-size: 2.8em; font-weight: 700; line-height: 1.05;">Software Logic</div>
  <div style="font-size: 1.22em; font-weight: 500; line-height: 1.12; margin-top: 0.38em;">Intellectual Control for Accountability</div>
  <div style="font-size: 1.22em; font-weight: 500; line-height: 1.12; margin-top: 0.04em;">In the Era of AI and Autoformalization</div>
  <div style="font-size: 1.05em; font-weight: 500; line-height: 1.2; margin-top: 0.9em;">Kevin Sullivan</div>
  <div style="font-size: 0.95em; font-weight: 400; line-height: 1.2; margin-top: 0.15em;">CS6501-010 Fall 2026</div>
</div>

## About This Course

This course examines human intellectual control over software as a central technical challenge and social imperative—today, and even more so in the emerging era of generative AI and verified abstract mathematics. Its central claim is that durable intellectual control depends on understanding the generalized mathematics of the domain, stating that theory precisely, and certifying separate computable implementations against it. The resulting assurance rests on two distinct objects of trust: the adequacy of the formal theory itself and the validity of the proof certificates that connect implementation to theory. Lean 4 provides a practical language in which theories, implementations, and proofs can coexist, but it does not eliminate either obligation: one must understand the mathematics being formalized, and one must understand the trusted proof-checking base on which machine-checked assurance depends.

## Schedule (Fall 2026 · Mondays & Wednesdays)

Two tracks run in parallel and are scheduled independently. **Paper readings** (Line I) keep
their weekly cadence — one theme per paper-week, spanning that week's two sessions, with full
bibliographic references and PDF links given in each week's paper cell. The **FP-book track** is
compressed to **two chapters per class session**, run in order, beginning **Wed Sep 2**; once the
book is complete (Mon Sep 28) the class proceeds to **Part 2** (Lean programming and proof
construction). Class does not meet Mon Oct 5 (fall reading days) or Wed Nov 25 (Thanksgiving);
Labor Day (Mon Sep 7) meets. 28 sessions total.

| # | Date | Paper readings (Line I — by week) | FP-book track (2 ch/session, starts Sep 2) → Part 2 |
|---:|---|---|---|
| | **▸ Week 1** · course intro & Lean setup | *Aug 26 + Aug 31* | |
| 1 | Wed Aug 26 | **Wk 1: Software as Intellectual Instrument.**<br>— Brooks, [“The Computer ‘Scientist’ as Toolsmith”](https://andymatuschak.org/files/papers/Brooks%20-%201977%20-%20The%20computer%20scientist%20as%20toolsmith.pdf), *Information Processing 77*, 1977, pp. 625–634.<br>— Hutchins, Hollan & Norman, [“Direct Manipulation Interfaces”](https://hci.ucsd.edu/hollan/direct-manip.pdf), *Human–Computer Interaction* 1(4), 1985, pp. 311–338. | *course intro · Lean/Mathlib setup — no chapter due* |
| 2 | Mon Aug 31 | ↳ *(wk 1 — cont.)* | *course intro · Lean/Mathlib setup — no chapter due* |
| | **▸ Week 2** · FP book · 2 ch/session | *Sep 02 + Sep 07* | |
| 3 | Wed Sep 02 | **Wk 2: Program Understanding.**<br>— Simon, [“The Architecture of Complexity”](https://www2.econ.iastate.edu/tesfatsi/ArchitectureOfComplexity.HSimon1962.pdf), *Proc. Am. Philosophical Society* 106(6), 1962, pp. 467–482.<br>— Letovsky, “Cognitive Processes in Program Comprehension,” *J. Systems and Software* 7(4), 1987, pp. 325–339, [doi:10.1016/0164-1212(87)90032-X](https://doi.org/10.1016/0164-1212%2887%2990032-X) — subscription; UVA Library.<br>— Brooks, [“No Silver Bullet”](https://www.cs.unc.edu/techreports/86-020.pdf), UNC TR86-020, 1986 (also *Computer* 20(4), 1987, pp. 10–19). | **Wk00** Algebraic Types — Computation & Logic · **Wk01** Expressions, Types, Values |
| 4 | Mon Sep 07 · Labor Day (meets) | ↳ *(wk 2 — cont.)* | **Wk02** Functions & Specifications · **Wk03** Recursion & Termination |
| | **▸ Week 3** · FP book · 2 ch/session | *Sep 09 + Sep 14* | |
| 5 | Wed Sep 09 | **Wk 3: Conceptual Design.**<br>— Jackson, [“Towards a Theory of Conceptual Design for Software”](https://groups.csail.mit.edu/sdg/pubs/2015/concept-essay.pdf), *Onward! 2015*, pp. 282–296.<br>— Perez De Rosso & Jackson, [“Purposes, Concepts, Misfits, and a Redesign of Git”](https://groups.csail.mit.edu/sdg/pubs/2016/gitless-oopsla16.pdf), *OOPSLA 2016*, pp. 292–310. | **Wk04** Algebraic Datatypes · **Wk05** Lists |
| 6 | Mon Sep 14 | ↳ *(wk 3 — cont.)* | **Wk06** Trees & BST Invariants · **Wk07** Polymorphism & Decidability |
| | **▸ Week 4** · FP book · 2 ch/session | *Sep 16 + Sep 21* | |
| 7 | Wed Sep 16 | **Wk 4: Modularity & Software Architecture.**<br>— Parnas, [“On the Criteria To Be Used in Decomposing Systems into Modules”](https://dl.acm.org/doi/pdf/10.1145/361598.361623), *CACM* 15(12), 1972, pp. 1053–1058.<br>— Perry & Wolf, [“Foundations for the Study of Software Architecture”](https://users.ece.utexas.edu/~perry/work/papers/swa-sen.pdf), *ACM SIGSOFT SEN* 17(4), 1992, pp. 40–52.<br>— Garlan & Shaw, [“An Introduction to Software Architecture”](https://www.cs.cmu.edu/afs/cs/project/able/ftp/intro_softarch/intro_softarch.pdf), 1993, pp. 1–39. | **Wk08** Higher-Order Functions · **Free** Free Theorems (interlude) |
| 8 | Mon Sep 21 | ↳ *(wk 4 — cont.)* | **Wk09** Specifications in Practice · **Wk10** Sets & Relations |
| | **▸ Week 5** · FP book · 2 ch/session — **book completes** | *Sep 23 + Sep 28* | |
| 9 | Wed Sep 23 | **Wk 5: Specification & the Architecture of Claims.**<br>— Hoare, [“An Axiomatic Basis for Computer Programming”](https://www.cs.cmu.edu/~crary/819-f09/Hoare69.pdf), *CACM* 12(10), 1969, pp. 576–580, 583.<br>— Dijkstra, [“Guarded Commands, Nondeterminacy and Formal Derivation of Programs”](https://www.cs.utexas.edu/~EWD/ewd04xx/EWD472.PDF), *CACM* 18(8), 1975, pp. 453–457. | **Wk11** Abstract Types · **Wk12** Type Classes & Decidability |
| 10 | Mon Sep 28 | ↳ *(wk 5 — cont.)* | **Wk13** Streams · **Wk14** Curry–Howard ← **FP book complete** |
| | **▸ Week 6** · Part 2 · Lean prog. & proof — *tentative* — **begins** | *Sep 30 + Oct 07* · (reading-day break between sessions) | |
| 11 | Wed Sep 30 | **Wk 6: Abstraction, Types & Intellectual Compression.**<br>— Liskov & Zilles, [“Programming with Abstract Data Types”](https://gleitzman.com/media/docs/adt-liskov.pdf), 1974, pp. 50–59.<br>— Reynolds, [“Types, Abstraction and Parametric Polymorphism”](https://home.ttic.edu/~dreyer/course/papers/reynolds.pdf), *Information Processing 83*, pp. 513–523.<br>— Wadler, [“Propositions as Types”](https://www.pure.ed.ac.uk/ws/portalfiles/portal/20001186/propositions_as_types.pdf), *CACM* 58(12), 2015, pp. 75–84. | ⟶ **PART 2 BEGINS — *all Part 2 topics TENTATIVE*** ‡ · **Relations** — abstract theory `A→B→Prop`: id, converse, composition, orders |
| 12 | Wed Oct 07 · post-reading-day | ↳ *(wk 6 — cont.)* | ‡ Relations — computable: finite relations as pair-lists; decidable membership |
| | **▸ Week 7** · Part 2 · Lean prog. & proof — *tentative* | *Oct 12 + Oct 14* | |
| 13 | Mon Oct 12 | **Wk 7: Semantics: Making Meaning Explicit.**<br>— Plotkin, [“A Structural Approach to Operational Semantics”](https://homepages.inf.ed.ac.uk/gdp/publications/sos_jlap.pdf), *JLAP* 60–61, 2004, pp. 17–139.<br>— Goguen & Burstall, [“Institutions: Abstract Model Theory for Specification and Programming”](https://dl.acm.org/doi/pdf/10.1145/147508.147524), *JACM* 39(1), 1992, pp. 95–146. | ‡ Relations — **bridge**: executable ops agree extensionally with abstract theory |
| 14 | Wed Oct 14 | ↳ *(wk 7 — cont.)* | ‡ **Transition systems** — transition relations; reflexive/transitive closure |
| | **▸ Week 8** · Part 2 · Lean prog. & proof — *tentative* | *Oct 19 + Oct 21* | |
| 15 | Mon Oct 19 | **Wk 8: Formal Proof as an Intellectual Tool.**<br>— Leroy, [“Formal Verification of a Realistic Compiler”](https://xavierleroy.org/publi/compcert-CACM.pdf), *CACM* 52(7), 2009, pp. 107–115.<br>— Trusted-base limitation: Lean 4.32.2 kernel soundness fix — [release notes](https://lean-lang.org/doc/reference/latest/releases/v4.32.2/), [issue #14576](https://github.com/leanprover/lean4/issues/14576). | ‡ Transition systems — computable: finite-state graph + reachability search |
| 16 | Wed Oct 21 | ↳ *(wk 8 — cont.)* | ‡ Transition systems — **bridge**: computed reachability iff abstract; invariant soundness |
| | **▸ Week 9** · Part 2 · Lean prog. & proof — *tentative* | *Oct 26 + Oct 28* | |
| 17 | Mon Oct 26 | **Wk 9: Construction by Meaning-Preserving Transformation.**<br>— Meertens, [“Algorithmics—Towards Programming as a Mathematical Activity”](https://www.kestrel.edu/people/meertens/publications/papers/Algorithmics.pdf), 1986, pp. 289–334.<br>— Backus, [“Can Programming Be Liberated from the von Neumann Style?”](https://dl.acm.org/doi/pdf/10.1145/359576.359579), *CACM* 21(8), 1978, pp. 613–641. | ‡ **Relational algebra** — extensional operators + laws |
| 18 | Wed Oct 28 | ↳ *(wk 9 — cont.)* | ‡ Relational algebra — computable: finite tables; select/project/join/union/diff/rename |
| | **▸ Week 10** · Part 2 · Lean prog. & proof — *tentative* | *Nov 02 + Nov 04* | |
| 19 | Mon Nov 02 | **Wk 10: Behavior, State, Time & Invariants.**<br>— Clarke, Emerson & Sistla, [“Automatic Verification of Finite-State Concurrent Systems…”](https://dl.acm.org/doi/pdf/10.1145/5397.5399), *TOPLAS* 8(2), 1986, pp. 244–263.<br>— Lamport, [“Time, Clocks, and the Ordering of Events in a Distributed System”](https://www.cs.cornell.edu/courses/cs614/2002sp/Clocks.Lamport.1.pdf), *CACM* 21(7), 1978, pp. 558–565. | ‡ Relational algebra — **bridge**: each operator denotes its abstract counterpart |
| 20 | Wed Nov 04 | ↳ *(wk 10 — cont.)* | ‡ **Inductive relational algebra** — query syntax + compositional denotation |
| | **▸ Week 11** · Part 2 · Lean prog. & proof — *tentative* | *Nov 09 + Nov 11* | |
| 21 | Mon Nov 09 | **Wk 11: Representation, Refinement & Substitutability.**<br>— Hoare, “Proof of Correctness of Data Representations,” *Acta Informatica* 1(4), 1972, pp. 271–281, [doi:10.1007/BF00289507](https://doi.org/10.1007/BF00289507) — subscription; UVA Library.<br>— Liskov & Wing, [“A Behavioral Notion of Subtyping”](https://www.cs.cmu.edu/~wing/publications/LiskovWing94.pdf), *TOPLAS* 16(6), 1994, pp. 1811–1841. | ‡ Inductive rel. algebra — computable: evaluator/compiler over finite relations |
| 22 | Wed Nov 11 | ↳ *(wk 11 — cont.)* | ‡ Inductive rel. algebra — **bridge**: evaluation preserves denotation (structural) |
| | **▸ Week 12** · Part 2 · Lean prog. & proof — *tentative* | *Nov 16 + Nov 18* | |
| 23 | Mon Nov 16 | **Wk 12: Evidence, Autoformalization & the Economics of Proof.**<br>— Claessen & Hughes, [“QuickCheck: A Lightweight Tool for Random Testing of Haskell Programs”](http://www.eecs.northwestern.edu/~robby/courses/395-495-2009-fall/quick.pdf), *ICFP 2000*, pp. 268–279.<br>— Wu et al., [“Autoformalization with Large Language Models”](https://papers.nips.cc/paper_files/paper/2022/file/d0c6bc641a56bebee9d985b937307367-Paper-Conference.pdf), *NeurIPS 2022*. | ‡ **Categories** — objects, morphisms, identity, composition, functoriality |
| 24 | Wed Nov 18 | ↳ *(wk 12 — cont.)* | ‡ Signatures, sentences, models, interpretations, satisfaction |
| | **▸ Week 13** · Part 2 · Lean prog. & proof — *tentative* | *Nov 23 + Nov 30* · (Thanksgiving break between sessions) | |
| 25 | Mon Nov 23 | **Wk 13: Trust & Machine-Generated Verified Construction.**<br>— Necula, [“Proof-Carrying Code”](https://dl.acm.org/doi/pdf/10.1145/263699.263712), *POPL 1997*, pp. 106–119.<br>— Thompson, [“Reflections on Trusting Trust”](https://web.mit.edu/6.857/OldStuff/Fall03/ref/Thompson-ReflectionsOnTrustingTrust.pdf), *CACM* 27(8), 1984, pp. 761–763.<br>— Saltzer, Reed & Clark, [“End-to-End Arguments in System Design”](https://www.cs.cmu.edu/afs/cs.cmu.edu/academic/class/15712-s12/www/papers/saltzer84.pdf), *TOCS* 2(4), 1984, pp. 277–288.<br>— Aggarwal, Parno & Welleck, [“AlphaVerus: Bootstrapping Formally Verified Code Generation…”](https://proceedings.mlr.press/v267/aggarwal25a.html), *ICML 2025*, pp. 587–615. | ‡ Concrete categories/finite models; executable satisfaction; **bridge** (functor laws; exec ⟺ abstract) |
| 26 | Mon Nov 30 · post-Thanksgiving | ↳ *(wk 13 — cont.)* | ‡ **Institutions** — signature category; sentence & model functors; indexed satisfaction |
| | **▸ Week 14** · Part 2 · Lean prog. & proof — *tentative* | *Dec 02 + Dec 07* | |
| 27 | Wed Dec 02 | **Wk 14: Understanding Change, Evolution & Accountability.**<br>— Sillito, Murphy & De Volder, [“Questions Programmers Ask During Software Evolution Tasks”](https://citeseerx.ist.psu.edu/document?doi=3dda5d9a5e4eb27760e8a4a381a1057ce0ba7d65&repid=rep1&type=pdf), *FSE 2006*, pp. 23–34.<br>— Lehman, [“Programs, Life Cycles, and Laws of Software Evolution”](https://users.ece.utexas.edu/~perry/education/SE-Intro/lehman.pdf), *Proc. IEEE* 68(9), 1980, pp. 1060–1076.<br>— Parnas, [“Software Aging”](https://plg.uwaterloo.ca/~migod/846/papers/parnas-SwAging.pdf), *ICSE 1994*, pp. 279–287. | ‡ Institutions — package semester's machinery as concrete executable institution; **satisfaction condition** |
| 28 | Mon Dec 07 · last class | ↳ *(wk 14 — cont.)* | ‡ **Endpoint** — prove the satisfaction condition; project synthesis & recoverability |

‡ **Part 2 topics (sessions 11–28) are tentative** — subject to change; the Lean materials are
not yet authored, and the per-topic pacing (≈3 sessions each) is provisional. Part 2 keeps the
discipline **general theory → separate computable realization → certified bridge**.

---

## Assessment

Students are assessed on five competencies:

1. **Specification writing**: given a function and English description,
   write the correct Lean type expressing its specification.
2. **Specification reading**: given a Lean proposition, state in English
   what it asserts; give a satisfying and falsifying example.
3. **Type inhabitation**: write a term the compiler accepts at a given type.
4. **Counterexample finding**: given a function and an incorrect
   specification, find a concrete input that witnesses the mismatch.
5. **Decidability identification**: given a proposition, state whether
   `decide` closes it, which other term if not, and why.

---

## Course Materials in This Book

The FP-book track above draws on the [CS1 Full Course](../FPCourse/Unit1/Week00_AlgebraicTypes.md)
chapters listed here. Weeks 9-14 of Part II build new theory on top of them rather than
introducing further chapters.

**Unit 1 — Expressions, Functions, Recursion**

- [Week 0: Algebraic Types — Computation and Logic](../FPCourse/Unit1/Week00_AlgebraicTypes.md)
- [Week 1: Expressions, Types, and Values](../FPCourse/Unit1/Week01_ExpressionsTypesValues.md)
- [Week 2: Functions and Specifications](../FPCourse/Unit1/Week02_FunctionsSpecifications.md)
- [Week 3: Recursion and Termination](../FPCourse/Unit1/Week03_RecursionTermination.md)

**Unit 2 — Algebraic Datatypes, Lists, Trees, Decidability**

- [Week 4: Algebraic Datatypes](../FPCourse/Unit2/Week04_AlgebraicDatatypes.md)
- [Week 5: Lists](../FPCourse/Unit2/Week05_Lists.md)
- [Week 6: Trees and BST Invariants](../FPCourse/Unit2/Week06_Trees.md)
- [Week 7: Polymorphism and Decidability](../FPCourse/Unit2/Week07_PolymorphismDecidability.md)

**Unit 3 — Higher-Order Functions, Specifications**

- [Week 8: Higher-Order Functions](../FPCourse/Unit3/Week08_HigherOrderFunctions.md)
- [Week 9: Specifications in Practice](../FPCourse/Unit3/Week09_Specifications.md)

**Unit 4 — Sets and Relations**

- [Week 10: Sets and Relations](../FPCourse/Unit4/Week10_SetsRelations.md)

**Unit 5 — Abstract Types, Type Classes**

- [Week 11: Abstract Types](../FPCourse/Unit5/Week11_AbstractTypes.md)
- [Week 12: Type Classes and Decidability](../FPCourse/Unit5/Week12_TypeClassesDecidable.md)

**Unit 6 — Streams and Curry-Howard**

- [Week 13: Streams](../FPCourse/Unit6/Week13_Streams.md)
- [Week 14: The Curry-Howard Correspondence](../FPCourse/Unit6/Week14_CurryHoward.md)

---

## Notes

- **Central epistemic structure:** the generalized mathematics of the domain comes first. It provides the theory whose concepts, laws, invariants, and theorems constitute the principal medium of intellectual control. A separate computable implementation is then constructed, and a proof bridge certifies that the implementation realizes the theory. The resulting assurance is therefore conditional on both **trust in the theory statement** and **trust in the proof certificates and checker**.
- **There is no absolute machine-checked certainty.** Lean 4.32.2, released July 28, 2026, fixed a kernel soundness bug involving nested inductive types with phantom parameters; a malicious metaprogram could cause the kernel to accept a proof of `False` or any theorem. See the [official Lean 4.32.2 release notes](https://lean-lang.org/doc/reference/latest/releases/v4.32.2/), [Lean issue #14576](https://github.com/leanprover/lean4/issues/14576), and the [oss-security report](https://www.openwall.com/lists/oss-security/2026/08/02/1). The lesson is not that formal proof is weak, but that its assurance is explicitly conditional on a trusted computing base whose own soundness must be engineered, tested, diversified, and sometimes independently checked.
- **Institutions are the intended and designed-for endpoint of Part II.** The mathematical sequence is backward-designed from that goal: students must climb from inductive structures and sets through relations, algebraic laws, categories, signatures, models, satisfaction, and functorial translation to a theory in which meaning preservation across changes of notation can itself be stated abstractly.
- **Subsetting rule for the companion foundations:** select and sequence material to maximize students' ability to ascend from concrete computation to increasingly general mathematics and then reconnect those abstractions to executable realizations by proof. The criterion is contribution to sustained or recoverable intellectual control, including the mathematical prerequisites needed to reach Institutions; there is no shortcut around understanding the domain mathematics and the abstract mathematics beneath it.
- **Lean begins in Week 1 and continues through Week 14.** Weeks 1–8 establish the ability to express intent, specifications, invariants, abstractions, mathematical models, implementations, and checked evidence. Part II changes the mode of work rather than introducing Lean.
- **The companion foundation materials remain unchanged.** This syllabus links to selected chapters and adds assignments whose products are intended to remain useful as recoverable intellectual-control artifacts.
- **Part II discipline:** **general theory → separate computable realization → certified bridge**.
- **Traceability for assurance:** each major assurance should remain recoverable through **domain purpose → domain theory → generalized mathematics → formal theory → computable implementation → certified bridge → assumptions/trusted base → evidence**.
- **TODO — Construct compelling mathematical case studies:** develop a small set of deep examples in which **students experience abstract mathematics itself as the principal medium of intellectual control**. Each case should begin with a realistic domain whose behavior is difficult to reason about directly, expose the domain mathematics and the deeper abstract mathematics that make the situation intelligible, formalize that theory in Lean, construct a separate executable realization, and prove the bridge that licenses reasoning about the implementation through the mathematics.

