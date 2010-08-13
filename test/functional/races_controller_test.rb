require File.dirname(__FILE__) + '/../test_helper'

class RacesControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Race',
		:actions => [:new,:create,:edit,:update,:show,:destroy,:index],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :factory_create
	}
	def factory_attributes(options={})
		Factory.attributes_for(:race,options)
	end
	def factory_create(options={})
		Factory(:race,options)
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
		:redirect => :races_path,
		:edit => { :id => 0 },
		:update => { :id => 0 },
		:show => { :id => 0 },
		:destroy => { :id => 0 }
	)

%w( superuser admin ).each do |cu|

	test "should NOT create new race with #{cu} login when create fails" do
		Race.any_instance.stubs(:create_or_update).returns(false)
		login_as send(cu)
		assert_difference('Race.count',0) do
			post :create, :race => factory_attributes
		end
		assert assigns(:race)
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should NOT create new race with #{cu} login and invalid race" do
		login_as send(cu)
		assert_difference('Race.count',0) do
			post :create, :race => { }
		end
		assert assigns(:race)
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should NOT update race with #{cu} login when update fails" do
		race = factory_create
		before = race.updated_at
		sleep 1	# if updated too quickly, updated_at won't change
		Race.any_instance.stubs(:create_or_update).returns(false)
		login_as send(cu)
		put :update, :id => race.id,
			:race => factory_attributes
		after = race.reload.updated_at
		assert_equal before.to_i,after.to_i
		assert assigns(:race)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update race with #{cu} login and invalid race" do
		race = factory_create
		login_as send(cu)
		put :update, :id => race.id,
			:race => { :code => nil }
		assert assigns(:race)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

end

end
