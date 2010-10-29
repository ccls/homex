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

require 'lib/surveyor/survey_extensions'

#	condition added to allow clean 'rake gems:install'
if Gem.searcher.find('ccls_engine')
	require 'ccls_engine/tasks'
end
#	From script/generate simply_pages ...
require 'simply_pages/test_tasks'
#	From `script/generate simply_authorized` ...
require 'simply_authorized/test_tasks'
#	From `script/generate simply_helpful` ...
require 'simply_helpful/test_tasks'
# From `script/generate ccls_engine` ...
require 'ccls_engine/test_tasks'
# From `script/generate calnet_authenticated` ...
require 'calnet_authenticated/test_tasks'
