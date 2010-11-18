require File.dirname(__FILE__) + '/../../test_helper'

class Followup::GiftCardsControllerTest < ActionController::TestCase

	setup :create_home_exposure_with_subject
	ASSERT_ACCESS_OPTIONS = {
		:actions => [:index]
	}

	assert_access_with_login({ 
		:logins => [:superuser,:admin] })
	assert_no_access_with_login({ 
		:logins => [:editor,:reader,:active_user] })
	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http


#%w( superuser admin reader editor ).each do |u|
#
#	test "should download csv with #{u} login" do
#		login_as send(u)
#		get :index, :commit => 'download'
#		assert_response :success
#		assert_not_nil @response.headers['Content-disposition'].match(/attachment;.*csv/)
#	end
#
#end
#
#%w( active_user ).each do |u|
#
#	test "should NOT download csv with #{u} login" do
#		login_as send(u)
#		get :index, :commit => 'download'
#		assert_redirected_to root_path
#		assert_not_nil flash[:error]
#	end
#
#end
#
#	test "should NOT download csv without login" do
#		get :index, :commit => 'download'
#		assert_redirected_to_login
#	end

end
