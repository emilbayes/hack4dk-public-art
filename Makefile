##
# Local binaries
##
NODE_MODULES_BIN := node_modules/.bin
BROWSERIFY := $(NODE_MODULES_BIN)/browserify
WATCHIFY := $(NODE_MODULES_BIN)/watchify
CSSNEXT := $(NODE_MODULES_BIN)/cssnext
ECSTATIC := $(NODE_MODULES_BIN)/ecstatic
STANDARD := $(NODE_MODULES_BIN)/standard

.PHONY: bundle data test deploy lint watch clean
.FORCE:
bundle: data dist/ dist/bundle.js dist/bundle.css dist/index.html
data: dist/ dist/committee-members.csv dist/artists-purchases.csv
test: lint
deploy: dist/ dist/.git bundle commit-gh-pages

##
# Make web files
##
dist/:
	mkdir -p dist

dist/bundle.js: src/index.js src/*.js dist/ .FORCE
	$(BROWSERIFY) $< -o $@

dist/bundle.css: src/index.css src/*.css dist/ .FORCE
	$(CSSNEXT) $< $@

dist/index.html: src/index.html dist/ .FORCE
	cp $< $@

##
# Aux helpers
##
watch:
	$(CSSNEXT) --watch src/index.css dist/bundle.css & \
	$(WATCHIFY) src/index.js -o dist/bundle.js & \
	$(ECSTATIC) dist & \
	while true; do sleep 0.5; make dist/index.html > /dev/null; done; \
	wait

lint: src/*.js
	$(STANDARD) $^

clean:
	rm -rf dist/ data/refined-data/artists-purchases.csv

##
# Make data files
##
dist/committee-members.csv: data/refined-data/committee-members.csv .FORCE
	cat $< | egrep -v '^#.*' > $@

dist/artists-purchases.csv: data/refined-data/artists-purchases.csv .FORCE
	# Quick fix. Julia escapes " as \", where the standard is ""
	cat $< | sed s'/\\"/""/g' > $@

data/refined-data/artists-purchases.csv: data/raw/artists.csv data/raw/purchases.csv
	julia data/process.jl


##
# Deploy targets
##
.SILENT: dist/.git commit-gh-pages
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
