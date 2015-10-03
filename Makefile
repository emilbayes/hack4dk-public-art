NODE_MODULES_BIN := node_modules/.bin
BROWSERIFY := $(NODE_MODULES_BIN)/browserify
WATCHIFY := $(NODE_MODULES_BIN)/watchify
CSSNEXT := $(NODE_MODULES_BIN)/cssnext
ECSTATIC := $(NODE_MODULES_BIN)/ecstatic
STANDARD := $(NODE_MODULES_BIN)/standard

bundle: data dist/ dist/bundle.js dist/bundle.css dist/index.html

dist/:
	mkdir -p dist

dist/bundle.js: src/index.js src/*.js dist/
	$(BROWSERIFY) $< -o $@

dist/bundle.css: src/index.css src/*.css dist/
	$(CSSNEXT) $< $@

dist/index.html: src/index.html dist/
	cp $< $@

data: dist/ dist/committee-members.csv dist/artists-purchases.csv

dist/committee-members.csv: data/refined-data/committee-members.csv
	cp $< $@

dist/artists-purchases.csv: data/refined-data/artists-purchases.csv
	cp $< $@

data/refined-data/artists-purchases.csv: data/raw/artists.csv data/raw/purchases.csv
	julia data/process.jl

watch:
	$(CSSNEXT) --watch src/index.css src/bundle.css & \
	$(WATCHIFY) src/index.js -o src/bundle.js & \
	watch -n1 make dist/index.html & \
	$(ECSTATIC) dist & \
	wait

test: lint

lint: src/*.js
	$(STANDARD) $^

clean:
	rm -rf dist/

deploy: dist/ dist/.git bundle commit-gh-pages

dist/.git: dist/
	cd dist && \
	git init && \
	git remote add origin "https://$(GH_TOKEN)@github.com/$(TRAVIS_REPO_SLUG).git" && \
	git pull origin gh-pages

commit-gh-pages: dist/.git bundle
	cd dist && \
	git add . && \
	git config user.name "Travis CI" && \
	git config user.email "no-reply@tixz.dk" && \
	git commit -m "Deploy $(TRAVIS_TAG)" && \
	git push --quiet origin master:gh-pages
