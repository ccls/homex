class CreateDocumentVersions < ActiveRecord::Migration
	def self.up
		create_table :document_versions do |t|
			t.integer :position
			t.references :document_type, :null => false
			t.string :title
			t.string :description
			t.string :indicator
			t.timestamps
		end
	end

	def self.down
		drop_table :document_versions
	end
end
