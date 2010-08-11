require File.dirname(__FILE__) + '/../test_helper'

class SurveyControllerTest < ActionController::TestCase

	setup :prep_stuff
	def prep_stuff	#	setup
		#	for whatever brilliant reason they had,
		#	surveys/ goes to the Surveyor controller's
		#	"new" action!!!
		#	Make 2 so that the index tests duplication.
		Factory(:survey_section)	#	creates a survey too
		Factory(:survey_section)	#	creates a survey too
		#	a survey section is needed in the edit action
#		Factory(:survey)
		@controller = SurveyorController.new
	end

%w( superuser admin reader ).each do |cu|

	test "should NOT show surveys with #{cu} login" do
		login_as send(cu)
		get :new
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT begin survey with #{cu} login" do
		login_as send(cu)
		survey = Survey.first
		assert_difference( 'ResponseSet.count', 0 ) {
			post :create, :subject_id => 123, 
				:survey_code => survey.access_code
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT continue survey with invalid response_set_code with #{cu} login" do
		#	Error  Line 263, Column 22: there is no attribute "autocomplete" .
  	#	<input autocomplete="off" ...
		SurveyorController.skip_after_filter :validate_page
		rs = Factory(:response_set, :survey => Survey.first)
		login_as send(cu)
		get :edit, :survey_code => rs.survey.access_code,
			:response_set_code => "bogus_response_set_code"
		assert !assigns(:survey)
		assert !assigns(:response_set)
		assert !assigns(:current_user)
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should continue incomplete survey with #{cu} login" do
		#	Error  Line 263, Column 22: there is no attribute "autocomplete" .
  	#	<input autocomplete="off" ...
		SurveyorController.skip_after_filter :validate_page
		rs = Factory(:response_set, :survey => Survey.first)
		login_as send(cu)
		get :edit, :survey_code => rs.survey.access_code,
			:response_set_code => rs.access_code
		assert assigns(:survey)
		assert assigns(:response_set)
		assert assigns(:current_user)
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT continue complete survey with #{cu} login" do
		rs = Factory(:response_set, :survey => Survey.first)
		rs.complete!
		rs.save
		login_as send(cu)
		get :edit, :survey_code => rs.survey.access_code,
			:response_set_code => rs.access_code
		assert !assigns(:survey)
		assert assigns(:response_set)
		assert assigns(:current_user)
		assert_not_nil flash[:error]
		assert_response :redirect
		assert_redirected_to root_path
	end

	test "should set completed_at on response_set finish with #{cu} login" do
		SurveyorController.skip_after_filter :validate_page
		rs = Factory(:response_set, :survey => Survey.first)
		login_as send(cu)
		put :update, :survey_code => rs.survey.access_code,
			:responses => {},
			:response_set_code => rs.access_code,
			:finish => true
		assert assigns(:response_set)
		assert_not_nil flash[:notice]
		assert_redirected_to survey_finished_path
	end

end

%w( active_user editor ).each do |cu|

	test "should NOT continue incomplete survey with #{cu} login" do
		rs = Factory(:response_set, :survey => Survey.first)
		login_as send(cu)
		get :edit, :survey_code => rs.survey.access_code,
			:response_set_code => rs.access_code
		assert !assigns(:survey)
		assert assigns(:response_set)
		assert assigns(:current_user)
		assert_response :redirect
		assert_redirected_to root_path
	end

end

	test "should NOT show surveys without login" do
		get :new
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT begin survey without login" do
		survey = Survey.first
		assert_difference( 'ResponseSet.count', 0 ) {
			post :create, :subject_id => 123, 
				:survey_code => survey.access_code
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should continue incomplete survey with valid invitation" do
		#	Error  Line 263, Column 22: there is no attribute "autocomplete" .
  	#	<input autocomplete="off" ...
		SurveyorController.skip_after_filter :validate_page
		rs = Factory(:response_set, :survey => Survey.first)
		si = Factory(:survey_invitation, :survey => rs.survey,
			:response_set => rs )
		session[:invitation] = si.token
		get :edit, :survey_code => rs.survey.access_code,
			:response_set_code => rs.access_code
		assert assigns(:survey)
		assert assigns(:response_set)
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT continue incomplete survey with invalid invitation" do
		#	Error  Line 263, Column 22: there is no attribute "autocomplete" .
  	#	<input autocomplete="off" ...
		SurveyorController.skip_after_filter :validate_page
		rs1 = Factory(:response_set, :survey => Survey.first)
		rs2 = Factory(:response_set, :survey => Survey.first)
		si = Factory(:survey_invitation, :survey => rs1.survey,
			:response_set => rs2 )
		session[:invitation] = si.token
		get :edit, :survey_code => rs1.survey.access_code,
			:response_set_code => rs1.access_code
		assert assigns(:response_set)
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT continue incomplete survey without login" do
		rs = Factory(:response_set, :survey => Survey.first)
		get :edit, :survey_code => rs.survey.access_code,
			:response_set_code => rs.access_code
		assert !assigns(:survey)
		assert assigns(:response_set)
		assert_redirected_to root_path
	end

end
