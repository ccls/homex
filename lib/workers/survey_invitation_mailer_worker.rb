class SurveyInvitationMailerWorker < BackgrounDRb::MetaWorker
	set_worker_name :survey_invitation_mailer_worker

	def create(args = nil)
    # this method is called, when worker is loaded for the first time
		send_invitations
		# time argument is in seconds
		add_periodic_timer(1800) { send_invitations }
	end

	def send_invitations
		puts "Send Survey Invitations:" << Time.now.to_s
		SurveyInvitation.find(:all,:conditions => {
			:sent_at => nil
		}).each do |invitation|
			puts "Sending unsent survey invitation to #{invitation.email}"



		end
	end

end
