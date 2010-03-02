class CreateAliquotSampleFormats < ActiveRecord::Migration
	def self.up
		create_table :aliquot_sample_formats do |t|
			t.integer :position
			t.string :description
			t.timestamps
		end
		add_index :aliquot_sample_formats, :description, :unique => true
	end

	def self.down
		drop_table :aliquot_sample_formats
	end
end
