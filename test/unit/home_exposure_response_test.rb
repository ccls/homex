require File.dirname(__FILE__) + '/../test_helper'

class HomeExposureResponseTest < ActiveSupport::TestCase

	assert_requires_valid_associations(:subject)
	assert_should_initially_belong_to(:subject)

	test "should create home_exposure_response" do
		assert_difference 'HomeExposureResponse.count' do
			home_exposure_response = create_home_exposure_response
			assert !home_exposure_response.new_record?, 
				"#{home_exposure_response.errors.full_messages.to_sentence}"
		end
	end

	test "should require unique subject_id" do
		subject = Factory(:subject)
		create_home_exposure_response(:subject => subject)
		assert_difference( 'HomeExposureResponse.count', 0 ) do
			home_exposure_response = create_home_exposure_response(
				:subject => subject)
			assert home_exposure_response.errors.on(:subject_id)
		end
	end

protected

	def create_home_exposure_response(options = {})
		record = Factory.build(:home_exposure_response,options)
		record.save
		record
	end
	alias_method :create_object, :create_home_exposure_response

end
