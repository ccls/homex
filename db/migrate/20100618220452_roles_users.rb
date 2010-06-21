class RolesUsers < ActiveRecord::Migration
	def self.up
		create_table :roles_users, :id => false do |t|
			t.references :role
			t.references :user
		end
		add_index :roles_users, :role_id
		add_index :roles_users, :user_id
	end

	def self.down
		drop_table :roles_users
	end
end
