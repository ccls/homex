# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

#	Use the updated rdoc gem rather than version
#	included with ruby.
require 'rdoc'	

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

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
				rdoc.rdoc_files.include('README.rdoc')
				rdoc.rdoc_files.include(
					'vendor/plugins/acts_as_trackable/lib/track.rb')
			}
		else
			orig_initialize(name) { |rdoc| yield rdoc }
		end
	end
end

require 'tasks/rails'
