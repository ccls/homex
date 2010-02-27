class CreateTransfers < ActiveRecord::Migration
	def self.up
		create_table :transfers do |t|
			t.references :aliquot
			t.integer :from_organization_id, :null => false
			t.integer :to_organization_id, :null => false
			t.decimal :amount
			t.string :reason
			t.boolean :is_permanent

			t.timestamps
		end
	end

	def self.down
		drop_table :transfers
	end
end
