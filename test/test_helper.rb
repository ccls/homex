ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

#	begin html_test plugin settings
ApplicationController.validate_all = true
#       default is :tidy, but it doesn't really validate.       
#       I've purposely not closed tags and it doesn't complain.
#       :w3c is ridiculously slow! even when used locally
ApplicationController.validators = [:w3c]
#ApplicationController.validators = [:tidy, :w3c]
Html::Test::Validator.verbose = false
#       http://habilis.net/validator-sac/
#       http://habilis.net/validator-sac/#advancedtopics
begin
	#	This will raise an error if Web Sharing is not on
	response = Net::HTTP.get_response('localhost','/w3c-validator/check')
	Html::Test::Validator.w3c_url = "http://localhost/w3c-validator/check"
rescue
	#	Do validation online
end
Html::Test::Validator.tidy_ignore_list = [/<table> lacks "summary" attribute/]
#	end html_test plugin settings


class ActiveSupport::TestCase
	# Transactional fixtures accelerate your tests by wrapping each test method
	# in a transaction that's rolled back on completion.  This ensures that the
	# test database remains unchanged so your fixtures don't have to be reloaded
	# between every test method.  Fewer database queries means faster tests.
	#
	# Read Mike Clark's excellent walkthrough at
	#   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
	#
	# Every Active Record database supports transactions except MyISAM tables
	# in MySQL.  Turn off transactional fixtures in this case; however, if you
	# don't care one way or the other, switching from MyISAM to InnoDB tables
	# is recommended.
	#
	# The only drawback to using transactional fixtures is when you actually 
	# need to test transactions.  Since your test is bracketed by a transaction,
	# any transactions started in your code will be automatically rolled back.
#	I don't use fixtures
#	self.use_transactional_fixtures = true

	# Instantiated fixtures are slow, but give you @david where otherwise you
	# would need people(:david).  If you don't want to migrate your existing
	# test cases which use the @david style and don't mind the speed hit (each
	# instantiated fixtures translates to a database query per test method),
	# then set this back to true.
#	I don't use fixtures
#	self.use_instantiated_fixtures  = false

	# Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
	#
	# Note: You'll currently still have to declare fixtures explicitly in integration tests
	# -- they do not yet inherit this setting
#	I don't use fixtures
#	fixtures :all

	# Add more helper methods to be used by all tests here...

	def active_user(options={})
		u = Factory(:user, options)
	end

	def admin_user(options={})
		u = active_user(options.merge(:role_name => "administrator"))
	end

	def login_as( user=nil )
		uid = ( user.is_a?(User) ) ? user.uid : user
		@request.session[:calnetuid] = uid
		User.find_create_and_update_by_uid(uid)

		CASClient::Frameworks::Rails::Filter.stubs(:filter).returns(true)
		CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(true)
	end
	alias :login  :login_as
	alias :log_in :login_as


	UCB::LDAP::Person.stubs(:find_by_uid).returns(UCB::LDAP::Person.new({
#		:sn => ["Wendt"],
#		:displayname => ["Mr. Jake Wendt, BA"],
#		:telephonenumber => ["+1 510 642-9749"],
#		:mail => []
	}))
	#	by default, the user is NOT authenticated so make it so
	CASClient::Frameworks::Rails::Filter.stubs(:filter).returns(false)
	CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(false)
	CASClient::Frameworks::Rails::Filter.stubs(:login_url).returns("https://auth-test.berkeley.edu/cas/login")

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

#UCB::LDAP::Person.new({{:berkeleyeduunitcalnetdeptname=>["Pub Hlth-Buffler Group"], :postaladdress=>["1995 University Ave$Berkeley, CA 94704-7392"], :berkeleyeduprimarydeptunithierarchystring=>["UCBKL-EVCP2-SC1PH-CPSPH"], :objectclass=>["top", "person", "organizationalperson", "inetorgperson", "berkeleyEduPerson", "eduPerson", "ucEduPerson"], :dn=>["uid=859908,ou=people,dc=berkeley,dc=edu"], :berkeleyedumoddate=>["20100303182542Z"], :berkeleyedunamesalutation=>["Mr."], :st=>["CA"], :berkeleyeduprimarydeptunit=>["CPSPH"], :sn=>["Wendt"], :street=>["1995 University Ave"], :berkeleyedunamehonorifics=>["BA"], :o=>["University of California, Berkeley"], :facsimiletelephonenumber=>["+1 510 643-1735"], :ou=>["people"], :berkeleyedudeptunithierarchystring=>["UCBKL-EVCP2-SC1PH-CPSPH"], :givenname=>["Jake", "George"], :l=>["Berkeley"], :telephonenumber=>["+1 510 642-9749"], :departmentnumber=>["CPSPH"], :roomnumber=>["460"], :title=>["Applications Programmer 3"], :uid=>["859908"], :berkeleyeduaffiliations=>["EMPLOYEE-TYPE-STAFF"], :cn=>["Wendt, Jake", "Wendt, George A"], :displayname=>["Mr. Jake Wendt, BA"], :postalcode=>["94704"], :berkeleyeduunithrdeptname=>["School of Public Health"]})

end
