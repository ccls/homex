require File.dirname(__FILE__) + '/../../test_helper'

class He::EnrollsControllerTest < ActionController::TestCase

	setup :create_home_exposure_with_subject
	ASSERT_ACCESS_OPTIONS = {
		:actions => [:index]
	}

	assert_access_with_login({ 
		:logins => [:admin,:employee,:editor] })
	assert_no_access_with_login({ 
		:logins => [:moderator,:active_user] })
	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http


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
		put :update_select, :date => Time.now.to_s,
			:subjects => [ ]
		assert_response :redirect
		assert_match he_enrolls_path, @response.redirected_to
		assert_not_nil flash[:notice]
	end

	test "should NOT update selected with #{u} login with invalid date" do
		login_as send(u)
		put :update_select, :date => "can't parse this!",
			:subjects => [ ]
		assert_response :redirect
		assert_match send_letters_he_enrolls_path, @response.redirected_to
		assert_not_nil flash[:error]
	end

	test "should NOT update selected with #{u} login without date" do
		login_as send(u)
		put :update_select, 
			:subjects => [ ]
		assert_response :redirect
		assert_match he_enrolls_path, @response.redirected_to
		assert_not_nil flash[:notice]
	end

	test "should update selected with #{u} login if in HE" do
		pending
	end

	test "should NOT update selected with #{u} login if not in HE" do
		pending
	end

end	#	%w( admin employee editor ).each do |u|

%w( moderator active_user ).each do |u|

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
		put :update_select, :date => Time.now.to_s,
			:subjects => [ ]
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

end	#	%w( active_user ).each do |u|

	test "should NOT download csv without login" do
		get :index, :commit => 'download'
		assert_redirected_to_login
	end

	test "should NOT get send_letters without login" do
		get :send_letters
		assert_redirected_to_login
	end

	test "should NOT update selected without login" do
		put :update_select, :date => Time.now.to_s,
			:subjects => [ ]
		assert_redirected_to_login
	end

end
