<style>
/* Cover page. Colors come from mdBook theme variables so the plate follows
   light / rust / coal / navy / ayu without per-theme overrides. */
.cover {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: calc(100vh - 8rem);
  margin: 0.5rem 0 2rem;
}
.cover-plate {
  width: 100%;
  padding: clamp(2rem, 6vw, 4.5rem) clamp(1.25rem, 5vw, 3.5rem);
  text-align: center;
  border: 1px solid var(--quote-border);
  outline: 1px solid var(--quote-border);
  outline-offset: 6px;
  background: var(--quote-bg);
}
.cover-kicker {
  font-size: 0.78rem;
  font-weight: 600;
  letter-spacing: 0.22em;
  text-transform: uppercase;
  opacity: 0.7;
}
.cover-title {
  font-size: clamp(3.2rem, 13vw, 6rem);
  font-weight: 700;
  line-height: 1;
  letter-spacing: 0.04em;
  margin: clamp(1.5rem, 5vw, 2.5rem) 0 0;
}
.cover-subtitle {
  font-size: clamp(1.15rem, 4vw, 1.7rem);
  font-weight: 400;
  font-style: italic;
  line-height: 1.25;
  margin-top: 0.6rem;
}
.cover-rule {
  width: 42%;
  max-width: 14rem;
  height: 1px;
  margin: clamp(1.5rem, 5vw, 2.25rem) auto;
  background: var(--quote-border);
}
.cover-blurb {
  max-width: 30rem;
  margin: 0 auto;
  font-size: 0.98rem;
  line-height: 1.55;
  opacity: 0.85;
}
.cover-author {
  margin-top: clamp(1.75rem, 5vw, 2.75rem);
  font-size: 1.12rem;
  font-weight: 600;
  letter-spacing: 0.01em;
}
.cover-affiliation {
  margin-top: 0.2rem;
  font-size: 0.95rem;
  opacity: 0.75;
}
.cover-mark {
  margin-top: clamp(1.75rem, 5vw, 2.75rem);
  font-family: var(--mono-font, monospace);
  font-size: 0.82rem;
  opacity: 0.6;
  overflow-wrap: anywhere;
}
.cover-status {
  margin-top: 0.9rem;
  font-size: 0.78rem;
  letter-spacing: 0.16em;
  text-transform: uppercase;
  opacity: 0.6;
}
</style>

<div class="cover">
  <div class="cover-plate">
    <div class="cover-kicker">University of Virginia</div>
    <div class="cover-title">CS6501</div>
    <div class="cover-subtitle">Fall 2026</div>
    <div class="cover-rule"></div>
    <p class="cover-blurb">
      A course in functional programming with Lean&nbsp;4, in which every function
      is accompanied by a proposition stating what it must do, and the machine
      decides whether the implementation satisfies it.
    </p>
    <div class="cover-author">Kevin Sullivan</div>
    <div class="cover-affiliation">Department of Computer Science</div>
    <div class="cover-mark">theorem correct : &forall; n, f n = spec n := by decide</div>
    <div class="cover-status">Draft for comment</div>
  </div>
</div>
