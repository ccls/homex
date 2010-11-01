require File.dirname(__FILE__) + '/../test_helper'

class AliquotSampleFormatTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_require_attributes(:code,:description)
	assert_should_require_unique_attributes(:code,:description)
	assert_should_require_attribute_length(:description, :minimum => 4)
	assert_should_not_require_attributes(:position)
	assert_should_act_as_list
	assert_should_have_many(:aliquots,:samples)

end
