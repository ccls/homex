require File.dirname(__FILE__) + '/../test_helper'

class OperationalEventTypeTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_have_many(:operational_events)
	assert_should_require_attributes(:code,:description)
	assert_should_require_unique_attributes(:code,:description)
	assert_should_not_require_attributes(
		:position,
		:project_id )
	assert_should_require_attribute_length(:description, :minimum => 4)


	test "should return description as to_s" do
		object = create_object
		assert_equal object.description, "#{object}"
	end

	test "should find by code with ['string']" do
		object = OperationalEventType['ineligible']
		assert object.is_a?(OperationalEventType)
	end

	test "should find by code with [:symbol]" do
		object = OperationalEventType[:ineligible]
		assert object.is_a?(OperationalEventType)
	end

#	test "should raise error if not found by code with []" do
#		assert_raise(OperationalEventType::NotFound) {
#			object = OperationalEventType['idonotexist']
#		}
#	end

end
