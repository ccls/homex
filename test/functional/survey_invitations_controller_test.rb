require File.dirname(__FILE__) + '/../test_helper'

class SurveyInvitationsControllerTest < ActionController::TestCase

	def setup
		@survey  = Factory(:survey)
		@subject = Factory(:subject, 
			:pii_attributes => Factory.attributes_for(:pii))
	end

	test "should create invitation for subject with admin login" do
		login_as admin_user
		assert_difference('ActionMailer::Base.deliveries.length',1) {
		assert_difference('SurveyInvitation.count',1) {
			post :create, :subject_id => @subject.id, :survey_id => @survey.id
		} }
		assert_redirected_to assigns(:subject)
		assert_not_nil flash[:notice]
		assert_nil flash[:error]
	end

	test "should create invitation for subject with employee login" do
		login_as employee
		assert_difference('ActionMailer::Base.deliveries.length',1) {
		assert_difference('SurveyInvitation.count',1) {
			post :create, :subject_id => @subject.id, :survey_id => @survey.id
		} }
		assert_redirected_to assigns(:subject)
		assert_not_nil flash[:notice]
		assert_nil flash[:error]
	end

	test "should NOT create invitation for subject with just login" do
		login_as active_user
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_difference('SurveyInvitation.count',0) {
			post :create, :subject_id => @subject.id, :survey_id => @survey.id
		} }
		assert_redirected_to root_path
		assert_not_nil flash[:error]
		assert_nil flash[:notice]
	end

	test "should NOT create invitation for subject without login" do
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_difference('SurveyInvitation.count',0) {
			post :create, :subject_id => @subject.id, :survey_id => @survey.id
		} }
		assert_redirected_to login_path
	end

	test "should NOT create invitation without subject" do
		login_as admin_user
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_difference('SurveyInvitation.count',0) {
		assert_raise(ActionController::RoutingError){
			post :create, :survey_id => @survey.id
		} } }
	end

	test "should NOT create invitation without valid subject id" do
		login_as admin_user
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_difference('SurveyInvitation.count',0) {
			post :create, :survey_id => @survey.id, :subject_id => 0
		} }
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT create invitation without survey" do
		login_as admin_user
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_difference('SurveyInvitation.count',0) {
			post :create, :subject_id => @subject.id
		} }
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT create invitation without valid survey id" do
		login_as admin_user
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_difference('SurveyInvitation.count',0) {
			post :create, :subject_id => @subject.id, :survey_id => 0
		} }
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should create ONE invitation for subject" do
		login_as admin_user
		assert_difference('ActionMailer::Base.deliveries.length',5) {
		assert_difference('SurveyInvitation.count',1) {
			post :create, :subject_id => @subject.id, :survey_id => @survey.id
			post :create, :subject_id => @subject.id, :survey_id => @survey.id
			post :create, :subject_id => @subject.id, :survey_id => @survey.id
			post :create, :subject_id => @subject.id, :survey_id => @survey.id
			post :create, :subject_id => @subject.id, :survey_id => @survey.id
		} }
		#	each create above should destroy the previous one
		#	just creating a new one each time
		#	But it will send an email for each one.
		assert_redirected_to assigns(:subject)
		assert_not_nil flash[:notice]
		assert_nil flash[:error]
	end

	test "should create invitation with survey_code" do
		login_as admin_user
		assert_difference('ActionMailer::Base.deliveries.length',1) {
		assert_difference('SurveyInvitation.count',1) {
			post :create, :subject_id => @subject.id, 
				:survey_code => @survey.access_code
		} }
		assert_redirected_to assigns(:subject)
		assert_not_nil flash[:notice]
		assert_nil flash[:error]
	end

	test "should create invitation with access_code" do
		login_as admin_user
		assert_difference('ActionMailer::Base.deliveries.length',1) {
		assert_difference('SurveyInvitation.count',1) {
			post :create, :subject_id => @subject.id, 
				:access_code => @survey.access_code
		} }
		assert_redirected_to assigns(:subject)
		assert_not_nil flash[:notice]
		assert_nil flash[:error]
	end

	test "should NOT create invitation when save fails" do
		SurveyInvitation.any_instance.stubs(:save).returns(false)
		login_as admin_user
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_difference('SurveyInvitation.count',0) {
			post :create, :subject_id => @subject.id, 
				:access_code => @survey.access_code
		} }
		assert_redirected_to assigns(:subject)
		assert_not_nil flash[:error]
		assert_nil flash[:notice]
	end

#	update

	test "should send reminder on invitation update" do
		si = Factory(:survey_invitation,{
			:subject_id => @subject.id,
			:survey_id  => @survey.id
		})
		login_as admin_user
		assert_difference('ActionMailer::Base.deliveries.length',1) {
			put :update, :id => si.id
		}
		assert_redirected_to assigns(:invitation).subject
		assert_not_nil flash[:notice]
		assert_nil flash[:error]
	end

	test "should not update without valid invitation id" do
		login_as admin_user
		assert_difference('ActionMailer::Base.deliveries.length',0) {
			put :update, :id => 0
		}
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

#	show

	test "should show with valid invitation token" do
		si = Factory(:survey_invitation)
		assert_difference('ResponseSet.count',1) do
			get :show, :id => si.token
		end
		assert_response :success
		assert_template 'show'
	end

	test "should NOT show without valid invitation token" do
		Factory(:survey_invitation)
		assert_difference('ResponseSet.count',0) do
			get :show, :id => 'some_very_likely_invalid_token'
		end
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should NOT show if response set creation fails" do
#
#	This should NEVER EVER HAPPEN!  If it does, subjects may
#	NEVER try to complete our online survey
#
		si = Factory(:survey_invitation)
		ResponseSet.any_instance.stubs(:create_or_update).returns(false)
		assert_difference('ResponseSet.count',0) do
			get :show, :id => si.token
		end
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT show if invitation save fails" do
#
#	This should NEVER EVER HAPPEN!  If it does, subjects may
#	NEVER try to complete our online survey
#
		si = Factory(:survey_invitation)
		SurveyInvitation.any_instance.stubs(:create_or_update).returns(false)
		assert_difference('ResponseSet.count',1) do
			get :show, :id => si.token
		end
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

end
