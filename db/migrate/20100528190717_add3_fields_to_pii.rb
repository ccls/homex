class Add3FieldsToPii < ActiveRecord::Migration
	def self.up
		add_column :piis, :patid, :string
		add_column :piis, :type, :string
		add_column :piis, :orderno, :string
#	this doesn't appear to be unique
#		add_index  :piis, :patid, :unique => true
	end

	def self.down
#		remove_index  :piis, :patid
		remove_column :piis, :patid
		remove_column :piis, :type
		remove_column :piis, :orderno
	end
end
