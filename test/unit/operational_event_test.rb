require File.dirname(__FILE__) + '/../test_helper'

class OperationalEventTest < ActiveSupport::TestCase

	test "should create operational_event" do
		assert_difference 'OperationalEvent.count' do
			operational_event = create_operational_event
			assert !operational_event.new_record?, "#{operational_event.errors.full_messages.to_sentence}"
		end
	end

	test "should require operational_event_type_id" do
		assert_no_difference 'OperationalEvent.count' do
			operational_event = create_operational_event(:operational_event_type_id => nil)
			assert operational_event.errors.on(:operational_event_type_id)
		end
	end

	test "should require subject_id" do
		assert_no_difference 'OperationalEvent.count' do
			operational_event = create_operational_event(:subject_id => nil)
			assert operational_event.errors.on(:subject_id)
		end
	end

	test "should belong to an operational_event_type" do
		operational_event = create_operational_event
#		assert_nil operational_event.operational_event_type
#		operational_event.operational_event_type = Factory(:operational_event_type)
		assert_not_nil operational_event.operational_event_type
	end

	test "should belong to a subject" do
		operational_event = create_operational_event
#		assert_nil operational_event.subject
#		operational_event.subject = Factory(:subject)
		assert_not_nil operational_event.subject
	end

protected

	def create_operational_event(options = {})
		record = Factory.build(:operational_event,options)
		record.save
		record
	end

end
