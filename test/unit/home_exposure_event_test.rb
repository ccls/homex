require File.dirname(__FILE__) + '/../test_helper'

class HomeExposureEventTest < ActiveSupport::TestCase

	assert_should_belong_to(:subject)

	test "should create home_exposure_event" do
		assert_difference 'HomeExposureEvent.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:home_exposure_event,options)
		record.save
		record
	end

end
