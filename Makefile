HUGO_VERSION := v0.165.0
HUGO_IMAGE   := ghcr.io/gohugoio/hugo:$(HUGO_VERSION)

# The Tailwind version and the platform detection live in scripts/build-css.sh,
# which is also what both CI configurations call. Pinned in one place only.

.PHONY: pull build serve css fonts clean

pull:
	docker pull $(HUGO_IMAGE)

# css runs first so a build can never ship stale utility classes.
build: pull css
	docker run -v $$(pwd):$$(pwd) -w $$(pwd) $(HUGO_IMAGE) build --minify

serve: pull css
	# --poll: file watching is unreliable through a Docker bind mount on
	# macOS, so live reload needs polling to see your edits.
	docker run -v $$(pwd):$$(pwd) -w $$(pwd) -p 1313:1313 $(HUGO_IMAGE) \
		server --bind 0.0.0.0 --poll 700ms

# Recompile the utility classes actually used by the templates.
css:
	./scripts/build-css.sh

# Re-download the self-hosted Inter subsets from Google Fonts.
fonts:
	python3 scripts/update-fonts.py

clean:
	rm -rf public .bin
