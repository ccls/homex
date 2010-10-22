class DropDocuments < ActiveRecord::Migration
  def self.up
		drop_table :documents
  end

  def self.down
		create_table :documents do |t|
			t.references :owner
			t.string :title, :null => false
			t.text   :abstract
			t.boolean :shared_with_all, 
				:default => false, :null => false
			t.boolean :shared_with_select, 
				:default => false, :null => false
			t.timestamps
		end
		add_index :documents, :owner_id
		add_column :documents, :document_file_name, :string
		add_column :documents, :document_content_type, :string
		add_column :documents, :document_file_size, :integer
		add_column :documents, :document_updated_at, :datetime
		add_index :documents, :document_file_name, :unique => true
  end
end
