require File.dirname(__FILE__) + '/../test_helper'

class SamplesControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Sample',
		:actions => [:edit,:update,:show,:destroy],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :factory_create
	}
	def factory_attributes(options={})
		# No attributes from Factory yet
		Factory.attributes_for(:sample,{
			:updated_at => Time.now,
#			:sample_type_id => SampleType.not_roots.first,	
			:sample_type_id => Factory(:sample_type).id,
			:unit_id => Factory(:unit).id }.merge(options))
	end
	def factory_create(options={})
		Factory(:sample,options)
	end

	assert_access_with_login({ 
		:logins => [:superuser,:admin] })
	assert_no_access_with_login({
		:logins => [:editor,:interviewer,:reader,:active_user] })
	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:actions => nil,
		:suffix => " and invalid id",
		:login => :superuser,
		:redirect => :subjects_path,
		:edit => { :id => 0 },
		:update => { :id => 0 },
		:show => { :id => 0 },
		:destroy => { :id => 0 }
	) 

%w( superuser admin ).each do |cu|

	test "should get sample index with #{cu} login" do
		login_as send(cu)
		subject = Factory(:subject)
		get :index, :subject_id => subject.id
		assert_nil flash[:error]
		assert_response :success
		assert_template 'index'
	end

	test "should get new sample with #{cu} login" do
		login_as send(cu)
		subject = Factory(:subject)
		get :new, :subject_id => subject.id
		assert_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should create new sample with #{cu} login" do
		login_as send(cu)
		subject = Factory(:subject)
		assert_difference('Sample.count',1) do
			post :create, :subject_id => subject.id,
				:sample => factory_attributes
		end
		assert_nil flash[:error]
		assert_redirected_to sample_path(assigns(:sample))
	end

	test "should NOT create with #{cu} login " <<
		"and invalid sample" do
		login_as send(cu)
		Sample.any_instance.stubs(:valid?).returns(false)
		subject = Factory(:subject)
		assert_difference('Sample.count',0) do
			post :create, :subject_id => subject.id,
				:sample => factory_attributes
		end
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT update with #{cu} login " <<
		"and invalid sample" do
		login_as send(cu)
		sample = factory_create
		Sample.any_instance.stubs(:valid?).returns(false)
		put :update, :id => sample.id,
			:sample => factory_attributes
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT create with #{cu} login " <<
		"and save failure" do
		login_as send(cu)
		Sample.any_instance.stubs(:create_or_update).returns(false)
		subject = Factory(:subject)
		assert_difference('Sample.count',0) do
			post :create, :subject_id => subject.id,
				:sample => factory_attributes
		end
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT update with #{cu} login " <<
		"and save failure" do
		login_as send(cu)
		sample = factory_create
		Sample.any_instance.stubs(:create_or_update).returns(false)
		put :update, :id => sample.id,
			:sample => factory_attributes
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'edit'
	end

end

%w( editor interviewer reader active_user ).each do |cu|

	test "should NOT get sample index with #{cu} login" do
		login_as send(cu)
		subject = Factory(:subject)
		get :index, :subject_id => subject.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT get new sample with #{cu} login" do
		login_as send(cu)
		subject = Factory(:subject)
		get :new, :subject_id => subject.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT create new sample with #{cu} login" do
		login_as send(cu)
		subject = Factory(:subject)
		post :create, :subject_id => subject.id,
			:sample => factory_attributes
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

end

	test "should NOT get sample index without login" do
		subject = Factory(:subject)
		get :index, :subject_id => subject.id
		assert_redirected_to_login
	end

	test "should NOT get new sample without login" do
		subject = Factory(:subject)
		get :new, :subject_id => subject.id
		assert_redirected_to_login
	end

	test "should NOT create new sample without login" do
		subject = Factory(:subject)
		post :create, :subject_id => subject.id,
			:sample => factory_attributes
		assert_redirected_to_login
	end

end
