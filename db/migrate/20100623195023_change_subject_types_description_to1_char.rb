class ChangeSubjectTypesDescriptionTo1Char < ActiveRecord::Migration
	def self.up
		change_column :subject_types, :description, :string, :limit => 1
	end

	def self.down
		change_column :subject_types, :description, :string
	end
end
