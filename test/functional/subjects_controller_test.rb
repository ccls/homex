require File.dirname(__FILE__) + '/../test_helper'

class SubjectsControllerTest < ActionController::TestCase

	test "should get index with subjects" do
		survey = Survey.find_by_access_code("home_exposure_survey")
		rs1 = fill_out_survey(:survey => survey)
		rs2 = fill_out_survey(:survey => survey, :subject => rs1.subject)
		rs2.to_her
		rs3 = fill_out_survey(:survey => survey)
		rs4 = fill_out_survey(:survey => survey, :subject => rs3.subject)
		rs5 = fill_out_survey(:survey => survey)
		Factory(:subject)
		login_as admin_user
		get :index
		assert_response :success
		assert_template 'index'
	end

	test "should get index with admin login" do
		login_as admin_user
		get :index
		assert_response :success
		assert_template 'index'
	end

	test "should get index with employee login" do
		login_as employee
		get :index
		assert_response :success
		assert_template 'index'
	end

	test "should NOT get index with just login" do
		login_as active_user
		get :index
		assert_redirected_to root_path
	end

	test "should NOT get index without login" do
		get :index
		assert_redirected_to_cas_login
	end


	test "should get show with admin login" do
		subject = Factory(:subject)
		login_as admin_user
		get :show, :id => subject
		assert_response :success
		assert_template 'show'
	end

	test "should get show with pii" do
		subject = Factory(:subject,
			:pii_attributes => Factory.attributes_for(:pii))
		login_as admin_user
		get :show, :id => subject
		assert_response :success
		assert_template 'show'
	end

	test "should get show with employee login" do
		subject = Factory(:subject)
		login_as employee
		get :show, :id => subject
		assert_response :success
		assert_template 'show'
	end

	test "should NOT get show with just login" do
		subject = Factory(:subject)
		login_as active_user
		get :show, :id => subject
		assert_redirected_to root_path
	end

	test "should NOT get show without login" do
		subject = Factory(:subject)
		get :show, :id => subject
		assert_redirected_to_cas_login
	end




	test "should get new with admin login" do
		pending
	end

	test "should get new with employee login" do
		pending
	end

	test "should NOT get new with just login" do
		pending
	end

	test "should NOT get new without login" do
		pending
	end

	
	test "should create with admin login" do
		pending
	end

	test "should create with employee login" do
		pending
	end

	test "should NOT create with just login" do
		pending
	end

	test "should NOT create without login" do
		pending
	end

	test "should NOT create without valid subject" do
		pending
	end

	test "should edit with admin login" do
		pending
	end

	test "should edit with employee login" do
		pending
	end

	test "should NOT edit with just login" do
		pending
	end

	test "should NOT edit without login" do
		pending
	end

	test "should NOT edit without valid id" do
		pending
	end

	test "should update with admin login" do
		pending
	end

	test "should update with employee login" do
		pending
	end

	test "should NOT update with just login" do
		pending
	end

	test "should NOT update without login" do
		pending
	end

	test "should NOT update with invalid subject" do
		pending
	end

	test "should destroy with admin login" do
		pending
	end

	test "should destroy with employee login" do
		pending
	end

	test "should NOT destroy with just login" do
		pending
	end

	test "should NOT destroy without login" do
		pending
	end

	test "should NOT destroy with invalid id" do
		pending
	end

end
