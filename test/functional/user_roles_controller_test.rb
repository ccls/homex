require File.dirname(__FILE__) + '/../test_helper'

class UserRolesControllerTest < ActionController::TestCase

	test "should update with admin login" do
		login_as admin_user
		put :update, :id => active_user.id, :role_name => 'employee'
		assert_not_nil flash[:notice]
		assert_redirected_to user_path(assigns(:user))
	end

	test "should NOT update witout valid id" do
		login_as admin_user
		put :update, :id => 0, :role_name => 'employee'
		assert_not_nil flash[:error]
		assert_redirected_to users_path
	end

	test "should NOT update without id" do
		login_as admin_user
		assert_raise(ActionController::RoutingError){
			put :update, :role_name => 'employee'
		}
	end

	test "should NOT update self" do
		user = admin_user
		login_as user
		put :update, :id => user.id, :role_name => 'employee'
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT update without valid role_name" do
		login_as admin_user
		put :update, :id => active_user.id, :role_name => 'bogus_role_name'
		assert_not_nil flash[:error]
		assert_redirected_to user_path(assigns(:user))
	end

	test "should NOT update without admin login" do
		login_as active_user
		put :update, :id => active_user.id, :role_name => 'administrator'
		assert_redirected_to user_path(assigns(:user))
	end

	test "should NOT update without login" do
		put :update, :id => active_user.id, :role_name => 'administrator'
		assert_redirected_to login_path
	end

end
