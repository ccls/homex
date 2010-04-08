class AddUniqueSubjectIdIndexes < ActiveRecord::Migration
	def self.up
		add_index :piis,               :subject_id, :unique => true
		add_index :patients,           :subject_id, :unique => true
		add_index :child_ids,          :subject_id, :unique => true
	end

	def self.down
		remove_index :piis,               :subject_id
		remove_index :patients,           :subject_id
		remove_index :child_ids,          :subject_id
	end
end
