require File.dirname(__FILE__) + '/../test_helper'

class OperationalEventTypeTest < ActiveSupport::TestCase

	test "should create operational_event_type" do
		assert_difference 'OperationalEventType.count' do
			operational_event_type = create_operational_event_type
			assert !operational_event_type.new_record?, "#{operational_event_type.errors.full_messages.to_sentence}"
		end
	end

	test "should require description" do
		assert_no_difference 'OperationalEventType.count' do
			operational_event_type = create_operational_event_type(:description => nil)
			assert operational_event_type.errors.on(:description)
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'OperationalEventType.count' do
			operational_event_type = create_operational_event_type(:description => 'Hey')
			assert operational_event_type.errors.on(:description)
		end
	end

	test "should have many operational_events" do
		operational_event_type = create_operational_event_type
		assert_equal 0, operational_event_type.operational_events.length
		operational_event_type.operational_events << Factory(:operational_event)
		assert_equal 1, operational_event_type.operational_events.length
		operational_event_type.operational_events << Factory(:operational_event)
		assert_equal 2, operational_event_type.reload.operational_events.length
	end

	test "should belong to a study_event" do
		operational_event_type = create_operational_event_type
		assert_nil operational_event_type.study_event
		operational_event_type.study_event = Factory(:study_event)
		assert_not_nil operational_event_type.study_event
	end

	test "should belong to an interview_event" do
		operational_event_type = create_operational_event_type
		assert_nil operational_event_type.interview_event
		operational_event_type.interview_event = Factory(:interview_event)
		assert_not_nil operational_event_type.interview_event
	end

protected

	def create_operational_event_type(options = {})
		record = Factory.build(:operational_event_type,options)
		record.save
		record
	end

end
