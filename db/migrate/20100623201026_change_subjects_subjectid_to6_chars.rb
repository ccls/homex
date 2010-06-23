class ChangeSubjectsSubjectidTo6Chars < ActiveRecord::Migration
	def self.up
		change_column :subjects, :subjectid, :string, :limit => 6
	end

	def self.down
		change_column :subjects, :subjectid, :string
	end
end
