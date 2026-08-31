# Source and target directories
SRC_DIRS := Overview FPCourse

# Commit the book was built from.  src/cover.md carries the literal token
# @GIT_COMMIT@; `stamp` rewrites it in the *built* HTML, so the source file
# stays clean and no commit has to contain its own hash.
GIT_COMMIT := $(shell git rev-parse --short HEAD 2>/dev/null || echo unknown)
GIT_DIRTY  := $(shell git diff --quiet HEAD 2>/dev/null || echo -dirty)

# Find all source files recursively across all source directories
SRC_FILES := $(shell find $(SRC_DIRS) -type f -name '*.lean')
# Derive corresponding output files with .md extension under src/
BUILD_FILES := $(patsubst %.lean,src/%.md,$(SRC_FILES))

# Default target: convert all .lean files to .md, then build the book
all: $(BUILD_FILES)
	mdbook build
	@$(MAKE) --no-print-directory stamp
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
	@$(MAKE) --no-print-directory stamp

# Stamp the built cover with the commit the book was built from
stamp:
	@sed -i 's/@GIT_COMMIT@/$(GIT_COMMIT)$(GIT_DIRTY)/' book/cover.html
	@echo "Stamped book/cover.html with $(GIT_COMMIT)$(GIT_DIRTY)"

# Regenerate the Canvas-pasteable exports from SYLLABUS.md
canvas:
	@python3 scripts/canvas_export.py

# Serve locally with live reload
serve:
	mdbook serve

# Clean generated markdown (but keep src/SUMMARY.md and src/introduction.md)
clean-md:
	rm -rf src/Overview src/FPCourse

# Clean everything including the built book
clean:
	rm -rf src/Overview src/FPCourse book/

.PHONY: all convert build stamp canvas serve clean-md clean
