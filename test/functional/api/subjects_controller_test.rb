require 'test_helper'

class Api::SubjectsControllerTest < ActionController::TestCase

	test "should get homex subject with credentials" do
		set_credentials
		subject = create_subject
		get :show, :id => subject.id
		assert_response :success
		assert assigns(:subject)
		assert_equal subject, assigns(:subject)
	end

	test "should not get homex subject without credentials" do
		subject = create_subject
		get :show, :id => subject.id
		assert_response 401
		assert_response :unauthorized
		#	action_controller/status_codes.rb
	end

	test "should not gem homex subject without id" do
		set_credentials
		assert_raise(ActionController::RoutingError){
			get :show
		}
	end

	test "should not gem homex subject with invalid id" do
		set_credentials
		assert_raise(ActiveRecord::RecordNotFound){
			get :show, :id => 0
		}
	end

protected 

	def set_credentials
		config = YAML::load(ERB.new(IO.read('config/api.yml')).result)
		@request.env['HTTP_AUTHORIZATION'
			] = ActionController::HttpAuthentication::Basic.encode_credentials(
				config[:user],config[:password])
	end

end
