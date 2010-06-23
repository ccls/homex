class ChangePiisOrdernoTo1Char < ActiveRecord::Migration
	def self.up
		change_column :piis, :orderno, :string, :limit => 1
	end

	def self.down
		change_column :piis, :orderno, :string
	end
end
