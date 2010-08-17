# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

#ENV['RAILS_ENV'] ||= 'production'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

#	This constant is used in the ucb_ccls_engine#Document
#	and other places like Amazon buckets
#	for controlling the path to documents.
RAILS_APP_NAME = 'homex'

Rails::Initializer.run do |config|

	# This is set to /homex in environments/production.rb
	config.action_controller.relative_url_root = ''
	
	if RUBY_PLATFORM =~ /java/
		#	For functionality with rvm/jruby
		#	I expected to have to change database.yml for this but didn't
		config.gem 'activerecord-jdbcmysql-adapter',
			:lib => 'active_record/connection_adapters/jdbcmysql_adapter'

		#	Additional jruby specific jars required in the war
		config.gem 'jdbc-sqlite3', :lib => 'jdbc/sqlite3'
		config.gem 'jruby-openssl', :lib => 'openssl'
	else

		# If using mysql ...
		# On Mac OS X:
		#   sudo gem install mysql -- --with-mysql-dir=/usr/local/mysql
		# On Mac OS X Leopard:
		#   sudo env ARCHFLAGS="-arch i386" gem install mysql 
		#			-- --with-mysql-config=/usr/local/mysql/bin/mysql_config
		# ... however, I had to install the mysql gem like so ...
		#   sudo env ARCHFLAGS="-arch x86_64" gem install mysql 
		#			-- --with-mysql-config=/usr/local/mysql/bin/mysql_config

		config.gem 'mysql'
	end


	config.gem 'jakewendt-stringify_date',
		:lib => 'stringify_date',
		:source => 'http://rubygems.org'

	config.gem 'haml'      # Needed for Surveyor
	config.gem "chronic"   #		http://chronic.rubyforge.org/
	config.gem 'active_shipping'
	config.gem 'will_paginate'
	config.gem 'fastercsv'
#	&apos; does not get converted correctly
#	config.gem 'sanitize'

	# config.plugins = [ :exception_notification, :ssl_requirement, :all ]

	config.frameworks -= [ :active_resource ]

	# Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
	# Run "rake -D time" for a list of tasks for finding time zone names.
	config.time_zone = 'UTC'

end
