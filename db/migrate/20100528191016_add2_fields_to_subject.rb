class Add2FieldsToSubject < ActiveRecord::Migration
	def self.up
		add_column :subjects, :subjectid, :string
		add_column :subjects, :sex, :string
	end

	def self.down
		remove_column :subjects, :subjectid, :string
		remove_column :subjects, :sex, :string
	end
end
