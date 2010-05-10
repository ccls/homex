class RemoveControllerFromPage < ActiveRecord::Migration
	def self.up
		remove_index  :pages, :controller
		remove_column :pages, :controller
	end

	def self.down
		add_column :pages, :controller, :string
		add_index  :pages, :controller
	end
end
