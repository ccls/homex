class DropPhotos < ActiveRecord::Migration
	def self.up
		drop_table :photos
	end

	def self.down
		create_table :photos do |t|
			t.string :title, :null => false
			t.text	 :caption
			t.timestamps
		end
		add_column :photos, :image_file_name, :string
		add_column :photos, :image_content_type, :string
		add_column :photos, :image_file_size, :integer
		add_column :photos, :image_updated_at, :datetime
	end
end
