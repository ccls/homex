require File.dirname(__FILE__) + '/../test_helper'

class SurveyInvitationsControllerTest < ActionController::TestCase

	#	no subject_id
	assert_no_route(:post, :create, :survey_id => 0)

	setup :create_home_exposure_with_subject

	setup :build_stuff
	def build_stuff	#	setup
		@survey  = Factory(:survey)
		@subject = Factory(:subject, 
			:pii_attributes => Factory.attributes_for(:pii))
	end

%w( superuser admin ).each do |cu|

	test "should create invitation for subject with #{cu} login" do
		login_as send(cu)
		assert_difference('ActionMailer::Base.deliveries.length',1) {
		assert_difference('SurveyInvitation.count',1) {
			post :create, :subject_id => @subject.id, :survey_id => @survey.id
		} }
		assert_redirected_to assigns(:subject)
		assert_not_nil flash[:notice]
		assert_nil flash[:error]
	end

	test "should NOT create invitation with #{cu} login" <<
		" without valid subject id" do
		login_as send(cu)
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_difference('SurveyInvitation.count',0) {
			post :create, :survey_id => @survey.id, :subject_id => 0
		} }
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT create invitation with #{cu} login" <<
		" without survey" do
		login_as send(cu)
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_difference('SurveyInvitation.count',0) {
			post :create, :subject_id => @subject.id
		} }
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT create invitation with #{cu} login" <<
		" without valid survey id" do
		login_as send(cu)
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_difference('SurveyInvitation.count',0) {
			post :create, :subject_id => @subject.id, :survey_id => 0
		} }
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should create ONE invitation for subject with #{cu} login" do
		login_as send(cu)
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

	test "should create invitation with survey_code with #{cu} login" do
		login_as send(cu)
		assert_difference('ActionMailer::Base.deliveries.length',1) {
		assert_difference('SurveyInvitation.count',1) {
			post :create, :subject_id => @subject.id, 
				:survey_code => @survey.access_code
		} }
		assert_redirected_to assigns(:subject)
		assert_not_nil flash[:notice]
		assert_nil flash[:error]
	end

	test "should create invitation with access_code with #{cu} login" do
		login_as send(cu)
		assert_difference('ActionMailer::Base.deliveries.length',1) {
		assert_difference('SurveyInvitation.count',1) {
			post :create, :subject_id => @subject.id, 
				:access_code => @survey.access_code
		} }
		assert_redirected_to assigns(:subject)
		assert_not_nil flash[:notice]
		assert_nil flash[:error]
	end

	test "should NOT create invitation with #{cu} login" <<
		" when save fails" do
		SurveyInvitation.any_instance.stubs(:create_or_update).returns(false)
		login_as send(cu)
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_difference('SurveyInvitation.count',0) {
			post :create, :subject_id => @subject.id, 
				:access_code => @survey.access_code
		} }
		assert_redirected_to assigns(:subject)
		assert_not_nil flash[:error]
		assert_nil flash[:notice]
	end

	test "should NOT create invitation with #{cu} login" <<
		" when invalid" do
		SurveyInvitation.any_instance.stubs(:valid?).returns(false)
		login_as send(cu)
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

	test "should send reminder on invitation update with #{cu} login" do
		si = Factory(:survey_invitation,{
			:subject => @subject,
			:survey_id  => @survey.id
		})
		login_as send(cu)
		assert_difference('ActionMailer::Base.deliveries.length',1) {
			put :update, :id => si.id
		}
		assert_redirected_to assigns(:invitation).subject
		assert_not_nil flash[:notice]
		assert_nil flash[:error]
	end

	test "should not update without valid invitation id with #{cu} login" do
		login_as send(cu)
		assert_difference('ActionMailer::Base.deliveries.length',0) {
			put :update, :id => 0
		}
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

end

%w( editor interviewer reader active_user ).each do |cu|

	test "should NOT create invitation for subject with #{cu} login" do
		login_as send(cu)
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_difference('SurveyInvitation.count',0) {
			post :create, :subject_id => @subject.id, :survey_id => @survey.id
		} }
		assert_redirected_to root_path
		assert_not_nil flash[:error]
		assert_nil flash[:notice]
	end

end

	test "should NOT create invitation for subject without login" do
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_difference('SurveyInvitation.count',0) {
			post :create, :subject_id => @subject.id, :survey_id => @survey.id
		} }
		assert_redirected_to_login
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
