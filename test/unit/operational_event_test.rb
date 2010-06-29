require File.dirname(__FILE__) + '/../test_helper'

class OperationalEventTest < ActiveSupport::TestCase

	test "should create operational_event" do
		assert_difference 'OperationalEvent.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require valid operational_event_type_id" do
		assert_no_difference 'OperationalEvent.count' do
			object = create_object(
				:operational_event_type_id => 0)
			assert object.errors.on(:operational_event_type)
		end
	end

	test "should require valid subject_id" do
		assert_no_difference 'OperationalEvent.count' do
			object = create_object(:subject_id => 0)
			assert object.errors.on(:subject)
		end
	end

	test "should require operational_event_type_id" do
		assert_no_difference 'OperationalEvent.count' do
			object = create_object(
				:operational_event_type_id => nil)
			assert object.errors.on(:operational_event_type)
		end
	end

	test "should require subject_id" do
		assert_no_difference 'OperationalEvent.count' do
			object = create_object(:subject_id => nil)
			assert object.errors.on(:subject)
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

	test "should act as list" do
		object = create_object
		assert_equal 1, object.position
		object = create_object
		assert_equal 2, object.position
	end

protected

	def create_object(options = {})
		record = Factory.build(:operational_event,options)
		record.save
		record
	end

end
