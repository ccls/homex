require File.dirname(__FILE__) + '/../test_helper'

class GuidesControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Guide',
		:actions => [:new,:create,:edit,:update,:show,:index,:destroy],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :factory_create
	}

	def factory_attributes(options={})
		Factory.attributes_for(:guide,options)
	end

	def factory_create(options={})
		Factory(:guide,options)
	end

	assert_access_with_login({ 
		:logins => [:superuser,:admin,:editor] })
	assert_no_access_with_login({ 
		:logins => [:interviewer,:reader,:active_user] })
	assert_no_access_without_login

	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:actions => nil,
		:suffix => " and invalid id",
		:login => :superuser,
		:redirect => :guides_path,
		:edit => { :id => 0 },
		:update => { :id => 0 },
		:show => { :id => 0 },
		:destroy => { :id => 0 }
	) 

%w( superuser admin ).each do |cu|

	test "should NOT create new guide with #{cu} login when create fails" do
		Guide.any_instance.stubs(:create_or_update).returns(false)
		login_as send(cu)
		assert_difference('Guide.count',0) do
			post :create, :guide => factory_attributes
		end
		assert assigns(:guide)
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should NOT create new guide with #{cu} login and invalid guide" do
		Guide.any_instance.stubs(:valid?).returns(false)
		login_as send(cu)
		assert_difference('Guide.count',0) do
			post :create, :guide => factory_attributes
		end
		assert assigns(:guide)
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should NOT update guide with #{cu} login when update fails" do
		guide = factory_create
		before = guide.updated_at
		sleep 1	# if updated too quickly, updated_at won't change
		Guide.any_instance.stubs(:create_or_update).returns(false)
		login_as send(cu)
		put :update, :id => guide.id,
			:guide => factory_attributes
		after = guide.reload.updated_at
		assert_equal before.to_i,after.to_i
		assert assigns(:guide)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update guide with #{cu} login and invalid guide" do
		guide = factory_create
		Guide.any_instance.stubs(:valid?).returns(false)
		login_as send(cu)
		put :update, :id => guide.id,
			:guide => factory_attributes
		assert assigns(:guide)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

end

end
