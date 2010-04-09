class SubjectMailer < ActionMailer::Base

	def invitation(sent_at = Time.now)
		subject    'SubjectMailer#invitation'
		recipients ''
		from       ''
		sent_on    sent_at
		
		body       :greeting => 'Hi,'
	end

	def reminder(sent_at = Time.now)
		subject    'SubjectMailer#reminder'
		recipients ''
		from       ''
		sent_on    sent_at
		
		body       :greeting => 'Hi,'
	end

	def thank_you(sent_at = Time.now)
		subject    'SubjectMailer#thank_you'
		recipients ''
		from       ''
		sent_on    sent_at
		
		body       :greeting => 'Hi,'
	end

end
