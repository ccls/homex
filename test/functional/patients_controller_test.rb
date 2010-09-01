require File.dirname(__FILE__) + '/../test_helper'

class PatientsControllerTest < ActionController::TestCase

#	ASSERT_ACCESS_OPTIONS = {
#		:model => 'Patient',
#		:actions => [:edit,:update],
#		:attributes_for_create => :factory_attributes,
#		:method_for_create => :factory_create
#	}
	def factory_attributes(options={})
		Factory.attributes_for(:patient,options)
	end
	def factory_create(options={})
		Factory(:patient,options)
	end

#	assert_access_with_login({ 
#		:logins => [:superuser,:admin,:editor] })
#	assert_no_access_with_login({ 
#		:logins => [:interviewer,:reader,:active_user] })
#	assert_no_access_without_login


%w( superuser admin editor ).each do |cu|

	test "should show patient with #{cu} login" do
		patient = factory_create
		login_as send(cu)
		get :show, :subject_id => patient.subject.id
		assert assigns(:subject)
		assert_response :success
		assert_template 'show'
	end

	test "should NOT show patient without subject_id " <<
			"and #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			get :show
		}
	end

	test "should NOT show patient with invalid subject_id " <<
			"and #{cu} login" do
		login_as send(cu)
		get :show, :subject_id => 0
		assert_not_nil flash[:error]
		assert_redirected_to subjects_path
	end

	test "should NOT show patient for patientless subject " <<
			"and #{cu} login" do
#		subject = Factory(:subject)
		subject = Factory(:case_subject)
		assert_nil subject.patient
		login_as send(cu)
		get :show, :subject_id => subject.id
		assert_not_nil assigns(:subject)
		assert_equal subject, assigns(:subject)
		assert_not_nil flash[:error]
		assert_redirected_to new_subject_patient_path(subject)
	end

	test "should NOT get new patient with #{cu} login " <<
			"for subject with patient" do
		patient = factory_create
		login_as send(cu)
		get :new, :subject_id => patient.subject.id
		assert assigns(:subject)
		assert_redirected_to subject_patient_path(assigns(:subject))
	end

	test "should get new patient with #{cu} login " <<
			"for subject without patient" do
#		subject = Factory(:subject)
		subject = Factory(:case_subject)
		login_as send(cu)
		get :new, :subject_id => subject.id
		assert assigns(:subject)
		assert assigns(:patient)
		assert_response :success
		assert_template 'new'
	end

	test "should NOT get new patient without subject_id " <<
			"and #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			get :new
		}
	end

	test "should NOT get new patient with invalid subject_id " <<
			"and #{cu} login" do
		login_as send(cu)
		get :new, :subject_id => 0
		assert_not_nil flash[:error]
		assert_redirected_to subjects_path
	end

	test "should create new patient with #{cu} login" do
#		subject = Factory(:subject)
		subject = Factory(:case_subject)
		login_as send(cu)
		assert_difference('Patient.count',1) do
			post :create, :subject_id => subject.id,
				:patient => factory_attributes
		end
		assert assigns(:subject)
		assert_redirected_to subject_patient_path(subject)
	end

	test "should NOT create new patient with #{cu} login " <<
			"for non-case subject" do
		subject = Factory(:subject)
		login_as send(cu)
		assert_difference('Patient.count',0) do
			post :create, :subject_id => subject.id,
				:patient => factory_attributes
		end
		assert_not_nil flash[:error]
		assert assigns(:subject)
#		assert_template 'new'
#		assert_redirected_to subject_patient_path(subject)
		assert_redirected_to subject_path(subject)
	end

	test "should NOT create new patient without subject_id " <<
			"and #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			post :create, :patient => factory_attributes
		}
	end

	test "should NOT create new patient with invalid subject_id " <<
			"and #{cu} login" do
		login_as send(cu)
		assert_difference('Patient.count',0) do
			post :create, :subject_id => 0, 
				:patient => factory_attributes
		end
		assert_not_nil flash[:error]
		assert_redirected_to subjects_path
	end

	test "should NOT create new patient with #{cu} " <<
			"login when create fails" do
#		subject = Factory(:subject)
		subject = Factory(:case_subject)
		Patient.any_instance.stubs(:create_or_update).returns(false)
		login_as send(cu)
		assert_difference('Patient.count',0) do
			post :create, :subject_id => subject.id,
				:patient => factory_attributes
		end
		assert assigns(:subject)
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should NOT create new patient with #{cu} " <<
			"login and invalid patient" do
