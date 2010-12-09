class CreateValidations < ActiveRecord::Migration
	def self.up
		table_name = 'validations'
		create_table table_name do |t|
			# Context
			t.integer :answer_id # the answer to validate
			
			# Conditional
			t.string :rule

			# Message
			t.string :message
			
			t.timestamps
		end unless table_exists?(table_name)
		idxs = indexes(table_name).map(&:name)
		add_index( table_name, :answer_id
			) unless idxs.include?("index_#{table_name}_on_answer_id")
	end

	def self.down
		drop_table :validations
	end
end
