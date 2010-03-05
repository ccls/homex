require File.dirname(__FILE__) + '/../test_helper'

class PackagesControllerTest < ActionController::TestCase

	test "should get index with admin login" do
		login_as admin_user
		get :index
		assert_template 'index'
		assert_response :success
		assert_not_nil assigns(:packages)
	end

	test "should NOT get index without admin login" do
		login_as active_user
		get :index
		assert_redirected_to root_path
	end

	test "should NOT get index without login" do
		get :index
		assert_redirected_to_cas_login
	end


	test "should get new with admin login" do
		login_as admin_user
		get :new
		assert_template 'new'
		assert_response :success
		assert_not_nil assigns(:package)
	end

	test "should NOT get new without admin login" do
		login_as active_user
		get :new
		assert_redirected_to root_path
	end

	test "should NOT get new without login" do
		get :new
		assert_redirected_to_cas_login
	end


	test "should create with admin login" do
		login_as admin_user
		post :create, :package => Factory.attributes_for(:package)
		assert_not_nil assigns(:package)
		assert_redirected_to packages_path
	end

	test "should NOT create with invalid package" do
		login_as admin_user
		post :create, :package => {}
		assert_not_nil assigns(:package)
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create without admin login" do
		login_as active_user
		post :create, :package => Factory.attributes_for(:package)
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT create without login" do
		post :create, :package => Factory.attributes_for(:package)
		assert_redirected_to_cas_login
	end






end
