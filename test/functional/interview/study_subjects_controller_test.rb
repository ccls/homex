require 'test_helper'

class Interview::StudySubjectsControllerTest < ActionController::TestCase

	setup :create_home_exposure_with_study_subject

	ASSERT_ACCESS_OPTIONS = {
		:actions => [:index]
	}
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

		test "should show interview/study_subjects " <<
				"with invalid hx interview study_subject " <<
				"with #{cu} login" do
			study_subject = create_hx_study_subject
			login_as send(cu)
			get :show, :id => study_subject.id

			assert_response :success

	#		assert_not_nil flash[:error]
	#		assert_redirected_to interview_study_subjects_path
		end

		test "should show interview/study_subjects " <<
				"with valid hx interview study_subject " <<
				"with #{cu} login" do
			study_subject = create_hx_interview_study_subject	#	doesn't really matter
			login_as send(cu)
			get :show, :id => study_subject.id

			assert_response :success

	#		assert_nil flash[:error]
	#		assert_redirected_to interview_path(study_subject.hx_interview)
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
