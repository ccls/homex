class AddSentAtToSurveyInvitation < ActiveRecord::Migration
	def self.up
		add_column :survey_invitations, :sent_at, :datetime
	end

	def self.down
		remove_column :survey_invitations, :sent_at
	end
end
