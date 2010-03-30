require File.dirname(__FILE__) + '/../test_helper'

class HomeExposureResponseTest < ActiveSupport::TestCase

	test "should create home_exposure_response" do
		assert_difference 'HomeExposureResponse.count' do
			home_exposure_response = create_home_exposure_response
			assert !home_exposure_response.new_record?, 
				"#{home_exposure_response.errors.full_messages.to_sentence}"
		end
	end

	test "should belong to subject" do
		home_exposure_response = create_home_exposure_response
		assert_nil home_exposure_response.subject
		home_exposure_response.subject = Factory(:subject)
		assert_not_nil home_exposure_response.subject
	end

#	test "should require description" do
#		assert_no_difference 'HomeExposureResponse.count' do
#			home_exposure_response = create_home_exposure_response(:description => nil)
#			assert home_exposure_response.errors.on(:description)
#		end
#	end
#
#	test "should require 4 char description" do
#		assert_no_difference 'HomeExposureResponse.count' do
#			home_exposure_response = create_home_exposure_response(:description => 'Hey')
#			assert home_exposure_response.errors.on(:description)
#		end
#	end
#
#	test "should require unique description" do
#		u = create_home_exposure_response
#		assert_no_difference 'HomeExposureResponse.count' do
#			home_exposure_response = create_home_exposure_response(:description => u.description)
#			assert home_exposure_response.errors.on(:description)
#		end
#	end
#
#	test "should belong to a context" do
#		home_exposure_response = create_home_exposure_response
#		assert_nil home_exposure_response.context
#		home_exposure_response.context = Factory(:context)
#		assert_not_nil home_exposure_response.context
#	end
#
#	test "should have many samples" do
#		home_exposure_response = create_home_exposure_response
#		assert_equal 0, home_exposure_response.samples.length
#		Factory(:sample, :home_exposure_questionnaire_id => home_exposure_response.id)
#		assert_equal 1, home_exposure_response.reload.samples.length
#		Factory(:sample, :home_exposure_questionnaire_id => home_exposure_response.id)
#		assert_equal 2, home_exposure_response.reload.samples.length
#	end

protected

	def create_home_exposure_response(options = {})
		record = Factory.build(:home_exposure_response,options)
		record.save
		record
	end

end
