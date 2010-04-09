class SubjectMailer < ActionMailer::Base

	def invitation(survey_invitation)
		subject    'CCLS Survey Invitation'
		recipients survey_invitation.subject.email
		body       :greeting => 'Hi,'
		body       :invitation => survey_invitation
	end

	def reminder(survey_invitation)
		subject    'SubjectMailer#reminder'
		recipients survey_invitation.subject.email
		body       :greeting => 'Hi,'
		body       :invitation => survey_invitation
	end

	def thank_you(survey_invitation)
		subject    'SubjectMailer#thank_you'
		recipients survey_invitation.subject.email
		body       :greeting => 'Hi,'
		body       :invitation => survey_invitation
	end

end
