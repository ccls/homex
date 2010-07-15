ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

$LOAD_PATH.unshift File.dirname(__FILE__) # NEEDED for rake test:coverage
require 'factory_test_helper'
require 'package_test_helper'

#	Using default validation settings from within the 
#	html_test and html_test_extension plugins

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

	def assert_layout(layout)
		layout = "layouts/#{layout}" unless layout.match(/^layouts/)
		assert_equal layout, @response.layout
	end

end
