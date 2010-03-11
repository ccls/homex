class CreateShipmentEvents < ActiveRecord::Migration
	def self.up
		create_table :shipment_events do |t|
			t.references :package
			t.string :location
			t.string :name
			t.datetime :time
			t.timestamps
		end
		add_index :shipment_events, [:package_id, :time], :unique => true
	end

	def self.down
		drop_table :shipment_events
	end
end
