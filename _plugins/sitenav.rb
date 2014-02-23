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
 
 class SiteNavigationTag < Liquid::Block
  include Liquid::StandardFilters
  
  @@tree = []
  @@child_list = {}
  
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
  
  private
  
  def generate_output(tree, context, template, level=0)
   return if tree == nil or tree.empty?
   pages = tree.collect do |i|
    nav = i["page"]["nav"]
    i["page"].merge({ "nav" => nav.merge(nav) { |k, v, unused|
     if k == "children"
      generate_output(v, context, template, level + 1)
     else
      (v.is_a? Proc) ? v.call(context) : v
     end
    }})
   end
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
    next if original_nav["show"] == false or original_nav["hide"] == true
    @@child_list[slug] = children = self.make_tree(site, slug_no_end_slash)
    page = page.deep_merge({"nav" => {
     "current"  => lambda {|ctx|
      cnav = (ctx["page"]["nav"].nil?) ? {} : ctx["page"]["nav"]
      (ctx["page"]["url"] == page["url"] or
       [page["url"], slug].include? cnav["highlight"])
     },
     "parent"   => lambda{|ctx|
      ctx["page"]["url"].start_with?(slug_no_end_slash+"/")
     },
     "slug"     => slug,
     "title"    => (not page["title"].nil?) ? page["title"] : slug,
     "dir"      => File.dirname(page["url"]),
     "original" => original_nav,
     "children" => children,
     "has_children" => children.length > 0
    }})
    {"slug" => slug, "page" => page, "children" => children}
   }.delete_if {|p| p.nil?}.sort {|a, b|
    self.sort_key(a) <=> self.sort_key(b)
   }
  end
 end
end

Liquid::Template.register_tag("sitenav", Jekyll::SiteNavigationTag)
Liquid::Template.register_tag("sitenavlevel", Jekyll::SiteNavigationLevelTag)
