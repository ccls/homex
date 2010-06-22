require 'rdoc'
require 'rdoc/rdoc'
#require 'rake'
#require 'rake/testtask'
require 'rake/rdoctask'
require File.dirname(__FILE__) + '/../../lib/rdoc_rails'

# Load Rails rakefile extensions
Dir["#{File.dirname(__FILE__)}/*.rake"].each { |ext| load ext }
