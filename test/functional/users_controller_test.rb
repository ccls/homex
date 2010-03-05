require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase

	test "should NOT get users index without login" do
#		CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(false)
		get :index
		assert_redirected_to_cas_login
	end

	test "should NOT get users index without admin login" do
		login_as active_user
		get :index
		assert_redirected_to root_path
	end

	test "should get users index with admin login" do
		login_as admin_user
		get :index
		assert_response :success
	end




	test "should NOT get user info without login" do
#		CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(false)
		user = active_user
		get :show, :id => user.id
		assert_redirected_to_cas_login
	end

	test "should NOT get user info without admin login" do
		login_as active_user
		get :show, :id => active_user.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
#		assert_nil assigns(:user)
	end

	test "should NOT get user info with invalid id" do
		login_as admin_user
		get :show, :id => 0
		assert_not_nil flash[:error]
		assert_redirected_to users_path
	end

	test "should get user info with admin login" do
		login_as admin_user
		get :show, :id => active_user.id
		assert_response :success
		assert_not_nil assigns(:user)
	end

	test "should get user info with self login" do
		user = active_user
		login_as user
		get :show, :id => user.id
		assert_response :success
		assert_not_nil assigns(:user)
	end



	test "should update with admin login" do
		login_as admin_user
		put :update, :id => active_user.id, :role_name => 'employee'
		assert_not_nil flash[:notice]
		assert_redirected_to user_path(assigns(:user))
	end

	test "should NOT update self" do
		user = admin_user
		login_as user
		put :update, :id => user.id, :role_name => 'employee'
		assert_not_nil flash[:error]
#		assert_response :success
#		assert_template 'show'
		assert_redirected_to root_path
	end

	test "should NOT update without valid role_name" do
		login_as admin_user
		put :update, :id => active_user.id, :role_name => 'bogus_role_name'
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'show'
	end

	test "should NOT update without admin login" do
		login_as active_user
		put :update, :id => active_user.id, :role_name => 'administrator'
#		assert_response :success
#		assert_template 'show'
#		assert_redirected_to root_path
		assert_redirected_to user_path(assigns(:user))
	end

	test "should NOT update without login" do
		put :update, :id => active_user.id, :role_name => 'administrator'
		assert_redirected_to_cas_login
	end


end
