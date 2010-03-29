require File.dirname(__FILE__) + '/../test_helper'

class SubjectsControllerTest < ActionController::TestCase

	test "should get index with admin login" do
		login_as admin_user
		get :index
		assert_response :success
		assert_template 'index'
	end

	test "should get index with employee login" do
		login_as active_user(:role_name => 'employee')
		get :index
		assert_response :success
		assert_template 'index'
	end

	test "should NOT get index with just login" do
		login_as active_user
		get :index
		assert_redirected_to root_path
	end

	test "should NOT get index without login" do
		get :index
		assert_redirected_to_cas_login
	end


	test "should get show with admin login" do
		subject = Factory(:subject)
		login_as admin_user
		get :show, :id => subject
		assert_response :success
		assert_template 'show'
	end

	test "should get show with employee login" do
		subject = Factory(:subject)
		login_as active_user(:role_name => 'employee')
		get :show, :id => subject
		assert_response :success
		assert_template 'show'
	end

	test "should NOT get show with just login" do
		subject = Factory(:subject)
		login_as active_user
		get :show, :id => subject
		assert_redirected_to root_path
	end

	test "should NOT get show without login" do
		subject = Factory(:subject)
		get :show, :id => subject
		assert_redirected_to_cas_login
	end

end
