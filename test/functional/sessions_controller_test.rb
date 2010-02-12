require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase

	test "should logout if authenticated" do
		log_in
		delete :destroy
		assert_response :redirect
		assert_match "https://auth-test.berkeley.edu/cas/logout", @response.redirected_to
	end

	test "should NOT logout if NOT authenticated" do
		delete :destroy
		assert_response :redirect
		assert_match "https://auth-test.berkeley.edu/cas/login", @response.redirected_to
	end

end
