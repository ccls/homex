require File.dirname(__FILE__) + '/../test_helper'

class UnusedSubjectsControllerTest < ActionController::TestCase
#	#	tests SubjectsController
#	
#		ASSERT_ACCESS_OPTIONS = {
#			:model => 'Subject',
#			:actions => [:new,:edit,:update,:show,:destroy,:index],
#			:attributes_for_create => :factory_attributes,
#			:method_for_create => :factory_create
#		}
#	
#		def factory_attributes(options={})
#			Factory.attributes_for(:subject,options)
#		end
#		def factory_create(options={})
#			Factory(:subject,options)
#		end
#	
#		assert_access_with_login({ 
#			:logins => [:superuser,:admin,:reader,:editor] })
#		assert_no_access_with_login( :create, { 
#			:logins => [:active_user] })
#		assert_no_access_without_login
#	
#		#	can't test create due to other requirements
#		assert_access_with_https
#		assert_no_access_with_http :create
#	
#		assert_no_access_with_login(
#			:attributes_for_create => nil,
#			:method_for_create => nil,
#			:actions => nil,
#			:suffix => " and invalid id",
#			:login => :superuser,
#			:redirect => :subjects_path,
#			:edit => { :id => 0 },
#			:update => { :id => 0 },
#			:show => { :id => 0 },
#			:destroy => { :id => 0 }
#		) 
#	
#	
#	
#	%w( superuser admin reader editor ).each do |cu|
#	
#		test "should get index with subjects with #{cu} login" do
#			survey = Survey.find_by_access_code("home_exposure_survey")
#			rs1 = fill_out_survey(:survey => survey)
#			rs2 = fill_out_survey(:survey => survey, :subject => rs1.subject)
#			rs2.to_her
#			rs3 = fill_out_survey(:survey => survey)
#			rs4 = fill_out_survey(:survey => survey, :subject => rs3.subject)
#			rs5 = fill_out_survey(:survey => survey)
#			factory_create
#			Factory(:project)	#	test search code in view
#			#	There should now be 4 subjects in different states.
#			login_as send(cu)
#			get :index
#			assert_response :success
#			assert_template 'index'
#		end
#	
#		test "should get show with pii with #{cu} login" do
#			subject = factory_create(
#				:pii_attributes => Factory.attributes_for(:pii))
#			login_as send(cu)
#			get :show, :id => subject
#			assert_response :success
#			assert_template 'show'
#		end
#	
#		test "new subject should have non nil pii with #{cu} login" do
#			login_as send(cu)
#			get :new
#			assert_not_nil assigns(:subject)
#			assert_not_nil assigns(:subject).pii
#		end
#		
#		test "should create with #{cu} login" do
#			login_as send(cu)
#			assert_difference('Subject.count',1){
#				post :create, :subject => factory_attributes(
#					:race_id => Race.first.id,
#					:subject_type_id => SubjectType.first.id)
#			}
#			assert_redirected_to subject_path(assigns(:subject))
#		end
#	
#		test "should NOT create without subject_type with #{cu} login" do
#			login_as send(cu)
#			assert_difference('Subject.count',0){
#				post :create, :subject => factory_attributes(
#					:race_id => Race.first.id)
#			}
#			assert_response :success
#			assert_template 'new'
#			assert_not_nil flash[:error]
#		end
#	
#		test "should NOT create without race with #{cu} login" do
#			login_as send(cu)
#			assert_difference('Subject.count',0){
#				post :create, :subject => factory_attributes(
#					:subject_type_id => SubjectType.first.id)
#			}
#			assert_response :success
#			assert_template 'new'
#			assert_not_nil flash[:error]
#		end
#	
#		test "should NOT create without valid subject_type with #{cu} login" do
#			login_as send(cu)
#			assert_difference('Subject.count',0){
#				post :create, :subject => factory_attributes(
#					:subject_type_id => 0,
#					:race_id => Race.first.id)
#			}
#			assert_response :success
#			assert_template 'new'
#			assert_not_nil flash[:error]
#		end
#	
#		test "should NOT create without valid race with #{cu} login" do
#			login_as send(cu)
#			assert_difference('Subject.count',0){
#				post :create, :subject => factory_attributes(
#					:race_id => 0,
#					:subject_type_id => SubjectType.first.id)
#			}
#			assert_response :success
#			assert_template 'new'
#			assert_not_nil flash[:error]
#		end
#	
#	
#		test "should NOT update without subject_type_id with #{cu} login" do
#			subject = factory_create
#			login_as send(cu)
#			assert_difference('Subject.count',0){
#			assert_difference('SubjectType.count',0){
#			assert_difference('Race.count',0){
#				put :update, :id => subject.id,
#					:subject => { :subject_type_id => nil }
#			} } }
#			assert_not_nil flash[:error]
#			assert_response :success
#			assert_template 'edit'
#		end
#	
#		test "should NOT update without race_id with #{cu} login" do
#			subject = factory_create
#			login_as send(cu)
#			assert_difference('Subject.count',0){
#			assert_difference('SubjectType.count',0){
#			assert_difference('Race.count',0){
#				put :update, :id => subject.id,
#					:subject => { :race_id => nil }
#			} } }
#			assert_not_nil flash[:error]
#			assert_response :success
#			assert_template 'edit'
#		end
#	
#		test "should NOT update without valid subject_type_id with #{cu} login" do
#			subject = factory_create
#			login_as send(cu)
#			assert_difference('Subject.count',0){
#			assert_difference('SubjectType.count',0){
#			assert_difference('Race.count',0){
#				put :update, :id => subject.id,
#					:subject => { :subject_type_id => 0 }
#			} } }
#			assert_not_nil flash[:error]
#			assert_response :success
#			assert_template 'edit'
#		end
#	
#		test "should NOT update without valid race_id with #{cu} login" do
#			subject = factory_create
#			login_as send(cu)
#			assert_difference('Subject.count',0){
#			assert_difference('SubjectType.count',0){
#			assert_difference('Race.count',0){
#				put :update, :id => subject.id,
#					:subject => { :race_id => 0 }
#			} } }
#			assert_not_nil flash[:error]
#			assert_response :success
#			assert_template 'edit'
#		end
#	
#		test "should NOT create without subjectid with #{cu} login" do
#			login_as send(cu)
#			assert_difference('Subject.count',0){
#				post :create, :subject => factory_attributes(
#					:subjectid => nil,
#					:race_id => Race.first.id,
#					:subject_type_id => SubjectType.first.id)
#			}
#			assert_response :success
#			assert_template 'new'
#			assert_not_nil flash[:error]
#		end
#	
#	end
#	
#	%w( active_user ).each do |cu|
#	
#		test "should NOT create with #{cu} login" do
#			login_as send(cu)
#			assert_difference('Subject.count',0){
#				post :create, :subject => factory_attributes(
#					:race_id => Race.first.id,
#					:subject_type_id => SubjectType.first.id)
#			}
#			assert_not_nil flash[:error]
#			assert_redirected_to root_path
#		end
#	
#	end
#	
#		test "should NOT create without login" do
#			post :create, :subject => factory_attributes(
#				:race_id => Race.first.id,
#				:subject_type_id => SubjectType.first.id)
#			assert_redirected_to_login
#		end
#	
end
