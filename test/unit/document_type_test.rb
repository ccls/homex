require File.dirname(__FILE__) + '/../test_helper'

class DocumentTypeTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:document_versions)
	assert_should_not_require_attributes( :position )
	assert_should_not_require_attributes( :title )
	assert_should_not_require_attributes( :description )
	assert_should_require_attribute_length( :title,       :maximum => 250 )
	assert_should_require_attribute_length( :description, :maximum => 250 )

end
