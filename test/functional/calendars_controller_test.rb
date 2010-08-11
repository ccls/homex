require File.dirname(__FILE__) + '/../test_helper'

class CalendarsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = { :actions => [:show] }

	assert_access_with_login({
		:logins => [:superuser,:admin,:reader,:editor] })
	assert_no_access_with_login({
		:logins => [:active_user] })
	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

end
