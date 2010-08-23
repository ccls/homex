require File.dirname(__FILE__) + '/../test_helper'

class PhoneNumbersControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'PhoneNumber',
		:actions => [:edit,:update],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :factory_create
	}
	def factory_attributes(options={})
		Factory.attributes_for(:phone_number,{
			:phone_type_id => Factory(:phone_type).id
		}.merge(options))
	end
	def factory_create(options={})
		Factory(:phone_number,options)
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

#	test "should get phone_numbers with #{cu} login" do
#		subject = Factory(:subject)
#		login_as send(cu)
#		get :index, :subject_id => subject.id
#		assert assigns(:subject)
#		assert_response :success
#		assert_template 'index'
##		assert_layout 'home_exposure'
#	end

#	test "should NOT get phone_numbers without subject_id and #{cu} login" do
#		login_as send(cu)
#		assert_raise(ActionController::RoutingError){
#			get :index
#		}
#	end

#	test "should NOT get phone_numbers with invalid subject_id and #{cu} login" do
#		login_as send(cu)
#		get :index, :subject_id => 0
#		assert_not_nil flash[:error]
#		assert_redirected_to subjects_path
#	end

	test "should get new phone_number with #{cu} login" do
		subject = Factory(:subject)
		login_as send(cu)
		get :new, :subject_id => subject.id
		assert assigns(:subject)
		assert assigns(:phone_number)
		assert_response :success
		assert_template 'new'
