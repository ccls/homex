class DropSurveys < ActiveRecord::Migration
	def self.up
		drop_table :surveys
	end

	def self.down
		create_table :surveys do |t|
			# Content
			t.string :title
			t.text :description

			# Reference
			t.string :access_code
			t.string :reference_identifier # from paper
			t.string :data_export_identifier # data export
			t.string :common_namespace # maping to a common vocab
			t.string :common_identifier # maping to a common vocab

			# Expiry
			t.datetime :active_at
			t.datetime :inactive_at
			
			# Display
			t.string :css_url
			
			t.string :custom_class
			
			t.timestamps

			t.integer :display_order
			t.boolean :manual_numbering
		end
		add_index :surveys, :access_code, :unique => true
		add_index :surveys, :access_code, :unique => true, :name => 'surveys_ac_idx'
	end
end
