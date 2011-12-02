require 'test_helper'

class InterviewsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Interview',
		:actions => [:show,:edit,:update,:destroy],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_interview_with_study_subject
	}
	def factory_attributes(options={})
		#	no attributes to trigger updated_at
		Factory.attributes_for(:interview,{
			:updated_at => Time.now
		}.merge(options))
	end

	assert_access_with_login({ 
		:logins => site_editors })
	assert_no_access_with_login({
		:logins => non_site_editors })
	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

#	TODO duplicate?
	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:actions => nil,
		:suffix => " and invalid id",
		:login => :superuser,
		:redirect => :study_subjects_path,
		:show => { :id => 0 },
		:edit => { :id => 0 },
		:update => { :id => 0 },
		:destroy => { :id => 0 }
	) 

	site_editors.each do |cu|
	
	#	test "should NOT create new interview with #{cu} login when create fails" do
	#		Interview.any_instance.stubs(:create_or_update).returns(false)
	#		login_as send(cu)
	#		assert_difference('Interview.count',0) do
	#			post :create, :interview => factory_attributes
	#		end
	#		assert assigns(:interview)
	#		assert_response :success
	#		assert_template 'new'
	#		assert_not_nil flash[:error]
	#	end
	#
	#	test "should NOT create new interview with #{cu} login and invalid interview" do
	#		Interview.any_instance.stubs(:valid?).returns(false)
	#		login_as send(cu)
	#		assert_difference('Interview.count',0) do
	#			post :create, :interview => factory_attributes
	#		end
	#		assert assigns(:interview)
	#		assert_response :success
	#		assert_template 'new'
	#		assert_not_nil flash[:error]
	#	end
	
#	TODO duplicate?
		test "should NOT update interview with #{cu} login " <<
			"when update fails" do
			interview = create_interview_with_study_subject(
				:updated_at => ( Time.now - 1.day ) )
			Interview.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			deny_changes("Interview.find(#{interview.id}).updated_at") {
				put :update, :id => interview.id,
					:interview => factory_attributes
			}
			assert assigns(:interview)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end
	
#	TODO duplicate?
		test "should NOT update interview with #{cu} login " <<
			"and invalid interview" do
			interview = create_interview_with_study_subject(
				:updated_at => ( Time.now - 1.day ) )
			Interview.any_instance.stubs(:valid?).returns(false)
			login_as send(cu)
			deny_changes("Interview.find(#{interview.id}).updated_at") {
				put :update, :id => interview.id,
					:interview => factory_attributes
			}
			assert assigns(:interview)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end
	
	
	
	#		test "should get interview index with #{cu} login" do
	#			login_as send(cu)
	#	#		study_subject = Factory(:study_subject)
	#			study_subject = Factory(:identifier).study_subject
	#			get :index, :study_subject_id => study_subject.id
	#			assert_nil flash[:error]
	#			assert_response :success
	#			assert_template 'index'
	#		end
	
	#		test "should get new interview with #{cu} login" do
	#			login_as send(cu)
	#	#		study_subject = Factory(:study_subject)
	#			study_subject = Factory(:identifier).study_subject
	#			get :new, :study_subject_id => study_subject.id
	#			assert_nil flash[:error]
	#			assert_response :success
	#			assert_template 'new'
	#		end
	#	
	#		test "should create new interview with #{cu} login" do
	#			login_as send(cu)
	#	#		study_subject = Factory(:study_subject)
	#			study_subject = Factory(:identifier).study_subject
	#			assert_difference('Interview.count',1) do
	#				post :create, :study_subject_id => study_subject.id,
	#					:interview => factory_attributes
	#			end
	#			assert_nil flash[:error]
	#			assert_redirected_to interview_path(assigns(:interview))
	#		end
	#	
	#		test "should NOT create with invalid interview and #{cu} login" do
	#			login_as send(cu)
	#	#		study_subject = Factory(:study_subject)
	#			study_subject = Factory(:identifier).study_subject
	#			assert_difference('Interview.count',0) do
	#				post :create, :study_subject_id => study_subject.id,
	#					:interview => {}
	#			end
	#			assert_not_nil flash[:error]
	#			assert_response :success
	#			assert_template 'new'
	#		end
	
	#		test "should NOT update with invalid interview and #{cu} login" do
	#			pending
	#	#	no validations
	#			login_as send(cu)
	#			interview = create_interview
	#			put :update, :id => interview.id,
	#				:interview => { }										#	make invalid
	#			assert_not_nil flash[:error]
	#			assert_response :success
	#			assert_template 'edit'
	#		end
	
	end
	
	non_site_editors.each do |cu|
	
	#		test "should NOT get interview index with #{cu} login" do
	#			login_as send(cu)
	#	#		study_subject = Factory(:study_subject)
	#			study_subject = Factory(:identifier).study_subject
	#			get :index, :study_subject_id => study_subject.id
	#			assert_not_nil flash[:error]
	#			assert_redirected_to root_path
	#		end
	#	
	#		test "should NOT get new interview with #{cu} login" do
	#			login_as send(cu)
	#	#		study_subject = Factory(:study_subject)
	#			study_subject = Factory(:identifier).study_subject
	#			get :new, :study_subject_id => study_subject.id
	#			assert_not_nil flash[:error]
	#			assert_redirected_to root_path
	#		end
	#	
	#		test "should NOT create new interview with #{cu} login" do
	#			login_as send(cu)
	#	#		study_subject = Factory(:study_subject)
	#			study_subject = Factory(:identifier).study_subject
	#			post :create, :study_subject_id => study_subject.id,
	#				:interview => factory_attributes
	#			assert_not_nil flash[:error]
	#			assert_redirected_to root_path
	#		end
	
	end

#		test "should NOT get interview index without login" do
#	#		study_subject = Factory(:study_subject)
#			study_subject = Factory(:identifier).study_subject
#			get :index, :study_subject_id => study_subject.id
#			assert_redirected_to_login
#		end

#		test "should NOT get new interview without login" do
#	#		study_subject = Factory(:study_subject)
#			study_subject = Factory(:identifier).study_subject
#			get :new, :study_subject_id => study_subject.id
#			assert_redirected_to_login
#		end
#	
#		test "should NOT create new interview without login" do
#	#		study_subject = Factory(:study_subject)
#			study_subject = Factory(:identifier).study_subject
#			post :create, :study_subject_id => study_subject.id,
#				:interview => factory_attributes
#			assert_redirected_to_login
#		end

protected

	#	TODO clean this up
	def create_interview_with_study_subject(options={})
		assert_difference('Interview.count',1) {
#		assert_difference('Identifier.count',1) {
		assert_difference('StudySubject.count',1) {
			@interview = create_interview(options)
			assert_not_nil @interview.id
#			assert_not_nil @interview.identifier
#			assert_not_nil @interview.identifier.id
			assert_not_nil @interview.study_subject
			assert_not_nil @interview.study_subject.id
#			study_subject = create_study_subject
#			identifier = @interview.identifier
#			identifier.study_subject = study_subject
#			identifier.save
#			assert_not_nil @interview.identifier.study_subject
#			assert_not_nil @interview.identifier.study_subject.id
#			@interview.reload
#			assert_not_nil @interview.study_subject
		} } #}
		@interview
	end

end
