.PHONY: css deploy postgen

all: gen postgen deploy

gen: css
	jekyll build --config _template/_config.base.yml,_config.yml --destination _gen
	cp -ar _template/_static/* _gen
	[ -d _static -a `ls -A _static | wc -l | cut -d' ' -f1` -ne 0 ] && \
	 cp -ar _static/* _gen || true

postgen:
	if [ -x _postgen ]; then ./_postgen; fi

deploy:
	rm -rf _site
	mv _gen _site

css: _template/_static/styles/*.css

_template/_static/styles/%.css: _template/_styles/%.styl
	stylus _template/_styles -o _template/_static/styles
	[ -d _site/styles ] && cp -ar _template/_static/styles/* _site/styles || true
