require File.dirname(__FILE__) + '/../test_helper'

class PagesControllerTest < ActionController::TestCase

	test "should get pages if authenticated" do
		log_in
		get :index
		assert_response :success
		assert_match "Logout", @response.body
	end

	test "should get pages if NOT authenticated" do
		CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(false)
		get :index
		assert_response :success
		assert_match "Login", @response.body
	end

end
