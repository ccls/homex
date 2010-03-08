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
	end

	def self.down
		drop_table :pages
	end
end
