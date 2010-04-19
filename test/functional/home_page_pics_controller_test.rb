require File.dirname(__FILE__) + '/../test_helper'

class HomePagePicsControllerTest < ActionController::TestCase

	test "should get index with admin login" do
		login_as admin_user
		get :index
		assert_response :success
		assert_not_nil assigns(:home_page_pics)
	end

	test "should get index with employee login" do
		login_as employee
		get :index
		assert_response :success
		assert_not_nil assigns(:home_page_pics)
	end

	test "should NOT get index with just login" do
		login_as active_user
		get :index
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT get index without login" do
		get :index
		assert_redirected_to_cas_login
	end


	test "should get new with admin login" do
		login_as admin_user
		get :new
		assert_response :success
	end

	test "should get new with employee login" do
		login_as employee
		get :new
		assert_response :success
	end

	test "should NOT get new with just login" do
		login_as active_user
		get :new
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT get new without login" do
		get :new
		assert_redirected_to_cas_login
	end


	test "should create home_page_pic with admin login" do
		login_as admin_user
		assert_difference('HomePagePic.count') do
			post :create, :home_page_pic => Factory.attributes_for(:home_page_pic)
		end
		assert_redirected_to home_page_pic_path(assigns(:home_page_pic))
	end

	test "should create home_page_pic with employee login" do
		login_as employee
		assert_difference('HomePagePic.count') do
			post :create, :home_page_pic => Factory.attributes_for(:home_page_pic)
		end
		assert_redirected_to home_page_pic_path(assigns(:home_page_pic))
	end

	test "should NOT create home_page_pic with just login" do
		login_as active_user
		assert_difference('HomePagePic.count',0) do
			post :create, :home_page_pic => Factory.attributes_for(:home_page_pic)
		end
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT create home_page_pic without login" do
		assert_difference('HomePagePic.count',0) do
			post :create, :home_page_pic => Factory.attributes_for(:home_page_pic)
		end
		assert_redirected_to_cas_login
	end

	test "should NOT create home_page_pic without valid HPP" do
		login_as admin_user
		assert_difference('HomePagePic.count',0) do
			post :create, :home_page_pic => { }
		end
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end


	test "should show home_page_pic with admin login" do
		hpp = Factory(:home_page_pic)
		login_as admin_user
		get :show, :id => hpp.id
		assert_response :success
	end

	test "should show home_page_pic with employee login" do
		hpp = Factory(:home_page_pic)
		login_as employee
		get :show, :id => hpp.id
		assert_response :success
	end

	test "should NOT show home_page_pic with just login" do
		hpp = Factory(:home_page_pic)
		login_as active_user
		get :show, :id => hpp.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT show home_page_pic without login" do
		hpp = Factory(:home_page_pic)
		get :show, :id => hpp.id
		assert_redirected_to_cas_login
	end

	test "should NOT show home_page_pic with invalid id" do
		hpp = Factory(:home_page_pic)
		login_as admin_user
		get :show, :id => 0
		assert_not_nil flash[:error]
#		assert_redirected_to root_path
		assert_redirected_to home_page_pics_path
	end


	test "should get edit with admin login" do
		hpp = Factory(:home_page_pic)
		login_as admin_user
		get :edit, :id => hpp.id
		assert_response :success
	end

	test "should get edit with employee login" do
		hpp = Factory(:home_page_pic)
		login_as employee
		get :edit, :id => hpp.id
		assert_response :success
	end

	test "should NOT get edit with just login" do
		hpp = Factory(:home_page_pic)
		login_as active_user
		get :edit, :id => hpp.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT get edit without login" do
		hpp = Factory(:home_page_pic)
		get :edit, :id => hpp.id
		assert_redirected_to_cas_login
	end

	test "should NOT get edit with invalid id" do
		hpp = Factory(:home_page_pic)
		login_as admin_user
		get :edit, :id => 0
		assert_not_nil flash[:error]
