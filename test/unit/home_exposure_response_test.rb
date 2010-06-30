require File.dirname(__FILE__) + '/../test_helper'

class HomeExposureResponseTest < ActiveSupport::TestCase

	assert_requires_valid_associations(:subject)
	assert_should_initially_belong_to(:subject)

	test "should create home_exposure_response" do
		assert_difference 'HomeExposureResponse.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should require unique subject_id" do
		subject = Factory(:subject)
		create_object(:subject => subject)
		assert_difference( 'HomeExposureResponse.count', 0 ) do
			object = create_object(
				:subject => subject)
			assert object.errors.on(:subject_id)
		end
	end

protected

	def create_object(options = {})
		record = Factory.build(:home_exposure_response,options)
		record.save
		record
	end

end
