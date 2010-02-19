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

protected

	def create_operational_event_type(options = {})
		record = Factory.build(:operational_event_type,options)
		record.save
		record
	end

end
