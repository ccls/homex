require File.dirname(__FILE__) + '/../test_helper'

class ContactsControllerTest < ActionController::TestCase

%w( superuser admin editor ).each do |cu|

	test "should get contacts with #{cu} login" do
		subject = Factory(:subject)
		login_as send(cu)
		get :index, :subject_id => subject.id
		assert assigns(:subject)
		assert_response :success
		assert_template 'index'
	end

	test "should NOT get contacts without subject_id and #{cu} login" do
		login_as send(cu)
		assert_raise(ActionController::RoutingError){
			get :index
		}
	end

	test "should NOT get contacts with invalid subject_id and #{cu} login" do
		login_as send(cu)
		get :index, :subject_id => 0
		assert_not_nil flash[:error]
		assert_redirected_to subjects_path
	end

end


%w( interviewer reader active_user ).each do |cu|

	test "should NOT get contacts with #{cu} login" do
		subject = Factory(:subject)
		login_as send(cu)
		get :index, :subject_id => subject.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

end

	test "should NOT get contacts without login" do
		subject = Factory(:subject)
		get :index, :subject_id => subject.id
		assert_redirected_to_login
	end

end
