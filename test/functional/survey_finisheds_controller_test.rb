require 'test_helper'

class SurveyFinishedsControllerTest < ActionController::TestCase

#	test "should show with valid invitation token set" do
#		invitation = Factory(:survey_invitation)
#		invitation.subject.update_attribute(
#			:pii_attributes, Factory.attributes_for(:pii))
#		session[:invitation] = invitation.token
#		assert_difference('ActionMailer::Base.deliveries.length',1) {
#			get :show
#		}
#		assert_match "@example.com", ActionMailer::Base.deliveries.last.to.first
#		assert_not_nil ActionMailer::Base.deliveries.last.to
#		assert_response :success
#		assert_not_nil flash[:notice]
#		assert_nil session[:invitation]
#	end

%w( superuser admin editor interviewer reader ).each do |cu|

#	test "should redirect to interview/subject without token "<<
	test "should redirect to subject's response_sets without token "<<
			"but with access_code and #{cu} login" do
		rs = create_response_set	#Factory(:response_set)
		session[:access_code] = rs.access_code
		login_as send(cu)
		#	No mail without 'invitation'
		assert_difference('ActionMailer::Base.deliveries.length',0) {
			get :show
		}
		assert_not_nil flash[:notice]
#		assert_redirected_to interview_subject_path(rs.subject)
		assert_redirected_to subject_response_sets_path(rs.subject)
	end

	test "should redirect to root_path without token " <<
			"or access_code but with #{cu} login" do
		login_as send(cu)
		assert_difference('ActionMailer::Base.deliveries.length',0) {
			get :show
		}
		assert_not_nil flash[:notice]
		assert_redirected_to root_path
	end

end

%w( active_user ).each do |cu|

	test "should redirect to root_path without token " <<
			"or access_code but with #{cu} login" do
		login_as send(cu)
		assert_difference('ActionMailer::Base.deliveries.length',0) {
			get :show
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

end

	test "should redirect to login without token, access_code or login" do
		assert_difference('ActionMailer::Base.deliveries.length',0) {
			get :show
		}
		assert_redirected_to_login
	end

end
