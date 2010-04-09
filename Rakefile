# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

#	Use the updated rdoc gem rather than version
#	included with ruby.
require 'rdoc'
require 'rdoc/rdoc'

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
				%w(	
					README.rdoc
					/usr/lib/ruby/user-gems/1.8/gems/surveyor-0.9.10/app/models/**
					vendor/plugins/acts_as_trackable/lib/track.rb
				).each{|f| rdoc.rdoc_files.include( f ) }
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

#	why?  Included by default
#	As a plugin, this line will cause all tasks to be duplicated
#	so DEFINITELY remove this line
#require 'tasks/surveyor'
#	It still tries to run it twice!!!! WTF
#
#	There were some lines in one of my rake files for getting 
#	the tasks from the gem
#

require 'lib/surveyor/survey_extensions'
