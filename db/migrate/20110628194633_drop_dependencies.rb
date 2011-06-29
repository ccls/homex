class DropDependencies < ActiveRecord::Migration
	def self.up
		drop_table :dependencies
	end

	def self.down
		create_table :dependencies do |t|
			# Context
			t.integer :question_id # the dependent question
			t.integer :question_group_id
			
			# Conditional
			t.string :rule

			# Result - TODO: figure out the dependency hook presentation options
			# t.string :property_to_toggle # visibility, class_name,
			# t.string :effect #blind, opacity

			t.timestamps
		end
		add_index :dependencies, :question_id
	end
end
