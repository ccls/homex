require File.dirname(__FILE__) + '/../../test_helper'

class He::SubjectsControllerTest < ActionController::TestCase

	setup :create_home_exposure_with_subject

	ASSERT_ACCESS_OPTIONS = {
		:factory => :subject
	}

	assert_access_with_login :edit,:update,:show,:destroy,:index,{
		:before => :create_home_exposure_subjects,
		:login => :admin }

	assert_access_with_login :edit,:update,:show,:destroy,:index,{
		:before => :create_home_exposure_subjects,
		:login => :employee }

	assert_access_with_login :edit,:update,:show,:destroy,:index,{
		:before => :create_home_exposure_subjects,
		:login => :editor }

	assert_no_access_with_login :edit,:update,:show,:destroy,:index,{
		:login => :active_user }

	assert_no_access_without_login :edit,:update,:show,:destroy,:index

	assert_access_with_https :edit,:update,:show,:destroy,:index,{
		:before => :create_home_exposure_subjects }

	assert_no_access_with_http :edit,:update,:show,:destroy,:index

	assert_no_access_with_login(
		:factory => nil,	#	override the default setting from above
		:model => 'Subject',
		:suffix => " and invalid id",
		:redirect => :he_subjects_path,
		:login => :admin,
		:destroy => { :id => 0 },
		:edit => { :id => 0 },
		:show => { :id => 0 }
	)

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

	test "should get index with order and dir desc" do
		login_as admin
		get :index, :order => 'last_name', :dir => 'desc'
		assert_response :success
		assert_template 'index'
		assert_select "span.arrow", :count => 1
	end

	test "should get index with order and dir asc" do
		login_as admin
		get :index, :order => 'last_name', :dir => 'asc'
		assert_response :success
		assert_template 'index'
		assert_select "span.arrow", :count => 1
	end

	test "should get show with pii" do
		subject = Factory(:subject,
			:pii_attributes => Factory.attributes_for(:pii))
		login_as admin_user
		get :show, :id => subject
		assert_response :success
		assert_template 'show'
	end

%w( admin employee editor ).each do |u|

	test "should download csv with #{u} login" do
		login_as send(u)
		get :index, :commit => 'download'
		assert_response :success
		assert_not_nil @response.headers['Content-disposition'].match(/attachment;.*csv/)
	end

	test "should update with #{u} login" do
		subject = Factory(:subject)
		login_as send(u)
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			put :update, :id => subject.id, 
				:subject => Factory.attributes_for(:subject)
		} } }
		assert_redirected_to he_subject_path(assigns(:subject))
	end

end

%w( active_user ).each do |u|

	test "should NOT download csv with #{u} login" do
		login_as send(u)
		get :index, :commit => 'download'
		assert_redirected_to root_path
	end

	test "should NOT update with #{u} login" do
		subject = Factory(:subject)
		login_as send(u)
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			put :update, :id => subject.id, 
				:subject => Factory.attributes_for(:subject)
		} } }
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

end

	test "should NOT download csv without login" do
		get :index, :commit => 'download'
		assert_redirected_to_login
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

protected

	def create_home_exposure_subjects
		se = StudyEvent.find_or_create_by_description('Home Exposure')
		3.times do
			s  = Factory(:subject)
			Factory(:project_subject, :subject => s, :study_event => se )
			s
		end
	end

end
