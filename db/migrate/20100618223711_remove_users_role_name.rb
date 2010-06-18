class RemoveUsersRoleName < ActiveRecord::Migration
	def self.up
		remove_index  :users, :role_name
		remove_column :users, :role_name
	end

	def self.down
		add_column :users, :role_name, :string
		add_index  :users, :role_name
	end
end
