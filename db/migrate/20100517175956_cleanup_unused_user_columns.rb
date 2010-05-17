class CleanupUnusedUserColumns < ActiveRecord::Migration
	def self.up
#		remove_index :users, :uid
		remove_index :users, :sn
		remove_column :users, :uid
		remove_column :users, :sn
		remove_column :users, :displayname
		remove_column :users, :mail
		remove_column :users, :telephonenumber
	end

	def self.down
		add_column :users, :uid, :string, :null => false
		add_column :users, :sn, :string
		add_column :users, :displayname, :string
		add_column :users, :mail, :string
		add_column :users, :telephonenumber, :string
#		add_index :users, :uid, :unique => true
		add_index :users, :sn
	end
end
