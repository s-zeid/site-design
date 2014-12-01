# Ugly backport of Jekyll commit 0662d31bf63518e319c0140465aa8ac12eefc252
# (fix jsonify filter when used with boolean values)
# <https://github.com/jekyll/jekyll/commit/0662d31>
#
# From Jekyll core
# Copyright (c) 2008-2014 (this is an old version) Tom Preston-Werner
# MIT License per <https://github.com/jekyll/jekyll/blob/0662d31/LICENSE>

module Jekyll
 module Filters
  def as_liquid(item)
   case item
    when String, Numeric, true, false, nil
     item.to_liquid
    when Hash
     Hash[item.map { |k, v| [as_liquid(k), as_liquid(v)] }]
    when Array
     item.map{ |i| as_liquid(i) }
    else
     item.respond_to?(:to_liquid) ? as_liquid(item.to_liquid) : item
   end
  end
 end
end
