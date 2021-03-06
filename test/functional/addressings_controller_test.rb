require 'test_helper'

class AddressingsControllerTest < ActionController::TestCase

	#	no route
	assert_no_route(:get,:index)
	assert_no_route(:get,:show)
	assert_no_route(:get,:show,:id => 0)

	#	no study_subject_id
	assert_no_route(:get,:new)
	assert_no_route(:post,:create)

	#	no id
	assert_no_route(:get,:edit)
	assert_no_route(:put,:update)
	assert_no_route(:delete,:destroy)

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Addressing',
		:actions => [:edit,:update],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_addressing
	}

	def factory_attributes(options={})
		Factory.attributes_for(:addressing,options)
	end

	def address_attributes(options={})
		{ 
			:address_attributes => Factory.attributes_for(
				:address, {
					:address_type_id => Factory(:address_type).id
				}.merge(options) 
			) 
		}
	end

	assert_access_with_login({    :logins => site_editors })
	assert_no_access_with_login({ :logins => non_site_editors })
	assert_no_access_without_login

	#	destroy is TEMPORARY
	assert_access_with_login(
		:actions => [:destroy],
		:login => :superuser
	)

	site_editors.each do |cu|

		test "should get new addressing with #{cu} login" do
			study_subject = Factory(:study_subject)
			login_as send(cu)
			get :new, :study_subject_id => study_subject.id
			assert assigns(:study_subject)
			assert assigns(:addressing)
			assert_response :success
			assert_template 'new'
		end

		test "should NOT get new addressing with invalid study_subject_id " <<
				"and #{cu} login" do
			login_as send(cu)
			get :new, :study_subject_id => 0
			assert_not_nil flash[:error]
			assert_redirected_to study_subjects_path
		end

		test "should make study_subject ineligible after create " <<
				"with #{cu} login" do
			study_subject = create_eligible_hx_study_subject
			login_as send(cu)
			assert_difference("StudySubject.find(#{study_subject.id}).addressings.count",1) {
			assert_difference("StudySubject.find(#{study_subject.id}).addresses.count",1) {
			assert_difference('Addressing.count',1) {
			assert_difference('Address.count',1) {
				post :create, :study_subject_id => study_subject.id,
					:addressing => az_addressing()
			} } } }
			assert assigns(:study_subject)
			hxe = study_subject.enrollments.find_by_project_id(Project['HomeExposures'].id)
			assert_study_subject_is_not_eligible(study_subject)
			assert_equal   hxe.ineligible_reason,
				IneligibleReason['newnonCA']
			assert_redirected_to study_subject_contacts_path(study_subject)
		end

		test "should create new addressing with #{cu} login" do
			study_subject = Factory(:study_subject)
			login_as send(cu)
			assert_difference("StudySubject.find(#{study_subject.id}).addressings.count",1) {
			assert_difference("StudySubject.find(#{study_subject.id}).addresses.count",1) {
			assert_difference('Addressing.count',1) {
			assert_difference('Address.count',1) {
			assert_difference('AddressType.count',1) {
				post :create, :study_subject_id => study_subject.id,
					:addressing => factory_attributes(address_attributes)
			} } } } }
			assert assigns(:study_subject)
			assert_redirected_to study_subject_contacts_path(study_subject)
		end

		test "should set verified_on on create if is_verified " <<
				"with #{cu} login" do
			study_subject = Factory(:study_subject)
			login_as send(cu)
			post :create, :study_subject_id => study_subject.id,
				:addressing => factory_attributes(
					:is_verified => true,
					:how_verified => 'no idea'
				)
			assert assigns(:addressing)
			assert_not_nil assigns(:addressing).verified_on
		end

		test "should set verified_by on create if is_verified " <<
				"with #{cu} login" do
			study_subject = Factory(:study_subject)
			login_as u = send(cu)
			post :create, :study_subject_id => study_subject.id,
				:addressing => factory_attributes(
					:is_verified => true,
					:how_verified => 'no idea'
				)
			assert assigns(:addressing)
			assert_not_nil assigns(:addressing).verified_by_uid
			assert_equal assigns(:addressing).verified_by_uid, u.uid
		end

		test "should NOT create new addressing with invalid study_subject_id " <<
				"and #{cu} login" do
			login_as send(cu)
			assert_difference('Addressing.count',0) {
			assert_difference('Address.count',0) {
				post :create, :study_subject_id => 0, 
					:addressing => factory_attributes
			} }
			assert_not_nil flash[:error]
			assert_redirected_to study_subjects_path
		end

		test "should NOT create new addressing with #{cu} login " <<
				"when create fails" do
			study_subject = Factory(:study_subject)
			Addressing.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			assert_difference('Addressing.count',0) {
			assert_difference('Address.count',0) {
				post :create, :study_subject_id => study_subject.id,
					:addressing => factory_attributes
			} }
			assert assigns(:study_subject)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

		test "should NOT create new addressing with #{cu} login " <<
				"and invalid addressing" do
			Addressing.any_instance.stubs(:valid?).returns(false)
			study_subject = Factory(:study_subject)
			login_as send(cu)
			assert_difference('Addressing.count',0) {
			assert_difference('Address.count',0) {
				post :create, :study_subject_id => study_subject.id,
					:addressing => factory_attributes
			} }
			assert assigns(:study_subject)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

		test "should NOT create new addressing with #{cu} login " <<
				"and invalid address" do
	#		Address.any_instance.stubs(:valid?).returns(false)
			Address.any_instance.stubs(:create_or_update).returns(false)
			study_subject = Factory(:study_subject)
			login_as send(cu)
			assert_difference('Addressing.count',0) {
			assert_difference('Address.count',0) {
				post :create, :study_subject_id => study_subject.id,
					:addressing => factory_attributes(address_attributes(
						:line_1 => nil
					))
			} }
			assert assigns(:study_subject)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

		test "should set verified_on on update if is_verified " <<
				"with #{cu} login" do
			addressing = create_addressing
			login_as send(cu)
			put :update, :id => addressing.id,
				:addressing => factory_attributes(
					:is_verified  => true,
					:how_verified => 'not a clue'
				)
			assert assigns(:addressing)
			assert_not_nil assigns(:addressing).verified_on
		end

		test "should set verified_by on update if is_verified " <<
				"with #{cu} login" do
			addressing = create_addressing
			login_as u = send(cu)
			put :update, :id => addressing.id,
				:addressing => factory_attributes(
					:is_verified => true,
					:how_verified => 'not a clue'
				)
			assert assigns(:addressing)
			assert_not_nil assigns(:addressing).verified_by_uid
			assert_equal assigns(:addressing).verified_by_uid, u.uid
		end

		test "should NOT update addressing with #{cu} login " <<
				"when address update fails" do
			addressing = create_addressing(:updated_at => ( Time.now - 1.day ) )
			Address.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			deny_changes("Addressing.find(#{addressing.id}).updated_at") {
				put :update, :id => addressing.id,
					:addressing => factory_attributes(address_attributes)
			}
			assert assigns(:addressing)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end

		test "should NOT update addressing with #{cu} login " <<
				"and invalid address" do
			addressing = create_addressing(:updated_at => ( Time.now - 1.day ) )
			Address.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			deny_changes("Addressing.find(#{addressing.id}).updated_at") {
				put :update, :id => addressing.id,
					:addressing => factory_attributes(address_attributes(
						:line_1 => nil
					))
			}
			assert assigns(:addressing)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end

	end

	non_site_editors.each do |cu|

		test "should NOT get new addressing with #{cu} login" do
			study_subject = Factory(:study_subject)
			login_as send(cu)
			get :new, :study_subject_id => study_subject.id
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

		test "should NOT create new addressing with #{cu} login" do
			study_subject = Factory(:study_subject)
			login_as send(cu)
			post :create, :study_subject_id => study_subject.id,
				:addressing => factory_attributes
			assert_not_nil flash[:error]
			assert_redirected_to root_path
		end

	end

	test "should NOT get new addressing without login" do
		study_subject = Factory(:study_subject)
		get :new, :study_subject_id => study_subject.id
		assert_redirected_to_login
	end

	test "should NOT create new addressing without login" do
		study_subject = Factory(:study_subject)
		post :create, :study_subject_id => study_subject.id,
			:addressing => factory_attributes
		assert_redirected_to_login
	end

protected

	def addressing_with_address(options={})
		Factory.attributes_for(:addressing, {
			:address_attributes => Factory.attributes_for(:address,{
				:address_type => AddressType['residence']
			}.merge(options[:address]||{}))
		}.merge(options[:addressing]||{}))
	end

	def ca_addressing(options={})
		addressing_with_address({
			:address => {:state => 'CA'}}.merge(options))
	end

	def az_addressing(options={})
		addressing_with_address({
			:address => {:state => 'AZ'}}.merge(options))
	end

end
