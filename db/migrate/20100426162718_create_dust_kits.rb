class CreateDustKits < ActiveRecord::Migration
	def self.up
		create_table :dust_kits do |t|
			t.references :subject
			t.references :kit_package
			t.references :dust_package
			t.timestamps
		end
	end

	def self.down
		drop_table :dust_kits
	end
end
