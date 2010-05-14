require File.dirname(__FILE__) + '/../test_helper'

class UserSessionsControllerTest < ActionController::TestCase

	test "should get login if NOT logged in" do
		get :new
		assert_response :success
		assert_template 'new'
	end

	test "should NOT get login if logged in" do
		login_as active_user
		get :new
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should create session if NOT logged in" do
		user = active_user
		post :create, :user_session => {
			:username => user.username,
			:password => 'test'
		}
		assert_redirected_to root_path
	end

	test "should NOT create session if logged in" do
		login_as active_user
		user = active_user
		post :create, :user_session => {
			:username => user.username,
			:password => 'test'
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT create session without username and password" do
		post :create, :user_session => { }
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create session without password" do
		user = active_user
		post :create, :user_session => {
			:username => user.username
		}
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create session without username" do
		user = active_user
		post :create, :user_session => {
			:password => 'test'
		}
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create session with bad username" do
		user = active_user
		post :create, :user_session => {
			:username => 'fake_username',
			:password => 'test'
		}
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create session with bad password" do
		user = active_user
		post :create, :user_session => {
			:username => user.username,
			:password => 'wrongpassword'
		}
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT logout if NOT logged in" do
		delete :destroy
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should logout if logged in" do
		login_as user
		delete :destroy
		assert_not_nil flash[:notice]
		assert_redirected_to root_path
	end

end
