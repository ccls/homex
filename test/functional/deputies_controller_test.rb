require File.dirname(__FILE__) + '/../test_helper'

class DeputiesControllerTest < ActionController::TestCase

#	test "should deputize user if authenticated as admin" do
#		target_user = active_user
#		user = admin_user
#		assert !target_user.is_admin?
#		log_in user.uid
#		post :create, :id => target_user.id
#		assert target_user.reload.is_admin?
#		assert_nil flash[:error]
#		assert_redirected_to users_path
#	end
#
#	test "should NOT deputize user without id" do
#		target_user = active_user
#		user = admin_user
#		assert !target_user.is_admin?
#		log_in user.uid
#		post :create
#		assert !target_user.reload.is_admin?
#		assert_not_nil flash[:error]
#		assert_redirected_to users_path
#	end
#
#	test "should NOT deputize user if only authenticated" do
#		target_user = active_user
#		user = active_user
#		assert !target_user.is_admin?
#		log_in user.uid
#		post :create, :id => target_user.id
#		assert !target_user.reload.is_admin?
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#	test "should NOT deputize user if NOT authenticated" do
#		target_user = active_user
#		user = active_user
#		assert !target_user.is_admin?
#		post :create, :id => target_user.id
#		assert !target_user.reload.is_admin?
#		assert_redirected_to_cas_login
#	end
#
#
#	test "should NOT undeputize self if authenticated as admin" do
#		user = admin_user
#		assert user.is_admin?
#		log_in user.uid
#		delete :destroy, :id => user.id
#		assert user.reload.is_admin?
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#
#
#	test "should undeputize user if authenticated as admin" do
#		target_user = admin_user
#		user = admin_user
#		assert target_user.is_admin?
#		log_in user.uid
#		delete :destroy, :id => target_user.id
#		assert !target_user.reload.is_admin?
#		assert_nil flash[:error]
#		assert_redirected_to users_path
#	end
#
#	test "should NOT undeputize user without id" do
#		target_user = admin_user
#		user = admin_user
#		assert target_user.is_admin?
#		log_in user.uid
#		assert_raise(ActionController::RoutingError){
#			delete :destroy
#		}
#		assert target_user.reload.is_admin?
#		assert_response :success	#	irrelevant since there is no route
#	end
#
#	test "should NOT undeputize user if only authenticated" do
#		target_user = admin_user
#		user = active_user
#		assert target_user.is_admin?
#		log_in user.uid
#		delete :destroy, :id => target_user.id
#		assert target_user.reload.is_admin?
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#	test "should NOT undeputize user if NOT authenticated" do
#		target_user = admin_user
#		user = active_user
#		assert target_user.is_admin?
#		delete :destroy, :id => target_user.id
#		assert target_user.reload.is_admin?
#		assert_redirected_to_cas_login
#	end
#
#
#
#	test "should get deputies if authenticated as admin" do
#		user = admin_user
#		log_in user.uid
#		get :index
#		assert_response :success
#	end
#
#	test "should NOT get deputies if only authenticated" do
#		log_in
#		get :index
#		assert_redirected_to root_path
#	end
#
#	test "should NOT get deputies if NOT authenticated" do
#		get :index
#		assert_redirected_to_cas_login
#	end

end
