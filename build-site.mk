.PHONY: css move postbuild

BUILD_DIR := ._build
SITE_DIR  := _site

all: build postbuild move

build: css
	jekyll build --config _template/base-config.yml,_config.yml \
	             --destination $(BUILD_DIR)
	cp -ar _template/static/* $(BUILD_DIR)
	cp -a _redirects $(BUILD_DIR)/_redirects
	[ -d _static -a `ls -A _static | wc -l | cut -d' ' -f1` -ne 0 ] && \
	 cp -ar _static/* $(BUILD_DIR) || true

postbuild:
	if [ -x _postbuild ]; then ./_postbuild $(BUILD_DIR) $(SITE_DIR); fi

move:
	rm -rf $(SITE_DIR)
	mv $(BUILD_DIR) $(SITE_DIR)

css: _template/static/styles/*.css

_template/static/styles/%.css: _template/styles/%.styl _config.styl
	stylus _template/styles -o _template/static/styles
	[ -d $(SITE_DIR)/styles ] && \
	 cp -ar _template/static/styles/* $(SITE_DIR)/styles || true
