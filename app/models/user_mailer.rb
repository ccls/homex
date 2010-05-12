class UserMailer < ActionMailer::Base
 
	class NoEmailAddress < StandardError; end

	def invitation(user_invitation)
		subject    'User Invitation'
		recipients user_invitation.email
		body       :greeting => 'Hi,'
		body       :invitation => user_invitation
	end

#	activation / email_confirmation
#	forgot_password / reset_password
#	forgot_username (or just allow login with email address)
#	change_email_confirmation

protected

	#	Simple way of enforcing the presence of a recipient.
	#	This does NOT ensure that it is valid, just not empty.
	def deliver_with_required_email!(mail = @mail)
		raise NoEmailAddress if mail.to.blank?
		deliver_without_required_email!(mail)
	end
	alias_method_chain :deliver!, :required_email

end
