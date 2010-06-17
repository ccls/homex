require File.dirname(__FILE__) + '/../test_helper'

class HomePagePicsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:factory => :home_page_pic
	}

	assert_access_with_login :new,:create,:edit,:update,:show,:destroy,:index,{
		:login => :admin }

	assert_access_with_login :new,:create,:edit,:update,:show,:destroy,:index,{
		:login => :editor }

	assert_no_access_with_login :new,:create,:edit,:update,:show,:destroy,:index,{
		:login => :employee }

	assert_no_access_with_login :new,:create,:edit,:update,:show,:destroy,:index,{
		:login => :active_user }

	assert_no_access_without_login :new,:create,:edit,:update,:show,:destroy,:index


	assert_access_with_https :new,:create,:edit,:update,:show,:destroy,:index

	assert_no_access_with_http :new,:create,:edit,:update,:show,:destroy,:index


	test "should NOT create home_page_pic without valid HPP" do
		login_as admin_user
		assert_difference('HomePagePic.count',0) do
			post :create, :home_page_pic => { }
		end
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should NOT show home_page_pic with invalid id" do
		hpp = Factory(:home_page_pic)
		login_as admin_user
		get :show, :id => 0
		assert_not_nil flash[:error]
#		assert_redirected_to root_path
		assert_redirected_to home_page_pics_path
	end

	test "should NOT get edit with invalid id" do
		hpp = Factory(:home_page_pic)
		login_as admin_user
		get :edit, :id => 0
		assert_not_nil flash[:error]
		assert_redirected_to home_page_pics_path
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

	test "should NOT destroy home_page_pic with invalid id" do
		login_as admin_user
		hpp = Factory(:home_page_pic)
		assert_difference('HomePagePic.count', 0) do
			delete :destroy, :id => 0
		end
		assert_not_nil flash[:error]
		assert_redirected_to home_page_pics_path
	end

#	activate

%w( admin editor ).each do |cu|

	test "should activate all with #{cu} login" do
		login_as send(cu)
		hpp1 = Factory(:home_page_pic, :active => false)
		hpp2 = Factory(:home_page_pic, :active => false)
		HomePagePic.all.each { |hpp| assert !hpp.active }
		post :activate, :home_page_pics => {
			hpp1.id => { 'active' => true },
			hpp2.id => { 'active' => true }
		}
		HomePagePic.all.each { |hpp| assert hpp.active }
	end

	test "should deactivate all with #{cu} login" do
		login_as send(cu)
		hpp1 = Factory(:home_page_pic, :active => true)
		hpp2 = Factory(:home_page_pic, :active => true)
		HomePagePic.all.each { |hpp| assert hpp.active }
		post :activate, :home_page_pics => {
			hpp1.id => { 'active' => false },
			hpp2.id => { 'active' => false }
		}
		HomePagePic.all.each { |hpp| assert !hpp.active }
		assert_redirected_to home_page_pics_path
	end

end

%w( employee active_user ).each do |cu|

	test "should NOT activate all with #{cu} login" do
		login_as send(cu)
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
		assert_redirected_to_login
	end

	test "should NOT activate all when save fails" do
		login_as admin_user
		hpp1 = Factory(:home_page_pic, :active => false)
		hpp2 = Factory(:home_page_pic, :active => false)
		HomePagePic.all.each { |hpp| assert !hpp.active }
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
