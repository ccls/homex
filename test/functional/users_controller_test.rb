require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase

	test "should get users index without authentication" do
		CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(false)
		get :index
		assert_response :success
		assert assigns(:users)
	end

	test "should get user info without authentication" do
		user = Factory(:user)
		CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(false)
		get :show, :id => user.id
		assert_response :success
		assert_not_nil assigns(:user)
	end

end
