require File.dirname(__FILE__) + '/../test_helper'

class ProjectsControllerTest < ActionController::TestCase

#	I think that a Project and a StudyEvent are the same thing

#	admin

	test "should get index with admin login" do
		login_as admin
		get :index
		assert_response :success
		assert_template 'index'
	end

	test "should get show with admin login" do
		study_event = Factory(:study_event)
		login_as admin
		get :show, :id => study_event.id
		assert_response :success
		assert_template 'show'
	end

	test "should get new with admin login" do
		login_as admin
		get :new
		assert_response :success
		assert_template 'new'
	end

	test "should post create with admin login" do
		login_as admin
		assert_difference('StudyEvent.count',1) do
			post :create, :study_event => Factory.attributes_for(:study_event)
		end
		assert_redirected_to project_path(assigns(:study_event).id)
	end

	test "should get edit with admin login" do
		study_event = Factory(:study_event)
		login_as admin
		get :edit, :id => study_event.id
		assert_response :success
		assert_template 'edit'
	end

	test "should update with admin login" do
		study_event = Factory(:study_event)
		login_as admin
		put :update, :id => study_event.id, 
			:study_event => Factory.attributes_for(:study_event)
		assert_redirected_to project_path(assigns(:study_event).id)
	end

	test "should destroy with admin login" do
		study_event = Factory(:study_event)
		login_as admin
		assert_difference('StudyEvent.count',-1) do
			delete :destroy, :id => study_event.id
		end
		assert_redirected_to projects_path
	end

#	employee

	test "should get index with employee login" do
		login_as employee
		get :index
		assert_response :success
		assert_template 'index'
	end

	test "should get show with employee login" do
		study_event = Factory(:study_event)
		login_as employee
		get :show, :id => study_event.id
		assert_response :success
		assert_template 'show'
	end

	test "should get new with employee login" do
		login_as employee
		get :new
		assert_response :success
		assert_template 'new'
	end

	test "should post create with employee login" do
		login_as employee
		assert_difference('StudyEvent.count',1) do
			post :create, :study_event => Factory.attributes_for(:study_event)
		end
		assert_redirected_to project_path(assigns(:study_event).id)
	end

	test "should get edit with employee login" do
		study_event = Factory(:study_event)
		login_as employee
		get :edit, :id => study_event.id
		assert_response :success
		assert_template 'edit'
	end

	test "should update with employee login" do
		study_event = Factory(:study_event)
		login_as employee
		put :update, :id => study_event.id, 
			:study_event => Factory.attributes_for(:study_event)
		assert_redirected_to project_path(assigns(:study_event).id)
	end

	test "should destroy with employee login" do
		study_event = Factory(:study_event)
		login_as employee
		assert_difference('StudyEvent.count',-1) do
			delete :destroy, :id => study_event.id
		end
		assert_redirected_to projects_path
	end

#	just user

	test "should NOT get index with just user login" do
		login_as active_user
		get :index
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should get show with just user login" do
		study_event = Factory(:study_event)
		login_as active_user
		get :show, :id => study_event.id
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should get new with just user login" do
		login_as active_user
		get :new
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should post create with just user login" do
		login_as active_user
		assert_difference('StudyEvent.count',0) do
			post :create, :study_event => Factory.attributes_for(:study_event)
		end
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should get edit with just user login" do
		study_event = Factory(:study_event)
		login_as active_user
		get :edit, :id => study_event.id
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should update with just user login" do
		study_event = Factory(:study_event)
		login_as active_user
		put :update, :id => study_event.id, 
			:study_event => Factory.attributes_for(:study_event)
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should destroy with just user login" do
		study_event = Factory(:study_event)
		login_as active_user
		assert_difference('StudyEvent.count',0) do
			delete :destroy, :id => study_event.id
		end
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

#	not logged in

	test "should NOT get index without login" do
		get :index
		assert_redirected_to login_path
	end

	test "should NOT get show without login" do
		study_event = Factory(:study_event)
		get :show, :id => study_event.id
		assert_redirected_to login_path
	end

	test "should NOT get new without login" do
		get :new
		assert_redirected_to login_path
	end

	test "should NOT post create without login" do
		assert_difference('StudyEvent.count',0) do
			post :create, :study_event => Factory.attributes_for(:study_event)
		end
		assert_redirected_to login_path
	end

	test "should NOT get edit without login" do
		study_event = Factory(:study_event)
		get :edit, :id => study_event.id
		assert_redirected_to login_path
	end

	test "should NOT update without login" do
		study_event = Factory(:study_event)
		put :update, :id => study_event.id, 
			:study_event => Factory.attributes_for(:study_event)
		assert_redirected_to login_path
	end

	test "should NOT destroy without login" do
		study_event = Factory(:study_event)
		assert_difference('StudyEvent.count',0) do
			delete :destroy, :id => study_event.id
		end
		assert_redirected_to login_path
	end

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
		assert_not_nil flash[:error]
		assert_redirected_to projects_path
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

#	INVALID id

	test "should NOT get show without valid id" do
		study_event = Factory(:study_event)
		login_as admin
		get :show, :id => 0
		assert_redirected_to projects_path
	end

	test "should NOT get edit without valid id" do
		study_event = Factory(:study_event)
		login_as admin
		get :edit, :id => 0
		assert_redirected_to projects_path
	end

	test "should NOT update without valid id" do
		study_event = Factory(:study_event)
		login_as admin
		put :update, :id => 0,
			:study_event => Factory.attributes_for(:study_event)
		assert_redirected_to projects_path
	end

	test "should NOT destroy without valid id" do
		study_event = Factory(:study_event)
		login_as admin
		assert_difference('StudyEvent.count',0) do
			delete :destroy, :id => 0
		end
		assert_redirected_to projects_path
	end


#	invalid project

	test "should NOT create with invalid project" do
		login_as admin
		assert_difference('StudyEvent.count',0) do
			post :create, :study_event => {}
		end
		assert_not_nil assigns(:study_event)
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT update with invalid project" do
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
