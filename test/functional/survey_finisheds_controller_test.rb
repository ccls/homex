require File.dirname(__FILE__) + '/../test_helper'

class SurveyFinishedsControllerTest < ActionController::TestCase

	test "should show with valid invitation token set" do
		invitation = Factory(:survey_invitation)
		session[:invitation] = invitation.token
		get :show
		assert_response :success
		assert_not_nil flash[:notice]
		assert_nil session[:invitation]
	end

	test "should redirect to root_path without token" do
		get :show
		assert_redirected_to root_path
		assert_not_nil flash[:notice]
	end

end
