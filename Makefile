.PHONY: css deploy postbuild

BUILD_DIR := ._build
SITE_DIR  := _site

all: build postbuild deploy

build: css
	jekyll build --config _template/_config.base.yml,_config.yml \
	             --destination $(BUILD_DIR)
	cp -ar _template/_static/* $(BUILD_DIR)
	cp -a _redirects $(BUILD_DIR)/_redirects
	[ -d _static -a `ls -A _static | wc -l | cut -d' ' -f1` -ne 0 ] && \
	 cp -ar _static/* $(BUILD_DIR) || true

postbuild:
	if [ -x _postbuild ]; then ./_postbuild $(BUILD_DIR) $(SITE_DIR); fi

deploy:
	rm -rf $(SITE_DIR)
	mv $(BUILD_DIR) $(SITE_DIR)

css: _template/_static/styles/*.css

_template/_static/styles/%.css: _template/_styles/%.styl _config.styl
	stylus _template/_styles -o _template/_static/styles
	[ -d $(SITE_DIR)/styles ] && \
	 cp -ar _template/_static/styles/* $(SITE_DIR)/styles || true
