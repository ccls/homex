class CreateShipmentEvents < ActiveRecord::Migration
	def self.up
		create_table :shipment_events do |t|
			t.references :package
			t.string :location
			t.string :name
			t.datetime :time
			t.timestamps
		end
	end

	def self.down
		drop_table :shipment_events
	end
end
