ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

$LOAD_PATH.unshift File.dirname(__FILE__) # NEEDED for rake test:coverage
require 'factory_test_helper'

#	Using default validation settings from within the 
#	html_test and html_test_extension plugins

class ActiveSupport::TestCase

	self.use_transactional_fixtures = true
	self.use_instantiated_fixtures  = false
	fixtures :all

	include FactoryTestHelper

#	def active_user(options={})
#		u = Factory(:user, options)
#	end
#
#	def admin_user(options={})
#		u = active_user(options.merge(:role_name => "administrator"))
#	end

	def login_as( user=nil )
		uid = ( user.is_a?(User) ) ? user.uid : user
		if !uid.blank?
			@request.session[:calnetuid] = uid
			stub_ucb_ldap_person()
			User.find_create_and_update_by_uid(uid)
	
			CASClient::Frameworks::Rails::Filter.stubs(
				:filter).returns(true)
			CASClient::Frameworks::Rails::GatewayFilter.stubs(
				:filter).returns(true)
		end
	end
	alias :login  :login_as
	alias :log_in :login_as

	def stub_ucb_ldap_person(options={})
		UCB::LDAP::Person.stubs(:find_by_uid).returns(
			UCB::LDAP::Person.new({
				:sn => ["Wendt"],
				:displayname => ["Mr. Jake Wendt, BA"],
				:telephonenumber => ["+1 510 642-9749"],
				:mail => []
			})
		)
		#	Load schema locally for offline testing.
		#	This will generate this warning...
		#		Warning: schema loading from file
		#	from ucb_ldap-1.3.2/lib/ucb_ldap_schema.rb
		#	Comment this out to get the schema from Cal.
		#	This will generate this warning...
		#		warning: peer certificate won't be verified in this SSL session
		UCB::LDAP::Schema.stubs(
			:load_attributes_from_url).raises(StandardError)
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

	def assert_redirected_to_cas_login
		assert_response :redirect
		assert_match "https://auth-test.berkeley.edu/cas/login",
			@response.redirected_to
	end
	alias :assert_redirected_to_login :assert_redirected_to_cas_login

	def assert_redirected_to_cas_logout
		assert_response :redirect
		assert_match "https://auth-test.berkeley.edu/cas/logout", 
			@response.redirected_to
	end
	alias :assert_redirected_to_logout :assert_redirected_to_cas_logout

	#	by default, the user is NOT authenticated so make it so
	#	They actually need to be in setup
	def setup
		#	Filter redirects on failure, doesn't just return false
		#	Doing this stub will make the app think that the user
		#	is logged in but there won't actually be a user
		#	making all of the may_*_required filters fail
		#	with ...
		#	NoMethodError: undefined method `may_*?' for :false:Symbol
		#CASClient::Frameworks::Rails::Filter.stubs(:filter).returns(false)
		CASClient::Frameworks::Rails::GatewayFilter.stubs(
			:filter).returns(false)
#		CASClient::Frameworks::Rails::Filter.stubs(:login_url).returns(
#			"https://auth-test.berkeley.edu/cas/login")
	end


#	def full_response(options={})
#		survey = Factory(:survey)
#		survey_section = Factory(:survey_section, :survey => survey)
#		question = Factory(:question, { 
#			:survey_section => survey_section }.merge(options[:question]||{}))
#		answer = Factory(:answer, { :question => question,
#			:response_class => "answer" }.merge(options[:answer]||{}))
#		response_set = Factory(:response_set, {
#			:survey => survey}.merge(options[:response_set]||{}))
#		response = Factory(:response, {
#			:response_set => response_set,
#			:question => question, 
#			:answer => answer}.merge(options[:response]||{})
#		)
#	end
#
#	def full_response_set(options={})
#		survey = if options[:survey].is_a?(Survey)
#			options[:survey]
#		else
#			#	assuming that its a hash
#			Factory(:survey, options[:survey] )
#		end
#		survey_section = Factory(:survey_section, :survey => survey)
#
#
#
#
#
#		response_set = Factory(:response_set, {
#			:survey => survey}.merge(options[:response_set]||{}))
#
#
#
#
#		response_set
#	end

end
