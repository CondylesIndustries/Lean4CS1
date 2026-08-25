import Mathlib.Data.Real.Basic

-- Specifications (Data)

#check Empty
#check Unit
#check Bool
#check Nat
#check Int
#check Rat
#check Real
#check String
#check List

-- Implementations (Data)

/-
Some code below is *meant* to fail. We keep it because the failure is the
lesson, but a failing file breaks `lake build` and CI. `#guard_msgs` resolves
this: it runs the command that follows, compares the messages that command
emits against the `/-- ... -/` block immediately above it, and then consumes
them. If they match, the build succeeds and the error never escapes. If they
stop matching -- say a future Lean version reworks the message -- the guard
itself fails, so this stays honest rather than silently rotting.

To determine the precise text to guard upon:

1. Provoke the message. Build the file (`lake build FPCourse.specsAndImpls`),
   or put the cursor on the offending line in VS Code and read the InfoView.
2. Copy the message *verbatim*, but drop the `FPCourse/....lean:LINE:COL: `
   location prefix -- guard blocks carry no file positions.
3. Paste it into a `/-- ... -/` block directly above the command, prefixed by
   its severity: `error: `, `warning: `, or `info: `. Only the first line takes
   the prefix; continuation lines (`context:`, `⊢ ...`) are pasted as-is.
4. Preserve leading whitespace on continuation lines exactly. Lean compares the
   text after normalising trailing whitespace, so indentation inside the
   message is significant.
5. Write `#guard_msgs in` on the line between the block and the command.

Shortcut: write an empty `/-- -/` block, add `#guard_msgs in`, and build. The
mismatch report prints the actual message, which you can paste straight in.

A command may emit several messages; the block must list all of them, in order.
Use `#guard_msgs (error) in` to check only errors and ignore `info`/`warning`
output -- useful next to `#check` and `#reduce`, which are chatty.

One caution: messages containing metavariables, such as the `?u.2` universe in
the `List` guard below, embed numbers Lean assigns during elaboration. Those can
shift when surrounding code changes, and the guard will need updating.
-/

/--
error: don't know how to synthesize placeholder
context:
⊢ Empty
-/
#guard_msgs in
def e : Empty := _


#check e
#reduce e

def u : Unit := PUnit.unit
def u' : Unit := ()
#check u'
#reduce u'

def b0 : Bool := true
def b1 : Bool := false

def n0 : Nat := 0
def n1 : Nat := 1
-- each value is finite, but they do go on forever

def i : Int := 0

def q : Rat := 0

def r : Real := 0.0

def s : String := ""

/--
error: type expected, got
  (List : Type ?u.2 → Type ?u.2)
-/
#guard_msgs in
def l : List := _

-- Specifications (Total Functions)
-- Let's talk about functions
  -- domain of definition (for us, a type)
  -- codomain (for us, a type)
  -- collection of pairs (i, o) where i ∈ d.o.d. and o ∈ codomain
  -- domain (set of values in d.o.d. for which there are corresponding values in codomain)
  -- range (set of values in codomain for which there are corresponding values in d.o.d.)
-- A function is total if its domain is equal to its domain of definition

#check Empty → Empty
#check Empty → Bool
#check Bool → Empty
#check Bool → Bool
#check Bool → String
#check String → Bool
#check Empty → Bool
#check String → String

-- Implementations (Total Functions)
/--
error: don't know how to synthesize placeholder
context:
⊢ Empty → Empty
-/
#guard_msgs in
def e2e : Empty → Empty := _
