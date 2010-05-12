require File.dirname(__FILE__) + '/../test_helper'

class UserMailerTest < ActionMailer::TestCase

	def setup
		@invitation = Factory(:user_invitation)
	end

	test "should create invitation" do
		assert_difference('ActionMailer::Base.deliveries.length',0) {
			mail = UserMailer.create_invitation(@invitation)
			assert_match "@example.com", mail.to.first
		}
	end

	test "should deliver invitation" do
		assert_difference('ActionMailer::Base.deliveries.length',1) {
			mail = UserMailer.deliver_invitation(@invitation)
			assert_match "@example.com", mail.to.first
		}
	end

	test "should NOT deliver invitation without email" do
		@invitation.update_attribute(:email, nil)
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_raise(UserMailer::NoEmailAddress){
			UserMailer.deliver_invitation(@invitation)
		} }
	end

end
