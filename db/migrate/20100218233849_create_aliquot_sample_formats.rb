class CreateAliquotSampleFormats < ActiveRecord::Migration
	def self.up
		create_table :aliquot_sample_formats do |t|
			t.string :description
			t.timestamps
		end
	end

	def self.down
		drop_table :aliquot_sample_formats
	end
end
