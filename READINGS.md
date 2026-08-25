# Course readings — provenance record

CS6501-010 Software Logic, Fall 2026.

The [course schedule](src/SoftwareLogic/index.md) **links** to external copies of its
readings; this repository does not redistribute them. The papers are
publisher-copyrighted, and a local library of downloaded PDFs is kept in `Readings/`,
which is gitignored and never committed.

This file is the tracked record of where each local copy came from, so the sourcing work
survives a fresh clone even though the PDFs themselves do not. Local filenames follow
`Week##_Author####_ShortTitle.pdf`.

For the history of schedule *link* repairs — the CiteSeerX shutdown, the Perry & Wolf,
AlphaVerus and Brooks fixes, and the `dl.acm.org` false positives — see **Course reading
links** in [README.md](README.md).

## Where each local copy came from

Downloaded 2026-08-25. Where the publisher link in the schedule was paywalled or
bot-blocked, an open-access author or institutional copy was used instead.

| Week | Paper | File | Source used |
|---:|---|---|---|
| 1 | Brooks, *The Computer "Scientist" as Toolsmith* (1977) | `Week01_Brooks1977_Toolsmith.pdf` | as linked |
| 1 | Hutchins, Hollan & Norman, *Direct Manipulation Interfaces* (1985) | `Week01_HutchinsHollanNorman1985_DirectManipulation.pdf` | as linked |
| 2 | Simon, *The Architecture of Complexity* (1962) | `Week02_Simon1962_ArchitectureOfComplexity.pdf` | as linked |
| 2 | Letovsky, *Cognitive Processes in Program Comprehension* (1987) | **MISSING** | No open-access copy — needs UVA library access |
| 2 | Brooks, *No Silver Bullet* (1987) | `Week02_Brooks1987_NoSilverBullet.pdf` | UNC TR 86-020, `cs.unc.edu/techreports/86-020.pdf` — verified, see below. Schedule links this directly. |
| 3 | Jackson, *Towards a Theory of Conceptual Design for Software* (2015) | `Week03_Jackson2015_ConceptualDesign.pdf` | as linked |
| 3 | Perez De Rosso & Jackson, *Purposes, Concepts, Misfits, and a Redesign of Git* (2016) | `Week03_PerezDeRossoJackson2016_GitRedesign.pdf` | as linked |
| 4 | Parnas, *On the Criteria To Be Used in Decomposing Systems into Modules* (1972) | `Week04_Parnas1972_DecomposingModules.pdf` | TU Eindhoven mirror (ACM DL bot-blocked) |
| 4 | Perry & Wolf, *Foundations for the Study of Software Architecture* (1992) | `Week04_PerryWolf1992_SoftwareArchitecture.pdf` | `users.ece.utexas.edu` — schedule link since repaired to match |
| 4 | Garlan & Shaw, *An Introduction to Software Architecture* (1993) | `Week04_GarlanShaw1993_IntroSoftwareArchitecture.pdf` | as linked |
| 5 | Hoare, *An Axiomatic Basis for Computer Programming* (1969) | `Week05_Hoare1969_AxiomaticBasis.pdf` | as linked |
| 5 | Dijkstra, *Guarded Commands, Nondeterminacy and Formal Derivation of Programs* (1975) | `Week05_Dijkstra1975_GuardedCommands.pdf` | as linked (EWD472) |
| 6 | Liskov & Zilles, *Programming with Abstract Data Types* (1974) | `Week06_LiskovZilles1974_AbstractDataTypes.pdf` | as linked |
| 6 | Reynolds, *Types, Abstraction and Parametric Polymorphism* (1983) | `Week06_Reynolds1983_TypesAbstractionPolymorphism.pdf` | as linked |
| 6 | Wadler, *Propositions as Types* (2015) | `Week06_Wadler2015_PropositionsAsTypes.pdf` | as linked |
| 7 | Plotkin, *A Structural Approach to Operational Semantics* (2004) | `Week07_Plotkin2004_StructuralOperationalSemantics.pdf` | as linked |
| 7 | Goguen & Burstall, *Institutions* (1992) | `Week07_GoguenBurstall1992_Institutions.pdf` | UIUC CS522 mirror (ACM DL bot-blocked) |
| 8 | Leroy, *Formal Verification of a Realistic Compiler* (2009) | `Week08_Leroy2009_CompCert.pdf` | as linked |
| 9 | Meertens, *Algorithmics* (1986) | `Week09_Meertens1986_Algorithmics.pdf` | as linked |
| 9 | Backus, *Can Programming Be Liberated from the von Neumann Style?* (1978) | `Week09_Backus1978_VonNeumannStyle.pdf` | MSU CSE452 mirror (ACM DL bot-blocked) |
| 10 | Clarke, Emerson & Sistla, *Automatic Verification of Finite-State Concurrent Systems* (1986) | `Week10_ClarkeEmersonSistla1986_TemporalLogicVerification.pdf` | Clarke's own CMU page (paper is OA at ACM; only Cloudflare blocked the scripted fetch) |
| 10 | Lamport, *Time, Clocks, and the Ordering of Events* (1978) | `Week10_Lamport1978_TimeClocks.pdf` | as linked |
| 11 | Hoare, *Proof of Correctness of Data Representations* (1972) | **MISSING** | No open-access copy exists — needs UVA library access |
| 11 | Liskov & Wing, *A Behavioral Notion of Subtyping* (1994) | `Week11_LiskovWing1994_BehavioralSubtyping.pdf` | as linked |
| 12 | Claessen & Hughes, *QuickCheck* (2000) | `Week12_ClaessenHughes2000_QuickCheck.pdf` | as linked |
| 12 | Wu et al., *Autoformalization with Large Language Models* (2022) | `Week12_Wu2022_Autoformalization.pdf` | as linked |
| 13 | Necula, *Proof-Carrying Code* (1997) | `Week13_Necula1997_ProofCarryingCode.pdf` | UW mirror (ACM DL bot-blocked) |
| 13 | Thompson, *Reflections on Trusting Trust* (1984) | `Week13_Thompson1984_TrustingTrust.pdf` | as linked |
| 13 | Saltzer, Reed & Clark, *End-to-End Arguments in System Design* (1984) | `Week13_SaltzerReedClark1984_EndToEnd.pdf` | as linked |
| 13 | Aggarwal, Parno & Welleck, *AlphaVerus* (2025) | `Week13_Aggarwal2025_AlphaVerus.pdf` | arXiv 2412.06176; schedule links the PMLR version of record |
| 14 | Sillito, Murphy & De Volder, *Questions Programmers Ask* (2006) | `Week14_Sillito2006_QuestionsProgrammersAsk.pdf` | UBC mirror — verified, see below |
| 14 | Lehman, *Programs, Life Cycles, and Laws of Software Evolution* (1980) | `Week14_Lehman1980_LawsOfSoftwareEvolution.pdf` | as linked |
| 14 | Parnas, *Software Aging* (1994) | `Week14_Parnas1994_SoftwareAging.pdf` | as linked |

