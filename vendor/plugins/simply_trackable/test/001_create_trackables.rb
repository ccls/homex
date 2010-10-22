class CreateTrackables < ActiveRecord::Migration
	def self.up
		create_table :packages do |t|
			t.string :name
		end
		create_table :books do |t|
			t.string :title
		end
	end

	def self.down
		drop_table :packages
		drop_table :books
	end
end
