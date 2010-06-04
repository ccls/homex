#	I need to be more explicit about which files to require
#	because I have files of the same name in RAILS_ROOT/lib
require "#{File.dirname(__FILE__)}/../lib/integer_extension"
require "#{File.dirname(__FILE__)}/../lib/array_extension"
require "#{File.dirname(__FILE__)}/../lib/string_extension"
require "#{File.dirname(__FILE__)}/../lib/hash_extension"
require "#{File.dirname(__FILE__)}/../lib/nil_class_extension"
