require File.dirname(__FILE__) + '/../test_helper'

class SurveyInvitationTest < ActiveSupport::TestCase

	test "should create survey_invitation" do
		assert_difference( 'SurveyInvitation.count', 1) do
			survey_invitation = create_survey_invitation
			assert !survey_invitation.new_record?, 
				"#{survey_invitation.errors.full_messages.to_sentence}"
		end
	end

	test "should require subject_id" do
		assert_no_difference 'SurveyInvitation.count' do
			survey_invitation = create_survey_invitation(:subject_id => nil)
			assert survey_invitation.errors.on(:subject_id)
		end
	end

	test "should require token" do
		SurveyInvitation.any_instance.stubs(:create_token).returns(true)
		assert_no_difference 'SurveyInvitation.count' do
			survey_invitation = create_survey_invitation
			assert survey_invitation.errors.on(:token)
		end
	end

	test "should require response_set_id on update" do
		assert_difference 'SurveyInvitation.count', 1 do
			survey_invitation = create_survey_invitation
			survey_invitation.reload.update_attributes(:created_at => Time.now)
			assert survey_invitation.errors.on(:response_set_id)
		end
	end

	test "should create new invitation" do
		survey_invitation = create_survey_invitation
		subject = survey_invitation.subject
		before_id = subject.survey_invitation.id
		assert_difference('SurveyInvitation.count', 0) do
			subject.recreate_survey_invitation
		end
		after_id = subject.reload.survey_invitation.id
		assert_not_equal before_id, after_id
	end

	test "should belong to subject" do
		survey_invitation = create_survey_invitation
#		assert_nil survey_invitation.subject
#		survey_invitation.subject = Factory(:subject)
		assert_not_nil survey_invitation.subject
	end

	test "should belong to response_set" do
		survey_invitation = create_survey_invitation
		assert_nil survey_invitation.response_set
		survey_invitation.response_set = Factory(:response_set)
		assert_not_nil survey_invitation.response_set
	end


protected

	def create_survey_invitation(options = {})
		record = Factory.build(:survey_invitation,options)
		record.save
		record
	end

end
