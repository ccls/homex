require File.dirname(__FILE__) + '/../test_helper'

class SurveyControllerTest < ActionController::TestCase

	def setup
		#	for whatever brilliant reason they had,
		#	surveys/ goes to the Surveyor controller's
		#	"new" action!!!
		Factory(:survey)
		@controller = SurveyorController.new
	end

#	test "should show with admin login" do
#		login_as admin_user
#		get :show
#		assert_template 'show'
#		assert_response :success
#	end
#
#	test "should show with employee login" do
#		login_as active_user(:role_name => 'employee')
#		get :show
#		assert_template 'show'
#		assert_response :success
#	end
#
#	test "should NOT show with just user login" do
#		login_as active_user
#		get :show
#		assert_redirected_to root_path
#	end
#
#	test "should NOT show without login" do
#		get :show
#		assert_redirected_to_cas_login
#	end


	test "should show surveys with admin login" do
		login_as admin_user
		get :new
		assert_response :success
		assert assigns(:surveys)
		assert_equal 1, assigns(:surveys).length
		assert assigns(:current_user)
	end

	test "should show surveys with employee login" do
		login_as active_user(:role_name => 'employee')
		get :new
		assert_response :success
		assert assigns(:surveys)
		assert assigns(:current_user)
	end

	test "should show surveys with login" do
		login_as active_user
		get :new
		assert_response :success
		assert assigns(:surveys)
		assert assigns(:current_user)
	end

	test "should NOT show surveys without login" do
#available_surveys GET    /surveys  {:controller=>"surveyor", :action=>"new"}
#	I think that this is kinda stupid, but new is like index
		get :new
		assert_redirected_to_cas_login
	end


	test "should take survey with admin login" do
		survey = Survey.first
		login_as admin_user
		assert_difference( 'ResponseSet.count', 1 ) {
			post :create, :survey_code => survey.access_code
		}
		assert assigns(:survey)
		assert assigns(:response_set)
		assert assigns(:current_user)
		assert_not_nil flash[:notice]
		assert_response :redirect
		assert_redirected_to(
			edit_my_survey_path(
				:survey_code => assigns(:survey).access_code, 
				:response_set_code  => assigns(:response_set).access_code	
			)
		)
	end

	test "should NOT take survey with invalid access code" do
		login_as admin_user
		assert_difference( 'ResponseSet.count', 0 ) {
			post :create, :survey_code => "bogus code"
		}
		assert !assigns(:survey)
		assert !assigns(:response_set)
		assert assigns(:current_user)
		assert_not_nil flash[:notice]
		assert_response :redirect
		assert_redirected_to available_surveys_path
	end


#	edit
#	update
#	show


end
