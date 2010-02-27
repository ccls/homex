class CreateIneligibleReasons < ActiveRecord::Migration
	def self.up
		create_table :ineligible_reasons do |t|
			t.string :description
			t.string :ineligible_context
			t.timestamps
		end
	end

	def self.down
		drop_table :ineligible_reasons
	end
end
