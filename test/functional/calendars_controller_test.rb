require File.dirname(__FILE__) + '/../test_helper'

class CalendarsControllerTest < ActionController::TestCase

	assert_access_with_login [:show], {:login => :admin}
	assert_access_with_login [:show], {:login => :employee}
	assert_no_access_with_login [:show], {:login => :active_user}

#	test "should show with admin login" do
#		login_as admin_user
#		get :show
#		assert_template 'show'
#		assert_response :success
#	end
#
#	test "should show with employee login" do
#		login_as employee
#		get :show
#		assert_template 'show'
#		assert_response :success
#	end
#
#	test "should NOT show with just user login" do
#		login_as active_user
#		get :show
#		assert_redirected_to root_path
#	end

#	test "should NOT show without login" do
#		get :show
#		assert_redirected_to_login
#	end

	assert_no_access_without_login [:show]

end
