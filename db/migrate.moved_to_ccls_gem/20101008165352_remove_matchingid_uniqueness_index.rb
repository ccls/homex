class RemoveMatchingidUniquenessIndex < ActiveRecord::Migration
	def self.up
		remove_index :subjects, :matchingid
	end

	def self.down
		add_index :subjects, :matchingid
	end
end
