class CreateSamples < ActiveRecord::Migration
	def self.up
		create_table :samples do |t|
			t.integer :position
			t.references :aliquot_sample_format
			t.references :sample_type
			t.references :subject
			t.references :unit
			t.integer :order_no, :default => 1
			t.decimal :quantity_in_sample
			t.string :aliquot_or_sample_on_receipt, :default => 'Sample'
			t.date :sent_to_subject_on
			t.date :received_by_ccls_on
			t.date :sent_to_lab_on
			t.date :received_by_lab_on
			t.date :aliquotted_on
			t.string :external_id
			t.string :external_id_source
			t.date :receipt_confirmed_on
			t.string :receipt_confirmed_by
			t.timestamps
		end
	end

	def self.down
		drop_table :samples
	end
end
