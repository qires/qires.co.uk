pull:
	docker pull ghcr.io/gohugoio/hugo:v0.165.0

build: pull
	docker run -v $$(pwd):$$(pwd) -w $$(pwd) ghcr.io/gohugoio/hugo:v0.165.0 build

serve: pull
	docker run -v $$(pwd):$$(pwd) -w $$(pwd) -p 1313:1313 ghcr.io/gohugoio/hugo:v0.165.0 server --bind 0.0.0.0
