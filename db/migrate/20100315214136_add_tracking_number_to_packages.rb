class AddTrackingNumberToPackages < ActiveRecord::Migration
	def self.up
		add_column :packages, :tracking_number, :string
	end

	def self.down
		remove_column :packages, :tracking_number
	end
end
