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
#	}

	plugins = FileList['vendor/plugins/**'].collect { |plugin| 
		File.basename(plugin) }

	namespace :plugins do
		# Define doc tasks for each plugin
		plugins.each do |plugin|

			#	clear rails' Rake::Task of the same name
			Rake::Task[plugin].clear_actions
			Rake::Task[plugin].clear_prerequisites

			desc "Generate documentation for the #{plugin} plugin"
			task(plugin => :environment) do
				plugin_base	 = "vendor/plugins/#{plugin}"
				options			 = []
				files				 = Rake::FileList.new
				options << "-o doc/plugins/#{plugin}"
				options << "--title '#{plugin.titlecase} Plugin Documentation'"
				options << '--line-numbers' << '--inline-source'
				options << '--charset' << 'utf-8'

#	uh-oh! RDoc had a problem:
#	could not find template "html"
#				options << '-T html'

				files.include("#{plugin_base}/lib/**/*.rb")
				%w( README README.rdoc ).each do |readme|
					if File.exist?("#{plugin_base}/#{readme}")
						options << "--main '#{plugin_base}/#{readme}'"
						break
					end
				end
				%w( TODO.org MIT-LICENSE LICENSE CHANGELOG README README.rdoc ).each do |possible_file|
					if File.exist?("#{plugin_base}/#{possible_file}")
						files.include("#{plugin_base}/#{possible_file}") 
					end
				end

				options << files.to_s

				sh %(rdoc #{options * ' '})
			end
		end
	end
end