31 of the 33 assigned papers are held locally.

## Verification record

Two local copies were checked byte-for-byte against the URL they were attributed to,
confirming provenance rather than relying on the download note.

| File | Bytes | SHA-256 | MD5 | Verified against |
|---|---:|---|---|---|
| `Week02_Brooks1987_NoSilverBullet.pdf` | 807,175 | `a4a11dcb6ff7dcdfcc680e27760126d86c568cbb99a53a2bf58dc9041fbb190e` | `5baa8b3a4e90983830fa2d6ed57528fa` | `cs.unc.edu/techreports/86-020.pdf` — identical |
| `Week14_Sillito2006_QuestionsProgrammersAsk.pdf` | 294,095 | `167a233a7afc88ce1c735ede7ebce3a67e952333b36d353800402ea17f0ae687` | `e61bf0bbd07e87b7cea1c290a2c74a11` | what the schedule's CiteSeerX link now serves via its Wayback redirect — identical |

The Brooks file's title page reads *"No Silver Bullet — Essence and Accidents of Software
Engineering, TR86-020, September 1986,"* confirming it is the technical report rather than
the 1987 *Computer* article. The schedule citation names it accordingly.

The Sillito identity is worth noting: the download record attributes it to a UBC mirror, and
it is byte-identical to what CiteSeerX now serves. Either UBC was the copy CiteSeerX
harvested, or the file in fact came from CiteSeerX. The URL of the UBC mirror was not
recorded at download time, which is why no live replacement is on hand should the CiteSeerX
redirect stop resolving.

## Still missing (2 of 33)

**Letovsky, *Cognitive Processes in Program Comprehension* (1987).** Confirmed closed access
by both OpenAlex and Semantic Scholar; Elsevier/ScienceDirect only. A Kent State course
mirror file named `letovsky-1986-software.pdf` looks like a match but is a *different*
paper — Letovsky & Soloway, "Delocalized Plans and Program Comprehension," *IEEE Software*
3(3), May/June 1986, pp. 41-49. Do not mistake it for this reading.

**Hoare, *Proof of Correctness of Data Representations* (1972).** Confirmed closed access by
both OpenAlex and Semantic Scholar. The Oxford ORA record holds metadata with no attached
file; the Oxford PRG publication page has no file; the Springer article and the Springer
book-chapter reprint (`10.1007/978-3-642-48354-7_18`) both serve paywall HTML.

Both are cited by DOI in the schedule and read through the UVA library.

Week 8 also cites the Lean 4.32.2 release notes and Lean issue #14576. Those are web pages,
not papers, so they are not mirrored.
