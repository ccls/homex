class CreateRaces < ActiveRecord::Migration
	def self.up
		create_table :races do |t|
			t.integer :position
			t.string :name
			t.timestamps
		end
		add_index :races, :name, :unique => true
	end

	def self.down
		drop_table :races
	end
end
