class AddTrackingInfoTo<%= class_name.pluralize.gsub(/::/, '') -%> < ActiveRecord::Migration
	def self.up
		add_column :<%= file_path.gsub(/\//, '_').pluralize -%>, :tracks_count, :integer, :default => 0
		add_column :<%= file_path.gsub(/\//, '_').pluralize -%>, :tracking_number, :string
		add_index  :<%= file_path.gsub(/\//, '_').pluralize -%>, :tracking_number, :unique => true
	end

	def self.down
		remove_column :<%= file_path.gsub(/\//, '_').pluralize -%>, :tracks_count
		remove_column :<%= file_path.gsub(/\//, '_').pluralize -%>, :tracking_number
	end
end
