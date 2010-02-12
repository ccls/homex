class CreateUsers < ActiveRecord::Migration
	def self.up
		create_table :users do |t|
			t.string :uid, :null => false
			t.string :sn
			t.string :displayname
			t.string :mail
			t.string :telephonenumber
			t.boolean :administrator, :default => false, :null => false
			t.timestamps
		end
		add_index :users, :uid, :unique => true
		add_index :users, :sn
	end

	def self.down
		drop_table :users
	end
end
