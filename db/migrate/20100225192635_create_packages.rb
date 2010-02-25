class CreatePackages < ActiveRecord::Migration
	def self.up
		create_table :packages do |t|
#			t.string :carrier, :null => false
			t.string :tracking_number, :null => false
			t.string :status
			t.timestamps
		end
	end

	def self.down
		drop_table :packages
	end
end
