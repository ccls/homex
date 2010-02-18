class CreateUnits < ActiveRecord::Migration
	def self.up
		create_table :units do |t|
#			t.integer :context_id
			t.references :context
			t.string :description
			t.timestamps
		end
	end

	def self.down
		drop_table :units
	end
end
