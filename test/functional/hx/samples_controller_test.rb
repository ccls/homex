require File.dirname(__FILE__) + '/../../test_helper'

class Hx::SamplesControllerTest < ActionController::TestCase

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


%w( admin employee editor ).each do |cu|

	test "should download csv with #{cu} login" do
		login_as send(cu)
		get :index, :commit => 'download'
		assert_response :success
		assert_not_nil @response.headers['Content-disposition'].match(/attachment;.*csv/)
	end

end

%w( moderator active_user ).each do |cu|

	test "should NOT download csv with #{cu} login" do
		login_as send(cu)
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
