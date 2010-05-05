class ActsAsTranslatableGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      # m.directory "lib"
      # m.template 'README', "README"
			m.migration_template 'migration.rb', 'db/migrate', 
				:migration_file_name => "add_translatability_to_#{file_path.gsub(/\//, '_').pluralize}"
    end
  end
end
