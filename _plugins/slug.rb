module Jekyll
 class SlugTag < Liquid::Tag
  include Liquid::StandardFilters
  
  def initialize(tag_name, url, tokens)
   super
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
   SlugTag.to_slug((url == "") ? context["page"]["url"] : url)
  end
  
  def self.to_slug(url)
   slug = url.gsub(/\/index\.([^\/.]+)$/, "/")
   return (not slug.empty?) ? slug : "/"
  end
 end
 
 class SlugForTag < Liquid::Block
  include Liquid::StandardFilters
  
  def render(context)
   SlugTag.to_slug(super.strip)
  end
 end
end

Liquid::Template.register_tag("slug", Jekyll::SlugTag)
Liquid::Template.register_tag("slugfor", Jekyll::SlugForTag)
