class CreateDependencyConditions < ActiveRecord::Migration
	def self.up
		table_name = 'dependency_conditions'
		create_table table_name do |t|
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
		end unless table_exists?(table_name)
		idxs = indexes(table_name).map(&:name)
		add_index( table_name, :dependency_id
			) unless idxs.include?("index_#{table_name}_on_dependency_id")
		add_index( table_name, :question_id
			) unless idxs.include?("index_#{table_name}_on_question_id")
	end

	def self.down
		drop_table :dependency_conditions
	end
end
