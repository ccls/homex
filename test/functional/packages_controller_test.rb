require File.dirname(__FILE__) + '/../test_helper'

class PackagesControllerTest < ActionController::TestCase

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

	test "should get index with admin login" do
		login_as admin_user
		get :index
		assert_template 'index'
		assert_response :success
		assert_equal 0, assigns(:packages).length
	end

	test "should get index with employee login" do
		login_as employee
		get :index
		assert_template 'index'
		assert_response :success
		assert_equal 0, assigns(:packages).length
	end

	test "should NOT get index without admin login" do
		login_as active_user
		get :index
		assert_redirected_to root_path
	end

	test "should NOT get index without login" do
		get :index
		assert_redirected_to_login
	end


	test "should get new with admin login" do
		login_as admin_user
		get :new
		assert_template 'new'
		assert_response :success
		assert_not_nil assigns(:package)
	end

	test "should get new with employee login" do
		login_as employee
		get :new
		assert_template 'new'
		assert_response :success
		assert_not_nil assigns(:package)
	end

	test "should NOT get new without admin login" do
		login_as active_user
		get :new
		assert_redirected_to root_path
	end

	test "should NOT get new without login" do
		get :new
		assert_redirected_to_login
	end


	test "should create with admin login" do
		login_as admin_user
		post :create, :package => Factory.attributes_for(:package)
		assert_not_nil assigns(:package)
		assert_redirected_to packages_path
	end

	test "should create with employee login" do
		login_as employee
		post :create, :package => Factory.attributes_for(:package)
		assert_not_nil assigns(:package)
		assert_redirected_to packages_path
	end

	test "should NOT create with invalid package" do
		login_as admin_user
		post :create, :package => {}
		assert_not_nil assigns(:package)
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create without admin login" do
		login_as active_user
		post :create, :package => Factory.attributes_for(:package)
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT create without login" do
		post :create, :package => Factory.attributes_for(:package)
		assert_redirected_to_login
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


	test "should show package with admin login" do
		login_as admin_user
		package = Factory(:package)
		get :show, :id => package.id
		assert_response :success
		assert_template 'show'
	end

	test "should show package with employee login" do
		login_as employee
		package = Factory(:package)
		get :show, :id => package.id
		assert_response :success
		assert_template 'show'
	end

	test "should NOT show package without admin login" do
		login_as active_user
		package = Factory(:package)
		get :show, :id => package.id
		assert_redirected_to root_path
	end

	test "should NOT show package without login" do
		package = Factory(:package)
		get :show, :id => package.id
		assert_redirected_to_login
	end


	test "should destroy package with admin login" do
		login_as admin_user
		package = Factory(:package)
		assert_difference('Package.count',-1) {
			delete :destroy, :id => package.id
		}
		assert_redirected_to packages_path
	end

	test "should destroy package with employee login" do
		login_as employee
		package = Factory(:package)
		assert_difference('Package.count',-1) {
			delete :destroy, :id => package.id
		}
		assert_redirected_to packages_path
	end

	test "should NOT destroy package with just login" do
		login_as active_user
		package = Factory(:package)
		assert_difference('Package.count',0) {
			delete :destroy, :id => package.id
		}
		assert_redirected_to root_path
	end

	test "should NOT destroy package without login" do
		package = Factory(:package)
		assert_difference('Package.count',0) {
			delete :destroy, :id => package.id
		}
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
