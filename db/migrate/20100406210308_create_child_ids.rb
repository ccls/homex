class CreateChildIds < ActiveRecord::Migration
	def self.up
		create_table :child_ids do |t|
			t.references :subject
			t.integer :childid

			t.timestamps
		end
	end

	def self.down
		drop_table :child_ids
	end
end
