class CreateUserInvitations < ActiveRecord::Migration
	def self.up
		create_table :user_invitations do |t|
			t.integer  :sender_id
			t.string   :email
			t.string   :token
			t.datetime :accepted_on
			t.integer  :recipient_id
			t.text     :message
			t.timestamps
		end
	end

	def self.down
		drop_table :user_invitations
	end
end
