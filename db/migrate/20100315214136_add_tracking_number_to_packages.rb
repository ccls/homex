class AddTrackingNumberToPackages < ActiveRecord::Migration
	def self.up
		add_column :packages, :tracking_number, :string
		add_index :packages, :tracking_number, :unique => true
	end

	def self.down
		remove_column :packages, :tracking_number
	end
end
