require File.dirname(__FILE__) + '/../test_helper'

class StudyEventsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'StudyEvent',
		:attributes_for_create => :factory_attributes,
		:method_for_create => :factory_create
	}

	def factory_attributes
		Factory.attributes_for(:study_event)
	end
	def factory_create
		Factory(:study_event)
	end

	assert_access_with_login :new,:create,:edit,:update,:show,:destroy,:index,{
		:login => :admin }

	assert_access_with_login :new,:create,:edit,:update,:show,:destroy,:index,{
		:login => :employee }

	assert_no_access_with_login :new,:create,:edit,:update,:show,:destroy,:index,{
		:login => :editor }

	assert_no_access_with_login :new,:create,:edit,:update,:show,:destroy,:index,{
		:login => :active_user }

	assert_no_access_without_login :new,:create,:edit,:update,:show,:destroy,:index


	assert_access_with_https :new,:create,:edit,:update,:show,:destroy,:index

	assert_no_access_with_http :new,:create,:edit,:update,:show,:destroy,:index

	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:suffix => " and invalid id",
		:login => :admin,
		:redirect => :study_events_path,
		:edit => { :id => 0 },
		:update => { :id => 0 },
		:show => { :id => 0 },
		:destroy => { :id => 0 }
	)

#	save errors

	test "should NOT create when create fails" do
		login_as admin_user
		StudyEvent.any_instance.stubs(:create_or_update).returns(false)
		assert_difference('StudyEvent.count',0) {
			post :create, :study_event => Factory.attributes_for(:study_event)
		}
		assert_response :success
		assert_template 'new'
		assert_not_nil assigns(:study_event)
	end

	test "should NOT update when save fails" do
		login_as admin_user
		study_event = Factory(:study_event)
		StudyEvent.any_instance.stubs(:create_or_update).returns(false)
		put :update, :id => study_event.id,
			:study_event => Factory.attributes_for(:study_event)
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT destroy when save fails" do
		login_as admin_user
		study_event = Factory(:study_event)
		StudyEvent.any_instance.stubs(:new_record?).returns(true)
		assert_difference('StudyEvent.count',0){
			delete :destroy, :id => study_event.id
		}
#		assert_not_nil flash[:error]
		assert_redirected_to study_events_path
	end

#	NO id

	test "should NOT get show without id" do
		study_event = Factory(:study_event)
		login_as admin
		assert_raise(ActionController::RoutingError){
			get :show
		}
	end

	test "should NOT get edit without id" do
		study_event = Factory(:study_event)
		login_as admin
		assert_raise(ActionController::RoutingError){
			get :edit
		}
	end

	test "should NOT update without id" do
		study_event = Factory(:study_event)
		login_as admin
		assert_raise(ActionController::RoutingError){
			put :update, :study_event => Factory.attributes_for(:study_event)
		}
	end

	test "should NOT destroy without id" do
		study_event = Factory(:study_event)
		login_as admin
		assert_raise(ActionController::RoutingError){
		assert_difference('StudyEvent.count',0){
			delete :destroy
		} }
	end

#	invalid study_event

	test "should NOT create with invalid study_event" do
		login_as admin
		assert_difference('StudyEvent.count',0) do
			post :create, :study_event => {}
		end
		assert_not_nil assigns(:study_event)
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT update with invalid study_event" do
		study_event = Factory(:study_event)
		login_as admin
		put :update, :id => study_event.id, 
			:study_event => {:description => nil}
		assert_not_nil assigns(:study_event)
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'edit'
	end

end
