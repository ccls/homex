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
#	So this sucks a bit.  Apparently, the developer cannot
#	override an RDoc rake task.  Basically, we are modifying
#	the doc:app as Rails creates it in "require 'tasks/rails'".
#	The name of the task is a String and the current_scope
#	is an Array of Symbols. (don't know what order)  The 
#	current_scope is an Array of nested namespaces.
#
#	http://lists.netisland.net/archives/phillyonrails/phillyonrails-2006/msg00167.html
#
#
#
#	Actually, you can remove an RDocTask, but when you
#	have a plugin that comes in behind you and redefines
#	it, it just seems like you can't!!!!!!!
#

class Rake::RDocTask
	alias :orig_initialize :initialize
	def initialize(name)
#puts "initializing '#{name}'"
#puts "current_scope '#{Rake.application.current_scope}'"
#puts "current_scope class '#{Rake.application.current_scope.class.name}'"
#puts "current_scope first '#{Rake.application.current_scope.first.class.name}'"
		if Rake.application.current_scope == [:doc] and name == "app"
#puts self.methods.sort
#puts self.instance_variables.sort
#puts Rake.application.inspect
#puts Rake.application.current_scope
			orig_initialize(name) { |rdoc|
				yield rdoc # Init the way Rails expects
				rdoc.rdoc_files.include('README.rdoc')
			}
		else
			orig_initialize(name) { |rdoc| yield rdoc }
		end
	end
end

require 'tasks/rails'
