require File.dirname(__FILE__) + '/../test_helper'

class DustKitsControllerTest < ActionController::TestCase

	setup :build_subject
	def build_subject	#setup
		@subject = Factory(:subject)
	end

#	no route as is has_one

	test "should NOT get index with subject id" do
		assert_raise(ActionController::RoutingError){
			get :index, :subject_id => @subject.id
		}
	end


#	not logged in

	test "should NOT get new without login" do
		get :new, :subject_id => @subject.id
		assert_redirected_to login_path
	end

	test "should NOT post create without login" do
		assert_difference('DustKit.count',0){
			post :create, :subject_id => @subject.id, 
				:dust_kit => Factory.attributes_for(:dust_kit)
		}
		assert_redirected_to login_path
	end

	test "should NOT get edit without login" do
		get :edit, :subject_id => @subject.id
		assert_redirected_to login_path
	end

	test "should NOT put update without login" do
		put :update, :subject_id => @subject.id,
			:dust_kit => Factory.attributes_for(:dust_kit)
		assert_redirected_to login_path
	end

	test "should NOT get show without login" do
		get :show, :subject_id => @subject.id
		assert_redirected_to login_path
	end

	test "should NOT delete destroy without login" do
		assert_difference('DustKit.count',0) {
			delete :destroy, :subject_id => @subject.id
		}
		assert_redirected_to login_path
	end

#	admin login

	test "should get new with admin login" do
		login_as admin_user
		get :new, :subject_id => @subject.id
		assert_response :success
		assert_template 'new'
		assert assigns(:dust_kit)
	end

	test "should post create with admin login" do
		login_as admin_user
		assert_difference('DustKit.count',1) {
			post :create, :subject_id => @subject.id,
				:dust_kit => Factory.attributes_for(:dust_kit)
		}
		assert_redirected_to subject_path(assigns(:subject))
	end

	test "should get edit with admin login" do
		login_as admin_user
		get :edit, :subject_id => @subject.id
		assert_response :success
		assert_template 'edit'
		assert assigns(:dust_kit)
	end

	test "should put update with admin login" do
		login_as admin_user
		Factory(:dust_kit,:subject_id => @subject.id)
		put :update, :subject_id => @subject.id,
			:dust_kit => Factory.attributes_for(:dust_kit)
		assert_redirected_to subject_path(assigns(:subject))
	end

	test "should get show with admin login" do
		login_as admin_user
		get :show, :subject_id => @subject.id
		assert_response :success
		assert_template 'show'
		assert assigns(:dust_kit)
	end

	test "should get show with admin login and packages" do
		Factory(:dust_kit, 
			:kit_package_attributes  => Factory.attributes_for(:package),
			:dust_package_attributes => Factory.attributes_for(:package)
		)
		login_as admin_user
		get :show, :subject_id => @subject.id
		assert_response :success
		assert_template 'show'
		assert assigns(:dust_kit)
	end

	test "should delete destroy with admin login" do
		login_as admin_user
		Factory(:dust_kit,:subject_id => @subject.id)
		assert_difference('DustKit.count',-1){
			delete :destroy, :subject_id => @subject.id
		}
		assert_redirected_to subject_path(assigns(:subject))
	end

#	employee login

	test "should get new with employee login" do
		login_as employee
		get :new, :subject_id => @subject.id
		assert_response :success
		assert_template 'new'
		assert assigns(:dust_kit)
	end

	test "should post create with employee login" do
		login_as employee
		assert_difference('DustKit.count',1) {
			post :create, :subject_id => @subject.id,
				:dust_kit => Factory.attributes_for(:dust_kit)
		}
		assert_redirected_to subject_path(assigns(:subject))
	end

	test "should get edit with employee login" do
		login_as employee
		get :edit, :subject_id => @subject.id
		assert_response :success
		assert_template 'edit'
		assert assigns(:dust_kit)
	end

	test "should put update with employee login" do
		login_as employee
		Factory(:dust_kit,:subject_id => @subject.id)
		put :update, :subject_id => @subject.id,
			:dust_kit => Factory.attributes_for(:dust_kit)
		assert_redirected_to subject_path(assigns(:subject))
	end

	test "should get show with employee login" do
		login_as employee
		get :show, :subject_id => @subject.id
		assert_response :success
		assert_template 'show'
		assert assigns(:dust_kit)
	end

	test "should delete destroy with employee login" do
		login_as employee
		Factory(:dust_kit,:subject_id => @subject.id)
		assert_difference('DustKit.count',-1){
			delete :destroy, :subject_id => @subject.id
		}
		assert_redirected_to subject_path(assigns(:subject))
	end

#	user login

	test "should NOT get new with just login" do
		login_as user
		get :new, :subject_id => @subject.id
		assert_redirected_to root_path
	end

	test "should NOT post create with just login" do
		login_as user
		assert_difference('DustKit.count',0) {
			post :create, :subject_id => @subject.id,
				:dust_kit => Factory.attributes_for(:dust_kit)
		}
		assert_redirected_to root_path
	end

	test "should NOT get edit with just login" do
		login_as user
		get :edit, :subject_id => @subject.id
		assert_redirected_to root_path
	end

	test "should NOT put update with just login" do
		login_as user
		Factory(:dust_kit,:subject_id => @subject.id)
		put :update, :subject_id => @subject.id,
			:dust_kit => Factory.attributes_for(:dust_kit)
		assert_redirected_to root_path
	end

	test "should NOT get show with just login" do
		login_as user
		get :show, :subject_id => @subject.id
		assert_redirected_to root_path
	end

	test "should NOT delete destroy with just login" do
		login_as user
		Factory(:dust_kit,:subject_id => @subject.id)
		assert_difference('DustKit.count',0){
			delete :destroy, :subject_id => @subject.id
		}
		assert_redirected_to root_path
	end

