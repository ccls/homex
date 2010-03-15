class AddTrackingNumberTo<%= class_name.pluralize.gsub(/::/, '') -%> < ActiveRecord::Migration
	def self.up
		add_column :<%= file_path.gsub(/\//, '_').pluralize -%>, :tracking_number, :string
	end

	def self.down
		remove_column :<%= file_path.gsub(/\//, '_').pluralize -%>, :tracking_number
	end
end
