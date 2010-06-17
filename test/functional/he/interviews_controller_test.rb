require File.dirname(__FILE__) + '/../../test_helper'

class He::InterviewsControllerTest < ActionController::TestCase

	setup :create_home_exposure_with_subject

	assert_access_with_login :index,{
		:login => :admin}

	assert_access_with_login :index,{
		:login => :employee}

	assert_access_with_login :index,{
		:login => :editor}

	assert_no_access_with_login :index,{
		:login => :active_user}

	assert_no_access_without_login :index

	assert_access_with_https :index

	assert_no_access_with_http :index

%w( admin employee editor ).each do |u|

	test "should download csv with #{u} login" do
		login_as send(u)
		get :index, :commit => 'download'
		assert_response :success
		assert_not_nil @response.headers['Content-disposition'].match(/attachment;.*csv/)
	end

end

%w( active_user ).each do |u|

	test "should NOT download csv with #{u} login" do
		login_as send(u)
		get :index, :commit => 'download'
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

end

	test "should NOT download csv without login" do
		get :index, :commit => 'download'
		assert_redirected_to_login
	end

end
