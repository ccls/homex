require File.dirname(__FILE__) + '/../../test_helper'

class Hx::EnrollmentsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Enrollment',
		:actions => [:edit,:update],	#	only the shallow ones
		:attributes_for_create => :factory_attributes,
		:method_for_create => :factory_create
	}
	def factory_attributes
		Factory.attributes_for(:enrollment,
			:project_id => Factory(:project).id)
	end
	def factory_create
		Factory(:enrollment)
	end

	assert_access_with_login({ 
		:logins => [:admin,:employee,:editor] })
	assert_no_access_with_login({ 
		:logins => [:moderator,:active_user] })
	assert_no_access_without_login


%w( admin editor employee ).each do |cu|

	test "should get enrollments with #{cu} login" do
		subject = Factory(:subject)
		login_as send(cu)
		get :index, :subject_id => subject.id
		assert assigns(:subject)
		assert_response :success
		assert_template 'index'
		assert_layout 'home_exposure'
	end

	test "should NOT get enrollments without subject_id and #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			get :index
		}
	end

	test "should NOT get enrollments with invalid subject_id and #{cu} login" do
		login_as send(cu)
		get :index, :subject_id => 0
		assert_not_nil flash[:error]
		assert_redirected_to hx_subjects_path
	end

	test "should get new enrollment with #{cu} login" do
		subject = Factory(:subject)
		login_as send(cu)
		get :new, :subject_id => subject.id
		assert assigns(:subject)
		assert assigns(:projects)
#		assert assigns(:enrollment)
		assert_response :success
		assert_template 'new'
		assert_layout 'home_exposure'
	end

	test "should NOT get new enrollment without subject_id and #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			get :new
		}
	end

	test "should NOT get new enrollment with invalid subject_id and #{cu} login" do
		login_as send(cu)
		get :new, :subject_id => 0
		assert_not_nil flash[:error]
		assert_redirected_to hx_subjects_path
	end

	test "should create new enrollment with #{cu} login" do
		subject = Factory(:subject)
		login_as send(cu)
		assert_difference("Subject.find(#{subject.id}).enrollments.count",1) {
		assert_difference('Enrollment.count',1) {
			post :create, :subject_id => subject.id,
				:project_id => Factory(:project).id
#				:enrollment => factory_attributes
		} }
		assert assigns(:subject)
#		assert_redirected_to hx_subject_enrollments_path(subject)
		assert_redirected_to edit_hx_enrollment_path(assigns(:enrollment))
	end

	test "should NOT create new enrollment without subject_id and #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
#			post :create, :enrollment => factory_attributes
			post :create, :project_id => Factory(:project).id
		}
	end

	test "should NOT create new enrollment with invalid subject_id and #{cu} login" do
		login_as send(cu)
		assert_difference('Enrollment.count',0) do
			post :create, :subject_id => 0, 
				:project_id => Factory(:project).id
		end
		assert_not_nil flash[:error]
		assert_redirected_to hx_subjects_path
	end

	test "should NOT create new enrollment with #{cu} login when create fails" do
		subject = Factory(:subject)
		Enrollment.any_instance.stubs(:create_or_update).returns(false)
		login_as send(cu)
		assert_difference('Enrollment.count',0) do
			post :create, :subject_id => subject.id,
				:project_id => Factory(:project).id
#				:enrollment => factory_attributes
		end
		assert assigns(:subject)
		assert_response :success
		assert_template 'new'
		assert_layout 'home_exposure'
		assert_not_nil flash[:error]
	end

	test "should NOT create new enrollment with #{cu} login and invalid enrollment" do
#		subject = Factory(:subject)
#		Enrollment.any_instance.stubs(:create_or_update).returns(false)
#		login_as send(cu)
#		assert_difference('Enrollment.count',0) do
#			post :create, :subject_id => subject.id,
#				:enrollment => factory_attributes
#		end
#		assert assigns(:subject)
#		assert_response :success
#		assert_template 'new'
#		assert_layout 'home_exposure'
#		assert_not_nil flash[:error]
		pending
	end


	test "should edit enrollment with #{cu} login" do
		enrollment = Factory(:enrollment)
		login_as send(cu)
		get :edit, :subject_id => enrollment.subject.id, :id => enrollment.id
		assert assigns(:enrollment)
		assert_response :success
		assert_template 'edit'
		assert_layout 'home_exposure'
	end

	test "should NOT edit enrollment without id and #{cu} login" do
		enrollment = Factory(:enrollment)
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			get :edit, :subject_id => enrollment.subject.id
		}
	end

	test "should update enrollment with #{cu} login" do
		enrollment = Factory(:enrollment)
		login_as send(cu)
		put :update, :subject_id => enrollment.subject.id, :id => enrollment.id,
			:enrollment => factory_attributes
		assert assigns(:enrollment)
		assert_redirected_to hx_subject_enrollments_path(enrollment.subject)
	end

	test "should NOT update enrollment without id and #{cu} login" do
		enrollment = Factory(:enrollment)
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			put :update, :subject_id => enrollment.subject.id,
				:enrollment => factory_attributes
		}
	end

	test "should NOT update enrollment with #{cu} login when update fails" do
		enrollment = Factory(:enrollment)
		before = enrollment.updated_at
		sleep 1	# if updated too quickly, updated_at won't change
		Enrollment.any_instance.stubs(:create_or_update).returns(false)
		login_as send(cu)
		put :update, :subject_id => enrollment.subject.id, :id => enrollment.id,
			:enrollment => factory_attributes
		after = enrollment.reload.updated_at
		assert_equal before.to_i,after.to_i
		assert assigns(:enrollment)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update enrollment with #{cu} login and invalid enrollment" do
pending
		enrollment = Factory(:enrollment)
		login_as send(cu)
#		put :update, :subject_id => subject.id, :id => enrollment.id,
#			:enrollment => factory_attributes
#		assert assigns(:subject)
#		assert_response :success
#		assert_template 'edit'
#		assert_layout 'home_exposure'
	end

end


%w( moderator active_user ).each do |cu|

	test "should NOT get enrollments with #{cu} login" do
		subject = Factory(:subject)
		login_as send(cu)
		get :index, :subject_id => subject.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT get new enrollment with #{cu} login" do
		subject = Factory(:subject)
		login_as send(cu)
		get :new, :subject_id => subject.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT create new enrollment with #{cu} login" do
		subject = Factory(:subject)
		login_as send(cu)
		post :create, :subject_id => subject.id,
			:enrollment => factory_attributes
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

end

	test "should NOT get enrollments without login" do
		subject = Factory(:subject)
		get :index, :subject_id => subject.id
		assert_redirected_to_login
	end

	test "should NOT get new enrollment without login" do
		subject = Factory(:subject)
		get :new, :subject_id => subject.id
		assert_redirected_to_login
	end

	test "should NOT create new enrollment without login" do
		subject = Factory(:subject)
		post :create, :subject_id => subject.id,
			:enrollment => factory_attributes
		assert_redirected_to_login
	end

end
