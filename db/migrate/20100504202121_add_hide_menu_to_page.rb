class AddHideMenuToPage < ActiveRecord::Migration
	def self.up
		add_column :pages, :hide_menu, :boolean, :default => false
	end

	def self.down
		remove_column :pages, :hide_menu
	end
end
