class AddTranslatabilityTo<%= class_name.pluralize.gsub(/::/, '') -%> < ActiveRecord::Migration
	def self.up
		add_column :<%= file_path.gsub(/\//, '_').pluralize -%>, 
			:translatable_id, :integer
		add_column :<%= file_path.gsub(/\//, '_').pluralize -%>, 
			:locale, :string, :default => 'en', :null => false
		add_index  :<%= file_path.gsub(/\//, '_').pluralize -%>, 
			[:translatable_id, :locale], :unique => true
		<%=class_name-%>.all.each do |p|
			p.update_attribute(:translatable_id, p.id)
		end
	end

	def self.down
		remove_index  :<%= file_path.gsub(/\//, '_').pluralize -%>, 
			[:translatable_id, :locale]
		remove_column :<%= file_path.gsub(/\//, '_').pluralize -%>, 
			:translatable_id
		remove_column :<%= file_path.gsub(/\//, '_').pluralize -%>, 
			:locale
	end
end
