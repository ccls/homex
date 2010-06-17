require File.dirname(__FILE__) + '/../test_helper'

class CalendarsControllerTest < ActionController::TestCase

	assert_access_with_login       :show, { :login => :admin }
	assert_access_with_login       :show, { :login => :employee }
	assert_access_with_login       :show, { :login => :editor }
	assert_no_access_with_login    :show, { :login => :active_user }
	assert_no_access_without_login :show

	assert_access_with_https   :show
	assert_no_access_with_http :show

end
