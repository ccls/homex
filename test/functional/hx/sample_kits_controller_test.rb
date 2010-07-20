require File.dirname(__FILE__) + '/../../test_helper'

class Hx::SampleKitsControllerTest < ActionController::TestCase

	setup :create_home_exposure_with_subject
	setup :build_sample
	def build_sample	#setup
		@sample = Factory(:sample)
	end

#	no route as is has_one

	test "should NOT get index with sample id" do
		assert_raise(ActionController::RoutingError){
			get :index, :sample_id => @sample.id
		}
	end


#	not logged in

	test "should NOT get new without login" do
		get :new, :sample_id => @sample.id
		assert_redirected_to_login
	end

	test "should NOT post create without login" do
		assert_difference('SampleKit.count',0){
			post :create, :sample_id => @sample.id, 
				:sample_kit => Factory.attributes_for(:sample_kit)
		}
		assert_redirected_to_login
	end

	test "should NOT get edit without login" do
		get :edit, :sample_id => @sample.id
		assert_redirected_to_login
	end

	test "should NOT put update without login" do
		put :update, :sample_id => @sample.id,
			:sample_kit => Factory.attributes_for(:sample_kit)
		assert_redirected_to_login
	end

	test "should NOT get show without login" do
		get :show, :sample_id => @sample.id
		assert_redirected_to_login
	end

	test "should NOT delete destroy without login" do
		assert_difference('SampleKit.count',0) {
			delete :destroy, :sample_id => @sample.id
		}
		assert_redirected_to_login
	end

%w( admin employee editor ).each do |cu|

	test "should get new with #{cu} login" do
		login_as send(cu)
		get :new, :sample_id => @sample.id
		assert_response :success
		assert_template 'new'
		assert assigns(:sample_kit)
		assert_layout 'home_exposure'
	end

	test "should post create with #{cu} login" do
		login_as send(cu)
		assert_difference('SampleKit.count',1) {
			post :create, :sample_id => @sample.id,
				:sample_kit => Factory.attributes_for(:sample_kit)
		}
		assert_redirected_to hx_subject_path(assigns(:subject))
	end

	test "should get edit with #{cu} login" do
		login_as send(cu)
		get :edit, :sample_id => @sample.id
		assert_response :success
		assert_template 'edit'
		assert assigns(:sample_kit)
		assert_layout 'home_exposure'
	end

	test "should put update with #{cu} login" do
		login_as send(cu)
		Factory(:sample_kit,:sample_id => @sample.id)
		put :update, :sample_id => @sample.id,
			:sample_kit => Factory.attributes_for(:sample_kit)
		assert_redirected_to hx_subject_path(assigns(:subject))
	end

	test "should get show with #{cu} login" do
		login_as send(cu)
		get :show, :sample_id => @sample.id
		assert_response :success
		assert_template 'show'
		assert assigns(:sample_kit)
		assert_layout 'home_exposure'
	end

	test "should get show with #{cu} login and packages" do
		Factory(:sample_kit, 
			:kit_package_attributes  => Factory.attributes_for(:package),
			:dust_package_attributes => Factory.attributes_for(:package)
		)
		login_as send(cu)
		get :show, :sample_id => @sample.id
		assert_response :success
		assert_template 'show'
		assert assigns(:sample_kit)
	end

	test "should delete destroy with #{cu} login" do
		login_as send(cu)
		Factory(:sample_kit,:sample_id => @sample.id)
		assert_difference('SampleKit.count',-1){
			delete :destroy, :sample_id => @sample.id
		}
		assert_redirected_to hx_subject_path(assigns(:subject))
	end

#	no sample_id

	test "should get new without sample_id with #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			get :new
		}
	end

	test "should post create without sample_id with #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
		assert_difference('SampleKit.count',0) {
			post :create,
				:sample_kit => Factory.attributes_for(:sample_kit)
		} }
	end

	test "should get edit without sample_id with #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			get :edit
		}
	end

	test "should put update without sample_id with #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			put :update,
				:sample_kit => Factory.attributes_for(:sample_kit)
		}
	end

	test "should get show without sample_id with #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			get :show
		}
	end

	test "should delete destroy without sample_id with #{cu} login" do
		login_as send(cu)
		Factory(:sample_kit,:sample_id => @sample.id)
		assert_raise(ActionController::RoutingError){
		assert_difference('SampleKit.count',0){
			delete :destroy
		} }
	end

