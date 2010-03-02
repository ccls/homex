class CreateResidences < ActiveRecord::Migration
	def self.up
		create_table :residences do |t|
			t.integer :position
			t.references :address
			t.references :subject
			t.date :moved_in_on
			t.date :moved_out_on
			t.boolean :current_residence
			t.boolean :residence_at_diagnosis
			t.timestamps
		end
	end

	def self.down
		drop_table :residences
	end
end
