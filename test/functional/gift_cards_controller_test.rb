require 'test_helper'

class GiftCardsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'GiftCard',
		:actions => [:new,:create,:edit,:update,:show,:destroy,:index],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_gift_card
	}
	def factory_attributes(options={})
		Factory.attributes_for(:gift_card,options)
	end

	assert_access_with_login({ 
		:logins => site_administrators })
	assert_no_access_with_login({ 
		:logins => non_site_administrators })
	assert_no_access_without_login

	assert_access_with_https
	assert_no_access_with_http

end
