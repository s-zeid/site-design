module Jekyll
 class LSBReleaseTag < Liquid::Tag
  include Liquid::StandardFilters
  
  @@cache = {"id" => nil, "description" => nil, "release" => nil,
             "codename" => nil}
  
  def initialize(tag_name, fields, tokens)
   super
   
   @fields = if fields.strip.empty?
    ["id", "release"]
   else
    fields.split(',').collect {|f|
     f = f.strip
     (@@cache.include?(f)) ? f : "description"
    }.uniq
   end
  end
  
  def render(context)
   @fields.collect {|f|
    unless @@cache[f]
     @@cache[f] = IO.popen(["lsb_release", "--short", "--"+f]).read.strip
     @@cache[f][0] = @@cache[f][0].upcase
    end
    @@cache[f]
   }.join(" ")
  end
 end
end

Liquid::Template.register_tag("lsbrelease", Jekyll::LSBReleaseTag)
Liquid::Template.register_tag("lsb_release", Jekyll::LSBReleaseTag)
