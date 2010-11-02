require File.dirname(__FILE__) + '/../test_helper'

class TransferTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_requires_valid_associations(:aliquot)
	assert_requires_valid_associations(:organization,
		:as => :from_organization)
	assert_requires_valid_associations(:organization,
		:as => :to_organization)
	assert_should_initially_belong_to(:aliquot)
	assert_should_initially_belong_to(:to_organization,
		:class_name => 'Organization')
	assert_should_initially_belong_to(:from_organization,
		:class_name => 'Organization')

	assert_should_require_attributes(
		:aliquot_id,
		:from_organization_id,
		:to_organization_id )
	assert_should_not_require_attributes(
		:position,
		:amount,
		:reason,
		:is_permanent )
	assert_should_require_attribute_length(
		:reason, :maximum => 250 )

end
