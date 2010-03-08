class CreatePages < ActiveRecord::Migration
	def self.up
		create_table :pages do |t|
			t.integer :position
			t.string :title
			t.string :menu
			t.string :path
			t.text :body
			t.timestamps
		end
		add_index :pages, :path, :unique => true, :name => 'by_path'
		add_index :pages, :menu, :unique => true, :name => 'by_menu'
#	acts_as_list doesn't like the uniqueness
#	when it reorders, positions are temporarily not unique
#		add_index :pages, :position, :unique => true, :name => 'by_position'
	end

	def self.down
		drop_table :pages
	end
end
