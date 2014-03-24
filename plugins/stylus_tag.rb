# (c) Adam Spooner
# https://gist.github.com/adamjspooner/988201#file-stylus_converter-rb
# 
# This is PROPRIETARY because it has no license.

# A Jekyll plugin to convert .styl to .css
# This plugin requires the stylus gem, do:
# $ [sudo] gem install stylus

# See _config.yml above for configuration options.

# Caveats:
# 1. Files intended for conversion must have empty YAML front matter a the top.
#    See all.styl above.
# 2. You can not @import .styl files intended to be converted.
#    See all.styl and individual.styl above.

module Jekyll
 class StylusTag < Liquid::Block
  include Liquid::StandardFilters
  
  @@setup = false
  
  def render(context)
   begin
    setup_stylus(context.registers[:site].config)
    Stylus.compile super.to_s
   rescue => e
    puts "Stylus exception in #{context["page"]["url"]}: #{e.message}"
   end
  end
  
  def setup_stylus(config)
   return if @@setup
   require 'stylus'
   if config["stylus"]
    Stylus.compress = config['stylus']['compress'] if
     config['stylus']['compress']
    Stylus.paths << config['stylus']['path'] if config['stylus']['path']
   end
   @@setup = true
  rescue LoadError
   STDERR.puts 'You are missing a library required for Stylus. Please run:'
   STDERR.puts '  $ [sudo] gem install stylus'
   raise FatalException.new('Missing dependency: stylus')
  end
 end
end

Liquid::Template.register_tag("stylus", Jekyll::StylusTag)
