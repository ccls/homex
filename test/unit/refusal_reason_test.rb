require File.dirname(__FILE__) + '/../test_helper'

class RefusalReasonTest < ActiveSupport::TestCase

#	Only IF subject not consented
#	assert_should_have_many(:enrollments)

	assert_should_create_default_object
	assert_should_act_as_list
	assert_should_require_attributes(:code,:description)
	assert_should_require_unique_attributes(:code,:description)
	assert_should_not_require_attributes(:position)


	test "should require 4 char description" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:description => 'Hey')
			assert object.errors.on(:description)
		end
	end

	test "should return description as to_s" do
		object = create_object
		assert_equal object.description, "#{object}"
	end

	test "should find by code with ['string']" do
		object = RefusalReason['busy']
		assert object.is_a?(RefusalReason)
	end

	test "should find by code with [:symbol]" do
		object = RefusalReason[:busy]
		assert object.is_a?(RefusalReason)
	end

	test "should find random" do
		object = RefusalReason.random()
		assert object.is_a?(RefusalReason)
	end

	test "should return nil on random when no records" do
#		RefusalReason.destroy_all
		RefusalReason.stubs(:count).returns(0)
		object = RefusalReason.random()
		assert_nil object
	end

#	test "should raise error if not found by code with []" do
#		assert_raise(RefusalReason::NotFound) {
#			object = RefusalReason['idonotexist']
#		}
#	end

end
