require File.dirname(__FILE__) + '/../../test_helper'

class Hx::SampleKitsControllerTest < ActionController::TestCase

	setup :build_sample_kit
	def build_sample_kit
		@sample_kit = factory_create
		@sample = @sample_kit.sample
	end

	ASSERT_ACCESS_OPTIONS = {
		:model => 'SampleKit',
		:actions => [:show,:edit,:update,:destroy],	#	the shallow routes
		:attributes_for_create => :factory_attributes,
		:method_for_create => :factory_create
	}

	def factory_attributes(options={})
		#	No attributes from Factory yet
		Factory.attributes_for(:sample_kit,{
			:updated_at => Time.now}.merge(options))
	end
	def factory_create(options={})
		Factory(:sample_kit,options)
	end

	assert_access_with_login({ 
		:login => :admin })
	assert_no_access_with_login({ 
		:logins => [:moderator,:editor,:employee,:active_user] })
	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:actions => nil,
		:suffix => " and invalid id",
		:login => :admin,
		:redirect => :hx_subjects_path,
		:edit => { :id => 0 },
		:update => { :id => 0 },
		:show => { :id => 0 },
		:destroy => { :id => 0 }
	) 

#	no route as is has_one

	test "should NOT get index with sample id" do
		assert_raise(ActionController::RoutingError){
			get :index, :sample_id => @sample.id
		}
	end

#	not logged in

	test "should NOT get new without login" do
		get :new, :sample_id => @sample.id
		assert_redirected_to_login
	end

	test "should NOT post create without login" do
		assert_difference('SampleKit.count',0){
			post :create, :sample_id => @sample.id, 
				:sample_kit => factory_attributes
		}
		assert_redirected_to_login
	end

%w( admin ).each do |cu|

	test "should get new with #{cu} login" do
		login_as send(cu)
		get :new, :sample_id => @sample.id
		assert_response :success
		assert_template 'new'
		assert assigns(:sample_kit)
#		assert_layout 'home_exposure'
	end

	test "should post create with #{cu} login" do
		login_as send(cu)
		assert_difference('SampleKit.count',1) {
			post :create, :sample_id => @sample.id,
				:sample_kit => factory_attributes
		}
		assert_redirected_to hx_subject_path(assigns(:sample_kit).sample.subject)
	end

	test "should get show with #{cu} login and packages" do
		sk = factory_create(
			:kit_package_attributes  => Factory.attributes_for(:package),
			:sample_package_attributes => Factory.attributes_for(:package)
		)
		login_as send(cu)
		get :show, :id => sk.id
		assert_response :success
		assert_template 'show'
		assert assigns(:sample_kit)
	end

#	no sample_id

	test "should get new without sample_id with #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			get :new
		}
	end

	test "should post create without sample_id with #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
		assert_difference('SampleKit.count',0) {
			post :create,
				:sample_kit => factory_attributes
		} }
	end

#	no id

	test "should get edit without id with #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			get :edit
		}
	end

	test "should put update without id with #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			put :update,
				:sample_kit => factory_attributes
		}
	end

	test "should get show without id with #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			get :show
		}
	end

	test "should delete destroy without id with #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
		assert_difference('SampleKit.count',0){
			delete :destroy
		} }
	end

#	save errors

	test "should NOT post create with empty packages with #{cu} login" do
		login_as send(cu)
		assert_difference('SampleKit.count',0) {
			post :create, :sample_id => @sample.id,
				:sample_kit => {
					:kit_package_attributes  => {},
					:sample_package_attributes => {} 
				}
		}
		assert_response :success
		assert_template 'new'
	end

	test "should NOT post create with save failure with #{cu} login" do
		login_as send(cu)
		SampleKit.any_instance.stubs(:create_or_update).returns(false)
		assert_difference('SampleKit.count',0) {
			post :create, :sample_id => @sample.id,
				:sample_kit => factory_attributes
		}
		assert_response :success
		assert_template 'new'
	end

	test "should NOT put update with empty packages with #{cu} login" do
		login_as send(cu)
		put :update, :id => @sample_kit.id,
			:sample_kit => {
				:kit_package_attributes  => {},
				:sample_package_attributes => {} 
			}
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT put update with save failure with #{cu} login" do
		login_as send(cu)
		SampleKit.any_instance.stubs(:create_or_update).returns(false)
		put :update, :id => @sample_kit.id,
			:sample_kit => factory_attributes
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT delete destroy with destruction failure with #{cu} login" do
		login_as send(cu)
		SampleKit.any_instance.stubs(:new_record?).returns(true)
		assert_difference('SampleKit.count',0){
			delete :destroy, :id => @sample_kit.id
		}
		assert_redirected_to hx_subject_path(assigns(:sample_kit).sample.subject)
	end

#	INVALID sample_id

	test "should NOT get new with invalid sample_id with #{cu} login" do
		login_as send(cu)
		get :new, :sample_id => 0
		assert_redirected_to hx_subjects_path
		assert_not_nil flash[:error]
	end

	test "should NOT post create with invalid sample_id with #{cu} login" do
		login_as send(cu)
		assert_difference('SampleKit.count',0) {
			post :create, :sample_id => 0,
				:sample_kit => factory_attributes
		}
		assert_redirected_to hx_subjects_path
		assert_not_nil flash[:error]
	end


#	invalid sample kit
#	(no validations yet so no tests yet)

end

%w( editor employee moderator active_user ).each do |cu|

	test "should NOT get new with #{cu} login" do
		login_as send(cu)
		get :new, :sample_id => @sample.id
		assert_redirected_to root_path
	end

	test "should NOT post create with #{cu} login" do
		login_as send(cu)
		assert_difference('SampleKit.count',0) {
			post :create, :sample_id => @sample.id,
				:sample_kit => factory_attributes
		}
		assert_redirected_to root_path
	end

end

end
