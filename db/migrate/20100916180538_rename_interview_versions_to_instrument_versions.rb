class RenameInterviewVersionsToInstrumentVersions < ActiveRecord::Migration
	def self.up
		rename_table :interview_versions, :instrument_versions
	end

	def self.down
		rename_table :instrument_versions, :interview_versions
	end
end
