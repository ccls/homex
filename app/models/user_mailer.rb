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

	def deliver_with_timestamp!(mail=@mail)
		returned_mail = deliver_without_timestamp!(mail)
		if self.action_name == 'invitation'
			self.parameters.first.update_attribute(:sent_at, Time.now)
		end
		returned_mail
	end
	alias_method_chain :deliver!, :timestamp

	def initialize_with_memory(method_name=nil, *parameters)
		self.parameters = parameters
		initialize_without_memory(method_name,*parameters)
	end
	alias_method_chain :initialize, :memory

	attr_accessor :parameters

end
