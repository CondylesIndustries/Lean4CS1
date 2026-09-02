# Source and target directories
SRC_DIRS := Overview FPCourse

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

# Regenerate the Canvas-pasteable exports from SYLLABUS.md
canvas:
	@python3 scripts/canvas_export.py

# Serve locally with live reload
serve:
	mdbook serve -n 0.0.0.0

# Clean generated markdown (but keep src/SUMMARY.md and src/introduction.md)
clean-md:
	rm -rf src/Overview src/FPCourse

# Clean everything including the built book
clean:
	rm -rf src/Overview src/FPCourse book/

.PHONY: all convert build canvas serve clean-md clean
