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
		project = Factory(:study_event)
		login_as admin
		get :show, :id => project.id
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
			post :create, :project => Factory.attributes_for(:study_event)
		end
		assert_redirected_to project_path(assigns(:project))
	end

	test "should get edit with admin login" do
		project = Factory(:study_event)
		login_as admin
		get :edit, :id => project.id
		assert_response :success
		assert_template 'edit'
	end

	test "should update with admin login" do
		project = Factory(:study_event)
		login_as admin
		put :update, :id => project.id, 
			:project => Factory.attributes_for(:study_event)
		assert_redirected_to project_path(assigns(:project))
	end

	test "should destroy with admin login" do
		project = Factory(:study_event)
		login_as admin
		assert_difference('StudyEvent.count',-1) do
			delete :destroy, :id => project.id
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
		project = Factory(:study_event)
		login_as employee
		get :show, :id => project.id
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
			post :create, :project => Factory.attributes_for(:study_event)
		end
		assert_redirected_to project_path(assigns(:project))
	end

	test "should get edit with employee login" do
		project = Factory(:study_event)
		login_as employee
		get :edit, :id => project.id
		assert_response :success
		assert_template 'edit'
	end

	test "should update with employee login" do
		project = Factory(:study_event)
		login_as employee
		put :update, :id => project.id, 
			:project => Factory.attributes_for(:study_event)
		assert_redirected_to project_path(assigns(:project))
	end

	test "should destroy with employee login" do
		project = Factory(:study_event)
		login_as employee
		assert_difference('StudyEvent.count',-1) do
			delete :destroy, :id => project.id
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
		project = Factory(:study_event)
		login_as active_user
		get :show, :id => project.id
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
			post :create, :project => Factory.attributes_for(:study_event)
		end
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should get edit with just user login" do
		project = Factory(:study_event)
		login_as active_user
		get :edit, :id => project.id
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should update with just user login" do
		project = Factory(:study_event)
		login_as active_user
		put :update, :id => project.id, 
			:project => Factory.attributes_for(:study_event)
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should destroy with just user login" do
		project = Factory(:study_event)
		login_as active_user
		assert_difference('StudyEvent.count',0) do
			delete :destroy, :id => project.id
		end
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

#	save errors

	test "should NOT create when create fails" do
		login_as admin_user
		StudyEvent.any_instance.stubs(:create_or_update).returns(false)
		assert_difference('StudyEvent.count',0) {
			post :create, :project => Factory.attributes_for(:study_event)
		}
		assert_response :success
		assert_template 'new'
		assert_not_nil assigns(:project)
	end

	test "should NOT update when save fails" do
		login_as admin_user
		project = Factory(:study_event)
		StudyEvent.any_instance.stubs(:create_or_update).returns(false)
		put :update, :id => project.id,
			:project => Factory.attributes_for(:study_event)
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT destroy when save fails" do
		login_as admin_user
		project = Factory(:study_event)
		StudyEvent.any_instance.stubs(:new_record?).returns(true)
		assert_difference('StudyEvent.count',0){
			delete :destroy, :id => project.id
		}
		assert_not_nil flash[:error]
		assert_redirected_to projects_path
	end

#	NO id

	test "should NOT get show without id" do
		project = Factory(:study_event)
		login_as admin
		assert_raise(ActionController::RoutingError){
			get :show
		}
	end

	test "should NOT get edit without id" do
		project = Factory(:study_event)
		login_as admin
		assert_raise(ActionController::RoutingError){
			get :edit
		}
	end

	test "should NOT update without id" do
		project = Factory(:study_event)
		login_as admin
		assert_raise(ActionController::RoutingError){
			put :update, :project => Factory.attributes_for(:study_event)
		}
	end

	test "should NOT destroy without id" do
		project = Factory(:study_event)
		login_as admin
		assert_raise(ActionController::RoutingError){
		assert_difference('StudyEvent.count',0){
			delete :destroy
		} }
	end

#	INVALID id

	test "should NOT get show without valid id" do
		project = Factory(:study_event)
		login_as admin
		get :show, :id => 0
		assert_redirected_to projects_path
	end

	test "should NOT get edit without valid id" do
		project = Factory(:study_event)
		login_as admin
		get :edit, :id => 0
		assert_redirected_to projects_path
	end

	test "should NOT update without valid id" do
		project = Factory(:study_event)
		login_as admin
		put :update, :id => 0,
			:project => Factory.attributes_for(:study_event)
		assert_redirected_to projects_path
	end

	test "should NOT destroy without valid id" do
		project = Factory(:study_event)
		login_as admin
		assert_difference('StudyEvent.count',0) do
			delete :destroy, :id => 0
		end
		assert_redirected_to projects_path
	end


#	invalid project


	test "should NOT create with invalid project" do
		pending
	end

	test "should NOT update with invalid project" do
		pending
	end

end
