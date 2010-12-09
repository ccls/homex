class AddDisplayOrderToSurveys < ActiveRecord::Migration
	def self.up
		table_name = 'surveys'
		cols = columns(table_name).map(&:name)
		add_column( table_name, :display_order, :integer
			) unless cols.include?('display_order')
	end

	def self.down
		remove_column :surveys, :display_order
	end
end