#	no subject_id

	test "should get new without subject_id" do
		login_as admin_user
		assert_raise(ActionController::RoutingError){
			get :new
		}
	end

	test "should post create without subject_id" do
		login_as admin_user
		assert_raise(ActionController::RoutingError){
		assert_difference('DustKit.count',0) {
			post :create,
				:dust_kit => Factory.attributes_for(:dust_kit)
		} }
	end

	test "should get edit without subject_id" do
		login_as admin_user
		assert_raise(ActionController::RoutingError){
			get :edit
		}
	end

	test "should put update without subject_id" do
		login_as admin_user
		assert_raise(ActionController::RoutingError){
			put :update,
				:dust_kit => Factory.attributes_for(:dust_kit)
		}
	end

	test "should get show without subject_id" do
		login_as admin_user
		assert_raise(ActionController::RoutingError){
			get :show
		}
	end

	test "should delete destroy without subject_id" do
		login_as admin_user
		Factory(:dust_kit,:subject_id => @subject.id)
		assert_raise(ActionController::RoutingError){
		assert_difference('DustKit.count',0){
			delete :destroy
		} }
	end

#	save errors

	test "should NOT post create with empty packages" do
		login_as admin_user
		assert_difference('DustKit.count',0) {
			post :create, :subject_id => @subject.id,
				:dust_kit => {
					:kit_package_attributes  => {},
					:dust_package_attributes => {} 
				}
		}
		assert_response :success
		assert_template 'new'
	end

	test "should NOT post create with save failure" do
		login_as admin_user
		DustKit.any_instance.stubs(:create_or_update).returns(false)
		assert_difference('DustKit.count',0) {
			post :create, :subject_id => @subject.id,
				:dust_kit => Factory.attributes_for(:dust_kit)
		}
		assert_response :success
		assert_template 'new'
	end

	test "should NOT put update with empty packages" do
		login_as admin_user
		Factory(:dust_kit,:subject_id => @subject.id)
		put :update, :subject_id => @subject.id,
			:dust_kit => {
				:kit_package_attributes  => {},
				:dust_package_attributes => {} 
			}
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT put update with save failure" do
		login_as admin_user
		Factory(:dust_kit,:subject_id => @subject.id)
		DustKit.any_instance.stubs(:create_or_update).returns(false)
		put :update, :subject_id => @subject.id,
			:dust_kit => Factory.attributes_for(:dust_kit)
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT delete destroy with destruction failure" do
		login_as admin_user
		Factory(:dust_kit,:subject_id => @subject.id)
		DustKit.any_instance.stubs(:new_record?).returns(true)
		assert_difference('DustKit.count',0){
			delete :destroy, :subject_id => @subject.id
		}
		assert_not_nil flash[:error]
		assert_redirected_to subject_path(assigns(:subject))
	end

#	NO subject_id

	test "should NOT get new without subject_id " do
		login_as admin_user
		assert_raise(ActionController::RoutingError){
			get :new
		}
	end

	test "should NOT post create without subject_id" do
		login_as admin_user
		assert_raise(ActionController::RoutingError){
		assert_difference('DustKit.count',0) {
			post :create, :dust_kit => Factory.attributes_for(:dust_kit)
		} }
	end

	test "should NOT get edit without subject_id" do
		login_as admin_user
		assert_raise(ActionController::RoutingError){
			get :edit
		}
	end

	test "should NOT put update without subject_id" do
		login_as admin_user
		Factory(:dust_kit,:subject_id => @subject.id)
		assert_raise(ActionController::RoutingError){
			put :update, :dust_kit => Factory.attributes_for(:dust_kit)
		}
	end

	test "should NOT get show without subject_id" do
		login_as admin_user
		assert_raise(ActionController::RoutingError){
			get :show
		}
	end

	test "should NOT delete destroy without subject_id" do
		login_as admin_user
		Factory(:dust_kit,:subject_id => @subject.id)
		assert_raise(ActionController::RoutingError){
		assert_difference('DustKit.count',0){
			delete :destroy
		} }
	end

#	INVALID subject_id

	test "should NOT get new with invalid subject_id" do
		login_as admin_user
		get :new, :subject_id => 0
		assert_redirected_to subjects_path
		assert_not_nil flash[:error]
	end

	test "should NOT post create with invalid subject_id" do
		login_as admin_user
		assert_difference('DustKit.count',0) {
			post :create, :subject_id => 0,
				:dust_kit => Factory.attributes_for(:dust_kit)
		}
		assert_redirected_to subjects_path
		assert_not_nil flash[:error]
	end

	test "should NOT get edit with invalid subject_id" do
		login_as admin_user
		get :edit, :subject_id => 0
		assert_redirected_to subjects_path
		assert_not_nil flash[:error]
	end

	test "should NOT put update with invalid subject_id" do
		login_as admin_user
		Factory(:dust_kit,:subject_id => @subject.id)
		put :update, :subject_id => 0,
			:dust_kit => Factory.attributes_for(:dust_kit)
		assert_redirected_to subjects_path
		assert_not_nil flash[:error]
	end

	test "should NOT get show with invalid subject_id" do
		login_as admin_user
		get :show, :subject_id => 0
		assert_redirected_to subjects_path
		assert_not_nil flash[:error]
	end

	test "should NOT delete destroy with invalid subject_id" do
		login_as admin_user
		Factory(:dust_kit,:subject_id => @subject.id)
		assert_difference('DustKit.count',0){
			delete :destroy, :subject_id => 0
		}
		assert_redirected_to subjects_path
		assert_not_nil flash[:error]
	end


#	invalid dust kit
#	(no validations yet so no tests yet)

end
