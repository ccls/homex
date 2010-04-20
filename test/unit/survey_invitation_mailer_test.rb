require File.dirname(__FILE__) + '/../test_helper'

class SurveyInvitationMailerTest < ActionMailer::TestCase

	def setup
		@survey  = Factory(:survey)
		@subject = Factory(:subject, 
			:pii_attributes => Factory.attributes_for(:pii))
		@si      = Factory(:survey_invitation, {
			:survey_id => @survey.id,
			:subject_id => @subject.id
		})
	end

	test "invitation" do
		mail = SurveyInvitationMailer.create_invitation(@si)
		assert_match "@example.com", mail.to.first
	end

	test "reminder" do
		mail = SurveyInvitationMailer.create_reminder(@si)
		assert_match "@example.com", mail.to.first
	end

	test "thank_you" do
		mail = SurveyInvitationMailer.create_thank_you(@si)
		assert_match "@example.com", mail.to.first
	end

end
