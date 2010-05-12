require File.dirname(__FILE__) + '/../test_helper'

class UserInvitationTest < ActiveSupport::TestCase

	test "should create invitation" do
		assert_difference 'UserInvitation.count' do
			invitation = create_invitation
			assert !invitation.new_record?, 
				"#{invitation.errors.full_messages.to_sentence}"
		end
	end

	test "should generate token before create" do
		invitation = Factory.build(:user_invitation)
		assert_nil invitation.token
		invitation.save
		assert_not_nil invitation.token
	end

	test "should generate unique token before create" do
		i = create_invitation
		assert_difference( 'UserInvitation.count', 0 ) do
			invitation = create_invitation(:token => i.token)
			assert invitation.errors.on(:token)
		end
	end

	test "should require sender_id" do
		assert_no_difference 'UserInvitation.count' do
			invitation = create_invitation(:sender_id => nil)
			assert invitation.errors.on(:sender_id)
		end
	end

	test "should require email" do
		assert_no_difference 'UserInvitation.count' do
			invitation = create_invitation(:email => nil)
			assert invitation.errors.on(:email)
		end
	end

	test "should require properly formated email address" do
		pending
	end

	test "should belong to a sender" do
		invitation = create_invitation
		assert_not_nil invitation.sender
		assert invitation.sender.is_a?(User)
	end

	test "should send email after create" do
		pending
	end

	test "should be findable by email and token" do
		pending
	end

	test "should expire?" do
		pending
	end

	test "should be usable once and only once" do
		pending
	end

	test "should belong to a recipient after used" do
		pending
	end

	test "should accept a message" do
		pending
	end

protected

	def create_invitation(options={})
		record = Factory.build(:user_invitation,options)
		record.save
		record
	end

end
