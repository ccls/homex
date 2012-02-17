require 'test_helper'

class StudySubjectsControllerTest < ActionController::TestCase

	setup :create_home_exposure_with_study_subject

	ASSERT_ACCESS_OPTIONS = {
		:model => 'StudySubject',
		:actions => [:new,:create,:edit,:update,:show,:destroy,:index],
		:before => :create_home_exposure_study_subjects,
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_study_subject
	}
	def factory_attributes(options={})
		Factory.attributes_for(:study_subject,{
			:subject_type_id => Factory(:subject_type).id,
			:race_ids => [Factory(:race).id]}.merge(options))
#			:race_id => Factory(:race).id}.merge(options))
	end

	assert_access_with_login({ 
		:actions => [:show,:index],
		:logins => site_readers })
	assert_no_access_with_login({ 
		:actions => [:show,:index],
		:logins => non_site_readers })

	assert_access_with_login({ 
		:actions => [:new,:create,:edit,:update,:destroy],
		:logins => site_editors })
	assert_no_access_with_login({ 
		:actions => [:new,:create,:edit,:update,:destroy],
		:logins => non_site_editors })

	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

	site_editors.each do |cu|

		test "should update with #{cu} login" do
			study_subject = create_study_subject(:updated_at => ( Time.now - 1.day ) )
			login_as send(cu)
			assert_difference('StudySubject.count',0){
			assert_difference('SubjectType.count',0){
			assert_difference('Race.count',0){
			assert_changes("StudySubject.find(#{study_subject.id}).updated_at") {
				put :update, :id => study_subject.id, 
					:study_subject => Factory.attributes_for(:study_subject,
						:sex => 'DK' )	#	sex is M or F in the Factory so DK will make it change
			} } } }
			assert_redirected_to study_subject_path(assigns(:study_subject))
		end

		test "should NOT create with #{cu} login" <<
			" with invalid study_subject" do
			login_as send(cu)
			StudySubject.any_instance.stubs(:valid?).returns(false)
			assert_difference('StudySubject.count',0){
			assert_difference('SubjectType.count',0){
			assert_difference('Race.count',0){
				post :create, :study_subject => {}
			} } }
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'new'
		end

		test "should NOT create with #{cu} login" <<
			" when save fails" do
			login_as send(cu)
			StudySubject.any_instance.stubs(:create_or_update).returns(false)
			assert_difference('StudySubject.count',0){
			assert_difference('SubjectType.count',0){
			assert_difference('Race.count',0){
				post :create, :study_subject => {}
			} } }
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'new'
		end

		test "should NOT create without subject_type_id with #{cu} login" do
			login_as send(cu)
			assert_difference('StudySubject.count',0){
			assert_difference('SubjectType.count',0){
			assert_difference('Race.count',0){
				post :create, 
					:study_subject => Factory.attributes_for(:study_subject,
						:subject_type_id => nil )
			} } }
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'new'
		end

		test "should NOT create without valid subject_type_id with #{cu} login" do
			study_subject = create_study_subject
			login_as send(cu)
			assert_difference('StudySubject.count',0){
			assert_difference('SubjectType.count',0){
			assert_difference('Race.count',0){
				post :create, 
					:study_subject => Factory.attributes_for(:study_subject,
						:subject_type_id => 0 )
			} } }
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'new'
		end

		test "should NOT update without subject_type_id with #{cu} login" do
			study_subject = create_study_subject(:updated_at => ( Time.now - 1.day ) )
			login_as send(cu)
			assert_difference('StudySubject.count',0){
			assert_difference('SubjectType.count',0){
			assert_difference('Race.count',0){
			deny_changes("StudySubject.find(#{study_subject.id}).updated_at") {
				put :update, :id => study_subject.id,
					:study_subject => { :subject_type_id => nil }
			} } } }
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'edit'
		end

		test "should NOT update without valid subject_type_id with #{cu} login" do
			study_subject = create_study_subject(:updated_at => ( Time.now - 1.day ) )
			login_as send(cu)
			assert_difference('StudySubject.count',0){
			assert_difference('SubjectType.count',0){
			assert_difference('Race.count',0){
			deny_changes("StudySubject.find(#{study_subject.id}).updated_at") {
				put :update, :id => study_subject.id,
					:study_subject => { :subject_type_id => 0 }
			} } } }
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'edit'
		end

	end

	non_site_editors.each do |cu|

	end

######################################################################

	site_readers.each do |cu|

		test "study_subjects should include homex study subjects with #{cu} login" do
			login_as send(cu)
			study_subject = Factory(:study_subject)
			Factory(:enrollment,
				:project => Project['HomeExposures'],
				:study_subject => study_subject)
			get :index
			#	'setup' creates a homex subject as well, so this won't work
