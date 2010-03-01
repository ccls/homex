class CreateAliquots < ActiveRecord::Migration
	def self.up
		create_table :aliquots do |t|
			t.references :sample
			t.references :unit
			t.references :aliquot_sample_format
			t.string :location
			t.string :mass
			t.string :owner
			t.string :external_aliquot_id
			t.string :external_aliquot_id_source
			t.timestamps
		end
	end

	def self.down
		drop_table :aliquots
	end
end
