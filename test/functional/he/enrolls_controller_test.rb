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

%w( admin employee editor ).each do |u|

	test "should download csv with #{u} login" do
		login_as send(u)
		get :index, :commit => 'download'
		assert_response :success
		assert_not_nil @response.headers['Content-disposition'].match(/attachment;.*csv/)
	end

	test "should get send_letters with #{u} login" do
		login_as send(u)
		get :send_letters
		assert_response :success
		assert_template 'send_letters'
	end

	test "should update selected with #{u} login" do
		login_as send(u)
		put :update_select, :date => Time.now,
			:subjects => { }
		assert_response :redirect
		assert_match he_enrolls_path, @response.redirected_to
	end

end

%w( active_user ).each do |u|

	test "should NOT download csv with #{u} login" do
		login_as send(u)
		get :index, :commit => 'download'
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should NOT get send_letters with #{u} login" do
		login_as send(u)
		get :send_letters
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should NOT update selected with #{u} login" do
		login_as send(u)
		put :update_select, :date => Time.now,
			:subjects => { }
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

end

	test "should NOT download csv without login" do
		get :index, :commit => 'download'
		assert_redirected_to_login
	end

	test "should NOT get send_letters without login" do
		get :send_letters
		assert_redirected_to_login
	end

	test "should NOT update selected without login" do
		put :update_select, :date => Time.now,
			:subjects => { }
		assert_redirected_to_login
	end

end
