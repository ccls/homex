class CreateRefusalReasons < ActiveRecord::Migration
	def self.up
		create_table :refusal_reasons do |t|
			t.string :description
			t.timestamps
		end
	end

	def self.down
		drop_table :refusal_reasons
	end
end