#	save errors

	test "should NOT post create with empty packages with #{cu} login" do
		login_as send(cu)
		assert_difference('SampleKit.count',0) {
			post :create, :sample_id => @sample.id,
				:sample_kit => {
					:kit_package_attributes  => {},
					:dust_package_attributes => {} 
				}
		}
		assert_response :success
		assert_template 'new'
	end

	test "should NOT post create with save failure with #{cu} login" do
		login_as send(cu)
		SampleKit.any_instance.stubs(:create_or_update).returns(false)
		assert_difference('SampleKit.count',0) {
			post :create, :sample_id => @sample.id,
				:sample_kit => Factory.attributes_for(:sample_kit)
		}
		assert_response :success
		assert_template 'new'
	end

	test "should NOT put update with empty packages with #{cu} login" do
		login_as send(cu)
		Factory(:sample_kit,:sample_id => @sample.id)
		put :update, :sample_id => @sample.id,
			:sample_kit => {
				:kit_package_attributes  => {},
				:dust_package_attributes => {} 
			}
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT put update with save failure with #{cu} login" do
		login_as send(cu)
		Factory(:sample_kit,:sample_id => @sample.id)
		SampleKit.any_instance.stubs(:create_or_update).returns(false)
		put :update, :sample_id => @sample.id,
			:sample_kit => Factory.attributes_for(:sample_kit)
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT delete destroy with destruction failure with #{cu} login" do
		login_as send(cu)
		Factory(:sample_kit,:sample_id => @sample.id)
		SampleKit.any_instance.stubs(:new_record?).returns(true)
		assert_difference('SampleKit.count',0){
			delete :destroy, :sample_id => @sample.id
		}
#		assert_not_nil flash[:error]
		assert_redirected_to hx_subject_path(assigns(:subject))
	end

#	NO sample_id

	test "should NOT get new without sample_id  with #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			get :new
		}
	end

	test "should NOT post create without sample_id with #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
		assert_difference('SampleKit.count',0) {
			post :create, :sample_kit => Factory.attributes_for(:sample_kit)
		} }
	end

	test "should NOT get edit without sample_id with #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			get :edit
		}
	end

	test "should NOT put update without sample_id with #{cu} login" do
		login_as send(cu)
		Factory(:sample_kit,:sample_id => @sample.id)
		assert_raise(ActionController::RoutingError){
			put :update, :sample_kit => Factory.attributes_for(:sample_kit)
		}
	end

	test "should NOT get show without sample_id with #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			get :show
		}
	end

	test "should NOT delete destroy without sample_id with #{cu} login" do
		login_as send(cu)
		Factory(:sample_kit,:sample_id => @sample.id)
		assert_raise(ActionController::RoutingError){
		assert_difference('SampleKit.count',0){
			delete :destroy
		} }
	end

#	INVALID sample_id

	test "should NOT get new with invalid sample_id with #{cu} login" do
		login_as send(cu)
		get :new, :sample_id => 0
		assert_redirected_to hx_subjects_path
		assert_not_nil flash[:error]
	end

	test "should NOT post create with invalid sample_id with #{cu} login" do
		login_as send(cu)
		assert_difference('SampleKit.count',0) {
			post :create, :sample_id => 0,
				:sample_kit => Factory.attributes_for(:sample_kit)
		}
		assert_redirected_to hx_subjects_path
		assert_not_nil flash[:error]
	end

	test "should NOT get edit with invalid sample_id with #{cu} login" do
		login_as send(cu)
		get :edit, :sample_id => 0
		assert_redirected_to hx_subjects_path
		assert_not_nil flash[:error]
	end

	test "should NOT put update with invalid sample_id with #{cu} login" do
		login_as send(cu)
		Factory(:sample_kit,:sample_id => @sample.id)
		put :update, :sample_id => 0,
			:sample_kit => Factory.attributes_for(:sample_kit)
		assert_redirected_to hx_subjects_path
		assert_not_nil flash[:error]
	end

	test "should NOT get show with invalid sample_id with #{cu} login" do
		login_as send(cu)
		get :show, :sample_id => 0
		assert_redirected_to hx_subjects_path
		assert_not_nil flash[:error]
	end

	test "should NOT delete destroy with invalid sample_id with #{cu} login" do
		login_as send(cu)
		Factory(:sample_kit,:sample_id => @sample.id)
		assert_difference('SampleKit.count',0){
			delete :destroy, :sample_id => 0
		}
		assert_redirected_to hx_subjects_path
		assert_not_nil flash[:error]
	end


#	invalid dust kit
#	(no validations yet so no tests yet)

end

%w( moderator active_user ).each do |cu|

	test "should NOT get new with #{cu} login" do
		login_as send(cu)
		get :new, :sample_id => @sample.id
		assert_redirected_to root_path
	end

	test "should NOT post create with #{cu} login" do
		login_as send(cu)
		assert_difference('SampleKit.count',0) {
			post :create, :sample_id => @sample.id,
				:sample_kit => Factory.attributes_for(:sample_kit)
		}
		assert_redirected_to root_path
	end

	test "should NOT get edit with #{cu} login" do
		login_as send(cu)
		get :edit, :sample_id => @sample.id
		assert_redirected_to root_path
	end

	test "should NOT put update with #{cu} login" do
		login_as send(cu)
		Factory(:sample_kit,:sample_id => @sample.id)
		put :update, :sample_id => @sample.id,
			:sample_kit => Factory.attributes_for(:sample_kit)
		assert_redirected_to root_path
	end

	test "should NOT get show with #{cu} login" do
		login_as send(cu)
		get :show, :sample_id => @sample.id
		assert_redirected_to root_path
	end

	test "should NOT delete destroy with #{cu} login" do
		login_as send(cu)
		Factory(:sample_kit,:sample_id => @sample.id)
		assert_difference('SampleKit.count',0){
			delete :destroy, :sample_id => @sample.id
		}
		assert_redirected_to root_path
	end

end

end
