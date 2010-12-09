class CreateSurveySections < ActiveRecord::Migration
	def self.up
		table_name = 'survey_sections'
		create_table table_name do |t|
			# Context
			t.integer :survey_id
			
			# Content
			t.string :title
			t.text :description
			
			# Reference
			t.string :reference_identifier # from paper
			t.string :data_export_identifier # data export
			t.string :common_namespace # maping to a common vocab
			t.string :common_identifier # maping to a common vocab
			
			# Display
			t.integer :display_order
			
			t.string :custom_class

			t.timestamps
		end unless table_exists?(table_name)
		idxs = indexes(table_name).map(&:name)
		add_index( table_name, :survey_id
			) unless idxs.include?("index_#{table_name}_on_survey_id")
	end

	def self.down
		drop_table :survey_sections
	end
end
