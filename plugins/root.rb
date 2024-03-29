# Copyright (C) 2012-2015 S. Zeid
# https://code.s.zeid.me/site-design
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
 class RootTag < Liquid::Tag
  include Liquid::StandardFilters
  
  def initialize(tag_name, url, tokens)
   super
   @tag_name = tag_name
   @url = url.strip
  end
  
  def render(context)
   url = if /^"[^"]"|'[^']'$/.match(@url)
    @url[1..-2]
   elsif not context[@url].nil?
    context[@url]
   else
    @url
   end
   mode = if @tag_name == "absroot"
    "a"
   elsif @tag_name == "relroot"
    "r"
   else
    ""
   end
   options = mode
   "\x05#{url}\x05#{options}\x05"
  end
  
  def self.get_root(context, url="", mode="")
   if mode.start_with? "a"
    use_absolute_root = true
   elsif mode.start_with? "r"
    use_absolute_root = false
   else
    use_absolute_root = false
    if context["site"]["use-absolute-root"]
     case context["page"]["use-absolute-root"]
     when false, 0
      use_absolute_root = false
     else
      use_absolute_root = true
     end
    else
     if context["page"]["use-absolute-root"]
      use_absolute_root = true
     end
    end
   end
   
   if use_absolute_root
    RootTag.get_absolute_root(context["site"])
   else
    RootTag.get_relative_root((url == "") ? context["page"]["url"] : url)
   end
  end
  
  def self.get_absolute_root(site)
   if site["full-url"]
    return site["full-url"]
   elsif site["url"]
    return site["url"]
   else
    return ""
   end
  end
  
  def self.get_relative_root(url)
   dotdot = url.gsub(/^\//, "").gsub(/[^\/]+$/, "").gsub(/[^\/]+\//, "../")
   dotdot = dotdot.gsub(/\/+$/, "")
   return (not dotdot.empty?) ? dotdot : "."
  end
 end
 
 class RootForTag < Liquid::Block
  include Liquid::StandardFilters
  
  def initialize(tag_name, _, tokens)
   super
   @tag_name = tag_name
  end
  
  def render(context)
   url = super.strip
   mode = if @tag_name == "absrootfor"
    "a"
   elsif @tag_name == "relrootfor"
    "r"
   else
    ""
   end
   options = mode
   "\x05#{url}\x05#{options}\x05"
  end
 end
 
 class RootifyTag < Liquid::Block
  include Liquid::StandardFilters
  
  def render(context)
   super.gsub(/\x05[^\x05]*\x05[^\x05]*\x05/) { |match|
    url, options = match[1..-2].split(/\x05/, -1)
    mode = options
    if mode != "5"
     RootTag.get_root(context, url, mode)
    else
     "\x05"
    end
   }
  end
 end
end

Liquid::Template.register_tag("root", Jekyll::RootTag)
Liquid::Template.register_tag("rootfor", Jekyll::RootForTag)
Liquid::Template.register_tag("absroot", Jekyll::RootTag)
Liquid::Template.register_tag("absrootfor", Jekyll::RootForTag)
Liquid::Template.register_tag("relroot", Jekyll::RootTag)
Liquid::Template.register_tag("relrootfor", Jekyll::RootForTag)
Liquid::Template.register_tag("rootify", Jekyll::RootifyTag)

# old names
Liquid::Template.register_tag("dotdot", Jekyll::RootTag)
Liquid::Template.register_tag("dotdotfor", Jekyll::RootForTag)
