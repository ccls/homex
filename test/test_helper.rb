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

	def assert_subject_is_eligible(subject)
		assert_nil   subject.hx_enrollment.ineligible_reason_id
		assert_equal subject.hx_enrollment.is_eligible, YNDK[:yes]
	end

	def assert_subject_is_not_eligible(subject)
		assert_not_nil subject.hx_enrollment.ineligible_reason_id
		assert_equal   subject.hx_enrollment.is_eligible, YNDK[:no]
	end

end

class ActionController::TestCase

	setup :turn_https_on

	def assert_layout(layout)
		layout = "layouts/#{layout}" unless layout.match(/^layouts/)
		assert_equal layout, @response.layout
	end

end
