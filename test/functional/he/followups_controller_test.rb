require File.dirname(__FILE__) + '/../../test_helper'

class He::FollowupsControllerTest < ActionController::TestCase

	setup :create_home_exposure_with_subject

	assert_access_with_login [:index],{
		:login => :admin}
	assert_access_with_login [:index],{
		:login => :employee}
	assert_access_with_login [:index],{
		:login => :editor}
	assert_no_access_with_login [:index],{
		:login => :active_user}
	assert_no_access_without_login [:index]

#	test "should get index with admin login" do
#		login_as admin
#		get :index
#		assert assigns(:subjects)
#		assert_response :success
#		assert_template 'index'
#	end

	test "should download csv with admin login" do
		login_as admin
		get :index, :commit => 'download'
		assert_response :success
		assert_not_nil @response.headers['Content-disposition'].match(/attachment;.*csv/)
	end

#	test "should NOT get index with just login" do
#		login_as user
#		get :index
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end

#	test "should NOT get index without login" do
#		get :index
#		assert_redirected_to_login
#	end

end
