# Copyright (C) 2012-2015 Scott Zeid
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
 class SiteNavigationLevelTag < Liquid::Tag
  include Liquid::StandardFilters
  
  def initialize(tag_name, url, tokens)
   super
   @url = url.strip
  end
  
  def render(context)
   tree = SiteNavigationTag.tree(context.registers[:site])
   self.class.page_level((@url=="") ? context["page"]["url"] : @url, tree)
  end
  
  def self.page_level(url, tree, level=0)
   tree.each do |i|
    if i["page"]["url"] == url
     return i["page"]["nav"]["level"].to_i if not i["page"]["nav"]["level"].nil?
     return level
    end
    children = self.page_level(url, i["children"], level + 1)
    return children if not children.nil?
   end
   if level > 0
    return nil
   else
    return SiteNavigationTag.to_slug(url).gsub(/^\/?(.*?)\/?$/, '\1').count("/")
   end
  end
 end
 
 class SiteNavigationPageInfoTag < Liquid::Tag
  include Liquid::StandardFilters
  extend Jekyll::Filters
  
  def initialize(tag_name, url, tokens)
   super
   @url = url.strip
  end
  
  def render(context)
   url_map = SiteNavigationTag.url_map(context.registers[:site])
   self.class.page_info((@url=="") ? context["page"]["url"] : @url, url_map,
                        context)
  end
  
  def self.page_info(url, url_map, ctx)
   if url_map.include?(url)
    info = nil
    p = url_map[url]
    if not p["page_basic"].nil?
     info = p["page_basic"].call(ctx)
    end
   end
   info = Jekyll::Utils::deep_merge_hashes((info or {}), {
    "nav" => {
     "original" => {}
    }
   })
   return jsonify(info)
  end
 end
 
 class SiteNavigationTag < Liquid::Block
  include Liquid::StandardFilters
  
  @@tree = []
  @@child_list = {}
  @@url_map = {}
  
  def initialize(tag_name, parent, tokens)
   super
   @parent = (not parent.empty?) ? parent.strip : ""
  end
  
  def render(context)
   parent = if /^"[^"]"|'[^']'$/.match(@parent)
    @parent[1..-2]
   elsif not context[@parent].nil?
    context[@parent]
   else
    @parent
   end
   parent = (not parent.empty?) ? self.class.to_slug(parent) : ""
   parent = (parent != "/") ? parent : ""
   generate_output(self.class.tree(context.registers[:site], parent), context, super)
  end
  
  def self.tree(site, parent="", node=nil)
   if node.nil?
    if not @@tree.empty?
     node = @@tree
    else
     @@tree = self.make_tree(site)
     node = @@tree
     #@@child_list.keys.each { |k| puts "#{k} (#{@@child_list[k].size})" }
    end
   end
   
   if parent == ""
    return node
   else
    return @@child_list[parent]
   end
  end
  
  def self.to_slug(url)
   slug = url.gsub(/\/index\.([^\/.]+)$/, "/")
   return (not slug.empty?) ? slug : "/"
  end
  
  def self.url_map(site)
   if @@tree.empty?
    @@tree = self.make_tree(site)
   end
   return @@url_map
  end
  
  private
  
  def generate_output(tree, context, template, level=0)
   return if tree == nil or tree.empty?
   pages = tree.collect {|i|
    nav = i["page"]["nav"]
    original_nav = nav["original"]
    next if original_nav["show"] == false or original_nav["hide"] == true
    i["page"].merge({ "nav" => nav.merge(nav) { |k, v, unused|
     if k == "children"
      generate_output(v, context, template, level + 1)
     else
      (v.is_a? Proc) ? v.call(context, @@url_map[context["page"]["url"]]) : v
     end
    }})
   }.delete_if {|p| p.nil?}
   output = ""
   context.stack do
    context["nav"] = {
     "level"  => level,
     "pages"  => pages
    }
    partial = Liquid::Template.parse(template)
    output = partial.render(context)
   end
   return output
  end
  
  def self.sort_key(page)
   if page["page"]["nav"]["original"]["sort-key"]
    return page["page"]["nav"]["original"]["sort-key"]
   else
    return page["slug"]
   end
  end
  
  def self.make_tree(site, parent="")
   previous = ""
   site.pages.collect {|p| p.to_liquid}.sort {|a,b|
    self.to_slug(a["url"]) <=> self.to_slug(b["url"])
   }.collect {|page|
    slug = self.to_slug(page["url"])
    slug_no_end_slash = (slug != "/") ? slug.gsub(/(\/)$/, "") : slug
    next if not page["layout"] and (not page["nav"] or not page["nav"]["show"])
    next if previous != "" and slug_no_end_slash.start_with? (previous + "/")
    next if not slug_no_end_slash.start_with?(parent + "/")
    previous = slug_no_end_slash
    original_nav = (page["nav"].nil?) ? {} : page["nav"]
    title = if not original_nav["title"].nil?
     original_nav["title"]
    elsif not page["title"].nil?
     page["title"]
    else
     slug
    end
    @@child_list[slug] = children = self.make_tree(site, slug_no_end_slash)
    page = Jekyll::Utils::deep_merge_hashes(page, {"nav" => {
     "current"  => lambda {|ctx, p|
      p = (p.nil?) ? {} : p
      cnav = (ctx["page"]["nav"].nil?) ? {} : ctx["page"]["nav"]
      (ctx["page"]["url"] == page["url"] or
       (([page["url"], slug].include? cnav["highlight"]) and
        cnav["highlight-as-current"]))
     },
     "parent"   => lambda{|ctx, p|
      p = (p.nil?) ? {} : p
      if p["page"] and p["page"]["nav"] and p["page"]["nav"]["original"] then
       p_original_nav = p["page"]["nav"]["original"]
      end
      if p_original_nav and p_original_nav["highlight"]
       nav_highlight = p_original_nav["highlight"]
       nav_highlight_no_end_slash = nav_highlight.gsub(/(\/)$/, "")
       (nav_highlight_no_end_slash+"/").start_with?(slug_no_end_slash+"/")
      else
       ctx["page"]["url"].start_with?(slug_no_end_slash+"/")
      end
     },
     "slug"     => slug,
     "title"    => title,
     "dir"      => File.dirname(page["url"]),
     "original" => original_nav,
     "children" => children,
     "has_children" => children.length > 0
    }})
    page["nav"]["has_children"] = children.collect {|p|
     if p["page"] and p["page"]["nav"] and p["page"]["nav"]["original"] then
      p_original_nav = p["page"]["nav"]["original"]
      next if p_original_nav["show"] == false or p_original_nav["hide"] == true
     end
     p
    }.delete_if {|p| p.nil?}.length > 0
    {
     "slug" => slug, "page" => page, "children" => children,
     "page_basic" => lambda {|ctx|
      page_basic = Jekyll::Utils::deep_merge_hashes(page, {})
      page_basic.delete("content")
      pbnav = page_basic["nav"]
      pbnav.delete("children")
      page_basic = page_basic.merge({ "nav" => pbnav.merge(pbnav) { |k, v, unused|
       (v.is_a? Proc) ? v.call(ctx, @@url_map[ctx["page"]["url"]]) : v
      }})
     }
    }
   }.delete_if {|p| p.nil?}.sort {|a, b|
    self.sort_key(a) <=> self.sort_key(b)
   }.each {|p|
    @@url_map[p["page"]["url"]] = p
   }
  end
 end
end

Liquid::Template.register_tag("sitenav", Jekyll::SiteNavigationTag)
Liquid::Template.register_tag("sitenavlevel", Jekyll::SiteNavigationLevelTag)
Liquid::Template.register_tag("sitenavpageinfo", Jekyll::SiteNavigationPageInfoTag)
