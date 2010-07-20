require File.dirname(__FILE__) + '/../test_helper'

class PackagesControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Package',
		:actions => [:new,:create,:show,:destroy,:index],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :factory_create
	}

	def factory_attributes(options={})
		Factory.attributes_for(:package,options)
	end
	def factory_create(options={})
		Factory(:package,options)
	end

	assert_access_with_login({    
		:logins => [:admin,:employee,:editor] })
	assert_no_access_with_login({ 
		:logins => [:moderator,:active_user] })
	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:actions => nil,
		:suffix => " and invalid id",
		:login => :admin,
		:redirect => :packages_path,
		:update => { :id => 0 },
		:show => { :id => 0 }, 
		:destroy => { :id => 0 }
	)


%w( admin employee editor ).each do |cu|

	test "delivered packages should NOT have update status link with #{cu} login" do
		factory_create(:status => "Delivered")
		login_as send(cu)
		get :index
		assert_select "div.update" do
			assert_select "a", :count => 0
		end
	end

	test "undelivered packages should have update status link with #{cu} login" do
		factory_create
		login_as send(cu)
		get :index
		assert_select "div.update" do
			assert_select "a", :count => 1
		end
	end

	test "should NOT create with invalid package with #{cu} login" do
		login_as send(cu)
		post :create, :package => {}
		assert_not_nil assigns(:package)
		assert_response :success
		assert_template 'new'
	end

	test "should update with #{cu} login" do
		login_as send(cu)
		package = factory_create(:tracking_number => '077973360403984')
		assert_nil package.status
		put :update, :id => package.id
		assert_not_nil package.reload.status
		assert_redirected_to packages_path
	end

	test "should update and redirect to referer if set with #{cu} login" do
		login_as send(cu)
		package = factory_create
		@request.env["HTTP_REFERER"] = package_path(package)
#	all currently result in the same redirect
#		@request.session[:refer_to] = package_path(package)
#		session[:refer_to] = package_path(package)
		put :update, :id => package.id
		assert_redirected_to package_path(package)
	end

	test "should simulate ship with #{cu} login" do
		login_as send(cu)
		package = factory_create
		assert_not_equal 'Transit', package.reload.status
		put :ship, :id => package.id
		assert_equal 'Transit', package.reload.status
		assert_response :redirect
	end

	test "should simulate delivery with #{cu} login" do
		login_as send(cu)
		package = factory_create
		assert_not_equal 'Delivered', package.reload.status
		put :deliver, :id => package.id
		assert_equal 'Delivered', package.reload.status
		assert_response :redirect
	end

	test "should show tracks for package with #{cu} login" do
		stub_package_for_successful_delivery
		login_as send(cu)
		package = factory_create
		package.update_status
		assert package.tracks.length > 0
		get :show, :id => package.id
		assert_response :success
		assert_template 'show'
		assert_select 'div#tracks' do
			assert_select 'div.track'
		end
	end

end

%w( active_user moderator ).each do |cu|

	test "should NOT update with #{cu} login" do
		login_as send(cu)
		package = factory_create(:tracking_number => '077973360403984')
		assert_nil package.status
		put :update, :id => package.id
		assert_nil package.reload.status
		assert_redirected_to root_path
	end

end

	test "should NOT update without login" do
		package = factory_create(:tracking_number => '077973360403984')
		assert_nil package.status
		put :update, :id => package.id
		assert_nil package.reload.status
		assert_redirected_to_login
	end

end
