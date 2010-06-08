require File.dirname(__FILE__) + '/../test_helper'

class UserInvitationMailerTest < ActionMailer::TestCase

#	setup :build_stuff
#	def build_stuff
#		@invitation = Factory(:user_invitation)
#	end
#
#	test "should create invitation" do
#		assert_difference('ActionMailer::Base.deliveries.length',0) {
#			mail = UserInvitationMailer.create_invitation(@invitation)
#			assert_match "@example.com", mail.to.first
#		}
#		assert_nil @invitation.sent_at
#	end
#
#	test "should deliver invitation" do
#		assert_difference('ActionMailer::Base.deliveries.length',1) {
#			mail = UserInvitationMailer.deliver_invitation(@invitation)
#			assert_match "@example.com", mail.to.first
#		}
#		assert_not_nil @invitation.sent_at
#	end
#
#	test "should NOT deliver invitation without email" do
#		@invitation.update_attribute(:email, nil)
#		assert_difference('ActionMailer::Base.deliveries.length',0) {
#		assert_raise(UserInvitationMailer::NoEmailAddress){
#			UserInvitationMailer.deliver_invitation(@invitation)
#		} }
#		assert_nil @invitation.sent_at
#	end

end
