class CreateSampleSubtypes < ActiveRecord::Migration
	def self.up
		create_table :sample_subtypes do |t|
			t.integer :position
			t.references :sample_type
			t.string :code, :null => false
			t.string :description
			t.timestamps
		end
		add_index :sample_subtypes, :sample_type_id
		add_index :sample_subtypes, :code, :unique => true
		add_index :sample_subtypes, :description, :unique => true
	end

	def self.down
		drop_table :sample_subtypes
	end
end
