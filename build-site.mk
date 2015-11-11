.PHONY: css move postbuild %.PRECIOUS

BUILD_DIR := ._build
SITE_DIR  := _site

PRECIOUS  := .git .gitmodules .gitignore

all: build postbuild move

build: css
	jekyll build --trace \
	             --config _template/base-config.yml,_config.yml \
	             --destination $(BUILD_DIR)
	cp -ar _template/static/* $(BUILD_DIR)
	cp -a _redirects $(BUILD_DIR)/_redirects
	[ -d _static -a `ls -A _static | wc -l | cut -d' ' -f1` -ne 0 ] && \
	 cp -ar _static/* $(BUILD_DIR) || true

postbuild:
	if [ -x _postbuild ]; then ./_postbuild $(BUILD_DIR) $(SITE_DIR); fi

move: $(PRECIOUS:=.PRECIOUS)
	rm -rf $(SITE_DIR)
	mv $(BUILD_DIR) $(SITE_DIR)

%.PRECIOUS:
	f=$(SITE_DIR)/$(@:.PRECIOUS=); [ -e $$f ] && mv $$f $(BUILD_DIR)/ || true

css: _template/static/styles/*.css

_template/static/styles/%.css: _template/styles/%.styl _config.styl
	for styl in `ls -d _template/styles/*.styl | sort -g`; do \
	 stylus "$$styl" -o _template/static/styles; \
	done
	[ -d $(SITE_DIR)/styles ] && \
	 cp -ar _template/static/styles/* $(SITE_DIR)/styles || true
