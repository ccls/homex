require File.dirname(__FILE__) + '/../test_helper'

class RolesControllerTest < ActionController::TestCase

#%w( admin ).each do |cu|
#
#	test "should update with #{cu} login" do
#		login_as send(cu)
#		u = active_user
#		assert_not_equal 'employee', u.reload.role_name
#		put :update, :id => u.id, :role_name => 'employee'
#		assert_equal 'employee', u.reload.role_name
#		assert_not_nil flash[:notice]
#		assert_redirected_to user_path(assigns(:user))
#	end
#
#end
#
#	test "should NOT update without valid id" do
#		login_as admin_user
#		put :update, :id => 0, :role_name => 'employee'
#		assert_not_nil flash[:error]
#		assert_redirected_to users_path
#	end
#
#	test "should NOT update without id" do
#		login_as admin_user
#		assert_raise(ActionController::RoutingError){
#			put :update, :role_name => 'employee'
#		}
#	end
#
#	test "should NOT update self" do
#		user = admin_user
#		login_as user
#		put :update, :id => user.id, :role_name => 'employee'
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#	test "should NOT update without valid role_name" do
#		login_as admin_user
#		put :update, :id => active_user.id, :role_name => 'bogus_role_name'
#		assert_not_nil flash[:error]
#		assert_redirected_to user_path(assigns(:user))
#	end
#
#%w( employee editor active_user ).each do |cu|
#
#	test "should NOT update with #{cu} login" do
#		login_as send(cu)
#		u = active_user
#		assert_not_equal 'administrator', u.reload.role_name
#		put :update, :id => u.id, :role_name => 'administrator'
#		assert_not_equal 'administrator', u.reload.role_name
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#end
#
#	test "should NOT update without login" do
#		put :update, :id => active_user.id, :role_name => 'administrator'
#		assert_redirected_to_login
#	end

end
