require File.dirname(__FILE__) + '/test_helper'
require 'application_controller'
require 'users_controller'

ActionController::Routing::Routes.draw do |map|
	map.resources :users
end

class UsersControllerTest < ActionController::TestCase

	def setup
		setup_db
	end

	def teardown
		teardown_db
	end

	test "user can NOT destroy other user" do
		u = active_user
		login_as active_user
		assert_difference( 'User.count', 0 ) do
			delete :destroy, :id => u.id
		end
		assert_response :redirect
		assert_redirected_to "/"
		assert_not_nil flash[:error]
	end

	test "admin can NOT destroy self" do
		u = admin_user
		login_as u
		assert_difference( 'User.count', 0 ) do
			delete :destroy, :id => u.id
		end
		assert_response :redirect
		assert_redirected_to "http://cnn.com"
		assert_redirected_to @controller.redirections[:not_be_user][:redirect_to]
		assert_not_nil flash[:error]
		assert_equal flash[:error], @controller.redirections[:not_be_user][:message]
	end

	test "admin can destroy user" do
		u = active_user
		login_as admin_user
		assert_difference( 'User.count', -1 ) do
			delete :destroy, :id => u.id
		end
		assert_response :success
	end

end
