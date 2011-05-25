require(File.join(File.dirname(__FILE__), 'config', 'boot'))

#	Newer versions are incompatible with rdoc_rails gem/plugin
gem 'rdoc', '~> 2'

#	Use the updated rdoc gem rather than version
#	included with ruby.
require 'rdoc'
require 'rdoc/rdoc'

require 'rake'
require 'rake/testtask'
#require 'rake/rdoctask'
require 'rdoc/task'

#
#	Basically, we are modifying the doc:app as Rails creates 
#	it in "require 'tasks/rails'".  The name of the task is 
#	a String and the current_scope is an Array of nested 
#	namespaces as Symbols. (don't know what order)
#
#	http://lists.netisland.net/archives/phillyonrails/phillyonrails-2006/msg00167.html
#
#	The rdoc_rails plugin removes the original doc:app task
#	and replaces it with its own.  Rather that meddle
#	with removing that one and creating my own, I'll just
#	make the mods that I need. 
#	(This isn't very conventional)
class Rake::RDocTask
	alias :orig_initialize :initialize
	def initialize(name)
		if Rake.application.current_scope == [:doc] and name == "app"
			orig_initialize(name) { |rdoc|
				yield rdoc # Init the way Rails expects
				rdoc.main = 'README.rdoc'
				%w(	
					README.rdoc
					/usr/lib/ruby/user-gems/1.8/gems/surveyor-0.9.10/app/models/**
				).each{|f| rdoc.rdoc_files.include( f ) }
#					vendor/plugins/acts_as_trackable/lib/track.rb
#				rdoc.rdoc_files.include('README.rdoc')
#				rdoc.rdoc_files.include(
#					'vendor/plugins/acts_as_trackable/lib/track.rb')
			}
		else
			orig_initialize(name) { |rdoc| yield rdoc }
		end
	end
end

require 'tasks/rails'

load 'tasks/surveyor.rake'
require 'lib/surveyor/survey_extensions'

#	Must come after rails as overrides doc:app
if g = Gem.source_index.find_name('jakewendt-rdoc_rails').last
	gem 'jakewendt-rdoc_rails'
	require 'rdoc_rails'
	load "#{g.full_gem_path}/lib/tasks/rdoc_rails.rake"
end
