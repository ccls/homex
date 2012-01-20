require 'test_helper'

class Sample::StudySubjectsControllerTest < ActionController::TestCase

	setup :create_home_exposure_with_study_subject
	ASSERT_ACCESS_OPTIONS = {
		:actions => [:index,:show],
 		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_study_subject
	}
	def factory_attributes(options={})
		Factory.attributes_for(:study_subject,options)
	end

	assert_access_with_login({ 
		:logins => site_readers })
	assert_no_access_with_login({ 
		:logins => non_site_readers })
	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

	site_readers.each do |cu|

		test "study_subjects should include homex interview complete with #{cu} login" do
			login_as send(cu)
			study_subject = Factory(:study_subject)
			Factory(:enrollment,
				:project => Project['HomeExposures'],
				:study_subject => study_subject)
			Factory(:homex_outcome,
				:interview_outcome => InterviewOutcome['complete'],
				:study_subject => study_subject)
			get :index
			assert_equal [study_subject], assigns(:study_subjects)
		end

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
