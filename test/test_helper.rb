ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

$LOAD_PATH.unshift File.dirname(__FILE__) # NEEDED for rake test:coverage
require 'factory_test_helper'

require 'pending'
require 'declarative'

#	Using default validation settings from within the 
#	html_test and html_test_extension plugins

require 'authlogic_test_helper'
#require 'ucb_cas_test_helper'

class ActiveSupport::TestCase

	self.use_transactional_fixtures = true
	self.use_instantiated_fixtures  = false
	fixtures :all

	include FactoryTestHelper

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

end
