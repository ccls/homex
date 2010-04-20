class SurveyInvitationMailer < ActionMailer::Base

#
#	No callbacks????
#
#	Would be nice to be able to do something like ...
#
#	before_deliver :ensure_valid_email_address
#

	class NoEmailAddress < StandardError; end

	def invitation(survey_invitation)
		subject    'CCLS Survey Invitation'
		recipients survey_invitation.subject.email
		body       :greeting => 'Hi,'
		body       :invitation => survey_invitation
	end

	def reminder(survey_invitation)
		subject    'CCLS Survey Reminder'
		recipients survey_invitation.subject.email
		body       :greeting => 'Hi,'
		body       :invitation => survey_invitation
	end

	def thank_you(survey_invitation)
		subject    'CCLS Survey Thank You'
		recipients survey_invitation.subject.email
		body       :greeting => 'Hi,'
		body       :invitation => survey_invitation
	end

protected

	#	Simple way of enforcing the presence of a recipient.
	#	This does NOT ensure that it is valid, just not empty.
	def deliver_with_required_email!(mail = @mail)
		raise NoEmailAddress if mail.to.blank?
		deliver_without_required_email!(mail)
	end
	alias_method_chain :deliver!, :required_email

end
