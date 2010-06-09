ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

$LOAD_PATH.unshift File.dirname(__FILE__) # NEEDED for rake test:coverage
require 'factory_test_helper'
require 'package_test_helper'

require 'pending'
require 'declarative'
require 'no_access_without_login'
#require 'full_access_with_admin_login'

#	Using default validation settings from within the 
#	html_test and html_test_extension plugins

#require 'authlogic_test_helper'
require 'ucb_cas_test_helper'

class ActiveSupport::TestCase

	self.use_transactional_fixtures = true
	self.use_instantiated_fixtures  = false
	fixtures :all

	include FactoryTestHelper

end
