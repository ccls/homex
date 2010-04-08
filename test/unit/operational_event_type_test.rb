require File.dirname(__FILE__) + '/../test_helper'

class OperationalEventTypeTest < ActiveSupport::TestCase

	test "should create operational_event_type" do
		assert_difference 'OperationalEventType.count' do
			operational_event_type = create_operational_event_type
			assert !operational_event_type.new_record?, 
				"#{operational_event_type.errors.full_messages.to_sentence}"
		end
	end

	test "should require description" do
		assert_no_difference 'OperationalEventType.count' do
			operational_event_type = create_operational_event_type(
				:description => nil)
			assert operational_event_type.errors.on(:description)
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'OperationalEventType.count' do
			operational_event_type = create_operational_event_type(
				:description => 'Hey')
			assert operational_event_type.errors.on(:description)
		end
	end

	test "should require unique description" do
		oet = create_operational_event_type
		assert_no_difference 'OperationalEventType.count' do
			operational_event_type = create_operational_event_type(
				:description => oet.description)
			assert operational_event_type.errors.on(:description)
		end
	end

	test "should require study_event_id" do
		assert_no_difference 'OperationalEventType.count' do
			operational_event_type = create_operational_event_type(
				:study_event_id => nil)
			assert operational_event_type.errors.on(:study_event_id)
		end
	end

	test "should require interview_event_id" do
		assert_no_difference 'OperationalEventType.count' do
			operational_event_type = create_operational_event_type(
				:interview_event_id => nil)
			assert operational_event_type.errors.on(:interview_event_id)
		end
	end

	test "should have many operational_events" do
		operational_event_type = create_operational_event_type
		assert_equal 0, operational_event_type.operational_events.length
		Factory(:operational_event, 
				:operational_event_type_id => operational_event_type.id)
		assert_equal 1, operational_event_type.reload.operational_events.length
		Factory(:operational_event, 
				:operational_event_type_id => operational_event_type.id)
		assert_equal 2, operational_event_type.reload.operational_events.length
	end

	test "should initially belong to a study_event" do
		operational_event_type = create_operational_event_type
		assert_not_nil operational_event_type.study_event
	end

	test "should initially belong to an interview_event" do
		operational_event_type = create_operational_event_type
		assert_not_nil operational_event_type.interview_event
	end

protected

	def create_operational_event_type(options = {})
		record = Factory.build(:operational_event_type,options)
		record.save
		record
	end

end
