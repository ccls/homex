# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.14' unless defined? RAILS_GEM_VERSION

#ENV['RAILS_ENV'] ||= 'production'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

#	This constant is used in the ucb_ccls_engine#Document
#	and other places like Amazon buckets
#	for controlling the path to documents.
RAILS_APP_NAME = 'homex'

Rails::Initializer.run do |config|

#	config.gem 'RedCloth', :version => '!= 4.2.6', :lib => 'redcloth'

#	if RUBY_PLATFORM =~ /java/
#		config.gem 'activerecord-jdbcsqlite3-adapter',
#			:lib => 'active_record/connection_adapters/jdbcsqlite3_adapter'
#		config.gem 'activerecord-jdbcmysql-adapter',
#			:lib => 'active_record/connection_adapters/jdbcmysql_adapter'
#		config.gem 'jdbc-mysql', :lib => 'jdbc/mysql'
#		config.gem 'jdbc-sqlite3', :lib => 'jdbc/sqlite3'
#		config.gem 'jruby-openssl', :lib => 'openssl'
#	else
		config.gem 'mysql'
		config.gem "sqlite3"
#	end

	#	due to some enhancements, the db gems MUST come first
	#	for use in the jruby environment.
	config.gem 'ccls-ccls_engine'

	#	Without this, rake doesn't properly include that app/ paths
	config.gem 'ccls-simply_authorized'
#	config.gem 'ccls-simply_helpful'
	config.gem 'ccls-common_lib'
	config.gem 'jrails'

	#		http://chronic.rubyforge.org/
#	backgroundrb will actually require chronic
#	config.gem "chronic"	#, :version => '= 0.5.0'

#	20120213 - removing feature
#	config.gem 'active_shipping'

	config.gem 'will_paginate'
	config.gem 'fastercsv'

	config.frameworks -= [ :active_resource ]

	# Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
	# Run "rake -D time" for a list of tasks for finding time zone names.
	config.time_zone = 'Pacific Time (US & Canada)'

end
