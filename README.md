This is the design for my Web site, <http://s.zeid.me/>.

The contents of this repository are not intended to be used directly as
a Jekyll site; instead, a `new-site` script is provided that creates a
new Jekyll directory tree and clones this repository into `_template`
inside that directory.  To build the site, you use a GNU Makefile which
compiles the stylesheets and runs Jekyll with the correct configuration
files.  (Two configuration files are used:  one in this repository,
which contains some settings necessary for this system to work, and one
in your site's directory, which you can customize.)

In particular, you will notice that your site tree will contain no
`_layouts` or `_plugins` directories.  These are provided for you in the
`_template` directory, and the Makefile makes sure Jekyll uses the correct
paths for them.


Contents
========

* Setup
* Front-matter parameters
* Tags
* Filters


Setup
=====

1.  Install the dependencies:
    
        fedora$ sudo yum install ruby ruby-devel rubygems nodejs npm make
        ubuntu$ sudo apt-get install ruby ruby-dev rubygems nodejs npm make
        any-distro$ sudo npm -g install stylus
        any-distro$ sudo gem install jekyll stylus
    
    PHP 5 is an optional dependency, necessary only for the provided
    redirect mechanism (`_static/redirect.php`).
    
2.  Download <https://bitbucket.org/scottywz/site-design/raw/master/new-site>
    and make it executable.
3.  Inspect `new-site`.
4.  Run `new-site <directory>`, where `<directory>` is the directory in which
    you want your site to reside.
5.  Edit `_config.yml` (Jekyll configuration), `_config.styl` (stylesheet
    variables), `_postbuild`, and `_redirects` as desired.  You can also
    remove `_postbuild` and `_redirects` if you don't need them.
6.  Add some content!
7.  Change into your site's directory and run `make`.


Front-matter parameters
=======================

There's a lot of these.

### `title`
(string)

The page's title.

### `icon`
(string)

The URL, relative to the page itself, of an icon to use as the page's favicon
and in navigation elements.

### `description`
(string)

The page's description.

### `og-image`
(string)

The URL, relative to the page itself, to use for the value of the Facebook
`og:image` meta tag.  This will be converted to an absolute URL based on the
value of `site.full-url` or `site.url`.  Protocol-relative URLs will then be
converted based on the value of `site.default-scheme`.

### `html-title`
(string) (default: same as `page.title`)

The title to use in the HTML `<title>` element.

### `raw-html-title`
(boolean) (default: `False`)

If `False`, HTML and newlines will be stripped from the title as used in the
HTML `title` element.

### `h1`
(string) (default: same as `page.title`)

The title to show in the `<h1>` element at the top of the page.

### `show-copyright`
(boolean) (default: `True`)

Controls whether any copyright statement is shown in the page's footer.

### `head`
(string)

Extra content to be inserted at the end of the `<head>` tag, but before
`page.stylus` and/or `page.css`.

### `stylus`
(string)

A Stylus stylesheet to be inserted in a `<style>` tag at the end of the
`<head>` tag, but before `page.css`.

### `css`
(string)

A CSS stylesheet to be inserted in a `<style>` tag at the end of the `<head>`
tag.

### `before-html`
(string)

Raw text to be inserted before *any* generated HTML, even before the doctype.

### `after-html`
(string)

Raw text to be inserted after *all* generated HTML.

### `use-absolute-root`
(boolean) (default: same as `site.use-absoulte-root` or `False`)

Controls whether absolute paths should be used for the site root path and the
page's directory path (see the `root` and `dir` tags).  This only applies when
the page is being rendered as a standalone page.  When being included in
another page (e.g. a blog post listing or feed), the other page's setting will
be used instead.

### `nav`
(dictionary)

Controls how the page is displayed in navigation elements
(the top navigation bar, subpage listings, etc.).

#### `hide`
(boolean) (default: `False` (`True` if no layout))

Causes the page to not be shown in navigation areas.

#### `show`
(boolean) (default: `True` (`False` if no layout))

Causes the page to be shown in navigation areas.

#### `sort-key`
(string) (default: same as `page.url`)

Used for sorting navigation elements.

#### `title`
(string) (default: same as `page.title`)

Overrides the title used in navigation elements.  Different kinds of
navigation areas may also support other parameters that override this
one.

#### `menu-title`
(string) (defaults: `page.nav.title` or `page.title`)

The title to use in menu-style navigation elements.  Prefer to use
`page.nav.title` instead.

#### `subpage-title`
(string) (defaults: `page.nav.title` or `page.title`)

The title to use in subpage listings.  Prefer to use
`page.nav.title` instead.

#### `tooltip`
(string) (default: same as `page.description`)

Text to be shown when hovering over the menu item.

#### `target`
(string)

The window target to be used in the navigation item's `<a>` element.


Tags
====

This is only a partial list of Liquid tags available.

### `root`

Inserts the site's root URL.  This may be relative to the current page or
absolute, depending on the value of `page.use-absolute-root` *on the page
actually being generated* or `site.use-absolute-root`.

### `dir`

Inserts the path to the current page's directory. This may be relative to the
current page or absolute, depending on the value of `page.use-absolute-root`
*on the page actually being generated* or `site.use-absolute-root`.

### `enquiry`

Inserts a literal enquiry character (ASCII value `0x05`).  This exists due to
how the `root` and `dir` tags are internally implemented.

### `copyright_year`

Inserts the copyright year(s) that apply to the site.  This is based on the
current year at the time of rendering and the value of `site.copyright-start`.
The output will be of the format `<start-year>&ndash;<end-year>`, or just
`<end-year>` if both are the same.

### `rootify`

A block tag that resolves all references to the site's root URL using the
settings that apply to the page or layout in which `rootify` is used.  All
uses of `root`, `dir`, or `enquiry` MUST be contained inside a `rootify`
block, either directly or indirectly.  The included layouts (except for
`none`) will take care of this for you.

### `indent`
Usage: `{% indent <level> %}...{% endindent %}`

A block tag that indents its contents by `level` space(s).  `level` may be
a literal integer or a variable that contains either an integer or something
that can be converted to an integer.

The contents of `<pre>...</pre>` sequences will not be modified except to
replace newlines contained within them with the XML entity `&#x0a;`.
[Unfortunately](http://stackoverflow.com/a/1732454), this is done with a
regular expression.


Filters
=======

### `gsub`
Usage: `{{ ... | gsub: <regex>, <replacement>[, <options>] }}`

Converts input to a string and runs Ruby's [String#gsub][string-gsub] on the
result.  All arguments are to be supplied as string literals.

`options` should only contain the characters `i`, `m`, or `x`.  These are the
same as the same [options in Ruby's `Regexp` class][regexp-options].

You should only use this filter with trusted input and trusted arguments.

[string-gsub]: http://ruby-doc.org/core/String.html#method-i-gsub
[regexp-options]: http://ruby-doc.org/core/Regexp.html#class-Regexp-label-Options
