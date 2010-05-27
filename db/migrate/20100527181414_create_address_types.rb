class CreateAddressTypes < ActiveRecord::Migration
	def self.up
		create_table :address_types do |t|
			t.integer :position, :default => 0, :null => false
			t.string :code, :null => false
			t.string :description
			t.timestamps
		end
	end

	def self.down
		drop_table :address_types
	end
end
