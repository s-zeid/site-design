# Copyright (C) 2012-2014 Scott Zeid
# http://code.s.zeid.me/site-design
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# 
# Except as contained in this notice, the name(s) of the above copyright holders
# shall not be used in advertising or otherwise to promote the sale, use or
# other dealings in this Software without prior written authorization.

module Jekyll
 class IndentTag < Liquid::Block
  include Liquid::StandardFilters
  
  def initialize(tag_name, level, tokens)
   super
   @level = level.strip
  end
  
  def render(context)
   if @level.nil? or @level.empty?
    level = 0
   elsif /^\d+$/.match(@level).nil?
    level = context[@level].to_i
   else
    level = @level.to_i
   end
   str = super.to_s.gsub(/(<pre>.*?<\/pre>)/im) do |match|
    match.gsub(/(\n)/, "&#x0a;")
   end
   str.lines.collect do |line|
    " " * level + line
   end
  end
 end
end

Liquid::Template.register_tag("indent", Jekyll::IndentTag)
