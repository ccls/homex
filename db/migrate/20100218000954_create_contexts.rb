class CreateContexts < ActiveRecord::Migration
	def self.up
		create_table :contexts do |t|
			t.integer :position
			t.string :description
			t.text :notes
			t.timestamps
		end
		add_index :contexts, :description, :unique => true
	end

	def self.down
		drop_table :contexts
	end
end
