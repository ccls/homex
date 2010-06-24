class AddStudyidToPiis < ActiveRecord::Migration
	def self.up
		add_column :piis, :studyid, :string
	end

	def self.down
		remove_column :piis, :studyid
	end
end
