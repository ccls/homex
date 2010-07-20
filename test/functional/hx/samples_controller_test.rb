require File.dirname(__FILE__) + '/../../test_helper'

class Hx::SamplesControllerTest < ActionController::TestCase

#	TODO

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Sample',
#		:actions => [:new,:create,:edit,:update,:show,:destroy,:index],
		:actions => [:edit,:update,:show,:destroy],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :factory_create
	}

#	NESTED ROUTE

	def factory_attributes
		# No attributes from Factory yet
		Factory.attributes_for(:sample,:updated_at => Time.now)
	end
	def factory_create
		Factory(:sample)
	end

	assert_access_with_login({ 
		:logins => [:admin] })
	assert_no_access_with_login({
		:logins => [:employee,:editor,:moderator,:active_user] })
	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:actions => nil,
		:suffix => " and invalid id",
		:login => :admin,
		:redirect => :hx_subjects_path,
		:edit => { :id => 0 },
		:update => { :id => 0 },
		:show => { :id => 0 },
		:destroy => { :id => 0 }
	) 

end
