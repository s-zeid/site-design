# By Janne Ala-Äijälä (underdude)
# From <https://github.com/aucor/jekyll-plugins/blob/master/strip.rb>
# 
# Copyright (c) 2012 Aucor Oy
# MIT License per <https://github.com/aucor/jekyll-plugins/blob/333794c/LICENCE>.

# Modifications (c) 2015 Scott Zeid and released under the X11 license.

# Various whitespace-stripping block tags

module Jekyll
 class StripTag < Liquid::Block
  # Replaces multiple newlines and whitespace between them with one newline
  # and then strips leading and trailing whitespace
  def render(context)
   super.gsub(/\n\s*\n/, "\n").strip()
  end
 end
 class LStripTag < Liquid::Block
  # Strips leading whitespace
  def render(context)
   super.lstrip()
  end
 end
 class RStripTag < Liquid::Block
  # Strips trailing whitespace
  def render(context)
   super.rstrip()
  end
 end
 class LRStripTag < Liquid::Block
  # Strips leading and trailing whitespace
  def render(context)
   super.strip()
  end
 end
end

Liquid::Template.register_tag('strip', Jekyll::StripTag)
Liquid::Template.register_tag('lstrip', Jekyll::LStripTag)
Liquid::Template.register_tag('rstrip', Jekyll::RStripTag)
Liquid::Template.register_tag('lrstrip', Jekyll::LRStripTag)
