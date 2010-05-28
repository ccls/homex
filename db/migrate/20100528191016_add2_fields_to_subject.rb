class Add2FieldsToSubject < ActiveRecord::Migration
	def self.up
		add_column :subjects, :subjectid, :string
		add_column :subjects, :sex, :string
		add_index  :subjects, :subjectid, :unique => true
	end

	def self.down
		remove_index  :subjects, :subjectid
		remove_column :subjects, :subjectid
		remove_column :subjects, :sex
	end
end
