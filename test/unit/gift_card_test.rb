require File.dirname(__FILE__) + '/../test_helper'

class GiftCardTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_belong_to(:subject,:project)
	assert_should_require_attributes(:gift_card_number)
	assert_should_require_unique_attributes(:gift_card_number)
	assert_should_not_require_attributes(
		:subject_id,
		:project_id,
		:gift_card_issued_on,
		:gift_card_expiration,
		:gift_card_type
	)

end
