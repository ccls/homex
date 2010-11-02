require File.dirname(__FILE__) + '/../test_helper'

class ProjectOutcomeTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_require_attributes( :code )
	assert_should_require_attributes( :description )
	assert_should_require_unique_attributes( :code )
	assert_should_require_unique_attributes( :description )
	assert_should_not_require_attributes( :position )
	assert_should_not_require_attributes( :project_id )
	assert_should_have_many( :enrollments )
	assert_should_require_attribute_length( :code,        :maximum => 250 )
	assert_should_require_attribute_length( :description, :maximum => 250 )


	test "should return description as to_s" do
		object = create_object
		assert_equal object.description,
			"#{object}"
	end

end
