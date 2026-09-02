# Source and target directories.  Overview/ was removed in bc8a745; listing a
# directory that no longer exists made `find` error on every make invocation.
SRC_DIRS := FPCourse

# The cover's @GIT_COMMIT@ token is substituted by the stamp preprocessor
# (scripts/stamp_commit.py, registered in book.toml), so every build mdBook
# runs -- `mdbook serve` rebuilds included -- gets it right without help from
# this Makefile.  Set BOOK_COMMIT to override what it stamps.

# Find all source files recursively across all source directories
SRC_FILES := $(shell find $(SRC_DIRS) -type f -name '*.lean')
# Derive corresponding output files with .md extension under src/
BUILD_FILES := $(patsubst %.lean,src/%.md,$(SRC_FILES))

# Default target: convert all .lean files to .md, then build the book
all: $(BUILD_FILES)
	mdbook build
	@$(MAKE) --no-print-directory canvas

# Rule: .lean → src/%.md
$(BUILD_FILES): src/%.md: %.lean
	@mkdir -p $(dir $@)
	echo "Converting $< into $@"
	python3 scripts/convert.py $< $@

# Convert only (no mdbook build)
convert: $(BUILD_FILES)

# Build the book (assumes convert has been run)
build:
	mdbook build

# Regenerate the Slack copy-paste page from the Slack text
slack:
	@python3 scripts/make_slack_html.py

# Accessibility gate over the built book.  Pages authored here must pass
# WCAG 2.1 AA and Section 508; mdBook's own pages are reported but do not fail
# the build, since their violations come from the upstream theme.  Needs
# playwright: pip install playwright && python3 -m playwright install --with-deps chromium
a11y: build
	@python3 scripts/a11y_check.py book

# Regenerate the Canvas-pasteable exports from SYLLABUS.md
canvas:
	@python3 scripts/canvas_export.py

# Serve locally with live reload
serve:
	mdbook serve -n 0.0.0.0

# Directories under src/ that are generated from Lean sources, and so are the
# only ones safe to delete.  Derived from SRC_DIRS rather than written out, so
# the two cannot drift apart: a hardcoded src/Overview here would have deleted
# a tracked file whose .lean source no longer exists.
GENERATED_MD := $(addprefix src/,$(SRC_DIRS))

# Clean generated markdown (but keep src/SUMMARY.md and src/introduction.md)
clean-md:
	rm -rf $(GENERATED_MD)

# Clean everything including the built book
clean:
	rm -rf $(GENERATED_MD) book/

.PHONY: all convert build a11y slack canvas serve clean-md clean
