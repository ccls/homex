class CreateIneligibleReasons < ActiveRecord::Migration
	def self.up
		create_table :ineligible_reasons do |t|
			t.integer :position
			t.string :description
			t.string :ineligible_context
			t.timestamps
		end
		add_index :ineligible_reasons, :description, :unique => true
	end

	def self.down
		drop_table :ineligible_reasons
	end
end
