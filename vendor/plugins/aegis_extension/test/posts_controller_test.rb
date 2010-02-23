require File.dirname(__FILE__) + '/test_helper'
require 'application_controller'
require 'posts_controller'

ActionController::Routing::Routes.draw do |map|
	map.resources :posts
end

class PostsControllerTest < ActionController::TestCase

	def setup
		setup_db
	end

	def teardown
		teardown_db
	end

	test "anyone can view post index" do
		get :index
		assert_response :success
	end

	test "anyone can view post" do
		p = Post.create(:user_id => User.create.id)
		get :show, :id => p.id
		assert_response :success
	end

	test "logged in user can get new post" do
		login_as User.create
		get :new
		assert_response :success
	end

	test "guest can NOT create new post" do
		get :new
		assert_not_nil flash[:error]
		assert_response :redirect
		assert_redirected_to "/"
	end

	test "owner can edit" do
		u = User.create
		login_as u
		p = Post.create(:user_id => u.id)
		get :edit, :id => p.id
		assert_response :success
	end

	test "non-owner cannot edit" do
		login_as User.create
		p = Post.create(:user_id => User.create.id)
		get :edit, :id => p.id
		assert_not_nil flash[:error]
		assert_response :redirect
		assert_redirected_to "/"
	end

	test "owner can destroy" do
		u = User.create
		login_as u
		p = Post.create(:user_id => u.id)
		delete :destroy, :id => p.id
		assert_response :success
	end

	test "non-owner cannot destroy" do
		login_as User.create
		p = Post.create(:user_id => User.create.id)
		delete :destroy, :id => p.id
		assert_not_nil flash[:error]
		assert_response :redirect
		assert_redirected_to "/"
	end

end
