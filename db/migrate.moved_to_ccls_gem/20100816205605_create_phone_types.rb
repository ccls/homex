class CreatePhoneTypes < ActiveRecord::Migration
	def self.up
		create_table :phone_types do |t|
			t.integer :position
			t.string  :code, :null => false
			t.string  :description
			t.timestamps
		end
		add_index :phone_types, :code, :unique => true
	end

	def self.down
		drop_table :phone_types
	end
end