#		assert_redirected_to root_path
		assert_redirected_to home_page_pics_path
	end


	test "should update home_page_pic with admin login" do
		hpp = Factory(:home_page_pic)
		login_as admin_user
		put :update, :id => hpp.id,
			:home_page_pic => Factory.attributes_for(:home_page_pic)
		assert_redirected_to home_page_pic_path(assigns(:home_page_pic))
	end

	test "should update home_page_pic with employee login" do
		hpp = Factory(:home_page_pic)
		login_as employee
		put :update, :id => hpp.id,
			:home_page_pic => Factory.attributes_for(:home_page_pic)
		assert_redirected_to home_page_pic_path(assigns(:home_page_pic))
	end

	test "should NOT update home_page_pic with just login" do
		hpp = Factory(:home_page_pic)
		login_as active_user
		put :update, :id => hpp.id,
			:home_page_pic => Factory.attributes_for(:home_page_pic)
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT update home_page_pic without login" do
		hpp = Factory(:home_page_pic)
		put :update, :id => hpp.id,
			:home_page_pic => Factory.attributes_for(:home_page_pic)
		assert_redirected_to_cas_login
	end

	test "should NOT update home_page_pic with invalid id" do
		hpp = Factory(:home_page_pic)
		login_as admin_user
		put :update, :id => 0,
			:home_page_pic => Factory.attributes_for(:home_page_pic)
		assert_not_nil flash[:error]
		assert_redirected_to home_page_pics_path
	end

	test "should NOT update home_page_pic when update fails" do
		hpp = Factory(:home_page_pic)
		HomePagePic.any_instance.stubs(:create_or_update).returns(false)
		login_as admin_user
		put :update, :id => hpp.id,
			:home_page_pic => Factory.attributes_for(:home_page_pic)
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'edit'
	end


	test "should destroy home_page_pic with admin login" do
		login_as admin_user
		hpp = Factory(:home_page_pic)
		assert_difference('HomePagePic.count', -1) do
			delete :destroy, :id => hpp.id
		end
		assert_redirected_to home_page_pics_path
	end

	test "should destroy home_page_pic with employee login" do
		login_as employee
		hpp = Factory(:home_page_pic)
		assert_difference('HomePagePic.count', -1) do
			delete :destroy, :id => hpp.id
		end
		assert_redirected_to home_page_pics_path
	end

	test "should NOT destroy home_page_pic with just login" do
		login_as active_user
		hpp = Factory(:home_page_pic)
		assert_difference('HomePagePic.count', 0) do
			delete :destroy, :id => hpp.id
		end
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT destroy home_page_pic without login" do
		hpp = Factory(:home_page_pic)
		assert_difference('HomePagePic.count', 0) do
			delete :destroy, :id => hpp.id
		end
		assert_redirected_to_cas_login
	end

	test "should NOT destroy home_page_pic with invalid id" do
		login_as admin_user
		hpp = Factory(:home_page_pic)
		assert_difference('HomePagePic.count', 0) do
			delete :destroy, :id => 0
		end
		assert_not_nil flash[:error]
#		assert_redirected_to root_path
		assert_redirected_to home_page_pics_path
	end

#	activate


	test "should activate all with admin login" do
		login_as admin_user
		hpp1 = Factory(:home_page_pic, :active => false)
		hpp2 = Factory(:home_page_pic, :active => false)
		HomePagePic.all.each { |hpp| assert !hpp.active }
		post :activate, :home_page_pics => {
			hpp1.id => { 'active' => true },
			hpp2.id => { 'active' => true }
		}
		HomePagePic.all.each { |hpp| assert hpp.active }
	end

	test "should deactivate all with admin login" do
		login_as admin_user
		hpp1 = Factory(:home_page_pic, :active => true)
		hpp2 = Factory(:home_page_pic, :active => true)
		HomePagePic.all.each { |hpp| assert hpp.active }
		post :activate, :home_page_pics => {
			hpp1.id => { 'active' => false },
			hpp2.id => { 'active' => false }
		}
		HomePagePic.all.each { |hpp| assert !hpp.active }
	end

	test "should activate all with employee login" do
		login_as employee
		hpp1 = Factory(:home_page_pic, :active => false)
		hpp2 = Factory(:home_page_pic, :active => false)
		HomePagePic.all.each { |hpp| assert !hpp.active }
		post :activate, :home_page_pics => {
			hpp1.id => { 'active' => true },
			hpp2.id => { 'active' => true }
		}
		HomePagePic.all.each { |hpp| assert hpp.active }
	end

	test "should NOT activate all with just login" do
		login_as active_user
		hpp1 = Factory(:home_page_pic, :active => false)
		hpp2 = Factory(:home_page_pic, :active => false)
		HomePagePic.all.each { |hpp| assert !hpp.active }
		post :activate, :home_page_pics => {
			hpp1.id => { 'active' => true },
			hpp2.id => { 'active' => true }
		}
		HomePagePic.all.each { |hpp| assert !hpp.active }
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT activate all without login" do
		hpp1 = Factory(:home_page_pic, :active => false)
		hpp2 = Factory(:home_page_pic, :active => false)
		HomePagePic.all.each { |hpp| assert !hpp.active }
		post :activate, :home_page_pics => {
			hpp1.id => { 'active' => true },
			hpp2.id => { 'active' => true }
		}
		HomePagePic.all.each { |hpp| assert !hpp.active }
		assert_redirected_to_cas_login
	end

	test "should NOT activate all when save fails" do
		login_as admin_user
		hpp1 = Factory(:home_page_pic, :active => false)
		hpp2 = Factory(:home_page_pic, :active => false)
		HomePagePic.all.each { |hpp| assert !hpp.active }
#		HomePagePic.any_instance.stubs(:save).returns(false)
		HomePagePic.any_instance.stubs(:create_or_update).returns(false)
		post :activate, :home_page_pics => {
			hpp1.id => { 'active' => true },
			hpp2.id => { 'active' => true }
		}
		HomePagePic.all.each { |hpp| assert !hpp.active }
		assert_redirected_to home_page_pics_path
		assert_not_nil flash[:error]
	end

end
