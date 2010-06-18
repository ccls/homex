require File.dirname(__FILE__) + '/../test_helper'

class PermissionsControllerTest < ActionController::TestCase

	assert_access_with_login       :index,{ :login => :admin }
	assert_no_access_with_login    :index,{ :logins => [:editor,:employee,:user] }
	assert_no_access_without_login :index

	assert_access_with_https :index
	assert_no_access_with_http :index

end
