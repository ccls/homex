require File.dirname(__FILE__) + '/../test_helper'

class UserInvitationTest < ActiveSupport::TestCase

	test "should create invitation" do
		assert_difference 'UserInvitation.count' do
			invitation = create_invitation
			assert !invitation.new_record?, 
				"#{invitation.errors.full_messages.to_sentence}"
		end
	end

	test "should generate token before validation" do
		invitation = Factory.build(:user_invitation)
		assert_nil invitation.token
		assert invitation.valid?
		assert_not_nil invitation.token
	end

	test "should generate unique token before create" do
		i = create_invitation
		UserInvitation.any_instance.stubs(:generate_unique_token).returns(true)
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

	test "should be findable by token" do
		ui = UserInvitation.find_by_token('blah blah blah')
		assert_nil ui
		invitation = create_invitation
		ui = UserInvitation.find_by_token(invitation.token)
		assert_not_nil ui
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

	test "should not change token on invitation update" do
		i = create_invitation
		before = i.token
		i.update_attribute(:email, "me@here.com")
		after = i.reload.token
		assert_equal before, after
	end

protected

	def create_invitation(options={})
		record = Factory.build(:user_invitation,options)
		record.save
		record
	end

end
