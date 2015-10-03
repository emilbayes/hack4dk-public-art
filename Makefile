NODE_MODULES_BIN := node_modules/.bin
BROWSERIFY := $(NODE_MODULES_BIN)/browserify
WATCHIFY := $(NODE_MODULES_BIN)/watchify
CSSNEXT := $(NODE_MODULES_BIN)/cssnext
ECSTATIC := $(NODE_MODULES_BIN)/ecstatic
STANDARD := $(NODE_MODULES_BIN)/standard

bundle: dist/ dist/bundle.js dist/bundle.css dist/index.html

dist/:
	mkdir -p dist

dist/bundle.js: src/index.js src/*.js dist/
	$(BROWSERIFY) $< -o $@

dist/bundle.css: src/index.css src/*.css dist/
	$(CSSNEXT) $< $@

dist/index.html: src/index.html dist/
	cp $< $@

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
	git remote add origin git@github.com:$(TRAVIS_REPO_SLUG).git && \
	git pull origin gh-pages

commit-gh-pages: bundle
	cd dist && \
	git add . && \
	git config user.name "Travis CI" && \
	git config user.email "no-reply@tixz.dk" && \
	git commit -m "Deploy $(TRAVIS_TAG)"
