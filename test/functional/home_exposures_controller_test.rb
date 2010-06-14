require File.dirname(__FILE__) + '/../test_helper'

class HomeExposuresControllerTest < ActionController::TestCase

	assert_access_with_login [:show],{
		:login => :admin}

	assert_access_with_login [:show],{
		:login => :employee}

	assert_no_access_with_login [:show],{
		:login => :active_user}

	assert_no_access_without_login [:show]

end
