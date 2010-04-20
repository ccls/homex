require File.dirname(__FILE__) + '/../test_helper'

class SurveyFinishedsControllerTest < ActionController::TestCase

	test "should show with valid invitation token set" do
		invitation = Factory(:survey_invitation)
		invitation.subject.update_attribute(
			:pii_attributes, Factory.attributes_for(:pii))
		session[:invitation] = invitation.token
		assert_difference('ActionMailer::Base.deliveries.length',1) {
			get :show
		}
		assert_match "@example.com", ActionMailer::Base.deliveries.last.to.first
		assert_not_nil ActionMailer::Base.deliveries.last.to
		assert_response :success
		assert_not_nil flash[:notice]
		assert_nil session[:invitation]
	end

	test "should redirect to root_path without token" do
		assert_difference('ActionMailer::Base.deliveries.length',0) {
			get :show
		}
		assert_redirected_to root_path
		assert_not_nil flash[:notice]
	end

end
