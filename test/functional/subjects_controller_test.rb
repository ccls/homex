require File.dirname(__FILE__) + '/../test_helper'

class SubjectsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Subject',
		:attributes_for_create => :factory_attributes,
		:method_for_create => :factory_create
	}

	def factory_attributes
		Factory.attributes_for(:subject)
	end
	def factory_create
		Factory(:subject)
	end

	assert_access_with_login :new,:edit,:update,:show,:destroy,:index,{
		:login => :admin }

	assert_access_with_login :new,:edit,:update,:show,:destroy,:index,{
		:login => :employee }

	assert_access_with_login :new,:edit,:update,:show,:destroy,:index,{
		:login => :editor }

	assert_no_access_with_login :new,:create,:edit,:update,:show,:destroy,:index,{
		:login => :active_user }

	assert_no_access_without_login :new,:edit,:update,:show,:destroy,:index


	#	can't test create due to other requirements
	assert_access_with_https :new,:edit,:update,:show,:destroy,:index

	assert_no_access_with_http :new,:create,:edit,:update,:show,:destroy,:index

	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:suffix => " and invalid id",
		:login => :admin,
		:redirect => :subjects_path,
		:edit => { :id => 0 },
		:update => { :id => 0 },
		:show => { :id => 0 },
		:destroy => { :id => 0 }
	) 

	test "should get index with subjects" do
		survey = Survey.find_by_access_code("home_exposure_survey")
		rs1 = fill_out_survey(:survey => survey)
		rs2 = fill_out_survey(:survey => survey, :subject => rs1.subject)
		rs2.to_her
		rs3 = fill_out_survey(:survey => survey)
		rs4 = fill_out_survey(:survey => survey, :subject => rs3.subject)
		rs5 = fill_out_survey(:survey => survey)
		Factory(:subject)
		Factory(:study_event)	#	test search code in view
		#	There should now be 4 subjects in different states.
		login_as admin_user
		get :index
		assert_response :success
		assert_template 'index'
	end

	test "should get show with pii" do
		subject = Factory(:subject,
			:pii_attributes => Factory.attributes_for(:pii))
		login_as admin_user
		get :show, :id => subject
		assert_response :success
		assert_template 'show'
	end




	test "new subject should have non nil pii" do
		login_as admin
		get :new
		assert_not_nil assigns(:subject)
		assert_not_nil assigns(:subject).pii
	end

%w( admin employee editor ).each do |cu|
	
	test "should create with #{cu} login" do
		login_as send(cu)
		Factory(:race)
		Factory(:subject_type)
		assert_difference('Subject.count',1){
			post :create, :subject => Factory.attributes_for(:subject,
				:race_id => Race.first.id,
				:subject_type_id => SubjectType.first.id)
		}
		assert_redirected_to subject_path(assigns(:subject))
	end

end

%w( active_user ).each do |cu|

	test "should NOT create with #{cu} login" do
		login_as send(cu)
		Factory(:race)
		Factory(:subject_type)
		assert_difference('Subject.count',0){
			post :create, :subject => Factory.attributes_for(:subject,
				:race_id => Race.first.id,
				:subject_type_id => SubjectType.first.id)
		}
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

end

	test "should NOT create without login" do
		Factory(:race)
		Factory(:subject_type)
		post :create, :subject => Factory.attributes_for(:subject,
			:race_id => Race.first.id,
			:subject_type_id => SubjectType.first.id)
		assert_redirected_to_login
	end

	test "should NOT create with invalid subject" do
		pending
#
#	subject has no validations so cannot test yet
#
#		login_as admin
#		Factory(:race)
#		Factory(:subject_type)
#		assert_difference('Subject.count',0){
#			post :create, :subject => {
#				:race_id => Race.first.id,
#				:subject_type_id => SubjectType.first.id}
#		}
#		assert_response :success
#		assert_template 'new'
#		assert_not_nil flash[:error]
	end

	test "should NOT create without subject_type" do
		login_as admin
		Factory(:race)
		Factory(:subject_type)
		assert_difference('Subject.count',0){
			post :create, :subject => Factory.attributes_for(:subject,
				:race_id => Race.first.id)
		}
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should NOT create without race" do
		login_as admin
		Factory(:race)
		Factory(:subject_type)
		assert_difference('Subject.count',0){
			post :create, :subject => Factory.attributes_for(:subject,
				:subject_type_id => SubjectType.first.id)
		}
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should NOT create without valid subject_type" do
		login_as admin
		Factory(:race)
		Factory(:subject_type)
		assert_difference('Subject.count',0){
			post :create, :subject => Factory.attributes_for(:subject,
				:subject_type_id => 0,
				:race_id => Race.first.id)
		}
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should NOT create without valid race" do
		login_as admin
		Factory(:race)
		Factory(:subject_type)
		assert_difference('Subject.count',0){
			post :create, :subject => Factory.attributes_for(:subject,
				:race_id => 0,
				:subject_type_id => SubjectType.first.id)
		}
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
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
