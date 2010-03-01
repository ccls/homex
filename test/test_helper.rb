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
Html::Test::Validator.w3c_url = "http://localhost/w3c-validator/check"
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
		u
	end

	def admin_user(options={})
		u = active_user(options.merge(:role_name => "administrator"))
		u
	end

	def login_as( user=nil )
#	def login_as( user='1' )
#	def login_as( user=1 )
#		User.find_or_create_by_uid(uid)

		@request.session[:calnetuid] = case 
			when user.is_a?(Integer) then user
			when user.is_a?(String)  then user	#	User.find_by_uid(user).uid
#				if user.to_i.to_s == user
#					User.find(user).uid
#				else
#					User.find_by_login(user).id
#				end
			when user.is_a?(User)    then user.uid
			else 1
		end

		#	only one of these is necessary, but do both so works regardless
		CASClient::Frameworks::Rails::Filter.stubs(:filter).returns(true)
		CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(true)
	end
	alias :login  :login_as
	alias :log_in :login_as

	#	by default, the user is NOT authenticated so make it so
	#	yeah, don't do this
#	CASClient::Frameworks::Rails::Filter.stubs(:filter).returns(false)
#	might work if made more complex
#	causes failures like 
#		<"/"> expected to be =~
#		</https:\/\/auth\-test\.berkeley\.edu\/cas\/login/>.
	#	but this is OK (no its not)
#	CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(false)

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
