class CreateQuestions < ActiveRecord::Migration
	def self.up
		table_name = 'questions'
		create_table table_name do |t|
			# Context
			t.integer :survey_section_id
			t.integer :question_group_id

			# Content
			t.text :text
			t.text :short_text # For experts (ie non-survey takers). Short version of text
			t.text :help_text
			t.string :pick

			# Reference
			t.string :reference_identifier # from paper
			t.string :data_export_identifier # data export
			t.string :common_namespace # maping to a common vocab
			t.string :common_identifier # maping to a common vocab
			
			# Display
			t.integer :display_order
			t.string :display_type
			t.boolean :is_mandatory
			t.integer :display_width # used only for slider component (if needed)
			
			t.string :custom_class
			t.string :custom_renderer
			
			t.timestamps
		end unless table_exists?(table_name)
		idxs = indexes(table_name).map(&:name)
		add_index( table_name, :survey_section_id
			) unless idxs.include?("index_#{table_name}_on_survey_section_id")
		add_index( table_name, :data_export_identifier
			) unless idxs.include?("index_#{table_name}_on_data_export_identifier")
	end

	def self.down
		drop_table :questions
	end
end
