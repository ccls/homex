require File.dirname(__FILE__) + '/../test_helper'

class HomeExposureResponseTest < ActiveSupport::TestCase

	test "should create home_exposure_response" do
		assert_difference 'HomeExposureResponse.count' do
			home_exposure_response = create_home_exposure_response
			assert !home_exposure_response.new_record?, 
				"#{home_exposure_response.errors.full_messages.to_sentence}"
		end
	end

	test "should require subject_id" do
		assert_difference( 'HomeExposureResponse.count', 0 ) do
			home_exposure_response = create_home_exposure_response(
				:subject => nil)
			assert home_exposure_response.errors.on(:subject_id)
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

	test "should initially belong to subject" do
		home_exposure_response = create_home_exposure_response
		assert_not_nil home_exposure_response.subject
	end

protected

	def create_home_exposure_response(options = {})
		record = Factory.build(:home_exposure_response,options)
		record.save
		record
	end

end
