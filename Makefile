HUGO_VERSION    := v0.165.0
HUGO_IMAGE      := ghcr.io/gohugoio/hugo:$(HUGO_VERSION)
TAILWIND_VERSION := v4.3.3

# Pick the right standalone Tailwind build for this machine. The binary needs
# no Node, which keeps the Hugo Docker image and the Pages workflow free of a
# JavaScript toolchain.
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)
ifeq ($(UNAME_S),Darwin)
	ifeq ($(UNAME_M),arm64)
		TAILWIND_TARGET := macos-arm64
	else
		TAILWIND_TARGET := macos-x64
	endif
else
	ifeq ($(UNAME_M),aarch64)
		TAILWIND_TARGET := linux-arm64
	else
		TAILWIND_TARGET := linux-x64
	endif
endif

TAILWIND := .bin/tailwindcss

.PHONY: pull build serve css fonts clean

pull:
	docker pull $(HUGO_IMAGE)

# css runs first so a deploy can never ship stale utility classes.
build: pull css
	docker run -v $$(pwd):$$(pwd) -w $$(pwd) $(HUGO_IMAGE) build

serve: pull css
	docker run -v $$(pwd):$$(pwd) -w $$(pwd) -p 1313:1313 $(HUGO_IMAGE) server --bind 0.0.0.0

$(TAILWIND):
	@mkdir -p .bin
	@echo "Fetching Tailwind $(TAILWIND_VERSION) ($(TAILWIND_TARGET))..."
	@curl -sfL -o $@ \
		"https://github.com/tailwindlabs/tailwindcss/releases/download/$(TAILWIND_VERSION)/tailwindcss-$(TAILWIND_TARGET)"
	@chmod +x $@

# Recompile the utility classes actually used by the templates.
css: $(TAILWIND)
	$(TAILWIND) -i assets/css/tailwind.css -o static/css/tailwind.css --minify

# Re-download the self-hosted Inter subsets from Google Fonts.
fonts:
	python3 scripts/update-fonts.py

clean:
	rm -rf public .bin
