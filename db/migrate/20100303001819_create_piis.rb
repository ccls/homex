class CreatePiis < ActiveRecord::Migration
	def self.up
		create_table :piis do |t|
			t.references :subject
#	related_child_id
			t.string :first_name
			t.string :middle_name
			t.string :last_name
			t.date :dob
			t.string :ssn
			t.string :state_id_no
#			t.string :primary_phone_number
#			t.string :alternate_phone_number
			t.string :phone_primary
			t.string :phone_alternate
			t.string :mother_first_name
			t.string :mother_middle_name
			t.string :mother_last_name
			t.string :father_first_name
			t.string :father_middle_name
			t.string :father_last_name

			t.timestamps
		end
		add_index :piis, :ssn, :unique => true
		add_index :piis, :state_id_no, :unique => true
	end

	def self.down
		drop_table :piis
	end
end
