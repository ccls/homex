# Disable automatic framework detection by uncommenting/setting to false
# Warbler.framework_detection = false

#	I don't know exactly why, but without this
#	a newer versions loads, but is incompatible.
gem 'i18n', '=0.3.7'

#	Due to the existance of rails 3, warbler won't find
#	rails 2.3.10 unless a gem of that version is listed
#	directly below this.  Without it, it will complain
#	that you don't have rails installed.
#		Missing the Rails 2.3.10 gem. Please `gem install -v=2.3.10 rails`, 
#		update your RAILS_GEM_VERSION setting in config/environment.rb 
#		for the Rails version you do have installed, or comment out 
#		RAILS_GEM_VERSION to use the latest version installed.
gem 'activesupport', '=2.3.10'

#	for alias_method_chain
require 'active_support'	#	note the name disparity
#require 'active_support/core_ext'	#	note the name disparity

module WarblerWar

	def self.included(base)
		base.class_eval do
			alias_method_chain :apply, :removal
		end
	end

	def apply_with_removal(config,&block)
		apply_without_removal(config,&block)
		puts "BEFORE:#{@files.keys.length}"
		@files.delete_if {|k,v|
			#	MUST REMOVE SPECIFICATION TOO!
			#	Wasn't removing 3.0 specs and then rails
			#	complained that rails 2.3.10 wasn't installed??
			k =~ %r{WEB-INF/gems/[^/]+/(#{config.remove_gem_files.join('|')})}
		} unless config.remove_gem_files.empty?
		puts "AFTER:#{@files.keys.length} (~4900)"
	end

end
Warbler::War.send(:include,WarblerWar)

module WarblerConfig

	def self.included(base)
		base.class_eval do
			attr_accessor :remove_gem_files
			alias_method_chain :initialize, :removal
		end
	end

	#	ALWAYS RECEIVE AND PASS A BLOCK!
	def initialize_with_removal(warbler_home = WARBLER_HOME,&block)
		@remove_gem_files = []
		initialize_without_removal(warbler_home,&block)
	end

end
Warbler::Config.send(:include,WarblerConfig)


#	Always includes the latest version of a gem
#	despite being told not to.  Bad dog!


# Warbler web application assembly configuration file
Warbler::Config.new do |config|
	# Features: additional options controlling how the jar is built.
	# Currently the following features are supported:
	# - gemjar: package the gem repository in a jar file in WEB-INF/lib
	# config.features = %w(gemjar)

	# Application directories to be included in the webapp.
	config.dirs = %w(app config lib log vendor tmp db script test)
	#	db contains the migrations
	#	script contains the obvious
	#	test contains the fixtures

	# Additional files/directories to include, above those in config.dirs
	# config.includes = FileList["db"]
	config.includes = FileList["Rakefile"]

	# Additional files/directories to exclude
	# config.excludes = FileList["lib/tasks/*"]
	config.excludes = FileList[*%w(
		db/*sqlite3
		.DS_Store
		**/versions/**/*
	)]	#	be VERY specific here
#
#	This blocks app/views/document_versions/*
#		versions/**/*
#	This does too, but I don't understand why.
#	Testing shows that it shouldn't.
#		**/versions/

	# Additional Java .jar files to include.	Note that if .jar files are placed
	# in lib (and not otherwise excluded) then they need not be mentioned here.
	# JRuby and JRuby-Rack are pre-loaded in this list.	Be sure to include your
	# own versions if you directly set the value
	# config.java_libs += FileList["lib/java/*.jar"]

	# Loose Java classes and miscellaneous files to be placed in WEB-INF/classes.
	# config.java_classes = FileList["target/classes/**.*"]

	# One or more pathmaps defining how the java classes should be copied into
	# WEB-INF/classes. The example pathmap below accompanies the java_classes
	# configuration above. See http://rake.rubyforge.org/classes/String.html#M000017
	# for details of how to specify a pathmap.
	# config.pathmaps.java_classes << "%{target/classes/,}p"

	# Path to the pre-bundled gem directory inside the war file. Default
	# is 'WEB-INF/gems'. Specify path if gems are already bundled
	# before running Warbler. This also sets 'gem.path' inside web.xml.
	# config.gem_path = "WEB-INF/vendor/bundler_gems"

	# Bundler support is built-in. If Warbler finds a Gemfile in the
	# project directory, it will be used to collect the gems to bundle
	# in your application. If you wish to explicitly disable this
	# functionality, uncomment here.
	# config.bundler = false

	# Files for WEB-INF directory (next to web.xml). This contains
	# web.xml by default. If there is an .erb-File it will be processed
	# with webxml-config. You may want to exclude this file via
	# config.excludes.
	# config.webinf_files += FileList["jboss-web.xml"]

	# Other gems to be included. You need to tell Warbler which gems
	# your application needs so that they can be packaged in the war
	# file.
	# The Rails gems are included by default unless the vendor/rails
	# directory is present.
	# config.gems += ["activerecord-jdbcmysql-adapter", "jruby-openssl"]
	# config.gems << "tzinfo"

#
#	Rails 3 generates a lot of headaches just by existing!
#	If it is installed locally, it will end up in the .war
#	despite my efforts to stop it.
#

	# Uncomment this if you don't want to package rails gem.
#	BULLSHIT
	# config.gems -= ["rails"]
#	config.gems -= %w( i18n rails activerecord activesupport activeresource actionpack actionmailer activemodel arel railties bundler erubis mail polyglot thor treetop tzinfo )
#	ALL THAT AND THEY STILL END UP IN THE WAR FILE

	# The most recent versions of gems are used.
	# You can specify versions of gems by using a hash assignment:
	# config.gems["rails"] = "2.0.2"

	#	just before creating the war file, files matching
	#	these will be removed from the list. 
	#	  WEB-INF/gems/gems/REGEX
	config.remove_gem_files = %w(
		activesupport-3
		activerecord-3
		activeresource-3
		actionpack-3
		actionmailer-3
		activemodel-3
		railties-3
		rails-3
		rack-1.2.1
		rack-mount-
		rack-test-
		i18n-0.4 
		abstract-
		arel-
		bundler-
		erubis-
		mail-
		polyglot-
		thor-
		treetop-
		tzinfo-
	)

	# You can also use regexps or Gem::Dependency objects for flexibility or
	# fine-grained control.
	# config.gems << /^merb-/
	# config.gems << Gem::Dependency.new("merb-core", "= 0.9.3")
#	config.gems << Gem::Dependency.new("rails", "= 2.3.8")
#	config.gems << Gem::Dependency.new("rack", "= 1.1.0")

	# Include gem dependencies not mentioned specifically. Default is true, uncomment
	# to turn off.
	# config.gem_dependencies = false		#	too much

	# Array of regular expressions matching relative paths in gems to be
	# excluded from the war. Defaults to empty, but you can set it like
	# below, which excludes test files.
	# config.gem_excludes = [/^(test|spec)\//]

	# Files to be included in the root of the webapp.	Note that files in public
	# will have the leading 'public/' part of the path stripped during staging.
	# config.public_html = FileList["public/**/*", "doc/**/*"]
	config.public_html  = FileList["public/**/*"]
	config.public_html -= FileList[*%w(
		public/bottom.html 
		public/columns.html 
		public/index.html.orig 
		public/layout1.html
		public/system
		public/system/**/*
		public/doc
		public/doc/**/*
		public/**/versions
		public/**/versions/**/*
	)]

	# Pathmaps for controlling how public HTML files are copied into the .war
	# config.pathmaps.public_html = ["%{public/,}p"]

	# Pathmaps for controlling how application files are copied into the .war
	# config.pathmaps.application = ["WEB-INF/%p"]

	# Name of the war file (without the .war) -- defaults to the basename
	# of RAILS_ROOT
	config.war_name = "homex"

	# Name of the MANIFEST.MF template for the war file. Defaults to the
	# MANIFEST.MF normally generated by `jar cf`.
	# config.manifest_file = "config/MANIFEST.MF"

	# Value of RAILS_ENV for the webapp -- default as shown below
	# config.webxml.rails.env = ENV['RAILS_ENV'] || 'production'

	# Application booter to use, one of :rack, :rails, or :merb (autodetected by default)
	# config.webxml.booter = :rails

	# When using the :rack booter, "Rackup" script to use.
	# - For 'rackup.path', the value points to the location of the rackup
	# script in the web archive file. You need to make sure this file
	# gets included in the war, possibly by adding it to config.includes
	# or config.webinf_files above.
	# - For 'rackup', the rackup script you provide as an inline string
	#	 is simply embedded in web.xml.
	# The script is evaluated in a Rack::Builder to load the application.
	# Examples:
	# config.webxml.rackup.path = 'WEB-INF/hello.ru'
	# config.webxml.rackup = %{require './lib/demo'; run Rack::Adapter::Camping.new(Demo)}
	# config.webxml.rackup = require 'cgi' && CGI::escapeHTML(File.read("config.ru"))

	# Control the pool of Rails runtimes. Leaving unspecified means
	# the pool will grow as needed to service requests. It is recommended
	# that you fix these values when running a production server!
	# config.webxml.jruby.min.runtimes = 2
	# config.webxml.jruby.max.runtimes = 4

#	May be the cause of permission problems
#	config.webxml.jruby.min.runtimes = 1
#	config.webxml.jruby.max.runtimes = 1

	# JNDI data source name
	# config.webxml.jndi = 'jdbc/rails'

end
