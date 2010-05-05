class CreatePages < ActiveRecord::Migration
	def self.up
		create_table :pages do |t|
			t.integer :parent_id
			t.integer :position, :default => 0
			t.string :path
			t.string :title
			t.text :body
		end
	end

	def self.down
		drop_table :pages
	end
end
