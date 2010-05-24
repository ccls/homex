ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

$LOAD_PATH.unshift File.dirname(__FILE__) # NEEDED for rake test:coverage
require 'factory_test_helper'

require 'pending'
require 'declarative'

#	Using default validation settings from within the 
#	html_test and html_test_extension plugins

require 'authlogic/test_case'
class ActionController::TestCase
	setup :activate_authlogic
end

class ActiveSupport::TestCase

	self.use_transactional_fixtures = true
	self.use_instantiated_fixtures  = false
	fixtures :all

	include FactoryTestHelper

	def login_as( user )
		u = User.find(user)
		UserSession.create(u)
	end
	alias :login  :login_as
	alias :log_in :login_as

#	def stub_ucb_ldap_person(options={})
#		UCB::LDAP::Person.stubs(:find_by_uid).returns(
#			UCB::LDAP::Person.new({
#				:sn => ["Wendt"],
#				:displayname => ["Mr. Jake Wendt, BA"],
#				:telephonenumber => ["+1 510 642-9749"],
#				:mail => []
#			})
#		)
#		#	Load schema locally for offline testing.
#		#	This will generate this warning...
#		#		Warning: schema loading from file
#		#	from ucb_ldap-1.3.2/lib/ucb_ldap_schema.rb
#		#	Comment this out to get the schema from Cal.
#		#	This will generate this warning...
#		#		warning: peer certificate won't be verified in this SSL session
#		UCB::LDAP::Schema.stubs(
#			:load_attributes_from_url).raises(StandardError)
#	end

	def stub_package_for_in_transit(options={})
		ActiveMerchant::Shipping::TrackingResponse.any_instance.stubs(
			:latest_event).returns(
			ActiveMerchant::Shipping::ShipmentEvent.new(
				'Departed',
				Time.now,
				ActiveMerchant::Shipping::Location.new({
					:city => 'BERKELEY',
					:state => 'CA',
					:zip => '94703'
				})
			)
		)
		ActiveMerchant::Shipping::FedEx.any_instance.stubs(
			:find_tracking_info).returns(
				ActiveMerchant::Shipping::TrackingResponse.new(true ,'hello')
		)
	end

	def stub_package_for_successful_delivery(options={})
		ActiveMerchant::Shipping::TrackingResponse.any_instance.stubs(
			:latest_event).returns(
			ActiveMerchant::Shipping::ShipmentEvent.new(
				'Delivered',
				Time.now,
				ActiveMerchant::Shipping::Location.new({
					:city => 'BERKELEY',
					:state => 'CA',
					:zip => '94703'
				})
			)
		)
		ActiveMerchant::Shipping::FedEx.any_instance.stubs(
			:find_tracking_info).returns(
				ActiveMerchant::Shipping::TrackingResponse.new(true ,'hello')
		)
	end

	def stub_package_for_failure(options={})
		ActiveMerchant::Shipping::FedEx.any_instance.stubs(
			:find_tracking_info).raises(
				ActiveMerchant::Shipping::ResponseError)
	end

#	def assert_redirected_to_cas_login
##		assert_response :redirect
##		assert_match "https://auth-test.berkeley.edu/cas/login",
##			@response.redirected_to
#		assert_redirected_to login_path
#	end
#	alias :assert_redirected_to_login :assert_redirected_to_cas_login

#	def assert_redirected_to_cas_logout
#		assert_response :redirect
#		assert_match "https://auth-test.berkeley.edu/cas/logout", 
#			@response.redirected_to
#	end
#	alias :assert_redirected_to_logout :assert_redirected_to_cas_logout

end
