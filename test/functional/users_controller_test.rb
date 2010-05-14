require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase

	test "should NOT get users index without login" do
		get :index
		assert_redirected_to login_path
	end

	test "should NOT get users index without admin login" do
		login_as active_user
		get :index
		assert_redirected_to root_path
	end

	test "should get users index with admin login" do
		login_as admin_user
		get :index
		assert_nil flash[:error]
		assert_response :success
	end

	test "should filter users index by role" do
		login_as admin_user
		get :index, :role_name => 'administrator'
		assert_nil flash[:error]
		assert_response :success
	end

	test "should NOT filter users index by invalid role" do
		login_as admin_user
		get :index, :role_name => 'suffocator'
		assert_not_nil flash[:error]
		assert_response :success
	end




	test "should NOT get user info without login" do
		u = active_user
		get :show, :id => u.id
		assert_redirected_to login_path
	end

	test "should NOT get user info without admin login" do
		login_as active_user
		get :show, :id => active_user.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
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




	test "should get new user without login" do
		get :new
		assert_response :success
		assert_template 'new'
	end

	test "should NOT get new user with login" do
		login_as user
		get :new
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end


	test "should create new user without login" do
		assert_difference('User.count',1) {
			post :create, :user => Factory.attributes_for(:user)
		}
		assert_not_nil flash[:notice]
		assert_redirected_to login_path	#	user_path(assigns(:user))
	end

	test "should NOT create new user with login" do
		login_as user
		assert_difference('User.count',0) {
			post :create, :user => Factory.attributes_for(:user)
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT create new user without username" do
		assert_difference('User.count',0) {
			post :create, :user => Factory.attributes_for(:user,
				:username => nil)
		}
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create new user without unique username" do
		u = Factory(:user)
		assert_difference('User.count',0) {
			post :create, :user => Factory.attributes_for(:user,
				:username => u.username)
		}
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create new user without password" do
		assert_difference('User.count',0) {
			post :create, :user => Factory.attributes_for(:user,
				:password => nil)
		}
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create new user without password confirmation" do
		assert_difference('User.count',0) {
			post :create, :user => Factory.attributes_for(:user,
				:password_confirmation => nil)
		}
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create new user without matching password and confirmation" do
		assert_difference('User.count',0) {
			post :create, :user => Factory.attributes_for(:user,
				:password => 'alpha',
				:password_confirmation => 'beta')
		}
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create new user without email" do
		assert_difference('User.count',0) {
			post :create, :user => Factory.attributes_for(:user,
				:email => nil)
		}
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create new user without formatted email" do
		assert_difference('User.count',0) {
			post :create, :user => Factory.attributes_for(:user,
				:email => 'blah blah blah')
		}
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create new user without unique email" do
		u = Factory(:user)
		assert_difference('User.count',0) {
			post :create, :user => Factory.attributes_for(:user,
				:email => u.email)
		}
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end



	test "should edit user with admin login" do
		u = user
		login_as admin
		get :edit, :id => u.id
		assert_response :success
		assert_template 'edit'
	end

	test "should edit user with self login" do
		u = user
		login_as u
		get :edit, :id => u.id
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT edit user with just user login" do
		u = user
		login_as user
		get :edit, :id => u.id
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should NOT edit user without login" do
		u = user
		get :edit, :id => u.id
		assert_redirected_to login_path
		assert_not_nil flash[:error]
	end

	test "should NOT edit user without valid id" do
		u = user
		login_as admin
		get :edit, :id => 0
		assert_redirected_to users_path
		assert_not_nil flash[:error]
	end

	test "should NOT edit user without id" do
		u = user
		login_as admin
		assert_raise(ActionController::RoutingError){
			get :edit
		}
	end




	test "should update user with self login" do
		u = user
		login_as u
		put :update, :id => u.id, :user => Factory.attributes_for(:user)
		assert_redirected_to root_path
		assert_not_nil flash[:notice]
	end

	test "should update user with admin login" do
		u = user
		login_as admin
		put :update, :id => u.id, :user => Factory.attributes_for(:user)
		assert_redirected_to root_path
		assert_not_nil flash[:notice]
	end

	test "should NOT update user with just login" do
		u = user
		login_as user
		put :update, :id => u.id, :user => Factory.attributes_for(:user)
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should NOT update user without login" do
		u = user
		put :update, :id => u.id, :user => Factory.attributes_for(:user)
		assert_redirected_to login_path
		assert_not_nil flash[:error]
	end

	test "should NOT update user without valid id" do
		u = user
		login_as admin
		put :update, :id => 0, :user => Factory.attributes_for(:user)
		assert_redirected_to users_path
		assert_not_nil flash[:error]
	end

	test "should NOT update user without id" do
		u = user
		login_as admin
		assert_raise(ActionController::RoutingError){
			put :update, :user => Factory.attributes_for(:user)
		}
	end

	test "should update user without user" do
		# kinda pointless
		u = user
		login_as admin
		put :update, :id => u.id
		assert_redirected_to root_path
		assert_not_nil flash[:notice]
	end

	test "should NOT update user without username" do
		u = user
		login_as admin
		put :update, :id => u.id, :user => Factory.attributes_for(:user,
			:username => nil)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update user without unique username" do
		u1 = Factory(:user)
		u = user
		login_as admin
		put :update, :id => u.id, :user => Factory.attributes_for(:user,
			:username => u1.username)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should update user without password" do
		#	again odd.  Having password confirmation ignored.
		u = user
		login_as admin
		put :update, :id => u.id, :user => Factory.attributes_for(:user,
			:password => nil)
		assert_redirected_to root_path
	end

	test "should NOT update user without matching password and confirmation" do
		u = user
		login_as admin
		put :update, :id => u.id, :user => Factory.attributes_for(:user,
			:password => 'alpha', :password_confirmation => 'beta')
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update user without password confirmation" do
		u = user
		login_as admin
		put :update, :id => u.id, :user => Factory.attributes_for(:user,
			:password_confirmation => nil)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end





#	Destroy  


end
