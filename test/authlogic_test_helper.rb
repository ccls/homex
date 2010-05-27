require 'authlogic/test_case'
class ActionController::TestCase
	setup :activate_authlogic
end

class ActiveSupport::TestCase

	def login_as( user )
		u = User.find(user)
		UserSession.create(u)
	end
	alias :login  :login_as
	alias :log_in :login_as

	def assert_redirected_to_login
		assert_redirected_to login_path
	end

	def assert_redirected_to_logout
		assert_redirected_to logout_path
	end

end
