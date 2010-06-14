require File.dirname(__FILE__) + '/../test_helper'

class PackagesControllerTest < ActionController::TestCase

	assert_access_with_login [
		:new,:create,:show,:destroy,:index],{
		:login => :admin, :factory => :package }

	assert_access_with_login [
		:new,:create,:show,:destroy,:index],{
		:login => :employee, :factory => :package }

	assert_no_access_with_login [
		:new,:create,:show,:destroy,:index],{
		:login => :active_user, :factory => :package }

	assert_no_access_without_login [
		:new, :create, :show, :destroy, :index],{
		:factory => :package}



	test "delivered packages should NOT have update status link" do
		Factory(:package, :status => "Delivered")
		login_as admin_user
		get :index
		assert_select "div.update" do
			assert_select "a", :count => 0
		end
	end

	test "undelivered packages should have update status link" do
		Factory(:package)
		login_as admin_user
		get :index
		assert_select "div.update" do
			assert_select "a", :count => 1
		end
	end

	test "should get index with admin login with packages" do
		Factory(:package)
		login_as admin_user
		get :index
		assert_template 'index'
		assert_response :success
		assert_equal 1, assigns(:packages).length
	end

	test "should NOT create with invalid package" do
		login_as admin_user
		post :create, :package => {}
		assert_not_nil assigns(:package)
		assert_response :success
		assert_template 'new'
	end





	test "should update with admin login" do
		login_as admin_user
		package = Factory(:package, :tracking_number => '077973360403984')
		assert_nil package.status
		put :update, :id => package.id
		assert_not_nil package.reload.status
		assert_redirected_to packages_path
	end

	test "should update with employee login" do
		login_as employee
		package = Factory(:package, :tracking_number => '077973360403984')
		assert_nil package.status
		put :update, :id => package.id
		assert_not_nil package.reload.status
		assert_redirected_to packages_path
	end

	test "should update and redirect to referer if set" do
		login_as admin_user
		package = Factory(:package)
		@request.env["HTTP_REFERER"] = package_path(package)
#	all currently result in the same redirect
#		@request.session[:refer_to] = package_path(package)
#		session[:refer_to] = package_path(package)
		put :update, :id => package.id
		assert_redirected_to package_path(package)
	end

	test "should NOT update without admin login" do
		login_as active_user
		package = Factory(:package, :tracking_number => '077973360403984')
		assert_nil package.status
		put :update, :id => package.id
		assert_nil package.reload.status
		assert_redirected_to root_path
	end

	test "should NOT update without login" do
		package = Factory(:package, :tracking_number => '077973360403984')
		assert_nil package.status
		put :update, :id => package.id
		assert_nil package.reload.status
		assert_redirected_to_login
	end


	test "should NOT destroy package without valid id" do
		login_as admin_user
		package = Factory(:package)
		assert_difference('Package.count',0) {
			delete :destroy, :id => 0
		}
		assert_redirected_to packages_path
	end



	test "should simulate ship with admin login" do
		login_as admin_user
		package = Factory(:package)
		assert_not_equal 'Transit', package.reload.status
		put :ship, :id => package.id
		assert_equal 'Transit', package.reload.status
		assert_response :redirect
	end

	test "should simulate delivery with admin login" do
		login_as admin_user
		package = Factory(:package)
		assert_not_equal 'Delivered', package.reload.status
		put :deliver, :id => package.id
		assert_equal 'Delivered', package.reload.status
		assert_response :redirect
	end

end
