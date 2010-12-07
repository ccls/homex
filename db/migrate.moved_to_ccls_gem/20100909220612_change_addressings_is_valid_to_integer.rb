class ChangeAddressingsIsValidToInteger < ActiveRecord::Migration
	def self.up
		change_column :addressings, :is_valid, :integer
	end

	def self.down
		change_column :addressings, :is_valid, :boolean
	end
end
