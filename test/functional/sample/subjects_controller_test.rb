require 'test_helper'

class Sample::SubjectsControllerTest < ActionController::TestCase

	setup :create_home_exposure_with_subject
	ASSERT_ACCESS_OPTIONS = {
		:actions => [:index,:show],
 		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_subject
	}
	def factory_attributes(options={})
		Factory.attributes_for(:subject,options)
	end

	assert_access_with_login({ 
		:logins => site_readers })
	assert_no_access_with_login({ 
		:logins => non_site_readers })
	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

	site_readers.each do |cu|

		test "should download csv with #{cu} login" do
			login_as send(cu)
			get :index, :commit => 'download'
			assert_response :success
			assert_not_nil @response.headers['Content-disposition'].match(/attachment;.*csv/)
		end

	end

	non_site_readers.each do |cu|

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