#		assert_layout 'home_exposure'
	end

	test "should NOT get new phone_number without subject_id " <<
			"and #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			get :new
		}
	end

	test "should NOT get new phone_number with invalid subject_id " <<
			"and #{cu} login" do
		login_as send(cu)
		get :new, :subject_id => 0
		assert_not_nil flash[:error]
		assert_redirected_to subjects_path
	end

	test "should create new phone_number with #{cu} login" do
		subject = Factory(:subject)
		login_as send(cu)
		assert_difference("Subject.find(#{subject.id}).phone_numbers.count",1) {
		assert_difference('PhoneNumber.count',1) {
			post :create, :subject_id => subject.id,
				:phone_number => factory_attributes
		} }
		assert assigns(:subject)
		assert_redirected_to subject_contacts_path(subject)
	end

	test "should set verified_on on create if is_verified " <<
			"with #{cu} login" do
		subject = Factory(:subject)
		login_as send(cu)
		post :create, :subject_id => subject.id,
			:phone_number => factory_attributes(
				:is_verified => true,
				:how_verified => 'no idea'
			)
		assert assigns(:phone_number)
		assert_not_nil assigns(:phone_number).verified_on
	end

	test "should set verified_by on create if is_verified " <<
			"with #{cu} login" do
		subject = Factory(:subject)
		login_as u = send(cu)
		post :create, :subject_id => subject.id,
			:phone_number => factory_attributes(
				:is_verified => true,
				:how_verified => 'no idea'
			)
		assert assigns(:phone_number)
		assert_not_nil assigns(:phone_number).verified_by_id
		assert_equal assigns(:phone_number).verified_by_id, u.id
	end

	test "should NOT create new phone_number without subject_id " <<
			"and #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			post :create, :phone_number => factory_attributes
		}
	end

	test "should NOT create new phone_number with invalid subject_id " <<
			"and #{cu} login" do
		login_as send(cu)
		assert_difference('PhoneNumber.count',0) do
			post :create, :subject_id => 0, 
				:phone_number => factory_attributes
		end
		assert_not_nil flash[:error]
		assert_redirected_to subjects_path
	end

	test "should NOT create new phone_number with #{cu} login when " <<
			"create fails" do
		subject = Factory(:subject)
		PhoneNumber.any_instance.stubs(:create_or_update).returns(false)
		login_as send(cu)
		assert_difference('PhoneNumber.count',0) do
			post :create, :subject_id => subject.id,
				:phone_number => factory_attributes
		end
		assert assigns(:subject)
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should NOT create new phone_number with #{cu} login " <<
			"and invalid phone_number" do
		subject = Factory(:subject)
		login_as send(cu)
		assert_difference('PhoneNumber.count',0) do
			post :create, :subject_id => subject.id,
				:phone_number => { }
		end
		assert assigns(:subject)
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end


	test "should edit phone_number with #{cu} login" do
		phone_number = factory_create
		login_as send(cu)
		get :edit, :id => phone_number.id
		assert assigns(:phone_number)
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT edit phone_number with invalid id and #{cu} login" do
		phone_number = factory_create
		login_as send(cu)
		get :edit, :id => 0
		assert_redirected_to subjects_path
	end

	test "should NOT edit phone_number without id and #{cu} login" do
		phone_number = factory_create
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			get :edit
		}
	end

	test "should update phone_number with #{cu} login" do
		phone_number = factory_create
		login_as send(cu)
		put :update, :id => phone_number.id,
			:phone_number => factory_attributes
		assert assigns(:phone_number)
		assert_redirected_to subject_contacts_path(phone_number.subject)
	end

	test "should set verified_on on update if is_verified " <<
			"with #{cu} login" do
		phone_number = factory_create
		login_as send(cu)
		put :update, :id => phone_number.id,
			:phone_number => factory_attributes(
				:is_verified  => true,
				:how_verified => 'not a clue'
			)
		assert assigns(:phone_number)
		assert_not_nil assigns(:phone_number).verified_on
	end

	test "should set verified_by on update if is_verified " <<
			"with #{cu} login" do
		phone_number = factory_create
		login_as u = send(cu)
		put :update, :id => phone_number.id,
			:phone_number => factory_attributes(
				:is_verified => true,
				:how_verified => 'not a clue'
			)
		assert assigns(:phone_number)
		assert_not_nil assigns(:phone_number).verified_by_id
		assert_equal assigns(:phone_number).verified_by_id, u.id
	end

	test "should NOT update phone_number with invalid id and #{cu} login" do
		phone_number = factory_create
		login_as send(cu)
		put :update, :id => 0,
			:phone_number => factory_attributes
		assert_redirected_to subjects_path
	end

	test "should NOT update phone_number without id and #{cu} login" do
		phone_number = factory_create
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			put :update,
				:phone_number => factory_attributes
		}
	end

	test "should NOT update phone_number with #{cu} login " <<
			"when update fails" do
		phone_number = factory_create
		before = phone_number.updated_at
		sleep 1	# if updated too quickly, updated_at won't change
		PhoneNumber.any_instance.stubs(:create_or_update).returns(false)
		login_as send(cu)
		put :update, :id => phone_number.id,
			:phone_number => factory_attributes
		after = phone_number.reload.updated_at
		assert_equal before.to_i,after.to_i
		assert assigns(:phone_number)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should NOT update phone_number with #{cu} login " <<
			"and invalid phone_number" do
		phone_number = factory_create
		login_as send(cu)
		put :update, :id => phone_number.id,
			:phone_number => { :phone_number => nil }
		assert assigns(:phone_number)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

end


%w( interviewer reader active_user ).each do |cu|

#	test "should NOT get phone_numbers with #{cu} login" do
#		subject = Factory(:subject)
#		login_as send(cu)
#		get :index, :subject_id => subject.id
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end

	test "should NOT get new phone_number with #{cu} login" do
		subject = Factory(:subject)
		login_as send(cu)
		get :new, :subject_id => subject.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT create new phone_number with #{cu} login" do
		subject = Factory(:subject)
		login_as send(cu)
		post :create, :subject_id => subject.id,
			:phone_number => factory_attributes
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

end

#	test "should NOT get phone_numbers without login" do
#		subject = Factory(:subject)
#		get :index, :subject_id => subject.id
#		assert_redirected_to_login
#	end

	test "should NOT get new phone_number without login" do
		subject = Factory(:subject)
		get :new, :subject_id => subject.id
		assert_redirected_to_login
	end

	test "should NOT create new phone_number without login" do
		subject = Factory(:subject)
		post :create, :subject_id => subject.id,
			:phone_number => factory_attributes
		assert_redirected_to_login
	end

end
