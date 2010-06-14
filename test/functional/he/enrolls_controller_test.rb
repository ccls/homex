require File.dirname(__FILE__) + '/../../test_helper'

class He::EnrollsControllerTest < ActionController::TestCase

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


	test "should download csv with admin login" do
		login_as admin
		get :index, :commit => 'download'
		assert_response :success
		assert_not_nil @response.headers['Content-disposition'].match(/attachment;.*csv/)
	end

	test "should update selected with admin login" do
		login_as admin
		put :update_select, :date => Time.now,
			:subjects => { }
		assert_response :redirect
		assert_match he_enrolls_path, @response.redirected_to
	end

	test "should NOT update selected without login" do
		put :update_select, :date => Time.now,
			:subjects => { }
		assert_redirected_to_login
	end

end
