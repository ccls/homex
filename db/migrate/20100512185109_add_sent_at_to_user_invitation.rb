class AddSentAtToUserInvitation < ActiveRecord::Migration
	def self.up
		add_column :user_invitations, :sent_at, :datetime
	end

	def self.down
		remove_column :user_invitations, :sent_at
	end
end
