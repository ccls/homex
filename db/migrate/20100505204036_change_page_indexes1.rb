class ChangePageIndexes1 < ActiveRecord::Migration
	def self.up
		remove_index :pages, :name => 'by_path'
		remove_index :pages, :name => 'by_menu'
		add_index :pages, [:path,:locale], :unique => true
		add_index :pages, [:menu,:locale], :unique => true
	end

	def self.down
		add_index :pages, :path, :unique => true, :name => 'by_path'
		add_index :pages, :menu, :unique => true, :name => 'by_menu'
		remove_index :pages, [:path,:locale]
		remove_index :pages, [:menu,:locale]
	end
end
