class CreateExports < ActiveRecord::Migration
	def self.up
		table_name = 'exports'
		create_table table_name do |t|
#			t.integer :child_id
			t.integer :childid
			t.string :first_name
			t.string :middle_name
			t.string :last_name
			t.date :diagnosis_date
#			t.integer :pat_id
			t.integer :patid
			t.string :type
#			t.string :order_no
			t.string :orderno
			t.string :mother_first_name
			t.string :mother_middle_name
			t.string :mother_last_name
			t.string :father_first_name
			t.string :father_middle_name
			t.string :father_last_name
#			t.string :hospital_id
			t.string :hospital_code
			t.text :comments
			t.boolean :is_eligible
			t.boolean :is_chosen
			t.date :reference_date
			t.timestamps
		end unless table_exists?(table_name)
		idxs = indexes(table_name).map(&:name)
		add_index( table_name, :childid, :unique => true
			) unless idxs.include?("index_#{table_name}_on_childid")
		add_index( table_name, :patid,   :unique => true
			) unless idxs.include?("index_#{table_name}_on_patid")
	end

	def self.down
		drop_table :exports
	end
end