#			assert_equal [study_subject], assigns(:study_subjects)
			#	but these should
			assert assigns(:study_subjects).include?(study_subject)
			assert_equal 2, assigns(:study_subjects).length
		end

		test "should get index with order and dir desc with #{cu} login" do
			login_as send(cu)
			get :index, :order => 'last_name', :dir => 'desc'
			assert_response :success
			assert_template 'index'
			assert_select ".arrow", :count => 1
			assert_select ".arrow", 1
		end

		test "should get index with order and dir asc with #{cu} login" do
			login_as send(cu)
			get :index, :order => 'last_name', :dir => 'asc'
			assert_response :success
			assert_template 'index'
			assert_select ".arrow", :count => 1
			assert_select ".arrow", 1
		end

		test "should get show with pii with #{cu} login" do
			study_subject = create_study_subject
#			study_subject = create_study_subject(
#				:pii_attributes => Factory.attributes_for(:pii))
			login_as send(cu)
			get :show, :id => study_subject
			assert_response :success
			assert_template 'show'
		end

		test "should have do_not_contact if it is true "<<
				"with #{cu} login" do
			study_subject = create_study_subject(:do_not_contact => true)
			login_as send(cu)
			get :show, :id => study_subject
			assert_response :success
			assert_template 'show'
			assert_select "#do_not_contact", :count => 1
			assert_select "#do_not_contact", 1
		end

		test "should NOT have do_not_contact if it is false "<<
				"with #{cu} login" do
			study_subject = create_study_subject(:do_not_contact => false)
			login_as send(cu)
			get :show, :id => study_subject
			assert_response :success
			assert_template 'show'
			assert_select "#do_not_contact", :count => 0
			assert_select "#do_not_contact", 0
			assert_select "#do_not_contact", false
		end

		test "should have hospital link if study_subject is case "<<
				"with #{cu} login" do
			study_subject = create_study_subject(:subject_type => SubjectType['Case'])
			assert study_subject.reload.is_case?
			login_as send(cu)
			get :show, :id => study_subject
			assert_response :success
			assert_template 'show'
			assert_select "#submenu", :count => 1 do
				assert_select "a", :count => 5
				assert_select "a", 5
				assert_select "a", :count => 1, :text => 'hospital'
	#	apparently 1 doesn't work if :text exists
	#			assert_select "a", 1, :text => 'hospital'
			end
			#	<div id='submenu'>
			#	<a href="/study_subjects/2" class="current">general</a>
			#	<a href="/study_subjects/2/patient">hospital</a>
			#	<a href="/study_subjects/2/contacts">address/contact</a>
			#	<a href="/study_subjects/2/enrollments">eligibility/enrollments</a>
			#	<a href="/study_subjects/2/events">events</a>
			#	</div><!-- submenu -->
		end

		test "should download csv with #{cu} login" do
			login_as send(cu)
			get :index, :commit => 'download'
			assert_response :success
			assert_not_nil @response.headers['Content-disposition'].match(/attachment;.*csv/)
		end
	end

	non_site_readers.each do |cu|

		test "should NOT download csv with #{cu} login" do
			login_as send(cu)
			get :index, :commit => 'download'
			assert_redirected_to root_path
		end

		test "should NOT update with #{cu} login" do
			study_subject = create_study_subject(:updated_at => ( Time.now - 1.day ) )
			login_as send(cu)
			assert_difference('StudySubject.count',0){
			assert_difference('SubjectType.count',0){
			assert_difference('Race.count',0){
			deny_changes("StudySubject.find(#{study_subject.id}).updated_at") {
				put :update, :id => study_subject.id, 
					:study_subject => Factory.attributes_for(:study_subject)
			} } } }
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

	end

	test "should NOT download csv without login" do
		get :index, :commit => 'download'
		assert_redirected_to_login
	end

	test "should NOT update without login" do
		study_subject = create_study_subject(:updated_at => ( Time.now - 1.day ) )
		assert_difference('StudySubject.count',0){
		assert_difference('SubjectType.count',0){
		assert_difference('Race.count',0){
		deny_changes("StudySubject.find(#{study_subject.id}).updated_at") {
			put :update, :id => study_subject.id, 
				:study_subject => Factory.attributes_for(:study_subject)
		} } } }
		assert_redirected_to_login
	end


protected

	def create_home_exposure_study_subjects
		p = Project.find_or_create_by_code('HomeExposures')
		assert_difference('StudySubject.count',3) {
		assert_difference('Enrollment.count',6) {	#	3 ccls and 3 HomeExposures
		3.times {	#do
			s  = create_study_subject
			Factory(:enrollment, :study_subject => s, :project => p )
			s
#		end
		} } }
	end

end
