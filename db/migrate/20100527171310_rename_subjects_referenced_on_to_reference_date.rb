class RenameSubjectsReferencedOnToReferenceDate < ActiveRecord::Migration
	def self.up
		rename_column :subjects, :referenced_on, :reference_date
	end

	def self.down
		rename_column :subjects, :reference_date, :referenced_on
	end
end
