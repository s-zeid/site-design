# This is based on code from <http://jekyllrb.com/docs/plugins/#generators>
# (originally from <https://github.com/jekyll/jekyll/wiki/Plugins/6081f49#generators>).
# Copyright (c) 2013 Tom Preston-Werner
# MIT licensed per the site's footer.

# Modifications (c) 2012, 2015 S. Zeid and released under the X11 license.

module Jekyll
 class PostList < Page
  def initialize(site, base, dir, type, name)
   @site = site
   @base = base
   @dir = dir
   @name = 'index.html'

   self.process(@name)
   self.read_yaml(File.join(base, site.config["layouts_dir"]), 'post-list.html')

   self.data["title"]        = "#{type.capitalize}: #{name}"
   if not self.data.has_key?("nav")
    self.data["nav"] = {}
   end
   self.data["nav"]["title"] = name
   self.data[type]           = name
  end
 end

 class PostListGenerator < Generator
  safe true
  
  def generate(site)
   if site.layouts.key? 'post-list'
    [["category", "categories"], ["tag", "tags"]].each do |type|
     type, plural = *type
     dir = site.config["#{type}-dir"] || plural
     site.send(plural).keys.each do |name|
      site.pages << PostList.new(site, site.source, File.join(dir, name), type, name)
     end
    end
   end
  end
 end
end

