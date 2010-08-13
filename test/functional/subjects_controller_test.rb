require File.dirname(__FILE__) + '/../test_helper'

class SubjectsControllerTest < ActionController::TestCase

	setup :create_home_exposure_with_subject

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Subject',
		:actions => [:new,:create,:edit,:update,:show,:destroy,:index],
		:before => :create_home_exposure_subjects,
		:attributes_for_create => :factory_attributes,
		:method_for_create => :factory_create
	}
	def factory_attributes(options={})
		Factory.attributes_for(:subject,{
			:subject_type_id => Factory(:subject_type).id,
			:race_id => Factory(:race).id}.merge(options))
	end
	def factory_create(options={})
		Factory(:subject,options)
	end

	assert_access_with_login({ 
		:logins => [:superuser,:admin,:editor,:interviewer,:reader] })
	assert_no_access_with_login({ 
		:logins => [:active_user] })
	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:actions => nil,
		:suffix => " and invalid id",
		:redirect => :subjects_path,
		:login => :superuser,
		:update => { :id => 0 },
		:destroy => { :id => 0 },
		:edit => { :id => 0 },
		:show => { :id => 0 }
	)

%w( superuser admin editor interviewer reader ).each do |cu|

	test "should get index with subjects with #{cu} login" do
		survey = Survey.find_by_access_code("home_exposure_survey")
		rs1 = fill_out_survey(:survey => survey)
		rs2 = fill_out_survey(:survey => survey, :subject => rs1.subject)
		rs2.to_her
		rs3 = fill_out_survey(:survey => survey)
		rs4 = fill_out_survey(:survey => survey, :subject => rs3.subject)
		rs5 = fill_out_survey(:survey => survey)
		Factory(:project)	#	test search code in view
		#	There should now be 4 subjects in different states.
		login_as send(cu)
		get :index
		assert_equal 1, assigns(:subjects).length
		assert_response :success
		assert_template 'index'
#		assert_layout 'home_exposure'
	end

	test "should get index with order and dir desc with #{cu} login" do
		login_as send(cu)
		get :index, :order => 'last_name', :dir => 'desc'
		assert_response :success
		assert_template 'index'
		assert_select "span.arrow", :count => 1
	end

	test "should get index with order and dir asc with #{cu} login" do
		login_as send(cu)
		get :index, :order => 'last_name', :dir => 'asc'
		assert_response :success
		assert_template 'index'
		assert_select "span.arrow", :count => 1
	end

	test "should get show with pii with #{cu} login" do
		subject = factory_create(
			:pii_attributes => Factory.attributes_for(:pii))
		login_as send(cu)
		get :show, :id => subject
		assert_response :success
		assert_template 'show'
#		assert_layout 'home_exposure'
	end

	test "should download csv with #{cu} login" do
		login_as send(cu)
		get :index, :commit => 'download'
		assert_response :success
		assert_not_nil @response.headers['Content-disposition'].match(/attachment;.*csv/)
	end

	test "should update with #{cu} login" do
		subject = factory_create
		login_as send(cu)
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			put :update, :id => subject.id, 
				:subject => Factory.attributes_for(:subject)
		} } }
		assert_redirected_to subject_path(assigns(:subject))
	end



	test "should NOT create without subject_type_id with #{cu} login" do
		login_as send(cu)
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			post :create, 
				:subject => Factory.attributes_for(:subject,
					:subject_type_id => nil )
		} } }
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create without race_id with #{cu} login" do
		subject = factory_create
		login_as send(cu)
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			post :create, 
				:subject => Factory.attributes_for(:subject,
					:race_id => nil )
		} } }
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create without valid subject_type_id with #{cu} login" do
		subject = factory_create
		login_as send(cu)
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			post :create, 
				:subject => Factory.attributes_for(:subject,
					:subject_type_id => 0 )
		} } }
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create without valid race_id with #{cu} login" do
		subject = factory_create
		login_as send(cu)
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			post :create, 
				:subject => Factory.attributes_for(:subject,
					:race_id => 0 )
		} } }
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end


	test "should NOT update without subject_type_id with #{cu} login" do
		subject = factory_create
		login_as send(cu)
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

	test "should NOT update without race_id with #{cu} login" do
		subject = factory_create
		login_as send(cu)
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

	test "should NOT update without valid subject_type_id with #{cu} login" do
		subject = factory_create
		login_as send(cu)
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

	test "should NOT update without valid race_id with #{cu} login" do
		subject = factory_create
		login_as send(cu)
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

%w( active_user ).each do |cu|

	test "should NOT download csv with #{cu} login" do
		login_as send(cu)
		get :index, :commit => 'download'
		assert_redirected_to root_path
	end

	test "should NOT update with #{cu} login" do
		subject = factory_create
		login_as send(cu)
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
		subject = factory_create
		assert_difference('Subject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
			put :update, :id => subject.id, 
				:subject => Factory.attributes_for(:subject)
		} } }
		assert_redirected_to_login
	end


protected

	def create_home_exposure_subjects
		p = Project.find_or_create_by_code('HomeExposures')
		3.times do
			s  = factory_create
			Factory(:enrollment, :subject => s, :project => p )
			s
		end
	end

end
