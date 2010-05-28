class Add3FieldsToPii < ActiveRecord::Migration
	def self.up
		add_column :piis, :patid, :string
		add_column :piis, :type, :string
		add_column :piis, :orderno, :string
	end

	def self.down
		remove_column :piis, :patid
		remove_column :piis, :type
		remove_column :piis, :orderno
	end
end
