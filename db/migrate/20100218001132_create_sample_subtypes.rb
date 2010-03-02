class CreateSampleSubtypes < ActiveRecord::Migration
	def self.up
		create_table :sample_subtypes do |t|
			t.integer :position
#			t.integer :sample_type_id
			t.references :sample_type
			t.string :description
			t.timestamps
		end
		add_index :sample_subtypes, :description, :unique => true
	end

	def self.down
		drop_table :sample_subtypes
	end
end
