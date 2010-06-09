require File.dirname(__FILE__) + '/../test_helper'

class PermissionsControllerTest < ActionController::TestCase

	assert_no_access_without_login [:index]

#
#		index should only be visible to admins
#	

	test "should get index with admin login" do
		login_as admin_user
		get :index
		assert_template 'index'
		assert_response :success
	end

	test "should NOT get index without admin login" do
		login_as active_user
		get :index
		assert_redirected_to root_path
	end

#	test "should NOT get index without login" do
#		get :index
#		assert_redirected_to_login
#	end

end
