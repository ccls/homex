require File.dirname(__FILE__) + '/../test_helper'

class HomeExposureQuestionnairesControllerTest < ActionController::TestCase

	def setup
	end

	test "should get new with admin login" do
		rs1 = fill_out_survey(
			:survey => Survey.find_by_access_code("home_exposure_survey"))
		rs1.reload
		rs2 = fill_out_survey(:subject => rs1.subject, :survey => rs1.survey)
		login_as admin_user
		get :new, :subject_id => rs1.subject.id
		assert_response :success
		assert_template 'new'
	end

	test "should get new with employee login" do
		rs1 = fill_out_survey(
			:survey => Survey.find_by_access_code("home_exposure_survey"))
		rs1.reload
		rs2 = fill_out_survey(:subject => rs1.subject, :survey => rs1.survey)
		login_as active_user(:role_name => 'employee')
		get :new, :subject_id => rs1.subject.id
		assert_response :success
		assert_template 'new'
	end

	test "should NOT get new with just login" do
		rs1 = fill_out_survey(
			:survey => Survey.find_by_access_code("home_exposure_survey"))
		rs1.reload
		rs2 = fill_out_survey(:subject => rs1.subject, :survey => rs1.survey)
		login_as active_user
		get :new, :subject_id => rs1.subject.id
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should NOT get new without login" do
		rs1 = fill_out_survey(
			:survey => Survey.find_by_access_code("home_exposure_survey"))
		rs1.reload
		rs2 = fill_out_survey(:subject => rs1.subject, :survey => rs1.survey)
		get :new, :subject_id => rs1.subject.id
		assert_redirected_to_cas_login
	end

	test "should NOT get new without valid subject_id" do
		rs1 = fill_out_survey(
			:survey => Survey.find_by_access_code("home_exposure_survey"))
		rs1.reload
		rs2 = fill_out_survey(:subject => rs1.subject, :survey => rs1.survey)
		login_as admin_user
		assert_raise(ActionController::RoutingError){
			get :new
		}
#		assert_redirected_to root_path
#		assert_not_nil flash[:error]
	end

	test "should NOT get new with 1 response sets" do
		rs1 = fill_out_survey(
			:survey => Survey.find_by_access_code("home_exposure_survey"))
		rs1.reload
		login_as admin_user
		get :new, :subject_id => rs1.subject.id
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should NOT get new with 3 response sets" do
		rs1 = fill_out_survey(
			:survey => Survey.find_by_access_code("home_exposure_survey"))
		rs1.reload
		rs2 = fill_out_survey(:subject => rs1.subject, :survey => rs1.survey)
		rs3 = fill_out_survey(:subject => rs1.subject, :survey => rs1.survey)
		login_as admin_user
		get :new, :subject_id => rs1.subject.id
		assert_redirected_to root_path
		assert_not_nil flash[:error]

	end

	test "should NOT get new with incomplete response set" do
		rs1 = fill_out_survey(
			:survey => Survey.find_by_access_code("home_exposure_survey"),
			:completed_at => nil)
		rs1.reload
		rs2 = fill_out_survey(:subject => rs1.subject, :survey => rs1.survey)
		login_as admin_user
		get :new, :subject_id => rs1.subject.id
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end





#  test "should get index" do
#    get :index
#    assert_response :success
#    assert_not_nil assigns(:home_exposure_questionnaires)
#  end
#
#  test "should get new" do
#    get :new
#    assert_response :success
#  end
#
#  test "should create home_exposure_questionnaire" do
#    assert_difference('HomeExposureQuestionnaire.count') do
#      post :create, :home_exposure_questionnaire => { }
#    end
#
#    assert_redirected_to home_exposure_questionnaire_path(assigns(:home_exposure_questionnaire))
#  end
#
#  test "should show home_exposure_questionnaire" do
#    get :show, :id => home_exposure_questionnaires(:one).to_param
#    assert_response :success
#  end
#
#  test "should get edit" do
#    get :edit, :id => home_exposure_questionnaires(:one).to_param
#    assert_response :success
#  end
#
#  test "should update home_exposure_questionnaire" do
#    put :update, :id => home_exposure_questionnaires(:one).to_param, :home_exposure_questionnaire => { }
#    assert_redirected_to home_exposure_questionnaire_path(assigns(:home_exposure_questionnaire))
#  end
#
#  test "should destroy home_exposure_questionnaire" do
#    assert_difference('HomeExposureQuestionnaire.count', -1) do
#      delete :destroy, :id => home_exposure_questionnaires(:one).to_param
#    end
#
#    assert_redirected_to home_exposure_questionnaires_path
#  end
end
