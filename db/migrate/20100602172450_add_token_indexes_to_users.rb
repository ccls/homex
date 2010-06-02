class AddTokenIndexesToUsers < ActiveRecord::Migration
	def self.up
		add_index :users, :perishable_token,  :unique => true
		add_index :users, :persistence_token, :unique => true
	end

	def self.down
		remove_index :users, :perishable_token
		remove_index :users, :persistence_token
	end
end
