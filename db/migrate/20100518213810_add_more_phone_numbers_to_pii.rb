class AddMorePhoneNumbersToPii < ActiveRecord::Migration
	def self.up
		add_column :piis, :phone_alternate_2, :string
		add_column :piis, :phone_alternate_3, :string
	end

	def self.down
		remove_column :piis, :phone_alternate_3
		remove_column :piis, :phone_alternate_2
	end
end