#		subject = Factory(:subject)
		subject = Factory(:case_subject)
		login_as send(cu)
#		assert_difference('Patient.count',0) do
			post :create, :subject_id => subject.id,
				:patient => { }
#		end
		pending #	"no patient validations yet"
#		assert assigns(:subject)
#		assert_response :success
#		assert_template 'new'
#		assert_not_nil flash[:error]
	end

	test "should edit patient with #{cu} login" do
		patient = factory_create
		login_as send(cu)
#		get :edit, :id => patient.id
		get :edit, :subject_id => patient.subject.id
		assert assigns(:patient)
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT edit patient with invalid " <<
			"subject_id and #{cu} login" do
		patient = factory_create
		login_as send(cu)
		get :edit, :subject_id => 0
		assert_redirected_to subjects_path
	end

	test "should NOT edit patient without subject_id " <<
			"and #{cu} login" do
		patient = factory_create
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			get :edit
		}
	end

	test "should update patient with #{cu} login" do
		patient = factory_create
		login_as send(cu)
		put :update, :subject_id => patient.subject.id,
			:patient => factory_attributes
		assert assigns(:patient)
		assert_redirected_to subject_patient_path(patient.subject)
	end

	test "should NOT update patient with invalid " <<
			"subject_id and #{cu} login" do
		patient = factory_create
		login_as send(cu)
		put :update, :subject_id => 0,
			:patient => factory_attributes
		assert_redirected_to subjects_path
	end

	test "should NOT update patient without subject_id " <<
			"and #{cu} login" do
		patient = factory_create
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			put :update,
				:patient => factory_attributes
		}
	end

	test "should NOT update patient with #{cu} " <<
			"login when update fails" do
		patient = factory_create
		before = patient.updated_at
		sleep 1	# if updated too quickly, updated_at won't change
		Patient.any_instance.stubs(:create_or_update).returns(false)
		login_as send(cu)
		put :update, :subject_id => patient.subject.id,
			:patient => factory_attributes
		after = patient.reload.updated_at
		assert_equal before.to_i,after.to_i
		assert assigns(:patient)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update patient with #{cu} " <<
			"login and invalid patient" do
		patient = factory_create
		login_as send(cu)
		put :update, :subject_id => patient.subject.id,
			:patient => { }
pending
#		assert assigns(:patient)
#		assert_response :success
#		assert_template 'edit'
#		assert_not_nil flash[:error]
	end

	test "should destroy patient with #{cu} login" do
		login_as send(cu)
		subject = factory_create.subject
		assert_not_nil subject.patient
		assert_difference('Patient.count', -1) do
			delete :destroy, :subject_id => subject.id
		end
		assert_nil subject.reload.patient
		assert_redirected_to subject_path(subject)
	end

end


%w( interviewer reader active_user ).each do |cu|

	test "should NOT show patient with #{cu} login" do
#		subject = Factory(:subject)
		subject = Factory(:case_subject)
		login_as send(cu)
		get :show, :subject_id => subject.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT get new patient with #{cu} login" do
#		subject = Factory(:subject)
		subject = Factory(:case_subject)
		login_as send(cu)
		get :new, :subject_id => subject.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT create new patient with #{cu} login" do
#		subject = Factory(:subject)
		subject = Factory(:case_subject)
		login_as send(cu)
		post :create, :subject_id => subject.id,
			:patient => factory_attributes
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT destroy patient with #{cu} login" do
		login_as send(cu)
		subject = factory_create.subject
		assert_not_nil subject.patient
		assert_difference('Patient.count', 0) do
			delete :destroy, :subject_id => subject.id
		end
		assert_not_nil subject.patient
		assert_redirected_to root_path
	end

end

	test "should NOT show patient without login" do
#		subject = Factory(:subject)
		subject = Factory(:case_subject)
		get :show, :subject_id => subject.id
		assert_redirected_to_login
	end

	test "should NOT get new patient without login" do
#		subject = Factory(:subject)
		subject = Factory(:case_subject)
		get :new, :subject_id => subject.id
		assert_redirected_to_login
	end

	test "should NOT create new patient without login" do
#		subject = Factory(:subject)
		subject = Factory(:case_subject)
		post :create, :subject_id => subject.id,
			:patient => factory_attributes
		assert_redirected_to_login
	end

	test "should NOT destroy patient without login" do
		subject = factory_create.subject
		assert_not_nil subject.patient
		assert_difference('Patient.count', 0) do
			delete :destroy, :subject_id => subject.id
		end
		assert_not_nil subject.patient
		assert_redirected_to_login
	end

end
