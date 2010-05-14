require File.dirname(__FILE__) + '/../test_helper'

class HomeExposureResponsesControllerTest < ActionController::TestCase

	def setup
		@rs1 = fill_out_survey(
			:survey => Survey.find_by_access_code("home_exposure_survey"))
		@rs1.reload
		@rs2 = fill_out_survey(
			:subject => @rs1.subject, 
			:survey => @rs1.survey)
	end


	test "should show new with very different response sets" do
		@rs2.responses.destroy_all
		login_as admin_user
		get :new, :subject_id => @rs1.subject_id
		assert_response :success
		assert_template 'new'
	end

	test "should get new with admin login" do
		login_as admin_user
		get :new, :subject_id => @rs1.subject_id
		assert_response :success
		assert_template 'new'
	end

	test "should get new with employee login" do
		login_as employee
		get :new, :subject_id => @rs1.subject_id
		assert_response :success
		assert_template 'new'
	end

	test "should NOT get new with just login" do
		login_as active_user
		get :new, :subject_id => @rs1.subject_id
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should NOT get new without login" do
		get :new, :subject_id => @rs1.subject_id
		assert_redirected_to login_path
	end

	test "should NOT get new without valid subject_id" do
		login_as admin_user
		get :new, :subject_id => 0
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should NOT get new without subject_id" do
		login_as admin_user
		assert_raise(ActionController::RoutingError){
			get :new
		}
	end

	test "should NOT get new with 1 response sets" do
		@rs2.destroy
		login_as admin_user
		get :new, :subject_id => @rs1.subject_id
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should NOT get new with 3 response sets" do
		rs3 = fill_out_survey(:subject => @rs1.subject, :survey => @rs1.survey)
		login_as admin_user
		get :new, :subject_id => @rs1.subject_id
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should NOT get new with incomplete response set" do
		@rs1.update_attribute(:completed_at, nil)
		login_as admin_user
		get :new, :subject_id => @rs1.subject_id
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should NOT get new when HER already exists" do
		assert_difference("HomeExposureResponse.count",1){
			@rs1.to_her
		}
		login_as admin_user
		get :new, :subject_id => @rs1.subject_id
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end


	test "should create HER with admin login" do
		login_as admin_user
		assert_difference("HomeExposureResponse.count",1) {
			post :create, :subject_id => @rs1.subject_id, 
				:home_exposure_response => @rs1.q_and_a_codes_as_attributes
		}
		assert_redirected_to subject_home_exposure_response_path(
			assigns(:subject))
	end

	test "should create HER with employee login" do
		login_as employee
		assert_difference("HomeExposureResponse.count",1) {
			post :create, :subject_id => @rs1.subject_id, 
				:home_exposure_response => @rs1.q_and_a_codes_as_attributes
		}
		assert_redirected_to subject_home_exposure_response_path(
			assigns(:subject))
	end

	test "should NOT create HER with just login" do
		login_as active_user
		assert_difference("HomeExposureResponse.count",0) {
			post :create, :subject_id => @rs1.subject_id, 
				:home_exposure_response => @rs1.q_and_a_codes_as_attributes
		}
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should NOT create HER without login" do
		assert_difference("HomeExposureResponse.count",0) {
			post :create, :subject_id => @rs1.subject_id, 
				:home_exposure_response => @rs1.q_and_a_codes_as_attributes
		}
		assert_redirected_to login_path
	end

	test "should NOT create HER without subject_id" do
		login_as admin_user
		assert_difference("HomeExposureResponse.count",0) {
		assert_raise(ActionController::RoutingError){
			post :create, 
				:home_exposure_response => @rs1.q_and_a_codes_as_attributes
		} }
	end

	test "should NOT create HER without valid subject_id" do
		login_as admin_user
		assert_difference("HomeExposureResponse.count",0) {
			post :create, :subject_id => 0, 
				:home_exposure_response => @rs1.q_and_a_codes_as_attributes
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT create HER without home_exposure_response" do
		login_as admin_user
		assert_difference("HomeExposureResponse.count",0) {
			post :create, :subject_id => @rs1.subject_id
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT create HER without valid home_exposure_response" do
		login_as admin_user
		assert_difference("HomeExposureResponse.count",0) {
			post :create, :subject_id => @rs1.subject_id, 
				:home_exposure_response => 0
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT create HER when HER.create fails" do
		HomeExposureResponse.any_instance.stubs(:save).returns(false)
		login_as admin_user
		assert_difference("HomeExposureResponse.count",0) {
			post :create, :subject_id => @rs1.subject_id, 
				:home_exposure_response => @rs1.q_and_a_codes_as_attributes
		}
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create HER when HER already exists" do
		@rs1.to_her
		login_as admin_user
		assert_difference("HomeExposureResponse.count",0) {
			post :create, :subject_id => @rs1.subject_id, 
				:home_exposure_response => @rs1.q_and_a_codes_as_attributes
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should show with admin login" do
		@rs1.to_her
		login_as admin_user
		get :show, :subject_id => @rs1.subject_id
		assert_response :success
		assert_template 'show'
	end

	test "should show with employee login" do
		@rs1.to_her
		login_as employee
		get :show, :subject_id => @rs1.subject_id
		assert_response :success
		assert_template 'show'
	end

	test "should NOT show with just login" do
		@rs1.to_her
		login_as active_user
		get :show, :subject_id => @rs1.subject_id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT show without login" do
		@rs1.to_her
		get :show, :subject_id => @rs1.subject_id
		assert_redirected_to login_path
	end

	test "should NOT show without valid subject_id" do
		login_as admin_user
		get :show, :subject_id => 0
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should NOT show without subject_id" do
		login_as admin_user
		assert_raise(ActionController::RoutingError){
			get :show
		}
	end

	test "should NOT show without existing home_exposure_response" do
		login_as admin_user
		get :show, :subject_id => @rs1.subject_id
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end




	test "should get index" do
		pending
	end

	test "should get edit" do
		pending
	end

	test "should update" do
		pending
	end

	test "should destroy" do
		pending
	end

#  test "should get index" do
#    get :index
#    assert_response :success
#    assert_not_nil assigns(:home_exposure_responses)
#  end
#
#  test "should get edit" do
#    get :edit, :id => home_exposure_responses(:one).to_param
#    assert_response :success
#  end
#
#  test "should update home_exposure_response" do
#    put :update, :id => home_exposure_responses(:one).to_param, :home_exposure_response => { }
#    assert_redirected_to home_exposure_response_path(assigns(:home_exposure_response))
#  end
#
#  test "should destroy home_exposure_response" do
#    assert_difference('HomeExposureResponse.count', -1) do
#      delete :destroy, :id => home_exposure_responses(:one).to_param
#    end
#
#    assert_redirected_to home_exposure_responses_path
#  end
end
