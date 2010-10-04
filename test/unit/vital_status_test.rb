require File.dirname(__FILE__) + '/../test_helper'

class VitalStatusTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_have_many(:subjects)
	assert_should_require(:code,:description)
	assert_should_require_unique(:code)	#,:description)

	test "should create vital_status" do
		assert_difference( "#{model_name}.count", 1 ) do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require 4 char description" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(
				:description => 'Hey')
			assert object.errors.on(:description)
		end
	end

	test "should return description as to_s" do
		object = create_object
		assert_equal object.description, "#{object}"
	end

#	test "should find by code with ['string']" do
#		object = VitalStatus['living']
#		assert object.is_a?(VitalStatus)
#	end
#
#	test "should find by code with [:symbol]" do
#		object = VitalStatus[:living]
#		assert object.is_a?(VitalStatus)
#	end
#
#	test "should raise error if not found by code with []" do
#		assert_raise(VitalStatus::NotFound) {
#			object = VitalStatus['idonotexist']
#		}
#	end

end
