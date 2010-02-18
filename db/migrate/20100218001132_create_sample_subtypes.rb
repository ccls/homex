class CreateSampleSubtypes < ActiveRecord::Migration
	def self.up
		create_table :sample_subtypes do |t|
#			t.integer :sample_type_id
			t.references :sample_type
			t.string :description
			t.timestamps
		end
	end

	def self.down
		drop_table :sample_subtypes
	end
end
