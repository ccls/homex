require File.dirname(__FILE__) + '/../test_helper'

class OperationalEventTest < ActiveSupport::TestCase

	assert_should_act_as_list
#	assert_should_initially_belong_to(:operational_event_type,:subject)
#	assert_requires_valid_associations(:operational_event_type,:subject)
	assert_should_belong_to(:enrollment)
#	assert_requires_valid_associations(:operational_event_type)
	assert_should_initially_belong_to(:operational_event_type)
	assert_requires_valid_associations(:operational_event_type)

	test "should create operational_event" do
		assert_difference 'OperationalEvent.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:operational_event,options)
		record.save
		record
	end

end
