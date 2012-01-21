require 'test_helper'

class SamplesControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Sample',
		:actions => [:edit,:update,:show,:destroy],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_sample
	}
	def factory_attributes(options={})
		# No attributes from Factory yet
		Factory.attributes_for(:sample,{
			:updated_at => Time.now,
#			:sample_type_id => SampleType.not_roots.first,	
			:sample_type_id => Factory(:sample_type).id,
			:unit_id => Factory(:unit).id }.merge(options))
	end

	assert_access_with_login({ 
		:logins => site_editors })
	assert_no_access_with_login({
		:logins => non_site_editors })
	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

	site_editors.each do |cu|

		test "should get sample index with #{cu} login" do
			login_as send(cu)
			study_subject = create_study_subject	#Factory(:study_subject)
			get :index, :study_subject_id => study_subject.id
			assert_nil flash[:error]
			assert_response :success
			assert_template 'index'
		end

		test "should get new sample with #{cu} login" do
			login_as send(cu)
			study_subject = create_study_subject	#Factory(:study_subject)
			get :new, :study_subject_id => study_subject.id
			assert_nil flash[:error]
			assert_response :success
			assert_template 'new'
		end

		test "should create new sample with #{cu} login" do
			login_as send(cu)
			study_subject = create_study_subject	#Factory(:study_subject)
			assert_difference('Sample.count',1) do
				post :create, :study_subject_id => study_subject.id,
					:sample => factory_attributes
			end
			assert_nil flash[:error]
			assert_redirected_to sample_path(assigns(:sample))
		end

		test "should NOT create with #{cu} login " <<
			"and invalid sample" do
			login_as send(cu)
			Sample.any_instance.stubs(:valid?).returns(false)
			study_subject = create_study_subject	#Factory(:study_subject)
			assert_difference('Sample.count',0) do
				post :create, :study_subject_id => study_subject.id,
					:sample => factory_attributes
			end
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'new'
		end

		test "should NOT create with #{cu} login " <<
			"and save failure" do
			login_as send(cu)
			Sample.any_instance.stubs(:create_or_update).returns(false)
			study_subject = create_study_subject	#Factory(:study_subject)
			assert_difference('Sample.count',0) do
				post :create, :study_subject_id => study_subject.id,
					:sample => factory_attributes
			end
			assert_not_nil flash[:error]
			assert_response :success
			assert_template 'new'
		end

	end

	non_site_editors.each do |cu|

		test "should NOT get sample index with #{cu} login" do
			login_as send(cu)
			study_subject = create_study_subject	#Factory(:study_subject)
			get :index, :study_subject_id => study_subject.id
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should NOT get new sample with #{cu} login" do
			login_as send(cu)
			study_subject = create_study_subject	#Factory(:study_subject)
			get :new, :study_subject_id => study_subject.id
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should NOT create new sample with #{cu} login" do
			login_as send(cu)
			study_subject = create_study_subject	#Factory(:study_subject)
			post :create, :study_subject_id => study_subject.id,
				:sample => factory_attributes
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

	end

	test "should NOT get sample index without login" do
		study_subject = create_study_subject	#Factory(:study_subject)
		get :index, :study_subject_id => study_subject.id
		assert_redirected_to_login
	end

	test "should NOT get new sample without login" do
		study_subject = create_study_subject	#Factory(:study_subject)
		get :new, :study_subject_id => study_subject.id
		assert_redirected_to_login
	end

	test "should NOT create new sample without login" do
		study_subject = create_study_subject	#Factory(:study_subject)
		post :create, :study_subject_id => study_subject.id,
			:sample => factory_attributes
		assert_redirected_to_login
	end

end
