class AddDiagnosisIdToPatient < ActiveRecord::Migration
	def self.up
		add_column :patients, :diagnosis_id, :integer
	end

	def self.down
		remove_column :patients, :diagnosis_id
	end
end
