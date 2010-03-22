require File.dirname(__FILE__) + '/../test_helper'

class SurveyControllerTest < ActionController::TestCase

	def setup
		#	for whatever brilliant reason they had,
		#	surveys/ goes to the Surveyor controller's
		#	"new" action!!!
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


	test "should show index with admin login" do
		login_as admin_user
		get :new
		assert_response :success
	end

	test "should show index with employee login" do
		login_as active_user(:role_name => 'employee')
		get :new
		assert_response :success
	end

	test "should show index with login" do
		login_as active_user
		get :new
		assert_response :success
	end

	test "should NOT show index without login" do
#available_surveys GET    /surveys  {:controller=>"surveyor", :action=>"new"}
#	I think that this is kinda stupid, but new is like index
		get :new
		assert_redirected_to_cas_login
	end

end
