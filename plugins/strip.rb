# By Janne Ala-Äijälä (underdude)
# From <https://github.com/aucor/jekyll-plugins/blob/master/strip.rb>
# 
# Copyright (c) 2012 Aucor Oy
# MIT License per <https://github.com/aucor/jekyll-plugins/blob/333794c/LICENCE>.

# Modifications (c) 2015 Scott Zeid and released under the X11 license.

# Replaces multiple newlines and whitespace between them with one newline
# and then strips leading and trailing whitespace

module Jekyll
 class StripTag < Liquid::Block
  def render(context)
   super.gsub(/\n\s*\n/, "\n").strip()
  end
 end
end

Liquid::Template.register_tag('strip', Jekyll::StripTag)
