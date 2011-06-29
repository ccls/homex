class DropValidations < ActiveRecord::Migration
	def self.up
		drop_table :validations
	end

	def self.down
		create_table :validations do |t|
			# Context
			t.integer :answer_id # the answer to validate

			# Conditional
			t.string :rule

			# Message
			t.string :message

			t.timestamps
		end
		add_index :validations, :answer_id
	end
end
