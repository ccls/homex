class SetUserEmailDefault < ActiveRecord::Migration
	def self.up
		change_column :users, :email, :string, :default => ''
	end

	def self.down
		change_column :users, :email, :string, :default => nil
	end
end
