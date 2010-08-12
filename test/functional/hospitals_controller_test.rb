require File.dirname(__FILE__) + '/../test_helper'

class HospitalsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Hospital',
		:actions => [:edit,:update],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :factory_create
	}
	def factory_attributes(options={})
		Factory.attributes_for(:hospital,options)
	end
	def factory_create(options={})
		Factory(:hospital,options)
	end

#	assert_access_with_login({ 
#		:logins => [:superuser,:admin,:editor] })
#	assert_no_access_with_login({ 
#		:logins => [:reader,:active_user] })
#	assert_no_access_without_login
#
#
#%w( superuser admin editor ).each do |cu|
#
#	test "should get hospitals with #{cu} login" do
#		subject = Factory(:subject)
#		login_as send(cu)
#		get :index, :subject_id => subject.id
#		assert assigns(:subject)
#		assert_response :success
#		assert_template 'index'
#	end
#
#	test "should NOT get hospitals without subject_id and #{cu} login" do
#		login_as send(cu)
#		assert_raise(ActionController::RoutingError){
#			get :index
#		}
#	end
#
#	test "should NOT get hospitals with invalid subject_id and #{cu} login" do
#		login_as send(cu)
#		get :index, :subject_id => 0
#		assert_not_nil flash[:error]
#		assert_redirected_to subjects_path
#	end
#
#	test "should get new hospital with #{cu} login" do
#		subject = Factory(:subject)
#		login_as send(cu)
#		get :new, :subject_id => subject.id
#		assert assigns(:subject)
#		assert assigns(:hospital)
#		assert_response :success
#		assert_template 'new'
##		assert_layout 'home_exposure'
#	end
#
#	test "should NOT get new hospital without subject_id and #{cu} login" do
#		login_as send(cu)
#		assert_raise(ActionController::RoutingError){
#			get :new
#		}
#	end
#
#	test "should NOT get new hospital with invalid subject_id and #{cu} login" do
#		login_as send(cu)
#		get :new, :subject_id => 0
#		assert_not_nil flash[:error]
#		assert_redirected_to subjects_path
#	end
#
#	test "should create new hospital with #{cu} login" do
#		subject = Factory(:subject)
#		login_as send(cu)
#		assert_difference("Subject.find(#{subject.id}).hospitals.count",1) {
#		assert_difference('Hospital.count',1) {
#			post :create, :subject_id => subject.id,
#				:hospital => factory_attributes
#		} }
#		assert assigns(:subject)
#		assert_redirected_to subject_hospitals_path(subject)
#	end
#
#	test "should NOT create new hospital without subject_id and #{cu} login" do
#		login_as send(cu)
#		assert_raise(ActionController::RoutingError){
#			post :create, :hospital => factory_attributes
#		}
#	end
#
#	test "should NOT create new hospital with invalid subject_id and #{cu} login" do
#		login_as send(cu)
#		assert_difference('Hospital.count',0) do
#			post :create, :subject_id => 0, 
#				:hospital => factory_attributes
#		end
#		assert_not_nil flash[:error]
#		assert_redirected_to subjects_path
#	end
#
#	test "should NOT create new hospital with #{cu} login when create fails" do
#		subject = Factory(:subject)
#		Hospital.any_instance.stubs(:create_or_update).returns(false)
#		login_as send(cu)
#		assert_difference('Hospital.count',0) do
#			post :create, :subject_id => subject.id,
#				:hospital => factory_attributes
#		end
#		assert assigns(:subject)
#		assert_response :success
#		assert_template 'new'
#		assert_not_nil flash[:error]
#	end
#
#	test "should NOT create new hospital with #{cu} login and invalid hospital" do
#		subject = Factory(:subject)
#		login_as send(cu)
#		assert_difference('Hospital.count',0) do
#			post :create, :subject_id => subject.id,
#				:hospital => { }
#		end
#		assert assigns(:subject)
#		assert_response :success
#		assert_template 'new'
#		assert_not_nil flash[:error]
#	end
#
#
#	test "should edit hospital with #{cu} login" do
#		hospital = factory_create
#		login_as send(cu)
#		get :edit, :id => hospital.id
#		assert assigns(:hospital)
#		assert_response :success
#		assert_template 'edit'
#	end
#
#	test "should NOT edit hospital with invalid id and #{cu} login" do
#		hospital = factory_create
#		login_as send(cu)
#		get :edit, :id => 0
#		assert_redirected_to subjects_path
#	end
#
#	test "should NOT edit hospital without id and #{cu} login" do
#		hospital = factory_create
#		login_as send(cu)
#		assert_raise(ActionController::RoutingError){
#			get :edit
#		}
#	end
#
#	test "should update hospital with #{cu} login" do
#		hospital = factory_create
#		login_as send(cu)
#		put :update, :id => hospital.id,
#			:hospital => factory_attributes
#		assert assigns(:hospital)
#		assert_redirected_to subject_hospitals_path(hospital.subject)
#	end
#
#	test "should NOT update hospital with invalid id and #{cu} login" do
#		hospital = factory_create
#		login_as send(cu)
#		put :update, :id => 0,
#			:hospital => factory_attributes
#		assert_redirected_to subjects_path
#	end
#
#	test "should NOT update hospital without id and #{cu} login" do
#		hospital = factory_create
#		login_as send(cu)
#		assert_raise(ActionController::RoutingError){
#			put :update,
#				:hospital => factory_attributes
#		}
#	end
#
#	test "should NOT update hospital with #{cu} login when update fails" do
#		hospital = factory_create
#		before = hospital.updated_at
#		sleep 1	# if updated too quickly, updated_at won't change
#		Hospital.any_instance.stubs(:create_or_update).returns(false)
#		login_as send(cu)
#		put :update, :id => hospital.id,
#			:hospital => factory_attributes
#		after = hospital.reload.updated_at
#		assert_equal before.to_i,after.to_i
#		assert assigns(:hospital)
#		assert_response :success
#		assert_template 'edit'
#		assert_not_nil flash[:error]
#	end
#
#	test "should NOT update hospital with #{cu} login and invalid hospital" do
#		hospital = factory_create
#		login_as send(cu)
#		put :update, :id => hospital.id,
#			:hospital => { :line_1 => nil }
#		assert assigns(:hospital)
#		assert_response :success
#		assert_template 'edit'
#		assert_not_nil flash[:error]
#	end
#
#end
#
#
#%w( reader active_user ).each do |cu|
#
#	test "should NOT get hospitals with #{cu} login" do
#		subject = Factory(:subject)
#		login_as send(cu)
#		get :index, :subject_id => subject.id
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#	test "should NOT get new hospital with #{cu} login" do
#		subject = Factory(:subject)
#		login_as send(cu)
#		get :new, :subject_id => subject.id
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#	test "should NOT create new hospital with #{cu} login" do
#		subject = Factory(:subject)
#		login_as send(cu)
#		post :create, :subject_id => subject.id,
#			:hospital => factory_attributes
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#end
#
#	test "should NOT get hospitals without login" do
#		subject = Factory(:subject)
#		get :index, :subject_id => subject.id
#		assert_redirected_to_login
#	end
#
#	test "should NOT get new hospital without login" do
#		subject = Factory(:subject)
#		get :new, :subject_id => subject.id
#		assert_redirected_to_login
#	end
#
#	test "should NOT create new hospital without login" do
#		subject = Factory(:subject)
#		post :create, :subject_id => subject.id,
#			:hospital => factory_attributes
#		assert_redirected_to_login
#	end

end
