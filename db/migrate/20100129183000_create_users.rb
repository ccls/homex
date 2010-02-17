class CreateUsers < ActiveRecord::Migration
	def self.up
		create_table :users do |t|
			t.string :uid, :null => false
			t.string :sn
			t.string :displayname
			t.string :mail
			t.string :telephonenumber
			t.string :role_name
			t.timestamps
		end
		add_index :users, :uid, :unique => true
		add_index :users, :sn
		add_index :users, :role_name
	end

	def self.down
		drop_table :users
	end
end
