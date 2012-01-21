require 'test_helper'

class DocumentVersionsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'DocumentVersion',
		:actions => [:new,:edit,:update,:show,:destroy,:index],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_document_version
	}

#
#
#	Skipping create due to requirements
#	Fix me
#
#

	def factory_attributes(options={})
		Factory.attributes_for(:document_version,options)
	end

	assert_access_with_login({ 
		:logins => site_administrators })
	assert_no_access_with_login({ 
		:logins => non_site_administrators })
	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

end
