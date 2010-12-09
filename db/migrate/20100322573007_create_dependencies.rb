class CreateDependencies < ActiveRecord::Migration
	def self.up
		table_name = 'dependencies'
		create_table table_name do |t|
			# Context
			t.integer :question_id # the dependent question
			t.integer :question_group_id
			
			# Conditional
			t.string :rule

			# Result - TODO: figure out the dependency hook presentation options
			# t.string :property_to_toggle # visibility, class_name,
			# t.string :effect #blind, opacity

			t.timestamps
		end unless table_exists?(table_name)
		idxs = indexes(table_name).map(&:name)
		add_index( table_name, :question_id
			) unless idxs.include?("index_#{table_name}_on_question_id")
	end

	def self.down
		drop_table :dependencies
	end
end
