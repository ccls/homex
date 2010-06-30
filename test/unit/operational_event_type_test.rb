require File.dirname(__FILE__) + '/../test_helper'

class OperationalEventTypeTest < ActiveSupport::TestCase

	assert_should_act_as_list
	assert_should_have_many(:operational_events)

	test "should create operational_event_type" do
		assert_difference 'OperationalEventType.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require code" do
		assert_no_difference 'OperationalEventType.count' do
			object = create_object(
				:code => nil)
			assert object.errors.on(:code)
		end
	end

	test "should require unique code" do
		oet = create_object
		assert_no_difference 'OperationalEventType.count' do
			object = create_object(
				:code => oet.code)
			assert object.errors.on(:code)
		end
	end

	test "should require description" do
		assert_no_difference 'OperationalEventType.count' do
			object = create_object(
				:description => nil)
			assert object.errors.on(:description)
		end
	end

	test "should require 4 char description" do
		assert_no_difference 'OperationalEventType.count' do
			object = create_object(
				:description => 'Hey')
			assert object.errors.on(:description)
		end
	end

	test "should require unique description" do
		oet = create_object
		assert_no_difference 'OperationalEventType.count' do
			object = create_object(
				:description => oet.description)
			assert object.errors.on(:description)
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:operational_event_type,options)
		record.save
		record
	end

end
