require File.dirname(__FILE__) + '/../test_helper'

class UnitTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many( :aliquots )
	assert_should_have_many( :samples )
	assert_should_belong_to( :context )
	assert_should_require_attributes( :code )
	assert_should_require_attributes( :description )
	assert_should_require_unique_attributes( :code )
	assert_should_require_unique_attributes( :description )
	assert_should_not_require_attributes( :position )
	assert_should_not_require_attributes( :context_id )
	assert_should_require_attribute_length( :description, :maximum => 250, :minimum => 4)
	assert_should_require_attribute_length( :code,        :maximum => 250 )

end
