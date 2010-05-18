class AddMotherMaidenNameToPii < ActiveRecord::Migration
	def self.up
		add_column :piis, :mother_maiden_name, :string
	end

	def self.down
		remove_column :piis, :mother_maiden_name
	end
end
