class AddTranslatabilityTo<%= class_name.pluralize.gsub(/::/, '') -%> < ActiveRecord::Migration
	def self.up
		add_column :<%= file_path.gsub(/\//, '_').pluralize -%>, 
			:translatable_id, :integer
		add_column :<%= file_path.gsub(/\//, '_').pluralize -%>, 
			:locale, :string, :default => 'en', :null => false
#
#	need some type of unique indexing to avoid multiple translations
#	of same thing in same locale
#
#	May have to force the original to point to itself to avoid the 
#	duplication of nil translation_of_id and nil locale.
#
		add_index  :<%= file_path.gsub(/\//, '_').pluralize -%>, 
			[:translatable_id, :locale], :unique => true
	end

	def self.down
		remove_column :<%= file_path.gsub(/\//, '_').pluralize -%>, 
			:translatable_id
		remove_column :<%= file_path.gsub(/\//, '_').pluralize -%>, 
			:locale
	end
end
