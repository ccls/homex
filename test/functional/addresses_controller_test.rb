require File.dirname(__FILE__) + '/../test_helper'

class AddressesControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Address',
		:actions => [:edit,:update],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :factory_create
	}
	def factory_attributes(options={})
		Factory.attributes_for(:address,{
			:address_type_id => Factory(:address_type).id
		}.merge(options))
	end
	def factory_create(options={})
		Factory(:address,options)
	end

	assert_access_with_login({ 
		:logins => [:superuser,:admin,:reader,:editor] })
	assert_no_access_with_login({ 
		:logins => [:active_user] })
	assert_no_access_without_login


%w( superuser admin editor reader ).each do |cu|

	test "should get addresses with #{cu} login" do
		subject = Factory(:subject)
		login_as send(cu)
		get :index, :subject_id => subject.id
		assert assigns(:subject)
		assert_response :success
		assert_template 'index'
#		assert_layout 'home_exposure'
	end

	test "should NOT get addresses without subject_id and #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			get :index
		}
	end

	test "should NOT get addresses with invalid subject_id and #{cu} login" do
		login_as send(cu)
		get :index, :subject_id => 0
		assert_not_nil flash[:error]
		assert_redirected_to subjects_path
	end

	test "should get new address with #{cu} login" do
		subject = Factory(:subject)
		login_as send(cu)
		get :new, :subject_id => subject.id
		assert assigns(:subject)
		assert assigns(:address)
		assert_response :success
		assert_template 'new'
#		assert_layout 'home_exposure'
	end

	test "should NOT get new address without subject_id and #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			get :new
		}
	end

	test "should NOT get new address with invalid subject_id and #{cu} login" do
		login_as send(cu)
		get :new, :subject_id => 0
		assert_not_nil flash[:error]
		assert_redirected_to subjects_path
	end

	test "should create new address with #{cu} login" do
		subject = Factory(:subject)
		login_as send(cu)
		assert_difference("Subject.find(#{subject.id}).addresses.count",1) {
		assert_difference('Address.count',1) {
			post :create, :subject_id => subject.id,
				:address => factory_attributes
		} }
		assert assigns(:subject)
		assert_redirected_to subject_addresses_path(subject)
	end

	test "should NOT create new address without subject_id and #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			post :create, :address => factory_attributes
		}
	end

	test "should NOT create new address with invalid subject_id and #{cu} login" do
		login_as send(cu)
		assert_difference('Address.count',0) do
			post :create, :subject_id => 0, 
				:address => factory_attributes
		end
		assert_not_nil flash[:error]
		assert_redirected_to subjects_path
	end

	test "should NOT create new address with #{cu} login when create fails" do
		subject = Factory(:subject)
		Address.any_instance.stubs(:create_or_update).returns(false)
		login_as send(cu)
		assert_difference('Address.count',0) do
			post :create, :subject_id => subject.id,
				:address => factory_attributes
		end
		assert assigns(:subject)
		assert_response :success
		assert_template 'new'
#		assert_layout 'home_exposure'
		assert_not_nil flash[:error]
	end

	test "should NOT create new address with #{cu} login and invalid address" do
#		subject = Factory(:subject)
#		Address.any_instance.stubs(:create_or_update).returns(false)
#		login_as send(cu)
#		assert_difference('Address.count',0) do
#			post :create, :subject_id => subject.id,
#				:address => factory_attributes
#		end
#		assert assigns(:subject)
#		assert_response :success
#		assert_template 'new'
#		assert_layout 'home_exposure'
#		assert_not_nil flash[:error]
		pending
	end


	test "should edit address with #{cu} login" do
		address = factory_create
		login_as send(cu)
		get :edit, :id => address.id
		assert assigns(:address)
		assert_response :success
		assert_template 'edit'
#		assert_layout 'home_exposure'
	end

	test "should NOT edit address with invalid id and #{cu} login" do
		address = factory_create
		login_as send(cu)
		get :edit, :id => 0
		assert_redirected_to subjects_path
	end

	test "should NOT edit address without id and #{cu} login" do
		address = factory_create
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			get :edit
		}
	end

	test "should update address with #{cu} login" do
		address = factory_create
		login_as send(cu)
		put :update, :id => address.id,
			:address => factory_attributes
		assert assigns(:address)
		assert_redirected_to subject_addresses_path(address.subject)
	end

	test "should NOT update address with invalid id and #{cu} login" do
		address = factory_create
		login_as send(cu)
		put :update, :id => 0,
			:address => factory_attributes
		assert_redirected_to subjects_path
	end

	test "should NOT update address without id and #{cu} login" do
		address = factory_create
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			put :update,
				:address => factory_attributes
		}
	end

	test "should NOT update address with #{cu} login when update fails" do
		address = factory_create
		before = address.updated_at
		sleep 1	# if updated too quickly, updated_at won't change
		Address.any_instance.stubs(:create_or_update).returns(false)
		login_as send(cu)
		put :update, :id => address.id,
			:address => factory_attributes
		after = address.reload.updated_at
		assert_equal before.to_i,after.to_i
		assert assigns(:address)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update address with #{cu} login and invalid address" do
pending
		address = factory_create
		login_as send(cu)
#		put :update, :id => address.id,
#			:address => factory_attributes
#		assert assigns(:subject)
#		assert_response :success
#		assert_template 'edit'
#		assert_layout 'home_exposure'
	end

end


%w( active_user ).each do |cu|

	test "should NOT get addresses with #{cu} login" do
		subject = Factory(:subject)
		login_as send(cu)
		get :index, :subject_id => subject.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT get new address with #{cu} login" do
		subject = Factory(:subject)
		login_as send(cu)
		get :new, :subject_id => subject.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT create new address with #{cu} login" do
		subject = Factory(:subject)
		login_as send(cu)
		post :create, :subject_id => subject.id,
			:address => factory_attributes
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

end

	test "should NOT get addresses without login" do
		subject = Factory(:subject)
		get :index, :subject_id => subject.id
		assert_redirected_to_login
	end

	test "should NOT get new address without login" do
		subject = Factory(:subject)
		get :new, :subject_id => subject.id
		assert_redirected_to_login
	end

	test "should NOT create new address without login" do
		subject = Factory(:subject)
		post :create, :subject_id => subject.id,
			:address => factory_attributes
		assert_redirected_to_login
	end

end
