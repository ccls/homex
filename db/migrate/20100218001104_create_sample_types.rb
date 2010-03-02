class CreateSampleTypes < ActiveRecord::Migration
	def self.up
		create_table :sample_types do |t|
			t.integer :position
			t.string :description
			t.timestamps
		end
		add_index :sample_types, :description, :unique => true
	end

	def self.down
		drop_table :sample_types
	end
end
