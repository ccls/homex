require File.dirname(__FILE__) + '/../test_helper'

#class AddressesControllerTest < ActionController::TestCase
class AddressingsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
#		:model => 'Address',
		:model => 'Addressing',
		:actions => [:edit,:update],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :factory_create
	}
	def factory_attributes(options={})
		Factory.attributes_for(:addressing,options)
#			:address_type_id => Factory(:address_type).id
#		}.merge(options))
	end
	def factory_create(options={})
		Factory(:addressing,options)
	end

	assert_access_with_login({ 
		:logins => [:superuser,:admin,:editor] })
	assert_no_access_with_login({ 
		:logins => [:interviewer,:reader,:active_user] })
	assert_no_access_without_login


	#	destroy is TEMPORARY
	assert_access_with_login(
		:actions => [:destroy],
		:login => :superuser
	)


%w( superuser admin editor ).each do |cu|

#	test "should get addresses with #{cu} login" do
#		subject = Factory(:subject)
#		login_as send(cu)
#		get :index, :subject_id => subject.id
#		assert assigns(:subject)
#		assert_response :success
#		assert_template 'index'
##		assert_layout 'home_exposure'
#	end

#	test "should NOT get addresses without subject_id and #{cu} login" do
#		login_as send(cu)
#		assert_raise(ActionController::RoutingError){
#			get :index
#		}
#	end

#	test "should NOT get addresses with invalid subject_id and #{cu} login" do
#		login_as send(cu)
#		get :index, :subject_id => 0
#		assert_not_nil flash[:error]
#		assert_redirected_to subjects_path
#	end

	test "should get new addressing with #{cu} login" do
		subject = Factory(:subject)
		login_as send(cu)
		get :new, :subject_id => subject.id
		assert assigns(:subject)
		assert assigns(:addressing)
		assert_response :success
		assert_template 'new'
	end

	test "should NOT get new addressing without subject_id " <<
			"and #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			get :new
		}
	end

	test "should NOT get new addressing with invalid subject_id " <<
			"and #{cu} login" do
		login_as send(cu)
		get :new, :subject_id => 0
		assert_not_nil flash[:error]
		assert_redirected_to subjects_path
	end

	test "should create new addressing with #{cu} login" do
		subject = Factory(:subject)
		login_as send(cu)
		assert_difference("Subject.find(#{subject.id}).addressings.count",1) {
		assert_difference("Subject.find(#{subject.id}).addresses.count",1) {
		assert_difference('Addressing.count',1) {
		assert_difference('Address.count',1) {
			post :create, :subject_id => subject.id,
				:addressing => factory_attributes
		} } } }
		assert assigns(:subject)
		assert_redirected_to subject_contacts_path(subject)
	end

	test "should NOT create new addressing without subject_id " <<
			"and #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			post :create, :addressing => factory_attributes
		}
	end

	test "should NOT create new addressing with invalid subject_id " <<
			"and #{cu} login" do
		login_as send(cu)
		assert_difference('Addressing.count',0) {
		assert_difference('Address.count',0) {
			post :create, :subject_id => 0, 
				:addressing => factory_attributes
		} }
		assert_not_nil flash[:error]
		assert_redirected_to subjects_path
	end

	test "should NOT create new addressing with #{cu} login " <<
			"when create fails" do
		subject = Factory(:subject)
		Addressing.any_instance.stubs(:create_or_update).returns(false)
		login_as send(cu)
		assert_difference('Addressing.count',0) {
		assert_difference('Address.count',0) {
			post :create, :subject_id => subject.id,
				:addressing => factory_attributes
		} }
		assert assigns(:subject)
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should NOT create new addressing with #{cu} login " <<
			"and invalid addressing" do
		subject = Factory(:subject)
		login_as send(cu)
		assert_difference('Addressing.count',0) {
		assert_difference('Address.count',0) {
			post :create, :subject_id => subject.id,
				:addressing => { }
		} }
		assert assigns(:subject)
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should edit addressing with #{cu} login" do
		addressing = factory_create
		login_as send(cu)
		get :edit, :id => addressing.id
		assert assigns(:addressing)
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT edit addressing with invalid id and #{cu} login" do
		addressing = factory_create
		login_as send(cu)
		get :edit, :id => 0
		assert_redirected_to subjects_path
	end

	test "should NOT edit addressing without id and #{cu} login" do
		addressing = factory_create
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			get :edit
		}
	end

	test "should update addressing with #{cu} login" do
		addressing = factory_create
		login_as send(cu)
		put :update, :id => addressing.id,
			:addressing => factory_attributes
		assert assigns(:addressing)
		assert_redirected_to subject_contacts_path(addressing.subject)
	end

	test "should NOT update addressing with invalid id and #{cu} login" do
		addressing = factory_create
		login_as send(cu)
		put :update, :id => 0,
			:addressing => factory_attributes
		assert_redirected_to subjects_path
	end

	test "should NOT update addressing without id and #{cu} login" do
		addressing = factory_create
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			put :update,
				:addressing => factory_attributes
		}
	end

	test "should NOT update addressing with #{cu} login " <<
			"when update fails" do
		addressing = factory_create
		before = addressing.updated_at
		sleep 1	# if updated too quickly, updated_at won't change
		Addressing.any_instance.stubs(:create_or_update).returns(false)
		login_as send(cu)
		put :update, :id => addressing.id,
			:addressing => factory_attributes
		after = addressing.reload.updated_at
		assert_equal before.to_i,after.to_i
		assert assigns(:addressing)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update addressing with #{cu} login " <<
			"and invalid addressing" do
		addressing = factory_create
		login_as send(cu)
		put :update, :id => addressing.id,
			:addressing => { :subject_id => nil }
		assert assigns(:addressing)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

end


%w( interviewer reader active_user ).each do |cu|

#	test "should NOT get addresses with #{cu} login" do
#		subject = Factory(:subject)
#		login_as send(cu)
#		get :index, :subject_id => subject.id
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end

	test "should NOT get new addressing with #{cu} login" do
		subject = Factory(:subject)
		login_as send(cu)
		get :new, :subject_id => subject.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT create new addressing with #{cu} login" do
		subject = Factory(:subject)
		login_as send(cu)
		post :create, :subject_id => subject.id,
			:addressing => factory_attributes
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

end

#	test "should NOT get addresses without login" do
#		subject = Factory(:subject)
#		get :index, :subject_id => subject.id
#		assert_redirected_to_login
#	end

	test "should NOT get new addressing without login" do
		subject = Factory(:subject)
		get :new, :subject_id => subject.id
		assert_redirected_to_login
	end

	test "should NOT create new addressing without login" do
		subject = Factory(:subject)
		post :create, :subject_id => subject.id,
			:addressing => factory_attributes
		assert_redirected_to_login
	end

end
