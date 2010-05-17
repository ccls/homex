class AddAuthlogicColumnsToUser < ActiveRecord::Migration
	def self.up
		add_column :users, :username,  :string
		add_column :users, :email,  :string
		add_column :users, :crypted_password,  :string
		add_column :users, :password_salt,     :string
		add_column :users, :persistence_token, :string
		add_column :users, :perishable_token,  :string
		remove_index :users, :uid
		change_column :users, :uid, :string, :null => true
		add_index :users, :username, :unique => true
		add_index :users, :email, :unique => true
	end

	def self.down
		remove_index :users, :username
		remove_index :users, :email
		remove_column :users, :username
		remove_column :users, :email
		remove_column :users, :crypted_password
		remove_column :users, :password_salt
		remove_column :users, :persistence_token
		remove_column :users, :perishable_token
		change_column :users, :uid, :string, :null => false
		add_index :users, :uid, :unique => true
	end
end
