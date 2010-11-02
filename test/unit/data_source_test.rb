require File.dirname(__FILE__) + '/../test_helper'

class DataSourceTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:addresses)
	assert_should_not_require_attributes( :position )
	assert_should_not_require_attributes( :research_origin )
	assert_should_not_require_attributes( :data_origin )
	assert_should_require_attribute_length( :research_origin, :maximum => 250 )
	assert_should_require_attribute_length( :data_origin,     :maximum => 250 )

end
