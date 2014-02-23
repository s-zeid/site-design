module GSubFilter
 # https://github.com/Shopify/liquid/issues/202#issuecomment-19112872
 def gsub(input, regex, replacement = '', options = "")
  options_num = 0
  options_num |= Regexp::IGNORECASE if options =~ /i/i
  options_num |= Regexp::MULTILINE if options =~ /m/i
  options_num |= Regexp::EXTENDED if options =~ /x/i
  input.to_s.gsub(Regexp.new(regex, options_num), replacement.to_s)
 end
end

Liquid::Template.register_filter(GSubFilter)
