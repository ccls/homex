require File.dirname(__FILE__) + '/../test_helper'

class HomeExposureQuestionnaireTest < ActiveSupport::TestCase

	test "should create home_exposure_questionnaire" do
		assert_difference 'HomeExposureQuestionnaire.count' do
			home_exposure_questionnaire = create_home_exposure_questionnaire
			assert !home_exposure_questionnaire.new_record?, 
				"#{home_exposure_questionnaire.errors.full_messages.to_sentence}"
		end
	end

#	test "should require description" do
#		assert_no_difference 'HomeExposureQuestionnaire.count' do
#			home_exposure_questionnaire = create_home_exposure_questionnaire(:description => nil)
#			assert home_exposure_questionnaire.errors.on(:description)
#		end
#	end
#
#	test "should require 4 char description" do
#		assert_no_difference 'HomeExposureQuestionnaire.count' do
#			home_exposure_questionnaire = create_home_exposure_questionnaire(:description => 'Hey')
#			assert home_exposure_questionnaire.errors.on(:description)
#		end
#	end
#
#	test "should require unique description" do
#		u = create_home_exposure_questionnaire
#		assert_no_difference 'HomeExposureQuestionnaire.count' do
#			home_exposure_questionnaire = create_home_exposure_questionnaire(:description => u.description)
#			assert home_exposure_questionnaire.errors.on(:description)
#		end
#	end
#
#	test "should belong to a context" do
#		home_exposure_questionnaire = create_home_exposure_questionnaire
#		assert_nil home_exposure_questionnaire.context
#		home_exposure_questionnaire.context = Factory(:context)
#		assert_not_nil home_exposure_questionnaire.context
#	end
#
#	test "should have many samples" do
#		home_exposure_questionnaire = create_home_exposure_questionnaire
#		assert_equal 0, home_exposure_questionnaire.samples.length
#		Factory(:sample, :home_exposure_questionnaire_id => home_exposure_questionnaire.id)
#		assert_equal 1, home_exposure_questionnaire.reload.samples.length
#		Factory(:sample, :home_exposure_questionnaire_id => home_exposure_questionnaire.id)
#		assert_equal 2, home_exposure_questionnaire.reload.samples.length
#	end

protected

	def create_home_exposure_questionnaire(options = {})
		record = Factory.build(:home_exposure_questionnaire,options)
		record.save
		record
	end

end
