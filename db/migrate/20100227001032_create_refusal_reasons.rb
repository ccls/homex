class CreateRefusalReasons < ActiveRecord::Migration
	def self.up
		create_table :refusal_reasons do |t|
			t.integer :position
			t.string :description
			t.timestamps
		end
		add_index :refusal_reasons, :description, :unique => true
	end

	def self.down
		drop_table :refusal_reasons
	end
end
