class UserInvitationMailerWorker < BackgrounDRb::MetaWorker
	set_worker_name :user_invitation_mailer_worker

	def create(args = nil)
#		# this method is called, when worker is loaded for the first time
#		send_invitations
#		# time argument is in seconds
#		add_periodic_timer(1800) { send_invitations }
	end

#	def send_invitations
#		puts "Send User Invitations:" << Time.now.to_s
#		UserInvitation.find(:all,:conditions => {
#			:sent_at => nil
#		}).each do |invitation|
#			puts "Sending unsent user invitation to #{invitation.email}"
#
#			UserInvitationMailer.deliver_invitation(invitation)
#
#		end
#	end

end
