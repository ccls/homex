require File.dirname(__FILE__) + '/../test_helper'

class OperationalEventTest < ActiveSupport::TestCase

	test "should create operational_event" do
		assert_difference 'OperationalEvent.count' do
			operational_event = create_operational_event
			assert !operational_event.new_record?, "#{operational_event.errors.full_messages.to_sentence}"
		end
	end

protected

	def create_operational_event(options = {})
		record = Factory.build(:operational_event,options)
		record.save
		record
	end

end
