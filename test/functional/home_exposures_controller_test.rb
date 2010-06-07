require File.dirname(__FILE__) + '/../test_helper'

class HomeExposuresControllerTest < ActionController::TestCase

	test "should get with admin login" do
		login_as admin
		get :show
		assert_response :success
		assert_template 'show'
	end

	test "should NOT get without admin login" do
		login_as user
		get :show
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT get without login" do
		get :show
		assert_not_nil flash[:error]
		assert_redirected_to_login
	end

end
