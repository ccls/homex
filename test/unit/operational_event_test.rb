require File.dirname(__FILE__) + '/../test_helper'

class OperationalEventTest < ActiveSupport::TestCase

	assert_should_act_as_list

	assert_requires_valid_associations(:operational_event_type,:subject)

	test "should create operational_event" do
		assert_difference 'OperationalEvent.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should initially belong to an operational_event_type" do
		object = create_object
		assert_not_nil object.operational_event_type
	end

	test "should initially belong to a subject" do
		object = create_object
		assert_not_nil object.subject
	end

protected

	def create_object(options = {})
		record = Factory.build(:operational_event,options)
		record.save
		record
	end

end
