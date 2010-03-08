require File.dirname(__FILE__) + '/../test_helper'

class PagesControllerTest < ActionController::TestCase

#
#		index/new/create/edit/update/destroy 
#			should only be visible to admins for editing
#	

	test "should get index with admin login" do
		login_as admin_user
		get :index
		assert_template 'index'
		assert_response :success
		assert_not_nil assigns(:pages)
	end

	test "should NOT get index without admin login" do
		login_as active_user
		get :index
	end

	test "should NOT get index without login" do
#		CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(false)
		get :index
		assert_redirected_to_cas_login
	end



	test "should NOT get new without login" do
#		CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(false)
		get :new
		assert_redirected_to_cas_login
	end

	test "should get new with admin login" do
		login_as admin_user
		get :new
		assert_template 'new'
		assert_response :success
	end

	test "should NOT get new without admin login" do
		login_as active_user
		get :new
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end








	test "should NOT create without login" do
#		CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(false)
		assert_no_difference( 'Page.count' ) do
			post :create, :page => Factory.attributes_for(:page)
		end
		assert_redirected_to_cas_login
	end

	test "should create page with admin login" do
		login_as admin_user
		assert_difference('Page.count') do
			post :create, :page => Factory.attributes_for(:page)
		end
		assert_redirected_to page_path(assigns(:page))
	end

	test "should NOT create page with invalid page" do
		login_as admin_user
		assert_no_difference('Page.count') do
			post :create, :page => {}
		end
		assert_template 'new'
		assert_response :success
	end

	test "should NOT create page without admin login" do
		login_as active_user
		assert_no_difference('Page.count') do
			post :create, :page => Factory.attributes_for(:page)
		end
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end















	test "should NOT get edit without login" do
#		CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(false)
		get :edit, :id => Factory(:page).id
		assert_redirected_to_cas_login
	end

	test "should get edit with admin login" do
		login_as admin_user
		get :edit, :id => Factory(:page).id
		assert_template 'edit'
		assert_response :success
	end

	test "should NOT get edit with invalid id" do
		login_as admin_user
		get :edit, :id => 0
		assert_not_nil flash[:error]
		assert_redirected_to pages_path
	end

	test "should NOT get edit without admin login" do
		login_as active_user
		get :edit, :id => Factory(:page).id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end











	test "should NOT update without login" do
#		CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(false)
		put :update, :id => Factory(:page).id, :page => Factory.attributes_for(:page)
		assert_redirected_to_cas_login
	end

	test "should update page with admin login" do
		login_as admin_user
		put :update, :id => Factory(:page).id, :page => Factory.attributes_for(:page)
		assert_redirected_to page_path(assigns(:page))
	end

	test "should NOT update page with invalid page" do
		login_as admin_user
		put :update, :id => Factory(:page).id, :page => { :title => "a" }
		assert_not_nil flash[:error]
		assert_template 'edit'
		assert_response :success
	end

	test "should NOT update page with invalid id" do
		login_as admin_user
		put :update, :id => 0, :page => { :title => "a" }
		assert_not_nil flash[:error]
		assert_redirected_to pages_path
	end

	test "should NOT update page without admin login" do
		login_as active_user
		put :update, :id => Factory(:page).id, :page => Factory.attributes_for(:page)
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end















	test "should NOT destroy without login" do
		page = Factory(:page)
#		CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(false)
		assert_no_difference( 'Page.count' ) do
			delete :destroy, :id => page.id
		end
		assert_redirected_to_cas_login
	end

	test "should destroy page with admin login" do
		login_as admin_user
		page = Factory(:page)
		assert_difference('Page.count', -1) do
			delete :destroy, :id => page.id
		end
		assert_redirected_to pages_path
	end

	test "should NOT destroy page without admin login" do
		login_as active_user
		page = Factory(:page)
		assert_no_difference('Page.count') do
			delete :destroy, :id => page.id
		end
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT destroy page with invalid id" do
		login_as admin_user
		page = Factory(:page)
		assert_no_difference('Page.count') do
			delete :destroy, :id => 0
		end
		assert_not_nil flash[:error]
		assert_redirected_to pages_path
	end








#
#	/pages/:id should be visible to anyone ?
#
#	as the pages controller uses the gateway filter, not being logged in currently
#	requires the addition of the line ...
#		CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(false)
#


	test "should NOT show page with invalid id" do
		CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(false)
		get :show, :id => 0
		assert_not_nil flash[:error]
		assert_template 'show'
		assert_response :success
	end

	test "should show page without login" do
		CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(false)
		page = Factory(:page)
		get :show, :id => page.id
		assert_template 'show'
		assert_response :success
		assert_select 'title', page.title
	end

	test "should show page with login" do
		login_as active_user
		page = Factory(:page)
		get :show, :id => page.id
		assert_template 'show'
		assert_response :success
		assert_select 'title', page.title
	end

	#	test admin so that any special admin view code is tested
	test "should show page with admin login" do		
		login_as admin_user
		page = Factory(:page)
		get :show, :id => page.id
		assert_template 'show'
		assert_response :success
		assert_select 'title', page.title
	end

	test "should NOT show page without matching path" do
		CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(false)
		get :show, :path => "/i/do/not/exist".split('/').delete_if{|x|x.blank?}
		assert_not_nil flash[:error]
		assert_template 'show'
		assert_response :success
	end

	test "should show page by path" do
		CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(false)
		page = Factory(:page)
		get :show, :path => page.path.split('/').delete_if{|x|x.blank?}
		assert_equal assigns(:page), page
		assert_template 'show'
		assert_response :success
		assert_select 'title', page.title
	end

	test "should show page by path with slashes" do
		CASClient::Frameworks::Rails::GatewayFilter.stubs(:filter).returns(false)
		page = Factory(:page, :path => "/help/blogs")
		get :show, :path => page.path.split('/').delete_if{|x|x.blank?}
		assert_equal assigns(:page), page
		assert_template 'show'
		assert_response :success
		assert_select 'title', page.title
	end






	test "should get index with both help and non-help pages" do
		#	test css menus
		login_as admin_user
		nonhelp_page = Factory(:page, :path => "/hello" )
		help_page = Factory(:page, :path => "/help/test" )
		get :index
		assert_response :success
		assert_template 'index'
	end

#	action: order

	test "should order pages with admin login" do
		login_as admin_user
		pages = 3.times.collect{|i| Factory(:page) }
		assert_equal [1,2,3], pages.collect(&:position)
		before_page_ids = Page.all.collect(&:id)
		post :order, :pages => before_page_ids.reverse
		after_page_ids = Page.all.collect(&:id)
		assert_equal after_page_ids, before_page_ids.reverse
		assert_redirected_to pages_path
	end

	test "should NOT order pages without admin login" do
		login_as active_user
		pages = 3.times.collect{|i| Factory(:page) }
		assert_equal [1,2,3], pages.collect(&:position)
		before_page_ids = Page.all.collect(&:id)
		post :order, :pages => before_page_ids.reverse
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT order pages without login" do
		pages = 3.times.collect{|i| Factory(:page) }
		assert_equal [1,2,3], pages.collect(&:position)
		before_page_ids = Page.all.collect(&:id)
		post :order, :pages => before_page_ids.reverse
		assert_redirected_to_cas_login
	end

end
