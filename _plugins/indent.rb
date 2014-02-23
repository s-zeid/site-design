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
