require File.dirname(__FILE__) + '/../test_helper'

class PackagesControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Package',
		:attributes_for_create => :factory_attributes,
		:method_for_create => :factory_create
	}

	def factory_attributes
		Factory.attributes_for(:package)
	end
	def factory_create
		Factory(:package)
	end

	assert_access_with_login :new,:create,:show,:destroy,:index,{
		:login => :admin }

	assert_access_with_login :new,:create,:show,:destroy,:index,{
		:login => :employee }

	assert_no_access_with_login :new,:create,:show,:destroy,:index,{
		:login => :active_user }

	assert_no_access_without_login :new,:create,:show,:destroy,:index


	assert_access_with_https :new,:create,:show,:destroy,:index

	assert_no_access_with_http :new,:create,:show,:destroy,:index


	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:suffix => " and invalid id",
		:login => :admin,
		:redirect => :packages_path,
		:update => { :id => 0 },
		:show => { :id => 0 }, 
		:destroy => { :id => 0 }
	)


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

	test "should NOT create with invalid package" do
		login_as admin_user
		post :create, :package => {}
		assert_not_nil assigns(:package)
		assert_response :success
		assert_template 'new'
	end



%w( admin employee editor ).each do |cu|

	test "should update with #{cu} login" do
		login_as send(cu)
		package = Factory(:package, :tracking_number => '077973360403984')
		assert_nil package.status
		put :update, :id => package.id
		assert_not_nil package.reload.status
		assert_redirected_to packages_path
	end

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

%w( active_user ).each do |cu|

	test "should NOT update with #{cu} login" do
		login_as send(cu)
		package = Factory(:package, :tracking_number => '077973360403984')
		assert_nil package.status
		put :update, :id => package.id
		assert_nil package.reload.status
		assert_redirected_to root_path
	end

end

	test "should NOT update without login" do
		package = Factory(:package, :tracking_number => '077973360403984')
		assert_nil package.status
		put :update, :id => package.id
		assert_nil package.reload.status
		assert_redirected_to_login
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
