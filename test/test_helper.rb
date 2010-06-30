ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

$LOAD_PATH.unshift File.dirname(__FILE__) # NEEDED for rake test:coverage
require 'factory_test_helper'
require 'package_test_helper'

require 'pending'
require 'declarative'
require 'no_access_without_login'
require 'no_access_with_login'
require 'access_without_login'
require 'access_with_login'
require 'access_with_https'
require 'access_with_http'
require 'no_access_with_http'
require 'requires_valid_associations'

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

class ActionController::TestCase

	setup :turn_https_on

	def turn_https_on
		@request.env['HTTPS'] = 'on'
#		@request.env['HTTP_X_FORWARDED_PROTO'] == 'https'
	end

	def turn_https_off
		@request.env['HTTPS'] = nil
	end

end

#class ActionController::TestRequest
#	def ssl?
#		true
#	end
#end
