ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

##################################################
#	begin html_test plugin settings
validate = false
validators = ["http://localhost/w3c-validator/check", 
							Html::Test::Validator.w3c_url]

validators.each do |validator|
	vhost = validator.split('/')[2]
	vpath = "/"<< validator.split('/')[3..-1].join('/')
	begin
		response = Net::HTTP.get_response(vhost, vpath)
		if response.code == '200'
			Html::Test::Validator.w3c_url = validator
			validate = true
			break
		end
	rescue
	end
end

if validate
	ApplicationController.validate_all = true
	#       default is :tidy, but it doesn't really validate.       
	#       I've purposely not closed tags and it doesn't complain.
	#       :w3c is ridiculously slow! even when used locally
	ApplicationController.validators = [:w3c]
	#ApplicationController.validators = [:tidy, :w3c]
	Html::Test::Validator.verbose = false
	Html::Test::Validator.tidy_ignore_list = [/<table> lacks "summary" attribute/]
	puts "Validating all html with " <<
		Html::Test::Validator.w3c_url
else
	puts "NOT validating html at all"
end
#	end html_test plugin settings
##################################################

class ActiveSupport::TestCase

	def active_user(options={})
		u = Factory(:user, options)
	end

	def admin_user(options={})
		u = active_user(options.merge(:role_name => "administrator"))
	end

	def login_as( user=nil )
		uid = ( user.is_a?(User) ) ? user.uid : user
		if !uid.blank?
			@request.session[:calnetuid] = uid
			stub_ucb_ldap_person()
			User.find_create_and_update_by_uid(uid)
	
			CASClient::Frameworks::Rails::Filter.stubs(:filter).returns(true)
			CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(true)
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
		UCB::LDAP::Schema.stubs(:load_attributes_from_url).raises(StandardError)
	end

	def stub_fedex_find_tracking_info(options={})
		ActiveMerchant::Shipping::TrackingResponse.any_instance.stubs(:latest_event).returns(
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
		ActiveMerchant::Shipping::FedEx.any_instance.stubs(:find_tracking_info).returns(
			ActiveMerchant::Shipping::TrackingResponse.new(true ,'hello')
		)
	end

#	I need to define a initialize or setup to add these stubs
#	def setup
#		CASClient::Frameworks::Rails::Filter.stubs(:filter).returns(false)
#		CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(false)
#		CASClient::Frameworks::Rails::Filter.stubs(:login_url).returns("https://auth-test.berkeley.edu/cas/login")
##		super
#	end
	

	#	by default, the user is NOT authenticated so make it so
#	These are ignored too
#	CASClient::Frameworks::Rails::Filter.stubs(:filter).returns(false)
#	CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(false)
#	CASClient::Frameworks::Rails::Filter.stubs(:login_url).returns("https://auth-test.berkeley.edu/cas/login")

	def assert_redirected_to_cas_login
		assert_response :redirect
		assert_match "https://auth-test.berkeley.edu/cas/login", @response.redirected_to
	end
	alias :assert_redirected_to_login :assert_redirected_to_cas_login

	def assert_redirected_to_cas_logout
		assert_response :redirect
		assert_match "https://auth-test.berkeley.edu/cas/logout", @response.redirected_to
	end
	alias :assert_redirected_to_logout :assert_redirected_to_cas_logout

end
