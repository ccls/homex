require File.dirname(__FILE__) + '/../test_helper'

class ResponseSetsControllerTest < ActionController::TestCase

	setup :build_stuff
	def build_stuff	#	setup
		#	Make 2 so that the index tests duplication.
		Factory(:survey_section)	#	creates a survey too
		Factory(:survey_section)	#	creates a survey too
		Factory(:subject)
	end

#	#	test "should show with admin login" do
#	#		login_as admin_user
#	#		get :show
#	#		assert_template 'show'
#	#		assert_response :success
#	#	end
#	#
#	#	test "should show with employee login" do
#	#		login_as employee
#	#		get :show
#	#		assert_template 'show'
#	#		assert_response :success
#	#	end
#	#
#	#	test "should NOT show with just user login" do
#	#		login_as active_user
#	#		get :show
#	#		assert_redirected_to root_path
#	#	end
#	#
#	#	test "should NOT show without login" do
#	#		get :show
#	#		assert_redirected_to_login
#	#	end
#	
#	
#		test "should show surveys with admin login" do
#			login_as admin_user
#			get :new
#			assert_response :success
#			assert assigns(:surveys)
#			assert_equal 2, assigns(:surveys).length
#			assert assigns(:current_user)
#		end
#	
#		test "should show surveys with employee login" do
#			login_as employee
#			get :new
#			assert_response :success
#			assert assigns(:surveys)
#			assert assigns(:current_user)
#		end
#	
#		test "should show NOT surveys with login" do
#			login_as active_user
#			get :new
#	#		assert_response :success
#	#		assert assigns(:surveys)
#	#		assert assigns(:current_user)
#			assert_not_nil flash[:error]
#			assert_redirected_to root_path
#		end
#	
#		test "should NOT show surveys without login" do
#	#available_surveys GET    /surveys  {:controller=>"surveyor", :action=>"new"}
#	#	I think that this is kinda stupid, but new is like index
#			get :new
#			assert_redirected_to_login
#		end
	
	
#	create

%w( admin employee ).each do |cu|
	
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
	end

	test "should NOT begin survey with invalid subject_id with #{cu} login" do
		survey = Survey.first
		login_as send(cu)
		assert_difference( 'ResponseSet.count', 0 ) {
			post :create, :subject_id => 'bogus', 
				:survey_code => survey.access_code
		}
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

end

%w( active_user moderator editor ).each do |cu|

	test "should NOT begin survey with #{cu} login" do
		survey = Survey.first
		login_as send(cu)
		assert_difference( 'ResponseSet.count', 0 ) {
			post :create, :subject_id => Subject.first.id, 
				:survey_code => survey.access_code
		}
		assert !assigns(:survey)
		assert !assigns(:response_set)
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
		assert !assigns(:survey)
		assert !assigns(:response_set)
		assert_redirected_to_login
	end


#	edit

#		test "should continue incomplete survey with admin login" do
#			rs = Factory(:response_set, :survey => Survey.first)
#			login_as admin_user
#			get :edit, :survey_code => rs.survey.access_code,
#				:response_set_code => rs.access_code
#			assert assigns(:survey)
#			assert assigns(:response_set)
#			assert assigns(:current_user)
#			assert_response :success
#			assert_template 'edit'
#		end
#	
#		test "should continue incomplete survey with employee login" do
#			rs = Factory(:response_set, :survey => Survey.first)
#			login_as employee
#			get :edit, :survey_code => rs.survey.access_code,
#				:response_set_code => rs.access_code
#			assert assigns(:survey)
#			assert assigns(:response_set)
#			assert assigns(:current_user)
#			assert_response :success
#			assert_template 'edit'
#		end
#	
#		test "should NOT continue incomplete survey with just login" do
#			rs = Factory(:response_set, :survey => Survey.first)
#			login_as active_user
#			get :edit, :survey_code => rs.survey.access_code,
#				:response_set_code => rs.access_code
#			assert !assigns(:survey)
#			assert !assigns(:response_set)
#			assert assigns(:current_user)
#			assert_response :redirect
#			assert_redirected_to root_path
#		end
#	
#		test "should NOT continue incomplete survey without login" do
#			rs = Factory(:response_set, :survey => Survey.first)
#			get :edit, :survey_code => rs.survey.access_code,
#				:response_set_code => rs.access_code
#			assert !assigns(:survey)
#			assert !assigns(:response_set)
#			assert !assigns(:current_user)
#			assert_redirected_to_login
#		end
#	
#		test "should NOT continue complete survey" do
#			rs = Factory(:response_set, :survey => Survey.first)
#			rs.complete!
#			rs.save
#			login_as employee
#			get :edit, :survey_code => rs.survey.access_code,
#				:response_set_code => rs.access_code
#			assert !assigns(:survey)
#			assert assigns(:response_set)
#			assert assigns(:current_user)
#			assert_not_nil flash[:error]
#			assert_response :redirect
#			assert_redirected_to root_path
#		end

#	update
#	show


end
