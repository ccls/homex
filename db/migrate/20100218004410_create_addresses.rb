class CreateAddresses < ActiveRecord::Migration
	def self.up
		create_table :addresses do |t|
			t.integer :position
			t.references :subject
			t.references :address_type
			t.references :data_source
			t.string :line_1
			t.string :line_2
			t.string :city
			t.string :state
			t.string :zip
			t.integer :external_address_id
			t.timestamps
		end
		add_index :addresses, :subject_id
	end

	def self.down
		drop_table :addresses
	end
end
