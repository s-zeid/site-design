# Partially undo Jekyll commit 0d1586a5c471d322a79177e3e9c2f5813c697c32
# (Improved permalinks for pages and collections)
# <https://github.com/jekyll/jekyll/commit/0d1586a>
#
# From Jekyll core
# Copyright (c) 2008-2015 Tom Preston-Werner
# MIT License per <https://github.com/jekyll/jekyll/blob/0662d31/LICENSE>

# When using a permalink style that ends with a `/`, page permalinks should
# *not* be given a trailing slash instead of `.html` for a few reasons:
# 
# 1.  This breaks [Cool URIs don't change](http://www.w3.org/Provider/Style/URI.html)
#     for sites upgrading from older versions of Jekyll.
# 2.  My preferred system of setting up page permalinks that end with a `/`
#     is to explicitly make a subdirectory and name the page `index.md`
#     inside the subdirectory, and then to ignore the `index.html` in the
#     permalinks.  This has the advantage of making it easier to group
#     resources like images and data files with the page to which they
#     belong, and it also makes it obvious what the resulting directory
#     structure will be.
# 3.  If both `page/index.md` and `page.md` exist, there will be an obvious
#     conflict.
# 
# I haven't used collections, so I don't know what the effect is there and
# so I'm not reverting the part that deals with collections yet.  I should
# probably look at it some time when I have time.

module Jekyll
 class Page
  def template
   if site.permalink_style == :pretty
    if index? && html?
     "/:path/"
    elsif html?
     "/:path/:basename/"
    else
     "/:path/:basename:output_ext"
    end
   else
    "/:path/:basename:output_ext"
   end
  end
 end
end
