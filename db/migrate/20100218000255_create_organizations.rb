class CreateOrganizations < ActiveRecord::Migration
	def self.up
		create_table :organizations do |t|
			t.integer :position
			t.integer :aliquots_count, :default => 0
			t.string :name
			t.timestamps
		end
		add_index :organizations, :name, :unique => true, :name => 'by_name'
	end

	def self.down
		drop_table :organizations
	end
end
