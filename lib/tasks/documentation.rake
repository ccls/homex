#
#	This file has been copied from rails 
#		.../rails-2.3.5/lib/tasks/documentation.rake
#	so that parts of it could be modified.

namespace :doc do	|doc|

#	Rake::RDocTask.new("app") { |rdoc|
#
#		We cannot overwrite or override an RDoc rake task.
#		Redefining it here actually creates another
#		of the same name and both are run when
#		`rake doc:app` is called.	The Rakefile
#		is modified to handle the modifications.
#
#		Actually, that's not entirely true.  This would
#		add another task, but you can remove and override
#		a task.  The rdoc_rails plugin was overriding my
#		override, which caused all the frustration!!!
#
#	}

	plugins = FileList['vendor/plugins/**'].collect { |plugin| 
		File.basename(plugin) }

	namespace :plugins do
		# Define doc tasks for each plugin
		plugins.each do |plugin|

			#	clear rails' Rake::Task of the same name
			Rake::Task[plugin].clear_actions
			Rake::Task[plugin].clear_prerequisites

			Rake::RDocTask.new(plugin) { |rdoc|
				plugin_base  = "vendor/plugins/#{plugin}"
				ENV['format'] ||= 'railsfish'
				rdoc.rdoc_dir = "doc/plugins/#{plugin}"
				rdoc.template = ENV['template'] if ENV['template']
				rdoc.title    = "#{plugin.titlecase} Plugin Documentation"
				rdoc.options << '--line-numbers' << '--inline-source'
				rdoc.options << '--charset' << 'utf-8'
				rdoc.options << '--format'  << ENV['format']
				rdoc.rdoc_files.include("#{plugin_base}/lib/**/*.rb")

				%w( README README.rdoc ).each do |readme|
					if File.exist?("#{plugin_base}/#{readme}")
						rdoc.main = "#{plugin_base}/#{readme}"
						break
					end
				end
				%w( TODO.org MIT-LICENSE LICENSE CHANGELOG README README.rdoc ).each do |possible_file|
					if File.exist?("#{plugin_base}/#{possible_file}")
						rdoc.rdoc_files.include("#{plugin_base}/#{possible_file}") 
					end
				end
			}

		end
	end


	desc "Tables to CSV"
	task :tables_to_csv => :environment do
		puts ',"Home Exposures Metadata",,,,,,,,,,'
		puts ',,,,,,,,,,,'
		puts ',"Source Table Info",,,,"Destination Table Info",,,,,,'
		puts ',"Source Table","Fieldname","Data Type","Length","Destination Table",,"Fieldname","Data Type","Length","Data Source","Notes"'

		#	in development, by default, the models are eager loaded,
		#	so we need to load them manually.
#		%w( vendor/plugins/surveyor/app/models ).each do |load_path|
		%w( app/models ).each do |load_path|
			matcher = /\A#{Regexp.escape(load_path)}(.*)\.rb\Z/
			Dir.glob("#{load_path}/**/*.rb").sort.each do |file|
				require_dependency file.sub(matcher, '\1')
			end
		end

		skip = %w( Import Export BdrbJobQueue )
		Object.subclasses_of(ActiveRecord::Base).sort_by{|a|a.name}.each do |ar|
			next if skip.include?(ar.name)
			table_name = ar.table_name
			ar.columns.each do |c|
				puts ",,,,,\"#{table_name}\",,\"#{c.name}\",\"#{c.type}\",\"#{c.sql_type}\""
			end
		end

	end

	task :parse_readme => :environment do
		require 'rdoc/markup/to_html'
		h = RDoc::Markup::ToHtml.new
		puts h.convert( File.read('README.rdoc') )
	end
end
