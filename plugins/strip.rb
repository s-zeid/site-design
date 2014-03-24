# By Janne Ala-Äijälä (underdude)
# From <https://github.com/aucor/jekyll-plugins/blob/master/strip.rb>
# 
# Copyright (c) 2012 Aucor Oy
# MIT License per <https://github.com/aucor/jekyll-plugins/blob/333794c/LICENCE>.

# Replaces multiple newlines and whitespace 
# between them with one newline

module Jekyll
  class StripTag < Liquid::Block

    def render(context)
      super.gsub /\n\s*\n/, "\n"
    end

  end
end

Liquid::Template.register_tag('strip', Jekyll::StripTag)
