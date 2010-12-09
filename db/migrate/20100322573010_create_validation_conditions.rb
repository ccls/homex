class CreateValidationConditions < ActiveRecord::Migration
	def self.up
		table_name = 'validation_conditions'
		create_table table_name do |t|
			# Context
			t.integer :validation_id
			t.string :rule_key
			
			# Conditional		
			t.string :operator
			
			# Optional external reference
			t.integer :question_id
			t.integer :answer_id

			# Value
			t.datetime :datetime_value
			t.integer :integer_value
			t.float :float_value
			t.string :unit
			t.text :text_value
			t.string :string_value
			t.string :response_other
			t.string :regexp
			
			t.timestamps
		end unless table_exists?(table_name)
		idxs = indexes(table_name).map(&:name)
		add_index( table_name, :validation_id
			) unless idxs.include?("index_#{table_name}_on_validation_id")
	end

	def self.down
		drop_table :validation_conditions
	end
end
