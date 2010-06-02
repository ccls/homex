class CreateChildIds < ActiveRecord::Migration
	def self.up
		create_table :child_ids do |t|
			t.references :subject
			t.integer :childid
			t.timestamps
		end
		add_index :child_ids, :subject_id, :unique => true
	end

	def self.down
		drop_table :child_ids
	end
end
