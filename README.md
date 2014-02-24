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

Setup
=====

1.  Install the dependencies:
    
        fedora$ sudo yum install ruby rubygems nodejs npm make
        ubuntu$ sudo apt-get install ruby rubygems nodejs npm make
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
