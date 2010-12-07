class ChangeHomexOutcomeInterviewOutcomeOnToDate < ActiveRecord::Migration
	def self.up
		change_column :homex_outcomes, :interview_outcome_on, :date
	end

	def self.down
		change_column :homex_outcomes, :interview_outcome_on, :datetime
	end
end
