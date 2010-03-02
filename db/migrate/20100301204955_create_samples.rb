class CreateSamples < ActiveRecord::Migration
	def self.up
		create_table :samples do |t|
			t.integer :position
			t.references :aliquot_sample_format
			t.references :sample_subtype
			t.references :subject
			t.references :unit
			t.string :sample_order_number
			t.decimal :quantity_in_sample
			t.string :aliquot_or_sample_on_receipt
			t.date :sent_to_subject_on
			t.date :received_by_ccls_on
			t.date :received_by_lab_on
			t.date :aliquotted_on

			t.timestamps
		end
	end

	def self.down
		drop_table :samples
	end
end
