require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase

	test "should logout if authenticated" do
		log_in
		delete :destroy
		assert_redirected_to_cas_logout
	end

	test "should NOT logout if NOT authenticated" do
		delete :destroy
		assert_redirected_to_cas_login
	end

end
