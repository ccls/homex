require File.dirname(__FILE__) + '/../test_helper'

class GuidesControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Guide',
		:actions => [:new,:create,:edit,:update,:show,:index,:destroy],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :factory_create
	}

	def factory_attributes(options={})
		Factory.attributes_for(:guide,options)
	end

	def factory_create(options={})
		Factory(:guide,options)
	end

	assert_access_with_login({ 
		:logins => [:superuser,:admin,:editor] })
	assert_no_access_with_login({ 
		:logins => [:interviewer,:reader,:active_user] })
	assert_no_access_without_login

end
