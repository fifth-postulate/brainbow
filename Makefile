.PHONY: clean dist

dist: gh-pages/index.html gh-pages/assets gh-pages/js
	@echo "Finished"

deploy: dist deploy-pages.sh
	./deploy-pages.sh

gh-pages/index.html: gh-pages index.html
	cp index.html gh-pages/index.html

gh-pages/assets: gh-pages
	cp -r assets gh-pages/assets

gh-pages/js: gh-pages js/brainbow.js
	cp -r js gh-pages/js

js/brainbow.js: src/Main.elm
	elm make src/Main.elm --output=js/brainbow.js

gh-pages:
	mkdir -p gh-pages

clean:
	rm -rf gh-pages
