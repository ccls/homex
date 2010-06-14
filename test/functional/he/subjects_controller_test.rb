require File.dirname(__FILE__) + '/../../test_helper'

class He::SubjectsControllerTest < ActionController::TestCase

	setup :create_home_exposure_with_subject

	assert_access_with_login [:edit,:update,:show,:destroy,:index],{
		:login => :admin, :factory => :subject }

	assert_access_with_login [:edit,:update,:show,:destroy,:index],{
		:login => :employee, :factory => :subject }

	assert_access_with_login [:edit,:update,:show,:destroy,:index],{
		:login => :editor, :factory => :subject }

	assert_no_access_with_login [:edit,:update,:show,:destroy,:index],{
		:login => :active_user, :factory => :subject }

	assert_no_access_without_login [:edit,:update,:show,:destroy,:index],{
		:factory => :subject }

	assert_no_access_with_login [],{
		:model => 'Subject',
		:suffix => " and invalid id",
		:redirect => :he_subjects_path,
		:login => :admin,
		:destroy => { :id => 0 },
		:edit => { :id => 0 },
		:show => { :id => 0 }
	}

	test "should get index with subjects" do
		survey = Survey.find_by_access_code("home_exposure_survey")
		rs1 = fill_out_survey(:survey => survey)
		rs2 = fill_out_survey(:survey => survey, :subject => rs1.subject)
		rs2.to_her
		rs3 = fill_out_survey(:survey => survey)
		rs4 = fill_out_survey(:survey => survey, :subject => rs3.subject)
		rs5 = fill_out_survey(:survey => survey)
		Factory(:study_event)	#	test search code in view
		#	There should now be 4 subjects in different states.
		login_as admin_user
		get :index
		assert_equal 1, assigns(:subjects).length
		assert_response :success
		assert_template 'index'
	end

	test "should download csv with admin login" do
		login_as admin
		get :index, :commit => 'download'
		assert_response :success
		assert_not_nil @response.headers['Content-disposition'].match(/attachment;.*csv/)
	end

	test "should get show with pii" do
		subject = Factory(:subject,
			:pii_attributes => Factory.attributes_for(:pii))
		login_as admin_user
		get :show, :id => subject
		assert_response :success
		assert_template 'show'
	end

#		test "new subject should have non nil pii" do
#			login_as admin
#			get :new
#			assert_not_nil assigns(:subject)
#			assert_not_nil assigns(:subject).pii
#		end


	test "should update with admin login" do
		subject = Factory(:subject)
		login_as admin
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			put :update, :id => subject.id, 
				:subject => Factory.attributes_for(:subject)
		} } }
		assert_redirected_to he_subject_path(assigns(:subject))
	end

	test "should update with employee login" do
		subject = Factory(:subject)
		login_as employee
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			put :update, :id => subject.id, 
				:subject => Factory.attributes_for(:subject)
		} } }
		assert_redirected_to he_subject_path(assigns(:subject))
	end

	test "should NOT update with just login" do
		subject = Factory(:subject)
		login_as user
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			put :update, :id => subject.id, 
				:subject => Factory.attributes_for(:subject)
		} } }
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT update without login" do
		subject = Factory(:subject)
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			put :update, :id => subject.id, 
				:subject => Factory.attributes_for(:subject)
		} } }
		assert_redirected_to_login
	end

	test "should NOT update with invalid id" do
		subject = Factory(:subject)
		login_as admin
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			put :update, :id => 0,
				:subject => Factory.attributes_for(:subject)
		} } }
		assert_not_nil flash[:error]
		assert_redirected_to he_subjects_path
	end

	test "should NOT update without subject_type_id" do
		subject = Factory(:subject)
		login_as admin
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			put :update, :id => subject.id,
				:subject => { :subject_type_id => nil }
		} } }
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT update without race_id" do
		subject = Factory(:subject)
		login_as admin
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			put :update, :id => subject.id,
				:subject => { :race_id => nil }
		} } }
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT update without valid subject_type_id" do
		subject = Factory(:subject)
		login_as admin
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			put :update, :id => subject.id,
				:subject => { :subject_type_id => 0 }
		} } }
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT update without valid race_id" do
		subject = Factory(:subject)
		login_as admin
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			put :update, :id => subject.id,
				:subject => { :race_id => 0 }
		} } }
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'edit'
	end

end
