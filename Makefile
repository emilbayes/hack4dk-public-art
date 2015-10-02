NODE_MODULES_BIN := node_modules/.bin
BROWSERIFY := $(NODE_MODULES_BIN)/browserify
WATCHIFY := $(NODE_MODULES_BIN)/watchify
CSSNEXT := $(NODE_MODULES_BIN)/cssnext
ECSTATIC := $(NODE_MODULES_BIN)/ecstatic
STANDARD := $(NODE_MODULES_BIN)/standard

JS_ENTRY := src/index.js
CSS_ENTRY := src/index.css
HTML_ENTRY := src/index.html

BUNDLE_FOLDER := dist

JS_BUNDLE := $(BUNDLE_FOLDER)/bundle.js
CSS_BUNDLE := $(BUNDLE_FOLDER)/bundle.css
# Not a real bundle
HTML_BUNDLE := $(BUNDLE_FOLDER)/index.html

bundle: $(BUNDLE_FOLDER)/ $(JS_BUNDLE) $(CSS_BUNDLE) $(HTML_BUNDLE)

$(BUNDLE_FOLDER)/:
	mkdir -p dist

$(JS_BUNDLE): $(JS_ENTRY) src/*.js $(BUNDLE_FOLDER)/
	$(BROWSERIFY) $< -o $@

$(CSS_BUNDLE): $(CSS_ENTRY) src/*.css $(BUNDLE_FOLDER)/
	$(CSSNEXT) $< $@

$(HTML_BUNDLE): $(HTML_ENTRY) $(BUNDLE_FOLDER)/
	cp $< $@

watch:
	$(CSSNEXT) --watch $(CSS_ENTRY) src/bundle.css & \
	$(WATCHIFY) $(JS_ENTRY) -o src/bundle.js & \
	$(ECSTATIC) src & \
	wait

test: lint

lint: src/*.js
	$(STANDARD) $^

clean:
	rm -rf $(BUNDLE_FOLDER)/ src/bundle.css src/bundle.js

gh-pages:
	