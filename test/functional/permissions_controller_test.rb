require File.dirname(__FILE__) + '/../test_helper'

class PermissionsControllerTest < ActionController::TestCase

	assert_access_with_login [:index],{
		:login => :admin }

	assert_no_access_with_login [:index],{
		:login => :editor }

	assert_no_access_with_login [:index],{
		:login => :employee }

	assert_no_access_with_login [:index],{
		:login => :user }
		
	assert_no_access_without_login [:index]

end
