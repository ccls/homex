require File.dirname(__FILE__) + '/../test_helper'

class HomeExposureEventTest < ActiveSupport::TestCase

	test "should create home_exposure_event" do
		assert_difference 'HomeExposureEvent.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should belong to subject" do
		object = create_object
		assert_nil object.subject
		object.subject = Factory(:subject)
		assert_not_nil object.subject
	end

protected

	def create_object(options = {})
		record = Factory.build(:home_exposure_event,options)
		record.save
		record
	end

end
