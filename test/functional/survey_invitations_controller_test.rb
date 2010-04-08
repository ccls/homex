require File.dirname(__FILE__) + '/../test_helper'

class SurveyInvitationsControllerTest < ActionController::TestCase

	def setup
		@survey  = Factory(:survey)
		@subject = Factory(:subject)
	end

	test "should create invitation for subject with admin login" do
		login_as admin_user
		assert_difference('SurveyInvitation.count',1) do
			post :create, :subject_id => @subject.id, :survey_id => @survey.id
		end
		assert_redirected_to assigns(:subject)
		assert_not_nil flash[:notice]
		assert_nil flash[:error]
	end

	test "should create invitation for subject with employee login" do
		login_as active_user(:role_name => 'employee')
		assert_difference('SurveyInvitation.count',1) do
			post :create, :subject_id => @subject.id, :survey_id => @survey.id
		end
		assert_redirected_to assigns(:subject)
		assert_not_nil flash[:notice]
		assert_nil flash[:error]
	end

	test "should NOT create invitation for subject with just login" do
		login_as active_user
		assert_difference('SurveyInvitation.count',0) do
			post :create, :subject_id => @subject.id, :survey_id => @survey.id
		end
		assert_redirected_to root_path
		assert_not_nil flash[:error]
		assert_nil flash[:notice]
	end

	test "should NOT create invitation for subject without login" do
		assert_difference('SurveyInvitation.count',0) do
			post :create, :subject_id => @subject.id, :survey_id => @survey.id
		end
		assert_redirected_to_cas_login
	end

	test "should NOT create invitation without subject" do
		login_as admin_user
		assert_difference('SurveyInvitation.count',0) {
		assert_raise(ActionController::RoutingError){
			post :create, :survey_id => @survey.id
		} }
	end

	test "should NOT create invitation without survey" do
		login_as admin_user
		assert_difference('SurveyInvitation.count',0) {
			post :create, :subject_id => @subject.id
		}
		assert_not_nil flash[:error]
	end

	test "should create ONE invitation for subject" do
		login_as admin_user
		assert_difference('SurveyInvitation.count',1) do
			post :create, :subject_id => @subject.id, :survey_id => @survey.id
			post :create, :subject_id => @subject.id, :survey_id => @survey.id
			post :create, :subject_id => @subject.id, :survey_id => @survey.id
			post :create, :subject_id => @subject.id, :survey_id => @survey.id
			post :create, :subject_id => @subject.id, :survey_id => @survey.id
		end
		#	each create above should destroy the previous one
		#	just creating a new one each time
		assert_redirected_to assigns(:subject)
		assert_not_nil flash[:notice]
		assert_nil flash[:error]
	end

	test "should create invitation with survey_code" do
		login_as admin_user
		assert_difference('SurveyInvitation.count',1) do
			post :create, :subject_id => @subject.id, 
				:survey_code => @survey.access_code
		end
		assert_redirected_to assigns(:subject)
		assert_not_nil flash[:notice]
		assert_nil flash[:error]
	end

	test "should create invitation with access_code" do
		login_as admin_user
		assert_difference('SurveyInvitation.count',1) do
			post :create, :subject_id => @subject.id, 
				:access_code => @survey.access_code
		end
		assert_redirected_to assigns(:subject)
		assert_not_nil flash[:notice]
		assert_nil flash[:error]
	end




#	show


#	TODO


end
