class DropDependencyConditions < ActiveRecord::Migration
	def self.up
		drop_table :dependency_conditions
	end

	def self.down
		create_table :dependency_conditions do |t|
			# Context
			t.integer :dependency_id
			t.string :rule_key

			# Conditional
			t.integer :question_id # the conditional question
			t.string :operator

			# Value
			t.integer :answer_id
			t.datetime :datetime_value
			t.integer :integer_value
			t.float :float_value
			t.string :unit
			t.text :text_value
			t.string :string_value
			t.string :response_other

			t.timestamps
		end
		add_index :dependency_conditions, :dependency_id
		add_index :dependency_conditions, :question_id
	end
end
