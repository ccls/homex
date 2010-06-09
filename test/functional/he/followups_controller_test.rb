require File.dirname(__FILE__) + '/../../test_helper'

class He::FollowupsControllerTest < ActionController::TestCase

	setup :create_home_exposure_with_subject

	test "should get index with admin login" do
#		Factory(:study_event, :description => "Home Exposure")
		login_as admin
		get :index
		assert assigns(:subjects)
		assert_response :success
		assert_template 'index'
	end

	test "should NOT get index with just login" do
		login_as user
		get :index
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT get index without login" do
		get :index
		assert_redirected_to_login
	end

end
