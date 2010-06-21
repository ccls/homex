#	I need to be more explicit about which files to require
#	because I have files of the same name in RAILS_ROOT/lib
require "#{File.dirname(__FILE__)}/../lib/object"
require "#{File.dirname(__FILE__)}/../lib/integer"
require "#{File.dirname(__FILE__)}/../lib/array"
require "#{File.dirname(__FILE__)}/../lib/string"
require "#{File.dirname(__FILE__)}/../lib/hash"
require "#{File.dirname(__FILE__)}/../lib/nil_class"
