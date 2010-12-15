require 'test_helper'

class ResponseSetsControllerTest < ActionController::TestCase

	#	no subject_id
	assert_no_route(:get,:index)

	#	no id
	assert_no_route(:get, :show)
	assert_no_route(:get, :edit)
	assert_no_route(:put, :update)
	assert_no_route(:delete, :destroy)

	#	no route
	assert_no_route(:get,:new,:subject_id => 0)
#	assert_no_route(:post,:create,:subject_id => 0)
	assert_no_route(:get, :show, :id => 0)
	assert_no_route(:get, :edit, :id => 0)
	assert_no_route(:put, :update, :id => 0)
	assert_no_route(:delete, :destroy, :id => 0)

	setup :build_stuff
	def build_stuff	#	setup
		#	Make 2 so that the index tests duplication.
		Factory(:survey_section)	#	creates a survey too
		Factory(:survey_section)	#	creates a survey too
		Factory(:subject)
	end

%w( superuser admin ).each do |cu|
	
	test "should begin survey with #{cu} login" do
		survey = Survey.first
		login_as u = send(cu)
		assert_difference( 'Subject.first.response_sets_count', 1 ) {
		assert_difference( 'ResponseSet.count', 1 ) {
			post :create, :subject_id => Subject.first.id, 
				:survey_code => survey.access_code
		} }
		assert assigns(:survey)
		assert assigns(:response_set)
		assert_equal assigns(:response_set).user_id, u.id
		assert_not_nil session[:access_code]
		assert_equal session[:access_code], assigns(:response_set).access_code
		assert_redirected_to(
			edit_my_survey_path(
				:survey_code => assigns(:survey).access_code, 
				:response_set_code  => assigns(:response_set).access_code	
			)
		)
	end

	test "should NOT begin survey when create fails with #{cu} login" do
		login_as send(cu)
		ResponseSet.any_instance.stubs(:create_or_update).returns(false)
		assert_difference( 'ResponseSet.count', 0 ) {
			post :create, :subject_id => Subject.first.id, 
				:survey_code => Survey.first.access_code
		}
		assert_nil session[:access_code]
	end

	test "should NOT begin survey with invalid subject_id with #{cu} login" do
		survey = Survey.first
		login_as send(cu)
		assert_difference( 'ResponseSet.count', 0 ) {
			post :create, :subject_id => 'bogus', 
				:survey_code => survey.access_code
		}
		assert_nil session[:access_code]
		assert assigns(:survey)
		assert !assigns(:response_set)
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT begin survey with invalid survey access code with #{cu} login" do
		login_as send(cu)
		assert_difference( 'ResponseSet.count', 0 ) {
			post :create, :subject_id => Subject.first.id, 
				:survey_code => "bogus code"
		}
		assert_nil session[:access_code]
		assert !assigns(:survey)
		assert !assigns(:response_set)
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT begin third survey with #{cu} login" do
		subject = Subject.first
		survey  = Survey.first
		ResponseSet.create( :survey => survey, :subject => subject )
		ResponseSet.create( :survey => survey, :subject => subject )
		login_as send(cu)
		assert_difference( 'ResponseSet.count', 0 ) {
			post :create, :subject_id => subject.id, 
				:survey_code => survey.access_code
		}
		assert assigns(:survey)
		assert !assigns(:response_set)
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should get response sets with #{cu} login" do
		subject = create_subject	#Factory(:subject)
		login_as send(cu)
		get :index, :subject_id => subject.id
		assert assigns(:subject)
		assert_response :success
		assert_template 'index'
	end

	test "should get response sets with #{cu} login and hx subject" do
		subject = create_hx_subject
		login_as send(cu)
		get :index, :subject_id => subject.id
		assert assigns(:subject)
		assert_response :success
		assert_template 'index'
	end

	test "should NOT get response sets with invalid subject_id " <<
		"and #{cu} login" do
		login_as send(cu)
		get :index, :subject_id => 0
		assert_not_nil flash[:error]
		assert_redirected_to root_path	#subjects_path
	end

end

%w( active_user editor interviewer reader ).each do |cu|

	test "should NOT begin survey with #{cu} login" do
		survey = Survey.first
		login_as send(cu)
		assert_difference( 'ResponseSet.count', 0 ) {
			post :create, :subject_id => Subject.first.id, 
				:survey_code => survey.access_code
		}
		assert_nil session[:access_code]
		assert !assigns(:survey)
		assert !assigns(:response_set)
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT get response sets with #{cu} login" do
		subject = create_hx_subject
		login_as send(cu)
		get :index, :subject_id => subject.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

end

	test "should NOT begin survey without login" do
		survey = Survey.first
		assert_difference( 'ResponseSet.count', 0 ) {
			post :create, :subject_id => Subject.first.id, 
				:survey_code => survey.access_code
		}
		assert_nil session[:access_code]
		assert !assigns(:survey)
		assert !assigns(:response_set)
		assert_redirected_to_login
	end

	test "should NOT get response sets without login" do
		subject = create_hx_subject
		get :index, :subject_id => subject.id
		assert_redirected_to_login
	end

end
